using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Repositories;
using TechBuildAPI.Services;

namespace TechBuildAPI.Controllers
{
    // CARRINHO SALVO NO BANCO (tabela CarrinhoItens)
    // O mesmo carrinho aparece no site e no app quando a pessoa entra na mesma conta.
    //   GET api/Carrinho  -> devolve o carrinho do usuário logado
    //   PUT api/Carrinho  -> substitui o carrinho salvo pelo que foi enviado
    // O usuário vem sempre do token JWT (ninguém mexe no carrinho de outra pessoa).
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class CarrinhoController : ControllerBase
    {
        private readonly PedidoService _pedidos;

        public CarrinhoController(PedidoService pedidos)
        {
            _pedidos = pedidos;
        }

        public class SalvarCarrinhoDto
        {
            public List<ItemCarrinhoSalvo> Itens { get; set; } = new();
        }

        [HttpGet]
        public async Task<IActionResult> Get() => Ok(await _pedidos.Carrinho(User.ObterUsuarioId()));

        [HttpPut]
        public async Task<IActionResult> Salvar([FromBody] SalvarCarrinhoDto dto)
        {
            try
            {
                return Ok(await _pedidos.SalvarCarrinho(User.ObterUsuarioId(), dto.Itens));
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }
    }
}
