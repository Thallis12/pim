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
