#!/usr/bin/env bash
# Prepara o banco com o estado completo para a demonstração da Sprint 2.
# 1. Espera o backend responder;
# 2. Carrega as bases de jul a dez/2025 via importar-dataset.sh (ou pula com --so-campanhas);
# 3. Aplica o seed-demo.sql via docker compose exec no container do PostgreSQL;
# 4. Imprime um resumo com os usuários, senha e o roteiro do que cada perfil verá na demo.
#
# Uso:
#   ./scripts/seed-demo.sh                  # completo: importa a base inteira e recria campanhas
#   ./scripts/seed-demo.sh --so-campanhas   # rápido: pula a importação das planilhas (em segundos)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SO_CAMPANHAS=0
ARGS=()

for arg in "$@"; do
  if [ "$arg" = "--so-campanhas" ]; then
    SO_CAMPANHAS=1
  else
    ARGS+=("$arg")
  fi
done

BACKEND="${BACKEND_URL:-${ARGS[0]:-http://localhost:${BACKEND_HOST_PORT:-8080}}}"
BACKEND="${BACKEND%/}"

echo "============================================================"
echo "    Camplana - Preparação do Seed de Demo (Sprint 2)"
echo "============================================================"

# Espera o backend subir antes de qualquer ação
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
  echo "Erro: Backend não respondeu em $BACKEND após 120s; confira os logs do docker." >&2
  exit 1
fi

# 1. Importação da base inteira jul-dez/2025
if [ "$SO_CAMPANHAS" -eq 1 ]; then
  echo "Opção --so-campanhas detectada: pulando importação das planilhas."
else
  echo ""
  echo "--- Passo 1/2: Importando dataset jul-dez/2025 ---"
  "$SCRIPT_DIR/importar-dataset.sh" "$BACKEND"
  # As intercorrências de RH (A6-76) dependem dos funcionários recém-importados.
  "$SCRIPT_DIR/importar-intercorrencias.sh"
fi

# 2. Aplicação do seed de campanhas via docker compose
echo ""
echo "--- Passo 2/2: Aplicando seed das campanhas (seed-demo.sql) ---"

COMPOSE=(docker compose)
if [ -n "${COMPOSE_PROJECT_NAME:-}" ]; then
  COMPOSE+=(-p "$COMPOSE_PROJECT_NAME")
elif [ -n "${COMPOSE_PROJECT:-}" ]; then
  COMPOSE+=(-p "$COMPOSE_PROJECT")
fi

if [ -n "${COMPOSE_FILE:-}" ]; then
  IFS=': ' read -r -a C_FILES <<< "$COMPOSE_FILE"
  for f in "${C_FILES[@]}"; do
    [ -n "$f" ] && COMPOSE+=(-f "$f")
  done
fi

# ON_ERROR_STOP: sem ele o psql sai com 0 mesmo quando a transação cai em ROLLBACK.
"${COMPOSE[@]}" exec -T postgres psql -v ON_ERROR_STOP=1 -U "${DB_USERNAME:-postgres}" -d "${POSTGRES_DB:-camplana}" < "$SCRIPT_DIR/seed-demo.sql"

echo "Seed SQL aplicado com sucesso! (9 campanhas e histórico completo de mensagens de chat)"

echo ""
echo "============================================================"
echo "    Resumo da Demonstração da Sprint 2"
echo "============================================================"
echo "Senha padrão para todos os usuários: 123456"
echo ""
echo "1. Gabriela (GERENTE) - gabriela@camplana.com.br"
echo "   - Menu 'Minhas Campanhas' (/campanhas):"
echo "     • 6 campanhas ativas (sem filtro) e 1 arquivada (com filtro 'Arquivada'):"
echo "       - 'Campanha Fim de Ano - Rascunho' (RASCUNHO, 15 a 24/12/2025, custo R$ 45.000,00)"
echo "       - 'Campanha Virada de Novembro' (AGUARDANDO_APROVACAO, 20 a 28/11/2025, custo R$ 23.736,14)"
echo "       - 'Black Friday 2025 - Aprovada' (APROVADA, 24 a 30/11/2025, custo R$ 35.604,03)"
echo "       - 'Acréscimo de Agosto - Reprovada' (REPROVADA, 01 a 15/08/2025, custo R$ 137.249,44)"
echo "       - 'Incentivo Setembro - Arquivada' (ARQUIVADA, 01 a 15/09/2025, custo R$ 58.660,62)"
echo "       - 'Campanha Outubro - Dia das Crianças' (AGUARDANDO_APROVACAO v2, 01 a 12/10/2025, custo R$ 92.967,52)"
echo "       - 'Campanha de Inverno - Julho 2025' (APROVADA, 01 a 31/07/2025, custo R$ 179.633,39)"
echo "   - Visualização completa do resultado: Meta atingida, gráficos por Marca/Cargo, maiores lojas,"
echo "     histórico com 2 versões (v1 reprovada pelo Sérgio, v2 em análise) e trilha de auditoria."
echo ""
echo "2. Sérgio (SUPERVISOR) - sergio@camplana.com.br"
echo "   - Menu 'Minhas Campanhas' (/campanhas):"
echo "     • 'Incentivo Natal Antecipado - Supervisão' (AGUARDANDO_APROVACAO, 01 a 14/12/2025, custo R$ 64.649,63)"
echo "     • Ao abrir a própria campanha, não há botão de aprovação (princípio quatro-olhos)."
echo "   - Menu 'Campanhas / Aprovações' (/campanha):"
echo "     • Fila de Aprovação (2 campanhas): 'Campanha Virada de Novembro' e 'Campanha Outubro - Dia das Crianças' (v2)."
echo "       Não vê a própria campanha na fila de aprovação."
echo "     • Aba 'Passadas' (2 campanhas): 'Black Friday 2025' e 'Campanha de Inverno - Julho 2025'."
echo "   - Menu 'Importar Bases' (/importar) e '% Vigente' (/vigente)."
echo ""
echo "3. Sílvia (SUPERVISOR) - silvia@camplana.com.br"
echo "   - Menu 'Minhas Campanhas' (/campanhas):"
echo "     • 'Planejamento Verão 2026 - Rascunho' (RASCUNHO, 01 a 15/11/2025, custo R$ 118.665,41)"
echo "   - Menu 'Campanhas / Aprovações' (/campanha):"
echo "     • Fila de Aprovação (3 campanhas): vê as da Gabriela e a do Sérgio ('Incentivo Natal Antecipado'),"
echo "       podendo Aprovar, Reprovar ou Re-simular a do Sérgio."
echo "     • Aba 'Passadas' (2 campanhas): 'Black Friday 2025' e 'Campanha de Inverno - Julho 2025'."
echo ""
echo "4. Ana (ADMIN) - ana@camplana.com.br"
echo "   - Painel Administrativo (/admin):"
echo "     • Gestão de Usuários: lista dos 4 usuários (Ana, Gabriela, Sérgio, Sílvia),"
echo "       edição de dados, alteração de perfil e bloqueio/ativação."
echo "     • Não possui acesso a rotas de criação ou aprovação de campanhas (403)."
echo "============================================================"
