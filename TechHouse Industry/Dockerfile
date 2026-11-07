# =====================================================================
# DOCKERFILE - empacota a API TechBuild (e o site em wwwroot) num container
#
# Etapa 1 (build): usa a imagem com o SDK do .NET para compilar.
# Etapa 2 (final): copia só o resultado para uma imagem pequena, que tem
#                  apenas o necessário para RODAR (mais leve e mais segura).
#
# Montar:  docker build -t techbuild-api "TechHouse Industry"
# =====================================================================

# ---------- Etapa 1: compilar ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia primeiro só o .csproj: se ele não mudar, o Docker reaproveita
# os pacotes baixados (build mais rápido)
COPY ["TechHouse Industry/TechHouse Industry.csproj", "TechHouse Industry/"]
RUN dotnet restore "TechHouse Industry/TechHouse Industry.csproj"

# Copia o resto do código e publica em modo Release
COPY . .
RUN dotnet publish "TechHouse Industry/TechHouse Industry.csproj" -c Release -o /app/publish /p:UseAppHost=false

# ---------- Etapa 2: imagem final ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# A API escuta na porta 8080 dentro do container
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Roda com um usuário sem privilégios de administrador (segurança)
USER app

# Configurações sensíveis NÃO ficam na imagem; são passadas na hora de rodar:
#   ConnectionStrings__DefaultConnection  -> conexão com o SQL Server
#   Jwt__Key                              -> chave dos tokens (32+ caracteres)
ENTRYPOINT ["dotnet", "TechHouse Industry.dll"]
