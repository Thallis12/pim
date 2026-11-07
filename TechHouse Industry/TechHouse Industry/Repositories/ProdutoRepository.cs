using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;
using TechBuildAPI.Models;

namespace TechBuildAPI.Repositories
{
    // =====================================================================
    // CAMADA DE DADOS - PRODUTOS
    // Só esta classe conversa com a tabela Produtos.
    // A interface (contrato) diz O QUE a classe faz; a classe diz COMO.
    // Assim o Service depende do contrato e não do banco (baixo acoplamento).
    // =====================================================================
    public interface IProdutoRepository
    {
        Task<List<Produto>> Listar();
        Task<Produto?> ObterPorId(int id);
        Task<List<Produto>> ListarPorTipo(string tipo);
        Task<List<Produto>> ListarPorSocket(string socket);
        Task<bool> NomeExiste(string nome, int? ignorarId = null);
        Task Adicionar(Produto produto);
        Task Salvar();
        Task Remover(Produto produto);
        Task<int> ConsumoTotal();
        Task<int> VersaoCatalogo();
    }

    public class ProdutoRepository : IProdutoRepository
    {
        private readonly AppDbContext _context;

        public ProdutoRepository(AppDbContext context)
        {
            _context = context;
        }

        public Task<List<Produto>> Listar() => _context.Produtos.ToListAsync();

        public async Task<Produto?> ObterPorId(int id) => await _context.Produtos.FindAsync(id);

        public Task<List<Produto>> ListarPorTipo(string tipo) =>
            _context.Produtos.Where(p => p.Tipo == tipo).ToListAsync();

        public Task<List<Produto>> ListarPorSocket(string socket) =>
            _context.Produtos.Where(p => p.Socket == socket).ToListAsync();

        public Task<bool> NomeExiste(string nome, int? ignorarId = null) =>
            _context.Produtos.AnyAsync(p => p.Nome == nome && (ignorarId == null || p.Id != ignorarId));

        public async Task Adicionar(Produto produto)
        {
            _context.Produtos.Add(produto);
            await _context.SaveChangesAsync();
        }

        public Task Salvar() => _context.SaveChangesAsync();

        public async Task Remover(Produto produto)
        {
            _context.Produtos.Remove(produto);
            await _context.SaveChangesAsync();
        }

        public Task<int> ConsumoTotal() => _context.Produtos.SumAsync(p => p.ConsumoEnergia);

        // procedure dbo.sp_VersaoCatalogo (usada na atualização em tempo real)
        public async Task<int> VersaoCatalogo() =>
            (await _context.Database.SqlQueryRaw<VersaoCatalogo>("EXEC dbo.sp_VersaoCatalogo").ToListAsync())
            .Select(v => v.Versao).FirstOrDefault();
    }

    public class VersaoCatalogo
    {
        public int Versao { get; set; }
    }
}
