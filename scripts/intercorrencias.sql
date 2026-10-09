-- Intercorrencias de RH da Especificacao.
-- Executado por scripts/importar-intercorrencias.sh (precisa do psql, por causa dos \echo).
-- Tudo o que a especificacao cita entra em stg_evento, inclusive as pegadinhas.
-- A classificacao decide o que vai para evento_rh e o que vira linha do relatorio.
-- O script nao corrige nada, so lista.

BEGIN;

-- A ordem de insercao e a ordem da especificacao: define qual ocorrencia e a primeira.
CREATE TEMP TABLE stg_evento (
    ordem       SERIAL PRIMARY KEY,
    matricula   VARCHAR(20)  NOT NULL,
    tipo        VARCHAR(30)  NOT NULL,
    data_inicio DATE,
    data_fim    DATE,
    cod_loja    VARCHAR(10),
    dias        INT,
    origem      VARCHAR(255) NOT NULL
) ON COMMIT DROP;

INSERT INTO stg_evento (matricula, tipo, data_inicio, data_fim, cod_loja, dias, origem) VALUES
-- JULHO/2025
('MATRIC-58',  'afastamento',         '2025-07-10', '2025-07-24', NULL,     NULL, 'Especificacao jul/2025 item a'),
('MATRIC-124', 'afastamento',         '2025-07-21', '2025-07-25', NULL,     NULL, 'Especificacao jul/2025 item b'),
('MATRIC-400', 'afastamento',         '2025-07-15', '2025-07-16', NULL,     NULL, 'Especificacao jul/2025 item c'),
('MATRIC-485', 'afastamento',         '2025-07-10', '2025-07-29', NULL,     NULL, 'Especificacao jul/2025 item d'),
('MATRIC-549', 'ferias',              '2025-07-10', '2025-07-25', NULL,     NULL, 'Especificacao jul/2025 item e'),
('MATRIC-183', 'ferias',              '2025-07-10', '2025-07-25', NULL,     NULL, 'Especificacao jul/2025 item f'),
('MATRIC-293', 'cobertura_loja',      NULL,         NULL,         'LOJA-5', 10,   'Especificacao jul/2025 item g'),
-- AGOSTO/2025
('MATRIC-113', 'afastamento',         '2025-08-04', '2025-08-10', NULL,     NULL, 'Especificacao ago/2025 item a'),
('MATRIC-126', 'afastamento',         '2025-08-18', '2025-09-08', NULL,     NULL, 'Especificacao ago/2025 item b'),
('MATRIC-137', 'afastamento',         '2025-08-26', '2025-09-04', NULL,     NULL, 'Especificacao ago/2025 item c'),
('MATRIC-115', 'afastamento',         '2025-08-01', '2025-08-22', NULL,     NULL, 'Especificacao ago/2025 item d'),
('MATRIC-103', 'ferias',              '2025-08-04', '2025-08-17', NULL,     NULL, 'Especificacao ago/2025 item e'),
('MATRIC-127', 'ferias',              '2025-08-04', '2025-08-29', NULL,     NULL, 'Especificacao ago/2025 item f'),
-- SETEMBRO/2025
('MATRIC-138', 'afastamento',         '2025-09-08', '2025-09-11', NULL,     NULL, 'Especificacao set/2025 item a'),
('MATRIC-126', 'afastamento',         '2025-08-18', '2025-09-08', NULL,     NULL, 'Especificacao set/2025 item b'),
('MATRIC-137', 'afastamento',         '2025-08-26', '2025-09-05', NULL,     NULL, 'Especificacao set/2025 item c'),
('MATRIC-17',  'ferias',              '2025-09-01', '2025-09-30', NULL,     NULL, 'Especificacao set/2025 item d'),
('MATRIC-127', 'ferias',              '2025-09-15', '2025-09-26', NULL,     NULL, 'Especificacao set/2025 item e'),
-- OUTUBRO/2025
('MATRIC-179', 'afastamento',         '2025-10-17', '2025-11-20', NULL,     NULL, 'Especificacao out/2025 item a'),
('MATRIC-464', 'afastamento',         '2025-10-06', '2025-10-17', NULL,     NULL, 'Especificacao out/2025 item b'),
('MATRIC-246', 'afastamento',         '2025-10-06', '2025-10-24', NULL,     NULL, 'Especificacao out/2025 item c'),
('MATRIC-71',  'licenca_maternidade', '2025-10-01', NULL,         NULL,     NULL, 'Especificacao out/2025 item d'),
('MATRIC-408', 'ferias',              '2025-10-01', '2025-10-30', NULL,     NULL, 'Especificacao out/2025 item e'),
('MATRIC-199', 'ferias',              '2025-10-13', '2025-10-27', NULL,     NULL, 'Especificacao out/2025 item f'),
-- NOVEMBRO/2025
('MATRIC-179', 'afastamento',         '2025-10-17', '2025-11-20', NULL,     NULL, 'Especificacao nov/2025 item a'),
('MATRIC-5',   'afastamento',         '2025-11-10', '2025-12-12', NULL,     NULL, 'Especificacao nov/2025 item b'),
('MATRIC-71',  'licenca_maternidade', '2025-10-01', NULL,         NULL,     NULL, 'Especificacao nov/2025 item c'),
('MATRIC-581', 'ferias',              '2025-11-10', '2025-11-24', NULL,     NULL, 'Especificacao nov/2025 item d'),
('MATRIC-52',  'ferias',              '2025-11-24', '2025-12-12', NULL,     NULL, 'Especificacao nov/2025 item e'),
-- DEZEMBRO/2025
('MATRIC-188', 'afastamento',         '2025-12-03', '2025-12-09', NULL,     NULL, 'Especificacao dez/2025 item a'),
('MATRIC-5',   'afastamento',         '2025-11-10', '2025-12-12', NULL,     NULL, 'Especificacao dez/2025 item b'),
('MATRIC-71',  'licenca_maternidade', '2025-10-01', NULL,         NULL,     NULL, 'Especificacao dez/2025 item c'),
('MATRIC-318', 'ferias',              '2025-12-15', '2025-12-02', NULL,     NULL, 'Especificacao dez/2025 item d'),
('MATRIC-52',  'ferias',              '2025-11-24', '2025-12-12', NULL,     NULL, 'Especificacao dez/2025 item e');

