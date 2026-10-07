# Contratos de API - Sprint 2 (Front, Back e Lana)

Este documento centraliza os formatos JSON (requests e responses) que trafegarão entre Frontend, Backend e o Agente Lana durante a Sprint 2. Ele serve como **contrato principal** para que todos os desenvolvedores (login, campanha, conversa, trilha, resultado, avisos) possam trabalhar com mocks, evitando bloqueios mútuos.

> **Importante:** Todos os exemplos utilizam dados baseados no dataset real do domínio.

---

## 1. Login

**`POST /api/auth/login`**

- **Headers na Resposta:** 
  - Para usuários de desenvolvimento/administração, o header `X-Usuario-Dev: true` será injetado.

**Request:**
```json
{
  "email": "gerente.vendas@camplana.com.br",
  "senha": "password123"
}
```

**Response (200 OK):**
```json
{
 
}
```

---

## 2. Campanha

Define os contratos para o ciclo de vida da campanha, suportando controle de **status e versões**.

### 2.1. Salvar Rascunho / Atualizar
**`POST /api/campanhas`** (Cria nova versão se já existir em rascunho)

**Request / Response (200 OK):**
```json
{
  "id": "camp-bf-2025-11",
  "versao": 2,
  "status": "RASCUNHO",
  "titulo": "Black Friday 2025 - Vendedores e Gerentes",
  "parametros": {
    "periodo": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
    "pct_acrescimo": 1.0,
    "marcas_alvo": ["10", "20"],
    "cargos_alvo": ["100", "150"],
    "meta_vendas": 500000.00,
    "orcamento_limite": 25000.00
  }
}
```

### 2.2. Listar as Minhas
**`GET /api/campanhas/minhas`**

**Response (200 OK):**
```json
[
  {
    "id": "camp-bf-2025-11",
    "versao": 2,
    "titulo": "Black Friday 2025 - Vendedores e Gerentes",
    "status": "RASCUNHO",
    "ultima_atualizacao": "2025-10-07T10:30:00Z"
  }
]
```

### 2.3. Abrir Campanha
**`GET /api/campanhas/camp-bf-2025-11`**
Retorna o mesmo payload do endpoint de "Salvar".

### 2.4. Ações de Ciclo de Vida
Todos estes usam requisições `POST` sem body (ou com observação opcional) e retornam a campanha com o **status atualizado**:
- **Submeter para aprovação:** `POST /api/campanhas/{id}/submeter` -> `status: "AGUARDANDO_APROVACAO"`
- **Decidir (Aprovar/Rejeitar):** `POST /api/campanhas/{id}/decidir` -> payload `{ "aprovado": true, "motivo": "" }` -> `status: "APROVADO"`
- **Arquivar:** `POST /api/campanhas/{id}/arquivar` -> `status: "ARQUIVADO"`
- **Solicitar Cancelamento:** `POST /api/campanhas/{id}/cancelar` -> `status: "CANCELAMENTO_SOLICITADO"`

---

## 3. Chat (Interação com a Lana)

**`POST /api/chat`**

**Request:**
```json
{
  "chat_id": "thread-12345",
  "message": "Quero dar +1% de comissão para a marca PRETO no período da Black Friday",
  "historico": [
    { "role": "user", "content": "Quero criar uma campanha para Vendedores" },
    { "role": "assistant", "content": "Para qual período e quais marcas?" }
  ],
  "regra": null
}
```

**Response (200 OK):**
```json
{
  "resposta": "Entendido! Preenchi a ficha da campanha para Vendedores e Gerentes da marca PRETO durante a Black Friday. Gostaria de rodar uma simulação para ver o impacto no orçamento?",
  "ficha": {
    "tipo_regra": "BONUS_TEMPORARIO",
    "parametros": {
      "periodo": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
      "pct_acrescimo": 1.0,
      "marcas_alvo": ["10"],
      "cargos_alvo": ["100", "150"]
    }
  },
  "mensagens_sistema": [
    {
      "tipo": "INFO",
      "texto": "A marca PRETO representa 45% do faturamento histórico neste período."
    }
  ],
  "trilha": null
}
```

*(Nota: O objeto `trilha` é detalhado no tópico 5 e pode vir preenchido se a Lana executou ferramentas).*

---

## 4. Job de Simulação e Resultado da Simulação

A simulação é assíncrona. O Frontend inicia o job e faz polling do status.

### 4.1. Iniciar Job
**`POST /api/simulacoes`**

**Request:**
```json
{
  "chat_id": "thread-12345",
  "regra": {
      "periodo": { "data_inicio": "2025-11-24", "data_fim": "2025-11-30" },
      "pct_acrescimo": 1.0,
      "marcas_alvo": ["10"],
      "cargos_alvo": ["100"],
      "meta_vendas": 500000.00,
      "orcamento_limite": 25000.00
  }
}
```

**Response (202 Accepted):**
```json
{
  "job_id": "job-sim-789",
  "status": "PROCESSANDO",
  "etapa": "Extraindo dados da base (mês vigente)..."
}
```

### 4.2. Consultar Job (Polling)
**`GET /api/simulacoes/job-sim-789`**

