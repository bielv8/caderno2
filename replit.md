# Replit.md - Sistema de Gestão de Estoque

## Overview
Sistema web completo desenvolvido em Python Flask para gestão de estoque de materiais de construção. O sistema oferece funcionalidades para controle de entrada e saída de produtos, alertas automáticos de estoque mínimo, rastreabilidade de movimentações e documentação técnica integrada. Projetado para pequenos e médios comerciantes que necessitam de uma solução robusta e fácil de usar para gerenciar seus estoques.

## User Preferences
Preferred communication style: Simple, everyday language.

## System Architecture

### Backend Architecture
- **Framework**: Flask 3.1.2 como framework web principal
- **Language**: Python 3.12+ para toda a lógica de negócio
- **Authentication**: Flask-Login para gerenciamento de sessões e autenticação de usuários
- **Security**: Werkzeug para hashing de senhas e utilitários de segurança
- **Database Connector**: psycopg2-binary para comunicação com PostgreSQL

### Frontend Architecture
- **Template Engine**: Jinja2 (integrado ao Flask) para renderização server-side
- **CSS Framework**: Bootstrap 5.1.3 para interface responsiva e componentes prontos
- **JavaScript**: Vanilla JavaScript ES6+ para interatividade client-side
- **Structure**: Template base com herança para consistência visual
- **Assets**: Organização em /static para CSS, JavaScript e documentação

### Database Design
- **RDBMS**: PostgreSQL 16 (nome do banco: saep_db)
- **Schema Design**: 3 entidades principais com relacionamentos bem definidos
  - **USUARIOS**: Gerenciamento de usuários do sistema
  - **PRODUTOS**: Catálogo de produtos com informações de estoque
  - **MOVIMENTACOES**: Histórico de todas as transações de entrada/saída
- **Relationships**: Relacionamentos 1:N entre usuários/movimentações e produtos/movimentações
- **Constraints**: Chaves estrangeiras, campos únicos e validações de integridade

### Authentication & Authorization
- **Session Management**: Flask-Login para controle de sessões
- **Password Security**: Hash seguro usando Werkzeug
- **Route Protection**: Decoradores @login_required para proteção de rotas
- **User Context**: current_user disponível em todos os templates

### Application Structure
```
/sistema
├── app.py                 # Aplicação principal Flask
├── /templates            # Templates HTML com Jinja2
│   ├── base.html         # Template base com navegação
│   ├── login.html        # Página de autenticação
│   ├── dashboard.html    # Painel principal
│   ├── produtos.html     # Gestão de produtos
│   └── estoque.html      # Controle de estoque
├── /static              # Arquivos estáticos
│   ├── /css             # Estilos customizados
│   ├── /js              # Scripts JavaScript
│   └── /docs            # Documentação em HTML
└── /documentos          # Documentação em Markdown
```

## External Dependencies

### Database
- **PostgreSQL 16**: Sistema de gerenciamento de banco de dados principal
- **Connection**: Via DATABASE_URL environment variable para flexibilidade de deployment

### Python Packages
- **Flask 3.1.2**: Framework web principal
- **Flask-Login 0.6.3**: Sistema de autenticação e sessões
- **Werkzeug 3.1.3**: Utilitários WSGI e segurança
- **psycopg2-binary 2.9.10**: Driver PostgreSQL para Python

### Frontend Libraries
- **Bootstrap 5.1.3**: Framework CSS via CDN para interface responsiva
- **No external JavaScript frameworks**: Uso de JavaScript vanilla para máxima compatibilidade

### Development Tools
- **Environment Variables**: SECRET_KEY e DATABASE_URL para configuração
- **Error Handling**: Sistema integrado de flash messages para feedback do usuário
- **Documentation**: Sistema completo de documentação técnica em HTML

### Infrastructure Requirements
- **Operating System**: Linux Ubuntu 22.04 LTS ou superior
- **Python Runtime**: 3.12+ com pip para gerenciamento de pacotes
- **Web Server**: Desenvolvimento com servidor Flask integrado
- **Hardware**: Mínimo 2GB RAM, 10GB storage para desenvolvimento