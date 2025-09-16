-- Script de Criação e População do Banco de Dados
-- Sistema de Gestão de Estoque - Ferramentas Manuais
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

-- Tabela de ferramentas manuais
CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    material VARCHAR(50),
    peso VARCHAR(20),
    tamanho VARCHAR(20),
    caracteristicas TEXT,
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

-- Ferramentas manuais (martelos, chaves de fenda, alicates, etc.)

-- Martelos
INSERT INTO produtos (nome, tipo, material, peso, tamanho, caracteristicas, unidade, estoque_minimo, estoque_atual) VALUES 
('Martelo de Aço 500g', 'martelo', 'aço', '500g', '30cm', 'Cabeça de aço forjado, cabo de madeira resistente, ideal para trabalhos pesados', 'unidade', 5, 15),
('Martelo com Cabo de Madeira', 'martelo', 'madeira/aço', '350g', '28cm', 'Cabo de madeira ergonômico, cabeça de aço temperado, absorção de impacto', 'unidade', 3, 8),
('Martelo de Borracha 400g', 'martelo', 'borracha/aço', '400g', '25cm', 'Cabeça de borracha para trabalhos delicados, cabo antiderrapante', 'unidade', 4, 6);

-- Chaves de Fenda  
INSERT INTO produtos (nome, tipo, material, peso, tamanho, caracteristicas, unidade, estoque_minimo, estoque_atual) VALUES 
('Chave de Fenda Isolada 6mm', 'chave_fenda', 'aço/plástico', '120g', '25cm', 'Revestimento isolante até 1000V, ponta magnética, cabo ergonômico', 'unidade', 10, 25),
('Chave de Fenda Ponta Imantada 8mm', 'chave_fenda', 'aço', '150g', '30cm', 'Ponta imantada para facilitar o trabalho, cabo antiderrapante', 'unidade', 8, 18),
('Chave de Fenda Phillips 4mm', 'chave_fenda', 'aço', '100g', '20cm', 'Ponta Phillips para parafusos em cruz, acabamento cromado', 'unidade', 12, 20);

-- Alicates e outras ferramentas
INSERT INTO produtos (nome, tipo, material, peso, tamanho, caracteristicas, unidade, estoque_minimo, estoque_atual) VALUES 
('Alicate Universal 8"', 'alicate', 'aço', '280g', '20cm', 'Aço carbono temperado, cabo isolado, corte lateral integrado', 'unidade', 6, 12),
('Chave Inglesa 10"', 'chave_inglesa', 'aço', '420g', '25cm', 'Abertura regulável, acabamento cromado, mandíbulas paralelas', 'unidade', 4, 9),
('Furadeira Manual com Brocas', 'furadeira', 'metal/plástico', '800g', '35cm', 'Furadeira manual com conjunto de brocas variadas, empunhadura ergonômica', 'unidade', 2, 5);

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
COMMENT ON TABLE produtos IS 'Tabela de ferramentas manuais em estoque';
COMMENT ON TABLE movimentacoes IS 'Tabela de movimentações de entrada e saída';

-- Comentários das colunas
COMMENT ON COLUMN produtos.tipo IS 'Tipo da ferramenta: martelo, chave_fenda, alicate, etc.';
COMMENT ON COLUMN produtos.material IS 'Material da ferramenta: aço, madeira, plástico, borracha, etc.';
COMMENT ON COLUMN produtos.caracteristicas IS 'Características especiais: ponta magnética, revestimento isolante, etc.';
COMMENT ON COLUMN produtos.estoque_minimo IS 'Quantidade mínima em estoque para gerar alerta';
COMMENT ON COLUMN produtos.estoque_atual IS 'Quantidade atual em estoque';
COMMENT ON COLUMN movimentacoes.tipo IS 'Tipo da movimentação: entrada ou saida';