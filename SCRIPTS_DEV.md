# 🛠️ Scripts de Desenvolvimento

Scripts criados para facilitar o desenvolvimento do launcher.

## 📋 Scripts Disponíveis

### Windows (.cmd)

#### `dev-with-devtools.cmd`
Abre o launcher em modo desenvolvimento **COM DevTools** habilitado.
- Útil para debugar e ver erros no console
- Use quando estiver desenvolvendo ou corrigindo bugs

**Como usar:**
- Clique duas vezes no arquivo `dev-with-devtools.cmd`
- Ou execute no terminal: `dev-with-devtools.cmd`

#### `dev-without-devtools.cmd`
Abre o launcher em modo desenvolvimento **SEM DevTools**.
- Simula como ficará a versão final compilada
- Útil para ver como o launcher aparecerá para os usuários

**Como usar:**
- Clique duas vezes no arquivo `dev-without-devtools.cmd`
- Ou execute no terminal: `dev-without-devtools.cmd`

### Linux/Mac (.sh)

#### `dev-with-devtools.sh`
Abre o launcher em modo desenvolvimento **COM DevTools** habilitado.

**Como usar:**
```bash
chmod +x dev-with-devtools.sh
./dev-with-devtools.sh
```

#### `dev-without-devtools.sh`
Abre o launcher em modo desenvolvimento **SEM DevTools**.

**Como usar:**
```bash
chmod +x dev-without-devtools.sh
./dev-without-devtools.sh
```

## 🔧 Scripts NPM Alternativos

Você também pode usar diretamente os comandos npm:

```bash
# Com DevTools
npm run dev

# Sem DevTools (preview)
npm run dev:preview
```

## 💡 Dicas

- Use `dev-with-devtools.cmd` quando estiver desenvolvendo ou debugando
- Use `dev-without-devtools.cmd` para ver como ficará a versão final antes de compilar
- Os scripts são apenas atalhos para os comandos npm

