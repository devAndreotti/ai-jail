# ai-jail/Dockerfile
# Imagem de fallback Docker para agentes de IA em Windows.
# Para isolamento mais forte, prefira WSL2 + ai-jail oficial do Akita.

FROM ubuntu:24.04

LABEL maintainer="devAndreotti"
LABEL description="AI Jail - Sandbox Docker para agentes de IA"
LABEL version="2.3"
LABEL ai-jail.mode="docker-fallback"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    python3 \
    python3-pip \
    python3-venv \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p -m 755 /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/keyrings/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code@latest @openai/codex@latest opencode-ai@latest

RUN useradd -m -s /bin/bash devuser \
    && mkdir -p \
        /home/devuser/.codex \
        /home/devuser/.cache \
        /home/devuser/.config \
        /home/devuser/.local/share \
        /home/devuser/.local/share-linux \
        /home/devuser/.antigravity \
        /workspace \
    && chown -R devuser:devuser /home/devuser /workspace
USER devuser
WORKDIR /workspace

ENV PATH="/home/devuser/.local/bin:${PATH}"
ENV XDG_DATA_HOME="/home/devuser/.local/share-linux"
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TERM=xterm-256color
ENV PS1="(jail-docker) \\w \\$ "

RUN curl -fsSL https://antigravity.google/cli/install.sh | bash \
    && (command -v agy || command -v antigravity)

RUN gh extension install github/gh-copilot || true

USER root
RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'set -e' \
    '' \
    'mkdir -p \' \
    '    /home/devuser/.codex \' \
    '    /home/devuser/.cache \' \
    '    /home/devuser/.config \' \
    '    /home/devuser/.local/share \' \
    '    /home/devuser/.antigravity' \
    '' \
    'chown -R devuser:devuser /home/devuser/.codex 2>/dev/null || true' \
    '' \
    'if [ -d /tmp/codex-mount ]; then' \
    '    cp -rf /tmp/codex-mount/. /home/devuser/.codex/' \
    '    chown -R devuser:devuser /home/devuser/.codex 2>/dev/null || true' \
    'fi' \
    '' \
    'if [ "$#" -eq 0 ]; then' \
    '    set -- bash' \
    'fi' \
    '' \
    'export HOME=/home/devuser' \
    'export USER=devuser' \
    'export LOGNAME=devuser' \
    '' \
    'exec setpriv --reuid=devuser --regid=devuser --init-groups "$@"' \
    > /usr/local/bin/ai-jail-entrypoint \
    && chmod +x /usr/local/bin/ai-jail-entrypoint

ENTRYPOINT ["ai-jail-entrypoint"]

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD node --version && claude --version && codex --version && (agy --version || antigravity --version) || exit 1

# Dotfiles sensiveis nao devem ser montados manualmente:
#   ~/.gnupg
#   ~/.aws
#   ~/.ssh
#   ~/.mozilla
#   ~/.sparrow
#
# O launcher 12-AI-Jail.ps1 ja bloqueia esses caminhos.

CMD ["bash"]
