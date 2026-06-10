# TechHouse Industry

Sistema de e-commerce para montagem e venda de computadores, desenvolvido como projeto integrador (PIM). Permite que usuários montem PCs, adicionem produtos ao carrinho, finalizem compras e acompanhem o status dos pedidos — com painel administrativo para gestão de estoque, vendas e dashboard com gráficos.

---

## Tecnologias Utilizadas

**Back-end**
- ASP.NET Core (C#)
- Entity Framework Core
- SQL Server Express
- Swagger (documentação da API)

**Front-end**
- HTML, CSS e JavaScript (vanilla)
- Chart.js (gráficos do dashboard)

---

## Funcionalidades

**Usuário**
- Cadastro e login com validação de e-mail (@gmail.com / @hotmail.com) e senha
- Navegação e filtragem de produtos por tipo, socket e faixa de preço
- Montagem de PC com verificação de compatibilidade de socket e consumo de energia
- Carrinho de compras com controle de quantidade
- Finalização de compra com baixa automática de estoque
- Acompanhamento de pedidos com opção de cancelamento (até "Em Preparo") e devolução (quando "Entregue")

**Administrador**
- Cadastro, edição e exclusão de produtos com imagem e dados técnicos
- Gerenciamento de vendas com avanço de status: Em Preparo → Em Transporte → Entregue
- Registro de devoluções com motivo (Defeito, Desistência, Outro)
- Dashboard com gráficos de vendas, faturamento, estoque e devoluções
- Criação de outros administradores

---

## Estrutura do Projeto

```
PIM/
├── TechHouse Industry/        # Projeto ASP.NET Core
│   ├── Controllers/           # Endpoints da API
│   │   ├── ComprasController.cs
│   │   ├── ProdutosController.cs
│   │   ├── UsuariosController.cs
│   │   └── VendasController.cs
│   ├── Models/                # Entidades do banco
│   │   ├── Compra.cs
│   │   ├── CompraItem.cs
│   │   ├── Produto.cs
│   │   ├── Usuario.cs
│   │   └── Vendas.cs
│   ├── Data/                  # Contexto do Entity Framework
│   ├── Program.cs             # Configuração da aplicação
│   └── appsettings.json       # String de conexão com o banco
├── html/
│   ├── index.html             # Front-end principal
│   └── style.css              # Estilos globais
└── bancoPIM.sql               # Script de criação do banco de dados
```

---

## Como Executar

### Pré-requisitos
- .NET 8 SDK
- SQL Server Express
- Visual Studio 2022 ou VS Code

### Passo a passo

1. **Clone o repositório**
   ```bash
   git clone https://github.com/Thallis12/pim.git
   cd pim
   ```

2. **Configure o banco de dados**

   Execute o script `bancoPIM.sql` no SQL Server Management Studio (SSMS) para criar o banco `TechHouse IndustryDB`.

3. **Configure a string de conexão**

   Em `appsettings.json`, ajuste o servidor conforme sua instância:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=SEU_SERVIDOR\\SQLEXPRESS;Database=TechHouse IndustryDB;Trusted_Connection=True;TrustServerCertificate=True;"
   }
   ```

4. **Execute a API**
   ```bash
   cd "TechHouse Industry"
   dotnet run
   ```
   A API estará disponível em `https://localhost:{porta}` com Swagger em `/swagger`.

5. **Abra o front-end**

   Abra o arquivo `html/index.html` diretamente no navegador.

---

## Endpoints Principais da API

| Método | Rota | Descrição |
|--------|------|-----------|
| POST | `/api/Usuarios/criar-conta` | Cadastro de usuário |
| POST | `/api/Usuarios/login` | Login |
| GET | `/api/Produtos` | Listar produtos |
| POST | `/api/Produtos` | Cadastrar produto (admin) |
| PUT | `/api/Produtos/{id}` | Editar produto (admin) |
| DELETE | `/api/Produtos/{id}` | Remover produto (admin) |
| POST | `/api/Compras/finalizar` | Finalizar compra |
| GET | `/api/Compras/usuario/{id}` | Pedidos do usuário |
| PUT | `/api/Compras/cancelar/{id}` | Cancelar compra |
| GET | `/api/Vendas` | Listar vendas (admin) |
| PUT | `/api/Vendas/avancar-status/{id}` | Avançar status (admin) |
| PUT | `/api/Vendas/devolver/{id}` | Registrar devolução |

---

## Status dos Pedidos

```
Em Preparo → Em Transporte → Entregue
                                 ↓
                           Devolvida / Perda
```

- **Cancelada** — cliente cancela até "Em Preparo"
- **Devolvida** — devolução por desistência (volta ao estoque)
- **Perda** — devolução por defeito (não volta ao estoque)

---