CREATE TEMP TABLE stg_classificado ON COMMIT DROP AS
SELECT s.*,
       CASE s.tipo
           WHEN 'afastamento'         THEN 'Afastamento'
           WHEN 'ferias'              THEN 'Férias'
           WHEN 'licenca_maternidade' THEN 'Licença maternidade'
           ELSE 'Cobertura de loja'
       END AS rotulo,
       CASE
           WHEN s.data_inicio IS NULL THEN s.dias::text || ' dias'
           WHEN s.data_fim IS NULL    THEN 'a partir de ' || to_char(s.data_inicio, 'DD/MM/YYYY')
           ELSE to_char(s.data_inicio, 'DD/MM/YYYY') || ' a ' || to_char(s.data_fim, 'DD/MM/YYYY')
       END AS periodo,
       row_number() OVER w AS ocorrencia,
       first_value(s.data_fim) OVER w AS fim_primeira
FROM stg_evento s
WINDOW w AS (PARTITION BY s.matricula, s.tipo, s.data_inicio ORDER BY s.ordem);

-- Cada linha e uma pendencia. Um evento pode ter mais de uma.
CREATE TEMP TABLE pendencia ON COMMIT DROP AS
SELECT ordem, 'data_fim' AS campo, 'IMPEDITIVO' AS severidade,
       rotulo || ' com data final antes da inicial (' || periodo || ')' AS motivo
FROM stg_classificado
WHERE data_fim < data_inicio
UNION ALL
SELECT ordem, 'origem', 'AVISO',
       rotulo || ' repetido, já informado em mês anterior (' || periodo || ')'
FROM stg_classificado
WHERE ocorrencia > 1 AND data_fim IS NOT DISTINCT FROM fim_primeira
UNION ALL
SELECT ordem, 'data_fim', 'AVISO',
       rotulo || ' repetido com data final diferente da primeira ocorrência (' || periodo || ')'
FROM stg_classificado
WHERE ocorrencia > 1 AND data_fim IS DISTINCT FROM fim_primeira
UNION ALL
SELECT ordem, 'data_fim', 'AVISO',
       rotulo || ' sem data de término (' || periodo || ')'
FROM stg_classificado
WHERE tipo = 'licenca_maternidade' AND data_fim IS NULL AND ocorrencia = 1
UNION ALL
SELECT ordem, 'cod_loja / dias', 'AVISO',
       rotulo || ' sem intervalo de datas (' || periodo || ' na ' || cod_loja || ')'
FROM stg_classificado
WHERE tipo = 'cobertura_loja' AND data_inicio IS NULL AND ocorrencia = 1
UNION ALL
SELECT ordem, 'data_fim', 'AVISO',
       rotulo || ' de exatamente 15 dias (' || periodo || '); conta como até 15'
FROM stg_classificado
WHERE tipo = 'afastamento' AND data_fim - data_inicio + 1 = 15 AND ocorrencia = 1
UNION ALL
SELECT c.ordem, 'data_inicio', 'AVISO',
       c.rotulo || ' começa antes da admissão cadastrada (' || to_char(f.data_admissao, 'DD/MM/YYYY') || ')'
FROM stg_classificado c
JOIN funcionario f ON f.matricula = c.matricula
WHERE c.data_inicio < f.data_admissao AND c.ocorrencia = 1;

CREATE TEMP TABLE carga ON COMMIT DROP AS
SELECT c.*
FROM stg_classificado c
WHERE c.ocorrencia = 1
  AND NOT EXISTS (
      SELECT 1 FROM pendencia p
      WHERE p.ordem = c.ordem AND p.severidade = 'IMPEDITIVO'
  );

INSERT INTO evento_rh (matricula, tipo, data_inicio, data_fim, cod_loja, dias, origem)
SELECT matricula, tipo, data_inicio, data_fim, cod_loja, dias, origem
FROM carga
ORDER BY ordem
ON CONFLICT DO NOTHING;

\echo '## Resumo'
\echo
SELECT format('- Linhas lidas da especificação: %s', count(*)) FROM stg_evento;
SELECT format('- Eventos válidos, carregados uma vez: %s', count(*)) FROM carga;
SELECT format('- Pendências %s: %s', severidade, count(*))
FROM pendencia
GROUP BY severidade
ORDER BY severidade;
SELECT format('- Total em evento_rh: %s', count(*)) FROM evento_rh;
\echo
\echo '## Pendências'
\echo
\echo '| Origem | Item | Campo | Motivo | Severidade | Tratamento |'
\echo '| :--- | :--- | :--- | :--- | :--- | :--- |'
SELECT format('| %s | %s | %s | %s | **%s** | %s |',
       c.origem, c.matricula, p.campo, p.motivo, p.severidade,
       CASE
           WHEN p.severidade = 'IMPEDITIVO' THEN 'Não carregada em evento_rh.'
           WHEN c.ocorrencia > 1            THEN 'Não carregada de novo; vale a primeira ocorrência.'
           ELSE 'Carregada; fica o alerta.'
       END)
FROM pendencia p
JOIN stg_classificado c ON c.ordem = p.ordem
ORDER BY p.severidade DESC, c.ordem;

COMMIT;