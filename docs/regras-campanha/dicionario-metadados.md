# Estrutura de Parâmetros da Regra

## 1. Dicionário de Metadados

| Campo (key) | Rótulo (label) | Tipo (type) | Categoria | Valores Aceitos |
| :--- | :--- | :--- | :--- | :--- |
| tipo_regra | Tipo da Regra | select | - | Identifica o tipo de regra |
| periodo | Prazo da Campanha | date_range | REGRA | Formato YYYY-MM-DD |
| pct_acrescimo | Acréscimo de Comissão (%) | percentage | REGRA | Decimal (ex: 1.0 = +1%) |
| marcas_alvo | Marcas Participantes | multi_select | REGRA | Tabela marca (10, 20, 30, 40, 50, 60, ALL) |
| cargos_alvo | Cargos Elegíveis | multi_select | REGRA | Tabela cargo (100, 150, 200, 300) |
| meta_vendas | Meta Financeira (R$) | currency | CONSTRAINT | Valor monetário em R$ |
| orcamento_limite | Orçamento Máximo (R$) | currency | CONSTRAINT | Teto financeiro em R$ |

## 2. Mock JSON

\`\`\`json
{
  "rule_id": "draft-bf-2025-11",
  "tipo_regra": "BONUS_TEMPORARIO",
  "raw_prompt": "Todas as vendas no período de 24/11 a 30/11 terão um acréscimo no % de comissão de +1%.",
  "status": "DRAFT_PENDING_REVIEW",
  "parametros": [
    {
      "key": "periodo",
      "label": "Prazo da Campanha",
      "type": "date_range",
      "categoria": "REGRA",
      "value": {
        "data_inicio": "2025-11-24",
        "data_fim": "2025-11-30"
      },
      "required": true
    },
    {
      "key": "pct_acrescimo",
      "label": "Acréscimo de Comissão (%)",
      "type": "percentage",
      "categoria": "REGRA",
      "value": 1.0,
      "required": true
    },
    {
      "key": "marcas_alvo",
      "label": "Marcas Participantes",
      "type": "multi_select",
      "categoria": "REGRA",
      "value": ["ALL"],
      "options": [
        { "id": "ALL", "label": "Todas as Marcas" },
        { "id": "10", "label": "PRETO (10)" },
        { "id": "20", "label": "BRANCO (20)" },
        { "id": "30", "label": "AZUL (30)" },
        { "id": "40", "label": "VERMELHO (40)" },
        { "id": "50", "label": "AMARELO (50)" },
        { "id": "60", "label": "CINZA (60)" }
      ],
      "required": true
    },
    {
      "key": "cargos_alvo",
      "label": "Cargos Elegíveis",
      "type": "multi_select",
      "categoria": "REGRA",
      "value": ["100", "200", "300"],
      "options": [
        { "id": "100", "label": "VENDEDOR LOJA" },
        { "id": "150", "label": "GERENTE" },
        { "id": "200", "label": "VENDEDOR BALCAO" },
        { "id": "300", "label": "ASSISTENTE DE VENDAS" }
      ],
      "required": true
    },
    {
      "key": "meta_vendas",
      "label": "Meta Financeira da Campanha (R$)",
      "type": "currency",
      "categoria": "CONSTRAINT",
      "value": null,
      "required": true
    },
    {
      "key": "orcamento_limite",
      "label": "Orçamento Máximo de Incentivo (R$)",
      "type": "currency",
      "categoria": "CONSTRAINT",
      "value": null,
      "required": true
    }
  ]
}
\`\`\`