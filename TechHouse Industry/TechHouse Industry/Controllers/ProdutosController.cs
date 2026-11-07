using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Models;
using TechBuildAPI.Services;

namespace TechBuildAPI.Controllers
{
    // =====================================================================
    // CAMADA DE APRESENTAÇÃO (API) - PRODUTOS
    // O Controller só recebe o pedido HTTP, chama o Service e devolve a
    // resposta. Regras ficam no ProdutoService; banco no ProdutoRepository.
    // =====================================================================
    [ApiController]
    [Route("api/[controller]")]
    public class ProdutosController : ControllerBase
    {
        private readonly ProdutoService _produtos;

        public ProdutosController(ProdutoService produtos)
        {
            _produtos = produtos;
        }

        // GET api/Produtos - catálogo público
        [AllowAnonymous]
        [HttpGet]
        public async Task<ActionResult<List<Produto>>> Get() => await _produtos.Listar();

        // GET api/Produtos/versao - número que muda quando algum produto muda (tempo real)
        [AllowAnonymous]
        [HttpGet("versao")]
        public async Task<IActionResult> GetVersao() => Ok(new { versao = await _produtos.VersaoCatalogo() });

        [AllowAnonymous]
        [HttpGet("{id:int}")]
        public async Task<ActionResult<Produto>> GetById(int id)
        {
            var produto = await _produtos.Obter(id);
            return produto == null ? NotFound() : Ok(produto);
        }

        [AllowAnonymous]
        [HttpGet("tipo/{tipo}")]
        public async Task<ActionResult<List<Produto>>> GetByTipo(string tipo) => Ok(await _produtos.ListarPorTipo(tipo));

        [AllowAnonymous]
        [HttpGet("socket/{socket}")]
        public async Task<ActionResult<List<Produto>>> GetBySocket(string socket) => Ok(await _produtos.ListarPorSocket(socket));

        // POST - criar (somente admin)
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<Produto>> Post(Produto produto)
        {
            try
            {
                return Ok(await _produtos.Criar(produto));
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        // PUT - editar (somente admin)
        [Authorize(Roles = "Admin")]
        [HttpPut("{id:int}")]
        public async Task<IActionResult> Put(int id, Produto produto)
        {
            if (id != produto.Id)
                return BadRequest(new { mensagem = "ID inválido." });

            try
            {
                return await _produtos.Atualizar(id, produto) ? NoContent() : NotFound();
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        // DELETE - excluir (somente admin)
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id) =>
            await _produtos.Excluir(id) ? NoContent() : NotFound();

        // Regra de negócio extra: consumo total de energia do catálogo
        [AllowAnonymous]
        [HttpGet("consumo-total")]
        public async Task<ActionResult<int>> GetConsumoTotal() => Ok(await _produtos.ConsumoTotal());
    }
}
