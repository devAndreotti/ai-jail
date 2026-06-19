<#
.SYNOPSIS
AI Jail Setup.

.DESCRIPTION
Prepara o ambiente AI Jail oficial no WSL para executar agentes de IA em sandbox.

# ID: scriply-ia-ai-jail-wsl-install
# Nome: AI Jail Setup
# Resumo: Instala ou valida o AI Jail no WSL.
# Descricao: Script de bootstrap do AI Jail oficial no WSL. Fica oculto no catalogo para evitar duplicidade com o launcher principal.
# Categoria: ia
# MostrarNoApp: false
# Admin: false
# Versao: 1.2.0
# Logs: $env:ProgramData\Scriply\Logs\AI-Jail
# Params:
#>
#Requires -Version 5.1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$Script:RepoRoot = Split-Path -Parent $PSScriptRoot
$Script:PathsHelper = Join-Path $Script:RepoRoot 'config\Scriply.Paths.ps1'
if (Test-Path -LiteralPath $Script:PathsHelper) {
    . $Script:PathsHelper
}

$LogDir = Join-ScriplyLogPath "AI-Jail"
$LogFile = Join-Path $LogDir ("install_" + (Get-Date -Format "yyyy-MM-dd_HH-mm-ss") + ".log")
$AiJailTargetVersion = if ($env:AI_JAIL_VERSION) { $env:AI_JAIL_VERSION } else { '1.2.1' }
$TotalSteps = 8

function Ensure-LogDirectory {
    if (-not (Test-Path -LiteralPath $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
    }
}

function Write-Log {
    param([string]$Message)
    Ensure-LogDirectory
    Add-Content -LiteralPath $LogFile -Value $Message -ErrorAction SilentlyContinue
}

function Write-Step {
    param([int]$Num, [string]$Desc)
    Write-Host ""
    Write-Host ("  [{0}/{1}] {2}" -f $Num, $TotalSteps, $Desc) -ForegroundColor Magenta
    $ts = Get-Date -Format "HH-mm-ss"
    Write-Log "[$ts] Step ${Num} - $Desc"
}

function Write-Ok {
    param([string]$Msg)
    Write-Host "  [OK] $Msg" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Msg)
    Write-Host "  [ERRO] $Msg" -ForegroundColor Red
}

function Write-Info {
    param([string]$Msg)
    Write-Host "  [..] $Msg" -ForegroundColor DarkGray
}

Ensure-LogDirectory

Write-Host ""
Write-Host "  +------------------------------------------------------------+" -ForegroundColor DarkMagenta
Write-Host "  |         Instalador ai-jail (Akita) via WSL2               |" -ForegroundColor Yellow
Write-Host "  +------------------------------------------------------------+" -ForegroundColor DarkMagenta
Write-Host ""
Write-Info "Fonte: https://github.com/akitaonrails/ai-jail"

Write-Step -Num 1 -Desc "Verificando WSL2..."

try {
    $null = Get-Command wsl -ErrorAction Stop
    $null = wsl --status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "WSL2 nao encontrado. Execute: wsl --install"
        exit 1
    }
    Write-Ok "WSL2 ativo"
} catch {
    Write-Fail "WSL2 nao disponivel. Execute: wsl --install"
    exit 1
}

$distros = wsl -l -q 2>$null
$defaultDistro = ($distros | Where-Object { $_ -and $_.Trim() } | Select-Object -First 1)
if ($defaultDistro) {
    $defaultDistro = ($defaultDistro.Trim() -replace [char]0, '')
}

if (-not $defaultDistro) {
    Write-Fail "Nenhuma distro WSL instalada. Execute: wsl --install"
    exit 1
}

Write-Ok "Distro padrao: $defaultDistro"

Write-Step -Num 2 -Desc "Instalando bubblewrap (dependencia)..."

wsl -- which bwrap 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Ok "bubblewrap ja instalado"
} else {
    Write-Info "Executando: sudo apt update && sudo apt install -y bubblewrap"
    wsl -- bash -c "sudo apt update && sudo apt install -y bubblewrap"
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Falha ao instalar bubblewrap"
        exit 1
    }
    Write-Ok "bubblewrap instalado"
}

