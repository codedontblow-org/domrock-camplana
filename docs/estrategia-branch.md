# Estratégia de Branch

O projeto utiliza branches para organizar o desenvolvimento e evitar alterações diretamente na branch principal.

## Branches principais

### `main`

Contém a versão estável do projeto.

Alterações diretamente nessa branch não são permitidas. As mudanças devem ser realizadas por meio de Pull Requests.

### `develop`

Utilizada para integração das funcionalidades que estão em desenvolvimento.

### Branches de funcionalidade

Para desenvolver uma nova funcionalidade, deve ser criada uma branch a partir de `develop`.

Formato:

```
feat/<descricao-da-funcionalidade>
```

Exemplo:

```
feat/tela-login
```

### Branches de correção

Para correções de bugs:

```
fix/<descricao-do-bug>
```

Exemplo:

```
fix/erro-validacao-login
```

## Fluxo

```
develop
   │
   ├── feature/tela-login
   │
   └── feature/cadastro-usuario
           │
           ▼
        Pull Request
           │
           ▼
        develop
           │
           ▼
          main
```

## Regras

- Não realizar commits diretamente em `main`.
- Utilizar Pull Requests para integração.
- Manter o nome das branches descritivo.
- Remover branches após a conclusão da tarefa, quando não forem mais necessárias.
