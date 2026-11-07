using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Services;

namespace TechBuildAPI.Controllers
{
    // CAMADA DE APRESENTAÇÃO (API) - VENDAS (cada item de uma compra)
    // Controller -> PedidoService -> PedidoRepository -> procedures do banco
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class VendasController : ControllerBase
    {
        private readonly PedidoService _pedidos;

        public VendasController(PedidoService pedidos)
        {
            _pedidos = pedidos;
        }

        public class DevolverDto
        {
            public string Motivo { get; set; } = "";  // "Defeito" | "Desistencia" | "Outro"
            public string? MotivoTexto { get; set; }  // preenchido quando Motivo == "Outro"
        }

        // GET - admin enxerga todas; cliente enxerga apenas as próprias
        [HttpGet]
        public async Task<IActionResult> Get() =>
            Ok(await _pedidos.ListarVendas(User.ObterUsuarioId(), User.EhAdmin()));

        // POST - criar venda manual (apenas admin; o fluxo normal usa /api/Compras/finalizar)
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Criar([FromBody] Vendas venda)
        {
            try
            {
                return Ok(await _pedidos.CriarVendaManual(venda));
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        // PUT - avançar status (admin) -> procedure dbo.sp_AvancarStatusVenda
        [Authorize(Roles = "Admin")]
        [HttpPut("avancar-status/{id:int}")]
        public async Task<IActionResult> AvancarStatus(int id)
        {
            try
            {
                var status = await _pedidos.AvancarStatus(id);
                return Ok(new { mensagem = "Status atualizado.", status });
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        // PUT - cancelar item -> procedure dbo.sp_CancelarVenda
        [HttpPut("cancelar/{id:int}")]
        public async Task<IActionResult> Cancelar(int id)
        {
            try
            {
                await _pedidos.CancelarVenda(id, User.ObterUsuarioId(), User.EhAdmin());
                return Ok(new { mensagem = "Venda cancelada com sucesso." });
            }
            catch (RegraDeNegocioException ex)
            {
                if (ex.SemPermissao) return Forbid();
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        // PUT - devolver item entregue -> procedure dbo.sp_DevolverVenda
        [HttpPut("devolver/{id:int}")]
        public async Task<IActionResult> Devolver(int id, [FromBody] DevolverDto dto)
        {
            try
            {
                var status = await _pedidos.Devolver(id, User.ObterUsuarioId(), User.EhAdmin(), dto.Motivo, dto.MotivoTexto);
                return Ok(new { mensagem = "Devolução registrada.", status });
            }
            catch (RegraDeNegocioException ex)
            {
                if (ex.SemPermissao) return Forbid();
                return BadRequest(new { mensagem = ex.Message });
            }
        }
    }
}
