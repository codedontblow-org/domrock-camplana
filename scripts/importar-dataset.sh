#!/usr/bin/env bash
# Carrega no banco as bases da Dom Rock (RH, vendas e % de comissão) de jul a dez/2025,
# um mês por chamada, pelo endpoint de importação do backend.
# Uso: ./scripts/importar-dataset.sh [URL do backend]   (padrão: http://localhost:8080)
set -euo pipefail

BACKEND="${1:-${BACKEND_URL:-http://localhost:${BACKEND_HOST_PORT:-8080}}}"
BACKEND="${BACKEND%/}"
DATASET="$(cd "$(dirname "$0")/.." && pwd)/DomRock-Backend/docs/domrock-dataset"
MESES=(JUL25 AGO25 SET25 OUT25 NOV25 DEZ25)

if [ ! -d "$DATASET" ]; then
  echo "Dataset não encontrado em $DATASET; rode 'git submodule update --init --remote' antes." >&2
  exit 1
fi

COMMISS_FILE="$DATASET/BASE_COMMISS_FINAL.xlsx"
if [ ! -f "$COMMISS_FILE" ]; then
  echo "Planilha de comissão não encontrada em $COMMISS_FILE." >&2
  exit 1
fi

# O Spring Security bloqueia rotas não autenticadas (/actuator/health devolve 401).
# Testamos o endpoint de login (/api/auth/login), que responde 400 ou 401 assim que a API sobe.
echo "Aguardando o backend em $BACKEND..."
BACKEND_PRONTO=0
for _ in $(seq 1 60); do
  HTTP_CODE=$(curl --silent --output /dev/null --write-out "%{http_code}" -X POST "$BACKEND/api/auth/login" \
    -H "Content-Type: application/json" -d '{}' || true)
  if [ "$HTTP_CODE" = "400" ] || [ "$HTTP_CODE" = "401" ]; then
    BACKEND_PRONTO=1
    break
  fi
  sleep 2
done

if [ "$BACKEND_PRONTO" -ne 1 ]; then
  echo "Erro: Backend não respondeu em $BACKEND após 120s; confira os logs do container." >&2
  exit 1
fi

# Desde a sprint 2 (A6-60), a rota /api/importacao exige perfil SUPERVISOR e token JWT.
# Sérgio é o supervisor padrão criado no seed da migração V4.
echo "Autenticando como supervisor (Sérgio)..."
LOGIN_JSON=$(curl --silent --show-error -X POST "$BACKEND/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"sergio@camplana.com.br","senha":"123456"}')

TOKEN=$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('token', ''))" "$LOGIN_JSON" 2>/dev/null || true)
if [ -z "$TOKEN" ]; then
  echo "Erro: Falha na autenticação do Sérgio. Resposta recebida: $LOGIN_JSON" >&2
  exit 1
fi

echo "Login efetuado com sucesso."

# A importação no backend é um job assíncrono (@Async). Enviamos o multipart com RH,
# Vendas e a Comissão (conforme o guia_importacao.md), recebemos 202 com o ID do job
# e consultamos GET /api/importacao/{id} até sair de PROCESSANDO (~40s a 50s por mês).
for mes in "${MESES[@]}"; do
  RH_FILE="$DATASET/BASE RH_$mes.xlsx"
  VENDAS_FILE="$DATASET/BASE_VENDAS_$mes.xlsx"

  if [ ! -f "$RH_FILE" ] || [ ! -f "$VENDAS_FILE" ]; then
    echo "Erro: Arquivos de $mes não encontrados em $DATASET." >&2
    exit 1
  fi

  echo "Enviando base de $mes..."
  HTTP_RESP_FILE=$(mktemp)
  HTTP_STATUS=$(curl --silent --show-error --write-out "%{http_code}" --output "$HTTP_RESP_FILE" \
    -X POST "$BACKEND/api/importacao" \
    -H "Authorization: Bearer $TOKEN" \
    -F "arquivos=@$RH_FILE" \
    -F "arquivos=@$VENDAS_FILE" \
    -F "arquivos=@$COMMISS_FILE")

  CORPO_ENVIO=$(cat "$HTTP_RESP_FILE")
  rm -f "$HTTP_RESP_FILE"

  if [ "$HTTP_STATUS" != "202" ]; then
    echo "Erro: Envio de $mes rejeitado pelo backend. Status HTTP recebido: '$HTTP_STATUS', esperado: '202'." >&2
    echo "Detalhes do backend: $CORPO_ENVIO" >&2
    exit 1
  fi

  JOB_ID=$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('id', ''))" "$CORPO_ENVIO" 2>/dev/null || true)
  if [ -z "$JOB_ID" ]; then
    echo "Erro: Resposta de $mes não conteve o ID do job. Resposta: $CORPO_ENVIO" >&2
    exit 1
  fi

  echo "Job #$JOB_ID criado para $mes. Aguardando processamento..."
  while true; do
    sleep 3
    JOB_DATA=$(curl --silent --show-error -X GET "$BACKEND/api/importacao/$JOB_ID" \
      -H "Authorization: Bearer $TOKEN")

    STATUS_JOB=$(python3 -c "import sys, json; print(json.loads(sys.argv[1]).get('status', ''))" "$JOB_DATA" 2>/dev/null || true)

    if [ "$STATUS_JOB" = "PROCESSANDO" ]; then
      continue
    fi

    if [ "$STATUS_JOB" = "CONCLUIDO" ]; then
      # Mostra totais e avisos sem estourar o terminal
      python3 -c "
import sys, json
data = json.loads(sys.argv[1])
totais = data.get('totais', {})
pendencias = data.get('pendencias', [])
avisos = len(pendencias)
print(f\"[OK] $mes concluído: {data.get('linhas_importadas', 0)} linhas importadas (RH={totais.get('RH', 0)}, Vendas={totais.get('VENDAS', 0)}, Comissão={totais.get('COMISSAO', 0)}). Avisos: {avisos}.\")
if avisos > 0:
    print(f\"     Exemplo de aviso: {pendencias[0].get('motivo')}\")
" "$JOB_DATA"
      break
    else
      echo "Erro: Job #$JOB_ID ($mes) terminou com status '$STATUS_JOB' (esperado: 'CONCLUIDO')." >&2
      python3 -c "
import sys, json
data = json.loads(sys.argv[1])
print('Erro reportado:', data.get('erro'))
for p in data.get('pendencias', []):
    print(f\" - [{p.get('severidade')}] {p.get('origem')}: {p.get('motivo')}\")
" "$JOB_DATA" 2>/dev/null || echo "Resposta bruta: $JOB_DATA" >&2
      exit 1
    fi
  done
done

echo "Pronto: base de jul a dez/2025 importada com sucesso."
