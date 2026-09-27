# Manual do Usuário - Camplana

## 1\. Sobre o Camplana

O Camplana é uma plataforma para gerenciamento, análise e simulação de regras de negócio.

A plataforma utiliza Inteligência Artificial para auxiliar na interpretação de regras descritas em linguagem natural, identificar possíveis conflitos e apresentar uma explicação para o resultado da análise.

## 2\. Fluxo principal

O fluxo principal da aplicação é composto por:

1. Entrada do cenário.
2. Interpretação da regra.
3. Análise das regras existentes.
4. Explicação do resultado.
5. Simulação.
6. Aprovação, quando aplicável.
7. Acompanhamento e rastreabilidade.

## 3\. Criando uma nova regra

Na tela inicial, o usuário deve informar a intenção da nova regra utilizando linguagem natural.

### Exemplo

```
Comissão de 8% para a Região Sul.
```

O sistema utiliza essa informação para identificar os elementos relevantes da regra.

## 4\. Análise da regra

Após o envio da regra, o sistema realiza a análise considerando as regras existentes na base.

A análise pode verificar informações como:

- Região;
- Produto;
- Percentual de comissão;
- Campanha;
- Meta;
- Limites definidos;
- Possíveis sobreposições;
- Conflitos com regras existentes.

## 5\. Resultado explicável

Após a análise, o sistema apresenta o resultado acompanhado de uma explicação.

### Exemplo

```
Aprovado.

O limite para a Região Sul é de 10% e não foi
identificada sobreposição com campanhas existentes.
```

A explicação tem como objetivo permitir que o usuário compreenda os fatores considerados pelo sistema.

## 6\. Simulação

Quando a regra estiver apta para simulação, o usuário poderá executar uma simulação.

A simulação apresenta uma estimativa do impacto financeiro da regra considerando o cenário selecionado.

O usuário poderá utilizar diferentes cenários para comparar os possíveis resultados antes do envio para aprovação.

## 7\. Aprovação

Quando uma regra precisar de aprovação, ela será encaminhada para avaliação do Supervisor de Vendas.

O supervisor poderá:

- Visualizar a regra;
- Consultar a análise realizada;
- Visualizar a simulação;
- Aprovar a regra;
- Reprovar a regra;
- Acompanhar o status;
- Consultar informações relacionadas à decisão.

## 8\. Status da regra

Durante seu ciclo de vida, uma regra poderá apresentar diferentes estados.

Exemplo:

```
Criada
   ↓
Em análise
   ↓
Simulada
   ↓
Aguardando aprovação
   ↓
Aprovada / Reprovada
```

## 9\. Rastreabilidade

O sistema mantém informações relacionadas às alterações e decisões realizadas sobre as regras.

O usuário autorizado poderá consultar:

- Histórico de alterações;
- Usuário responsável pela alteração;
- Aprovações e reprovações;
- Registros de decisão;
- Informações utilizadas na análise.

## 10\. Exemplo de utilização

### Cenário

Um Gerente de Vendas deseja criar uma campanha oferecendo comissão de 8% para a Região Sul.

### Entrada

```
Comissão de 8% para a Região Sul.
```

### Análise

O Camplana consulta as regras existentes e verifica os limites e possíveis conflitos.

### Resultado

```
Aprovado para simulação.

Limite identificado: 10%.
Comissão solicitada: 8%.
Conflitos encontrados: nenhum.
```

### Simulação

O usuário executa a simulação para visualizar o impacto financeiro estimado.
