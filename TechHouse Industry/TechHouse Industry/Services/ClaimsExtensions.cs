using System.Security.Claims;

namespace TechBuildAPI.Services
{
    public static class ClaimsExtensions
    {
        // Id do usuário que está dentro do token JWT (claim "sub"). Retorna 0 se não houver.
        public static int ObterUsuarioId(this ClaimsPrincipal user)
        {
            var valor = user.FindFirst("sub")?.Value;
            return int.TryParse(valor, out var id) ? id : 0;
        }

        public static bool EhAdmin(this ClaimsPrincipal user) => user.IsInRole("Admin");
    }
}
