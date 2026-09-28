# API 6º Semestre ADS — CAMPLANA AI

## Documentação — Sprint 1

## Desafio <a id="desafio"></a>
Chat inteligente voltado à interação com regras de negócio, permitindo sua identificação e interpretação para simulação.

## Backlog da Sprint

<a id="backlog"></a>

| Rank | Prioridade | User Story | Estimativa | Sprint |
| :--: | :--------: | :--- | :--------: | :-----: |
| 1 | Alta | Como Gerente de Vendas, quero conversar com o agente por uma interface de chat, para descrever a regra em linguagem natural e receber as respostas dele. | 5 | 1 |
| 2 | Alta | Como Gerente de Vendas, quero que o agente interprete meu comando e me mostre os parâmetros extraídos (produto, meta, % de comissão, vigência, público-alvo), para eu confirmar que ele entendeu corretamente. | 13 | 1 |
| 3 | Alta | Como Gerente de Vendas, quero revisar e editar os parâmetros interpretados antes de simular, para corrigir erros de interpretação. | 8 | 1 |
| 4 | Alta | Como Gerente de Vendas, quero que o agente gere o artefato executável da simulação a partir dos parâmetros confirmados, para que a regra possa ser calculada sobre dados reais.| 13 | 1 |
| 5 | Alta |Como Gerente de Vendas, quero executar a simulação de um cenário de atingimento de meta, para ver o valor total de comissionamento resultante.| 8 | 1 |

## 🏅 DoR — Definition of Ready <a id="dor"></a>

Critérios utilizados para verificar se uma história está suficientemente preparada para entrar em desenvolvimento.

| Critério                       | Descrição                                                                                                                          |
| :----------------------------- | :--------------------------------------------------------------------------------------------------------------------------------- |
| Clareza da descrição           | A User Story apresenta de forma clara a pessoa usuária, a ação desejada e o objetivo a ser alcançado.                              |
| Critérios de aceitação         | A história possui critérios objetivos que definem as condições necessárias para sua conclusão.                                     |
| Cenários de teste              | A história possui pelo menos um cenário de teste estruturado em Dado, Quando e Então.                                              |
| Referência visual              | O protótipo ou material visual necessário para a implementação está disponível, quando aplicável.                                  |
| Escopo técnico definido        | Está especificado se a história envolve frontend, backend, IA ou integração entre esses componentes.                               |
| Regras de negócio definidas    | As regras de comissionamento, entradas, resultados esperados e possíveis exceções estão descritas e compreendidas.                 |
| Estimativa definida            | A história possui uma estimativa de esforço definida e discutida pela equipe.                                                      |


## 🏅 DoD — Definition of Done <a id="dod"></a>

Critérios utilizados para verificar se uma história foi desenvolvida, testada e validada de acordo com o que foi definido. 

| Critério                         | Descrição                                                                                                  |
| :------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| Critérios de aceitação atendidos | Todos os critérios definidos para a história foram implementados e verificados.                            |
| Regras de negócio conferidas     | O comportamento da funcionalidade foi validado com exemplos de entrada, saída e exceções previstas.        |
| Código revisado                  | A implementação passou por revisão de código realizada por outro integrante da equipe.                     |
| Funcionalidade integrada         | A funcionalidade foi integrada à aplicação e testada dentro do fluxo correspondente.                       |
| Documentação atualizada          | As documentações, regras e instruções impactadas pela implementação foram atualizadas.                     |
| Validação funcional pelo PO      | O Product Owner verificou a funcionalidade e confirmou que a história atende ao que foi definido.          |
