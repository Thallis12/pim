using System.Text.Json;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;
using TechBuildAPI.Models;
using TechBuildAPI.Services;

namespace TechBuildAPI.Repositories
{
    // =====================================================================
    // CAMADA DE DADOS - PEDIDOS (compras, vendas, carrinho e relatórios)
    // Chama as STORED PROCEDURES do banco, onde ficam as regras de compra,
    // estoque e status (ver banco_etapa7_procedures_triggers.sql).
    // =====================================================================

    // ---------- Formatos das linhas devolvidas pelas procedures ----------
    public class ResumoDashboard
    {
        public decimal TotalVendido { get; set; }
        public int TotalRegistros { get; set; }
        public int? QtdVendas { get; set; }
        public int? QtdDevolucoes { get; set; }
        public int? QtdCancelamentos { get; set; }
        public int? QtdPerdas { get; set; }
        public int? QtdEmPreparo { get; set; }
        public int? QtdEmTransporte { get; set; }
    }

    public class ProdutoMaisVendido
    {
        public string ProdutoNome { get; set; } = "";
        public int QuantidadeVendida { get; set; }
        public decimal Faturamento { get; set; }
    }

    public class RendaPeriodo
    {
        public string Periodo { get; set; } = "";
        public decimal Renda { get; set; }
        public decimal Perdas { get; set; }
        public DateTime Ordem { get; set; }
    }

    public class ProdutoEstoqueBaixo
    {
        public int Id { get; set; }
        public string? Nome { get; set; }
        public string? Tipo { get; set; }
        public int Quantidade { get; set; }
    }

    public class ItemCarrinhoSalvo
    {
        public int ProdutoId { get; set; }
        public int Quantidade { get; set; }
        public string Origem { get; set; } = "Carrinho";
    }

    public class ItemDoPedido
    {
        public string Nome { get; set; } = "";
        public int Quantidade { get; set; }
        public string Origem { get; set; } = "Carrinho";
    }

    // Linha da lista de vendas (o que o site e o app recebem)
    public class VendaResumo
    {
        public int Id { get; set; }
        public decimal Preco { get; set; }
        public int Quantidade { get; set; }
        public string? Status { get; set; }
        public DateTime Data { get; set; }
        public string ProdutoNome { get; set; } = "";
        public string ProdutoTipo { get; set; } = "";
        public string Origem { get; set; } = "";
        public int UsuarioId { get; set; }
        public string UsuarioNome { get; set; } = "";
        public int CompraId { get; set; }
        public string? MotivoDevolicao { get; set; }
    }

    // ---------- Contrato ----------
    public interface IPedidoRepository
    {
        Task<int> FinalizarCompra(int usuarioId, List<ItemDoPedido> itens);
        Task CancelarCompra(int compraId, int usuarioId, bool isAdmin);
        Task CancelarVenda(int vendaId, int usuarioId, bool isAdmin);
        Task<string> AvancarStatus(int vendaId);
        Task<string> Devolver(int vendaId, int usuarioId, bool isAdmin, string motivo, string? texto);
        Task<List<Compra>> ListarComprasDoUsuario(int usuarioId);
        Task<List<VendaResumo>> ListarVendas(int? somenteDoUsuarioId);
        Task<Vendas> CriarVendaManual(Vendas venda);
        Task<ResumoDashboard?> Resumo();
        Task<List<ProdutoMaisVendido>> MaisVendidos(int top);
        Task<List<RendaPeriodo>> RendaPorPeriodo(string agrupamento);
        Task<List<ProdutoEstoqueBaixo>> EstoqueBaixo();
        Task<List<ItemCarrinhoSalvo>> ObterCarrinho(int usuarioId);
        Task SalvarCarrinho(int usuarioId, List<ItemCarrinhoSalvo> itens);
    }

    public class PedidoRepository : IPedidoRepository
    {
        private readonly AppDbContext _context;

        public PedidoRepository(AppDbContext context)
        {
            _context = context;
        }

        // Executa uma procedure e transforma os erros de regra (THROW 50000+) em RegraDeNegocioException
        private async Task Executar(string sql, params SqlParameter[] parametros)
        {
            try
            {
                await _context.Database.ExecuteSqlRawAsync(sql, parametros);
            }
            catch (SqlException ex) when (ex.Number >= 50000)
            {
                // 50011, 50031, 50051 = usuário tentando mexer no pedido de outra pessoa
                bool semPermissao = ex.Number is 50011 or 50031 or 50051;
                throw new RegraDeNegocioException(ex.Message, semPermissao);
            }
        }

        private static SqlParameter Saida(string nome, System.Data.SqlDbType tipo, int tamanho = 0) =>
            new(nome, tipo, tamanho) { Direction = System.Data.ParameterDirection.Output };

        // ---------- sp_FinalizarCompra ----------
        public async Task<int> FinalizarCompra(int usuarioId, List<ItemDoPedido> itens)
        {
            var json = JsonSerializer.Serialize(itens.Select(i => new
            {
                nome = i.Nome.Trim(),
                quantidade = i.Quantidade,
                origem = i.Origem
            }));

            var compraId = Saida("@CompraId", System.Data.SqlDbType.Int);

            await Executar("EXEC dbo.sp_FinalizarCompra @UsuarioId, @ItensJson, @CompraId OUTPUT",
                new SqlParameter("@UsuarioId", usuarioId),
                new SqlParameter("@ItensJson", json),
                compraId);

            return (int)compraId.Value;
        }

        // ---------- sp_CancelarCompra ----------
        public Task CancelarCompra(int compraId, int usuarioId, bool isAdmin) =>
            Executar("EXEC dbo.sp_CancelarCompra @CompraId, @UsuarioId, @IsAdmin",
                new SqlParameter("@CompraId", compraId),
                new SqlParameter("@UsuarioId", usuarioId),
                new SqlParameter("@IsAdmin", isAdmin));

