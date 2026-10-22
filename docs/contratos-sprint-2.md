# Contratos de API - Sprint 2 (Front, Back e Lana)

Este documento centraliza os formatos JSON (requests e responses) que trafegam entre Frontend, Backend e o Agente Lana na Sprint 2. Com ele, quem consome uma rota trabalha com dados falsos no formato certo, sem esperar quem produz.

> **Importante:** os exemplos usam dados reais do dataset (conferidos no banco local em 21/10/2026) ou os números dos critérios de aceite dos cards.

## Como ler

Cada seção diz a **situação** da rota:

- **Existe:** já está na `develop`. O contrato descreve o que o código faz hoje.
- **Nova:** ainda não existe. Quem implementa segue o formato daqui.
- **Muda:** existe e muda nesta sprint. A seção diz o que muda e quem ajusta cada lado.

Para não repetir objetos grandes, alguns exemplos trazem um texto como `"<Regra 2.1>"` no lugar do objeto. Ele indica o formato da seção citada.

Mudança posterior neste contrato só por PR, com aviso no canal do time.

### Convenções

| Item | Regra | Exemplo |
|---|---|---|
| Nomes dos campos | `snake_case` | `chat_id`, `custo_incremental` |
| Valores fixos (status, tipo) | maiúsculas | `AGUARDANDO_APROVACAO` |
| Dia | `YYYY-MM-DD` | `2025-11-24` |
| Data e hora | ISO-8601 em UTC | `2026-10-21T13:05:00Z` |
| Competência | `YYYY-MM` | `2025-11` |
| Dinheiro | número em reais, 2 casas | `23736.10` |
| Percentual | número em pontos percentuais | `1.0` = 1% |
| Marca, cargo e loja | código como texto | `"10"`, `"150"`, `"33"` |
| Ids do banco | número | `12` |

### Quem produz e quem consome

| Seção | Produz | Consome |
|---|---|---|
| 1. Login | A6-60 (integrado) | A6-61 (integrado), todas as telas |
| 2.1 Regra (ficha) | Lana (Sprint 1) | chat, simulação, campanha |
| 2.2 Trilha | A6-70 | A6-71, A6-65, A6-66, A6-69 |
| 2.3 Resultado da simulação | Lana: A6-72, A6-74, A6-77 | A6-66, A6-67, A6-69, A6-72, A6-75 |
| 3. Chat e conversa | A6-53 (integrado), A6-65, A6-70, A6-81 | front do chat, A6-67, A6-69 |
| 4. Simulação (job) | A6-66 | front do chat, A6-68 |
| 5. Campanha e aprovação | A6-64, A6-68 | A6-67, A6-69, A6-75 |
| 6. Correção da base | A6-80, A6-81 | A6-69, A6-83 |
| 7. Importação | A6-78 (integrado) | A6-79 |
| 8. Avisos | A6-82 | A6-83 |

### O que quebra o que existe hoje

| Mudança | Quem ajusta |
|---|---|
| `POST /api/simulacoes` deixa de devolver o resultado na hora e passa a devolver um job (202) | A6-66 (backend e front) |
| `resultado.orcamento` pode vir `null` (orçamento opcional) | A6-72 (Lana e front) |
| Os tipos de % vigente e conflito do branch `a6-75-bloco-de-comissao-no-periodo` passam a `snake_case` (seção 2.3) | A6-75 (front) |
| A Lana deixa de guardar a conversa (`InMemorySaver`) e recebe o histórico do backend | A6-65 (backend e Lana) |

O resto é acréscimo: campos novos em respostas que já existem, campos novos no `.proto` (o proto3 aceita sem quebrar) e rotas novas.

### Formato de erro

Os erros do próprio backend seguem o `ErroResponse` (`domrock-backend/src/main/java/br/com/camplana/exception/ErroResponse.java`):

```json
{
  "timestamp": "2026-10-21T13:05:00Z",
  "status": 409,
  "error": "Conflict",
  "message": "Transição inválida: campanha 12 está em APROVADA, pedido RASCUNHO",
  "path": "/api/campanhas/12/editar"
}
```

Os erros que vêm da Lana (chat e simulação) chegam com o corpo dela, sem mudança:

```json
{
  "etapa": "validacao",
  "mensagem": "Regra incompleta ou inválida",
  "erros": ["periodo: obrigatório, recebido None"]
}
```

| Status | Quando |
|---|---|
| 422 | Simulação recusada pela Lana (regra incompleta, código gerado que falhou) |
| 502 | Lana fora do ar (vem no formato `ErroResponse`) |
| 503 | Cota do provedor de IA (`etapa: "cota_llm"`) |
| 504 | A Lana demorou demais (`etapa: "tempo"`) |

### Perfis e permissões

O usuário do sistema **não tem matrícula**: matrícula é só do funcionário da base. O perfil `GERENTE` (Gerente de Vendas, que usa o sistema) não é o cargo 150 (gerente de loja, que recebe comissão).

Usuários do seed (migration V4), usados nos exemplos:

| Id | Nome | E-mail | Perfil |
|---|---|---|---|
| 1 | Gabriela | `gabriela@camplana.com.br` | GERENTE |
| 2 | Sérgio | `sergio@camplana.com.br` | SUPERVISOR |
| 3 | Sílvia | `silvia@camplana.com.br` | SUPERVISOR |
| 4 | Ana | `ana@camplana.com.br` | ADMIN |

| Rota | Perfis | No `SecurityConfig` |
|---|---|---|
| `POST /api/auth/login` | pública | existe |
| `/api/chat/**` | GERENTE, SUPERVISOR | existe |
| `/api/simulacoes/**` | GERENTE, SUPERVISOR | existe |
| `POST /api/campanhas/*/decidir` | SUPERVISOR | existe |
| `POST /api/campanhas/*/versoes/*/resimular` | SUPERVISOR | **falta** (A6-68) |
| `/api/campanhas/**` | GERENTE, SUPERVISOR | existe |
| `POST /api/correcoes/*/decidir` | SUPERVISOR | **falta** (A6-80) |
| `/api/correcoes/**` | GERENTE, SUPERVISOR | **falta** (A6-80) |
| `/api/avisos/**` | SUPERVISOR | **falta** (A6-82) |
| `/api/usuarios/**` | ADMIN | existe |
| `/api/importacao/**` | SUPERVISOR | existe |

O `SecurityConfig` termina em `denyAll()`: rota nova sem linha na matriz devolve 403.

---

## 1. Login

**Situação:** existe (A6-60).

**`POST /api/auth/login`** (rota pública, não exige token)

Autentica com e-mail e senha e devolve um token JWT.

**Request:**
```json
{
  "email": "gabriela@camplana.com.br",
  "senha": "123456"
}
```

