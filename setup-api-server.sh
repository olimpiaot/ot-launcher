#!/bin/bash

# Script de setup rápido para hospedar a API do Launcher
# Execute com: sudo bash setup-api-server.sh

echo "🚀 Configurando servidor para API do Launcher..."
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Por favor, execute com sudo"
    exit 1
fi

# Atualizar sistema
echo "📦 Atualizando sistema..."
apt update && apt upgrade -y

# Instalar Node.js 20.x
echo "📦 Instalando Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Verificar instalação
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
echo "✅ Node.js instalado: $NODE_VERSION"
echo "✅ NPM instalado: $NPM_VERSION"

# Instalar PM2
echo "📦 Instalando PM2..."
npm install -g pm2

# Criar diretório para a API
echo "📁 Criando diretório para a API..."
mkdir -p /var/www/ot-launcher-api
chown $SUDO_USER:$SUDO_USER /var/www/ot-launcher-api

echo ""
echo "✅ Setup básico concluído!"
echo ""
echo "📝 Próximos passos:"
echo "1. Faça upload dos arquivos da API para: /var/www/ot-launcher-api"
echo "2. Execute: cd /var/www/ot-launcher-api && npm install"
echo "3. Crie o arquivo .env com as configurações"
echo "4. Execute: pm2 start index.js --name ot-launcher-api"
echo "5. Execute: pm2 save"
echo "6. Configure o nginx (veja GUIA_HOSPEDAGEM_API.md)"
echo ""

