-- Script de Criação e População do Banco de Dados
-- Sistema de Gestão de Estoque - SAEP
-- PostgreSQL 16

-- Criação do banco de dados
CREATE DATABASE saep_db;

-- Conectar ao banco criado
\c saep_db;

-- Criação das tabelas

-- Tabela de usuários
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de produtos
CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    validade DATE,
    unidade VARCHAR(20) NOT NULL,
    estoque_minimo INTEGER NOT NULL DEFAULT 0,
    estoque_atual INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de movimentações
CREATE TABLE movimentacoes (
    id SERIAL PRIMARY KEY,
    produto_id INTEGER REFERENCES produtos(id) ON DELETE CASCADE,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo VARCHAR(10) CHECK (tipo IN ('entrada', 'saida')) NOT NULL,
    quantidade INTEGER NOT NULL,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criação de índices para melhor performance
CREATE INDEX idx_produtos_nome ON produtos(nome);
CREATE INDEX idx_movimentacoes_produto ON movimentacoes(produto_id);
CREATE INDEX idx_movimentacoes_usuario ON movimentacoes(usuario_id);
CREATE INDEX idx_movimentacoes_data ON movimentacoes(data);

-- Inserção de dados de exemplo

-- Usuários (senha padrão: 123456)
INSERT INTO usuarios (nome, email, senha_hash) VALUES 
('João Silva', 'joao@email.com', 'scrypt:32768:8:1$HwUX21XmfpMbO2KN$2c25d5f7583ed6df0e1ac9a92f55ee09fec7267885dd850b915591d463c19efcc7b00fe47a1faec911dfad992d2066ee577deb76c1e00809692b39b692561592'),
('Maria Santos', 'maria@email.com', 'scrypt:32768:8:1$HwUX21XmfpMbO2KN$2c25d5f7583ed6df0e1ac9a92f55ee09fec7267885dd850b915591d463c19efcc7b00fe47a1faec911dfad992d2066ee577deb76c1e00809692b39b692561592'),
('Pedro Costa', 'pedro@email.com', 'scrypt:32768:8:1$HwUX21XmfpMbO2KN$2c25d5f7583ed6df0e1ac9a92f55ee09fec7267885dd850b915591d463c19efcc7b00fe47a1faec911dfad992d2066ee577deb76c1e00809692b39b692561592');

-- Produtos
INSERT INTO produtos (nome, descricao, validade, unidade, estoque_minimo, estoque_atual) VALUES 
('Cimento CP-II 40kg', 'Cimento Portland composto para uso geral', '2025-12-31', 'saco', 50, 120),
('Tijolo cerâmico 6 furos', 'Tijolo cerâmico para alvenaria', '2030-01-01', 'milheiro', 5, 15),
('Areia média', 'Areia lavada para construção', '2030-01-01', 'm³', 10, 25),
('Brita 1', 'Brita graduada número 1', '2030-01-01', 'm³', 8, 18),
('Ferro 10mm', 'Vergalhão de aço CA-50', '2030-01-01', 'barra', 20, 45);

-- Movimentações
INSERT INTO movimentacoes (produto_id, usuario_id, tipo, quantidade, data) VALUES 
(1, 1, 'entrada', 50, '2024-09-01 08:00:00'),
(1, 2, 'saida', 10, '2024-09-02 14:30:00'),
(2, 1, 'entrada', 10, '2024-09-03 09:15:00'),
(3, 3, 'entrada', 15, '2024-09-04 10:45:00'),
(4, 2, 'entrada', 12, '2024-09-05 16:20:00'),
(5, 1, 'entrada', 30, '2024-09-06 07:30:00');

-- Views úteis para relatórios
CREATE VIEW view_estoque_baixo AS
SELECT p.id, p.nome, p.estoque_atual, p.estoque_minimo,
       (p.estoque_minimo - p.estoque_atual) as deficit
FROM produtos p 
WHERE p.estoque_atual <= p.estoque_minimo;

CREATE VIEW view_movimentacoes_completa AS
SELECT m.id, m.tipo, m.quantidade, m.data,
       p.nome as produto_nome, u.nome as usuario_nome
FROM movimentacoes m
JOIN produtos p ON m.produto_id = p.id
JOIN usuarios u ON m.usuario_id = u.id
ORDER BY m.data DESC;

-- Comentários das tabelas
COMMENT ON TABLE usuarios IS 'Tabela de usuários do sistema';
COMMENT ON TABLE produtos IS 'Tabela de produtos em estoque';
COMMENT ON TABLE movimentacoes IS 'Tabela de movimentações de entrada e saída';

-- Comentários das colunas
COMMENT ON COLUMN produtos.estoque_minimo IS 'Quantidade mínima em estoque para gerar alerta';
COMMENT ON COLUMN produtos.estoque_atual IS 'Quantidade atual em estoque';
COMMENT ON COLUMN movimentacoes.tipo IS 'Tipo da movimentação: entrada ou saida';