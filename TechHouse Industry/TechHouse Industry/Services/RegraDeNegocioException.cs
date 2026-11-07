namespace TechBuildAPI.Services
{
    // Erro de REGRA DE NEGÓCIO (ex.: "Estoque insuficiente", "E-mail já cadastrado").
    // Os Services e o Repository lançam este erro; o Controller transforma em
    // resposta HTTP 400 (ou 403 quando SemPermissao = true).
    public class RegraDeNegocioException : Exception
    {
        public bool SemPermissao { get; }

        public RegraDeNegocioException(string mensagem, bool semPermissao = false) : base(mensagem)
        {
            SemPermissao = semPermissao;
        }
    }
}
