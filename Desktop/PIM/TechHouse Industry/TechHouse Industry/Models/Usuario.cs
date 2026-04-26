namespace TechBuildAPI.Models
{
    public class Usuario
    {
        public int Id { get; set; }

        public string Email { get; set; } = "";
        public string Senha { get; set; } = "";

        public bool IsAdmin { get; set; }

        public string? Nome { get; set; }
    }
}