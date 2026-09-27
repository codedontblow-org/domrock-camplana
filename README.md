<h1 align="center"> API ADS 6º Semestre </h1>

<div align="center">
    <!--  <img src="" alt="DomRock_image" width="900"> -->
<h2 align="center"> 💣 Code Don't Blow </h2>
</div>

<div align="center">

<a href="#desafio">Desafio</a> |
<a href="#mvp">Solução</a> |
<a href="#backlog">Backlog do Produto</a> |
<!-- <a href="#dor">DoR</a> |
<a href="#dod">DoD</a> | -->
<a href="#sprint">Cronograma de Sprints</a> |
<a href="#roadmap">Roadmap de Entregas</a> |
<a href="#prototipo">Protótipo</a> |
<a href="#demo">Demonstração</a> |
<a href="#tecnologias">Tecnologias</a> |
<a href="#estrutura">Estrutura do Projeto</a> |
<a href="#como-executar">Como Executar?</a> |
<a href="#manual">Documentações</a> |
<a href="#team">Equipe</a>

</div>

---

> Status do Projeto: Em andamento! 🚧

---

## 🏁 Desafio: <a id="desafio"></a>

O desafio propõe o desenvolvimento de um sistema para gerenciamento de regras de negócio, utilizando técnicas de Engenharia de Software Assistida por Inteligência Artificial.
<br>
Empresas possuem regras de negócio que mudam constantemente devido a novos produtos, alterações de preços, campanhas de vendas e mudanças em acordos comerciais com parceiros e fornecedores. Entretanto, essas regras muitas vezes não são registradas ou organizadas adequadamente, dificultando sua utilização, manutenção e rastreabilidade.
<br>
Nesse contexto, o sistema deverá permitir registrar, organizar, analisar e simular regras de negócio, reduzindo problemas como inconsistências operacionais, conflitos entre regras, dependência de conhecimento tácito e perda de rastreabilidade.

## 🥇 Solução <a id="mvp"></a>

Camplana é uma plataforma que usa IA Generativa explicável (a **Lana**) para planejar campanhas de comissionamento: o gerente descreve a regra em linguagem natural, revisa os parâmetros que a Lana extraiu e simula o impacto financeiro sobre os dados reais de vendas e RH da Dom Rock antes de levar a campanha adiante.

**Nenhum número vem direto da LLM.** A Lana gera o código Python da regra, que roda isolado sobre os dados e é conferido contra um cálculo determinístico; a comissão sem a campanha (baseline) também é calculada por código.

### Fluxo do Usuário

1. **Regra em linguagem natural:** no chat, o gerente descreve a campanha.
   <br>exemplo: _"Todas as vendas de 24/11/2025 a 30/11/2025 terão +1% de comissão (Black Friday), para todas as marcas e cargos, exceto gerentes (cargo 150)."_
2. **Parâmetros revisáveis:** a Lana preenche o painel **Campanha** (período, acréscimo, marcas, cargos, meta e orçamento) e pede o que faltar, sem assumir valores. O gerente pode corrigir qualquer campo.
3. **Simulação:** ao clicar em **Simular campanha**, a Lana gera o código da regra, executa sobre as vendas do período e confere o resultado.
4. **Resultado explicável:** custo extra da campanha, se cabe no orçamento, pessoas impactadas, onde o custo pesa (marca, cargo, loja), cenários alternativos já simulados (ex.: o maior acréscimo que cabe no orçamento) e o código Python usado no cálculo.

A simulação é um _backtest_: aplica a regra sobre vendas que já aconteceram (jul a dez/2025) e compara com a comissão sem a campanha.

---

## 🗒️ Backlog do Produto <a id="backlog"></a>

