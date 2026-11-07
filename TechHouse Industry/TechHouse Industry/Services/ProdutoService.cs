using TechBuildAPI.Models;
using TechBuildAPI.Repositories;

namespace TechBuildAPI.Services
{
    // =====================================================================
    // CAMADA DE REGRAS DE NEGÓCIO - PRODUTOS
    // Valida os dados antes de gravar (preço, estoque, nome repetido...).
    // Não sabe nada de HTTP nem de SQL: recebe e devolve objetos.
    // =====================================================================
    public class ProdutoService
    {
        private readonly IProdutoRepository _repositorio;

        public ProdutoService(IProdutoRepository repositorio)
        {
            _repositorio = repositorio;
        }

        // Regras de um produto válido
        private static void Validar(Produto p)
        {
            if (string.IsNullOrWhiteSpace(p.Nome))
                throw new RegraDeNegocioException("Informe o nome do produto.");
            if (string.IsNullOrWhiteSpace(p.Tipo))
                throw new RegraDeNegocioException("Informe o tipo do produto.");
            if (p.Preco < 0)
                throw new RegraDeNegocioException("O preço não pode ser negativo.");
            if (p.Quantidade < 0)
                throw new RegraDeNegocioException("A quantidade não pode ser negativa.");
            if (p.ConsumoEnergia < 0)
                throw new RegraDeNegocioException("O consumo não pode ser negativo.");
            if (p.Potencia.HasValue && p.Potencia.Value < 0)
                throw new RegraDeNegocioException("A potência não pode ser negativa.");

            // Imagem enviada pelo site vem em base64 dentro do texto. Limite de ~1 MB:
            // uma foto enorme deixava o catálogo com dezenas de MB e travava a loja.
            if (p.ImagemUrl != null && p.ImagemUrl.Length > 1_500_000)
                throw new RegraDeNegocioException("Imagem muito grande (máximo 1 MB). Use uma foto menor.");
        }

        public Task<List<Produto>> Listar() => _repositorio.Listar();
        public Task<Produto?> Obter(int id) => _repositorio.ObterPorId(id);
        public Task<List<Produto>> ListarPorTipo(string tipo) => _repositorio.ListarPorTipo(tipo);
        public Task<List<Produto>> ListarPorSocket(string socket) => _repositorio.ListarPorSocket(socket);
        public Task<int> ConsumoTotal() => _repositorio.ConsumoTotal();
        public Task<int> VersaoCatalogo() => _repositorio.VersaoCatalogo();

        public async Task<Produto> Criar(Produto produto)
        {
            Validar(produto);
            produto.Nome = produto.Nome.Trim();

            if (await _repositorio.NomeExiste(produto.Nome))
                throw new RegraDeNegocioException("Já existe um produto com esse nome.");

            produto.Id = 0; // o banco gera o Id
            await _repositorio.Adicionar(produto);
            return produto;
        }

        // Retorna false se o produto não existir
        public async Task<bool> Atualizar(int id, Produto dados)
        {
            Validar(dados);

            var existente = await _repositorio.ObterPorId(id);
            if (existente == null)
                return false;

            var nome = dados.Nome.Trim();
            if (await _repositorio.NomeExiste(nome, ignorarId: id))
                throw new RegraDeNegocioException("Já existe outro produto com esse nome.");

            existente.Nome = nome;
            existente.Tipo = dados.Tipo;
            existente.Preco = dados.Preco;
            existente.Socket = dados.Socket;
            existente.ConsumoEnergia = dados.ConsumoEnergia;
            existente.ImagemUrl = dados.ImagemUrl;
            existente.Potencia = dados.Potencia;
            existente.Quantidade = dados.Quantidade;

            await _repositorio.Salvar();
            return true;
        }

        // Retorna false se o produto não existir
        public async Task<bool> Excluir(int id)
        {
            var produto = await _repositorio.ObterPorId(id);
            if (produto == null)
                return false;

            await _repositorio.Remover(produto);
            return true;
        }
    }
}
