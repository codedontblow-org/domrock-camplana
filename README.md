<h1 align="center"> API ADS 6º Semestre </h1>

<div align="center">
    <!--  <img src="" alt="DomRock_image" width="900"> -->
<h2 align="center"> 💣 Code Don't Blow </h2>
</div>

<div align="center">

<div align="center">

<a href="#desafio">Desafio</a> |
<a href="#mvp">Solução</a> |
<a href="#backlog">Backlog do Produto</a> |
<a href="#dor">DoR</a> |
<a href="#dod">DoD</a> |
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

</div>

> Status do Projeto: Em andamento! 🚧 

<br>

## 🏁 Desafio: <a id="desafio"></a>
O desafio propõe o desenvolvimento de um sistema para gerenciamento de regras de negócio, utilizando técnicas de Engenharia de Software Assistida por Inteligência Artificial. Empresas possuem regras de negócio que mudam constantemente devido a novos produtos, alterações de preços, campanhas de vendas e mudanças em acordos comerciais com parceiros e fornecedores. Entretanto, essas regras muitas vezes não são registradas ou organizadas adequadamente, dificultando sua utilização, manutenção e rastreabilidade. Nesse contexto, o sistema deverá permitir registrar, organizar, analisar e simular regras de negócio, reduzindo problemas como inconsistências operacionais, conflitos entre regras, dependência de conhecimento tácito e perda de rastreabilidade.      



## 🥇 Solução <a id="mvp"></a>
Camplana é uma plataforma que valida o uso de IA Generativa explicável (Lana) para transformar o cadastro, a detecção de conflitos e a simulação de regras de negócio em um processo simples, transparente e sem erros operacionais.

### Fluxo do Usuário

1. **Entrada do Cenário:** O usuário seleciona um produto/região (massa de dados pré-carregada) e digita a nova intenção de campanha
<br>exemplo: *"Comissão de 8% para a Região Sul"*.
3. **Análise da Lana:** A IA (via LangChain) consulta a base de regras e verifica se a proposta desrespeita os limites vigentes (baseline).
4. **Explicabilidade (XAI):** O sistema exibe um card explicativo: *"Aprovado. O limite para a Região Sul é de 10% e não há sobreposição de campanhas"*.
5. **Simulação:** O usuário clica em "Simular" e o sistema exibe o cálculo final do impacto financeiro estimado com base na regra aprovada.

---


## 🗒️ Backlog do Produto <a id="backlog"></a>

| Rank | Prioridade |                  User Story                    | Sprint  | Status   |
| :--: | :--------: | :--------------------------------------------: | :-----: | :------: |
| 1 | Alta | Como Gerente de Vendas, quero falar uma regra em linguagem natural para o sistema interpretar e iniciar uma simulação da regra de negócio. | 1  | 🔒  |
| 2 | Alta |  Como Gerente de Vendas, quero rodar a simulação da regra com diferentes cenários de meta para ver o impacto financeiro projetado antes de enviar para aprovação. |  1  |   🔒  |
| 3 | Alta | Como Supervisor de Vendas quero avaliar, aprovar ou reprovar regras de negócios criadas por outros usuários, para garantir que estejam alinhadas ao orçamento e aos objetivos da campanha antes serem executadas. | 2  |  🔒  |
| 4 | Alta | Como Supervisor de Vendas, quero ver o status da minha regra, para acompanhar em que etapa ela está. |  2   |    🔒  |
| 5 | Alta | Como Supervisor de Vendas, quero propor alterações nos dados da base de vendas, para corrigir alterações em campanhas sem comprometer a integridade das informações. |  2   | 🔒  |
| 6 | Alta  | Como Supervisor de Vendas, quero poder visualizar os logs de edições e aprovações, para acompanhar o histórico de mudanças e garantir rastreabilidade | 3 | 🔒 |
| 7 | Alta  |  Como Supervisor de Vendas, quero visualizar a trilha de decisão de uma regra para entender como o sistema chegou naquele resultado. |  3  |  🔒  |
| 8 | Média |  Como Supervisor de Vendas, quero gerar um relatório final referente à campanha para visualizar o real impacto financeiro| 3 |  🔒  |
| 9 | Média | Como Supervisor de Vendas, quero visualizar gráficos e insights ao final da campanha para entender os resultados e realizar comparações |  3  |  🔒  |
| 10 | Baixa | Como Supervisor de Vendas, quero visualizar as campanhas já realizadas, em andamento e previstas, para gerenciamento.  |   3    |  🔒   |

<!--Status: ✅ ❌ 🔒 --->


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

---

