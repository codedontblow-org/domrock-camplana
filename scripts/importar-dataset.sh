#!/usr/bin/env bash
# Carrega no banco as bases da Dom Rock (RH, vendas e % de comissão) de jul a dez/2025,
# um mês por chamada, pelo endpoint de importação do backend.
# Uso: ./scripts/importar-dataset.sh [URL do backend]   (padrão: http://localhost:8080)
set -euo pipefail

BACKEND="${1:-http://localhost:${BACKEND_HOST_PORT:-8080}}"
DATASET="$(cd "$(dirname "$0")/.." && pwd)/DomRock-Backend/docs/domrock-dataset"
MESES=(JUL25 AGO25 SET25 OUT25 NOV25 DEZ25)

if [ ! -d "$DATASET" ]; then
  echo "Dataset não encontrado em $DATASET; rode 'git submodule update --init --remote' antes." >&2
  exit 1
fi

# O backend cria as tabelas (Flyway) ao subir; espera até 2 min para ele responder.
echo "Aguardando o backend em $BACKEND..."
for _ in $(seq 1 60); do
  curl --silent --fail "$BACKEND/actuator/health" > /dev/null && break
  sleep 2
done
if ! curl --silent --fail "$BACKEND/actuator/health" > /dev/null; then
  echo "Backend não respondeu em $BACKEND/actuator/health; confira 'docker compose logs backend'." >&2
  exit 1
fi

for mes in "${MESES[@]}"; do
  echo "Importando $mes..."
  curl --fail --silent --show-error -X POST "$BACKEND/api/importacao" \
    -F "arquivos=@$DATASET/BASE RH_$mes.xlsx" \
    -F "arquivos=@$DATASET/BASE_VENDAS_$mes.xlsx" \
    -F "arquivos=@$DATASET/BASE_COMMISS_FINAL.xlsx" > /dev/null
done

echo "Pronto: jul a dez/2025 importados."
