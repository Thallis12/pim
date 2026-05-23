using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Models;

namespace TechBuildAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Produto> Produtos { get; set; }
        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<Compra> Compras { get; set; }
        public DbSet<CompraItem> CompraItens { get; set; }
        public DbSet<Vendas> Vendas { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // 🔥 Produto
            modelBuilder.Entity<Produto>()
                .Property(p => p.Preco)
                .HasPrecision(10, 2);

            // 🔥 CompraItem
            modelBuilder.Entity<CompraItem>()
                .Property(p => p.Preco)
                .HasPrecision(10, 2);

            
            modelBuilder.Entity<Vendas>()
                .Property(v => v.Preco)
                .HasPrecision(10, 2);
        }
    }
}