# Requisitos Funcionais - Sistema de Gestão de Estoque

## Visão Geral
Sistema web para gestão de estoque de materiais de construção, desenvolvido em Python Flask com banco PostgreSQL.

## Funcionalidades Implementadas

### 1. Sistema de Autenticação
- **RF001**: Login de usuário com validação de email e senha
- **RF002**: Logout com redirecionamento para tela de login
- **RF003**: Mensagens de erro para credenciais inválidas
- **RF004**: Proteção de rotas (login obrigatório)

### 2. Dashboard Principal
- **RF005**: Exibição do nome do usuário logado
- **RF006**: Menu de navegação para todas as funcionalidades
- **RF007**: Acesso rápido aos módulos principais

### 3. Cadastro de Produtos
- **RF008**: Listagem completa de produtos com dados do banco
- **RF009**: Campo de busca por nome do produto
- **RF010**: Inserção de novos produtos com validações
- **RF011**: Campos obrigatórios: nome, unidade, estoque mínimo
- **RF012**: Campos opcionais: descrição, data de validade
- **RF013**: Indicação visual de produtos com estoque baixo

### 4. Gestão de Estoque
- **RF014**: Listagem de produtos ordenada alfabeticamente
- **RF015**: Registro de movimentações (entrada/saída)
- **RF016**: Inserção da data da movimentação
- **RF017**: Atualização automática do estoque atual
- **RF018**: Alertas automáticos para estoque abaixo do mínimo
- **RF019**: Histórico completo de movimentações

### 5. Sistema de Documentação
- **RF020**: Acesso à documentação técnica
- **RF021**: Visualização de requisitos funcionais
- **RF022**: Acesso ao diagrama entidade-relacionamento
- **RF023**: Download do script SQL
- **RF024**: Documentação de casos de teste
- **RF025**: Especificações de infraestrutura

## Regras de Negócio

### RN001 - Controle de Estoque
- Movimentações de entrada aumentam o estoque atual
- Movimentações de saída reduzem o estoque atual
- Sistema impede estoque negativo

### RN002 - Alertas de Estoque Mínimo
- Produtos com estoque atual ≤ estoque mínimo geram alerta
- Alertas são exibidos na tela de gestão de estoque
- Indicação visual com badges coloridos

### RN003 - Rastreabilidade
- Todas as movimentações são registradas com:
  - Produto movimentado
  - Usuário responsável
  - Tipo da movimentação
  - Quantidade
  - Data e hora

### RN004 - Validações de Dados
- Nome do produto: obrigatório, máximo 150 caracteres
- Email: formato válido e único
- Quantidades: valores positivos
- Datas: formato válido

## Casos de Uso

### UC001 - Fazer Login
**Ator**: Usuário  
**Pré-condições**: Usuário cadastrado no sistema  
**Fluxo Principal**:
1. Usuário acessa a tela de login
2. Informa email e senha
3. Sistema valida credenciais
4. Usuário é redirecionado para o dashboard

### UC002 - Cadastrar Produto
**Ator**: Usuário autenticado  
**Pré-condições**: Usuário logado  
**Fluxo Principal**:
1. Usuário acessa módulo de produtos
2. Clica em "Novo Produto"
3. Preenche formulário
4. Submete dados
5. Sistema valida e salva produto
6. Produto aparece na listagem

### UC003 - Registrar Movimentação
**Ator**: Usuário autenticado  
**Pré-condições**: Produto cadastrado  
**Fluxo Principal**:
1. Usuário acessa gestão de estoque
2. Clica em "Entrada" ou "Saída"
3. Seleciona produto
4. Informa quantidade e data
5. Sistema registra movimentação
6. Estoque é atualizado automaticamente

## Tecnologias Utilizadas
- **Backend**: Python 3.12 + Flask
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5
- **Banco**: PostgreSQL 16
- **Autenticação**: Flask-Login
- **Segurança**: Werkzeug (hash de senhas)