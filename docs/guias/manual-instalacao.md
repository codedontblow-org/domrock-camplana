# Manual de Instalação — Camplana

## 1\. Visão geral

O Camplana é organizado em diferentes componentes:

```
domrock-camplana/
├── domrock-backend/
├── domrock-frontend/
├── domrock-ai/
├── domrock-iac/
└── docs/
```

Cada componente possui uma responsabilidade específica na aplicação.

## 2\. Pré-requisitos

Antes de executar o projeto, é necessário possuir:

- Git;
- Java;
- Node.js;
- npm;
- Python;
- PostgreSQL;
- Docker, quando necessário para execução dos serviços.

## 3\. Clonando o projeto

Clone o repositório:

```
git clone https://github.com/codedontblow-org/domrock-camplana
```

Acesse o projeto:

```
cd domrock-camplana
```

## 4\. Configuração do banco de dados

O Camplana utiliza PostgreSQL.

Crie um banco de dados para o ambiente de desenvolvimento e configure as credenciais utilizadas pela aplicação.

As configurações devem ser mantidas em variáveis de ambiente e não devem ser versionadas no repositório.

Exemplo:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=camplana
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
```

> Os nomes exatos das variáveis devem seguir a configuração implementada no backend.

## 5\. Configuração do backend

Acesse o diretório:

```
cd domrock-backend
```

O backend utiliza Java e Spring Boot.

O comando de execução deve seguir o sistema de build configurado no projeto.

### Maven

Caso o projeto utilize Maven:

```
./mvnw spring-boot:run
```

No Windows:

```
mvnw.cmd spring-boot:run
```

## 6\. Configuração do frontend

Acesse o diretório do frontend:

```
cd domrock-frontend/camplana-web
```

Instale as dependências:

```
npm install
```

Execute o projeto:

```
npm run dev
```

O endereço exibido pelo terminal deverá ser utilizado para acessar a aplicação.

## 7\. Configuração do módulo de IA

Acesse:

```
cd domrock-ai/camplana
```

Crie e ative o ambiente virtual Python:

```
python -m venv .venv
```

### Windows

```
.venv\Scripts\activate
```

### Linux/macOS

```
source .venv/bin/activate
```

Instale as dependências:

```
pip install -r requirements.txt
```

Configure as variáveis necessárias para os serviços de IA utilizados pelo projeto.

Exemplo:

```
OPENROUTER_API_KEY=sua_chave
```

> As variáveis exatas devem seguir a configuração implementada no módulo de IA.

## 8\. Infraestrutura

O diretório:

```
domrock-iac/
└── camplana/
```

contém os arquivos relacionados à infraestrutura do projeto.

Caso sejam utilizados containers Docker, consulte os arquivos de configuração presentes nesse diretório antes de iniciar os serviços manualmente.

## 9\. Ordem recomendada de execução

Em um ambiente local, a ordem recomendada é:

```
1. PostgreSQL
       ↓
2. Backend
       ↓
3. Serviço de IA
       ↓
4. Frontend
```

## 10\. Verificação

Após iniciar os componentes, verifique:

- Backend disponível;
- Banco de dados conectado;
- Serviço de IA disponível;
- Frontend carregando;
- Comunicação entre frontend e backend;
- Comunicação entre backend e módulo de IA.

## 11\. Problemas comuns

### Banco de dados não conecta

Verifique:

- Host;
- Porta;
- Nome do banco;
- Usuário;
- Senha;
- Status do PostgreSQL.

### Dependências do frontend não encontradas

Execute:

```
npm install
```

### Ambiente Python não encontrado

Crie novamente o ambiente virtual:

```
python -m venv .venv
```

### Variável de ambiente ausente

Verifique se o arquivo de configuração foi criado e se todas as variáveis obrigatórias foram preenchidas.

## 12\. Segurança

Não versionar:

- Senhas;
- Chaves de API;
- Tokens;
- Credenciais de banco;
- Arquivos `.env` contendo informações sensíveis.

Utilize arquivos de exemplo, como:

```
.env.example
```

para documentar as variáveis necessárias sem expor credenciais reais.

## Uma alteração que eu faria no seu README

Com esses arquivos, a estrutura ficaria melhor assim:

```
docs/
├── backlogs/
│   ├── DoR.md
│   └── DoD.md
│
├── guias/
│   ├── manual-usuario.md
│   └── manual-instalacao.md
│
├── arquitetura.md
├── estrategia-branch.md
└── padrao-commit.md
```

E o trecho do README:

```
# 📖 Guia de Documentações <a id="manual"></a>

Toda a documentação complementar do projeto permanece versionada no diretório `docs/`.

- [Checklist de Definition of Ready (DoR)](docs/backlogs/DoR.md)
- [Checklist de Definition of Done (DoD)](docs/backlogs/DoD.md)
- [Estratégia de Branch](docs/estrategia-branch.md)
- [Padrões de Commit](docs/padrao-commit.md)
- [Manual do Usuário](docs/guias/manual-usuario.md)
- [Manual de Instalação](docs/guias/manual-instalacao.md)
- [Arquitetura](docs/arquitetura.md)
```

**Um detalhe importante:** no manual de instalação eu deixei alguns comandos condicionais porque, pelo README que você enviou, ainda não dá para saber se o backend usa Maven ou Gradle, qual é a porta do Spring Boot, qual é a porta do frontend, como o serviço Python é iniciado e quais variáveis de ambiente o código realmente exige. É melhor confirmar isso no código do projeto do que colocar comandos que podem estar errados.
