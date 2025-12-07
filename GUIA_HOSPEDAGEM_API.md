# 🚀 Guia: Hospedar API do Launcher com Nginx

Este guia mostra como hospedar a API do launcher em um servidor dedicado usando nginx como reverse proxy.

## 📋 Pré-requisitos

- Servidor Linux (Ubuntu/Debian recomendado)
- Acesso root ou sudo
- Domínio apontando para o servidor (ex: `api.seudominio.com`)
- Nginx instalado

---

## 🔧 Passo 1: Instalar Node.js no Servidor

### Ubuntu/Debian:

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar instalação
node --version
npm --version
```

### CentOS/RHEL:

```bash
# Instalar Node.js 20.x
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs

# Verificar instalação
node --version
npm --version
```

---

## 📦 Passo 2: Instalar PM2 (Gerenciador de Processos)

PM2 mantém a API rodando mesmo após reinicializações:

```bash
# Instalar PM2 globalmente
sudo npm install -g pm2

# Configurar PM2 para iniciar no boot
pm2 startup
# Execute o comando que aparecer (algo como: sudo env PATH=...)
```

---

## 📤 Passo 3: Enviar a API para o Servidor

### Opção A: Via Git (Recomendado)

```bash
# No servidor, criar pasta para a API
cd /var/www
sudo mkdir -p ot-launcher-api
sudo chown $USER:$USER ot-launcher-api

# Clonar o repositório (ou fazer upload dos arquivos)
cd ot-launcher-api
git clone https://github.com/Oen44/ot-launcher-api.git .
# OU fazer upload via SCP/SFTP dos arquivos da pasta ot-launcher-api
```

### Opção B: Via SCP (Upload Manual)

No seu computador local:

```bash
scp -r ot-launcher-api/ usuario@servidor:/var/www/ot-launcher-api/
```

---

## ⚙️ Passo 4: Configurar a API

```bash
# Entrar na pasta da API
cd /var/www/ot-launcher-api

# Instalar dependências
npm install

# Criar arquivo .env
nano .env
```

Adicione no arquivo `.env`:

```env
PORT=3000
DISCORD_BOT_TOKEN=seu_token_do_bot_aqui
DISCORD_GUILD_ID=seu_guild_id_aqui
DISCORD_CHANNEL_ID=seu_channel_id_aqui
DISCORD_FETCH_LIMIT=10
CACHE_TTL=30
```

Salve e saia (Ctrl+X, Y, Enter)

---

## 🚀 Passo 5: Iniciar a API com PM2

```bash
# Iniciar a API
pm2 start index.js --name "ot-launcher-api"

# Verificar se está rodando
pm2 status

# Ver logs
pm2 logs ot-launcher-api

# Salvar configuração do PM2
pm2 save
```

A API agora está rodando em `http://localhost:3000`

---

## 🌐 Passo 6: Configurar Nginx como Reverse Proxy

### Criar configuração do Nginx:

```bash
sudo nano /etc/nginx/sites-available/ot-launcher-api
```

Adicione o seguinte conteúdo:

```nginx
server {
    listen 80;
    server_name api.seudominio.com;  # Substitua pelo seu domínio

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

**Importante:** Substitua `api.seudominio.com` pelo seu domínio real!

### Ativar o site:

```bash
# Criar link simbólico
sudo ln -s /etc/nginx/sites-available/ot-launcher-api /etc/nginx/sites-enabled/

# Testar configuração do nginx
sudo nginx -t

# Se tudo estiver OK, recarregar nginx
sudo systemctl reload nginx
```

---

## 🔒 Passo 7: Configurar SSL/HTTPS (Opcional mas Recomendado)

### Usando Certbot (Let's Encrypt - Gratuito):

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obter certificado SSL
sudo certbot --nginx -d api.seudominio.com

# Seguir as instruções na tela
# Certbot vai modificar automaticamente o arquivo do nginx
```

O Certbot vai:
1. Obter o certificado SSL
2. Configurar renovação automática
3. Atualizar a configuração do nginx para usar HTTPS

---

## ✅ Passo 8: Verificar se Está Funcionando

### Testar localmente no servidor:

```bash
curl http://localhost:3000/launcher/news
```

Deve retornar um JSON com as notícias.

### Testar via domínio:

No navegador ou terminal:

```bash
curl https://api.seudominio.com/launcher/news
```

Deve retornar o mesmo JSON.

---

## 🔧 Comandos Úteis do PM2

```bash
# Ver status de todas as aplicações
pm2 status

# Ver logs em tempo real
pm2 logs ot-launcher-api

# Parar a API
pm2 stop ot-launcher-api

# Reiniciar a API
pm2 restart ot-launcher-api

# Ver informações detalhadas
pm2 show ot-launcher-api

# Ver uso de recursos
pm2 monit
```

---

## 🔄 Atualizar a API

Quando precisar atualizar a API:

```bash
cd /var/www/ot-launcher-api

# Se usar Git:
git pull

# Instalar novas dependências (se houver)
npm install

# Reiniciar a API
pm2 restart ot-launcher-api
```

---

## 🐛 Resolução de Problemas

### API não responde:

1. **Verificar se está rodando:**
   ```bash
   pm2 status
   ```

2. **Ver logs de erro:**
   ```bash
   pm2 logs ot-launcher-api --err
   ```

3. **Verificar porta:**
   ```bash
   sudo netstat -tlnp | grep 3000
   ```

### Nginx não funciona:

1. **Verificar configuração:**
   ```bash
   sudo nginx -t
   ```

2. **Ver logs do nginx:**
   ```bash
   sudo tail -f /var/log/nginx/error.log
   ```

3. **Verificar se nginx está rodando:**
   ```bash
   sudo systemctl status nginx
   ```

### Erro 502 Bad Gateway:

- A API não está rodando ou não está na porta 3000
- Verifique: `pm2 status` e `pm2 logs ot-launcher-api`

### Erro 404 Not Found:

- Verifique se o `proxy_pass` no nginx está correto
- Verifique se a API está respondendo em `http://localhost:3000`

---

## 📝 Configuração Final no Launcher

No arquivo `launcher-config.json` do launcher, use:

```json
{
  "API_URL": "https://api.seudominio.com"
}
```

**Importante:** Use `https://` se configurou SSL, ou `http://` se não configurou.

---

## 🔐 Segurança Adicional (Opcional)

### Firewall (UFW):

```bash
# Permitir apenas portas necessárias
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

### Limitar acesso por IP (se necessário):

No nginx, adicione:

```nginx
location / {
    allow 192.168.1.0/24;  # Permitir apenas IPs específicos
    deny all;
    
    proxy_pass http://localhost:3000;
    # ... resto da configuração
}
```

---

## ✅ Checklist Final

- [ ] Node.js instalado
- [ ] PM2 instalado e configurado
- [ ] API instalada e configurada
- [ ] Arquivo `.env` criado com todas as variáveis
- [ ] API rodando com PM2
- [ ] Nginx configurado como reverse proxy
- [ ] Domínio apontando para o servidor
- [ ] SSL configurado (opcional mas recomendado)
- [ ] API respondendo via domínio
- [ ] `launcher-config.json` atualizado com a URL da API

---

## 🎉 Pronto!

Sua API está hospedada e acessível via `https://api.seudominio.com/launcher/news`

O launcher agora pode buscar as notícias do Discord através da sua API hospedada!

