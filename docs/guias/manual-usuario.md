# Manual do Usuário — Camplana

O **Camplana** é a plataforma de planejamento, simulação e governança de campanhas de comissionamento da Dom Rock, desenvolvida para auxiliar equipes comerciais e de gestão na tomada de decisões estratégicas embasadas em dados históricos reais.

A aplicação conta com a **Lana**, uma agente de IA que interpreta regras de negócio em linguagem natural, traduz os parâmetros para o painel de controle e executa simulações financeiras com total explicabilidade e rastreabilidade dos números apurados.

---

## 1. Perfis de Usuário e Acesso ao Sistema

O sistema conta com três perfis de acesso bem definidos:

- **Gerente de Vendas (`GERENTE`):** conversa com a Lana no chat, revisa e ajusta parâmetros de regras, executa simulações, salva e acompanha o status de suas campanhas, e as submete para avaliação.
- **Supervisor de Vendas (`SUPERVISOR`):** além de todas as funções do Gerente, analisa campanhas submetidas na fila de aprovação (aprovação quatro-olhos), decide com justificativa (aprovar ou reprovar), re-simula versões congeladas, consulta o percentual vigente por marca/cargo e importa os lotes mensais de dados (RH, Vendas e Comissão).
- **Administrador (`ADMIN`):** gerencia o cadastro dos usuários do sistema (criação, edição de dados, definição de perfil e ativação/desativação). Não atua no fluxo de campanhas nem simulações.

### 1.1 Entrando no Sistema (Login)
1. Acesse o endereço da aplicação no navegador (ex.: `http://localhost:5173`).
2. Digite o e-mail e senha de acesso.
   - Demonstração: `gabriela@camplana.com.br`, `sergio@camplana.com.br`, `silvia@camplana.com.br` ou `ana@camplana.com.br`, com a senha padrão `123456`.
3. O sistema valida as credenciais contra a API via token JWT e redireciona automaticamente para a tela correspondente ao seu perfil de atuação:
   - Gerentes e Supervisores entram na tela de **Chat / Planejamento**.
   - Administradores são encaminhados para a **Gestão de Usuários**.

---

## 2. Planejando e Simulando uma Campanha (Gerente de Vendas)

### 2.1 Conversa com a Lana em Linguagem Natural
Na página principal de Chat:
1. Digite a intenção da campanha na barra de mensagens inferior.
   - *Exemplo:* `"Todas as vendas de 24/11 a 30/11 terão +1% de comissão (Black Friday) para todas as marcas e cargos, exceto gerentes (cargo 150), com meta de R$ 2.000.000."`
2. A Lana interpreta o comando e preenche a ficha de parâmetros no painel lateral direito (**Campanha**).

### 2.2 Revisão de Parâmetros
No painel lateral, você pode revisar e ajustar diretamente os campos:
- **Prazo da Campanha (Período):** datas de início e fim da ação comercial;
- **Acréscimo de Comissão (%):** percentual adicional a ser concedido sobre as vendas;
- **Marcas Participantes:** seleção de marcas específicas ou "Todas as Marcas";
- **Cargos Elegíveis:** seleção dos cargos que recebem o incentivo (ex.: Vendedor Loja, Assistente, Balcão);
- **Meta Financeira da Campanha (R$):** volume de vendas esperado;
- **Orçamento Máximo de Incentivo (R$):** teto financeiro opcional para a campanha.

### 2.3 Execução da Simulação
1. Com a ficha conferida, clique no botão **Simular campanha**.
2. A simulação é processada em segundo plano (job assíncrono): o painel apresenta o indicador de progresso ("Na fila" → "Simulando" → "Concluída").
3. Ao concluir, o resultado financeiro da campanha é exibido:
   - **Custo Adicional (Diferença):** valor extra estimado que a regra demanda além da folha base;
   - **Impacto de Meta:** vendas apuradas no período, percentual de atingimento e se a meta foi superada;
   - **Impacto em Pessoas:** quantidade de colaboradores elegíveis impactados e valores médios;
   - **Detalhamento:** gráficos e tabelas com a distribuição do custo por Marca, por Cargo e pelas Maiores Lojas.

---

## 3. Explicabilidade: "De onde vieram esses números?"

Ao analisar qualquer simulação concluída, o usuário pode clicar em **"De onde vieram esses números"** para consultar a trilha de auditoria completa gerada pela Lana:
- **Passos executados:** sequência exata de processamento (carregamento de bases, cálculo do baseline sem campanha, geração e conferência do código da regra);
- **Consultas e Tabelas:** quais tabelas do banco de dados foram consultadas (`venda`, `funcionario_loja`, `marca_cargo`), filtros aplicados e competências lidas;
- **Conferência de Integridade:** validações aplicadas pelo algoritmo de referência (ausência de comissões negativas, conferência determinística);
- **Código Python da Regra:** supervisores têm visibilidade sobre o código gerado para conferência técnica.

---

## 4. Gestão e Ciclo de Vida da Campanha

### 4.1 Salvando a Campanha
Após rodar uma simulação satisfatória:
1. No painel de resultados, clique em **Salvar Campanha**.
2. Informe o nome da campanha (ex.: `"Black Friday 2025"`).
3. A campanha é criada no status **`RASCUNHO`**.

