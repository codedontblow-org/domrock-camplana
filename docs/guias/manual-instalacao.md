# Manual de Instalação — Camplana

Este manual descreve o passo a passo para configurar e executar a stack completa do Camplana (PostgreSQL, Spring Boot Backend, Lana AI Service e Vue.js Frontend) em ambiente local ou servidor de desenvolvimento.

---

## 1. Visão geral da arquitetura

O projeto Camplana é distribuído em três submódulos principais orquestrados via Docker Compose:

```text
domrock-camplana/
├── DomRock-Backend/     # API REST em Java 17 / Spring Boot 3 / Flyway
├── DomRock-Frontend/    # Interface Web em Vue 3 / Vite / Tailwind CSS
├── DomRock-Lana/        # Agente de IA em Python 3.12 / FastAPI / LangChain / gRPC
├── docker-compose.yml   # Orquestração dos 4 containers (postgres, backend, lana, frontend)
├── .env.example         # Template de variáveis de ambiente
├── scripts/             # Scripts utilitários de carga e demonstração
└── docs/                # Manuais, contratos e documentação técnica
```

---

## 2. Preparação do ambiente (Linux Mint / Ubuntu)

Para executar o projeto em um computador limpo com **Linux Mint (21/22)** ou **Ubuntu (22.04/24.04)**, instale os pacotes básicos:

### 2.1 Instalação do Git, Curl e utilitários
```bash
sudo apt update
sudo apt install -y git curl ca-certificates gnupg
```

### 2.2 Instalação do Docker Engine e Docker Compose Plugin
Remova versões antigas e configure o repositório oficial do Docker:

```bash
# Adiciona a chave GPG oficial do Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório oficial (no Linux Mint, utiliza a base Ubuntu correspondente)
UBUNTU_CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $UBUNTU_CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 2.3 Permissões do usuário (Grupo Docker)
Permita a execução do Docker sem `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Teste a instalação:
```bash
docker compose version
```

---

## 3. Clonando o repositório e inicializando submódulos

Clone o repositório principal e baixe o código dos submódulos na branch `develop`:

```bash
git clone https://github.com/codedontblow-org/domrock-camplana.git
cd domrock-camplana

# Inicializa e atualiza os submódulos (Backend, Frontend e Lana)
git submodule update --init --remote
```

---

## 4. Configuração de variáveis de ambiente (`.env`)

Copie o modelo de ambiente:

```bash
cp .env.example .env
```

Edite o arquivo `.env` para informar o provedor de IA e a respectiva chave de API:

```ini
## Banco de Dados
DB_USERNAME=postgres
DB_PASSWORD=postgres
LANA_DB_PASSWORD=lana_leitura

## Autenticação (JWT)
# Segredo para assinatura de tokens JWT. Pode ser mantido o padrão em desenvolvimento/demo.
JWT_SECRET=camplana-segredo-jwt-desenvolvimento-sprint-2-2026

## Provedor de IA da Lana
AI_PROVIDER=GEMINI
AI_MODEL=gemini-3.5-flash-lite
GEMINI_API_KEY=sua_chave_gemini_aqui

# Fallback automático caso a cota do Gemini termine (429)
AI_FALLBACKS=GEMINI:gemini-3.1-flash-lite,OPENROUTER:qwen/qwen3.8-27b:free,GROQ:openai/gpt-oss-120b
AI_TIMEOUT_S=30
```

### 4.1 Portas no host trocáveis
Se alguma das portas padrão já estiver em uso na máquina, altere-as diretamente no `.env`:

| Variável | Padrão | Serviço |
|---|---|---|
| `POSTGRES_HOST_PORT` | `5432` | Banco PostgreSQL |
| `BACKEND_HOST_PORT` | `8080` | API Spring Boot |
| `LANA_HOST_PORT` | `8000` | Serviço REST FastAPI da Lana |
| `LANA_GRPC_HOST_PORT` | `50051` | Servidor gRPC da Lana |
| `FRONTEND_HOST_PORT` | `5173` | Aplicação Web Vue/Vite |

