using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;
using TechBuildAPI.Models;

namespace TechBuildAPI.Repositories
{
    // =====================================================================
    // CAMADA DE DADOS - USUÁRIOS
    // Só esta classe conversa com a tabela Usuarios.
    // =====================================================================
    public interface IUsuarioRepository
    {
        Task<Usuario?> ObterPorEmail(string email);
        Task<Usuario?> ObterPorId(int id);
        Task<bool> EmailExiste(string email);
        Task Adicionar(Usuario usuario);
    }

    public class UsuarioRepository : IUsuarioRepository
    {
        private readonly AppDbContext _context;

        public UsuarioRepository(AppDbContext context)
        {
            _context = context;
        }

        public Task<Usuario?> ObterPorEmail(string email) =>
            _context.Usuarios.FirstOrDefaultAsync(u => u.Email == email);

        public async Task<Usuario?> ObterPorId(int id) => await _context.Usuarios.FindAsync(id);

        public Task<bool> EmailExiste(string email) =>
            _context.Usuarios.AnyAsync(u => u.Email == email);

        public async Task Adicionar(Usuario usuario)
        {
            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();
        }
    }
}