$apparmorUserNs = (wsl -- bash -lc "cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns 2>/dev/null || true" 2>$null)
if ($apparmorUserNs -eq '1') {
    Write-Info "Ubuntu/Debian restringe user namespaces; se bwrap falhar, aplique o perfil AppArmor do README oficial."
}

Write-Step -Num 3 -Desc "Verificando Rust toolchain..."

wsl -- bash -lc "source ~/.cargo/env 2>/dev/null; command -v cargo" 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    $rustVersion = (wsl -- bash -lc "source ~/.cargo/env 2>/dev/null; cargo --version" 2>$null)
    Write-Ok "Rust ja instalado ($rustVersion)"
} else {
    Write-Info "Instalando Rust via rustup..."
    wsl -- bash -c "curl --proto =https --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Falha ao instalar Rust"
        exit 1
    }
    Write-Ok "Rust instalado"
}

Write-Step -Num 4 -Desc "Instalando ai-jail via cargo..."

wsl -- bash -c "source ~/.cargo/env 2>/dev/null; which ai-jail" 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    $jailVersion = (wsl -- bash -c "source ~/.cargo/env 2>/dev/null; ai-jail --version" 2>$null)
    Write-Ok "ai-jail ja instalado ($jailVersion)"

    if ($jailVersion -notlike "* $AiJailTargetVersion") {
        Write-Info "Atualizando ai-jail para a versao $AiJailTargetVersion..."
        wsl -- bash -lc "source ~/.cargo/env; cargo install ai-jail --locked --force --version $AiJailTargetVersion"
        if ($LASTEXITCODE -ne 0) {
            Write-Fail "Falha ao atualizar ai-jail para $AiJailTargetVersion"
            exit 1
        }
    } else {
        Write-Info "Versao alvo ja instalada: $AiJailTargetVersion"
    }
} else {
    Write-Info "Executando: cargo install ai-jail --locked --version $AiJailTargetVersion"
    Write-Info "(pode levar 2-5 minutos para compilar)"
    wsl -- bash -lc "source ~/.cargo/env; cargo install ai-jail --locked --version $AiJailTargetVersion"
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Falha ao instalar ai-jail"
        exit 1
    }
    Write-Ok "ai-jail instalado"
}

Write-Step -Num 5 -Desc "Verificando instalacao..."

$version = (wsl -- bash -c "source ~/.cargo/env 2>/dev/null; ai-jail --version" 2>$null)
if ($LASTEXITCODE -eq 0) {
    Write-Ok "ai-jail funcionando: $version"
} else {
    Write-Fail "ai-jail instalado mas nao encontrado no PATH"
    Write-Host '  Adicione ao .bashrc: export PATH="$HOME/.cargo/bin:$PATH"' -ForegroundColor Yellow
    exit 1
}

Write-Step -Num 6 -Desc "Preparando PATH e prefix global dos agentes..."

$profileBootstrap = @(
    'mkdir -p "$HOME/.npm-global" "$HOME/.npm-global/bin" "$HOME/.claude" "$HOME/.codex" "$HOME/.gemini" "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.antigravity"'
    'touch "$HOME/.claude.json"'
    'npm config --location=user set prefix "$HOME/.npm-global"'
) -join '; '

wsl -- bash -lc $profileBootstrap
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Falha ao preparar prefix global do npm para os agentes"
    exit 1
}

$configuredPrefix = (wsl -- bash -lc "npm config get prefix" 2>$null)
if ($LASTEXITCODE -eq 0 -and $configuredPrefix) {
    Write-Ok "npm global configurado em: $configuredPrefix"
} else {
    Write-Fail "Nao foi possivel confirmar o prefix global do npm"
    exit 1
}

Write-Step -Num 7 -Desc "Preparando perfis isolados do AI Jail..."