---

## 5. Execução via Docker Compose

Inicie todos os serviços da aplicação:

```bash
docker compose up -d --build
```

Acompanhe os logs dos containers:

```bash
docker compose logs -f
```

Aguarde o Spring Boot aplicar as migrações Flyway (V1 a V10) e a Lana iniciar o servidor gRPC na porta 50051.

---

## 6. Carga inicial e Seed da Demonstração

Para carregar os dados e deixar o sistema pronto para apresentação em segundos, utilize o script automatizado:

```bash
./scripts/seed-demo.sh
```

O script realiza:
1. Verificação de prontidão do backend;
2. Importação de todos os meses da Dom Rock (julho a dezembro de 2025) com RH, Vendas e Comissão;
3. Carga das intercorrências de RH (`./scripts/importar-intercorrencias.sh`, ver 6.1);
4. Criação de cenários de demonstração (campanhas em `RASCUNHO`, `AGUARDANDO_APROVACAO`, `APROVADA` e `REPROVADA`, com simulações e logs reais).

> **Dica para ensaios rápidos:** Caso já tenha importado as planilhas e queira apenas restaurar o estado limpo das campanhas da demo, use:
> ```bash
> ./scripts/seed-demo.sh --so-campanhas
> ```

### 6.1 Carga das intercorrências de RH (jul a dez/2025)

O `seed-demo.sh` completo já roda este passo. Para rodá-lo sozinho, com o dataset principal já importado, execute a carga das intercorrências e gere o relatório de pendências:

```bash
./scripts/importar-intercorrencias.sh
```

Nota de idempotência: O script pode ser reexecutado de forma segura sem duplicação de dados em evento_rh. O relatório gerado fica em docs/relatorio-pendencias-intercorrencias.md.

---

## 7. Usuários e Acesso ao Sistema

Acesse a aplicação no navegador em: `http://localhost:5173`

Os usuários de demonstração (criados na migração V4 do backend) utilizam todos a mesma senha:

| Nome | E-mail | Perfil | Senha | Acesso / Funcionalidade |
|---|---|---|---|---|
| **Gabriela** | `gabriela@camplana.com.br` | `GERENTE` | `123456` | Chat, simulações, salvar e acompanhar campanhas |
| **Sérgio** | `sergio@camplana.com.br` | `SUPERVISOR` | `123456` | Fila de aprovação, aprovar/reprovar, importação de bases |
| **Sílvia** | `silvia@camplana.com.br` | `SUPERVISOR` | `123456` | Fila de aprovação, aprovar/reprovar, importação de bases |
| **Ana** | `ana@camplana.com.br` | `ADMIN` | `123456` | Gestão de usuários (criar, editar perfil, desativar) |

---

## 8. Execução sem Docker (Desenvolvimento Local Isolado)

Caso deseje executar algum componente fora de containers para depuração local:

### 8.1 Backend (Spring Boot)
Requer Java 17+ e PostgreSQL ativo:
```bash
cd DomRock-Backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### 8.2 Frontend (Vue.js)
Requer Node.js 22 ou 24:
```bash
cd DomRock-Frontend
npm install
npm run dev
```

### 8.3 Lana AI (Python)
Requer Python 3.12:
```bash
cd DomRock-Lana
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

---

## 9. Diagnóstico e Resolução de Problemas

- **Erro de conexão ao banco:** confira com `docker compose ps` se o container `postgres` está com status `healthy`.
- **Backend não responde no login:** verifique se as migrações do Flyway foram concluídas (`docker compose logs backend | grep -i flyway`).
- **Erro de cota na Lana (429):** o sistema possui cadeia automática de fallbacks (`AI_FALLBACKS` no `.env`). Como contingência imediata offline para a demo, mude `CODEGEN_MODO=modelo` no `.env` da Lana para usar o algoritmo determinístico de referência sem chamar a LLM.
- **Derrubada da stack de testes:**
  ```bash
  docker compose down -v
  ```
