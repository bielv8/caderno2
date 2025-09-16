// Sistema de Gestão de Estoque - Scripts JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

    // Confirmar exclusão de produtos
    const deleteButtons = document.querySelectorAll('.btn-outline-danger');
    deleteButtons.forEach(button => {
        if (button.textContent.trim() === 'Excluir') {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                if (confirm('Tem certeza que deseja excluir este produto?')) {
                    // Aqui você adicionaria a lógica de exclusão
                    alert('Funcionalidade de exclusão será implementada.');
                }
            });
        }
    });

    // Validação de formulários
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
});

// Função para formatar números
function formatNumber(num) {
    return new Intl.NumberFormat('pt-BR').format(num);
}

// Função para validar quantidade antes de enviar movimentação
function validarMovimentacao(tipo, quantidade, estoqueAtual) {
    if (tipo === 'saida' && quantidade > estoqueAtual) {
        alert('A quantidade de saída não pode ser maior que o estoque atual!');
        return false;
    }
    return true;
}