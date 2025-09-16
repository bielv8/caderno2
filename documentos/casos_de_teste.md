# Casos de Teste - Sistema de Gestão de Estoque

## Ambiente de Teste
- **Sistema Operacional**: Linux Ubuntu 22.04
- **Python**: 3.12
- **Flask**: 3.1.2
- **PostgreSQL**: 16
- **Navegador**: Compatível com Chrome, Firefox, Safari

## Ferramentas de Teste
- **Testes Funcionais**: Navegador web
- **Testes de Integração**: Postman/curl
- **Validação de Banco**: pgAdmin/psql
- **Performance**: Lighthouse (opcional)

## Casos de Teste Funcionais

### CT001 - Login com Credenciais Válidas
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar login com usuário válido |
| **Pré-condições** | Usuário cadastrado no sistema |
| **Passos** | 1. Acessar /login<br>2. Inserir email: joao@email.com<br>3. Inserir senha: 123456<br>4. Clicar "Entrar" |
| **Resultado Esperado** | Redirecionamento para dashboard |
| **Status** | ✅ PASSOU |

### CT002 - Login com Credenciais Inválidas
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar rejeição de credenciais incorretas |
| **Pré-condições** | Sistema funcionando |
| **Passos** | 1. Acessar /login<br>2. Inserir email: teste@teste.com<br>3. Inserir senha: senhaerrada<br>4. Clicar "Entrar" |
| **Resultado Esperado** | Mensagem "Email ou senha inválidos" |
| **Status** | ✅ PASSOU |

### CT003 - Acesso sem Autenticação
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar proteção de rotas |
| **Pré-condições** | Usuário não logado |
| **Passos** | 1. Acessar diretamente /dashboard |
| **Resultado Esperado** | Redirecionamento para /login |
| **Status** | ✅ PASSOU |

### CT004 - Logout
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar saída do sistema |
| **Pré-condições** | Usuário logado |
| **Passos** | 1. Clicar em "Sair" no menu<br>2. Tentar acessar páginas internas |
| **Resultado Esperado** | Redirecionamento para login |
| **Status** | ✅ PASSOU |

### CT005 - Cadastro de Produto Válido
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Inserir novo produto no sistema |
| **Pré-condições** | Usuário logado |
| **Passos** | 1. Acessar /produtos<br>2. Clicar "Novo Produto"<br>3. Preencher campos obrigatórios<br>4. Clicar "Salvar" |
| **Resultado Esperado** | Produto aparece na listagem |
| **Status** | ✅ PASSOU |

### CT006 - Cadastro com Campos Obrigatórios Vazios
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Validar campos obrigatórios |
| **Pré-condições** | Usuário logado |
| **Passos** | 1. Acessar /produtos<br>2. Clicar "Novo Produto"<br>3. Deixar campo "Nome" vazio<br>4. Tentar salvar |
| **Resultado Esperado** | Validação impede envio |
| **Status** | ✅ PASSOU |

### CT007 - Busca de Produtos
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Filtrar produtos por nome |
| **Pré-condições** | Produtos cadastrados |
| **Passos** | 1. Acessar /produtos<br>2. Digitar "cimento" no campo busca<br>3. Clicar "Buscar" |
| **Resultado Esperado** | Apenas produtos com "cimento" no nome |
| **Status** | ✅ PASSOU |

### CT008 - Entrada de Estoque
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Registrar entrada de produtos |
| **Pré-condições** | Produto cadastrado |
| **Passos** | 1. Acessar /estoque<br>2. Clicar "Entrada de Estoque"<br>3. Selecionar produto<br>4. Informar quantidade: 10<br>5. Confirmar |
| **Resultado Esperado** | Estoque atual aumenta em 10 unidades |
| **Status** | ✅ PASSOU |

### CT009 - Saída de Estoque
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Registrar saída de produtos |
| **Pré-condições** | Produto com estoque disponível |
| **Passos** | 1. Acessar /estoque<br>2. Clicar "Saída de Estoque"<br>3. Selecionar produto<br>4. Informar quantidade: 5<br>5. Confirmar |
| **Resultado Esperado** | Estoque atual diminui em 5 unidades |
| **Status** | ✅ PASSOU |

### CT010 - Alerta de Estoque Baixo
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar alertas automáticos |
| **Pré-condições** | Produto com estoque ≤ mínimo |
| **Passos** | 1. Configurar produto com est_min=10, est_atual=8<br>2. Acessar /estoque |
| **Resultado Esperado** | Alerta amarelo exibido |
| **Status** | ✅ PASSOU |

## Casos de Teste de Integração

### CTI001 - Conexão com Banco de Dados
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar conectividade PostgreSQL |
| **Método** | Consulta direta ao banco |
| **Comando** | `SELECT version();` |
| **Status** | ✅ PASSOU |

### CTI002 - Integridade Referencial
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Validar relacionamentos FK |
| **Método** | Tentar inserir movimentação com produto_id inexistente |
| **Resultado Esperado** | Erro de constraint |
| **Status** | ✅ PASSOU |

### CTI003 - Hash de Senhas
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar criptografia de senhas |
| **Método** | Consultar tabela usuarios |
| **Verificação** | Senhas não estão em texto plano |
| **Status** | ✅ PASSOU |

## Testes de Performance

### CTP001 - Tempo de Resposta Login
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Medir tempo de autenticação |
| **Método** | Cronômetro manual |
| **Meta** | < 2 segundos |
| **Resultado** | ~0.5 segundos |
| **Status** | ✅ PASSOU |

### CTP002 - Carregamento de Lista de Produtos
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Medir tempo de listagem |
| **Método** | Developer Tools |
| **Meta** | < 1 segundo |
| **Resultado** | ~0.3 segundos |
| **Status** | ✅ PASSOU |

## Testes de Usabilidade

### CTU001 - Interface Responsiva
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Verificar adaptação móvel |
| **Método** | Redimensionar navegador |
| **Breakpoints** | 768px, 576px, 320px |
| **Status** | ✅ PASSOU |

### CTU002 - Mensagens de Feedback
| **Campo** | **Valor** |
|-----------|-----------|
| **Objetivo** | Validar comunicação com usuário |
| **Verificações** | - Mensagens de sucesso<br>- Mensagens de erro<br>- Auto-dismiss após 5s |
| **Status** | ✅ PASSOU |

## Resumo dos Resultados

| **Categoria** | **Total** | **Passou** | **Falhou** | **Taxa Sucesso** |
|---------------|-----------|------------|------------|------------------|
| Funcionais    | 10        | 10         | 0          | 100%             |
| Integração    | 3         | 3          | 0          | 100%             |
| Performance   | 2         | 2          | 0          | 100%             |
| Usabilidade   | 2         | 2          | 0          | 100%             |
| **TOTAL**     | **17**    | **17**     | **0**      | **100%**         |

## Observações
- Todos os testes foram executados em ambiente de desenvolvimento
- Sistema demonstrou estabilidade durante os testes
- Interface responsiva funciona adequadamente
- Performance dentro dos padrões esperados
- Nenhum bug crítico identificado

## Recomendações
1. Implementar testes automatizados para CI/CD
2. Adicionar logs de auditoria detalhados
3. Considerar cache para consultas frequentes
4. Implementar backup automático do banco