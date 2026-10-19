#!/usr/bin/env bash
# Carrega no banco as bases da Dom Rock (RH, vendas e % de comissão) de jul a dez/2025,
# um mês por chamada, pelo endpoint de importação do backend.
# A importação é só do Supervisor: o script entra com o Sérgio do seed (V4 do backend).
# Uso: ./scripts/importar-dataset.sh [URL do backend]   (padrão: http://localhost:8080)
# Outro usuário: IMPORTAR_EMAIL=... IMPORTAR_SENHA=... ./scripts/importar-dataset.sh
set -euo pipefail

BACKEND="${1:-http://localhost:${BACKEND_HOST_PORT:-8080}}"
DATASET="$(cd "$(dirname "$0")/.." && pwd)/DomRock-Backend/docs/domrock-dataset"
MESES=(JUL25 AGO25 SET25 OUT25 NOV25 DEZ25)
EMAIL="${IMPORTAR_EMAIL:-sergio@camplana.com.br}"
SENHA="${IMPORTAR_SENHA:-123456}"

if [ ! -d "$DATASET" ]; then
  echo "Dataset não encontrado em $DATASET; rode 'git submodule update --init --remote' antes." >&2
  exit 1
fi

# Imprime o corpo da resposta e, na última linha, o status HTTP (000 = backend fora do ar).
login() {
  curl --silent --show-error --write-out '\n%{http_code}' -X POST "$BACKEND/api/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$EMAIL\",\"senha\":\"$SENHA\"}" 2> /dev/null || true
}

# O backend cria as tabelas (Flyway) ao subir; espera até 2 min o login responder.
# O login serve de sinal de "pronto" (o actuator saiu com o Spring Security) e já devolve o token.
echo "Aguardando o backend em $BACKEND..."
status="000"
for _ in $(seq 1 60); do
  resposta="$(login)"
  status="$(printf '%s' "$resposta" | tail -n 1)"
  [ "$status" != "000" ] && [ "$status" -lt 500 ] && break
  sleep 2
done
if [ "$status" != "200" ]; then
  echo "Login de $EMAIL em $BACKEND/api/auth/login falhou (HTTP $status)." >&2
  echo "000 ou 5xx: confira 'docker compose logs backend'. 401: e-mail ou senha errados." >&2
  exit 1
fi
TOKEN="$(printf '%s' "$resposta" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')"

for mes in "${MESES[@]}"; do
  echo "Importando $mes..."
  curl --fail --silent --show-error -X POST "$BACKEND/api/importacao" \
    -H "Authorization: Bearer $TOKEN" \
    -F "arquivos=@$DATASET/BASE RH_$mes.xlsx" \
    -F "arquivos=@$DATASET/BASE_VENDAS_$mes.xlsx" \
    -F "arquivos=@$DATASET/BASE_COMMISS_FINAL.xlsx" > /dev/null
done

echo "Pronto: jul a dez/2025 importados."
