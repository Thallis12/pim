using TechBuildAPI.Models;

public class Vendas
{
    public int Id { get; set; }

    public int UsuarioId { get; set; } // ✔ só uma vez

    public Usuario Usuario { get; set; } // ✔ navegação

    public string ProdutoNome { get; set; } = "";
    public string ProdutoTipo { get; set; } = "";

    public decimal Preco { get; set; }
    public int Quantidade { get; set; }

    public int CompraId { get; set; }
    public string Status { get; set; } = "Concluida";
    public DateTime Data { get; set; } = DateTime.Now;

    public Compra Compra { get; set; }

    public string Origem { get; set; } = "";
}