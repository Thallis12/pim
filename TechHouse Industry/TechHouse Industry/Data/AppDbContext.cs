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

            // As tabelas Produtos e Vendas têm TRIGGERS no banco.
            // O Entity Framework precisa saber disso: sem este aviso ele grava
            // usando "OUTPUT", que o SQL Server não aceita em tabelas com trigger
            // (era isso que dava erro 500 ao editar/criar produto).
            modelBuilder.Entity<Produto>()
                .ToTable(t => t.HasTrigger("trg_Produtos_Auditoria"));

            modelBuilder.Entity<Vendas>()
                .ToTable(t =>
                {
                    t.HasTrigger("trg_Vendas_ValidarStatus");
                    t.HasTrigger("trg_Vendas_AtualizarStatusCompra");
                });
        }
    }
}