from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.middleware.proxy_fix import ProxyFix
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.DEBUG)

# Configuração da aplicação Flask
app = Flask(__name__)
app.secret_key = os.environ.get("SESSION_SECRET")
app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)  # needed for url_for to generate with https

# Verificar se a SECRET_KEY está configurada
if not app.secret_key:
    print("ERRO: SESSION_SECRET não configurado nas variáveis de ambiente")
    exit(1)

# Configuração do banco de dados
DATABASE_URL = os.environ.get('DATABASE_URL')
if not DATABASE_URL:
    print("ERRO: DATABASE_URL não configurado nas variáveis de ambiente")
    exit(1)

# Configuração Flask-Login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'
login_manager.login_message = 'Por favor, faça login para acessar esta página.'

class User(UserMixin):
    def __init__(self, id, nome, email):
        self.id = id
        self.nome = nome
        self.email = email

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            cursor.execute("SELECT * FROM usuarios WHERE id = %s", (user_id,))
            user_data = cursor.fetchone()
            if user_data:
                return User(user_data['id'], user_data['nome'], user_data['email'])
        except Exception as e:
            print(f"Erro ao carregar usuário: {e}")
        finally:
            conn.close()
    return None

def get_db_connection():
    """Conecta ao banco de dados PostgreSQL"""
    try:
        conn = psycopg2.connect(DATABASE_URL)
        return conn
    except Exception as e:
        print(f"Erro de conexão com o banco: {e}")
        return None

@app.route('/')
def index():
    """Página inicial - redireciona para login se não autenticado"""
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Página de login"""
    if request.method == 'POST':
        email = request.form['email']
        senha = request.form['senha']
        
        conn = get_db_connection()
        if conn:
            try:
                cursor = conn.cursor(cursor_factory=RealDictCursor)
                cursor.execute("SELECT * FROM usuarios WHERE email = %s", (email,))
                usuario = cursor.fetchone()
                
                if usuario and check_password_hash(usuario['senha_hash'], senha):
                    user = User(usuario['id'], usuario['nome'], usuario['email'])
                    login_user(user)
                    flash('Login realizado com sucesso!', 'success')
                    return redirect(url_for('dashboard'))
                else:
                    flash('Email ou senha inválidos.', 'error')
            except Exception as e:
                flash(f'Erro no sistema: {str(e)}', 'error')
            finally:
                conn.close()
    
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    """Logout do usuário"""
    logout_user()
    flash('Logout realizado com sucesso!', 'success')
    return redirect(url_for('login'))

@app.route('/dashboard')
@login_required
def dashboard():
    """Página principal do sistema"""
    return render_template('dashboard.html', usuario=current_user)

@app.route('/produtos')
@login_required
def produtos():
    """Página de gestão de produtos"""
    conn = get_db_connection()
    produtos = []
    
    # Busca por nome se fornecida
    search = request.args.get('search', '')
    
    if conn:
        try:
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            if search:
                cursor.execute("SELECT * FROM produtos WHERE nome ILIKE %s ORDER BY nome", (f'%{search}%',))
            else:
                cursor.execute("SELECT * FROM produtos ORDER BY nome")
            produtos = cursor.fetchall()
        except Exception as e:
            flash(f'Erro ao carregar produtos: {str(e)}', 'error')
        finally:
            conn.close()
    
    return render_template('produtos.html', produtos=produtos, search=search)

@app.route('/estoque')
@login_required
def estoque():
    """Página de gestão de estoque"""
    conn = get_db_connection()
    produtos = []
    alertas = []
    
    if conn:
        try:
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            cursor.execute("SELECT * FROM produtos ORDER BY nome")
            produtos = cursor.fetchall()
            
            # Verificar produtos com estoque baixo
            cursor.execute("SELECT * FROM produtos WHERE estoque_atual <= estoque_minimo")
            alertas = cursor.fetchall()
            
        except Exception as e:
            flash(f'Erro ao carregar estoque: {str(e)}', 'error')
        finally:
            conn.close()
    
    return render_template('estoque.html', produtos=produtos, alertas=alertas)

@app.route('/documentos')
@login_required
def documentos():
    """Página de documentos do sistema"""
    return render_template('documentos.html')

# Rotas de API para operações CRUD
@app.route('/api/produtos', methods=['POST'])
@login_required
def add_produto():
    """Adicionar novo produto"""
    try:
        nome = request.form['nome']
        descricao = request.form['descricao']
        validade = request.form['validade'] or None
        unidade = request.form['unidade']
        estoque_minimo = int(request.form['estoque_minimo'])
        estoque_atual = int(request.form['estoque_atual'])
        
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute(
                """INSERT INTO produtos (nome, descricao, validade, unidade, estoque_minimo, estoque_atual) 
                   VALUES (%s, %s, %s, %s, %s, %s)""",
                (nome, descricao, validade, unidade, estoque_minimo, estoque_atual)
            )
            conn.commit()
            conn.close()
            flash('Produto adicionado com sucesso!', 'success')
    except Exception as e:
        flash(f'Erro ao adicionar produto: {str(e)}', 'error')
    
    return redirect(url_for('produtos'))

@app.route('/api/movimentacao', methods=['POST'])
@login_required
def add_movimentacao():
    """Adicionar movimentação de estoque"""
    try:
        produto_id = int(request.form['produto_id'])
        tipo = request.form['tipo']
        quantidade = int(request.form['quantidade'])
        data = request.form['data'] or datetime.now()
        
        conn = get_db_connection()
        if conn:
            cursor = conn.cursor()
            
            # Registrar a movimentação
            cursor.execute(
                """INSERT INTO movimentacoes (produto_id, usuario_id, tipo, quantidade, data) 
                   VALUES (%s, %s, %s, %s, %s)""",
                (produto_id, current_user.id, tipo, quantidade, data)
            )
            
            # Atualizar estoque atual
            if tipo == 'entrada':
                cursor.execute(
                    "UPDATE produtos SET estoque_atual = estoque_atual + %s WHERE id = %s",
                    (quantidade, produto_id)
                )
            else:  # saída
                cursor.execute(
                    "UPDATE produtos SET estoque_atual = estoque_atual - %s WHERE id = %s",
                    (quantidade, produto_id)
                )
            
            conn.commit()
            conn.close()
            flash(f'Movimentação de {tipo} registrada com sucesso!', 'success')
    except Exception as e:
        flash(f'Erro ao registrar movimentação: {str(e)}', 'error')
    
    return redirect(url_for('estoque'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)