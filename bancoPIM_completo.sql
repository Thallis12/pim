-- =====================================================================
-- TechBuild (PIM IV) - SCRIPT COMPLETO DO BANCO DE DADOS
-- Parte A: criacao das tabelas e dados (script original do PIM III)
-- Parte B: Etapa 7 do PIM IV (integridade, indices, auditoria,
--          triggers, stored procedures e views)
-- ATENCAO: a Parte A APAGA e recria o banco. Para so atualizar um
-- banco que ja existe, use banco_etapa7_procedures_triggers.sql
-- =====================================================================

-- ============================================================
-- TechBuild — Script de criação do banco de dados
-- Compatível com SQL Server Express (qualquer versão)
-- ============================================================

USE master
GO

-- Remove o banco se já existir
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'TechHouse IndustryDB')
BEGIN
    ALTER DATABASE [TechHouse IndustryDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [TechHouse IndustryDB];
END
GO

-- Cria o banco no local padrão do SQL Server da máquina
CREATE DATABASE [TechHouse IndustryDB]
GO

USE [TechHouse IndustryDB]
GO

CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompraItens]    Script Date: 02/06/2026 21:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompraItens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompraId] [int] NOT NULL,
	[ProdutoNome] [nvarchar](200) NOT NULL,
	[ProdutoTipo] [nvarchar](100) NOT NULL,
	[Preco] [decimal](10, 2) NOT NULL,
	[Quantidade] [int] NOT NULL,
	[Origem] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compras]    Script Date: 02/06/2026 21:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compras](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[DataCompra] [datetime] NOT NULL,
	[Status] [nvarchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Produtos]    Script Date: 02/06/2026 21:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Produtos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NULL,
	[Tipo] [varchar](50) NULL,
	[Preco] [decimal](10, 2) NULL,
	[Socket] [varchar](50) NULL,
	[ConsumoEnergia] [int] NULL,
	[ImagemUrl] [nvarchar](max) NULL,
	[Potencia] [int] NULL,
	[Quantidade] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 02/06/2026 21:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[Senha] [nvarchar](100) NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[Nome] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vendas]    Script Date: 02/06/2026 21:06:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Data] [datetime2](7) NOT NULL,
	[Preco] [decimal](10, 2) NOT NULL,
	[ProdutoNome] [nvarchar](max) NULL,
	[ProdutoTipo] [nvarchar](max) NULL,
	[Quantidade] [int] NOT NULL,
	[Status] [nvarchar](50) NULL,
	[UsuarioId] [int] NOT NULL,
	[CompraId] [int] NULL,
	[Origem] [nvarchar](50) NULL,
	[MotivoDevolicao] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CompraItens] ON 

INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1, 1, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2, 1, N'Intel i5 12400F', N'CPU', CAST(1900.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (3, 1, N'Ryzen 9 5900X', N'CPU', CAST(2800.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (4, 1, N'RTX 3060', N'GPU', CAST(2800.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (5, 1, N'8GB DDR4', N'RAM', CAST(1150.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (6, 1, N'B450M', N'PlacaMae', CAST(1500.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (7, 1, N'SSD 240GB', N'SSD', CAST(1150.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (8, 1, N'SSD NVMe 500GB', N'SSDNVME', CAST(1300.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (9, 1, N'Fonte 400W', N'Fonte', CAST(1200.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (10, 1, N'Gabinete Gamer RGB', N'Gabinete', CAST(1300.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (11, 2, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), 5, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (12, 2, N'Ryzen 9 5900X', N'CPU', CAST(2800.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (13, 2, N'RTX 3060', N'GPU', CAST(2800.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (14, 2, N'8GB DDR4', N'RAM', CAST(1150.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (15, 2, N'B450M', N'PlacaMae', CAST(1500.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (16, 2, N'SSD 240GB', N'SSD', CAST(1150.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (17, 2, N'Fonte 400W', N'Fonte', CAST(1200.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (18, 2, N'Gabinete Gamer RGB', N'Gabinete', CAST(1300.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (19, 3, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (20, 4, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (21, 4, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (22, 5, N'Ryzen 3 4100', N'CPU', CAST(1500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (23, 5, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1001, 1001, N'Intel i5 12400F', N'CPU', CAST(1900.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1002, 1001, N'Ryzen 9 5900X', N'CPU', CAST(2800.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1003, 1002, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1004, 1002, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1005, 1003, N'Intel i5 12400F', N'CPU', CAST(1900.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1006, 1004, N'Ryzen 3 4100', N'CPU', CAST(1500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1007, 1004, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1008, 1004, N'Intel i5 13400F', N'CPU', CAST(2100.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1009, 1004, N'GTX 1660', N'GPU', CAST(2200.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1010, 1004, N'Kingston Fury 16GB', N'RAM', CAST(1320.00 AS Decimal(10, 2)), 2, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1011, 1004, N'B760', N'PlacaMae', CAST(1900.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1012, 1004, N'SSD RGB 512GB', N'SSD', CAST(1350.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1013, 1004, N'SSD NVMe 500GB', N'SSDNVME', CAST(1300.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1014, 1004, N'Fonte 400W', N'Fonte', CAST(1200.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1015, 1004, N'Gabinete Gamer RGB', N'Gabinete', CAST(1300.00 AS Decimal(10, 2)), 1, N'MontePC')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1016, 1005, N'Ryzen 3 4100', N'CPU', CAST(1500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (1017, 1005, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2016, 2005, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2017, 2006, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2018, 2006, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2019, 2007, N'Ryzen 3 4100', N'CPU', CAST(1500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2020, 2007, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2021, 2008, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2022, 2008, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), 1, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2023, 2009, N'Ryzen 9 5900X', N'CPU', CAST(2800.00 AS Decimal(10, 2)), 2, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2024, 2010, N'Ryzen 9 5900X', N'CPU', CAST(2800.00 AS Decimal(10, 2)), 4, N'Carrinho')
INSERT [dbo].[CompraItens] ([Id], [CompraId], [ProdutoNome], [ProdutoTipo], [Preco], [Quantidade], [Origem]) VALUES (2025, 2011, N'Intel i5 12400F', N'CPU', CAST(1900.00 AS Decimal(10, 2)), 1, N'Carrinho')
SET IDENTITY_INSERT [dbo].[CompraItens] OFF
GO
SET IDENTITY_INSERT [dbo].[Compras] ON 

INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (1, 3, CAST(N'2026-04-26T19:05:50.187' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2, 3, CAST(N'2026-04-26T19:06:30.707' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (3, 3, CAST(N'2026-04-26T19:09:15.627' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (4, 3, CAST(N'2026-04-26T19:11:50.017' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (5, 2, CAST(N'2026-04-26T19:13:54.843' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (1001, 5, CAST(N'2026-05-20T23:46:47.160' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (1002, 6, CAST(N'2026-05-22T00:20:06.187' AS DateTime), N'Cancelada')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (1003, 3, CAST(N'2026-05-22T00:20:31.297' AS DateTime), N'Cancelada')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (1004, 3, CAST(N'2026-05-23T18:44:14.443' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (1005, 2, CAST(N'2026-05-28T20:17:16.680' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2005, 5, CAST(N'2026-06-01T19:40:02.963' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2006, 5, CAST(N'2026-06-01T19:58:14.693' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2007, 5, CAST(N'2026-06-01T19:58:35.017' AS DateTime), N'Entregue')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2008, 5, CAST(N'2026-06-01T20:08:48.910' AS DateTime), N'Em Preparo')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2009, 4, CAST(N'2026-06-01T20:11:47.850' AS DateTime), N'Em Preparo')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2010, 4, CAST(N'2026-06-01T20:11:58.233' AS DateTime), N'Em Preparo')
INSERT [dbo].[Compras] ([Id], [UsuarioId], [DataCompra], [Status]) VALUES (2011, 4, CAST(N'2026-06-01T20:17:02.200' AS DateTime), N'Em Preparo')
SET IDENTITY_INSERT [dbo].[Compras] OFF
GO
SET IDENTITY_INSERT [dbo].[Produtos] ON 

INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (7, N'Ryzen 9 5900X', N'CPU', CAST(2800.00 AS Decimal(10, 2)), N'AM4', 105, NULL, NULL, 0)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (8, N'Intel i5 12400F', N'CPU', CAST(1900.00 AS Decimal(10, 2)), N'LGA1700', 65, NULL, NULL, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (9, N'Intel i7 12700K', N'CPU', CAST(2500.00 AS Decimal(10, 2)), N'LGA1700', 125, NULL, NULL, 0)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (10, N'Intel i9 12900K', N'CPU', CAST(3500.00 AS Decimal(10, 2)), N'LGA1700', 125, NULL, NULL, 0)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (11, N'Ryzen 3 4100', N'CPU', CAST(1500.00 AS Decimal(10, 2)), N'AM4', 65, NULL, NULL, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (12, N'Intel i3 10100F', N'CPU', CAST(1450.00 AS Decimal(10, 2)), N'LGA1200', 65, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (13, N'Ryzen 7 5800X3D', N'CPU', CAST(3000.00 AS Decimal(10, 2)), N'AM4', 105, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (14, N'Intel i5 13400F', N'CPU', CAST(2100.00 AS Decimal(10, 2)), N'LGA1700', 65, NULL, NULL, 8)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (15, N'RTX 3060', N'GPU', CAST(2800.00 AS Decimal(10, 2)), NULL, 170, NULL, NULL, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (16, N'RTX 4060', N'GPU', CAST(3200.00 AS Decimal(10, 2)), NULL, 160, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (17, N'RTX 4070', N'GPU', CAST(4500.00 AS Decimal(10, 2)), NULL, 200, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (18, N'RTX 4080', N'GPU', CAST(7000.00 AS Decimal(10, 2)), NULL, 320, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (19, N'RX 6600', N'GPU', CAST(2500.00 AS Decimal(10, 2)), NULL, 160, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (20, N'RX 6700 XT', N'GPU', CAST(3200.00 AS Decimal(10, 2)), NULL, 230, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (21, N'RX 6800', N'GPU', CAST(4000.00 AS Decimal(10, 2)), NULL, 250, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (22, N'GTX 1660', N'GPU', CAST(2200.00 AS Decimal(10, 2)), NULL, 120, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (23, N'RTX 3050', N'GPU', CAST(2500.00 AS Decimal(10, 2)), NULL, 130, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (24, N'RX 580', N'GPU', CAST(1800.00 AS Decimal(10, 2)), NULL, 185, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (25, N'8GB DDR4', N'RAM', CAST(1150.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (26, N'16GB DDR4', N'RAM', CAST(1300.00 AS Decimal(10, 2)), NULL, 10, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (27, N'32GB DDR4', N'RAM', CAST(1600.00 AS Decimal(10, 2)), NULL, 15, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (28, N'8GB DDR5', N'RAM', CAST(1250.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (29, N'16GB DDR5', N'RAM', CAST(1500.00 AS Decimal(10, 2)), NULL, 10, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (30, N'32GB DDR5', N'RAM', CAST(1900.00 AS Decimal(10, 2)), NULL, 15, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (31, N'Corsair 16GB', N'RAM', CAST(1350.00 AS Decimal(10, 2)), NULL, 10, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (32, N'Kingston Fury 16GB', N'RAM', CAST(1320.00 AS Decimal(10, 2)), NULL, 10, NULL, NULL, 8)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (33, N'HyperX 8GB', N'RAM', CAST(1200.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (34, N'XPG 16GB', N'RAM', CAST(1310.00 AS Decimal(10, 2)), NULL, 10, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (35, N'SSD 240GB', N'SSD', CAST(1150.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 5)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (36, N'SSD 480GB', N'SSD', CAST(1250.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 8)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (37, N'SSD 1TB', N'SSD', CAST(1400.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (38, N'SSD NVMe 500GB', N'SSDNVME', CAST(1300.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 6)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (39, N'SSD NVMe 1TB', N'SSDNVME', CAST(1500.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 7)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (40, N'SSD Kingston 480GB', N'SSD', CAST(1270.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (41, N'SSD WD Green 1TB', N'SSD', CAST(1420.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (42, N'SSD Samsung 1TB', N'SSD', CAST(1600.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (43, N'SSD Crucial 500GB', N'SSD', CAST(1280.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (44, N'SSD RGB 512GB', N'SSD', CAST(1350.00 AS Decimal(10, 2)), NULL, 5, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (45, N'Fonte 400W', N'Fonte', CAST(1200.00 AS Decimal(10, 2)), NULL, 0, NULL, 400, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (46, N'Fonte 500W', N'Fonte', CAST(1250.00 AS Decimal(10, 2)), NULL, 0, NULL, 500, 8)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (47, N'Fonte 600W', N'Fonte', CAST(1300.00 AS Decimal(10, 2)), NULL, 0, NULL, 600, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (48, N'Fonte 700W', N'Fonte', CAST(1400.00 AS Decimal(10, 2)), NULL, 0, NULL, 700, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (49, N'Fonte 800W', N'Fonte', CAST(1500.00 AS Decimal(10, 2)), NULL, 0, NULL, 800, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (50, N'Corsair 650W', N'Fonte', CAST(1450.00 AS Decimal(10, 2)), NULL, 0, NULL, 650, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (51, N'EVGA 600W', N'Fonte', CAST(1350.00 AS Decimal(10, 2)), NULL, 0, NULL, 600, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (52, N'CoolerMaster 750W', N'Fonte', CAST(1480.00 AS Decimal(10, 2)), NULL, 0, NULL, 750, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (53, N'Fonte Modular 850W', N'Fonte', CAST(1650.00 AS Decimal(10, 2)), NULL, 0, NULL, 850, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (54, N'Fonte Gold 1000W', N'Fonte', CAST(1900.00 AS Decimal(10, 2)), NULL, 0, NULL, 1000, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (55, N'Gabinete Gamer RGB', N'Gabinete', CAST(1300.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (56, N'Gabinete Preto Simples', N'Gabinete', CAST(1150.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 8)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (57, N'Gabinete Branco RGB', N'Gabinete', CAST(1350.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (58, N'Gabinete Full Tower', N'Gabinete', CAST(1500.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (59, N'Gabinete Mini Tower', N'Gabinete', CAST(1200.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (60, N'Gabinete CoolerMaster', N'Gabinete', CAST(1400.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (61, N'Gabinete Corsair', N'Gabinete', CAST(1450.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (62, N'Gabinete Vidro Temperado', N'Gabinete', CAST(1380.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (63, N'Gabinete Compacto', N'Gabinete', CAST(1220.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (64, N'Gabinete Premium RGB', N'Gabinete', CAST(1600.00 AS Decimal(10, 2)), NULL, 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (65, N'B450M', N'PlacaMae', CAST(1500.00 AS Decimal(10, 2)), N'AM4', 0, NULL, NULL, 4)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (66, N'B550M', N'PlacaMae', CAST(1700.00 AS Decimal(10, 2)), N'AM4', 0, NULL, NULL, 8)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (67, N'X570', N'PlacaMae', CAST(2200.00 AS Decimal(10, 2)), N'AM4', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (68, N'H610', N'PlacaMae', CAST(1450.00 AS Decimal(10, 2)), N'LGA1700', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (69, N'B660', N'PlacaMae', CAST(1800.00 AS Decimal(10, 2)), N'LGA1700', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (70, N'Z690', N'PlacaMae', CAST(2500.00 AS Decimal(10, 2)), N'LGA1700', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (71, N'A320', N'PlacaMae', CAST(1400.00 AS Decimal(10, 2)), N'AM4', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (72, N'B760', N'PlacaMae', CAST(1900.00 AS Decimal(10, 2)), N'LGA1700', 0, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (73, N'Z790', N'PlacaMae', CAST(2800.00 AS Decimal(10, 2)), N'LGA1700', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (74, N'B450 Steel Legend', N'PlacaMae', CAST(1650.00 AS Decimal(10, 2)), N'AM4', 0, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (75, N'HD Seagate 500GB', N'HD', CAST(1180.00 AS Decimal(10, 2)), NULL, 6, NULL, NULL, 9)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (76, N'HD Seagate 1TB', N'HD', CAST(1250.00 AS Decimal(10, 2)), NULL, 6, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (77, N'HD Seagate 2TB', N'HD', CAST(1380.00 AS Decimal(10, 2)), NULL, 7, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (78, N'HD Western Digital 500GB', N'HD', CAST(1190.00 AS Decimal(10, 2)), NULL, 6, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (79, N'HD Western Digital 1TB', N'HD', CAST(1260.00 AS Decimal(10, 2)), NULL, 6, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (80, N'HD Western Digital 2TB', N'HD', CAST(1400.00 AS Decimal(10, 2)), NULL, 7, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (81, N'HD Toshiba 500GB', N'HD', CAST(1170.00 AS Decimal(10, 2)), NULL, 6, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (82, N'HD Toshiba 1TB', N'HD', CAST(1240.00 AS Decimal(10, 2)), NULL, 6, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (83, N'HD Toshiba 2TB', N'HD', CAST(1390.00 AS Decimal(10, 2)), NULL, 7, NULL, NULL, 10)
INSERT [dbo].[Produtos] ([Id], [Nome], [Tipo], [Preco], [Socket], [ConsumoEnergia], [ImagemUrl], [Potencia], [Quantidade]) VALUES (84, N'HD BarraCuda 4TB', N'HD', CAST(1650.00 AS Decimal(10, 2)), NULL, 8, NULL, NULL, 10)
SET IDENTITY_INSERT [dbo].[Produtos] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([Id], [Email], [Senha], [IsAdmin], [Nome]) VALUES (1, N'teste@teste.com', N'123456', 0, N'teste@teste.com')
INSERT [dbo].[Usuarios] ([Id], [Email], [Senha], [IsAdmin], [Nome]) VALUES (2, N'batata@gmail.com', N'Fgas@1988', 0, N'batata@gmail.com')
INSERT [dbo].[Usuarios] ([Id], [Email], [Senha], [IsAdmin], [Nome]) VALUES (3, N'admin@gmail.com', N'12345', 1, N'Administrador')
INSERT [dbo].[Usuarios] ([Id], [Email], [Senha], [IsAdmin], [Nome]) VALUES (4, N'admin2@gmail.com', N'12345', 1, N'admin2@gmail.com')
INSERT [dbo].[Usuarios] ([Id], [Email], [Senha], [IsAdmin], [Nome]) VALUES (5, N'fefef@gmail.com', N'12345', 0, N'fefefes')
INSERT [dbo].[Usuarios] ([Id], [Email], [Senha], [IsAdmin], [Nome]) VALUES (6, N'hrugb@gmail.com', N'12345', 0, N'ef5')
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Vendas] ON 

INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1, CAST(N'2026-04-26T19:05:50.3212838' AS DateTime2), CAST(2500.00 AS Decimal(10, 2)), N'Intel i7 12700K', N'CPU', 1, N'Entregue', 3, 1, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2, CAST(N'2026-04-26T19:05:50.3515612' AS DateTime2), CAST(1900.00 AS Decimal(10, 2)), N'Intel i5 12400F', N'CPU', 1, N'Entregue', 3, 1, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (3, CAST(N'2026-04-26T19:05:50.3544250' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'Ryzen 9 5900X', N'CPU', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (4, CAST(N'2026-04-26T19:05:50.3570041' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'RTX 3060', N'GPU', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (5, CAST(N'2026-04-26T19:05:50.3605172' AS DateTime2), CAST(1150.00 AS Decimal(10, 2)), N'8GB DDR4', N'RAM', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (6, CAST(N'2026-04-26T19:05:50.3633748' AS DateTime2), CAST(1500.00 AS Decimal(10, 2)), N'B450M', N'PlacaMae', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (7, CAST(N'2026-04-26T19:05:50.3660553' AS DateTime2), CAST(1150.00 AS Decimal(10, 2)), N'SSD 240GB', N'SSD', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (8, CAST(N'2026-04-26T19:05:50.3683922' AS DateTime2), CAST(1300.00 AS Decimal(10, 2)), N'SSD NVMe 500GB', N'SSDNVME', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (9, CAST(N'2026-04-26T19:05:50.3708886' AS DateTime2), CAST(1200.00 AS Decimal(10, 2)), N'Fonte 400W', N'Fonte', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (10, CAST(N'2026-04-26T19:05:50.3741194' AS DateTime2), CAST(1300.00 AS Decimal(10, 2)), N'Gabinete Gamer RGB', N'Gabinete', 1, N'Entregue', 3, 1, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (11, CAST(N'2026-04-26T19:06:30.7118270' AS DateTime2), CAST(2500.00 AS Decimal(10, 2)), N'Intel i7 12700K', N'CPU', 5, N'Entregue', 3, 2, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (12, CAST(N'2026-04-26T19:06:30.7160644' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'Ryzen 9 5900X', N'CPU', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (13, CAST(N'2026-04-26T19:06:30.7183908' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'RTX 3060', N'GPU', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (14, CAST(N'2026-04-26T19:06:30.7209094' AS DateTime2), CAST(1150.00 AS Decimal(10, 2)), N'8GB DDR4', N'RAM', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (15, CAST(N'2026-04-26T19:06:30.7237252' AS DateTime2), CAST(1500.00 AS Decimal(10, 2)), N'B450M', N'PlacaMae', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (16, CAST(N'2026-04-26T19:06:30.7264904' AS DateTime2), CAST(1150.00 AS Decimal(10, 2)), N'SSD 240GB', N'SSD', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (17, CAST(N'2026-04-26T19:06:30.7291386' AS DateTime2), CAST(1200.00 AS Decimal(10, 2)), N'Fonte 400W', N'Fonte', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (18, CAST(N'2026-04-26T19:06:30.7318400' AS DateTime2), CAST(1300.00 AS Decimal(10, 2)), N'Gabinete Gamer RGB', N'Gabinete', 1, N'Entregue', 3, 2, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (19, CAST(N'2026-04-26T19:09:15.6340506' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 3, 3, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (20, CAST(N'2026-04-26T19:11:50.0214672' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 3, 4, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (21, CAST(N'2026-04-26T19:11:50.0252570' AS DateTime2), CAST(2500.00 AS Decimal(10, 2)), N'Intel i7 12700K', N'CPU', 1, N'Entregue', 3, 4, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (22, CAST(N'2026-04-26T19:13:54.9885989' AS DateTime2), CAST(1500.00 AS Decimal(10, 2)), N'Ryzen 3 4100', N'CPU', 1, N'Entregue', 2, 5, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (23, CAST(N'2026-04-26T19:13:55.0139208' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 2, 5, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1001, CAST(N'2026-05-20T23:46:47.2960357' AS DateTime2), CAST(1900.00 AS Decimal(10, 2)), N'Intel i5 12400F', N'CPU', 1, N'Entregue', 5, 1001, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1002, CAST(N'2026-05-20T23:46:47.3775263' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'Ryzen 9 5900X', N'CPU', 1, N'Entregue', 5, 1001, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1003, CAST(N'2026-05-22T00:20:06.2243100' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Cancelada', 6, 1002, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1004, CAST(N'2026-05-22T00:20:06.2481863' AS DateTime2), CAST(2500.00 AS Decimal(10, 2)), N'Intel i7 12700K', N'CPU', 1, N'Cancelada', 6, 1002, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1005, CAST(N'2026-05-22T00:20:31.2994345' AS DateTime2), CAST(1900.00 AS Decimal(10, 2)), N'Intel i5 12400F', N'CPU', 1, N'Cancelada', 3, 1003, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1006, CAST(N'2026-05-23T18:44:14.6705898' AS DateTime2), CAST(1500.00 AS Decimal(10, 2)), N'Ryzen 3 4100', N'CPU', 1, N'Entregue', 3, 1004, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1007, CAST(N'2026-05-23T18:44:14.7351512' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 3, 1004, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1008, CAST(N'2026-05-23T18:44:14.7409440' AS DateTime2), CAST(2100.00 AS Decimal(10, 2)), N'Intel i5 13400F', N'CPU', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1009, CAST(N'2026-05-23T18:44:14.7445504' AS DateTime2), CAST(2200.00 AS Decimal(10, 2)), N'GTX 1660', N'GPU', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1010, CAST(N'2026-05-23T18:44:14.7486177' AS DateTime2), CAST(1320.00 AS Decimal(10, 2)), N'Kingston Fury 16GB', N'RAM', 2, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1011, CAST(N'2026-05-23T18:44:14.7525018' AS DateTime2), CAST(1900.00 AS Decimal(10, 2)), N'B760', N'PlacaMae', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1012, CAST(N'2026-05-23T18:44:14.7566333' AS DateTime2), CAST(1350.00 AS Decimal(10, 2)), N'SSD RGB 512GB', N'SSD', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1013, CAST(N'2026-05-23T18:44:14.7604942' AS DateTime2), CAST(1300.00 AS Decimal(10, 2)), N'SSD NVMe 500GB', N'SSDNVME', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1014, CAST(N'2026-05-23T18:44:14.7644383' AS DateTime2), CAST(1200.00 AS Decimal(10, 2)), N'Fonte 400W', N'Fonte', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1015, CAST(N'2026-05-23T18:44:14.7682264' AS DateTime2), CAST(1300.00 AS Decimal(10, 2)), N'Gabinete Gamer RGB', N'Gabinete', 1, N'Entregue', 3, 1004, N'MontePC', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1016, CAST(N'2026-05-28T20:17:17.2249684' AS DateTime2), CAST(1500.00 AS Decimal(10, 2)), N'Ryzen 3 4100', N'CPU', 1, N'Entregue', 2, 1005, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (1017, CAST(N'2026-05-28T20:17:17.4532849' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 2, 1005, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2016, CAST(N'2026-06-01T19:40:03.1697823' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 5, 2005, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2017, CAST(N'2026-06-01T19:58:14.6978961' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 5, 2006, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2018, CAST(N'2026-06-01T19:58:14.7005717' AS DateTime2), CAST(2500.00 AS Decimal(10, 2)), N'Intel i7 12700K', N'CPU', 1, N'Entregue', 5, 2006, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2019, CAST(N'2026-06-01T19:58:35.0183069' AS DateTime2), CAST(1500.00 AS Decimal(10, 2)), N'Ryzen 3 4100', N'CPU', 1, N'Entregue', 5, 2007, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2020, CAST(N'2026-06-01T19:58:35.0192375' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 5, 2007, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2021, CAST(N'2026-06-01T20:08:49.0393869' AS DateTime2), CAST(3500.00 AS Decimal(10, 2)), N'Intel i9 12900K', N'CPU', 1, N'Entregue', 5, 2008, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2022, CAST(N'2026-06-01T20:08:49.0808698' AS DateTime2), CAST(2500.00 AS Decimal(10, 2)), N'Intel i7 12700K', N'CPU', 1, N'Entregue', 5, 2008, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2023, CAST(N'2026-06-01T20:11:47.8558862' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'Ryzen 9 5900X', N'CPU', 2, N'Entregue', 4, 2009, N'Carrinho', NULL)
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2024, CAST(N'2026-06-01T20:11:58.2393470' AS DateTime2), CAST(2800.00 AS Decimal(10, 2)), N'Ryzen 9 5900X', N'CPU', 4, N'Perda', 4, 2010, N'Carrinho', N'Defeito')
INSERT [dbo].[Vendas] ([Id], [Data], [Preco], [ProdutoNome], [ProdutoTipo], [Quantidade], [Status], [UsuarioId], [CompraId], [Origem], [MotivoDevolicao]) VALUES (2025, CAST(N'2026-06-01T20:17:02.3284126' AS DateTime2), CAST(1900.00 AS Decimal(10, 2)), N'Intel i5 12400F', N'CPU', 1, N'Devolvida', 4, 2011, N'Carrinho', N'Desistencia')
SET IDENTITY_INSERT [dbo].[Vendas] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Usuarios__A9D105341B48ABA8]    Script Date: 02/06/2026 21:06:10 ******/
ALTER TABLE [dbo].[Usuarios] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Usuarios__A9D105346E4E60B6]    Script Date: 02/06/2026 21:06:10 ******/
ALTER TABLE [dbo].[Usuarios] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Compras] ADD  DEFAULT (getdate()) FOR [DataCompra]
GO
ALTER TABLE [dbo].[Compras] ADD  DEFAULT ('Ativa') FOR [Status]
GO
ALTER TABLE [dbo].[Produtos] ADD  DEFAULT ((0)) FOR [Quantidade]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [dbo].[CompraItens]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([Id])
GO
ALTER TABLE [dbo].[CompraItens]  WITH CHECK ADD FOREIGN KEY([CompraId])
REFERENCES [dbo].[Compras] ([Id])
GO
ALTER TABLE [dbo].[Compras]  WITH CHECK ADD FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
ALTER TABLE [dbo].[Compras]  WITH CHECK ADD FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([Id])
GO
USE [master]
GO
ALTER DATABASE [TechHouse IndustryDB] SET  READ_WRITE 
GO
GO

-- =====================================================================
-- PARTE B - ETAPA 7 (PIM IV)
-- =====================================================================
-- =====================================================================
-- TechBuild (PIM IV) - ETAPA 7: Programacao de Banco de Dados
-- Banco: [TechHouse IndustryDB] (SQL Server)
--
-- Este script ATUALIZA o banco que ja existe. Ele NAO apaga tabelas
-- nem dados. Pode ser executado mais de uma vez sem problema.
--
-- O que ele cria:
--   PARTE 1 - Integridade: chaves estrangeiras e regras (CHECK) que faltavam
--   PARTE 2 - Indices para deixar as consultas mais rapidas
--   PARTE 3 - Tabelas novas: auditoria (LogAuditoria) e carrinho salvo (CarrinhoItens)
--   PARTE 4 - Triggers (acoes automaticas do banco)
--   PARTE 5 - Stored procedures (regras de negocio dentro do banco)
--   PARTE 6 - Views (consultas prontas para relatorios)
--
-- As procedures sao chamadas pela API (.NET), que e usada pelo site
-- e pelo aplicativo mobile.
-- =====================================================================

USE [TechHouse IndustryDB];
GO

-- =====================================================================
-- PARTE 1 - INTEGRIDADE DOS DADOS
-- =====================================================================

-- A tabela Vendas guardava UsuarioId e CompraId, mas o banco nao
-- garantia que eles existiam. As chaves estrangeiras (FK) garantem.
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Vendas_Usuarios')
    ALTER TABLE dbo.Vendas ADD CONSTRAINT FK_Vendas_Usuarios
        FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuarios(Id);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Vendas_Compras')
    ALTER TABLE dbo.Vendas ADD CONSTRAINT FK_Vendas_Compras
        FOREIGN KEY (CompraId) REFERENCES dbo.Compras(Id);
GO

-- Regras simples que o proprio banco passa a recusar:
-- estoque negativo, preco negativo e status desconhecido.
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Produtos_Quantidade')
    ALTER TABLE dbo.Produtos ADD CONSTRAINT CK_Produtos_Quantidade CHECK (Quantidade >= 0);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Produtos_Preco')
    ALTER TABLE dbo.Produtos ADD CONSTRAINT CK_Produtos_Preco CHECK (Preco >= 0);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Vendas_Quantidade')
    ALTER TABLE dbo.Vendas ADD CONSTRAINT CK_Vendas_Quantidade CHECK (Quantidade > 0);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Vendas_Status')
    ALTER TABLE dbo.Vendas ADD CONSTRAINT CK_Vendas_Status CHECK
        (Status IN (N'Em Preparo', N'Em Transporte', N'Entregue', N'Cancelada', N'Devolvida', N'Perda'));
GO

-- =====================================================================
-- PARTE 2 - INDICES
-- Um indice funciona como o indice de um livro: o banco acha as linhas
-- sem precisar ler a tabela inteira.
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Compras_UsuarioId')
    CREATE INDEX IX_Compras_UsuarioId ON dbo.Compras(UsuarioId);          -- "minhas compras"
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CompraItens_CompraId')
    CREATE INDEX IX_CompraItens_CompraId ON dbo.CompraItens(CompraId);    -- itens de uma compra
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Vendas_CompraId')
    CREATE INDEX IX_Vendas_CompraId ON dbo.Vendas(CompraId);              -- vendas de uma compra
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Vendas_UsuarioId')
    CREATE INDEX IX_Vendas_UsuarioId ON dbo.Vendas(UsuarioId);            -- vendas de um cliente
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Produtos_Nome')
    CREATE INDEX IX_Produtos_Nome ON dbo.Produtos(Nome);                  -- busca de produto pelo nome
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Produtos_Tipo')
    CREATE INDEX IX_Produtos_Tipo ON dbo.Produtos(Tipo);                  -- filtro por categoria
GO

-- =====================================================================
-- PARTE 3 - TABELA DE AUDITORIA
-- Guarda um historico do que mudou (preco, estoque, status do pedido).
-- Quem preenche essa tabela sao os triggers da parte 4.
-- =====================================================================
IF OBJECT_ID('dbo.LogAuditoria', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.LogAuditoria (
        Id          INT IDENTITY(1,1) PRIMARY KEY,
        Tabela      NVARCHAR(50)  NOT NULL,   -- em qual tabela aconteceu
        Acao        NVARCHAR(20)  NOT NULL,   -- INSERT, UPDATE ou DELETE
        RegistroId  INT           NOT NULL,   -- Id da linha alterada
        Descricao   NVARCHAR(500) NOT NULL,   -- o que mudou, em texto
        DataHora    DATETIME      NOT NULL DEFAULT (GETDATE())
    );
END
GO

-- CARRINHO SALVO NO BANCO
-- Antes o carrinho ficava so na memoria do navegador/celular e sumia ao fechar.
-- Agora cada item fica gravado aqui, ligado ao usuario. Assim o mesmo carrinho
-- aparece no site e no app quando a pessoa entra na mesma conta.
IF OBJECT_ID('dbo.CarrinhoItens', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CarrinhoItens (
        Id           INT IDENTITY(1,1) PRIMARY KEY,
        UsuarioId    INT          NOT NULL,
        ProdutoId    INT          NOT NULL,
        Quantidade   INT          NOT NULL,
        Origem       NVARCHAR(20) NOT NULL DEFAULT (N'Carrinho'),  -- 'Carrinho' ou 'MontePC'
        AtualizadoEm DATETIME     NOT NULL DEFAULT (GETDATE()),
        CONSTRAINT FK_CarrinhoItens_Usuarios FOREIGN KEY (UsuarioId) REFERENCES dbo.Usuarios(Id),
        -- se o produto for excluido, ele sai sozinho de todos os carrinhos
        CONSTRAINT FK_CarrinhoItens_Produtos FOREIGN KEY (ProdutoId) REFERENCES dbo.Produtos(Id) ON DELETE CASCADE,
        CONSTRAINT CK_CarrinhoItens_Quantidade CHECK (Quantidade > 0),
        CONSTRAINT CK_CarrinhoItens_Origem CHECK (Origem IN (N'Carrinho', N'MontePC')),
        -- o mesmo produto aparece uma vez so por usuario e origem
        CONSTRAINT UQ_CarrinhoItens UNIQUE (UsuarioId, ProdutoId, Origem)
    );
END
GO

-- Indice para achar rapido o ultimo registro do log (usado na "versao do catalogo")
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_LogAuditoria_Tabela')
    CREATE INDEX IX_LogAuditoria_Tabela ON dbo.LogAuditoria(Tabela, Id);
GO

-- =====================================================================
-- PARTE 4 - TRIGGERS
-- Trigger = codigo que o banco executa SOZINHO quando algo acontece
-- em uma tabela (inserir, alterar ou excluir).
-- Dentro do trigger existem duas tabelas temporarias:
--   inserted = como a linha ficou      deleted = como a linha era antes
-- =====================================================================

-- TRIGGER 1: auditoria de produtos.
-- Toda vez que um produto e criado, alterado ou excluido, grava no log.
CREATE OR ALTER TRIGGER dbo.trg_Produtos_Auditoria
ON dbo.Produtos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Produto novo (so existe em inserted)
    INSERT INTO dbo.LogAuditoria (Tabela, Acao, RegistroId, Descricao)
    SELECT N'Produtos', N'INSERT', i.Id,
           N'Produto criado: ' + ISNULL(i.Nome, N'') + N' | estoque ' + CAST(i.Quantidade AS NVARCHAR(20))
    FROM inserted i
    WHERE NOT EXISTS (SELECT 1 FROM deleted d WHERE d.Id = i.Id);

    -- Produto excluido (so existe em deleted)
    INSERT INTO dbo.LogAuditoria (Tabela, Acao, RegistroId, Descricao)
    SELECT N'Produtos', N'DELETE', d.Id, N'Produto excluido: ' + ISNULL(d.Nome, N'')
    FROM deleted d
    WHERE NOT EXISTS (SELECT 1 FROM inserted i WHERE i.Id = d.Id);

    -- Produto alterado: registra qualquer mudanca (preco, estoque, nome, especificacoes...)
    INSERT INTO dbo.LogAuditoria (Tabela, Acao, RegistroId, Descricao)
    SELECT N'Produtos', N'UPDATE', i.Id,
           ISNULL(i.Nome, N'') +
           CASE WHEN ISNULL(d.Preco, -1) <> ISNULL(i.Preco, -1)
                THEN N' | preco ' + CAST(d.Preco AS NVARCHAR(20)) + N' -> ' + CAST(i.Preco AS NVARCHAR(20)) ELSE N'' END +
           CASE WHEN d.Quantidade <> i.Quantidade
                THEN N' | estoque ' + CAST(d.Quantidade AS NVARCHAR(20)) + N' -> ' + CAST(i.Quantidade AS NVARCHAR(20)) ELSE N'' END +
           CASE WHEN ISNULL(d.Nome, N'') <> ISNULL(i.Nome, N'')
                  OR ISNULL(d.Tipo, N'') <> ISNULL(i.Tipo, N'')
                  OR ISNULL(d.Socket, N'') <> ISNULL(i.Socket, N'')
                  OR ISNULL(d.ConsumoEnergia, -1) <> ISNULL(i.ConsumoEnergia, -1)
                  OR ISNULL(d.Potencia, -1) <> ISNULL(i.Potencia, -1)
                  OR ISNULL(d.ImagemUrl, N'') <> ISNULL(i.ImagemUrl, N'')
                THEN N' | dados do produto alterados' ELSE N'' END
    FROM inserted i
    JOIN deleted d ON d.Id = i.Id
    WHERE ISNULL(d.Preco, -1) <> ISNULL(i.Preco, -1)
       OR d.Quantidade <> i.Quantidade
       OR ISNULL(d.Nome, N'') <> ISNULL(i.Nome, N'')
       OR ISNULL(d.Tipo, N'') <> ISNULL(i.Tipo, N'')
       OR ISNULL(d.Socket, N'') <> ISNULL(i.Socket, N'')
       OR ISNULL(d.ConsumoEnergia, -1) <> ISNULL(i.ConsumoEnergia, -1)
       OR ISNULL(d.Potencia, -1) <> ISNULL(i.Potencia, -1)
       OR ISNULL(d.ImagemUrl, N'') <> ISNULL(i.ImagemUrl, N'');
END
GO

-- TRIGGER 2: valida a mudanca de status do pedido (regra de negocio).
-- Caminho permitido:
--   Em Preparo -> Em Transporte -> Entregue -> Devolvida / Perda
--   Em Preparo -> Cancelada
-- Qualquer outra mudanca (ex.: Entregue -> Em Preparo) e recusada.
CREATE OR ALTER TRIGGER dbo.trg_Vendas_ValidarStatus
ON dbo.Vendas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(Status) RETURN;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON d.Id = i.Id
        WHERE ISNULL(d.Status, N'') <> ISNULL(i.Status, N'')
          AND NOT (
                (d.Status = N'Em Preparo'    AND i.Status IN (N'Em Transporte', N'Cancelada'))
             OR (d.Status = N'Em Transporte' AND i.Status =  N'Entregue')
             OR (d.Status = N'Entregue'      AND i.Status IN (N'Devolvida', N'Perda'))
          )
    )
    BEGIN
        ;THROW 50020, N'Mudanca de status nao permitida para este pedido.', 1;
    END

    -- Mudanca valida: grava no log
    INSERT INTO dbo.LogAuditoria (Tabela, Acao, RegistroId, Descricao)
    SELECT N'Vendas', N'UPDATE', i.Id,
           N'Compra #' + CAST(ISNULL(i.CompraId, 0) AS NVARCHAR(20)) + N' | ' + ISNULL(i.ProdutoNome, N'') +
           N' | status ' + ISNULL(d.Status, N'') + N' -> ' + ISNULL(i.Status, N'')
    FROM inserted i
    JOIN deleted d ON d.Id = i.Id
    WHERE ISNULL(d.Status, N'') <> ISNULL(i.Status, N'');
END
GO

-- TRIGGER 3: mantem o status da COMPRA igual ao status dos seus itens.
-- Ex.: se todos os itens da compra ficaram "Entregue", a compra fica "Entregue".
-- Se os itens estao em status diferentes, a compra fica "Parcial".
CREATE OR ALTER TRIGGER dbo.trg_Vendas_AtualizarStatusCompra
ON dbo.Vendas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(Status) RETURN;

    UPDATE c
    SET c.Status = CASE WHEN r.QtdStatus = 1 THEN r.UnicoStatus ELSE N'Parcial' END
    FROM dbo.Compras c
    JOIN (
        SELECT v.CompraId,
               COUNT(DISTINCT v.Status) AS QtdStatus,
               MIN(v.Status)            AS UnicoStatus
        FROM dbo.Vendas v
        WHERE v.CompraId IN (SELECT CompraId FROM inserted WHERE CompraId IS NOT NULL)
        GROUP BY v.CompraId
    ) r ON r.CompraId = c.Id;
END
GO

-- =====================================================================
-- PARTE 5 - STORED PROCEDURES
-- Procedure = um "metodo" guardado no banco. A API so chama:
--   EXEC dbo.sp_FinalizarCompra ...
-- e o banco faz todo o trabalho dentro de uma TRANSACAO
-- (ou faz tudo, ou nao faz nada).
-- Os erros usam THROW com numero 50000+; a API devolve a mensagem
-- para o site/app.
-- =====================================================================

-- PROCEDURE 1: finaliza uma compra.
-- Recebe os itens em JSON, ex.: [{"nome":"RTX 3060","quantidade":1,"origem":"Carrinho"}]
-- 1) confere usuario, produtos e estoque
-- 2) baixa o estoque
-- 3) grava Compras, CompraItens e Vendas e esvazia o carrinho salvo
-- 4) devolve o numero da compra em @CompraId
CREATE OR ALTER PROCEDURE dbo.sp_FinalizarCompra
    @UsuarioId INT,
    @ItensJson NVARCHAR(MAX),
    @CompraId  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;   -- se der qualquer erro, desfaz a transacao inteira

    IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE Id = @UsuarioId)
        THROW 50001, N'Usuario nao encontrado.', 1;

    IF ISJSON(@ItensJson) <> 1
        THROW 50002, N'Lista de itens invalida.', 1;

    -- Le o JSON e transforma em uma tabela temporaria
    DECLARE @Itens TABLE (Nome NVARCHAR(200), Quantidade INT, Origem NVARCHAR(30));

    INSERT INTO @Itens (Nome, Quantidade, Origem)
    SELECT LTRIM(RTRIM(j.nome)),
           j.quantidade,
           CASE WHEN j.origem = N'MontePC' THEN N'MontePC' ELSE N'Carrinho' END
    FROM OPENJSON(@ItensJson)
         WITH (nome NVARCHAR(200) '$.nome', quantidade INT '$.quantidade', origem NVARCHAR(30) '$.origem') j;

    IF NOT EXISTS (SELECT 1 FROM @Itens)
        THROW 50003, N'A compra nao tem itens.', 1;

    IF EXISTS (SELECT 1 FROM @Itens WHERE ISNULL(Nome, N'') = N'' OR ISNULL(Quantidade, 0) <= 0 OR Quantidade > 1000)
        THROW 50004, N'Ha item com nome ou quantidade invalidos.', 1;

    DECLARE @Msg NVARCHAR(400);

    -- Produto que nao existe no catalogo
    DECLARE @Faltando NVARCHAR(200) =
        (SELECT TOP 1 i.Nome FROM @Itens i
         WHERE NOT EXISTS (SELECT 1 FROM dbo.Produtos p WHERE p.Nome = i.Nome));
    IF @Faltando IS NOT NULL
    BEGIN
        SET @Msg = N'Produto nao encontrado: ' + @Faltando + N'.';
        THROW 50005, @Msg, 1;
    END

    -- Liga cada item ao produto do banco (preco e tipo vem do banco, nao do app)
    DECLARE @ItensProduto TABLE (ProdutoId INT, Nome NVARCHAR(200), Tipo NVARCHAR(100),
                                 Preco DECIMAL(10,2), Quantidade INT, Origem NVARCHAR(30));
    INSERT INTO @ItensProduto
    SELECT p.Id, p.Nome, ISNULL(p.Tipo, N''), ISNULL(p.Preco, 0), i.Quantidade, i.Origem
    FROM @Itens i
    CROSS APPLY (SELECT TOP 1 Id, Nome, Tipo, Preco FROM dbo.Produtos WHERE Nome = i.Nome ORDER BY Id) p;

    BEGIN TRANSACTION;

        -- Confere estoque travando as linhas (ninguem compra o mesmo item ao mesmo tempo)
        DECLARE @SemEstoque NVARCHAR(200) =
            (SELECT TOP 1 ip.Nome
             FROM (SELECT ProdutoId, Nome, SUM(Quantidade) AS Total FROM @ItensProduto GROUP BY ProdutoId, Nome) ip
             JOIN dbo.Produtos p WITH (UPDLOCK, HOLDLOCK) ON p.Id = ip.ProdutoId
             WHERE p.Quantidade < ip.Total);
        IF @SemEstoque IS NOT NULL
        BEGIN
            SET @Msg = N'Estoque insuficiente para ' + @SemEstoque + N'.';
            THROW 50006, @Msg, 1;
        END

        -- Baixa o estoque
        UPDATE p
        SET p.Quantidade = p.Quantidade - ip.Total
        FROM dbo.Produtos p
        JOIN (SELECT ProdutoId, SUM(Quantidade) AS Total FROM @ItensProduto GROUP BY ProdutoId) ip
          ON ip.ProdutoId = p.Id;

        -- Data e hora do Brasil
        DECLARE @Agora DATETIME = CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'E. South America Standard Time' AS DATETIME);

        -- Cabecalho da compra
        INSERT INTO dbo.Compras (UsuarioId, DataCompra, Status)
        VALUES (@UsuarioId, @Agora, N'Em Preparo');
        SET @CompraId = SCOPE_IDENTITY();

        -- Itens da compra
        INSERT INTO dbo.CompraItens (CompraId, ProdutoNome, ProdutoTipo, Preco, Quantidade, Origem)
        SELECT @CompraId, Nome, Tipo, Preco, Quantidade, Origem FROM @ItensProduto;

        -- Uma venda por item (e o que o admin acompanha e muda de status)
        INSERT INTO dbo.Vendas (UsuarioId, CompraId, ProdutoNome, ProdutoTipo, Preco, Quantidade, Origem, Status, Data)
        SELECT @UsuarioId, @CompraId, Nome, Tipo, Preco, Quantidade, Origem, N'Em Preparo', @Agora FROM @ItensProduto;

        -- Compra feita: esvazia o carrinho salvo do usuario
        DELETE FROM dbo.CarrinhoItens WHERE UsuarioId = @UsuarioId;

    COMMIT TRANSACTION;
END
GO

-- PROCEDURE 2: cancela a compra inteira.
-- So pode se TODOS os itens ainda estiverem "Em Preparo" (nao enviados).
-- Devolve os itens ao estoque.
CREATE OR ALTER PROCEDURE dbo.sp_CancelarCompra
    @CompraId  INT,
    @UsuarioId INT,     -- quem esta pedindo o cancelamento
    @IsAdmin   BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Dono INT = (SELECT UsuarioId FROM dbo.Compras WHERE Id = @CompraId);

    IF @Dono IS NULL
        THROW 50010, N'Compra nao encontrada.', 1;

    IF @Dono <> @UsuarioId AND @IsAdmin = 0
        THROW 50011, N'Voce nao tem permissao para cancelar esta compra.', 1;

    IF EXISTS (SELECT 1 FROM dbo.Vendas WHERE CompraId = @CompraId AND Status NOT IN (N'Em Preparo', N'Cancelada'))
        THROW 50012, N'Nao e possivel cancelar: um ou mais itens ja foram enviados.', 1;

    BEGIN TRANSACTION;

        -- Devolve ao estoque os itens que ainda estavam em preparo
        UPDATE p
        SET p.Quantidade = p.Quantidade + v.Total
        FROM dbo.Produtos p
        JOIN (SELECT ProdutoNome, SUM(Quantidade) AS Total
              FROM dbo.Vendas
              WHERE CompraId = @CompraId AND Status = N'Em Preparo'
              GROUP BY ProdutoNome) v
          ON p.Id = (SELECT TOP 1 Id FROM dbo.Produtos WHERE Nome = v.ProdutoNome ORDER BY Id);

        UPDATE dbo.Vendas  SET Status = N'Cancelada' WHERE CompraId = @CompraId AND Status = N'Em Preparo';
        UPDATE dbo.Compras SET Status = N'Cancelada' WHERE Id = @CompraId;

    COMMIT TRANSACTION;
END
GO

-- PROCEDURE 3: cancela um item (venda) da compra.
CREATE OR ALTER PROCEDURE dbo.sp_CancelarVenda
    @VendaId   INT,
    @UsuarioId INT,
    @IsAdmin   BIT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Dono INT, @Status NVARCHAR(50), @Produto NVARCHAR(200), @Qtd INT;
    SELECT @Dono = UsuarioId, @Status = Status, @Produto = ProdutoNome, @Qtd = Quantidade
    FROM dbo.Vendas WHERE Id = @VendaId;

    IF @Dono IS NULL
        THROW 50030, N'Venda nao encontrada.', 1;
    IF @Dono <> @UsuarioId AND @IsAdmin = 0
        THROW 50031, N'Voce nao tem permissao para cancelar este item.', 1;
    IF @Status <> N'Em Preparo'
        THROW 50032, N'Nao e possivel cancelar: pedido ja foi enviado.', 1;

    BEGIN TRANSACTION;
        UPDATE dbo.Vendas SET Status = N'Cancelada' WHERE Id = @VendaId;
        UPDATE dbo.Produtos SET Quantidade = Quantidade + @Qtd
        WHERE Id = (SELECT TOP 1 Id FROM dbo.Produtos WHERE Nome = @Produto ORDER BY Id);
    COMMIT TRANSACTION;
END
GO

-- PROCEDURE 4: admin avanca o status do item.
-- Em Preparo -> Em Transporte -> Entregue
CREATE OR ALTER PROCEDURE dbo.sp_AvancarStatusVenda
    @VendaId    INT,
    @NovoStatus NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Atual NVARCHAR(50) = (SELECT Status FROM dbo.Vendas WHERE Id = @VendaId);
    IF @Atual IS NULL
        THROW 50040, N'Venda nao encontrada.', 1;

    SET @NovoStatus = CASE @Atual
                          WHEN N'Em Preparo'    THEN N'Em Transporte'
                          WHEN N'Em Transporte' THEN N'Entregue'
                          ELSE @Atual            -- ja esta no fim: nao muda
                      END;

    IF @NovoStatus <> @Atual
        UPDATE dbo.Vendas SET Status = @NovoStatus WHERE Id = @VendaId;
END
GO

-- PROCEDURE 5: cliente devolve um item ja entregue.
-- Motivo "Defeito" -> status "Perda" (nao volta ao estoque)
-- Outros motivos   -> status "Devolvida" (volta ao estoque)
CREATE OR ALTER PROCEDURE dbo.sp_DevolverVenda
    @VendaId     INT,
    @UsuarioId   INT,
    @IsAdmin     BIT,
    @Motivo      NVARCHAR(50),           -- "Defeito" | "Desistencia" | "Outro"
    @MotivoTexto NVARCHAR(200) = NULL,   -- usado quando o motivo e "Outro"
    @NovoStatus  NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Dono INT, @Status NVARCHAR(50), @Produto NVARCHAR(200), @Qtd INT;
    SELECT @Dono = UsuarioId, @Status = Status, @Produto = ProdutoNome, @Qtd = Quantidade
    FROM dbo.Vendas WHERE Id = @VendaId;

    IF @Dono IS NULL
        THROW 50050, N'Venda nao encontrada.', 1;
    IF @Dono <> @UsuarioId AND @IsAdmin = 0
        THROW 50051, N'Voce nao tem permissao para devolver este item.', 1;
    IF @Status <> N'Entregue'
        THROW 50052, N'So e possivel devolver um pedido ja entregue.', 1;
    IF ISNULL(LTRIM(RTRIM(@Motivo)), N'') = N''
        THROW 50053, N'Informe o motivo da devolucao.', 1;

    DECLARE @TextoMotivo NVARCHAR(500) =
        CASE WHEN @Motivo = N'Defeito' THEN N'Defeito'
             WHEN @Motivo = N'Outro' AND ISNULL(LTRIM(RTRIM(@MotivoTexto)), N'') <> N''
                  THEN N'Outro: ' + LTRIM(RTRIM(@MotivoTexto))
             ELSE @Motivo END;

    SET @NovoStatus = CASE WHEN @Motivo = N'Defeito' THEN N'Perda' ELSE N'Devolvida' END;

    BEGIN TRANSACTION;
        UPDATE dbo.Vendas
        SET Status = @NovoStatus, MotivoDevolicao = @TextoMotivo
        WHERE Id = @VendaId;

        IF @NovoStatus = N'Devolvida'
            UPDATE dbo.Produtos SET Quantidade = Quantidade + @Qtd
            WHERE Id = (SELECT TOP 1 Id FROM dbo.Produtos WHERE Nome = @Produto ORDER BY Id);
    COMMIT TRANSACTION;
END
GO

-- PROCEDURE 6: resumo do dashboard do administrador.
-- Mesma regra do site: vendas ativas somam; devolucoes e perdas subtraem.
CREATE OR ALTER PROCEDURE dbo.sp_DashboardResumo
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CAST(ISNULL(SUM(CASE WHEN Status IN (N'Em Preparo', N'Em Transporte', N'Entregue') THEN Preco * Quantidade
                             WHEN Status IN (N'Devolvida', N'Perda')                         THEN -Preco * Quantidade
                             ELSE 0 END), 0) AS DECIMAL(12,2))           AS TotalVendido,
        COUNT(*)                                                         AS TotalRegistros,
        SUM(CASE WHEN Status IN (N'Em Preparo', N'Em Transporte', N'Entregue') THEN 1 ELSE 0 END) AS QtdVendas,
        SUM(CASE WHEN Status = N'Devolvida' THEN 1 ELSE 0 END)           AS QtdDevolucoes,
        SUM(CASE WHEN Status = N'Cancelada' THEN 1 ELSE 0 END)           AS QtdCancelamentos,
        SUM(CASE WHEN Status = N'Perda'     THEN 1 ELSE 0 END)           AS QtdPerdas,
        SUM(CASE WHEN Status = N'Em Preparo' THEN 1 ELSE 0 END)          AS QtdEmPreparo,
        SUM(CASE WHEN Status = N'Em Transporte' THEN 1 ELSE 0 END)       AS QtdEmTransporte
    FROM dbo.Vendas;
END
GO

-- PROCEDURE 7: produtos mais vendidos (so vendas que nao foram canceladas/devolvidas).
CREATE OR ALTER PROCEDURE dbo.sp_ProdutosMaisVendidos
    @Top INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@Top)
        ProdutoNome,
        SUM(Quantidade)                              AS QuantidadeVendida,
        CAST(SUM(Preco * Quantidade) AS DECIMAL(12,2)) AS Faturamento
    FROM dbo.Vendas
    WHERE Status IN (N'Em Preparo', N'Em Transporte', N'Entregue')
    GROUP BY ProdutoNome
    ORDER BY SUM(Quantidade) DESC;
END
GO

-- PROCEDURE 8: renda por periodo (dia, mes ou ano).
-- Renda  = vendas ativas      Perdas = canceladas, devolvidas e perdas
CREATE OR ALTER PROCEDURE dbo.sp_RendaPorPeriodo
    @Agrupamento NVARCHAR(10) = N'dia'   -- 'dia' | 'mes' | 'ano'
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Base AS (
        SELECT v.Preco * v.Quantidade AS Valor,
               v.Status,
               ISNULL(c.DataCompra, v.Data) AS DataVenda
        FROM dbo.Vendas v
        LEFT JOIN dbo.Compras c ON c.Id = v.CompraId
    )
    SELECT
        CASE @Agrupamento
            WHEN N'ano' THEN FORMAT(DataVenda, 'yyyy')
            WHEN N'mes' THEN FORMAT(DataVenda, 'MM/yyyy')
            ELSE             FORMAT(DataVenda, 'dd/MM/yyyy')
        END AS Periodo,
        CAST(SUM(CASE WHEN Status IN (N'Em Preparo', N'Em Transporte', N'Entregue') THEN Valor ELSE 0 END) AS DECIMAL(12,2)) AS Renda,
        CAST(SUM(CASE WHEN Status IN (N'Cancelada', N'Devolvida', N'Perda')        THEN Valor ELSE 0 END) AS DECIMAL(12,2)) AS Perdas,
        MIN(DataVenda) AS Ordem
    FROM Base
    GROUP BY CASE @Agrupamento
                 WHEN N'ano' THEN FORMAT(DataVenda, 'yyyy')
                 WHEN N'mes' THEN FORMAT(DataVenda, 'MM/yyyy')
                 ELSE             FORMAT(DataVenda, 'dd/MM/yyyy')
             END
    ORDER BY MIN(DataVenda);
END
GO

-- PROCEDURE 9: "versao" do catalogo, usada na ATUALIZACAO EM TEMPO REAL.
-- Toda mudanca em Produtos gera uma linha no LogAuditoria (trigger 1),
-- entao o maior Id do log muda sempre que algum produto muda.
-- O site e o app perguntam esse numero a cada 3 segundos: se mudou,
-- recarregam a lista de produtos sem precisar apertar F5.
CREATE OR ALTER PROCEDURE dbo.sp_VersaoCatalogo
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ISNULL(MAX(Id), 0) AS Versao FROM dbo.LogAuditoria WHERE Tabela = N'Produtos';
END
GO

-- PROCEDURE 10: salva o carrinho do usuario (substitui o que estava salvo).
-- Recebe JSON, ex.: [{"produtoId":8,"quantidade":2,"origem":"Carrinho"}]
-- Ignora produtos que nao existem e limita a quantidade ao estoque.
CREATE OR ALTER PROCEDURE dbo.sp_SalvarCarrinho
    @UsuarioId INT,
    @ItensJson NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE Id = @UsuarioId)
        THROW 50060, N'Usuario nao encontrado.', 1;
    IF ISJSON(@ItensJson) <> 1
        THROW 50061, N'Carrinho invalido.', 1;

    BEGIN TRANSACTION;
        DELETE FROM dbo.CarrinhoItens WHERE UsuarioId = @UsuarioId;

        INSERT INTO dbo.CarrinhoItens (UsuarioId, ProdutoId, Quantidade, Origem)
        SELECT @UsuarioId,
               p.Id,
               CASE WHEN SUM(j.quantidade) > p.Quantidade THEN p.Quantidade ELSE SUM(j.quantidade) END,
               CASE WHEN j.origem = N'MontePC' THEN N'MontePC' ELSE N'Carrinho' END
        FROM OPENJSON(@ItensJson)
             WITH (produtoId INT '$.produtoId', quantidade INT '$.quantidade', origem NVARCHAR(20) '$.origem') j
        JOIN dbo.Produtos p ON p.Id = j.produtoId
        WHERE j.quantidade > 0 AND p.Quantidade > 0
        GROUP BY p.Id, p.Quantidade, CASE WHEN j.origem = N'MontePC' THEN N'MontePC' ELSE N'Carrinho' END;
    COMMIT TRANSACTION;
END
GO

-- PROCEDURE 11: devolve o carrinho salvo do usuario
CREATE OR ALTER PROCEDURE dbo.sp_ObterCarrinho
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT c.ProdutoId, c.Quantidade, c.Origem
    FROM dbo.CarrinhoItens c
    WHERE c.UsuarioId = @UsuarioId
    ORDER BY c.Origem, c.Id;
END
GO

-- =====================================================================
-- PARTE 6 - VIEWS
-- View = uma consulta salva com nome, usada como se fosse uma tabela.
-- =====================================================================

-- Pedidos com nome do cliente e cada item (relatorio geral)
CREATE OR ALTER VIEW dbo.vw_PedidosDetalhados
AS
SELECT
    c.Id                                 AS CompraId,
    c.DataCompra,
    c.Status                             AS StatusCompra,
    u.Id                                 AS UsuarioId,
    ISNULL(u.Nome, u.Email)              AS Cliente,
    v.Id                                 AS VendaId,
    v.ProdutoNome,
    v.ProdutoTipo,
    v.Quantidade,
    v.Preco,
    v.Preco * v.Quantidade               AS Subtotal,
    v.Status                             AS StatusItem,
    v.Origem
FROM dbo.Compras c
JOIN dbo.Usuarios u ON u.Id = c.UsuarioId
JOIN dbo.Vendas   v ON v.CompraId = c.Id;
GO

-- Produtos com estoque baixo (2 unidades ou menos) - alerta para reposicao
CREATE OR ALTER VIEW dbo.vw_EstoqueBaixo
AS
SELECT Id, Nome, Tipo, Quantidade
FROM dbo.Produtos
WHERE Quantidade <= 2;
GO

PRINT N'Etapa 7 aplicada com sucesso: integridade, indices, auditoria, triggers, procedures e views.';
GO