## 📅 Cronograma de Sprints <a id="sprint"></a>

| Sprint            | Período         | Status       |
| ----------------- | --------------- | ------------ |
| Kick Off          |  24/08 a 28/08  | Finalizado   |
| 01                | 07/09 a 27/09   | Finalizado   |
| 02                | 05/10 a 25/10   | A fazer      |
| 03                | 02/11 a 22/11   | A fazer      |
| Feira de Soluções |  03/12          | A fazer      |

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
|----------|---|---|
| Sprint 1 | 🚧 | 🚧 |
| Sprint 2 | 🚧 | 🚧 |
| Sprint 3 | 🚧 | 🚧 |



## 🛠️ Tecnologias
<a id="tecnologias"></a>
<div align="center">

![Vue.js](https://img.shields.io/badge/vue.js-0b192c.svg?style=for-the-badge&logo=vuedotjs&logoColor=white)
![Spring Boot](https://img.shields.io/badge/spring_boot-0b192c.svg?style=for-the-badge&logo=springboot&logoColor=white)
![Java](https://img.shields.io/badge/java-0b192c.svg?style=for-the-badge&logo=openjdk&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-3368A0?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/python-0b192c.svg?style=for-the-badge&logo=python&logoColor=white)
![LangGraph](https://img.shields.io/badge/langgraph-1C3C3C?style=for-the-badge&logo=langgraph&logoColor=white)
![OpenRouter](https://img.shields.io/badge/OpenRouter-67C090?style=for-the-badge&logo=openrouter&logoColor=white)
![Gemini](https://img.shields.io/badge/Gemini-67C090?style=for-the-badge&logo=googlegemini&logoColor=white)
![Jira](https://img.shields.io/badge/jira-0b192c.svg?style=for-the-badge&logo=jira&logoColor=white)
![Figma](https://img.shields.io/badge/figma-0b192c.svg?style=for-the-badge&logo=figma&logoColor=white)

</div>

---

## 📂 Estrutura do Projeto <a id="estrutura"></a>

```text
domrock-camplana/
├── docs/
│   ├── DoR.md
│   ├── DoD.md
│   ├── estrategia-branch.md
│   ├── manual-usuario.md
│   └── manual-instalacao.md
│
├── domrock-backend/
│   ├── camplana.API/
│
├── domrock-frontend/
│   └── camplana-web/
│
├── domrock-ai/
│   └── camplana/
|
├── domrock-iac/
│   └── camplana/
|
├── .gitignore
├── README.md
└── LICENSE
```

A separação entre backend, frontend, ai, iac e docs facilita a localização...

### 🏗️ Arquitetura

O back-end utiliza uma arquitetura em camadas, separando responsabilidades entre API, aplicação, domínio e infraestrutura.

A documentação detalhada da arquitetura está disponível em:
[Documentação de Arquitetura](docs/arquitetura.md).


# ⚙️ Como Executar? <a id="como-executar"></a>

### Pré-requisitos

Antes de executar o projeto, instale:
- Git;
- Node.js e npm;
- PostgreSQL;
- Python;
- Java.

### Clonar o repositório

```bash
git clone https://github.com/codedontblow-org/domrock-camplana
cd domrock-camplana
```

### Executar o back-end
```bash
```

### Executar o front-end

Em outro terminal:

```bash
```

Depois, acesse:

```text
```

---

# 📖 Guia de Documentações <a id="manual"></a>
Toda a documentação complementar do projeto permanece versionada no diretório `docs/`.

- [Checklist de Definition of Ready (DoR)](docs/DoR.md)
- [Checklist de Definition of Done (DoD)](docs/DoD.md)
- [DoR e DoD por Sprint](docs/sprints/)
- [Estratégia de Branch](docs/estrategia-branch.md)
- [Padrões de Commit](docs/padrao-commit.md)
- [Manual do Usuário](docs/manual-usuario.md)
- [Manual de Instalação](docs/manual-instalacao.md)


------

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


##  👥 Cliente: <a id="cliente"></a>

<div align="center">

|     Cliente     |               Empresa             |
| :-------------: | :-------------------------------: |
| André de Almeida | <a href='https://www.domrock.net/'> Dom Rock </a> |

</div>

# 🥅 Docentes: <a id="docentes"></a>

<div align="center">

|                          P²                            |                       M²           |
| :----------------------------------------------------: | :--------------------------------: |
| <a href='http://lattes.cnpq.br/9441903297380731'> José Walmir Gonçalves Duque </a> | <a href='http://lattes.cnpq.br/3238411230371891'>Cláudio Etelvino de Lima </a> |

</div>
