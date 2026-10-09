#!/usr/bin/env bash
# Carrega no banco as intercorrencias de RH da Especificacao Dom Rock 
# gera o relatorio de pendencias.
# (./scripts/importar-dataset.sh), porque a classificacao cruza com a tabela funcionario.
# Uso: ./scripts/importar-intercorrencias.sh
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
SQL_FILE="$RAIZ/scripts/intercorrencias.sql"
RELATORIO="$RAIZ/docs/relatorio-pendencias-intercorrencias.md"
CONTAINER="${POSTGRES_CONTAINER:-postgres-camplana}"

if [ ! -f "$SQL_FILE" ]; then
  echo "Arquivo SQL nao encontrado em $SQL_FILE." >&2
  exit 1
fi

psql_db() {
  docker exec -i -e PGCLIENTENCODING=UTF8 "$CONTAINER" \
    sh -c 'exec psql -X -q -At -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
}

echo "Aguardando o banco no container $CONTAINER..."
pronto=""
for _ in $(seq 1 60); do
  pronto="$(echo "SELECT to_regclass('public.evento_rh') IS NOT NULL;" | psql_db 2>/dev/null || true)"
  [ "$pronto" = "t" ] && break
  sleep 2
done
if [ "$pronto" != "t" ]; then
  echo "Tabela evento_rh nao encontrada; suba o backend para o Flyway aplicar a V4." >&2
  exit 1
fi

FUNCIONARIOS="$(echo "SELECT count(*) FROM funcionario;" | psql_db)"
if [ "$FUNCIONARIOS" = "0" ]; then
  echo "Tabela funcionario vazia; rode ./scripts/importar-dataset.sh antes." >&2
  exit 1
fi

echo "Carregando intercorrencias e classificando pendencias..."
CORPO="$(psql_db < "$SQL_FILE")"

mkdir -p "$(dirname "$RELATORIO")"
{
  cat << 'EOF'
# Relatório de Pendências: Intercorrências da Especificação Dom Rock (jul a dez/2025)

Gerado por `scripts/importar-intercorrencias.sh` a partir de `scripts/intercorrencias.sql`.
O script não corrige nada, só lista: IMPEDITIVO não é carregado em `evento_rh`;
AVISO é carregado (se repetido, só a primeira ocorrência) e fica listado aqui.

EOF
  printf '%s\n' "$CORPO"
} > "$RELATORIO"

echo "Pronto. Relatorio em: $RELATORIO"