using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Data;
using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Models;

namespace TechBuildAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VendasController : ControllerBase
    {
        private readonly AppDbContext _context;

        public VendasController(AppDbContext context)
        {
            _context = context;
        }

        // DTO para devolução
        public class DevolverDto
        {
            public string Motivo { get; set; } = ""; // "Defeito" | "Desistencia" | "Outro"
            public string? MotivoTexto { get; set; }  // preenchido quando Motivo == "Outro"
        }

        // GET - LISTAR VENDAS
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var vendas = await _context.Vendas
                .Include(v => v.Usuario)
                .Include(v => v.Compra)
                .OrderByDescending(v => v.Id)
                .Select(v => new
                {
                    v.Id,
                    v.Preco,
                    v.Quantidade,
                    v.Status,
                    Data = v.Compra != null ? v.Compra.DataCompra : v.Data,
                    v.ProdutoNome,
                    v.ProdutoTipo,
                    v.Origem,
                    UsuarioNome = (v.Usuario != null && !string.IsNullOrEmpty(v.Usuario.Nome))
                        ? v.Usuario.Nome
                        : "Usuário",
                    v.CompraId,
                    v.MotivoDevolicao
                })
                .ToListAsync();

            return Ok(vendas);
        }

        // POST - CRIAR VENDA
        [HttpPost]
        public async Task<IActionResult> Criar([FromBody] Vendas venda)
        {
            if (venda == null)
                return BadRequest("Dados inválidos.");

            if (venda.UsuarioId == 0)
                return BadRequest("Usuário inválido.");

            if (string.IsNullOrWhiteSpace(venda.ProdutoNome))
                return BadRequest("Produto inválido.");

            var brasil = TimeZoneInfo.FindSystemTimeZoneById("E. South America Standard Time");
            venda.Data = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, brasil);
            venda.Status = "Em Preparo";

            if (string.IsNullOrEmpty(venda.Origem))
                venda.Origem = "Carrinho";

            _context.Vendas.Add(venda);
            await _context.SaveChangesAsync();

            return Ok(venda);
        }

        // PUT - AVANÇAR STATUS (apenas admin)
        // Sequência: Em Preparo → Em Transporte → Entregue
        [HttpPut("avancar-status/{id}")]
        public async Task<IActionResult> AvancarStatus(int id)
        {
            var venda = await _context.Vendas.FindAsync(id);
            if (venda == null)
                return NotFound("Venda não encontrada.");

            venda.Status = venda.Status switch
            {
                "Em Preparo" => "Em Transporte",
                "Em Transporte" => "Entregue",
                _ => venda.Status
            };

            await _context.SaveChangesAsync();
            return Ok(new { mensagem = "Status atualizado.", status = venda.Status });
        }

        // PUT - CANCELAR VENDA (cliente — só até "Em Preparo")
        [HttpPut("cancelar/{id}")]
        public async Task<IActionResult> Cancelar(int id)
        {
            var venda = await _context.Vendas.FindAsync(id);
            if (venda == null)
                return NotFound("Venda não encontrada.");

            if (venda.Status != "Em Preparo")
                return BadRequest(new { mensagem = "Não é possível cancelar: pedido já foi enviado." });

            venda.Status = "Cancelada";

            // Devolve ao estoque
            var produto = await _context.Produtos
                .FirstOrDefaultAsync(p => p.Nome.ToLower() == venda.ProdutoNome.ToLower());
            if (produto != null)
                produto.Quantidade += venda.Quantidade;

            await _context.SaveChangesAsync();
            return Ok(new { mensagem = "Venda cancelada com sucesso." });
        }

        // PUT - DEVOLVER (cliente — só quando status == "Entregue")
        [HttpPut("devolver/{id}")]
        public async Task<IActionResult> Devolver(int id, [FromBody] DevolverDto dto)
        {
            var venda = await _context.Vendas.FindAsync(id);
            if (venda == null)
                return NotFound("Venda não encontrada.");

            if (venda.Status != "Entregue")
                return BadRequest(new { mensagem = "Só é possível devolver um pedido já entregue." });

            // "Defeito" → vira "Perda" (não volta ao estoque)
            // outros    → vira "Devolvida" (volta ao estoque)
            if (dto.Motivo == "Defeito")
            {
                venda.Status = "Perda";
                venda.MotivoDevolicao = "Defeito";
            }
            else
            {
                venda.Status = "Devolvida";
                venda.MotivoDevolicao = dto.Motivo == "Outro" && !string.IsNullOrWhiteSpace(dto.MotivoTexto)
                    ? $"Outro: {dto.MotivoTexto}"
                    : dto.Motivo; // "Desistencia"

                // Volta ao estoque
                var produto = await _context.Produtos
                    .FirstOrDefaultAsync(p => p.Nome.ToLower() == venda.ProdutoNome.ToLower());
                if (produto != null)
                    produto.Quantidade += venda.Quantidade;
            }

            await _context.SaveChangesAsync();
            return Ok(new { mensagem = "Devolução registrada.", status = venda.Status });
        }
    }
}