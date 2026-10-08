ALTER TABLE usuario ADD COLUMN ativo BOOLEAN DEFAULT TRUE NOT NULL;

INSERT INTO usuario (nome, email, senha, perfil, ativo) VALUES
('Gerente1', 'gerente1@camplana.com.br', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'GERENTE', true),
('Supervisor2', 'supervisor2@camplana.com.br', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'SUPERVISOR', true),
('Supervisor 1', 'supervisor1@camplana.com.br', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'SUPERVISOR', true),
('ADMIN', 'admin@camplana.com.br', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'ADMIN', true);
