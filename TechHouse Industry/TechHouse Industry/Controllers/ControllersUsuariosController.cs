using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TechBuildAPI.Services;

namespace TechBuildAPI.Controllers
{
    // =====================================================================
    // CAMADA DE APRESENTAÇÃO (API) - USUÁRIOS
    // Regras (validação de e-mail/senha, BCrypt, JWT) ficam no UsuarioService.
    // =====================================================================
    [ApiController]
    [Route("api/[controller]")]
    [Authorize] // por padrão tudo exige token; login e criar-conta liberam com [AllowAnonymous]
    public class UsuariosController : ControllerBase
    {
        private readonly UsuarioService _usuarios;

        public UsuariosController(UsuarioService usuarios)
        {
            _usuarios = usuarios;
        }

        public class CriarContaDto
        {
            public string Nome { get; set; } = "";
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
            public string Email { get; set; } = "";
            public string Senha { get; set; } = "";
            public string ConfirmarSenha { get; set; } = "";
        }

        [AllowAnonymous]
        [HttpPost("criar-conta")]
        public async Task<IActionResult> CriarConta([FromBody] CriarContaDto dto)
        {
            try
            {
                await _usuarios.CriarConta(dto.Nome, dto.Email, dto.Senha, dto.ConfirmarSenha);
                return Ok(new { mensagem = "Conta criada com sucesso." });
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            try
            {
                var resultado = await _usuarios.Login(dto.Email, dto.Senha);
                if (resultado == null)
                    return Unauthorized(new { mensagem = "E-mail ou senha inválidos." });

                var u = resultado.Usuario;
                return Ok(new
                {
                    mensagem = "Login realizado com sucesso.",
                    token = resultado.Token,
                    id = u.Id,
                    email = u.Email,
                    isAdmin = u.IsAdmin,
                    nome = u.Nome
                });
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("criar-admin")]
        public async Task<IActionResult> CriarAdmin([FromBody] CriarAdminDto dto)
        {
            try
            {
                await _usuarios.CriarAdmin(dto.Email, dto.Senha, dto.ConfirmarSenha);
                return Ok(new { mensagem = "Administrador criado com sucesso." });
            }
            catch (RegraDeNegocioException ex)
            {
                return BadRequest(new { mensagem = ex.Message });
            }
        }
    }
}
