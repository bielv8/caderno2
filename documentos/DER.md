# Diagrama Entidade-Relacionamento (DER)
# Sistema de Gestão de Estoque

```
┌─────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
│     USUARIOS    │       │   MOVIMENTACOES     │       │      PRODUTOS       │
├─────────────────┤       ├─────────────────────┤       ├─────────────────────┤
│ id (PK)         │◄─────┐│ id (PK)             │┌─────►│ id (PK)             │
│ nome            │      ││ produto_id (FK)     ││      │ nome                │
│ email (UNIQUE)  │      ││ usuario_id (FK)     ││      │ descricao           │
│ senha_hash      │      ││ tipo                ││      │ validade            │
│ created_at      │      ││ quantidade          ││      │ unidade             │
└─────────────────┘      │└─────────────────────┘│      │ estoque_minimo      │
                         │        │              │      │ estoque_atual       │
                         │        │              │      │ created_at          │
                         └────────┼──────────────┘      └─────────────────────┘
                                  │
                                  ▼
                            RELACIONAMENTOS:
                            • 1 USUARIO : N MOVIMENTACOES
                            • 1 PRODUTO : N MOVIMENTACOES
                            • MOVIMENTACOES.tipo IN ('entrada', 'saida')
```

## Descrição das Entidades

### USUARIOS
- **id**: Chave primária (SERIAL)
- **nome**: Nome completo do usuário (VARCHAR 100)
- **email**: Email único para login (VARCHAR 100, UNIQUE)
- **senha_hash**: Hash seguro da senha (VARCHAR 255)
- **created_at**: Data de criação (TIMESTAMP)

### PRODUTOS
- **id**: Chave primária (SERIAL)
- **nome**: Nome do produto (VARCHAR 150)
- **descricao**: Descrição detalhada (TEXT, opcional)
- **validade**: Data de validade (DATE, opcional)
- **unidade**: Unidade de medida (VARCHAR 20)
- **estoque_minimo**: Quantidade mínima em estoque (INTEGER)
- **estoque_atual**: Quantidade atual em estoque (INTEGER)
- **created_at**: Data de criação (TIMESTAMP)

### MOVIMENTACOES
- **id**: Chave primária (SERIAL)
- **produto_id**: Referência ao produto (FK → PRODUTOS.id)
- **usuario_id**: Referência ao usuário (FK → USUARIOS.id)
- **tipo**: Tipo de movimentação ('entrada' ou 'saida')
- **quantidade**: Quantidade movimentada (INTEGER)
- **data**: Data da movimentação (TIMESTAMP)

## Regras de Integridade
1. **Chaves Estrangeiras**: ON DELETE CASCADE
2. **Constraint**: tipo IN ('entrada', 'saida')
3. **Unique**: usuarios.email
4. **Not Null**: Campos obrigatórios conforme especificação