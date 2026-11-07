#!/bin/bash
# Cria o banco TechHouse IndustryDB na PRIMEIRA vez que o docker compose sobe.
# Se o banco já existir, não faz nada (não apaga os dados).
SQLCMD="/opt/mssql-tools18/bin/sqlcmd -S sqlserver -U sa -P $SA_PASSWORD -C"

EXISTE=$($SQLCMD -h -1 -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.databases WHERE name = N'TechHouse IndustryDB'" | tr -d '[:space:]')

if [ "$EXISTE" = "0" ]; then
  echo "Criando o banco (tabelas, dados, procedures, triggers e views)..."
  $SQLCMD -i /scripts/bancoPIM_completo.sql
else
  echo "Banco já existe, nada a fazer."
fi
