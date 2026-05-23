using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;
using TechBuildAPI.Models;

namespace TechBuildAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProdutosController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ProdutosController(AppDbContext context)
        {
            _context = context;
        }

        // =========================
        // GET ALL
        // =========================
        [HttpGet]
        public async Task<ActionResult<List<Produto>>> Get()
        {
            return await _context.Produtos.ToListAsync();
        }

        // =========================
        // GET BY ID
        // =========================
        [HttpGet("{id}")]
        public async Task<ActionResult<Produto>> GetById(int id)
        {
            var produto = await _context.Produtos.FindAsync(id);

            if (produto == null)
                return NotFound();

            return Ok(produto);
        }

        // =========================
        // GET BY TIPO
        // =========================
        [HttpGet("tipo/{tipo}")]
        public async Task<ActionResult<List<Produto>>> GetByTipo(string tipo)
        {
            var produtos = await _context.Produtos
                .Where(p => p.Tipo == tipo)
                .ToListAsync();

            return Ok(produtos);
        }

        // =========================
        // GET BY SOCKET
        // =========================
        [HttpGet("socket/{socket}")]
        public async Task<ActionResult<List<Produto>>> GetBySocket(string socket)
        {
            var produtos = await _context.Produtos
                .Where(p => p.Socket == socket)
                .ToListAsync();

            return Ok(produtos);
        }

        // =========================
        // POST (CRIAR)
        // =========================
        [HttpPost]
        public async Task<ActionResult<Produto>> Post(Produto produto)
        {
            _context.Produtos.Add(produto);
            await _context.SaveChangesAsync();

            return Ok(produto);
        }

        // =========================
        // PUT (EDITAR)
        // =========================
        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, Produto produto)
        {
            if (id != produto.Id)
                return BadRequest("ID inválido");

            _context.Entry(produto).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // =========================
        // DELETE
        // =========================
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var produto = await _context.Produtos.FindAsync(id);

            if (produto == null)
                return NotFound();

            _context.Produtos.Remove(produto);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // =========================
        // REGRA DE NEGÓCIO (DIFERENCIAL PIM)
        // =========================
        [HttpGet("consumo-total")]
        public async Task<ActionResult<int>> GetConsumoTotal()
        {
            var total = await _context.Produtos.SumAsync(p => p.ConsumoEnergia);
            return Ok(total);
        }
    }
}