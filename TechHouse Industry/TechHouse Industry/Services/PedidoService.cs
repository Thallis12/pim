using TechBuildAPI.Models;
using TechBuildAPI.Repositories;

namespace TechBuildAPI.Services
{
    // =====================================================================
    // CAMADA DE REGRAS DE NEGÓCIO - PEDIDOS, CARRINHO E RELATÓRIOS
    // Faz as validações simples (lista vazia, quantidade, motivo...) e chama
    // o repositório. As regras pesadas (estoque, status, transação) ficam
    // nas stored procedures do banco, chamadas pelo PedidoRepository.
    // =====================================================================
    public class PedidoService
    {
        private readonly IPedidoRepository _repositorio;

        public PedidoService(IPedidoRepository repositorio)
        {
            _repositorio = repositorio;
        }

        private static string OrigemValida(string? origem) =>
            string.Equals(origem, "MontePC", StringComparison.OrdinalIgnoreCase) ? "MontePC" : "Carrinho";

        // ---------- Compras ----------
        public Task<int> FinalizarCompra(int usuarioId, List<ItemDoPedido> itens)
        {
            if (usuarioId <= 0 || itens == null || itens.Count == 0)
                throw new RegraDeNegocioException("Compra inválida.");

            if (itens.Any(i => string.IsNullOrWhiteSpace(i.Nome) || i.Quantidade <= 0 || i.Quantidade > 1000))
                throw new RegraDeNegocioException("Há item com nome ou quantidade inválidos.");

            foreach (var i in itens) i.Origem = OrigemValida(i.Origem);
            return _repositorio.FinalizarCompra(usuarioId, itens);
        }

        public Task<List<Compra>> ComprasDoUsuario(int usuarioId) => _repositorio.ListarComprasDoUsuario(usuarioId);

        public Task CancelarCompra(int compraId, int usuarioId, bool isAdmin) =>
            _repositorio.CancelarCompra(compraId, usuarioId, isAdmin);

        // ---------- Vendas (itens) ----------
        // Admin vê todas as vendas; cliente vê só as dele
        public Task<List<VendaResumo>> ListarVendas(int usuarioId, bool isAdmin) =>
            _repositorio.ListarVendas(isAdmin ? null : usuarioId);

        public Task<Vendas> CriarVendaManual(Vendas venda)
        {
            if (venda == null || venda.UsuarioId == 0)
                throw new RegraDeNegocioException("Usuário inválido.");
            if (string.IsNullOrWhiteSpace(venda.ProdutoNome))
                throw new RegraDeNegocioException("Produto inválido.");
            if (venda.Quantidade <= 0 || venda.Preco < 0)
                throw new RegraDeNegocioException("Quantidade ou preço inválidos.");

            venda.Id = 0;
            venda.Data = FusoHorario.Agora();
            venda.Status = "Em Preparo";
            venda.Origem = OrigemValida(venda.Origem);
            return _repositorio.CriarVendaManual(venda);
        }

        public Task<string> AvancarStatus(int vendaId) => _repositorio.AvancarStatus(vendaId);

        public Task CancelarVenda(int vendaId, int usuarioId, bool isAdmin) =>
            _repositorio.CancelarVenda(vendaId, usuarioId, isAdmin);

        public Task<string> Devolver(int vendaId, int usuarioId, bool isAdmin, string motivo, string? texto)
        {
            texto = texto?.Trim();
            if (texto != null && texto.Length > 200)
                texto = texto.Substring(0, 200);

            return _repositorio.Devolver(vendaId, usuarioId, isAdmin, motivo ?? "", texto);
        }

        // ---------- Carrinho salvo ----------
        public Task<List<ItemCarrinhoSalvo>> Carrinho(int usuarioId) => _repositorio.ObterCarrinho(usuarioId);

        public async Task<List<ItemCarrinhoSalvo>> SalvarCarrinho(int usuarioId, List<ItemCarrinhoSalvo> itens)
        {
            itens ??= new();
            if (itens.Count > 200)
                throw new RegraDeNegocioException("Carrinho com itens demais.");

            foreach (var i in itens) i.Origem = OrigemValida(i.Origem);
            await _repositorio.SalvarCarrinho(usuarioId, itens);
            return await _repositorio.ObterCarrinho(usuarioId); // devolve como ficou (limitado ao estoque)
        }

        // ---------- Dashboard ----------
        public Task<ResumoDashboard?> Resumo() => _repositorio.Resumo();
        public Task<List<ProdutoMaisVendido>> MaisVendidos(int top) => _repositorio.MaisVendidos(Math.Clamp(top, 1, 50));
        public Task<List<ProdutoEstoqueBaixo>> EstoqueBaixo() => _repositorio.EstoqueBaixo();

        public Task<List<RendaPeriodo>> RendaPorPeriodo(string por)
        {
            if (por != "dia" && por != "mes" && por != "ano")
                throw new RegraDeNegocioException("Use por=dia, por=mes ou por=ano.");
            return _repositorio.RendaPorPeriodo(por);
        }
    }
}
