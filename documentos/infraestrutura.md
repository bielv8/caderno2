# Requisitos de Infraestrutura - Sistema de Gestão de Estoque

## Visão Geral
Documentação técnica dos requisitos de infraestrutura para implantação e operação do Sistema de Gestão de Estoque para materiais de construção.

## Especificações do Sistema

### Sistema Operacional
| **Componente** | **Especificação** | **Versão** |
|----------------|-------------------|------------|
| **OS Base** | Linux Ubuntu Server | 22.04 LTS |
| **Arquitetura** | x86_64 | 64-bit |
| **Kernel** | Linux Kernel | ≥ 5.15 |

### Software Base

#### Linguagem de Programação
| **Software** | **Versão** | **Propósito** |
|--------------|------------|---------------|
| **Python** | 3.12.x | Linguagem principal do backend |
| **pip** | Latest | Gerenciador de pacotes Python |

#### Framework Web
| **Software** | **Versão** | **Propósito** |
|--------------|------------|---------------|
| **Flask** | 3.1.2 | Framework web principal |
| **Flask-Login** | 0.6.3 | Gerenciamento de autenticação |
| **Werkzeug** | 3.1.3 | Utilitários WSGI |

#### Banco de Dados
| **Software** | **Versão** | **Propósito** |
|--------------|------------|---------------|
| **PostgreSQL** | 16.x | Sistema de gerenciamento de banco |
| **psycopg2-binary** | 2.9.10 | Adaptador PostgreSQL para Python |

#### Frontend
| **Tecnologia** | **Versão** | **Propósito** |
|----------------|------------|---------------|
| **HTML5** | - | Estrutura das páginas |
| **CSS3** | - | Estilização |
| **JavaScript** | ES6+ | Interatividade |
| **Bootstrap** | 5.1.3 | Framework CSS responsivo |

## Requisitos de Hardware

### Ambiente de Desenvolvimento
| **Recurso** | **Mínimo** | **Recomendado** |
|-------------|------------|-----------------|
| **CPU** | 1 core | 2+ cores |
| **RAM** | 2 GB | 4 GB |
| **Armazenamento** | 10 GB | 20 GB SSD |
| **Rede** | 100 Mbps | 1 Gbps |

### Ambiente de Produção
| **Recurso** | **Mínimo** | **Recomendado** | **Alta Carga** |
|-------------|------------|-----------------|----------------|
| **CPU** | 2 cores | 4 cores | 8+ cores |
| **RAM** | 4 GB | 8 GB | 16+ GB |
| **Armazenamento** | 50 GB SSD | 100 GB SSD | 500+ GB SSD |
| **Rede** | 1 Gbps | 1 Gbps | 10 Gbps |
| **Backup** | - | 100 GB | 1 TB+ |

## Arquitetura da Aplicação

### Estrutura de Diretórios
```
/opt/sistema-estoque/
├── sistema/                 # Aplicação Flask
│   ├── app.py              # Arquivo principal
│   ├── models/             # Modelos de dados
│   ├── templates/          # Templates HTML
│   └── static/             # Arquivos estáticos
│       ├── css/
│       ├── js/
│       └── docs/
├── documentos/             # Documentação técnica
├── logs/                   # Arquivos de log
└── backups/               # Backups do sistema
```

### Fluxo de Dados
```
[Cliente Web] ←→ [Nginx/Apache] ←→ [Flask App] ←→ [PostgreSQL]
     ↓                ↓               ↓            ↓
[HTML/CSS/JS]    [SSL/HTTPS]    [Python Logic]  [Dados]
```

## Configurações do Banco de Dados

### PostgreSQL Settings
```sql
-- Configurações recomendadas postgresql.conf
shared_buffers = 256MB          # 25% da RAM disponível
effective_cache_size = 1GB      # 75% da RAM disponível
maintenance_work_mem = 64MB     # Para operações de manutenção
checkpoint_completion_target = 0.7
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1          # Para SSDs
effective_io_concurrency = 200  # Para SSDs
```

