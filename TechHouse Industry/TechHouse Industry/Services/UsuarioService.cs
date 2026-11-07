using System.Net.Mail;
using System.Text.RegularExpressions;
using TechBuildAPI.Models;
using TechBuildAPI.Repositories;

namespace TechBuildAPI.Services
{
    // =====================================================================
    // CAMADA DE REGRAS DE NEGÓCIO - USUÁRIOS
    // Cadastro, login (com BCrypt) e criação de administradores.
    // =====================================================================
    public class UsuarioService
    {
        private readonly IUsuarioRepository _repositorio;
        private readonly TokenService _tokens;

        private static readonly Regex SenhaPermitida =
            new Regex(@"^[A-Za-z0-9!@#$%^&*()_\-+=\[\]{};:,.?/\\|]+$");

        public UsuarioService(IUsuarioRepository repositorio, TokenService tokens)
        {
            _repositorio = repositorio;
            _tokens = tokens;
        }

        // Resultado do login: o usuário e o token JWT gerado
        public record ResultadoLogin(Usuario Usuario, string Token);

        private static void ValidarEmail(string email)
        {
            if (email.Length > 150)
                throw new RegraDeNegocioException("E-mail muito longo.");
            try
            {
                var endereco = new MailAddress(email);
                if (endereco.Address != email || !endereco.Host.Contains('.'))
                    throw new RegraDeNegocioException("E-mail inválido.");
            }
            catch (FormatException)
            {
                throw new RegraDeNegocioException("E-mail inválido.");
            }
        }

        private static void ValidarSenha(string senha, string confirmar)
        {
            if (senha.Length < 5)
                throw new RegraDeNegocioException("A senha deve ter no mínimo 5 caracteres.");
            if (senha.Length > 72)
                throw new RegraDeNegocioException("A senha deve ter no máximo 72 caracteres.");
            if (!SenhaPermitida.IsMatch(senha))
                throw new RegraDeNegocioException("A senha só pode conter letras, números e caracteres especiais permitidos.");
            if (senha != confirmar)
                throw new RegraDeNegocioException("As senhas não coincidem.");
        }

        private static bool SenhaConfere(string senhaDigitada, string hashSalvo)
        {
            try
            {
                return BCrypt.Net.BCrypt.Verify(senhaDigitada, hashSalvo);
            }
            catch (Exception)
            {
                return false; // hash em formato inválido: trata como senha errada
            }
        }

        public async Task CriarConta(string nome, string email, string senha, string confirmar)
        {
            if (string.IsNullOrWhiteSpace(nome) || string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(senha) || string.IsNullOrWhiteSpace(confirmar))
                throw new RegraDeNegocioException("Preencha todos os campos.");

            nome = nome.Trim();
            email = email.Trim();

            if (nome.Length > 100)
                throw new RegraDeNegocioException("Nome muito longo.");

            ValidarEmail(email);
            ValidarSenha(senha, confirmar);

            if (await _repositorio.EmailExiste(email))
                throw new RegraDeNegocioException("Já existe uma conta com esse email.");

            await _repositorio.Adicionar(new Usuario
            {
                Nome = nome,
                Email = email,
                Senha = BCrypt.Net.BCrypt.HashPassword(senha), // a senha nunca é salva em texto
                IsAdmin = false
            });
        }

        // Retorna null quando e-mail ou senha estão errados
        public async Task<ResultadoLogin?> Login(string email, string senha)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(senha))
                throw new RegraDeNegocioException("Preencha email e senha.");

            var usuario = await _repositorio.ObterPorEmail(email.Trim());

            // mesma resposta para e-mail inexistente e senha errada (não revela quais e-mails existem)
            if (usuario == null || !SenhaConfere(senha, usuario.Senha))
                return null;

            return new ResultadoLogin(usuario, _tokens.Gerar(usuario));
        }

        public async Task CriarAdmin(string email, string senha, string confirmar)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(senha) ||
                string.IsNullOrWhiteSpace(confirmar))
                throw new RegraDeNegocioException("Preencha todos os campos.");

            email = email.Trim();
            ValidarEmail(email);
            ValidarSenha(senha, confirmar);

            if (await _repositorio.EmailExiste(email))
                throw new RegraDeNegocioException("Já existe uma conta com esse email.");

            await _repositorio.Adicionar(new Usuario
            {
                Email = email,
                Senha = BCrypt.Net.BCrypt.HashPassword(senha),
                IsAdmin = true
            });
        }
    }
}
