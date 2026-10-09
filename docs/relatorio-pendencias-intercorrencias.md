# Relatório de Pendências: Intercorrências da Especificação Dom Rock (jul a dez/2025)

Gerado por `scripts/importar-intercorrencias.sh` a partir de `scripts/intercorrencias.sql`.
O script não corrige nada, só lista: IMPEDITIVO não é carregado em `evento_rh`;
AVISO é carregado (se repetido, só a primeira ocorrência) e fica listado aqui.

## Resumo

- Linhas lidas da especificação: 34
- Eventos válidos, carregados uma vez: 26
- Pendências AVISO: 11
- Pendências IMPEDITIVO: 1
- Total em evento_rh: 26

## Pendências

| Origem | Item | Campo | Motivo | Severidade | Tratamento |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Especificacao dez/2025 item d | MATRIC-318 | data_fim | Férias com data final antes da inicial (15/12/2025 a 02/12/2025) | **IMPEDITIVO** | Não carregada em evento_rh. |
| Especificacao jul/2025 item a | MATRIC-58 | data_inicio | Afastamento começa antes da admissão cadastrada (01/09/2025) | **AVISO** | Carregada; fica o alerta. |
| Especificacao jul/2025 item a | MATRIC-58 | data_fim | Afastamento de exatamente 15 dias (10/07/2025 a 24/07/2025); conta como até 15 | **AVISO** | Carregada; fica o alerta. |
| Especificacao jul/2025 item g | MATRIC-293 | cod_loja / dias | Cobertura de loja sem intervalo de datas (10 dias na LOJA-5) | **AVISO** | Carregada; fica o alerta. |
| Especificacao set/2025 item b | MATRIC-126 | origem | Afastamento repetido, já informado em mês anterior (18/08/2025 a 08/09/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
| Especificacao set/2025 item c | MATRIC-137 | data_fim | Afastamento repetido com data final diferente da primeira ocorrência (26/08/2025 a 05/09/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
| Especificacao out/2025 item d | MATRIC-71 | data_fim | Licença maternidade sem data de término (a partir de 01/10/2025) | **AVISO** | Carregada; fica o alerta. |
| Especificacao nov/2025 item a | MATRIC-179 | origem | Afastamento repetido, já informado em mês anterior (17/10/2025 a 20/11/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
| Especificacao nov/2025 item c | MATRIC-71 | origem | Licença maternidade repetido, já informado em mês anterior (a partir de 01/10/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
| Especificacao dez/2025 item b | MATRIC-5 | origem | Afastamento repetido, já informado em mês anterior (10/11/2025 a 12/12/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
| Especificacao dez/2025 item c | MATRIC-71 | origem | Licença maternidade repetido, já informado em mês anterior (a partir de 01/10/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
| Especificacao dez/2025 item e | MATRIC-52 | origem | Férias repetido, já informado em mês anterior (24/11/2025 a 12/12/2025) | **AVISO** | Não carregada de novo; vale a primeira ocorrência. |
