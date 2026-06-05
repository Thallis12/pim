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