        // ---------- sp_CancelarVenda ----------
        public Task CancelarVenda(int vendaId, int usuarioId, bool isAdmin) =>
            Executar("EXEC dbo.sp_CancelarVenda @VendaId, @UsuarioId, @IsAdmin",
                new SqlParameter("@VendaId", vendaId),
                new SqlParameter("@UsuarioId", usuarioId),
                new SqlParameter("@IsAdmin", isAdmin));

        // ---------- sp_AvancarStatusVenda ----------
        public async Task<string> AvancarStatus(int vendaId)
        {
            var novoStatus = Saida("@NovoStatus", System.Data.SqlDbType.NVarChar, 50);
            await Executar("EXEC dbo.sp_AvancarStatusVenda @VendaId, @NovoStatus OUTPUT",
                new SqlParameter("@VendaId", vendaId),
                novoStatus);
            return (string)novoStatus.Value;
        }

        // ---------- sp_DevolverVenda ----------
        public async Task<string> Devolver(int vendaId, int usuarioId, bool isAdmin, string motivo, string? texto)
        {
            var novoStatus = Saida("@NovoStatus", System.Data.SqlDbType.NVarChar, 50);
            await Executar(
                "EXEC dbo.sp_DevolverVenda @VendaId, @UsuarioId, @IsAdmin, @Motivo, @MotivoTexto, @NovoStatus OUTPUT",
                new SqlParameter("@VendaId", vendaId),
                new SqlParameter("@UsuarioId", usuarioId),
                new SqlParameter("@IsAdmin", isAdmin),
                new SqlParameter("@Motivo", motivo),
                new SqlParameter("@MotivoTexto", (object?)texto ?? DBNull.Value),
                novoStatus);
            return (string)novoStatus.Value;
        }

        // ---------- Consultas (Entity Framework) ----------
        public Task<List<Compra>> ListarComprasDoUsuario(int usuarioId) =>
            _context.Compras
                .Where(c => c.UsuarioId == usuarioId)
                .Include(c => c.Itens)
                .OrderByDescending(c => c.Id)
                .ToListAsync();

        // somenteDoUsuarioId = null -> todas as vendas (admin)
        public Task<List<VendaResumo>> ListarVendas(int? somenteDoUsuarioId)
        {
            var query = _context.Vendas.AsQueryable();
            if (somenteDoUsuarioId != null)
                query = query.Where(v => v.UsuarioId == somenteDoUsuarioId);

            return query
                .OrderByDescending(v => v.Id)
                .Select(v => new VendaResumo
                {
                    Id = v.Id,
                    Preco = v.Preco,
                    Quantidade = v.Quantidade,
                    Status = v.Status,
                    Data = v.Compra != null ? v.Compra.DataCompra : v.Data,
                    ProdutoNome = v.ProdutoNome,
                    ProdutoTipo = v.ProdutoTipo,
                    Origem = v.Origem,
                    UsuarioId = v.UsuarioId,
                    UsuarioNome = (v.Usuario != null && !string.IsNullOrEmpty(v.Usuario.Nome)) ? v.Usuario.Nome : "Usuário",
                    CompraId = v.CompraId,
                    MotivoDevolicao = v.MotivoDevolicao
                })
                .ToListAsync();
        }

        public async Task<Vendas> CriarVendaManual(Vendas venda)
        {
            _context.Vendas.Add(venda);
            await _context.SaveChangesAsync();
            return venda;
        }

        // ---------- Relatórios (procedures e view) ----------
        public async Task<ResumoDashboard?> Resumo() =>
            (await _context.Database.SqlQueryRaw<ResumoDashboard>("EXEC dbo.sp_DashboardResumo").ToListAsync())
            .FirstOrDefault();

        public Task<List<ProdutoMaisVendido>> MaisVendidos(int top) =>
            _context.Database.SqlQueryRaw<ProdutoMaisVendido>("EXEC dbo.sp_ProdutosMaisVendidos @Top",
                new SqlParameter("@Top", top)).ToListAsync();

        public Task<List<RendaPeriodo>> RendaPorPeriodo(string agrupamento) =>
            _context.Database.SqlQueryRaw<RendaPeriodo>("EXEC dbo.sp_RendaPorPeriodo @Agrupamento",
                new SqlParameter("@Agrupamento", agrupamento)).ToListAsync();

        public Task<List<ProdutoEstoqueBaixo>> EstoqueBaixo() =>
            _context.Database.SqlQueryRaw<ProdutoEstoqueBaixo>(
                "SELECT Id, Nome, Tipo, Quantidade FROM dbo.vw_EstoqueBaixo").ToListAsync();

        // ---------- Carrinho salvo (sp_ObterCarrinho / sp_SalvarCarrinho) ----------
        public Task<List<ItemCarrinhoSalvo>> ObterCarrinho(int usuarioId) =>
            _context.Database.SqlQueryRaw<ItemCarrinhoSalvo>("EXEC dbo.sp_ObterCarrinho @UsuarioId",
                new SqlParameter("@UsuarioId", usuarioId)).ToListAsync();

        public Task SalvarCarrinho(int usuarioId, List<ItemCarrinhoSalvo> itens)
        {
            var json = JsonSerializer.Serialize(itens.Select(i => new
            {
                produtoId = i.ProdutoId,
                quantidade = i.Quantidade,
                origem = i.Origem
            }));

            return Executar("EXEC dbo.sp_SalvarCarrinho @UsuarioId, @ItensJson",
                new SqlParameter("@UsuarioId", usuarioId),
                new SqlParameter("@ItensJson", json));
        }
    }
}