| ID | Prioridade | User Story | Estimativa | Sprint | Status |
| :-: | :-: | :-- | :-: | :-: | :-: |
| 1 | Alta | Como Gerente de Vendas, quero conversar com o agente por uma interface de chat, para descrever a regra em linguagem natural e receber as respostas dele. | 5 | 1 | ✅ |
| 2 | Alta | Como Gerente de Vendas, quero que o agente interprete meu comando e me mostre os parâmetros extraídos (produto, meta, % de comissão, vigência, público-alvo), para eu confirmar que ele entendeu corretamente. | 13 | 1 | ✅ |
| 3 | Alta | Como Gerente de Vendas, quero revisar e editar os parâmetros interpretados antes de simular, para corrigir erros de interpretação. | 8 | 1 | ✅ |
| 4 | Alta | Como Gerente de Vendas, quero que o agente gere o artefato executável da simulação a partir dos parâmetros confirmados, para que a regra possa ser calculada sobre dados reais. | 13 | 1 | ✅ |
| 5 | Alta | Como Gerente de Vendas, quero executar a simulação de um cenário de atingimento de meta, para ver o valor total de comissionamento resultante. | 8 | 1 | ✅ |
| 6 | Alta | Como Supervisor de Vendas quero avaliar e aprovar ou reprovar com justificativa as regras de negócio criadas por outros usuários, para garantir que estejam alinhadas ao orçamento e aos objetivos da campanha antes serem executadas. | 8 | 2 |  |
| 7 | Alta | Como Administrador do Sistema, quero poder criar, editar e excluir usuários para gerenciar quem usa o sistema. | 3 | 2 |  |
| 8 | Alta | Como Gerente de Vendas, quero que o sistema disponha da base de vendas, metas e vendedores do período, para que a simulação tenha dados sobre os quais calcular. | 8 | 2 |  |
| 9 | Alta | Como Supervisor de Vendas, quero propor correções pontuais na base cadastral e submetê-las ao mesmo fluxo de aprovação, para manter a base íntegra caso haja necessidade. | 8 | 2 |  |
| 10 | Média | Como Usuário Autenticado, quero ver o status da minha regra (rascunho, em simulação, aguardando aprovação, aprovada, arquivada), para acompanhar em que etapa ela está. | 5 | 2 |  |
| 11 | Média | Como Supervisor de Vendas, quero ser notificado quando uma regra ou uma correção na base cadastral for submetida para aprovação, para avaliá-la sem depender de checar o sistema manualmente e não atrasar o início da campanha. | 8 | 2 |  |
| 12 | Alta | Como Supervisor de Vendas, quero um relatório com gráficos do resultado da apuração do comissionamento ao final da campanha, para visualizar o impacto financeiro real e comparar com o simulado. | 13 | 3 |  |
| 13 | Alta | Como Supervisor de Vendas, quero que o sistema sinalize automaticamente valores de comissionamento com desvio relevante em relação à média histórica (ex: vendas muito acima do esperado), para que eu possa analisar possíveis inconsistências. | 13 | 3 |  |
| 14 | Alta | Como Supervisor de Vendas, quero poder visualizar os logs de edições e aprovações, para acompanhar o histórico de mudanças e garantir rastreabilidade | 8 | 3 |  |
| 15 | Alta | Como Supervisor de Vendas, quero visualizar o passo a passo de como o sistema interpretou o comando e chegou ao resultado da simulação de uma regra, para entender e confiar na decisão (explicabilidade/XAI). | 13 | 3 |  |
| 16 | Média | Como Supervisor de Vendas, quero visualizar as campanhas já realizadas, em andamento e previstas, para gerenciamento. | 5 | 3 |  |
| 17 | Média | Como Gerente e/ou Supervisor, quero visualizar meu perfil e editar meus dados pessoais para manter minhas informações atualizadas. | 3 | 3 |  |
| 18 | Baixa | Como Supervisor de Vendas, quero insights automáticos sobre o resultado da campanha, para identificar rapidamente o que mais influenciou o custo. | 3 | 3 |  |

<!--Status: ✅ ❌ --->

**Perfis:** o **Gerente de Vendas** cria regras e solicita mudanças; o **Supervisor de Vendas** cria e aprova regras e mudanças; o **Administrador** apenas gerencia usuários, sem acesso a simulações, edições ou aprovações.

<!--
## :bomb: DoR - Definition of Ready <a id="dor"></a>

Uma história está pronta para entrar em desenvolvimento quando:

- [ ] A história possui identificador único.
- [ ] O objetivo está claramente descrito.
- [ ] Os critérios de aceitação estão definidos.
- [ ] A regra de negócio está compreendida.
- [ ] As dependências foram identificadas.
- [ ] As dúvidas relevantes foram esclarecidas.
- [ ] O Product Owner validou o escopo.
- [ ] A equipe possui informações suficientes para iniciar o desenvolvimento.

## :boom: DoD - Definition of Done <a id="dod"></a>

Uma história é considerada concluída quando:

- [ ] Implementação realizada.
- [ ] Critérios de aceitação atendidos.
- [ ] Testes executados com sucesso.
- [ ] Código revisado.
- [ ] Pull Request aberto.
- [ ] Code Review realizado.
- [ ] Ajustes solicitados no review concluídos.
- [ ] Documentação atualizada quando necessário.
- [ ] Pull Request aprovado.
- [ ] Código integrado à branch principal.
-->

---