| Campo | Tipo | Obrigatório | Observação |
|---|---|---|---|
| `email` | string | sim | |
| `senha` | string | sim | Nunca é devolvida nem registrada em log |

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "perfil": "GERENTE",
  "validade": "2026-10-11T01:48:55.055Z",
  "usuario": {
    "id": 1,
    "nome": "Gabriela",
    "email": "gabriela@camplana.com.br"
  }
}
```

| Campo | Descrição |
|---|---|
| `token` | JWT assinado (HS256), válido por 8 horas |
| `perfil` | `ADMIN`, `GERENTE` ou `SUPERVISOR` |
| `validade` | Data/hora de expiração do token, ISO-8601 em UTC |
| `usuario` | Dados básicos de quem logou |

**Conteúdo do token (claims):** `sub` (e-mail), `id`, `perfil`, `iss` (`camplana-api`) e `exp`.

**Erros:**

| Status | Quando | `message` |
|---|---|---|
| 401 | E-mail inexistente, senha errada ou usuário inativo | `E-mail ou senha inválidos` |

A mensagem é a mesma nos três casos, para não revelar qual campo errou.

### Autenticação nas demais rotas

Toda rota protegida exige o cabeçalho:

```
Authorization: Bearer <token>
```

| Status | Quando | `message` |
|---|---|---|
| 401 | Sem token, token inválido ou expirado | `Autenticação necessária` |
| 403 | Perfil sem permissão para a rota | `Sem permissão para esta ação` |

### Atalho de desenvolvimento (somente profile `dev`)

Com o profile `dev` do Spring ativo no backend, é possível omitir o token e enviar o id do usuário:

```
X-Usuario-Dev: 1
```

A requisição é tratada como o usuário de id 1. **Fora do profile `dev`, o cabeçalho é ignorado.** Não usar em produção.

---

## 2. Objetos compartilhados

### 2.1. Regra (ficha)

**Situação:** existe (Sprint 1). Muda um detalhe no A6-72.

É a ficha que a Lana preenche no chat, o usuário revisa no painel e a simulação usa. O formato é o mesmo no chat, na simulação e na campanha. Está definida em `domrock-lana/app/tools/regra_tool/dtos.py` e espelhada em `domrock-frontend/src/(user)/chat/types.ts`.

```json
{
  "rule_id": "draft-3fa9c1d2",
  "tipo_regra": "BONUS_TEMPORARIO",
  "raw_prompt": "Todas as vendas de 24/11 a 30/11 terão +1% de comissão, todas as marcas, exceto gerentes.",
  "status": "DRAFT_PENDING_REVIEW",
  "faltantes": [],
  "parametros": [
    { "key": "periodo", "label": "Prazo da Campanha", "type": "date_range", "categoria": "REGRA",
      "value": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" }, "options": null, "required": true },
    { "key": "pct_acrescimo", "label": "Acréscimo de Comissão (%)", "type": "percentage", "categoria": "REGRA",
      "value": 1.0, "options": null, "required": true },
    { "key": "marcas_alvo", "label": "Marcas Participantes", "type": "multi_select", "categoria": "REGRA",
      "value": ["ALL"], "required": true,
      "options": [
        { "id": "ALL", "label": "Todas as Marcas" }, { "id": "10", "label": "PRETO (10)" },
        { "id": "20", "label": "BRANCO (20)" }, { "id": "30", "label": "AZUL (30)" },
        { "id": "40", "label": "VERMELHO (40)" }, { "id": "50", "label": "AMARELO (50)" },
        { "id": "60", "label": "CINZA (60)" }
      ] },
    { "key": "cargos_alvo", "label": "Cargos Elegíveis", "type": "multi_select", "categoria": "REGRA",
      "value": ["100", "200", "300"], "required": true,
      "options": [
        { "id": "100", "label": "VENDEDOR LOJA" }, { "id": "150", "label": "GERENTE" },
        { "id": "200", "label": "VENDEDOR BALCAO" }, { "id": "300", "label": "ASSISTENTE DE VENDAS" }
      ] },
    { "key": "meta_vendas", "label": "Meta Financeira da Campanha (R$)", "type": "currency", "categoria": "CONSTRAINT",
      "value": 2000000.00, "options": null, "required": true },
    { "key": "orcamento_limite", "label": "Orçamento Máximo de Incentivo (R$)", "type": "currency", "categoria": "CONSTRAINT",
      "value": null, "options": null, "required": false }
  ]
}
```

- `status` é da ficha (`DRAFT_PENDING_REVIEW`), não da campanha. O status da campanha está na seção 5.
- **Muda no A6-72:** `orcamento_limite` passa a `required: false`, pode vir `null` e não entra em `faltantes`.

### 2.2. Trilha

**Situação:** nova (A6-70).

Mostra de onde veio cada número: as ferramentas usadas, as consultas feitas, as tabelas e os meses lidos. **É montada pelo código, nunca escrita pela LLM.** Vem em `trilha` na resposta do chat (3.1) e em `resultado.trilha` na simulação (2.3). Vale `null` quando a resposta não usou ferramenta (ex.: "o que você consegue fazer?").

| Campo | Tipo | Observação |
|---|---|---|
| `modelo` | texto | modelo de IA usado, ex.: `gemini-3.5-flash-lite` |
| `tentativas` | número | tentativas de gerar o código (só na simulação; no chat, `null`) |
| `premissas` | lista de textos | tiradas dos parâmetros e das ressalvas |
| `passos` | lista | um item por ferramenta chamada ou por passo da simulação |

Cada passo:

| Campo | Tipo | Observação |
|---|---|---|
| `ordem` | número | começa em 1 |
| `ferramenta` | texto | `consultar_banco`, `registrar_parametros_regra` ou um passo da simulação (tabela abaixo) |
| `descricao` | texto | legível, montada pelo código |
| `tabelas_acessadas` | lista | nomes reais das tabelas do banco |
| `competencias` | lista | `YYYY-MM` |
| `filtros` | texto | |
| `sql_executado` | texto ou `null` | |
| `registros_retornados` | número | linhas que a consulta devolveu |
| `dados` | lista ou `null` | linhas devolvidas pelo `consultar_banco` (no máximo 50, o `LIMITE_LINHAS` do guard) |
| `tempo_ms` | número | |
| `situacao` | `SUCESSO` ou `ERRO` | |
| `mensagem_erro` | texto ou `null` | preenchido quando `ERRO`. Nesse caso a resposta não traz valor em reais |

O exemplo da trilha do chat está em 3.1. Na simulação, os passos são sempre estes, nesta ordem:

| Ordem | `ferramenta` | `descricao` (exemplo da Black Friday) |
|---|---|---|
| 1 | `carregar_bases` | Bases de nov/2025: 469 pessoas no RH, 721 vendas de 24/11 a 30/11, 24 linhas de % por marca e cargo |
| 2 | `comissao_atual` | Comissão atual (regras 5a a 5g): R$ 480.263,24 |
| 3 | `gerar_codigo` | Código gerado por gemini-3.5-flash-lite em 1 tentativa, conferido com o cálculo de referência |
| 4 | `executar_sandbox` | Código executado no sandbox |
| 5 | `conferir` | 4 conferências passaram: sem comissão negativa, contribuições, escopo da regra, cálculo de referência |
| 6 | `resumir` | Custo adicional de R$ 23.736,10 |

Premissas desse exemplo: `"Gerentes (150) excluídos"`, `"Todas as marcas"`, `"Simulação sobre vendas que já aconteceram: supõe que as pessoas venderiam o mesmo com a regra nova."`

### 2.3. Resultado da simulação

**Situação:** muda (A6-70, A6-72, A6-74, A6-77).

Os campos novos **se somam** ao resultado atual: nenhum campo existente some ou muda de nome. Os campos atuais estão em `domrock-lana/app/simulacao/dtos.py` (`ResultadoSimulacao`) e no `ResultadoSimulacao` de `domrock-frontend/src/(user)/chat/types.ts`:

| Campo atual | O que é |
|---|---|
| `rule_id`, `competencias` | ficha simulada e meses lidos |
| `totais` | `baseline`, `simulado`, `diferenca` (custo adicional), `diferenca_pct` |
| `por_marca`, `por_cargo`, `maiores_lojas` | quebras do custo |
| `orcamento` | `orcamento_limite`, `custo_incremental`, `folga`, `cabe_no_orcamento` |
| `meta` | `meta_vendas`, `vendas_periodo`, `pct_atingimento`, `atingida` |
| `impacto` | pessoas impactadas e acréscimos |
| `cenarios` | variações já calculadas (`ajustar_acrescimo`, `sem_marca`) |
| `ressalvas`, `explicacao`, `observacao` | textos |
| `codigo`, `origem_codigo`, `tentativas` | código gerado (o front mostra `codigo` só para SUPERVISOR, A6-71) |

O que muda:

| Campo | Mudança | Card |
|---|---|---|
| `meta.diferenca` | novo: venda do período − meta | A6-72 |
| `retorno` | novo | A6-72 |
| `orcamento` | `null` quando o orçamento não foi informado; o cenário `ajustar_acrescimo` só aparece com orçamento | A6-72 |
| `comissao_periodo` | novo: % base, vigente e com a campanha, por marca × cargo e trecho | A6-74 |
| `conflitos` | novo: campanhas que se sobrepõem a esta | A6-74 |
| `regras_base_aplicadas`, `pessoas_no_piso` | novos | A6-77 |
| `trilha` | novo (2.2) | A6-70 |
| `ressalvas` | sai a frase "A comissão atual ainda não aplica proporcional de admissão/demissão nem férias e afastamentos." | A6-77 |

**Exemplo 1: meta, retorno e regras base.** Black Friday +1% de 24 a 30/11/2025, todas as marcas, exceto gerentes, meta de R$ 2.000.000 e orçamento vazio. A venda real do período foi de R$ 2.406.125,93. Mostra só os campos que mudam:

```json
{
  "meta": {
    "meta_vendas": 2000000.00,
    "vendas_periodo": 2406125.93,
    "pct_atingimento": 120.31,
    "atingida": true,
    "diferenca": 406125.93
  },
  "retorno": {
    "provisorio": true,
    "custo_pct_venda": 0.99,
    "custo_por_real_acima_meta": 0.06
  },
  "orcamento": null,
  "regras_base_aplicadas": [
    { "regra": "5c", "descricao": "Admissão no mês", "pessoas": 19 },
    { "regra": "5e_5f", "descricao": "Afastamento", "pessoas": 3 },
    { "regra": "5g", "descricao": "Férias", "pessoas": 2 }
  ],
  "pessoas_no_piso": 3
}
```

- `retorno` usa a conta provisória do A6-72 enquanto a Dom Rock não responde a pergunta 2: `custo_pct_venda` = custo adicional ÷ venda do período × 100; `custo_por_real_acima_meta` = custo adicional ÷ (venda − meta), `null` se a venda não passou da meta. Com `provisorio: true`, a tela mostra a etiqueta "provisório".
- `regras_base_aplicadas` lista as regras da especificação aplicadas na comissão atual, com quantas pessoas caíram em cada uma. Regras com 0 pessoas não aparecem. Códigos: `5c` (admissão), `5d` (demissão), `5e_5f` (afastamento, inclui licença-maternidade), `5g` (férias), `bonus`, `cobertura` (gerente cobrindo outra loja). As regras 5a e 5b valem para todos e não entram na lista.
- `pessoas_no_piso`: quantas pessoas ficaram no piso de R$ 3.500 (só quem teve afastamento).
- As contagens são da competência nov/2025 na base (19 admissões; afastamentos e férias da especificação). O número do piso é conferido no A6-77.

**Exemplo 2: % vigente e conflitos** (critério do A6-74). A % base do gerente (150) da marca 10 é 1,00%. Estão aprovadas a Campanha A (+1,0%, de 20 a 30/11/2025) e a Campanha B (+0,5%, de 25/11 a 05/12/2025). Gabriela simula +0,5% de 24 a 30/11 para a marca 10, cargo 150:

```json
{
  "comissao_periodo": [
    {
      "marca": "10", "cargo": "150",
      "data_inicio": "2025-11-24", "data_fim": "2025-11-24",
      "pct_base": 1.00, "pct_vigente": 2.00, "pct_com_campanha": 2.50,
      "historico": [
        { "campanha_id": 9, "versao": 1, "nome": "Campanha A",
          "data_inicio": "2025-11-20", "data_fim": "2025-11-30", "pct_acrescimo": 1.0,
          "autor": "Gabriela", "aprovador": "Sérgio", "aprovada_em": "2026-10-15T14:02:00Z",
          "justificativa": "Reforço da última semana de novembro" }
      ]
    },
    {
      "marca": "10", "cargo": "150",
      "data_inicio": "2025-11-25", "data_fim": "2025-11-30",
      "pct_base": 1.00, "pct_vigente": 2.50, "pct_com_campanha": 3.00,
      "historico": [
        { "campanha_id": 9, "versao": 1, "nome": "Campanha A",
          "data_inicio": "2025-11-20", "data_fim": "2025-11-30", "pct_acrescimo": 1.0,
          "autor": "Gabriela", "aprovador": "Sérgio", "aprovada_em": "2026-10-15T14:02:00Z",
          "justificativa": "Reforço da última semana de novembro" },
        { "campanha_id": 10, "versao": 1, "nome": "Campanha B",
          "data_inicio": "2025-11-25", "data_fim": "2025-12-05", "pct_acrescimo": 0.5,
          "autor": "Gabriela", "aprovador": "Sílvia", "aprovada_em": "2026-10-16T10:30:00Z",
          "justificativa": "Gerentes puxam a virada para dezembro" }
      ]
    }
  ],
  "conflitos": [
    { "campanha_id": 9, "versao": 1, "nome": "Campanha A", "status": "APROVADA", "autor": "Gabriela",
      "data_inicio": "2025-11-20", "data_fim": "2025-11-30",
      "sobreposicao": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
      "marcas": ["10"], "cargos": ["150"] },
    { "campanha_id": 10, "versao": 1, "nome": "Campanha B", "status": "APROVADA", "autor": "Gabriela",
      "data_inicio": "2025-11-25", "data_fim": "2025-12-05",
      "sobreposicao": { "data_inicio": "2025-11-25", "data_fim": "2025-11-30" },
      "marcas": ["10"], "cargos": ["150"] }
  ]
}
```

- **Trecho** = intervalo de datas em que a % vigente fica constante: o início e o fim de cada campanha cortam o período. Não é faixa de atingimento.
- `comissao_periodo` tem um item por marca × cargo da campanha e por trecho. Sem campanhas no período: um item por marca × cargo, com `pct_vigente` = `pct_base` e `historico: []`.
- `historico` = as campanhas aprovadas que levam da % base à vigente naquele trecho. É o "Por quê" do A6-75.
- Regra de combinação: **soma** (provisória, estudo A6-73).
- `conflitos`: outra campanha aprovada ou aguardando aprovação, com período que cruza o desta e ao menos uma marca × cargo em comum. `marcas` e `cargos` são os que as duas têm em comum. Campanha que aguarda aprovação aparece com `status: "AGUARDANDO_APROVACAO"`, gera conflito, mas não entra na % vigente. `conflitos: []` = verificado e sem conflito.
- Para o branch do A6-75: `comissoes_periodo` → `comissao_periodo`, `inicio`/`fim` → `data_inicio`/`data_fim`, `base` → `pct_base`, `vigente` → `pct_vigente`, `comCampanha` → `pct_com_campanha`, `acrescimo` → `pct_acrescimo`, `aprovadoEm` → `aprovada_em`, `id` (no histórico e no conflito) → `campanha_id`, `marca` (no conflito) → `marcas`. O `id` de cada linha de `comissao_periodo` sai. O conflito ganha `status`, `versao`, `autor` e `sobreposicao`.

---

## 3. Chat e conversa

### 3.1. Mandar mensagem

**Situação:** muda (A6-65, A6-70, A6-81). O que existe não muda; entram campos novos na resposta.

**`POST /api/chat`**

**Request:**
```json
{
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "message": "Quanto a marca 30 vendeu em outubro de 2025?",
  "regra": null
}
```

| Campo | Observação |
|---|---|
| `chat_id` | Gerado pelo front ao abrir uma conversa nova (`novoChatId()` em `stores/chat.ts`). Na 1ª mensagem, o backend cria a conversa no nome do usuário logado; outro usuário com o mesmo `chat_id` recebe 403 |
| `message` | Texto do usuário |
| `regra` | A ficha como está no painel (2.1), com as edições do usuário, ou `null` |

O histórico **não** vem do front: o backend lê a conversa gravada no banco (A6-65) e envia o histórico à Lana (3.3).

**Response (200 OK):**
```json
{
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "response": "Em outubro de 2025 a marca 30 (AZUL) vendeu R$ 333.666,01, em 188 vendas.",
  "events": [
    { "type": "tool_call", "tool": "consultar_banco", "args": { "pergunta": "Total vendido pela marca 30 em outubro de 2025" } },
    { "type": "tool_res", "tool": "consultar_banco", "result": "{'status': 'sucesso', ...}" }
  ],
  "regra": null,
  "trilha": {
    "modelo": "gemini-3.5-flash-lite",
    "tentativas": null,
    "premissas": [],
    "passos": [
      {
        "ordem": 1,
        "ferramenta": "consultar_banco",
        "descricao": "Venda da marca 30 em out/2025",
        "tabelas_acessadas": ["venda", "funcionario_loja", "loja", "marca"],
        "competencias": ["2025-10"],
        "filtros": "marca 30; vendas de 01/10/2025 a 31/10/2025",
        "sql_executado": "SELECT COUNT(*) AS qtd_vendas, SUM(v.vlr_venda) AS total FROM venda v JOIN funcionario_loja fl ON fl.funcionario_id = v.funcionario_id AND DATE_TRUNC('month', fl.date_ref) = DATE_TRUNC('month', v.date_ref) JOIN loja l ON l.id = fl.loja_id JOIN marca m ON m.id = l.marca_id WHERE m.cod_marca = '30' AND v.date_ref BETWEEN '2025-10-01' AND '2025-10-31' LIMIT 50",
        "registros_retornados": 1,
        "dados": [{ "qtd_vendas": 188, "total": 333666.01 }],
        "tempo_ms": 340,
        "situacao": "SUCESSO",
        "mensagem_erro": null
      }
    ]
  },
  "mensagens_sistema": [],
  "solicitacao": null
}
```

| Campo | Situação | Observação |
|---|---|---|
| `chat_id` | existe | |
| `response` | existe | Texto da Lana |
| `events` | existe | Chamadas de ferramenta cruas (`tool_call`/`tool_res`), para depuração. A tela usa `trilha` |
| `regra` | existe | Ficha registrada neste turno (2.1) ou `null` |
| `trilha` | nova (A6-70) | 2.2, ou `null` |
| `mensagens_sistema` | nova (A6-65) | Mensagens de sistema gravadas desde a última mensagem do usuário (ex.: a reprovação), no formato de 3.2 |
| `solicitacao` | nova (A6-81) | Correção da base aberta pela Lana neste turno (seção 6), ou `null` |

Os erros 502, 503 e 504 seguem a tabela de "Formato de erro".

### 3.2. Reabrir a conversa

**Situação:** nova (A6-65).

**`GET /api/chat/{chat_id}/mensagens`**

Devolve a conversa gravada, em ordem, para reabrir depois de um reinício e para o aprovador ver como o autor chegou aos números.

Quem pode: o dono da conversa e, se a conversa é de uma campanha com versão submetida, os Supervisores. Outros recebem 403; `chat_id` inexistente, 404.

**Response (200 OK):**
```json
{
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "campanha_id": 12,
  "mensagens": [
    { "id": 101, "papel": "usuario", "texto": "Quero +1% para todas as marcas de 24 a 30/11, exceto gerentes, com meta de 2 milhões",
      "criada_em": "2026-10-21T12:58:10Z" },
    { "id": 102, "papel": "lana", "texto": "Preenchi a ficha: +1% de 24/11 a 30/11/2025, todas as marcas, exceto gerentes. Confira no painel e clique em Simular.",
      "regra": "<Regra 2.1>", "trilha": null, "criada_em": "2026-10-21T12:58:14Z" },
    { "id": 103, "papel": "sistema", "tipo": "SIMULACAO", "texto": "Simulação concluída: custo adicional de R$ 23.736,10",
      "simulacao_id": 345, "criada_em": "2026-10-21T12:59:02Z" },
    { "id": 104, "papel": "sistema", "tipo": "STATUS", "texto": "Enviado para análise — v1",
      "criada_em": "2026-10-21T13:05:00Z" },
    { "id": 105, "papel": "sistema", "tipo": "STATUS", "texto": "Reprovado por Sérgio: a meta de R$ 2 milhões está abaixo da venda real do período (R$ 2,4 milhões)",
      "criada_em": "2026-10-21T14:20:00Z" }
  ]
}
```

| Campo | Observação |
|---|---|
| `papel` | `usuario`, `lana` ou `sistema` |
| `regra`, `trilha` | Só em `lana`: a ficha e a trilha daquela resposta |
| `tipo` | Só em `sistema`: `SIMULACAO` (uma simulação terminou) ou `STATUS` (a campanha mudou de status) |
| `simulacao_id` | Só em `SIMULACAO`: o resultado está em `GET /api/simulacoes/{id}` (4.2) |
| `campanha_id` | `null` enquanto a conversa não foi salva como campanha |

Textos das mensagens de status: "Enviado para análise — v1", "Aprovado por Sílvia — v1", "Reprovado por Sérgio: {justificativa}", "Voltou para rascunho — a próxima submissão será a v2", "Arquivada".

### 3.3. Backend → Lana (gRPC `InvokeAgent`)

**Situação:** muda (A6-65, A6-70, A6-81). Existe desde o A6-51/52/53.

O `.proto` tem uma cópia em cada repositório, e as duas mudam juntas: `domrock-backend/src/main/proto/ia_service.proto` e `domrock-lana/app/proto/ia_service.proto` (os `_pb2` da Lana são gerados de novo a partir dele). O proto3 aceita campo novo sem quebrar: quem ainda não conhece o campo ignora.

```proto
message InvokeRequest {
  string prompt = 1;          // mensagem do usuário
  string chat_id = 2;
  string regra_json = 3;      // ficha do painel (2.1) em JSON, ou ""
  string historico_json = 4;  // novo (A6-65): mensagens anteriores da conversa, em JSON
}

message InvokeResponse {
  string resposta = 1;
  string events_json = 2;
  string regra_json = 3;
  string trilha_json = 4;       // novo (A6-70): trilha (2.2) em JSON, ou ""
  string solicitacao_json = 5;  // novo (A6-81): correção pedida (6.1, sem autor) em JSON, ou ""
}
```

Exemplo de `historico_json`:

```json
[
  { "papel": "usuario", "texto": "Quero +1% para todas as marcas de 24 a 30/11, exceto gerentes, com meta de 2 milhões" },
  { "papel": "lana", "texto": "Preenchi a ficha: +1% de 24/11 a 30/11/2025, todas as marcas, exceto gerentes. Confira no painel e clique em Simular." },
  { "papel": "sistema", "texto": "Reprovado por Sérgio: a meta de R$ 2 milhões está abaixo da venda real do período (R$ 2,4 milhões)" }
]
```

- Vem em ordem e sem a mensagem atual (que vai em `prompt`). As mensagens de sistema entram para a Lana saber, por exemplo, que a campanha foi reprovada e por quê.
- A Lana não guarda estado: monta o contexto só com o histórico recebido. O `InMemorySaver` sai.
- O backend monta a resposta do chat (3.1) a partir do `InvokeResponse`: `resposta` → `response`, `events_json` → `events`, `regra_json` → `regra`, `trilha_json` → `trilha`. Com `solicitacao_json` preenchido, o backend cria a correção (6.1) e a devolve em `solicitacao`.
- O `POST /agent/invoke` em HTTP da Lana continua existindo (Sprint 1), mas o backend não usa mais.

---

## 4. Simulação (job)

A simulação é assíncrona: o front pede, recebe o id na hora e consulta o status a cada 2 segundos. **Toda** simulação fica registrada, salva como campanha ou não (A6-66).

Status: `PENDENTE` → `RODANDO` → `CONCLUIDA` ou `ERRO`. Uma simulação nunca fica `RODANDO` para sempre: no timeout, vira `ERRO` com `etapa: "tempo"`.

### 4.1. Pedir

**Situação:** muda (A6-66). Hoje a rota devolve o resultado na hora.

**`POST /api/simulacoes`**

**Request:**
```json
{
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "campanha_id": null,
  "regra": "<Regra 2.1>"
}
```

- `campanha_id`: `null` até salvar. Depois de salva, o front manda o id e a simulação fica ligada à campanha: é a última simulação concluída que o submeter usa (5.7).

**Response (202 Accepted):**
```json
{ "id": 345, "status": "PENDENTE", "etapa": "Na fila" }
```

| Status | Quando |
|---|---|
| 400 | Corpo sem `regra` (já existe) |
| 403 | Campanha ou conversa de outro usuário |
| 409 | Campanha fora de `RASCUNHO`. A re-simulação da aprovação usa outra rota (5.9) |

### 4.2. Acompanhar

**Situação:** nova (A6-66).

**`GET /api/simulacoes/{id}`**

Quem pode: quem pediu e, se a simulação é de uma campanha com versão submetida, os Supervisores.

**Response (200 OK), rodando:**
```json
{
  "id": 345,
  "status": "RODANDO",
  "etapa": "Simulando",
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "campanha_id": null,
  "criada_em": "2026-10-21T12:58:40Z",
  "concluida_em": null,
  "duracao_ms": null,
  "resultado": null,
  "erro": null
}
```

**Concluída:** `status: "CONCLUIDA"`, `etapa: "Concluída"`, `concluida_em`, `duracao_ms` e `resultado` (2.3, com a `trilha` dentro).

**Com erro:** `status: "ERRO"` e `erro` com o corpo da Lana, ou com a etapa do backend quando a Lana não respondeu:

```json
{
  "id": 346,
  "status": "ERRO",
  "etapa": "Erro",
  "erro": { "etapa": "lana_indisponivel", "mensagem": "Lana indisponível em /simulacao" }
}
```

- `etapa` é um texto para mostrar ao usuário. O backend só vê o começo e o fim da chamada à Lana, então nesta sprint as etapas são "Na fila", "Simulando", "Concluída" e "Erro". Etapas mais finas ("gerando código", "conferindo") dependem de a Lana informar progresso e ficam fora deste contrato.

### 4.3. Backend → Lana (`POST /simulacao`)

**Situação:** muda (A6-74). Existe em HTTP; o gRPC cobre só o chat.

**Request:**
```json
{
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "regra": "<Regra 2.1>",
  "campanhas": [
    { "campanha_id": 9, "versao": 1, "nome": "Campanha A", "status": "APROVADA",
      "autor": "Gabriela", "aprovador": "Sérgio", "aprovada_em": "2026-10-15T14:02:00Z",
      "justificativa": "Reforço da última semana de novembro",
      "data_inicio": "2025-11-20", "data_fim": "2025-11-30",
      "pct_acrescimo": 1.0, "marcas_alvo": ["10"], "cargos_alvo": ["150"] },
    { "campanha_id": 10, "versao": 1, "nome": "Campanha B", "status": "APROVADA",
      "autor": "Gabriela", "aprovador": "Sílvia", "aprovada_em": "2026-10-16T10:30:00Z",
      "justificativa": "Gerentes puxam a virada para dezembro",
      "data_inicio": "2025-11-25", "data_fim": "2025-12-05",
      "pct_acrescimo": 0.5, "marcas_alvo": ["10"], "cargos_alvo": ["150"] }
  ]
}
```

- `campanhas` (novo, A6-74): as campanhas aprovadas e as que aguardam aprovação que cruzam o período e têm ao menos uma marca × cargo em comum com a regra, **sem** a própria campanha que está sendo simulada. Vem da versão aprovada (ou submetida) de cada uma. Lista vazia = nenhuma.
- As aprovadas entram na % vigente; as que aguardam aprovação só geram conflito.
- Só entram campanhas criadas no sistema. As campanhas da especificação entram pelo A6-77 (ver o card).

**Response (200 OK):** o resultado (2.3), com a `trilha`. Erros: 422 com `{etapa, mensagem, erros?, codigo?}`, como hoje.

---

## 5. Campanha e aprovação

### 5.1. Status e transições

**Situação:** nova (A6-64, A6-68).

Status gravados: `RASCUNHO`, `AGUARDANDO_APROVACAO`, `APROVADA`, `REPROVADA`, `ARQUIVADA`.

Calculados na leitura, **nunca gravados**:

- `vigencia`, só em `APROVADA`: `FUTURA` (hoje antes do início), `VIGENTE` (hoje dentro do período) ou `ENCERRADA` (hoje depois do fim). Nos outros status, `null`. Com o dataset de 2025, toda campanha aprovada nessas datas aparece como `ENCERRADA`.
- `em_simulacao`: `true` quando a campanha tem uma simulação `PENDENTE` ou `RODANDO`. A tela mostra a etiqueta "Em simulação" (é o "em simulação" da US-10, A6-49). Antes de salvar, o front já sabe disso, porque foi ele que pediu a simulação.

| De | Para | Rota | Quem |
|---|---|---|---|
| (nova) | `RASCUNHO` | `POST /api/campanhas` | GERENTE ou SUPERVISOR, depois de ao menos uma simulação |
| `RASCUNHO` | `AGUARDANDO_APROVACAO` | `POST /api/campanhas/{id}/submeter` | autor |
| `AGUARDANDO_APROVACAO` | `APROVADA` ou `REPROVADA` | `POST /api/campanhas/{id}/decidir` | SUPERVISOR diferente do autor |
| `REPROVADA` | `RASCUNHO` | `POST /api/campanhas/{id}/editar` | autor |
| `RASCUNHO` ou `REPROVADA` | `ARQUIVADA` | `POST /api/campanhas/{id}/arquivar` | autor |
| `APROVADA` | `ARQUIVADA` | solicitação de cancelamento (5.10, fora da sprint) | |

Qualquer outra transição → **409**, com o status atual e o pedido na `message`. Ação do autor feita por outro usuário → **403**.

### 5.2. Objeto Campanha

É o que salvar, abrir e as ações do autor devolvem. Exemplo de uma campanha que teve a v1 reprovada:

```json
{
  "id": 12,
  "nome": "Black Friday 2025",
  "status": "REPROVADA",
  "vigencia": null,
  "em_simulacao": false,
  "autor": { "id": 1, "nome": "Gabriela" },
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "periodo": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
  "versao_atual": 1,
  "ultima_simulacao": {
    "id": 345,
    "regra": "<Regra 2.1>",
    "resultado": "<Resultado 2.3>",
    "concluida_em": "2026-10-21T12:59:02Z"
  },
  "versoes": [
    { "numero": 1, "status": "REPROVADA", "submetida_em": "2026-10-21T13:05:00Z",
      "decisao": { "decisao": "REPROVADA", "por": { "id": 2, "nome": "Sérgio" },
                   "em": "2026-10-21T14:20:00Z",
                   "justificativa": "a meta de R$ 2 milhões está abaixo da venda real do período (R$ 2,4 milhões)" } }
  ],
  "log": [
    { "de": null, "para": "RASCUNHO", "versao": null, "usuario": { "id": 1, "nome": "Gabriela" },
      "em": "2026-10-21T13:00:12Z", "justificativa": null },
    { "de": "RASCUNHO", "para": "AGUARDANDO_APROVACAO", "versao": 1, "usuario": { "id": 1, "nome": "Gabriela" },
      "em": "2026-10-21T13:05:00Z", "justificativa": null },
    { "de": "AGUARDANDO_APROVACAO", "para": "REPROVADA", "versao": 1, "usuario": { "id": 2, "nome": "Sérgio" },
      "em": "2026-10-21T14:20:00Z", "justificativa": "a meta de R$ 2 milhões está abaixo da venda real do período (R$ 2,4 milhões)" }
  ],
  "criada_em": "2026-10-21T13:00:12Z",
  "atualizada_em": "2026-10-21T14:20:00Z"
}
```

| Campo | Observação |
|---|---|
| `versao_atual` | Número da última versão submetida; `null` se a campanha nunca foi submetida |
| `ultima_simulacao` | A última simulação concluída da campanha. É ela que vira a próxima versão no submeter |
| `versoes` | Uma por submissão, da mais antiga para a mais nova (aba "Versões" do A6-67) |
| `log` | Toda mudança de status (`campanha_status_log`): quem, quando, de, para |

### 5.3. Salvar

**Situação:** nova (A6-64).

**`POST /api/campanhas`**

```json
{
  "nome": "Black Friday 2025",
  "chat_id": "c1f0a7e2-5b1d-4e0a-9d3c-2f6b8a7e4c10",
  "simulacao_id": 345
}
```

- A ficha e o resultado vêm da simulação gravada (A6-66), não do front. Assim o que fica salvo é exatamente o que foi simulado.
- As simulações anteriores daquele chat passam a apontar para a campanha (A6-66).

**Response (201 Created):** Campanha (5.2) em `RASCUNHO`, com `versao_atual: null`, `versoes: []` e o `log` com a criação.

| Status | Quando |
|---|---|
| 400 | Simulação não concluída ou de outro chat. Ex.: `Simule antes de salvar: a simulação 345 está em RODANDO` |
| 403 | Conversa de outro usuário |
| 409 | A conversa já tem campanha (uma conversa, uma campanha) |

### 5.4. Listar as minhas

**Situação:** nova (A6-64, A6-67).

**`GET /api/campanhas/minhas`**, com o filtro opcional `?status=RASCUNHO`.

```json
[
  {
    "id": 12,
    "nome": "Black Friday 2025",
    "status": "RASCUNHO",
    "vigencia": null,
    "em_simulacao": false,
    "versao_atual": null,
    "periodo": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
    "custo_adicional": 23736.10,
    "atualizada_em": "2026-10-21T13:00:12Z"
  }
]
```

- `custo_adicional` = `resultado.totais.diferenca` da última simulação.

### 5.5. Fila do Supervisor

**Situação:** nova (A6-68, A6-69).

**`GET /api/campanhas?status=AGUARDANDO_APROVACAO`**

Só SUPERVISOR (GERENTE recebe 403). Devolve as versões que aguardam aprovação, **menos as que o próprio Supervisor submeteu**, das mais antigas para as mais novas. Nesta sprint, só esse valor de `status` é aceito aqui; outro valor → 400.

```json
[
  {
    "id": 12,
    "nome": "Black Friday 2025",
    "versao": 1,
    "autor": { "id": 1, "nome": "Gabriela" },
    "submetida_em": "2026-10-21T13:05:00Z",
    "periodo": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
    "custo_adicional": 23736.10,
    "conflitos": 0,
    "resimulacao_necessaria": false
  }
]
```

- `conflitos` = quantidade de itens em `resultado.conflitos` da versão (destaque na lista do A6-69).

### 5.6. Abrir a campanha e a versão

**Situação:** nova (A6-64, A6-68, A6-69).

**`GET /api/campanhas/{id}`** → Campanha (5.2).

Quem pode: o autor e, se a campanha tem ao menos uma versão submetida, os Supervisores. Outros recebem 403.

**`GET /api/campanhas/{id}/versoes/{numero}`** → a versão congelada: o que o autor viu ao submeter. É a tela de decisão do A6-69.

```json
{
  "campanha_id": 12,
  "numero": 1,
  "status": "AGUARDANDO_APROVACAO",
  "autor": { "id": 1, "nome": "Gabriela" },
  "submetida_em": "2026-10-21T13:05:00Z",
  "simulacao_id": 345,
  "regra": "<Regra 2.1>",
  "resultado": "<Resultado 2.3>",
  "ultima_mensagem_id": 104,
  "resimulacao_necessaria": true,
  "aprovadas_depois": [
    { "campanha_id": 14, "nome": "Semana do Vendedor", "aprovador": "Sílvia", "aprovada_em": "2026-10-21T13:40:00Z" }
  ],
  "resimulacao": null,
  "decisao": null
}
```

| Campo | Observação |
|---|---|
| `status` | Status da versão: `AGUARDANDO_APROVACAO`, `APROVADA` ou `REPROVADA` |
| `ultima_mensagem_id` | A conversa congelada vai até essa mensagem (aba "Conversa" do A6-69, via 3.2) |
| `resimulacao_necessaria` | `true` quando outra campanha que cruza o período foi aprovada depois da submissão e ainda não houve re-simulação. Com ela, o "Aprovar" fica desabilitado |
| `aprovadas_depois` | Essas campanhas, para o aviso "Outra campanha deste período foi aprovada depois da submissão" |
| `resimulacao` | Depois de 5.9: `{ "simulacao_id", "por", "em", "resultado" }`. A tela mostra o resultado antigo e o novo lado a lado |
| `decisao` | `{ "decisao", "por", "em", "justificativa" }`, ou `null` enquanto aguarda |

### 5.7. Ações do autor

**Situação:** nova (A6-64).

Todas devolvem a Campanha (5.2) atualizada. Só o `PUT` tem corpo.

| Rota | O que faz |
|---|---|
| `PUT /api/campanhas/{id}` | Renomeia: `{ "nome": "Black Friday 2025 - sem gerentes" }`. Só em `RASCUNHO`. A ficha não se edita aqui: o autor conversa e simula de novo com `campanha_id` (4.1), e a última simulação concluída vira a `ultima_simulacao` |
| `POST /api/campanhas/{id}/submeter` | Cria a versão (número = maior + 1), congelando ficha, resultado, trilha e conversa até ali. Grava a mensagem de sistema "Enviado para análise — v1" e avisa os Supervisores (8). 400 se não houver simulação concluída |
| `POST /api/campanhas/{id}/editar` | `REPROVADA` → `RASCUNHO`. Grava "Voltou para rascunho — a próxima submissão será a v2" |
| `POST /api/campanhas/{id}/arquivar` | `RASCUNHO` ou `REPROVADA` → `ARQUIVADA` |

### 5.8. Decidir

**Situação:** nova (A6-68). O `SecurityConfig` já libera a rota só para SUPERVISOR.

**`POST /api/campanhas/{id}/decidir`**

```json
{
  "versao": 1,
  "decisao": "REPROVAR",
  "justificativa": "a meta de R$ 2 milhões está abaixo da venda real do período (R$ 2,4 milhões)"
}
```

- `versao`: a versão que o Supervisor viu. Assim ninguém aprova uma versão diferente da que estava na tela.
- `decisao`: `APROVAR` ou `REPROVAR`. A `justificativa` é obrigatória ao reprovar e opcional ao aprovar.

**Response (200 OK):** Campanha (5.2) em `APROVADA` ou `REPROVADA`. O backend grava o log e a mensagem de sistema ("Aprovado por Sílvia — v1" ou "Reprovado por Sérgio: {justificativa}") e resolve os avisos daquele item (8).

Verificações, nesta ordem:

| Verificação | Se falhar | `message` |
|---|---|---|
| Perfil é SUPERVISOR | 403 | `Sem permissão para esta ação` |
| Quem decide ≠ autor | 403 | `Outra pessoa precisa aprovar esta campanha` |
| A `versao` está em `AGUARDANDO_APROVACAO` | 409 | `Esta versão já foi decidida por Sílvia em 21/10/2026` (vale a primeira decisão) |
| Reprovar com justificativa não vazia | 400 | `Justificativa obrigatória para reprovar` |
| Sem `resimulacao_necessaria`, ou já re-simulada | 409 | `Simule de novo antes de aprovar` |

As duas respostas 409 se distinguem pela `message`. A tela já sabe da re-simulação antes, pelo `resimulacao_necessaria` (5.6).

### 5.9. Re-simular na aprovação

**Situação:** nova (A6-68). Precisa de linha própria no `SecurityConfig`, como o decidir.

**`POST /api/campanhas/{id}/versoes/{numero}/resimular`** (sem corpo)

Só SUPERVISOR, com a versão em `AGUARDANDO_APROVACAO` (senão 409). Simula de novo a ficha congelada da versão, com a % vigente de hoje. Devolve o job, como em 4.1 (202), e o front acompanha por 4.2. Ao concluir, o backend preenche `resimulacao` na versão: os dois resultados ficam gravados, e a decisão vale sobre o número novo.

### 5.10. Solicitar cancelamento (futuro)

**Situação:** fora da sprint (A6-88, a decidir). Não implementar agora.

Quando entrar: `POST /api/campanhas/{id}/cancelamento` com `{ "motivo": "..." }`. O pedido vira um item da mesma fila de aprovação; ao ser aprovado, a campanha passa a `ARQUIVADA` e sai da % vigente a partir da data da aprovação.

---

## 6. Correção da base

**Situação:** nova (A6-80, A6-81).

Uma correção pontual na base cadastral vira uma **solicitação**, aplicada só depois de aprovada por outra pessoa, no mesmo fluxo das campanhas.

| `tipo` | `antes` e `depois` |
|---|---|
| `TRANSFERENCIA_LOJA` | código da loja (`cod_loja`) |
| `TROCA_CARGO` | código do cargo |
| `DATA_ADMISSAO` | dia (`YYYY-MM-DD`) |
| `DATA_DEMISSAO` | dia (`YYYY-MM-DD`); `antes` é `null` quando não havia demissão |

Status: `PENDENTE`, `APROVADA`, `REPROVADA`.

### 6.1. Criar

**`POST /api/correcoes`**

```json
{
  "tipo": "TRANSFERENCIA_LOJA",
  "matricula": "MATRIC-38",
  "competencia": "2025-10",
  "antes": "33",
  "depois": "8",
  "motivo": "Transferida para a LOJA-8 em outubro",
  "origem": "USUARIO",
  "chat_id": null
}
```

- O **autor vem do token** (usuário logado), nunca do corpo.
- `antes` tem que ser o valor atual da base. A MATRIC-38 está na LOJA-33 em out/2025; com outro `antes`, a resposta é 400 com o valor atual na `message`. A matrícula e a competência também precisam existir (400).
- **Pela Lana (A6-81):** a Lana devolve a solicitação, sem autor, em `solicitacao_json` (3.3). O backend cria com `origem: "LANA"`, o `chat_id` da conversa e o usuário logado como autor, e a devolve em `solicitacao` na resposta do chat (3.1).

**Response (201 Created):**
```json
{
  "id": 7,
  "tipo": "TRANSFERENCIA_LOJA",
  "matricula": "MATRIC-38",
  "competencia": "2025-10",
  "antes": "33",
  "depois": "8",
  "motivo": "Transferida para a LOJA-8 em outubro",
  "origem": "USUARIO",
  "chat_id": null,
  "status": "PENDENTE",
  "autor": { "id": 1, "nome": "Gabriela" },
  "criada_em": "2026-10-21T15:10:00Z",
  "decisao": null
}
```

### 6.2. Fila e detalhe

- **`GET /api/correcoes?status=PENDENTE`**: só SUPERVISOR; lista as pendentes, menos as que o próprio Supervisor abriu.
- **`GET /api/correcoes/{id}`**: o autor e os Supervisores. Com `origem: "LANA"`, a tela mostra "aberta pela Lana a pedido de Gabriela" e o link para a conversa.

### 6.3. Decidir

**`POST /api/correcoes/{id}/decidir`**

```json
{ "decisao": "APROVAR", "justificativa": "" }
```

Ao aprovar, a correção é aplicada na base **na mesma transação**: no exemplo, o `funcionario_loja` de out/2025 da MATRIC-38 passa a apontar para a LOJA-8. Ao reprovar, nada muda. Devolve a correção com `status` e `decisao` preenchidos.

| Verificação | Se falhar | `message` |
|---|---|---|
| Perfil é SUPERVISOR | 403 | `Sem permissão para esta ação` |
| Quem decide ≠ autor | 403 | `Outra pessoa precisa aprovar esta correção` |
| Ainda `PENDENTE` | 409 | `Esta correção já foi decidida por Sílvia em 21/10/2026` |
| Reprovar com justificativa não vazia | 400 | `Justificativa obrigatória para reprovar` |
| `antes` ainda igual à base | 409 | `A base mudou desde o pedido` |

---

## 7. Importação da base do mês

**Situação:** existe (A6-78). Só SUPERVISOR.

### 7.1. Enviar as planilhas

**`POST /api/importacao`** (`multipart/form-data`)

Campo `arquivos` com uma ou mais planilhas `.xlsx` do mês (`BASE_VENDAS_NOV25.xlsx`, `BASE RH_NOV25.xlsx`, `BASE_COMMISS_FINAL.xlsx`). O backend reconhece cada planilha pelo conteúdo, então não há campo de tipo.

```bash
curl -X POST http://localhost:8080/api/importacao \
  -H "Authorization: Bearer <token>" \
  -F "arquivos=@BASE RH_NOV25.xlsx" \
  -F "arquivos=@BASE_VENDAS_NOV25.xlsx"
```

**Response (202 Accepted):**
```json
{ "id": 6, "status": "PROCESSANDO" }
```

| Status | Quando |
|---|---|
| 400 | Nenhum arquivo enviado |
| 409 | Já existe uma importação em andamento |

Essas duas respostas vêm do `ResponseStatusException`, que o `GlobalExceptionHandler` não trata: o corpo é o padrão do Spring, sem `message`. O front decide o texto pelo status.

### 7.2. Acompanhar e ver as pendências

**`GET /api/importacao/{id}`**

```json
{
  "id": 6,
  "status": "CONCLUIDO",
  "competencia": "2025-11",
  "usuario": "Sérgio",
  "total_linhas": 5469,
  "linhas_importadas": 5467,
  "totais": { "RH": 469, "VENDAS": 4998, "COMISSAO": 0 },
  "pendencias": [
    {
      "origem": "Cruzamento",
      "linha": 681,
      "campo": "Matricula",
      "motivo": "matrícula MATRIC-207 não encontrada no RH da competência; a venda de 2025-11-01 (R$ 798.2) não será gravada",
      "severidade": "AVISO"
    }
  ],
  "criada_em": "2026-10-20T01:39:39Z",
  "concluida_em": "2026-10-20T01:40:50Z"
}
```

| Status do job | Significado |
|---|---|
| `PROCESSANDO` | Em andamento |
| `CONCLUIDO` | Gravado; pode ter pendências `AVISO` |
| `PENDENTE` | Há pendência `IMPEDITIVO`: nada é gravado (`linhas_importadas: 0`) |
| `FALHA` | Erro inesperado, ou job interrompido por um reinício |

- `severidade`: `IMPEDITIVO` ou `AVISO`. `usuario` é o nome de quem importou.
- **`GET /api/importacao`**: histórico, com os mesmos campos menos `totais` e `pendencias`.

---

## 8. Avisos

**Situação:** nova (A6-82, A6-83). Só SUPERVISOR.

Quando uma campanha ou correção é submetida, cada Supervisor **ativo**, menos o autor, recebe um aviso dentro do sistema. Quando alguém decide o item, o aviso é resolvido para todos e sai da lista. Não há e-mail, push nem WebSocket: o front consulta a cada 30 segundos.

**`GET /api/avisos`**: avisos pendentes do usuário logado, dos mais recentes para os mais antigos.

```json
[
  {
    "id": 32,
    "tipo": "CORRECAO",
    "descricao": "Lana abriu correção da MATRIC-38 a pedido de Gabriela",
    "campanha_id": null,
    "versao": null,
    "correcao_id": 7,
    "criado_em": "2026-10-21T15:10:00Z"
  },
  {
    "id": 31,
    "tipo": "CAMPANHA",
    "descricao": "Gabriela submeteu Black Friday 2025 (v1)",
    "campanha_id": 12,
    "versao": 1,
    "correcao_id": null,
    "criado_em": "2026-10-21T13:05:00Z"
  }
]
```

- `descricao` vem pronta do backend; o "há 5 min" o front calcula a partir de `criado_em`.
- Clique: `CAMPANHA` abre a versão (5.6); `CORRECAO` abre a correção (6.2).

**`GET /api/avisos/contador`**

```json
{ "pendentes": 2 }
```

---

## Histórico do documento

- 07/10/2026, Victor: primeira versão (PR #4).
- 10/10 e 14/10/2026, Victor: login e salvar campanha, depois da revisão do PR.
- 21/10/2026, Leonardo: aplica o restante da revisão do PR #4; alinha com o que já entrou na `develop` (chat por gRPC, importação, formato de erro); acrescenta conversa, job de simulação, versões, decisão, re-simulação, correção da base e avisos.
