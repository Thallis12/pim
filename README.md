TechBuild — Loja de Hardware
Projeto desenvolvido para o PIM III do curso de Análise e Desenvolvimento de Sistemas (UNIP).
Sistema web completo para venda de componentes de hardware, com configurador de PC, painel administrativo e dashboard analítico.

Tecnologias
CamadaTecnologiaFrontendHTML5, CSS3, JavaScript (Vanilla)BackendASP.NET Core (C#)Banco de dadosSQL ServerORMEntity Framework CoreGráficosChart.js

Funcionalidades
Para o usuário:

Catálogo de produtos com filtro por faixa de preço
Configurador de PC com validação de compatibilidade (socket CPU/placa-mãe e potência da fonte)
Carrinho de compras com produtos avulsos e montagens
Histórico de pedidos com opção de cancelamento
Cadastro e login de conta

Para o administrador:

Gestão de estoque (criar, editar, excluir produtos)
Histórico de vendas agrupado por pedido
Dashboard com gráficos de produtos mais vendidos e receita por dia, mês e ano
Criação de outros administradores
Como rodar
Pré-requisitos

.NET SDK 8+
SQL Server (ou SQL Server Express)

1. Banco de dados
Execute o script banco.sql no SQL Server para criar o banco TechHouse IndustryDB com todas as tabelas.
2. API
bashcd "TechHouse Industry"
dotnet run
A API sobe em https://localhost:7011 por padrão.
O Swagger fica disponível em https://localhost:7011/swagger.
3. Frontend
Abra o arquivo html/index.html diretamente no navegador.
A URL da API está configurada no topo do script em index.html:
jsconst API = "https://localhost:7011/api/Produtos";

Banco de dados — tabelas
TabelaDescriçãoUsuariosClientes e administradoresProdutosCatálogo de hardware com atributos técnicosComprasPedidos realizadosCompraItensItens de cada pedidoVendasRegistro individual de cada venda
