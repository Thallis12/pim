namespace TechBuildAPI.Services
{
    // Hora do Brasil (UTC-3) funcionando no Windows e no Linux/Docker.
    public static class FusoHorario
    {
        private static readonly TimeZoneInfo Brasil = Resolver();

        private static TimeZoneInfo Resolver()
        {
            foreach (var id in new[] { "E. South America Standard Time", "America/Sao_Paulo" })
            {
                try
                {
                    return TimeZoneInfo.FindSystemTimeZoneById(id);
                }
                catch (Exception ex) when (ex is TimeZoneNotFoundException || ex is InvalidTimeZoneException)
                {
                    // tenta o próximo identificador
                }
            }

            return TimeZoneInfo.CreateCustomTimeZone("BRT", TimeSpan.FromHours(-3), "BRT", "BRT");
        }

        public static DateTime Agora() => TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, Brasil);
    }
}
