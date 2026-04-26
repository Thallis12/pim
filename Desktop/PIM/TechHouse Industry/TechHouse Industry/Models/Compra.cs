using System.Text.Json.Serialization;

namespace TechBuildAPI.Models
{
    public class Compra
    {
        public int Id { get; set; }
        public int UsuarioId { get; set; }
        public DateTime DataCompra { get; set; }
        public string Status { get; set; } = "Ativa";

        [JsonIgnore]
        public Usuario? Usuario { get; set; }

        public List<CompraItem> Itens { get; set; } = new();
    }
}