### 4.2 Acompanhando "Minhas Campanhas"
Acesse o menu lateral **Minhas Campanhas** (`/campanhas`):
- Visualize a lista de todas as suas campanhas criadas, ordenadas pela atualização mais recente.
- Cada cartão apresenta o status atual, período de vigência, custo adicional calculado e ações disponíveis:
  - **`RASCUNHO`:** permite **Renomear**, **Submeter para análise** ou **Arquivar**.
  - **`AGUARDANDO_APROVACAO`:** versão congelada em análise pela supervisão.
  - **`APROVADA`:** campanha aprovada e registrada na esteira comercial.
  - **`REPROVADA`:** reprovada com justificativa visível. Permite a ação **Editar** (que retorna a campanha para Rascunho para ajustes e nova submissão v2) ou **Arquivar**.

### 4.3 Submissão para Aprovação
1. Na campanha em `RASCUNHO`, clique em **Submeter**.
2. O sistema congela a versão atual (v1) contendo a ficha exata de parâmetros, o resultado financeiro apurado e a trilha de números.
3. A campanha transita para **`AGUARDANDO_APROVACAO`** e entra imediatamente na fila dos supervisores de vendas.

---

## 5. Fila e Fluxo de Aprovação (Supervisor de Vendas)

O Camplana adota o princípio de **aprovação quatro-olhos**: uma campanha só pode ser decidida por um supervisor diferente do autor que a submeteu.

### 5.1 Fila de Aprovação
Como Supervisor (Sérgio ou Sílvia), acesse o menu **Campanhas / Aprovações** (`/campanha`):
1. A aba **Fila de Aprovação** lista as versões pendentes enviadas por outros usuários.
2. Cada item indica o autor, data de submissão, custo adicional estimado e se há **conflitos de sobreposição** de período com outras campanhas.

### 5.2 Tomada de Decisão
Ao abrir uma versão para análise:
1. Revise os parâmetros congelados, as metas, as quebras de custo e o histórico de comissão.
2. Em caso de sobreposição de períodos, o sistema aponta as datas de conflito e as marcas/cargos coincidentes.
3. Decida a ação:
   - **Aprovar:** registra o status `APROVADA` e o log de decisão no sistema (justificativa opcional).
   - **Reprovar:** exige o preenchimento de uma **justificativa obrigatória** explicando o motivo do indeferimento comercial (ex.: *"Meta de vendas desproporcional ao histórico da quinzena"*). A campanha passa para `REPROVADA` e a justificativa fica registrada no histórico do autor.
   - **Re-simular:** recalcula os impactos da regra congelada considerando as campanhas mais recentes aprovadas no mesmo período.

---

## 6. Percentual Vigente por Marca e Cargo

No menu **% Vigente** (`/vigente`):
- Consulte a matriz consolidada de comissões para cada combinação de Marca e Cargo da rede.
- Visualize o percentual base importado e o percentual efetivo vigente resultante das campanhas ativas e acordos comerciais no período.

---

## 7. Importação da Base Mensal (Supervisor de Vendas)

No menu **Importar Bases** (`/importar`), o Supervisor realiza a ingestão dos dados operacionais da Dom Rock:

### 7.1 Envio de Arquivos
1. Selecione os arquivos `.xlsx` do mês:
   - Planilha de RH (`BASE RH_MMM25.xlsx`);
   - Planilha de Vendas (`BASE_VENDAS_MMM25.xlsx`);
   - Planilha de Comissão (`BASE_COMMISS_FINAL.xlsx`, quando aplicável ou enviada individualmente).
2. Clique em **Importar Base**.
3. O envio cria um job assíncrono e exibe a barra de progresso do processamento.

### 7.2 Acompanhamento e Relatório de Pendências
Ao finalizar a importação, o sistema exibe o resumo:
- Total de linhas lidas e efetivamente gravadas;
- Contagem por categoria (RH, Vendas, Comissão);
- **Relatório de Pendências:**
  - **AVISO:** alertas não impeditivos (ex.: funcionário de RH que não realizou vendas no mês, ou venda de colaborador admitido no meio do mês). Os dados válidos são gravados com sucesso.
  - **IMPEDITIVO:** inconsistências que impedem a carga (ex.: formato de arquivo inválido, ausência de colunas obrigatórias ou discrepância de competências). Quando há impeditivos, o job encerra como `PENDENTE` e nada é gravado no banco, assegurando a atomicidade.

---

## 8. Gestão de Usuários (Administrador)

No menu **Gestão de Usuários** (`/admin`), exclusivo do perfil `ADMIN` (Ana):
- **Listagem de Usuários:** consulta aos colaboradores cadastrados com nome, e-mail, perfil e status (Ativo/Inativo);
- **Cadastro de Novo Usuário:** inclusão com nome, e-mail, perfil (`GERENTE`, `SUPERVISOR`, `ADMIN`) e senha inicial;
- **Edição e Situação:** alteração do perfil de atuação e alternância do status (ativação ou inativação do usuário).
