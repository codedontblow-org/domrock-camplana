# Roteiro de Apresentação — Review da Sprint 2

Este roteiro orienta a demonstração prática da Sprint 2 para o Leo (PO) e os avaliadores da Fatec / Dom Rock. A apresentação é conduzida em um notebook **Linux Mint limpo**, utilizando o estado de dados preparado automaticamente pelo script `seed-demo.sh`.

Tempo estimado total: **10 a 15 minutos**.

---

## 0. Preparação antes da apresentação (5 minutos antes)

No terminal do notebook de demonstração:

```bash
cd domrock-camplana
# 1. Garante que a stack está rodando
docker compose up -d

# 2. Executa o seed da demo (se já importou as planilhas antes, use --so-campanhas)
./scripts/seed-demo.sh --so-campanhas

# 3. Abra o navegador em http://localhost:5173
```

Todas as senhas dos usuários de demonstração são: **`123456`**.

---

## 1. Parte 1 — Gabriela (Gerente de Vendas): Governança de Campanhas e XAI

**Objetivo:** Mostrar o ciclo de vida completo de criação, simulação e governança das campanhas do ponto de vista de quem planeja a ação comercial.

### 1.1 Login e Visão Geral
1. Acesse `http://localhost:5173/login`.
2. Entre como: **`gabriela@camplana.com.br`** / **`123456`**.
3. **Fala do Apresentador:**
   > *"Nesta Sprint 2, implementamos autenticação segura via JWT com controle de perfis. A Gabriela é Gerente de Vendas e sua missão é estruturar incentivos comerciais viáveis financeiramente."*

### 1.2 "Minhas Campanhas", Ciclo de Vida e Filtro de Arquivadas
1. Clique no menu lateral **Minhas Campanhas** (`/campanhas`).
2. **Fala do Apresentador:**
   > *"Aqui a Gabriela acompanha o portfólio completo de campanhas. Temos os estados do ciclo de vida que demonstram o fluxo de negócio:"*
   - **`RASCUNHO` ("Campanha Fim de Ano - Rascunho"):**
     > *"Esta campanha foi criada e simulada, mas ainda não foi enviada para aprovação. O autor pode renomeá-la, arquivá-la ou submetê-la."*
   - **`AGUARDANDO_APROVACAO` ("Campanha Virada de Novembro"):**
     > *"Submetida pela Gabriela. A versão v1 foi congelada com a ficha de parâmetros e o resultado exato daquele momento, e está aguardando avaliação da supervisão."*
   - **`APROVADA` ("Black Friday 2025 - Aprovada" e "Campanha de Inverno - Julho 2025"):**
     > *"Campanhas já avaliadas e aprovadas, prontas para vigência."*
   - **`REPROVADA` ("Acréscimo de Agosto - Reprovada"):**
     > *"Foi reprovada pelo supervisor Sérgio. Veja que o botão 'Editar' permite que a Gabriela devolva a campanha para Rascunho e elabore a versão v2 corrigida."*
3. **Passo: Filtro de Arquivadas (Contrato 5.4):**
   - Mostre que, por padrão (sem filtro), a listagem exibe 6 campanhas e esconde as arquivadas para não poluir a visão operacional.
   - Clique no filtro **Arquivada**: a campanha *"Incentivo Setembro - Arquivada"* é exibida (submetida, reprovada pela Sílvia com justificativa e arquivada pela Gabriela).

### 1.3 Detalhes da Campanha e Trilha de Números ("De onde vieram esses números?")
1. Clique na **"Black Friday 2025 - Aprovada"** ou na **"Campanha Virada de Novembro"**.
2. Mostre os cartões de resultado:
   - **Meta:** valor estipulado vs. vendas apuradas no histórico, percentual de atingimento e superação;
   - **Custo Adicional:** impacto financeiro líquido estimado da campanha;
   - **Gráficos e Detalhamento:** quebra do custo por Marca, por Cargo elegível e maiores Lojas impactadas.
3. Clique em **"De onde vieram esses números"** (Trilha de auditoria da Lana):
   - **Fala do Apresentador:**
     > *"Nenhum número vem direto de uma LLM. A Lana calcula o baseline diretamente sobre o banco PostgreSQL, gera o código da regra, valida em cálculo determinístico e registra cada tabela consultada e cada conferência de consistência."*

### 1.4 Histórico de Versões da Campanha
1. Volte para **Minhas Campanhas** e clique na **"Campanha Outubro - Dia das Crianças"** (em `AGUARDANDO_APROVACAO`).
2. Clique na aba **Versões**:
   - Mostre o histórico completo das duas versões:
     - **v1:** submetida inicialmente (+2,0%), reprovada pelo Sérgio com justificativa visível (*"O percentual de 2.0% excede o limite financeiro..."*);
     - A campanha retornou a Rascunho, foi re-simulada (+1,0%, marcas ajustadas) e submetida como **v2**, atualmente em avaliação.

---

## 2. Parte 2 — Sérgio e Sílvia (Supervisores de Vendas): Fila de Aprovação Quatro-Olhos e Importação

**Objetivo:** Demonstrar o controle quatro-olhos, o tratamento de conflitos de período e a ingestão de planilhas.

### 2.1 Logout e Login como Supervisor
1. No menu inferior esquerdo, faça logout da Gabriela.
2. Faça login com: **`sergio@camplana.com.br`** / **`123456`**.