## 📅 Cronograma de Sprints <a id="sprint"></a>

| Sprint            | Período       | Status     |
| ----------------- | ------------- | ---------- |
| Kick Off          | 24/08 a 28/08 | Finalizado |
| 01                | 07/09 a 27/09 | Finalizado |
| 02                | 05/10 a 25/10 | A fazer    |
| 03                | 02/11 a 22/11 | A fazer    |
| Feira de Soluções | 03/12         | A fazer    |

---

<!--Status: Finalizado, A Fazer ou Em andamento --->

## 🛣️ Roadmap de Entregas <a id="roadmap"></a>

O cronograma abaixo apresenta visualmente a evolução planejada das principais entregas.

---

## 📋 Protótipo da Aplicação <a id="prototipo"></a>

<div align="center"> 
<table>
  <tr>
<th> <img src = ""> </th>
<th> <img src = ""> </th>
<th> <img src = ""> </th>
<th> <img src = ""> </th>
</tr> <tr>
<td> <img src = ""></td>
<td> <img src =""> </td>
<td> <img src = ""> </td>
<td> <img src = ""> </td>
  </tr>
</table> 
</div>

## 🎥 Demonstração

<a id="demo"></a>

| Sprint   | Entregas | Vídeo do incremento |
| -------- | -------- | ------------------- |
| Sprint 1 | 🚧       | 🚧                  |
| Sprint 2 | 🚧       | 🚧                  |
| Sprint 3 | 🚧       | 🚧                  |

## 🛠️ Tecnologias

<a id="tecnologias"></a>

<div align="center">