**Response (200 OK - Finalizado):**
```json
{
  "job_id": "job-sim-789",
  "status": "CONCLUIDO",
  "etapa": "Simulação finalizada.",
  "resultado": {
    "rule_id": "draft-bf-2025-11",
    "meta": {
      "valor_meta": 500000.00,
      "vendas_projetadas": 515000.00,
      "diferenca": 15000.00,
      "atingida": true
    },
    "retorno_provisorio": 18500.00,
    "percentual_vigente_marca_cargo_trecho": [
      {
        "marca": "10",
        "nome_marca": "PRETO",
        "cargo": "100",
        "nome_cargo": "VENDEDOR LOJA",
        "trecho": "0 a 100%",
        "pct_vigente": 3.5,
        "pct_com_campanha": 4.5
      }
    ],
    "conflitos": [
      {
        "tipo": "SOBREPOSICAO_MARCA",
        "campanha_conflitante": "camp-inverno-2025",
        "mensagem": "A marca PRETO já possui bônus ativo no período de 24/11 a 30/11."
      }
    ],
    "regras_base_aplicadas": [
      "REGRA_COMISSAO_PADRAO_VENDEDOR",
      "TETO_ORCAMENTO_GLOBAL"
    ],
    "orcamento": {
      "orcamento_limite": 25000.00,
      "custo_incremental": 23736.10,
      "folga": 1263.90,
      "cabe_no_orcamento": true
    }
  }
}
```

---

## 5. Trilha de Raciocínio (Agent Reasoning / Tools)

A trilha vem embutida na resposta do Chat ou da Simulação, para dar transparência sobre como a Lana pensou e quais dados consultou.

**Exemplo do objeto `trilha`:**
```json
{
  "premissas": [
    "O usuário deseja focar no cargo VENDEDOR LOJA (100).",
    "A marca alvo é PRETO (10)."
  ],
  "modelo": "gemini-1.5-pro",
  "passos": [
    {
      "ferramenta": "query_tool",
      "descricao": "Consultando histórico de vendas da marca PRETO em Nov/2024 para criar projeção",
      "tabelas_acessadas": ["vendas_historico", "marcas"],
      "competencias": ["2024-11"],
      "filtros": "marca_id = 10 AND cargo_id = 100",
      "sql_executado": "SELECT SUM(valor) FROM vendas_historico WHERE marca_id = 10 AND ...",
      "registros_retornados": 15420,
      "tempo_ms": 340,
      "situacao": "SUCESSO"
    },
    {
      "ferramenta": "regra_tool",
      "descricao": "Validando se a regra ultrapassa o teto financeiro global",
      "tabelas_acessadas": [],
      "competencias": [],
      "filtros": "",
      "sql_executado": null,
      "registros_retornados": 0,
      "tempo_ms": 45,
      "situacao": "SUCESSO"
    }
  ]
}
```

---

## 6. Solicitação de Correção da Base

Quando o usuário ou a própria Lana identificam dados incorretos, podem registrar uma solicitação de correção.

**`POST /api/correcoes`**

**Request:**
```json
{
  "chat_id": "thread-12345",
  "tipo": "AJUSTE_COMISSAO",
  "matricula": "987654",
  "competencia": "2025-10",
  "antes": {
    "pct_comissao": 3.0
  },
  "depois": {
    "pct_comissao": 4.5
  },
  "autor": "joao.silva",
  "origem": "LANA"
}
```

**Response (201 Created):**
```json
{
  "id": "cor-001",
  "status": "PENDENTE_APROVACAO",
  "mensagem": "Solicitação registrada com sucesso e enviada aos administradores."
}
```

---

## 7. Importação de Dados (Dataset)

Endpoints de integração de dados em lote.

### 7.1. Submeter Job de Importação
**`POST /api/importacao`**

**Request:**
```json
{
  "tipo_entidade": "VENDAS",
  "url_arquivo": "s3://bucket/dataset-bf-2025.csv"
}
```

**Response (202 Accepted):**
```json
{
  "job_id": "job-imp-444",
  "status": "PROCESSANDO"
}
```

### 7.2. Relatório de Pendências / Erros
**`GET /api/importacao/job-imp-444/relatorio`**

**Response (200 OK):**
```json
{
  "job_id": "job-imp-444",
  "status": "CONCLUIDO_COM_ERROS",
  "total_linhas": 50000,
  "linhas_importadas": 49998,
  "pendencias": [
    {
      "origem": "dataset-bf-2025.csv",
      "linha": 1432,
      "campo": "marca_id",
      "motivo": "ID da marca não cadastrado (99)",
      "severidade": "ERRO_BLOQUEANTE"
    },
    {
      "origem": "dataset-bf-2025.csv",
      "linha": 45112,
      "campo": "valor_venda",
      "motivo": "Valor negativo, ajustado para absoluto por regra de negócio.",
      "severidade": "AVISO"
    }
  ]
}
```

---

## 8. Avisos e Notificações

Para manter o usuário atualizado de requisições, aprovações ou alertas do sistema.

**`GET /api/avisos`**

**Response (200 OK):**
```json
{
  "contador_nao_lidos": 2,
  "lista": [
    {
      "id": "av-101",
      "titulo": "Campanha Aprovada",
      "mensagem": "Sua campanha 'Black Friday 2025' foi aprovada.",
      "data": "2025-10-07T09:15:00Z",
      "lida": false,
      "link_acao": "/campanhas/camp-bf-2025-11"
    },
    {
      "id": "av-102",
      "titulo": "Erro na Importação",
      "mensagem": "O job job-imp-444 finalizou com 2 pendências.",
      "data": "2025-10-07T08:30:00Z",
      "lida": false,
      "link_acao": "/configuracoes/importacoes"
    }
  ]
}
```
