using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Repositories;
using TechBuildAPI.Services;

namespace TechBuildAPI.Controllers
{
    // CAMADA DE APRESENTAÇÃO (API) - COMPRAS
    // Controller -> PedidoService -> PedidoRepository -> procedures do banco
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ComprasController : ControllerBase
    {
        private readonly PedidoService _pedidos;

        public ComprasController(PedidoService pedidos)
        {
            _pedidos = pedidos;
        }

        public class FinalizarCompraDto
        {
            // Mantido só por compatibilidade com o front antigo; é IGNORADO.
            // O usuário da compra vem sempre do token JWT.
            public int UsuarioId { get; set; }
            public List<ItemDto> Itens { get; set; } = new();
        }

        public class ItemDto
        {
            public string ProdutoNome { get; set; } = "";
            // Preço e tipo enviados pelo app são ignorados: o banco usa os valores dele.
            public string ProdutoTipo { get; set; } = "";
            public decimal Preco { get; set; }
            public int Quantidade { get; set; }
            public string Origem { get; set; } = "";
        }

        // POST api/Compras/finalizar -> procedure dbo.sp_FinalizarCompra
        [HttpPost("finalizar")]
        public async Task<IActionResult> Finalizar([FromBody] FinalizarCompraDto dto)
        {
            var itens = (dto.Itens ?? new()).Select(i => new ItemDoPedido
            {
                Nome = i.ProdutoNome ?? "",
                Quantidade = i.Quantidade,
                Origem = i.Origem
            }).ToList();

            try
            {
                var compraId = await _pedidos.FinalizarCompra(User.ObterUsuarioId(), itens);
                return Ok(new { mensagem = "Compra finalizada com sucesso.", compraId });
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        // GET api/Compras/usuario/5 - compras com os itens
        [HttpGet("usuario/{usuarioId:int}")]
        public async Task<IActionResult> GetComprasDoUsuario(int usuarioId)
        {
            // Cliente só vê as próprias compras; admin vê de qualquer usuário
            if (usuarioId != User.ObterUsuarioId() && !User.EhAdmin())
                return Forbid();

            return Ok(await _pedidos.ComprasDoUsuario(usuarioId));
        }

        // PUT api/Compras/cancelar/5 -> procedure dbo.sp_CancelarCompra
        [HttpPut("cancelar/{id:int}")]
        public async Task<IActionResult> CancelarCompra(int id)
        {
            try
            {
                await _pedidos.CancelarCompra(id, User.ObterUsuarioId(), User.EhAdmin());
                return Ok(new { mensagem = "Compra cancelada com sucesso." });
            }
            catch (RegraDeNegocioException ex)
            {
                if (ex.SemPermissao) return Forbid();
                return BadRequest(new { mensagem = ex.Message });
            }
        }
    }
}
