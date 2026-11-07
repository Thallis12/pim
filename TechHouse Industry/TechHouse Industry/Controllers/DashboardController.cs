using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Services;

namespace TechBuildAPI.Controllers
{
    // Relatórios do administrador. Os números são calculados no BANCO
    // (sp_DashboardResumo, sp_ProdutosMaisVendidos, sp_RendaPorPeriodo e vw_EstoqueBaixo).
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class DashboardController : ControllerBase
    {
        private readonly PedidoService _pedidos;

        public DashboardController(PedidoService pedidos)
        {
            _pedidos = pedidos;
        }

        [HttpGet("resumo")]
        public async Task<IActionResult> Resumo() => Ok(await _pedidos.Resumo());

        [HttpGet("mais-vendidos")]
        public async Task<IActionResult> MaisVendidos([FromQuery] int top = 5) => Ok(await _pedidos.MaisVendidos(top));

        // GET api/Dashboard/renda?por=dia | mes | ano
        [HttpGet("renda")]
        public async Task<IActionResult> Renda([FromQuery] string por = "dia")
        {
            try
            {
                return Ok(await _pedidos.RendaPorPeriodo(por));
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        [HttpGet("estoque-baixo")]
        public async Task<IActionResult> EstoqueBaixo() => Ok(await _pedidos.EstoqueBaixo());
    }
}
