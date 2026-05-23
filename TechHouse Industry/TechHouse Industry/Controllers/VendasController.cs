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

        // 🔥 GET - LISTAR VENDAS
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

                    // 🔥 DATA CORRETA
                    Data = v.Compra != null ? v.Compra.DataCompra : v.Data,

                    v.ProdutoNome,
                    v.ProdutoTipo,

                    // 🔥 ESSENCIAL PRA SEPARAR NO FRONT
                    v.Origem,

                    UsuarioNome = (v.Usuario != null && !string.IsNullOrEmpty(v.Usuario.Nome))
                        ? v.Usuario.Nome
                        : "Usuário",

                    v.CompraId
                })
                .ToListAsync();

            return Ok(vendas);
        }

        // 🔥 POST - CRIAR VENDA
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
            venda.Status = string.IsNullOrEmpty(venda.Status) ? "Concluida" : venda.Status;

            // 🔥 GARANTE QUE NÃO VAI NULL
            // 🔥 GARANTE QUE NÃO VAI NULL
            if (string.IsNullOrEmpty(venda.Origem))
                venda.Origem = "Carrinho";

            _context.Vendas.Add(venda);
            await _context.SaveChangesAsync();

            return Ok(venda);
        }

        // 🔥 PUT - CANCELAR VENDA
        [HttpPut("cancelar/{id}")]
        public async Task<IActionResult> Cancelar(int id)
        {
            var venda = await _context.Vendas.FindAsync(id);

            if (venda == null)
                return NotFound("Venda não encontrada.");

            venda.Status = "Cancelada";
            await _context.SaveChangesAsync();

            return Ok(new { mensagem = "Venda cancelada com sucesso." });
        }
    }
}