-- Script de Criação e População do Banco de Dados
-- Sistema de Gestão de Estoque - Equipamentos Eletrônicos
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

-- Tabela de produtos eletrônicos
CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    especificacoes TEXT,
    data_compra DATE,
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

-- Produtos eletrônicos (3 de cada tipo: smartphone, notebook, smart_tv)

-- Smartphones
INSERT INTO produtos (nome, tipo, especificacoes, data_compra, unidade, estoque_minimo, estoque_atual) VALUES 
('iPhone 15 Pro Max 256GB', 'smartphone', 'Tela: 6.7" Super Retina XDR | Armazenamento: 256GB | Conectividade: 5G, Wi-Fi 6E, Bluetooth 5.3', '2024-01-15', 'unidade', 5, 12),
('Samsung Galaxy S24 Ultra 512GB', 'smartphone', 'Tela: 6.8" Dynamic AMOLED 2X | Armazenamento: 512GB | Conectividade: 5G, Wi-Fi 7, Bluetooth 5.3', '2024-02-20', 'unidade', 3, 8),
('Xiaomi 14 Ultra 512GB', 'smartphone', 'Tela: 6.73" AMOLED | Armazenamento: 512GB | Conectividade: 5G, Wi-Fi 7, Bluetooth 5.4', '2024-03-10', 'unidade', 4, 6);

-- Notebooks  
INSERT INTO produtos (nome, tipo, especificacoes, data_compra, unidade, estoque_minimo, estoque_atual) VALUES 
('MacBook Pro 16" M3 Pro 512GB', 'notebook', 'Processador: Apple M3 Pro | RAM: 18GB | Armazenamento: 512GB SSD | Tela: 16.2" Liquid Retina XDR', '2024-01-25', 'unidade', 2, 5),
('Dell XPS 15 Intel i7 1TB', 'notebook', 'Processador: Intel Core i7-13700H | RAM: 32GB | Armazenamento: 1TB SSD | Tela: 15.6" OLED 3.5K', '2024-02-15', 'unidade', 3, 7),
('ASUS ROG Strix G15 RTX 4060', 'notebook', 'Processador: AMD Ryzen 9 7940HS | RAM: 16GB | Armazenamento: 512GB SSD | GPU: RTX 4060 8GB', '2024-03-05', 'unidade', 2, 4);

-- Smart TVs
INSERT INTO produtos (nome, tipo, especificacoes, data_compra, unidade, estoque_minimo, estoque_atual) VALUES 
('Samsung Neo QLED 65" QN90C', 'smart_tv', 'Tamanho: 65" | Resolução: 4K Neo QLED | HDR: HDR10+ | Conectividade: Wi-Fi 6, HDMI 2.1, Bluetooth', '2024-01-30', 'unidade', 2, 6),
('LG OLED 55" C3 Series', 'smart_tv', 'Tamanho: 55" | Resolução: 4K OLED | HDR: Dolby Vision IQ | Conectividade: Wi-Fi 6, HDMI 2.1, Bluetooth 5.1', '2024-02-25', 'unidade', 3, 8),
('Sony Bravia XR 75" X90L', 'smart_tv', 'Tamanho: 75" | Resolução: 4K LED | HDR: HDR10, Dolby Vision | Conectividade: Wi-Fi 6, HDMI 2.1, Bluetooth 4.2', '2024-03-15', 'unidade', 1, 3);

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
COMMENT ON TABLE produtos IS 'Tabela de equipamentos eletrônicos em estoque';
COMMENT ON TABLE movimentacoes IS 'Tabela de movimentações de entrada e saída';

-- Comentários das colunas
COMMENT ON COLUMN produtos.tipo IS 'Tipo do produto: smartphone, notebook ou smart_tv';
COMMENT ON COLUMN produtos.especificacoes IS 'Especificações técnicas: resolução, armazenamento, conectividade';
COMMENT ON COLUMN produtos.estoque_minimo IS 'Quantidade mínima em estoque para gerar alerta';
COMMENT ON COLUMN produtos.estoque_atual IS 'Quantidade atual em estoque';
COMMENT ON COLUMN movimentacoes.tipo IS 'Tipo da movimentação: entrada ou saida';