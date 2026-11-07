using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Microsoft.EntityFrameworkCore;
using TechBuildAPI.Data;
using TechBuildAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// ---------------------------------------------------------------
// Chave do JWT: NÃO fica no appsettings (o repositório é público).
// Configure uma vez com:
//   dotnet user-secrets set "Jwt:Key" "uma-chave-longa-com-no-minimo-32-caracteres"
// ---------------------------------------------------------------
var jwtKey = builder.Configuration["Jwt:Key"];
if (string.IsNullOrWhiteSpace(jwtKey) || jwtKey.Length < 32)
{
    throw new InvalidOperationException(
        "Jwt:Key não configurada (mínimo 32 caracteres). " +
        "Execute: dotnet user-secrets set \"Jwt:Key\" \"sua-chave-com-32-ou-mais-caracteres\"");
}

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// Swagger com botão "Authorize" para testar rotas protegidas
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Cole apenas o token JWT retornado pelo login."
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<TokenService>();

// ---------------------------------------------------------------
// ARQUITETURA EM CAMADAS (injeção de dependência)
//   Controllers  -> recebem o pedido HTTP e devolvem a resposta
//   Services     -> regras de negócio (validações)
//   Repositories -> acesso ao banco (Entity Framework + stored procedures)
// Cada Service recebe a INTERFACE do repositório, não a classe concreta.
// ---------------------------------------------------------------
builder.Services.AddScoped<TechBuildAPI.Repositories.IProdutoRepository, TechBuildAPI.Repositories.ProdutoRepository>();
builder.Services.AddScoped<TechBuildAPI.Repositories.IUsuarioRepository, TechBuildAPI.Repositories.UsuarioRepository>();
builder.Services.AddScoped<TechBuildAPI.Repositories.IPedidoRepository, TechBuildAPI.Repositories.PedidoRepository>();
builder.Services.AddScoped<ProdutoService>();
builder.Services.AddScoped<UsuarioService>();
builder.Services.AddScoped<PedidoService>();

// Autenticação JWT
builder.Services
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.MapInboundClaims = false;
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
            ClockSkew = TimeSpan.FromMinutes(1),
            NameClaimType = "sub",
            RoleClaimType = "role"
        };
    });

builder.Services.AddAuthorization();

// CORS restrito às origens listadas em appsettings.json (Cors:Origens)
var origens = builder.Configuration.GetSection("Cors:Origens").Get<string[]>() ?? Array.Empty<string>();
builder.Services.AddCors(options =>
{
    options.AddPolicy("Front", policy =>
    {
        policy
            .WithOrigins(origens)
            .AllowAnyHeader()
            .AllowAnyMethod();
    });

    // Usada pelo app mobile (preview do FlutLab roda no navegador, em outra origem).
    // Liberada apenas em Development; em produção vale a lista "Cors:Origens".
    options.AddPolicy("Mobile", policy =>
    {
        policy
            .SetIsOriginAllowed(_ => true)
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// Permite servir o front pela própria API (coloque os arquivos em wwwroot)
app.UseDefaultFiles();
app.UseStaticFiles();

app.UseCors(app.Environment.IsDevelopment() ? "Mobile" : "Front");

app.UseAuthentication();   // precisa vir ANTES do UseAuthorization
app.UseAuthorization();

app.MapControllers();

// MONITORAMENTO: GET /health diz se a API está no ar e se consegue falar com o banco.
// Usado pelo Docker e pela nuvem para saber se precisam reiniciar o container.
app.MapGet("/health", async (AppDbContext db) =>
    await db.Database.CanConnectAsync()
        ? Results.Ok(new { status = "ok", banco = "conectado", hora = DateTime.UtcNow })
        : Results.Json(new { status = "erro", banco = "sem conexão" }, statusCode: 503));

// Transição: converte para hash BCrypt as senhas que ainda estão em texto simples.
// Depois que rodar uma vez, não há mais nada a converter (pode remover esta chamada).
try
{
    await SenhaMigracao.HashearSenhasAntigasAsync(app.Services);
}
catch (Exception ex)
{
    app.Logger.LogWarning(ex, "Não foi possível converter as senhas antigas para hash.");
}

app.Run();
