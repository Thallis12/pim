using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
using TechBuildAPI.Data;
using TechBuildAPI.Models;

namespace TechBuildAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuariosController : ControllerBase
    {
        private readonly AppDbContext _context;

        public UsuariosController(AppDbContext context)
        {
            _context = context;
        }

        public class CriarContaDto
        {
            public string Email { get; set; } = "";
            public string Senha { get; set; } = "";
            public string ConfirmarSenha { get; set; } = "";
        }

        public class LoginDto
        {
            public string Email { get; set; } = "";
            public string Senha { get; set; } = "";
        }

        public class CriarAdminDto
        {
            public int AdminId { get; set; }
            public string Email { get; set; } = "";
            public string Senha { get; set; } = "";
            public string ConfirmarSenha { get; set; } = "";
        }

        [HttpPost("criar-conta")]
        public async Task<IActionResult> CriarConta([FromBody] CriarContaDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Email) ||
                string.IsNullOrWhiteSpace(dto.Senha) ||
                string.IsNullOrWhiteSpace(dto.ConfirmarSenha))
            {
                return BadRequest(new { mensagem = "Preencha todos os campos." });
            }

            if (!dto.Email.EndsWith("@gmail.com", StringComparison.OrdinalIgnoreCase) &&
                !dto.Email.EndsWith("@hotmail.com", StringComparison.OrdinalIgnoreCase))
            {
                return BadRequest(new { mensagem = "Email inválido. Use apenas @gmail.com ou @hotmail.com." });
            }

            if (dto.Senha.Length < 5)
            {
                return BadRequest(new { mensagem = "A senha deve ter no mínimo 5 caracteres." });
            }

            if (!Regex.IsMatch(dto.Senha, @"^[A-Za-z0-9!@#$%^&*()_\-+=\[\]{};:,.?/\\|]+$"))
            {
                return BadRequest(new { mensagem = "A senha só pode conter letras, números e caracteres especiais permitidos." });
            }

            if (dto.Senha != dto.ConfirmarSenha)
            {
                return BadRequest(new { mensagem = "As senhas não coincidem." });
            }

            bool existe = await _context.Usuarios.AnyAsync(u => u.Email == dto.Email);

            if (existe)
            {
                return BadRequest(new { mensagem = "Já existe uma conta com esse email." });
            }

            var usuario = new Usuario
            {
                Email = dto.Email,
                Senha = dto.Senha,
                IsAdmin = false
            };

            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();

            return Ok(new { mensagem = "Conta criada com sucesso." });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            if (string.IsNullOrWhiteSpace(dto.Email) || string.IsNullOrWhiteSpace(dto.Senha))
            {
                return BadRequest(new { mensagem = "Preencha email e senha." });
            }

            var usuarioEmail = await _context.Usuarios
                .FirstOrDefaultAsync(u => u.Email == dto.Email);

            if (usuarioEmail == null)
            {
                return BadRequest(new { mensagem = "Email inválido." });
            }

            if (usuarioEmail.Senha != dto.Senha)
            {
                return BadRequest(new { mensagem = "Senha inválida." });
            }

            return Ok(new
            {
                mensagem = "Login realizado com sucesso.",
                id = usuarioEmail.Id,
                email = usuarioEmail.Email,
                isAdmin = usuarioEmail.IsAdmin,
                nome = usuarioEmail.Nome
            });
        }

        [HttpPost("criar-admin")]
        public async Task<IActionResult> CriarAdmin([FromBody] CriarAdminDto dto)
        {
            if (dto.AdminId <= 0 ||
                string.IsNullOrWhiteSpace(dto.Email) ||
                string.IsNullOrWhiteSpace(dto.Senha) ||
                string.IsNullOrWhiteSpace(dto.ConfirmarSenha))
            {
                return BadRequest(new { mensagem = "Preencha todos os campos." });
            }

            var admin = await _context.Usuarios.FirstOrDefaultAsync(u => u.Id == dto.AdminId);

            if (admin == null || !admin.IsAdmin)
            {
                return BadRequest(new { mensagem = "Apenas um administrador pode criar outro administrador." });
            }

            if (!dto.Email.EndsWith("@gmail.com", StringComparison.OrdinalIgnoreCase) &&
                !dto.Email.EndsWith("@hotmail.com", StringComparison.OrdinalIgnoreCase))
            {
                return BadRequest(new { mensagem = "Email inválido. Use apenas @gmail.com ou @hotmail.com." });
            }

            if (dto.Senha.Length < 5)
            {
                return BadRequest(new { mensagem = "A senha deve ter no mínimo 5 caracteres." });
            }

            if (!Regex.IsMatch(dto.Senha, @"^[A-Za-z0-9!@#$%^&*()_\-+=\[\]{};:,.?/\\|]+$"))
            {
                return BadRequest(new { mensagem = "A senha só pode conter letras, números e caracteres especiais permitidos." });
            }

            if (dto.Senha != dto.ConfirmarSenha)
            {
                return BadRequest(new { mensagem = "As senhas não coincidem." });
            }

            bool existe = await _context.Usuarios.AnyAsync(u => u.Email == dto.Email);

            if (existe)
            {
                return BadRequest(new { mensagem = "Já existe uma conta com esse email." });
            }

            var novoAdmin = new Usuario
            {
                Email = dto.Email,
                Senha = dto.Senha,
                IsAdmin = true
            };

            _context.Usuarios.Add(novoAdmin);
            await _context.SaveChangesAsync();

            return Ok(new { mensagem = "Administrador criado com sucesso." });
        }
    }
}