### 2.2 Quatro Olhos: A Campanha do Sérgio
1. Como Sérgio, acesse **Minhas Campanhas** (`/campanhas`) e abra a sua campanha **"Incentivo Natal Antecipado - Supervisão"** (`AGUARDANDO_APROVACAO`).
2. **Fala do Apresentador:**
   > *"Demonstração dos quatro olhos: o Sérgio é supervisor, mas por ser o autor desta campanha, ele não possui o botão de Aprovar. A aprovação precisa vir de outro supervisor."*
3. Acesse o menu **Campanhas / Aprovações** (`/campanha`):
   - A fila de aprovação do Sérgio lista as campanhas dos outros usuários ('Campanha Virada de Novembro' e 'Dia das Crianças' v2), mas exclui a sua própria.

### 2.3 Quatro Olhos: A Sílvia Pode Aprovar a Campanha do Sérgio
1. Faça logout do Sérgio e entre como: **`silvia@camplana.com.br`** / **`123456`**.
2. Acesse **Campanhas / Aprovações** (`/campanha`):
   - Na fila da Sílvia, a campanha **"Incentivo Natal Antecipado - Supervisão"** aparece listada (3 campanhas na fila).
   - Ao abrir o painel de aprovação, a Sílvia tem disponíveis os botões de **Aprovar**, **Devolver** e **Simular de novo**.

### 2.4 Fila de Aprovação e Conflito de Sobreposição
1. Acesse o menu **Campanhas / Aprovações** (`/campanha`).
2. **Fala do Apresentador:**
   > *"Na fila do Sérgio, aparece a 'Campanha Virada de Novembro' submetida pela Gabriela. Note o princípio quatro-olhos: o autor não aprova a própria campanha. Além disso, o sistema sinalizou '1 Conflito'!"*
3. Abra a versão para análise:
   - Mostre que a Virada de Novembro (20 a 28/11) cruza datas com a Black Friday Aprovada (24 a 30/11);
   - O supervisor tem total clareza do impacto cruzado antes de deliberar.
4. Demonstre os botões de ação:
   - Clique em **Reprovar**: mostre que o sistema exige o preenchimento de justificativa obrigatória;
   - Mostre o botão de **Aprovar** e o botão de **Re-simular** (caso novas campanhas tenham sido aprovadas no mesmo intervalo).

### 2.5 Matriz de % Vigente
1. Acesse o menu **% Vigente** (`/vigente`).
2. **Fala do Apresentador:**
   > *"Aqui o supervisor tem a visão consolidada de todas as marcas e cargos da Dom Rock, enxergando a taxa base e o percentual efetivo vigente resultante das campanhas ativas."*

### 2.6 Importação da Base Mensal de Dados
1. Acesse o menu **Importar Bases** (`/importar`).
2. **Fala do Apresentador:**
   > *"A importação das bases mensais é responsabilidade do Supervisor. O sistema processa os arquivos de forma assíncrona, com validação atômica — se houver pendência impeditiva, nada é gravado."*
3. Mostre o **Histórico de Importações**:
   - Os meses de julho a dezembro de 2025 aparecem com status `CONCLUIDO`, totais de linhas de RH, Vendas e Comissão;
   - Abra o relatório de um mês (ex.: julho ou agosto) para mostrar os **Avisos** (ex.: colaboradores sem vendas no mês).

---

## 3. Parte 3 — Ana (Administradora): Gestão de Usuários e Segurança

**Objetivo:** Demonstrar o controle administrativo e a segregação estrita de permissões.

### 3.1 Login como Admin
1. Faça logout do Sérgio.
2. Faça login com: **`ana@camplana.com.br`** / **`123456`**.
3. Observe que a Ana é direcionada diretamente para o painel de **Gestão de Usuários** (`/admin`).

### 3.2 Painel de Usuários
1. **Fala do Apresentador:**
   > *"O Administrador possui escopo dedicado à governança de acessos, sem misturar com regras comerciais."*
2. Mostre os 4 usuários cadastrados:
   - Ana (`ADMIN`), Gabriela (`GERENTE`), Sérgio e Sílvia (`SUPERVISOR`).
3. Demonstre a interface de edição e os controles de ativação/desativação de usuários.
4. Mostre que a Ana não possui acesso a rotas de campanhas nem importação (segregação por RBAC no Spring Security).

---

## 4. Plano B: Contingência para a Demonstração (Cota de IA / 429)

Caso durante uma simulação ao vivo a API pública do provedor de IA falhe por limite de requisições ou instabilidade externa:

1. **Fallback Automático:**
   - O Camplana já possui configurada a variável `AI_FALLBACKS` no `.env`. Se o Gemini 3.5 Flash Lite retornar erro de cota (HTTP 429), a requisição é automaticamente repassada para os modelos de reserva (Gemini 3.1, Groq ou OpenRouter).
2. **Plano B Offline Instantâneo (`CODEGEN_MODO=modelo`):**
   - Caso o local da apresentação esteja sem internet ou com todas as APIs bloqueadas:
     No arquivo `.env`, altere:
     ```ini
     CODEGEN_MODO=modelo
     ```
     Nesse modo, a Lana utiliza diretamente o algoritmo determinístico compilado, respondendo a qualquer simulação em menos de 1 segundo sem nenhuma chamada externa de rede.
3. **Dados do Seed Pré-Gravados:**
   - Todo o roteiro principal pode ser apresentado usando as 4 campanhas do seed (`seed-demo.sh`), que já contêm todas as fichas, resultados e logs reais gravados no banco de dados, sem depender de nenhuma chamada ao vivo para a IA!
