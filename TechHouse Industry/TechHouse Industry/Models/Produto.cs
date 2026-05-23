namespace TechBuildAPI.Models
{
    public class Produto
    {
        public int Id { get; set; }

        public string Nome { get; set; } = "";
        public string Tipo { get; set; } = "";
        public decimal Preco { get; set; }

        public string? Socket { get; set; }
        public int ConsumoEnergia { get; set; }

        public string? ImagemUrl { get; set; }

        public int? Potencia { get; set; }

        public int Quantidade { get; set; }
    }
}