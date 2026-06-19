#!/usr/bin/env bash
set -e

# Instalar gh
if ! command -v gh >/dev/null 2>&1; then
    echo "Instalando GitHub CLI no WSL..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/keyrings/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
fi

# Instalar extensão gh-copilot
echo "Configurando extensao Copilot no WSL..."
export HOME=/root
if gh auth status >/dev/null 2>&1; then
    if gh extension list 2>/dev/null | grep -q "gh-copilot"; then
        gh extension upgrade github/gh-copilot
    else
        gh extension install github/gh-copilot
    fi
else
    echo "GitHub CLI sem autenticacao; pulando gh-copilot"
fi

echo "GitHub CLI e Copilot instalados com sucesso no WSL!"