![Vue.js](https://img.shields.io/badge/vue.js-00b4f1.svg?style=for-the-badge&logo=vuedotjs&logoColor=white)
![Spring Boot](https://img.shields.io/badge/spring_boot-00b4f1.svg?style=for-the-badge&logo=springboot&logoColor=white)
![Java](https://img.shields.io/badge/java-00b4f1.svg?style=for-the-badge&logo=openjdk&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-00b4f1?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-00b4f1?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/python-00b4f1.svg?style=for-the-badge&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/fastapi-00b4f1.svg?style=for-the-badge&logo=fastapi&logoColor=white)
![LangGraph](https://img.shields.io/badge/langgraph-00b4f1?style=for-the-badge&logo=langgraph&logoColor=white)
![OpenRouter](https://img.shields.io/badge/OpenRouter-00b4f1?style=for-the-badge&logo=openrouter&logoColor=white)
![Gemini](https://img.shields.io/badge/Gemini-00b4f1?style=for-the-badge&logo=googlegemini&logoColor=white)
![Jira](https://img.shields.io/badge/jira-00b4f1.svg?style=for-the-badge&logo=jira&logoColor=white)
![Figma](https://img.shields.io/badge/figma-00b4f1.svg?style=for-the-badge&logo=figma&logoColor=white)

</div>

---

## 📂 Estrutura do Projeto <a id="estrutura"></a>

Este repositório reúne os três serviços como **submódulos Git**, apontando para a branch de integração da Sprint 1 (`feature/implementacao-do-fluxo-completo`, definida no `.gitmodules`).

```text
domrock-camplana/
├── DomRock-Frontend/      # submódulo: chat, painel da campanha e resultado (Vue 3 + Vite + Pinia)
├── DomRock-Backend/       # submódulo: API, importação das bases, usuários (Spring Boot 4 + PostgreSQL)
│   └── docs/domrock-dataset/   # planilhas da Dom Rock (RH, vendas e % de comissão, jul-dez/2025)
├── DomRock-Lana/          # submódulo: agente, geração/execução do código e simulação (FastAPI + LangGraph)
├── docs/                  # arquitetura, DoR/DoD, estratégia de branch, padrão de commit e manuais
├── scripts/
│   └── importar-dataset.sh     # carrega as bases no banco pelo backend
├── docker-compose.yml     # sobe PostgreSQL, backend, Lana e frontend
├── .env.example           # variáveis (chaves de IA, portas)
├── README.md
└── LICENSE
```

### 🏗️ Arquitetura

```text
Navegador ──> Frontend (Vite, proxy /backend) ──> Backend Spring (/api/chat, /api/simulacoes)
                                                       │
                                                       ▼
                                   Lana FastAPI (/agent/invoke, /simulacao) ──> PostgreSQL
                                                       │                       (papel somente leitura)
                                                       ▼
                                   Código Python da regra em subprocesso isolado
```

O backend é a porta de entrada: repassa o chat e a simulação para a Lana por HTTP. A Lana consulta o banco com um papel somente leitura (`lana_leitura`), com guarda de SQL e limite de linhas. A documentação detalhada está em [Documentação de Arquitetura](docs/arquitetura.md).

# ⚙️ Como Executar? <a id="como-executar"></a>

### Pré-requisitos

- Git;
- Docker com Compose v2;
- Uma chave de API do Gemini (ou do OpenRouter) para a Lana.

Não é preciso instalar Java, Node ou Python: tudo roda em containers.

### 1. Clonar com os submódulos

```bash
git clone --recurse-submodules https://github.com/codedontblow-org/domrock-camplana
cd domrock-camplana
git submodule update --init --remote   # garante a branch feature/implementacao-do-fluxo-completo
```

Para atualizar depois (novos commits na branch): `git submodule update --remote`.

### 2. Configurar as variáveis

```bash
cp .env.example .env
```

| Variável | Exemplo | Para quê |
| --- | --- | --- |
| `AI_PROVIDER` | `GEMINI` | `GEMINI` ou `OPENROUTER` |
| `AI_MODEL` | `gemini-3.5-flash-lite` | Modelo usado pela Lana |
| `GEMINI_API_KEY` | `...` | Chave do provedor escolhido |
| `OPENROUTER_API_KEY` / `GROQ_API_KEY` | `...` | Chaves dos provedores de reserva (opcionais) |
| `AI_FALLBACKS` | `GEMINI:gemini-3.1-flash-lite,GROQ:openai/gpt-oss-120b` | Reserva em ordem se o principal falhar (cota 429, fora do ar). Provedor sem chave é ignorado |
| `AI_TIMEOUT_S` | `30` | Segundos por modelo antes de passar ao próximo |
| `DB_USERNAME` / `DB_PASSWORD` | `postgres` / `postgres` | Banco local |
| `LANA_DB_PASSWORD` | `lana_leitura` | Senha do papel somente leitura da Lana (criado pelo Flyway) |

### 3. Subir tudo

```bash
docker compose up -d --build
```

### 4. Carregar as bases (só na primeira vez)

```bash
./scripts/importar-dataset.sh
```

Pode rodar logo depois do `docker compose up`: o script espera o backend terminar de subir e então envia RH, vendas e % de comissão de jul a dez/2025 para `POST /api/importacao` (leva cerca de 2 minutos). Os dados ficam no volume do Postgres, então não é preciso importar de novo ao reiniciar os containers. Se trocou a porta do backend, passe o endereço: `./scripts/importar-dataset.sh http://localhost:8081`. No Windows, rode pelo Git Bash ou WSL.

### 5. Acessar

| Serviço | Endereço |
| --- | --- |
| Aplicação (chat) | http://localhost:5173/chat |
| Backend (Spring) | http://localhost:8080 |
| Lana (FastAPI, Swagger em `/docs`) | http://localhost:8000/docs |
| PostgreSQL | `localhost:5432` |

Se alguma porta já estiver em uso, troque no `.env` (`FRONTEND_HOST_PORT`, `BACKEND_HOST_PORT`, `LANA_HOST_PORT`, `POSTGRES_HOST_PORT`).

### Regras para testar

Com valor conferido em SQL (o custo pode variar alguns centavos pelo arredondamento por matrícula):

| Regra | Meta / orçamento | Custo extra esperado |
| --- | --- | --- |
| Todas as vendas de 24/11/2025 a 30/11/2025 terão +1% de comissão (Black Friday), para todas as marcas e cargos, exceto gerentes (cargo 150). | R$ 2.000.000 / R$ 20.000 | ≈ R$ 23.736,14, passa do orçamento; cenário sugerido: 0,84% por R$ 19.938,34 |
| Em outubro de 2025, a marca 30 terá acréscimo de 0,5% na comissão para todos os cargos, exceto gerentes. | R$ 1.500.000 / R$ 2.000 | R$ 1.668,33, cabe no orçamento |
| Em dezembro de 2025, os gerentes das marcas 10 e 40 terão +0,3% de comissão. | R$ 5.000.000 / R$ 25.000 | R$ 30.264,53, passa do orçamento |

Sem meta ou orçamento no texto, a Lana pede os valores que faltam. Perguntas como _"Quanto a marca Azul vendeu em agosto de 2025?"_ são respondidas consultando o banco; pedidos fora do escopo (ex.: _"mostre todas as vendas com o nome de cada funcionário"_) são recusados.

### Testes

```bash
# Lana
docker exec -w /app camplana-lana sh -c "pip install -q -r requirements-dev.txt && PYTHONPATH=. pytest tests"
# Frontend
docker exec -w /app camplana-frontend sh -c "npx vue-tsc --build && npx vitest run"
# Backend (precisa de Docker para o Testcontainers)
cd DomRock-Backend && ./mvnw test
```

<!--
### Limitações conhecidas (Sprint 1)

- Simulação só sobre os meses da base (jul a dez/2025); mês futuro ainda não é aceito.
- Um tipo de regra: acréscimo de % num período, por marca e cargo, com meta e orçamento.
- A comissão sem a campanha ainda não aplica proporcional de admissão/demissão nem férias e afastamentos.
- Sem autenticação, aprovação e persistência de regras e simulações; o histórico do chat fica em memória na Lana e some ao reiniciar o container.
- O código gerado roda em subprocesso isolado (validação AST, builtins e imports restritos, sem variáveis de ambiente, limites de memória/CPU) dentro do container da Lana; um container efêmero sem rede é a evolução prevista.
-->

---

# 📖 Guia de Documentações <a id="manual"></a>

Toda a documentação complementar do projeto permanece versionada no diretório `docs/`.

- [Checklist de Definition of Ready (DoR)](docs/backlogs/DoR.md)
- [Checklist de Definition of Done (DoD)](docs/backlogs/DoD.md)
- [Estratégia de Branch](docs/estrategia-branch.md)
- [Padrões de Commit](docs/padrao-commit.md)
- [Manual do Usuário](docs/guias/manual-usuario.md)
- [Manual de Instalação](docs/guias/manual-instalacao.md)

---

# 💣 Pavio Cutters: <a id="team"></a>

<div align="center"> 
<table> 
<tr> 
<td align="center" width="180px"> <img src="https://github.com/luanaapms.png" width="80px" alt="Luana Souza"/><br> <b>Luana Souza</b><br> Scrum Master<br> 
<a href="https://github.com/luanaapms"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

<td align="center" width="180px"> <img src="https://github.com/Doryumi.png" width="80px" alt="Vanessa da Costa"/><br> <b>Vanessa da Costa</b><br> Product Owner<br> <a href="https://github.com/Doryumi"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

<td align="center" width="180px"> <img src="https://github.com/henrySilverIX.png" width="80px" alt="Henrique Tadeu"/><br> <b>Henrique Tadeu</b><br> Dev Team<br> <a href="https://github.com/henrySilverIX"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

<td align="center" width="180px"> <img src="https://github.com/Leonardo-dSouza.png" width="80px" alt="Leonardo Cristiano"/><br> <b>Leonardo Cristiano</b><br> Dev Team<br> <a href="https://github.com/Leonardo-dSouza"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

</tr> 
<tr> 
<td align="center" width="180px"> <img src="https://github.com/EstupendoG.png" width="80px" alt="Rafael Gonçalves"/><br> <b>Rafael Gonçalves</b><br> Dev Team<br> 
<a href="https://github.com/EstupendoG"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

<td align="center" width="180px"> <img src="https://github.com/raphaelamonteiro.png" width="80px" alt="Raphaela Monteiro"/><br> <b>Raphaela Monteiro</b><br> Dev Team<br> 
<a href="https://github.com/raphaelamonteiro"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

<td align="center" width="180px"> <img src="https://github.com/ramonads42.png" width="80px" alt="Ramon Amorim da Silva"/><br> <b>Ramon Amorim</b><br> Dev Team<br> <a href="https://github.com/ramonads42"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td>

<td align="center" width="180px"> <img src="https://github.com/victorrgodoy.png" width="80px" alt="Victor Godoy"/><br> <b>Victor Godoy</b><br> Dev Team<br> <a href="https://github.com/victorrgodoy"> <img src="https://img.shields.io/badge/GitHub-0b192c?style=flat&logo=github&logoColor=white" alt="GitHub"/> </a> </td> 
</tr> 
</table> 
</div>

## 👥 Cliente: <a id="cliente"></a>

<div align="center">

|     Cliente      |                      Empresa                      |
| :--------------: | :-----------------------------------------------: |
| André de Almeida | <a href='https://www.domrock.net/'> Dom Rock </a> |

</div>

# 🥅 Docentes: <a id="docentes"></a>

<div align="center">

|                                         P²                                         |                                       M²                                       |
| :--------------------------------------------------------------------------------: | :----------------------------------------------------------------------------: |
| <a href='http://lattes.cnpq.br/9441903297380731'> José Walmir Gonçalves Duque </a> | <a href='http://lattes.cnpq.br/3238411230371891'>Cláudio Etelvino de Lima </a> |

</div>