$isolatedProfileBootstrap = @(
    'set -e'
    'mkdir -p "$HOME/.scriply/ai-jail/profiles/default/.codex" "$HOME/.scriply/ai-jail/context/default"'
    'chmod 700 "$HOME/.scriply" "$HOME/.scriply/ai-jail" "$HOME/.scriply/ai-jail/profiles" "$HOME/.scriply/ai-jail/profiles/default" 2>/dev/null || true'
) -join '; '

wsl -- bash -lc $isolatedProfileBootstrap
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Falha ao preparar perfil isolado default do AI Jail"
    exit 1
}

Write-Ok "Perfil isolado default preparado em ~/.scriply/ai-jail/profiles/default"

Write-Step -Num 8 -Desc "Atualizando agentes CLI..."

$agentBootstrap = @(
    'set -e'
    'export NPM_CONFIG_PREFIX="$HOME/.npm-global"'
    'export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"'
    'if ! command -v gh >/dev/null 2>&1; then sudo mkdir -p -m 755 /etc/apt/keyrings; wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null; sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg; echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/keyrings/github-cli.list > /dev/null; sudo apt-get update && sudo apt-get install -y gh; fi'
    'if gh auth status >/dev/null 2>&1; then if gh extension list 2>/dev/null | grep -q "gh-copilot"; then gh extension upgrade github/gh-copilot; else gh extension install github/gh-copilot; fi; else echo "GitHub CLI sem autenticacao; pulando gh-copilot" >&2; fi'
    'npm install -g @anthropic-ai/claude-code@latest @openai/codex@latest opencode-ai@latest'
    'curl -fsSL https://antigravity.google/cli/install.sh | bash'
    'command -v claude >/dev/null'
    'command -v codex >/dev/null'
    'command -v opencode >/dev/null'
    'if ! command -v agy >/dev/null && ! command -v antigravity >/dev/null; then echo "Antigravity CLI nao encontrado no PATH" >&2; exit 1; fi'
    'claude --version || true'
    'codex --version || true'
    'opencode --version || true'
    'gh copilot --version || true'
    '(agy --version || antigravity --version || true)'
) -join '; '

wsl -- bash -lc $agentBootstrap
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Falha ao instalar/validar Claude, Codex ou Antigravity CLI"
    exit 1
}

Write-Ok "Agentes CLI atualizados"

Write-Host ""
Write-Host "  +--------------------------------------+" -ForegroundColor DarkMagenta
Write-Host "  | Instalacao concluida!                |" -ForegroundColor Green
Write-Host "  +--------------------------------------+" -ForegroundColor DarkMagenta
Write-Host ""
Write-Host "  Uso rapido:" -ForegroundColor Magenta
Write-Host "    .\12-AI-Jail.ps1 claude        -> Akita jail + Claude Code" -ForegroundColor White
Write-Host "    .\12-AI-Jail.ps1 agy           -> Akita jail + Antigravity CLI" -ForegroundColor White
Write-Host "    .\12-AI-Jail.ps1 --agent-profile dev codex -> Login Codex isolado do perfil dev" -ForegroundColor White
Write-Host "    .\12-AI-Jail.ps1 --host-agent-login codex  -> Reutiliza login Codex do host" -ForegroundColor White
Write-Host "    .\12-AI-Jail.ps1 --lockdown    -> Modo lockdown (read-only)" -ForegroundColor White
Write-Host "    .\12-AI-Jail.ps1 --dry-run     -> Mostra config sem executar" -ForegroundColor White
Write-Host "  Padrao: login do agente fica isolado; skills/plugins continuam sincronizados." -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Direto no WSL:" -ForegroundColor Magenta
Write-Host "    wsl -- ai-jail claude          -> Rodar direto no WSL" -ForegroundColor White
Write-Host "    wsl -- ai-jail agy             -> Rodar Antigravity no WSL" -ForegroundColor White
Write-Host "    wsl -- ai-jail --lockdown bash -> Lockdown + bash" -ForegroundColor White
Write-Host ""

$ts = Get-Date -Format "HH-mm-ss"
Write-Log "[$ts] Instalacao concluida: $version"
