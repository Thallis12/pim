# TechBuild – PIM IV (ADS – UNIP)

Loja virtual de hardware com a função "Monte seu PC". Ela tem uma API em ASP.NET Core, um front-end web (HTML/CSS/JS), um app mobile em Flutter e um banco de dados SQL Server.

## Estrutura do repositório

| Pasta / arquivo | O que é |
| --- | --- |
| `TechHouse Industry/` | API REST em C# / ASP.NET Core |
| `html/` | Front-end web (index.html, style.css) |
| `mobile/` | App mobile em Flutter |
| `bancoPIM_completo.sql` | Script completo do banco (tabelas e dados) |
| `banco_etapa7_procedures_triggers.sql` | Procedures e triggers |
| `docker-compose.yml`, `docker/` | Ambiente com Docker |
| `diagramas/` | Diagramas do projeto |

---

## 1. Baixar o projeto

```
git clone https://github.com/Thallis12/pim.git
cd pim
```

---

## Opção A – Rodar com Docker (mais fácil)

**Precisa ter instalado:** [Docker Desktop](https://www.docker.com/products/docker-desktop/)

1. Copie o arquivo de exemplo de configuração:
   ```
   copy env.exemplo .env
   ```
   (no Linux/Mac: `cp env.exemplo .env`)
2. Abra o `.env` e, se quiser, troque a senha do banco.
3. Suba tudo:
   ```
   docker compose up -d --build
   ```
4. Veja no `docker-compose.yml` em quais portas a API e o banco ficaram disponíveis.

Para desligar: `docker compose down`

---

## Opção B – Rodar sem Docker

**Precisa ter instalado:**
- [.NET SDK](https://dotnet.microsoft.com/download) (a mesma versão indicada no `TechHouse Industry.csproj`)
- [SQL Server](https://www.microsoft.com/sql-server/sql-server-downloads) (a versão Express serve) e o [SSMS](https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms)

### 1. Criar o banco
1. Abra o SSMS e conecte no seu SQL Server.
2. Abra e execute o `bancoPIM_completo.sql`.
3. Depois, abra e execute o `banco_etapa7_procedures_triggers.sql`.

### 2. Configurar a API
Abra `TechHouse Industry/TechHouse Industry/appsettings.json` e ajuste a connection string para o seu SQL Server. Exemplo:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost;Database=NOME_DO_BANCO;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

### 3. Rodar a API
```
cd "TechHouse Industry/TechHouse Industry"
dotnet run
```
O terminal mostra o endereço da API, por exemplo `https://localhost:7011`. Para ver e testar os endpoints, abra `/swagger` nesse endereço.

### 4. Abrir o site
Abra o arquivo `html/index.html` no navegador. Se a API estiver em outra porta, altere a constante `API` no início do script do `index.html`.

---

## App mobile (Flutter)

**Precisa ter instalado:** [Flutter SDK](https://docs.flutter.dev/get-started/install). Outra opção é abrir a pasta `mobile/` direto no [FlutLab](https://flutlab.io).

```
cd mobile
flutter pub get
flutter run
```

> No emulador Android, `localhost` aponta para o próprio emulador. Para acessar a API rodando no seu PC, use `10.0.2.2` no lugar de `localhost`.

---

## Integrantes
- Cauê Alexandre Souza Santos – H683BI2
- João Pedro Ribeiro Barrozo – H596548
- Luiz Felipe Requião Lemos – R649DE3
- Thallis Andrade Souza – G757IC4
- Vinicius Braga de Morais – F3627H2
