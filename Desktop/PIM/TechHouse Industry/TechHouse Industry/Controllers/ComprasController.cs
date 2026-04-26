using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;
using TechBuildAPI.Models;

namespace TechBuildAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ComprasController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ComprasController(AppDbContext context)
        {
            _context = context;
        }

        public class FinalizarCompraDto
        {
            public int UsuarioId { get; set; }
            public List<ItemDto> Itens { get; set; } = new();
        }

        public class ItemDto
        {
            public string ProdutoNome { get; set; } = "";
            public string ProdutoTipo { get; set; } = "";
            public decimal Preco { get; set; }
            public int Quantidade { get; set; }
            public string Origem { get; set; } = ""; // 🔥 IMPORTANTE
        }

        [HttpPost("finalizar")]
        public async Task<IActionResult> Finalizar([FromBody] FinalizarCompraDto dto)
        {
            if (dto.UsuarioId <= 0 || dto.Itens == null || dto.Itens.Count == 0)
                return BadRequest(new { mensagem = "Compra inválida." });

            var usuario = await _context.Usuarios.FindAsync(dto.UsuarioId);
            if (usuario == null)
                return BadRequest(new { mensagem = "Usuário não encontrado." });

            var brasil = TimeZoneInfo.FindSystemTimeZoneById("E. South America Standard Time");

            var compra = new Compra
            {
                UsuarioId = dto.UsuarioId,
                DataCompra = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, brasil),
                Status = "Ativa"
            };

            _context.Compras.Add(compra);
            await _context.SaveChangesAsync();

            foreach (var item in dto.Itens)
            {
                // 🔹 ITEM DA COMPRA
                _context.CompraItens.Add(new CompraItem
                {
                    CompraId = compra.Id,
                    ProdutoNome = item.ProdutoNome,
                    ProdutoTipo = item.ProdutoTipo,
                    Preco = item.Preco,
                    Quantidade = item.Quantidade,
                    Origem = item.Origem // 🔥 SALVA
                });

                // 🔹 VENDA (AGORA COM ORIGEM)
                _context.Vendas.Add(new Vendas
                {
                    UsuarioId = dto.UsuarioId,
                    CompraId = compra.Id,
                    ProdutoNome = item.ProdutoNome,
                    ProdutoTipo = item.ProdutoTipo,
                    Preco = item.Preco,
                    Quantidade = item.Quantidade,
                    Origem = item.Origem, // 🔥 ESSENCIAL
                    Status = "Concluida",
                    Data = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, brasil)
                });

                // 🔹 ATUALIZA ESTOQUE
                var produto = await _context.Produtos
                    .FirstOrDefaultAsync(p => p.Nome.ToLower() == item.ProdutoNome.ToLower());

                if (produto != null)
                {
                    produto.Quantidade -= item.Quantidade;
                    if (produto.Quantidade < 0)
                        produto.Quantidade = 0;
                }
            }

            await _context.SaveChangesAsync();

            return Ok(new
            {
                mensagem = "Compra finalizada com sucesso.",
                compraId = compra.Id
            });
        }

        [HttpGet("usuario/{usuarioId}")]
        public async Task<IActionResult> GetComprasDoUsuario(int usuarioId)
        {
            var compras = await _context.Compras
                .Where(c => c.UsuarioId == usuarioId)
                .Include(c => c.Itens)
                .OrderByDescending(c => c.Id)
                .ToListAsync();

            return Ok(compras);
        }

        [HttpPut("cancelar/{id}")]
        public async Task<IActionResult> CancelarCompra(int id)
        {
            var compra = await _context.Compras.FindAsync(id);

            if (compra == null)
                return NotFound(new { mensagem = "Compra não encontrada." });

            compra.Status = "Cancelada";

            var vendas = await _context.Vendas
                .Where(v => v.CompraId == id)
                .ToListAsync();

            foreach (var venda in vendas)
            {
                venda.Status = "Cancelada";
            }

            await _context.SaveChangesAsync();

            return Ok(new { mensagem = "Compra e vendas canceladas com sucesso." });
        }
    }
}