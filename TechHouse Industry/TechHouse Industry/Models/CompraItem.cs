using System.Text.Json.Serialization;

namespace TechBuildAPI.Models
{
    public class CompraItem
    {
        public int Id { get; set; }
        public int CompraId { get; set; }

        public string ProdutoNome { get; set; } = "";
        public string ProdutoTipo { get; set; } = "";
        public decimal Preco { get; set; }
        public int Quantidade { get; set; }
        public string Origem { get; set; } = "";

        [JsonIgnore]
        public Compra? Compra { get; set; }
    }
}