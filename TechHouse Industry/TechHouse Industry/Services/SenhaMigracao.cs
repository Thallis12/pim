using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;

namespace TechBuildAPI.Services
{
    public static class SenhaMigracao
    {
        // Formato de um hash BCrypt: $2a$10$ + 53 caracteres
        private static readonly Regex FormatoBcrypt = new Regex(@"^\$2[aby]\$\d{2}\$.{53}$");

        public static async Task HashearSenhasAntigasAsync(IServiceProvider services)
        {
            using var scope = services.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

            var usuarios = await db.Usuarios.ToListAsync();
            var alterou = false;

            foreach (var usuario in usuarios)
            {
                if (!string.IsNullOrEmpty(usuario.Senha) && !FormatoBcrypt.IsMatch(usuario.Senha))
                {
                    usuario.Senha = BCrypt.Net.BCrypt.HashPassword(usuario.Senha);
                    alterou = true;
                }
            }

            if (alterou)
            {
                await db.SaveChangesAsync();
            }
        }
    }
}