### Conexão com Banco
```python
# Variáveis de ambiente necessárias
DATABASE_URL=postgresql://user:password@localhost:5432/saep_db
PGHOST=localhost
PGPORT=5432
PGUSER=sistema_user
PGPASSWORD=senha_segura
PGDATABASE=saep_db
```

## Segurança

### Configurações de Segurança
| **Aspecto** | **Implementação** |
|-------------|-------------------|
| **Autenticação** | Flask-Login com sessões |
| **Senhas** | Hash Werkzeug (scrypt) |
| **HTTPS** | SSL/TLS obrigatório em produção |
| **Firewall** | Portas 22, 80, 443 apenas |
| **Backup** | Diário automatizado |

### Usuários do Sistema
```bash
# Usuário da aplicação (sem shell)
sudo useradd -r -s /bin/false -d /opt/sistema-estoque sistema

# Usuário do banco PostgreSQL
sudo -u postgres createuser --pwprompt sistema_user
```

## Dependências Externas

### Bibliotecas Python
```txt
Flask==3.1.2
Flask-Login==0.6.3
psycopg2-binary==2.9.10
Werkzeug==3.1.3
Jinja2==3.1.6
MarkupSafe==3.0.2
click==8.2.1
itsdangerous==2.2.0
blinker==1.9.0
```

### CDNs Externos
- **Bootstrap CSS**: `https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css`
- **Bootstrap JS**: `https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js`

## Configuração de Implantação

### Servidor Web (Nginx)
```nginx
server {
    listen 80;
    server_name seu-dominio.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name seu-dominio.com;
    
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location /static/ {
        alias /opt/sistema-estoque/sistema/static/;
        expires 30d;
    }
}
```

### Serviço Systemd
```ini
# /etc/systemd/system/sistema-estoque.service
[Unit]
Description=Sistema de Gestão de Estoque
After=network.target postgresql.service

[Service]
Type=simple
User=sistema
WorkingDirectory=/opt/sistema-estoque/sistema
ExecStart=/usr/bin/python3 app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## Monitoramento e Logs

### Estrutura de Logs
```
/var/log/sistema-estoque/
├── aplicacao.log          # Logs da aplicação Flask
├── acesso.log            # Logs de acesso HTTP
├── erro.log              # Logs de erro
└── banco.log             # Logs do PostgreSQL
```

### Métricas a Monitorar
- **CPU**: Utilização < 80%
- **RAM**: Utilização < 85%
- **Disco**: Espaço livre > 20%
- **Rede**: Latência < 100ms
- **Banco**: Conexões ativas
- **App**: Tempo de resposta < 2s

## Backup e Recuperação

### Estratégia de Backup
```bash
#!/bin/bash
# Script de backup diário
BACKUP_DIR="/opt/sistema-estoque/backups"
DATE=$(date +"%Y%m%d_%H%M%S")

# Backup do banco
pg_dump saep_db > "$BACKUP_DIR/db_backup_$DATE.sql"

# Backup dos arquivos
tar -czf "$BACKUP_DIR/files_backup_$DATE.tar.gz" /opt/sistema-estoque/sistema/

# Manter apenas últimos 30 dias
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

### Procedimento de Restauração
1. **Parar aplicação**: `systemctl stop sistema-estoque`
2. **Restaurar banco**: `psql saep_db < backup.sql`
3. **Restaurar arquivos**: `tar -xzf files_backup.tar.gz`
4. **Reiniciar aplicação**: `systemctl start sistema-estoque`

## Escalabilidade

### Otimizações para Alta Carga
- **Load Balancer**: Nginx upstream
- **Cache**: Redis para sessões
- **CDN**: CloudFlare para estáticos
- **Banco**: Read replicas PostgreSQL
- **Containerização**: Docker + Kubernetes

### Limites Operacionais
- **Usuários Simultâneos**: ~500 (configuração atual)
- **Produtos**: ~10.000 registros
- **Movimentações**: ~100.000/mês
- **Consultas/seg**: ~100 QPS