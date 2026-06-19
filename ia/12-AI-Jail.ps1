<#
.SYNOPSIS
AI Jail.

.DESCRIPTION
Abre Codex, Claude, Antigravity ou shell no AI Jail com opcoes de lockdown, Docker fallback e dry-run.

# ID: scriply-ia-ai-jail-launcher
# Nome: AI Jail
# Resumo: Executa agentes de IA em sandbox.
# Descricao: Abre Codex, Claude, Antigravity ou shell no AI Jail com opcoes de lockdown, Docker fallback e dry-run.
# Categoria: ia
# MostrarNoApp: true
# Admin: false
# Versao: 1.2.1
# Logs: $env:ProgramData\Scriply\Logs\AI-Jail
# Params: --docker, --lockdown, --no-lockdown, --dry-run, --memory, --cpus, --display, --no-display, --no-docker, --status-bar, --no-status-bar, --clean, --init, --bootstrap, --gpu, --no-gpu, --verbose, --landlock, --no-landlock, --seccomp, --no-seccomp, --rlimits, --no-rlimits, --mise, --no-mise, --worktree, --no-worktree, --private-home, --no-private-home, --sync-agent-context, --no-sync-agent-context, --agent-profile, --host-agent-login, --no-host-agent-login, --save-config, --no-save-config, --hide-config, --no-hide-config, --ssh, --no-ssh, --pictures, --no-pictures, --browser, --no-browser, --exec, --mask, --hide-dotdir, --claude-dir, --allow-tcp-port, --map, --rw-map, comando
# ParamMeta: --docker | Docker Fallback | Forca o modo Docker em vez do AI Jail no WSL.
# ParamMeta: --lockdown | Lockdown | Executa sem rede e com escrita restrita.
# ParamMeta: --no-lockdown | Sem Lockdown | Desativa o lockdown quando suportado.
# ParamMeta: --dry-run | Simulacao | Mostra o comando final sem iniciar a sessao.
# ParamMeta: --memory | Memoria | Define o limite de memoria usado no fallback Docker.
# ParamMeta: --cpus | CPUs | Define a quantidade de CPUs usada no fallback Docker.
# ParamMeta: --display | Com Display | Mantem recursos de display habilitados.
# ParamMeta: --no-display | Sem Display | Executa sem integrar recursos de display.
# ParamMeta: --no-docker | Sem Docker | Desativa o socket Docker no modo WSL.
# ParamMeta: --status-bar | Barra de Status | Exibe a barra de status do AI Jail.
# ParamMeta: --no-status-bar | Sem Barra de Status | Oculta a barra de status do AI Jail.
# ParamMeta: --clean | Limpo | Inicia com ambiente limpo quando suportado.
# ParamMeta: --init | Init | Inicializa a configuracao padrao do AI Jail.
# ParamMeta: --bootstrap | Bootstrap | Faz o bootstrap inicial do ambiente AI Jail.
# ParamMeta: --gpu | GPU | Habilita acesso a GPU quando suportado.
# ParamMeta: --no-gpu | Sem GPU | Desabilita acesso a GPU no AI Jail.
# ParamMeta: --verbose | Verbose | Mostra logs detalhados da execucao.
# ParamMeta: --landlock | Landlock | Forca o uso de Landlock no sandbox.
# ParamMeta: --no-landlock | Sem Landlock | Desativa Landlock quando suportado.
# ParamMeta: --seccomp | Seccomp | Habilita filtro de syscalls quando suportado.
# ParamMeta: --no-seccomp | Sem Seccomp | Desativa o filtro de syscalls quando suportado.
# ParamMeta: --rlimits | RLimits | Habilita limites de recursos quando suportado.
# ParamMeta: --no-rlimits | Sem RLimits | Desativa limites de recursos quando suportado.
# ParamMeta: --mise | Mise | Habilita integracao com Mise no ambiente.
# ParamMeta: --no-mise | Sem Mise | Desabilita integracao com Mise.
# ParamMeta: --worktree | Worktree | Habilita passthrough seguro de metadados Git worktree.
# ParamMeta: --no-worktree | Sem Worktree | Desabilita passthrough de metadados Git worktree.
# ParamMeta: --private-home | Home Privado | Nao monta dotdirs normais do host.
# ParamMeta: --no-private-home | Sem Home Privado | Desativa private-home quando suportado.
# ParamMeta: --sync-agent-context | Sync Agente | Sincroniza skills/plugins locais para o jail quando seguro.
# ParamMeta: --no-sync-agent-context | Sem Sync Agente | Desativa sincronizacao automatica de skills/plugins.
# ParamMeta: --agent-profile | Perfil Agente | Usa perfil persistente isolado para login do agente.
# ParamMeta: --host-agent-login | Login Host | Opt-in para copiar/montar login do agente do host.
# ParamMeta: --no-host-agent-login | Sem Login Host | Mantem login do agente isolado do host.
# ParamMeta: --save-config | Salvar Config | Permite salvar .ai-jail.
# ParamMeta: --no-save-config | Sem Salvar Config | Evita criar ou atualizar .ai-jail.
# ParamMeta: --hide-config | Ocultar Config | Oculta .ai-jail dentro do sandbox.
# ParamMeta: --no-hide-config | Mostrar Config | Mantem .ai-jail visivel dentro do sandbox.
# ParamMeta: --ssh | SSH | Compartilha SSH de forma explicita quando suportado.
# ParamMeta: --no-ssh | Sem SSH | Desabilita compartilhamento SSH.
# ParamMeta: --pictures | Imagens | Compartilha Pictures em leitura quando suportado.
# ParamMeta: --no-pictures | Sem Imagens | Desabilita compartilhamento Pictures.
# ParamMeta: --browser | Browser | Habilita perfil isolado de navegador.
# ParamMeta: --no-browser | Sem Browser | Desabilita perfil isolado de navegador.
# ParamMeta: --exec | Exec | Executa sem proxy TTY/status bar.
# ParamMeta: --mask | Mascara | Oculta arquivo/pasta do projeto dentro do sandbox.
# ParamMeta: --hide-dotdir | Ocultar Dotdir | Nao monta dotdir especifico do HOME.
# ParamMeta: --claude-dir | Claude Dir | Usa diretorio de configuracao separado para Claude.
# ParamMeta: --allow-tcp-port | TCP Lockdown | Permite porta TCP especifica no lockdown.
# ParamMeta: --map | Mapear Leitura | Repassa um mapeamento de caminho para o ai-jail.
# ParamMeta: --rw-map | Mapear Escrita | Repassa um mapeamento gravavel para o ai-jail.
# ParamMeta: comando | Comando | Define o comando executado dentro do AI Jail; se omitido, abre bash.
#>
#Requires -Version 5.1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$Script:RepoRoot = Split-Path -Parent $PSScriptRoot
$Script:PathsHelper = Join-Path $Script:RepoRoot 'config\Scriply.Paths.ps1'
$Script:UiHelper = Join-Path $Script:RepoRoot 'config\Scriply.Ui.ps1'
if (Test-Path -LiteralPath $Script:PathsHelper) {
    . $Script:PathsHelper
}
if (Test-Path -LiteralPath $Script:UiHelper) {
    . $Script:UiHelper
}

$Docker = $false
$Lockdown = $false
$DryRun = $false
$Memory = "4g"
$Cpus = 2
$AiJailOptions = New-Object System.Collections.Generic.List[string]
$DockerPrivateHome = $false
$SyncAgentContext = $true
if ([string]::IsNullOrWhiteSpace($env:AI_JAIL_SYNC_AGENT_CONTEXT) -eq $false -and $env:AI_JAIL_SYNC_AGENT_CONTEXT -match '^(0|false|no)$') {
    $SyncAgentContext = $false
}
$AgentProfile = if ([string]::IsNullOrWhiteSpace($env:AI_JAIL_AGENT_PROFILE)) { "default" } else { [string]$env:AI_JAIL_AGENT_PROFILE }
$HostAgentLogin = $false
if (-not [string]::IsNullOrWhiteSpace($env:AI_JAIL_HOST_AGENT_LOGIN) -and $env:AI_JAIL_HOST_AGENT_LOGIN -match '^(1|true|yes|on)$') {
    $HostAgentLogin = $true
}
$parsedCommand = New-Object System.Collections.Generic.List[string]

function Test-DockerMemoryLimit {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    return ($Value -match '^[1-9][0-9]*(b|k|m|g)?$')
}

function Test-DockerCpuLimit {
    param([int]$Value)
    return ($Value -ge 1 -and $Value -le 64)
}

function Assert-AiJailTcpPort {
    param([string]$Value)

    $port = 0
    if (-not [int]::TryParse($Value, [ref]$port) -or $port -lt 1 -or $port -gt 65535) {
        Write-Error "Valor invalido para --allow-tcp-port: $Value"
        exit 1
    }
}

function Assert-AgentProfileName {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value) -or $Value -notmatch '^[A-Za-z0-9_.-]{1,64}$') {
        Write-Error "Valor invalido para --agent-profile: use letras, numeros, ponto, hifen ou underline."
        exit 1
    }
}

Assert-AgentProfileName -Value $AgentProfile

for ($i = 0; $i -lt $args.Count; $i++) {
    $currentArg = [string]$args[$i]

    switch -Regex ($currentArg) {
        "^--docker$|^-docker$" {
            $Docker = $true
            continue
        }
        "^--lockdown$|^-lockdown$" {
            $Lockdown = $true
            continue
        }
        "^--private-home$" {
            $DockerPrivateHome = $true
            $AiJailOptions.Add($currentArg)
            continue
        }
        "^--no-private-home$" {
            $DockerPrivateHome = $false
            $AiJailOptions.Add($currentArg)
            continue
        }
        "^--sync-agent-context$" {
            $SyncAgentContext = $true
            continue
        }
        "^--no-sync-agent-context$" {
            $SyncAgentContext = $false
            continue
        }
        "^--agent-profile=(.+)$" {
            Assert-AgentProfileName -Value $matches[1]
            $AgentProfile = $matches[1]
            continue
        }
        "^--agent-profile$" {
            if (($i + 1) -ge $args.Count) {
                Write-Error "Parametro $currentArg precisa de um valor."
                exit 1
            }

            $i++
            Assert-AgentProfileName -Value ([string]$args[$i])
            $AgentProfile = [string]$args[$i]
            continue
        }
        "^--host-agent-login$" {
            $HostAgentLogin = $true
            continue
        }
        "^--no-host-agent-login$" {
            $HostAgentLogin = $false
            continue
        }
        "^--no-lockdown$|^--display$|^--no-display$|^--gpu$|^--no-gpu$|^--no-status-bar$|^--clean$|^--init$|^--bootstrap$|^--verbose$|^--landlock$|^--no-landlock$|^--seccomp$|^--no-seccomp$|^--rlimits$|^--no-rlimits$|^--mise$|^--no-mise$|^--worktree$|^--no-worktree$|^--save-config$|^--no-save-config$|^--hide-config$|^--no-hide-config$|^--ssh$|^--no-ssh$|^--pictures$|^--no-pictures$|^--no-browser$|^--exec$|^--no-docker$" {
            $AiJailOptions.Add($currentArg)
            continue
        }
        "^(-s|--status-bar)(?:=(dark|light|pastel))?$" {
            if (($currentArg -eq '-s' -or $currentArg -eq '--status-bar') -and (($i + 1) -lt $args.Count) -and ([string]$args[$i + 1] -match '^(dark|light|pastel)$')) {
                $i++
                $AiJailOptions.Add(('--status-bar={0}' -f [string]$args[$i]))
            } else {
                $AiJailOptions.Add($currentArg)
            }

            continue
        }
        "^--browser=(hard|soft)$" {
            $AiJailOptions.Add($currentArg)
            continue
        }
        "^--browser$" {
            if (($i + 1) -lt $args.Count -and ([string]$args[$i + 1] -match '^(hard|soft)$')) {
                $AiJailOptions.Add(('--browser={0}' -f [string]$args[$i + 1]))
                $i++
            } else {
                $AiJailOptions.Add($currentArg)
            }

            continue
        }
        "^--allow-tcp-port=(.+)$" {
            Assert-AiJailTcpPort -Value $matches[1]
            $AiJailOptions.Add($currentArg)
            continue
        }
        "^--(?:rw-map|map|mask|hide-dotdir|claude-dir)=.+$" {
            $AiJailOptions.Add($currentArg)
            continue
        }
        "^--allow-tcp-port$" {
            if (($i + 1) -ge $args.Count) {
                Write-Error "Parametro $currentArg precisa de um valor."
                exit 1
            }

            $AiJailOptions.Add($currentArg)
            $i++
            $portCandidate = [string]$args[$i]
            Assert-AiJailTcpPort -Value $portCandidate
            $AiJailOptions.Add($portCandidate)
            continue
        }
        "^--(?:rw-map|map|mask|hide-dotdir|claude-dir)$" {
            if (($i + 1) -ge $args.Count) {
                Write-Error "Parametro $currentArg precisa de um valor."
                exit 1
            }

            $AiJailOptions.Add($currentArg)
            $i++
            $AiJailOptions.Add([string]$args[$i])
            continue
        }
        "^--dry-run$|^-dryrun$" {
            $DryRun = $true
            continue
        }
        "^--memory$|^-memory$" {
            if (($i + 1) -ge $args.Count) {
                Write-Error "Parametro $currentArg precisa de um valor."
                exit 1
            }

            $i++
            $memoryCandidate = [string]$args[$i]
            if (-not (Test-DockerMemoryLimit -Value $memoryCandidate)) {
                Write-Error "Valor invalido para memoria Docker: $memoryCandidate"
                exit 1
            }

            $Memory = $memoryCandidate
            continue
        }
        "^--cpus$|^-cpus$" {
            if (($i + 1) -ge $args.Count) {
                Write-Error "Parametro $currentArg precisa de um valor."
                exit 1
            }

            $i++
            $parsedCpuCount = 0
            if (-not [int]::TryParse([string]$args[$i], [ref]$parsedCpuCount)) {
                Write-Error "Valor invalido para CPUS: $($args[$i])"
                exit 1
            }

            if (-not (Test-DockerCpuLimit -Value $parsedCpuCount)) {
                Write-Error "Valor invalido para CPUS: $($args[$i])"
                exit 1
            }

            $Cpus = $parsedCpuCount
            continue
        }
        default {
            $parsedCommand.Add($currentArg)
        }
    }
}

$LogDir = Join-ScriplyLogPath "AI-Jail"
$DockerImage = "ai-jail-dev"
$ProjectDir = (Get-Location).Path
$SessionTimestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = Join-Path $LogDir "session_$SessionTimestamp.log"
$CommandArgs = @(
    @($parsedCommand) |
        Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } |
        ForEach-Object { [string]$_ }
)
if ($CommandArgs.Count -eq 0) {
    $CommandArgs = @("bash")
}

$AgentAliasWarning = $null
if ($CommandArgs.Count -gt 0) {
    switch ($CommandArgs[0].ToLowerInvariant()) {
        "gemini" {
            $CommandArgs[0] = "agy"
            $AgentAliasWarning = "Gemini CLI foi substituido pelo Antigravity CLI. Redirecionando para 'agy'."
        }
        "antigravity" {
            $CommandArgs[0] = "agy"
        }
        "copilot" {
            $restOfArgs = if ($CommandArgs.Count -gt 1) { $CommandArgs[1..($CommandArgs.Count - 1)] } else { @() }
            $CommandArgs = @("gh", "copilot") + $restOfArgs
        }
    }
}

$CommandLabel = $CommandArgs -join " "

$SensitiveDirs = @(".gnupg", ".aws", ".ssh", ".mozilla", ".sparrow", ".basilisk-dev")
$AllowedRWDirs = @(".claude", ".crush", ".aider", ".config", ".cargo", ".cache", ".docker", ".npm", ".npm-global", ".local\share", ".antigravity", ".opencode")
$CodexDockerVolumeBase = if ([string]::IsNullOrWhiteSpace($env:AI_JAIL_CODEX_DOCKER_VOLUME)) { "ai-jail-codex-home" } else { $env:AI_JAIL_CODEX_DOCKER_VOLUME }
$DockerTempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "Scriply\AI-Jail"
$DockerSessionTempDir = $null
$DefaultWslBootstrap = @(
    'mkdir -p "$HOME/.npm-global" "$HOME/.npm-global/bin" "$HOME/.claude" "$HOME/.codex" "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.antigravity" "$HOME/.opencode"',
    'touch "$HOME/.claude.json"',
    'export NPM_CONFIG_PREFIX="$HOME/.npm-global"',
    'export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"'
)
$DefaultWslRwMaps = @(
    '--rw-map "$HOME/.npm-global"',
    '--rw-map "$HOME/.local"',
    '--rw-map "$HOME/.antigravity"',
    '--rw-map "$HOME/.opencode"'
)

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $entry = "[{0}][{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Add-Content -Path $LogFile -Value $entry -ErrorAction SilentlyContinue
}

function Get-DockerSessionTempDir {
    if (-not [string]::IsNullOrWhiteSpace($Script:DockerSessionTempDir)) {
        return $Script:DockerSessionTempDir
    }

    $tempName = "{0}-{1}" -f $SessionTimestamp, ([System.Guid]::NewGuid().ToString("N"))
    $Script:DockerSessionTempDir = Join-Path $DockerTempRoot $tempName
    New-Item -ItemType Directory -Path $Script:DockerSessionTempDir -Force | Out-Null
    return $Script:DockerSessionTempDir
}

function Remove-DockerSessionTempDir {
    if ([string]::IsNullOrWhiteSpace($Script:DockerSessionTempDir)) {
        return
    }

    try {
        $resolvedTemp = (Resolve-Path -LiteralPath $Script:DockerSessionTempDir -ErrorAction Stop).Path
        $resolvedRoot = (Resolve-Path -LiteralPath $DockerTempRoot -ErrorAction Stop).Path
        $comparison = [System.StringComparison]::OrdinalIgnoreCase
        $insideTempRoot = $resolvedTemp.StartsWith($resolvedRoot.TrimEnd('\') + '\', $comparison)

        if ($insideTempRoot) {
            Remove-Item -LiteralPath $resolvedTemp -Recurse -Force -ErrorAction Stop
            Write-Log "Removed Docker session temp files."
        } else {
            Write-Log ("Skipped Docker temp cleanup outside expected root: {0}" -f $resolvedTemp) "WARN"
        }
    } catch {
        Write-Log ("Failed to remove Docker session temp files: {0}" -f $_.Exception.Message) "WARN"
    } finally {
        $Script:DockerSessionTempDir = $null
    }
}

function Get-AgentProfileDockerVolume {
    param([string]$ProfileName)

    if (-not [string]::IsNullOrWhiteSpace($env:AI_JAIL_CODEX_DOCKER_VOLUME)) {
        return $CodexDockerVolumeBase
    }

    return ("{0}-{1}" -f $CodexDockerVolumeBase, $ProfileName)
}

function Copy-DockerReadableTempFile {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$FileName
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        return $null
    }

    $targetPath = Join-Path (Get-DockerSessionTempDir) $FileName
    try {
        Copy-Item -LiteralPath $SourcePath -Destination $targetPath -Force -ErrorAction Stop
        return $targetPath
    } catch {
        Write-Log ("Failed to copy readable temp file {0}: {1}" -f $FileName, $_.Exception.Message) "WARN"
        return $null
    }
}

function Convert-CodexConfigForDockerJail {
    param(
        [Parameter(Mandatory = $true)][string]$Content
    )

    $lines = $Content -split "\r?\n"
    $blocks = New-Object System.Collections.Generic.List[object]
    $currentHeader = $null
    $currentLines = New-Object System.Collections.Generic.List[string]

    foreach ($line in $lines) {
        if ($line -match '^\s*\[([^\]]+)\]\s*(?:#.*)?$') {
            if ($currentLines.Count -gt 0) {
                $blocks.Add([pscustomobject]@{
                    Header = $currentHeader
                    Lines  = @($currentLines)
                })
                $currentLines = New-Object System.Collections.Generic.List[string]
            }

            $currentHeader = $matches[1]
        }

        $currentLines.Add($line)
    }

    if ($currentLines.Count -gt 0) {
        $blocks.Add([pscustomobject]@{
            Header = $currentHeader
            Lines  = @($currentLines)
        })
    }

    $removedMcpServers = New-Object System.Collections.Generic.List[string]

    # Passagem 1: Identificar nomes bases de servidores que devem ser removidos
    foreach ($block in $blocks) {
        $header = [string]$block.Header
        if ($header -like "mcp_servers.*") {
            $serverName = ($header -replace '^mcp_servers\.', '') -replace '\..*$', ''
            if ([string]::IsNullOrWhiteSpace($serverName)) {
                continue
            }

            $blockText = (($block.Lines | ForEach-Object { [string]$_ }) -join "`n")
            $shouldRemove = $false

            # Critérios de remoção
            if ($serverName -eq "node_repl" -or $serverName -eq "github-mcp-server") {
                $shouldRemove = $true
            } elseif ($blockText -match '(?i)([A-Z]:\\|\\\\|\.exe"|\.cmd"|\.bat")') {
                $shouldRemove = $true
            }

            if ($shouldRemove -and -not $removedMcpServers.Contains($serverName)) {
                $removedMcpServers.Add($serverName)
            }
        }
    }

    # Passagem 2: Filtrar todas as seções/subseções dos servidores identificados
    $keptLines = New-Object System.Collections.Generic.List[string]

    foreach ($block in $blocks) {
        $header = [string]$block.Header
        $keep = $true

        if ($header -like "mcp_servers.*") {
            $serverName = ($header -replace '^mcp_servers\.', '') -replace '\..*$', ''
            if (-not [string]::IsNullOrWhiteSpace($serverName) -and $removedMcpServers.Contains($serverName)) {
                $keep = $false
            }
        }

        if ($keep) {
            if ($header -like "projects.*") {
                if ($header -match "^projects\.(['""])(.+)\1$") {
                    $winPath = $matches[2]
                    $linuxPath = Convert-ToWslPath -Path $winPath
                    $quoteChar = $matches[1]
                    $newHeader = "projects." + $quoteChar + $linuxPath + $quoteChar
                    $block.Lines[0] = "[" + $newHeader + "]"
                }
            }

            foreach ($line in $block.Lines) {
                $keptLines.Add([string]$line)
            }
        }
    }

    if ($removedMcpServers.Count -gt 0) {
        Write-Log ("Filtered Docker-incompatible Codex MCP servers (including sub-sections): {0}" -f ($removedMcpServers -join ", ")) "WARN"
    }

    $prefix = @(
        "# Generated by Scriply AI Jail Docker fallback."
        "# Windows-only MCP servers and their sub-sections are removed before mounting into Linux."
        ""
    )

    return ($prefix + @($keptLines)) -join "`n"
}

function New-DockerJailCodexConfig {
    param([Parameter(Mandatory = $true)][string]$HostConfigPath)

    if (-not (Test-Path -LiteralPath $HostConfigPath)) {
        return $null
    }

    try {
        $hostConfig = [System.IO.File]::ReadAllText($HostConfigPath)
        $dockerConfig = Convert-CodexConfigForDockerJail -Content $hostConfig
        $mountDir = Join-Path (Get-DockerSessionTempDir) "codex-mount"
        if (-not (Test-Path -LiteralPath $mountDir)) {
            New-Item -ItemType Directory -Path $mountDir -Force | Out-Null
        }
        $targetPath = Join-Path $mountDir "config.toml"
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($targetPath, $dockerConfig, $utf8NoBom)
        Write-Log "Prepared Docker-safe Codex config."
        return $mountDir
    } catch {
        Write-Log ("Failed to prepare Docker-safe Codex config: {0}" -f $_.Exception.Message) "WARN"
        return $null
    }
}

function Convert-ToTomlString {
    param([string]$Value)

    if ($null -eq $Value) {
        $Value = ""
    }

    $escapedValue = $Value.Replace("\", "\\").Replace('"', '\"')
    return '"' + $escapedValue + '"'
}

function Get-AiJailDefaultConfigContent {
    param([string[]]$Command)

    $serializedCommand = ""
    if ($null -ne $Command -and $Command.Count -gt 0) {
        $serializedCommand = ($Command | ForEach-Object { Convert-ToTomlString -Value ([string]$_) }) -join ", "
    }

    return @(
        "# ai-jail sandbox configuration"
        "# https://github.com/akitaonrails/ai-jail"
        "# Edit freely. Regenerate with: ai-jail --clean --init"
        ""
        ("command = [{0}]" -f $serializedCommand)
        "rw_maps = []"
        "ro_maps = []"
        ""
    ) -join "`n"
}

function Test-AiJailConfigShouldPersist {
    param([System.Collections.Generic.List[string]]$Options)

    foreach ($token in $Options) {
        switch ([string]$token) {
            "--init" { return $true }
            "--bootstrap" { return $true }
            "--save-config" { return $true }
        }
    }

    return $false
}

function Test-AiJailOptionPresent {
    param(
        [System.Collections.Generic.List[string]]$Options,
        [string]$Name
    )

    foreach ($token in $Options) {
        if ([string]$token -eq $Name -or [string]$token -like "$Name=*") {
            return $true
        }
    }

    return $false
}

function Get-AiJailSshKeyMappings {
    param([string]$MountRoot)

    $rawMappings = [Environment]::GetEnvironmentVariable("AI_JAIL_SSH_KEY_MAP", "Process")
    if ([string]::IsNullOrWhiteSpace($rawMappings)) {
        return @()
    }

    $items = New-Object System.Collections.Generic.List[object]
    foreach ($entry in ($rawMappings -split ';')) {
        if ([string]::IsNullOrWhiteSpace($entry)) {
            continue
        }

        $parts = $entry -split '=', 2
        $hostPath = $parts[0].Trim()
        if ([string]::IsNullOrWhiteSpace($hostPath)) {
            continue
        }

        $name = if ($parts.Count -gt 1 -and -not [string]::IsNullOrWhiteSpace($parts[1])) {
            ($parts[1].Trim() -replace '[^A-Za-z0-9_.-]', '_')
        } else {
            ([System.IO.Path]::GetFileName($hostPath) -replace '[^A-Za-z0-9_.-]', '_')
        }

        if ([string]::IsNullOrWhiteSpace($name)) {
            $name = "ssh_key"
        }

        $items.Add([pscustomobject]@{
            Host      = $hostPath
            Container = ("{0}/{1}" -f $MountRoot.TrimEnd('/'), $name)
        })
    }

    return $items.ToArray()
}

function Add-AiJailOptionIfMissing {
    param(
        [System.Collections.Generic.List[string]]$Options,
        [string]$Name
    )

    if (-not (Test-AiJailOptionPresent -Options $Options -Name $Name)) {
        $Options.Add($Name)
    }
}

function Normalize-Content {
    param([string]$Value)

    if ($null -eq $Value) {
        return ""
    }

    return (($Value -replace "`r`n", "`n") -replace "`r", "`n").TrimEnd("`n")
}

function Remove-AutoGeneratedAiJailConfig {
    param(
        [string]$ConfigPath,
        [bool]$ConfigExistedBefore,
        [bool]$PreserveGeneratedConfig,
        [string]$ExpectedContent
    )

    if ($ConfigExistedBefore -or $PreserveGeneratedConfig -or [string]::IsNullOrWhiteSpace($ExpectedContent)) {
        return
    }

    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        return
    }

    try {
        $actualContent = [System.IO.File]::ReadAllText($ConfigPath)
    } catch {
        Write-Log ("Failed to read generated .ai-jail for cleanup: {0}" -f $_.Exception.Message) "WARN"
        return
    }

    if ((Normalize-Content -Value $actualContent) -ne (Normalize-Content -Value $ExpectedContent)) {
        Write-Log "Preserved .ai-jail because it differs from the auto-generated default."
        return
    }

    try {
        Remove-Item -LiteralPath $ConfigPath -Force
        Write-Log "Removed auto-generated .ai-jail created for this session."
    } catch {
        Write-Log ("Failed to remove generated .ai-jail: {0}" -f $_.Exception.Message) "WARN"
    }
}

function Quote-BashArg {
    param([string]$Value)

    if ([string]::IsNullOrEmpty($Value)) {
        return "''"
    }

    return "'" + ($Value -replace "'", "'""'""'") + "'"
}

function Convert-ToWslPath {
    param([string]$Path)

    if ($Path -match "^([A-Za-z]):(.*)$") {
        $driveLetter = $matches[1].ToLower()
        $restOfPath = ($matches[2] -replace "\\", "/")
        return "/mnt/$driveLetter$restOfPath"
    }

    return ($Path -replace "\\", "/")
}

function Get-AgentContextSources {
    $sources = @(
        [pscustomobject]@{
            Name       = "codex-skills"
            HostPath   = (Join-Path $env:USERPROFILE ".codex\skills")
            DockerPath = "/home/devuser/.codex/skills"
            WslPath    = (Convert-ToWslPath -Path (Join-Path $env:USERPROFILE ".codex\skills"))
            WslTarget  = '$HOME/.codex/skills'
            ContextRelativePath = ".codex/skills"
            CopyToWsl  = $true
        }
        [pscustomobject]@{
            Name       = "codex-plugin-cache"
            HostPath   = (Join-Path $env:USERPROFILE ".codex\plugins\cache")
            DockerPath = "/home/devuser/.codex/plugins/cache"
            WslPath    = (Convert-ToWslPath -Path (Join-Path $env:USERPROFILE ".codex\plugins\cache"))
            WslTarget  = '$HOME/.codex/plugins/cache'
            ContextRelativePath = ".codex/plugins/cache"
            CopyToWsl  = $true
        }
        [pscustomobject]@{
            Name       = "codex-understand-anything"
            HostPath   = (Join-Path $env:USERPROFILE ".codex\understand-anything")
            DockerPath = "/home/devuser/.codex/understand-anything"
            WslPath    = (Convert-ToWslPath -Path (Join-Path $env:USERPROFILE ".codex\understand-anything"))
            WslTarget  = '$HOME/.codex/understand-anything'
            ContextRelativePath = ".codex/understand-anything"
            CopyToWsl  = $true
        }
        [pscustomobject]@{
            Name       = "agents-skills"
            HostPath   = (Join-Path $env:USERPROFILE ".agents\skills")
            DockerPath = "/home/devuser/.agents/skills"
            WslPath    = (Convert-ToWslPath -Path (Join-Path $env:USERPROFILE ".agents\skills"))
            WslTarget  = '$HOME/.agents/skills'
            ContextRelativePath = ".agents/skills"
            CopyToWsl  = $true
        }
        [pscustomobject]@{
            Name       = "tooling-agents"
            HostPath   = "D:\Dev\Tooling\Agents"
            DockerPath = "/mnt/d/Dev/Tooling/Agents"
            WslPath    = "/mnt/d/Dev/Tooling/Agents"
            WslTarget  = ""
            ContextRelativePath = ""
            CopyToWsl  = $false
        }
    )

    return @($sources | Where-Object { Test-Path -LiteralPath $_.HostPath })
}

function Get-DockerAgentContextMountArgs {
    $mountArgs = New-Object System.Collections.Generic.List[string]

    foreach ($source in Get-AgentContextSources) {
        $mountArgs.Add("-v")
        $mountArgs.Add(("{0}:{1}:ro" -f $source.HostPath, $source.DockerPath))
        Write-Log ("Agent context mounted read-only: {0}" -f $source.Name)
    }

    return $mountArgs.ToArray()
}

function Get-WslAgentContextMapArgs {
    $mapArgs = New-Object System.Collections.Generic.List[string]

    foreach ($source in Get-AgentContextSources) {
        if ([string]::IsNullOrWhiteSpace([string]$source.WslPath)) {
            continue
        }

        $mapArgs.Add("--map")
        $mapArgs.Add((Quote-BashArg -Value ([string]$source.WslPath)))
        Write-Log ("Agent context mapped read-only in WSL: {0}" -f $source.Name)
    }

    return $mapArgs.ToArray()
}

function Sync-WslAgentContext {
    param([string]$TargetRoot)

    foreach ($source in Get-AgentContextSources) {
        if (-not $source.CopyToWsl) {
            continue
        }

        $src = Quote-BashArg -Value ([string]$source.WslPath)
        if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
            $target = [string]$source.WslTarget
        } else {
            $relativePath = [string]$source.ContextRelativePath
            if ([string]::IsNullOrWhiteSpace($relativePath)) {
                continue
            }

            $target = ('{0}/{1}' -f $TargetRoot.TrimEnd('/'), $relativePath.TrimStart('/'))
        }

        if ([string]::IsNullOrWhiteSpace($target)) {
            continue
        }

        $syncCommand = ('set -e; if [ -d {0} ]; then mkdir -p "{1}"; if command -v rsync >/dev/null 2>&1; then rsync -a --delete {0}/ "{1}/"; else cp -a -u {0}/. "{1}/"; fi; fi' -f $src, $target)
        $oldPreference = $ErrorActionPreference
        $ErrorActionPreference = "Continue"
        $output = & wsl -- bash -lc $syncCommand 2>&1
        $exitCode = $LASTEXITCODE
        $ErrorActionPreference = $oldPreference

        if ($exitCode -eq 0) {
            Write-Log ("Agent context synced to WSL: {0}" -f $source.Name)
        } else {
            Write-Log ("Agent context sync failed for {0}: {1}" -f $source.Name, (($output | Out-String).Trim())) "WARN"
        }
    }
}

function Get-WslHomePath {
    $output = & wsl -- bash -lc 'printf %s "$HOME"' 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace(($output | Out-String).Trim())) {
        return "/root"
    }

    return (($output | Out-String).Trim() -split "`r?`n")[0]
}

function Copy-WslReadableFile {
    param(
        [Parameter(Mandatory = $true)][string]$SourcePath,
        [Parameter(Mandatory = $true)][string]$TargetPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        return $false
    }

    $sourceWslPath = Quote-BashArg -Value (Convert-ToWslPath -Path $SourcePath)
    $targetWslPath = Quote-BashArg -Value $TargetPath
    $copyCommand = ('set -e; mkdir -p "$(dirname {0})"; cp {1} {0}' -f $targetWslPath, $sourceWslPath)
    $output = & wsl -- bash -lc $copyCommand 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log ("Failed to seed WSL isolated file {0}: {1}" -f $TargetPath, (($output | Out-String).Trim())) "WARN"
        return $false
    }

    return $true
}

function Sync-WslIsolatedAgentTools {
    param([Parameter(Mandatory = $true)][string]$ProfileRoot)

    $profileRootClean = $ProfileRoot.TrimEnd('/')
    $npmTarget = Quote-BashArg -Value ("{0}/.npm-global" -f $profileRootClean)
    $localBinTarget = Quote-BashArg -Value ("{0}/.local/bin" -f $profileRootClean)
    $syncCommand = @(
        'set -e'
        ('mkdir -p {0} {1}' -f $npmTarget, $localBinTarget)
        ('if [ -d "\$HOME/.npm-global" ]; then mkdir -p {0}; if command -v rsync >/dev/null 2>&1; then rsync -a --delete "\$HOME/.npm-global/" {0}/; else rm -rf {0}; cp -a "\$HOME/.npm-global" {0}; fi; fi' -f $npmTarget)
        ('mkdir -p {0}' -f $localBinTarget)
        ('for bin in agy; do if [ -x "\$HOME/.local/bin/\$bin" ]; then cp -a "\$HOME/.local/bin/\$bin" {0}/"\$bin"; fi; done' -f $localBinTarget)
    ) -join '; '

    $output = & wsl -- bash -lc $syncCommand 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Log "Synced WSL isolated agent tools."
    } else {
        Write-Log ("Failed to sync WSL isolated agent tools: {0}" -f (($output | Out-String).Trim())) "WARN"
    }
}

function Sync-WslIsolatedCodexSeed {
    param([Parameter(Mandatory = $true)][string]$ProfileRoot)

    $codexHostDir = Join-Path $env:USERPROFILE ".codex"
    $codexHostConfig = Join-Path $codexHostDir "config.toml"
    if (Test-Path -LiteralPath $codexHostConfig) {
        try {
            $hostConfig = [System.IO.File]::ReadAllText($codexHostConfig)
            $safeConfig = Convert-CodexConfigForDockerJail -Content $hostConfig
            $seedDir = Join-Path (Get-DockerSessionTempDir) "wsl-seed"
            New-Item -ItemType Directory -Path $seedDir -Force | Out-Null
            $seedConfigPath = Join-Path $seedDir "config.toml"
            $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
            [System.IO.File]::WriteAllText($seedConfigPath, $safeConfig, $utf8NoBom)
            if (Copy-WslReadableFile -SourcePath $seedConfigPath -TargetPath ("{0}/.codex/config.toml" -f $ProfileRoot)) {
                Write-Log "Seeded isolated WSL Codex config without host auth."
            }
        } catch {
            Write-Log ("Failed to prepare isolated WSL Codex config: {0}" -f $_.Exception.Message) "WARN"
        }
    }

    $codexAgents = Join-Path $codexHostDir "AGENTS.md"
    if (Copy-WslReadableFile -SourcePath $codexAgents -TargetPath ("{0}/.codex/AGENTS.md" -f $ProfileRoot)) {
        Write-Log "Seeded isolated WSL Codex AGENTS.md."
    }
}

function New-WslIsolatedRunScriptContent {
    param(
        [Parameter(Mandatory = $true)][string]$ProfileRoot,
        [Parameter(Mandatory = $true)][string]$ContextRoot,
        [Parameter(Mandatory = $true)][string]$HomePath
    )

    return @(
        '#!/usr/bin/env bash'
        'set +e'
        ('PROFILE_ROOT="{0}"' -f $ProfileRoot)
        ('CONTEXT_ROOT="{0}"' -f $ContextRoot)
        ('HOME_ROOT="{0}"' -f $HomePath)
        'export NPM_CONFIG_PREFIX="$PROFILE_ROOT/.npm-global"'
        'export PATH="$PROFILE_ROOT/.npm-global/bin:$PROFILE_ROOT/.local/bin:$HOME_ROOT/.cargo/bin:$PATH"'
        'for d in .codex .agents .claude .config .antigravity .opencode; do'
        '  mkdir -p "$HOME_ROOT/$d"'
        '  if [ -d "$PROFILE_ROOT/$d" ]; then cp -a "$PROFILE_ROOT/$d/." "$HOME_ROOT/$d/" 2>/dev/null || true; fi'
        'done'
        'if [ -f "$PROFILE_ROOT/.claude.json" ]; then cp "$PROFILE_ROOT/.claude.json" "$HOME_ROOT/.claude.json"; fi'
        'if [ -d "$CONTEXT_ROOT/.codex" ]; then cp -a "$CONTEXT_ROOT/.codex/." "$HOME_ROOT/.codex/" 2>/dev/null || true; fi'
        'if [ -d "$CONTEXT_ROOT/.agents" ]; then cp -a "$CONTEXT_ROOT/.agents/." "$HOME_ROOT/.agents/" 2>/dev/null || true; fi'
        'if [ "$#" -gt 0 ] && ! command -v "$1" >/dev/null 2>&1; then'
        '  echo "AI Jail: comando $1 nao encontrado no profile isolado." >&2'
        '  echo "Rode jwsl para instalar agentes no WSL, ou use --host-agent-login se quiser usar o ambiente do host." >&2'
        '  exit 127'
        'fi'
        '"$@"'
        'status=$?'
        'mkdir -p "$PROFILE_ROOT"'
        'for d in .codex .agents .claude .config .antigravity .opencode; do'
        '  if [ -d "$HOME_ROOT/$d" ]; then mkdir -p "$PROFILE_ROOT/$d"; cp -a "$HOME_ROOT/$d/." "$PROFILE_ROOT/$d/" 2>/dev/null || true; fi'
        'done'
        'if [ -f "$HOME_ROOT/.claude.json" ]; then cp "$HOME_ROOT/.claude.json" "$PROFILE_ROOT/.claude.json" 2>/dev/null || true; fi'
        'exit "$status"'
        ''
    ) -join "`n"
}

function Sync-WslIsolatedRunScript {
    param(
        [Parameter(Mandatory = $true)][string]$ProfileRoot,
        [Parameter(Mandatory = $true)][string]$ContextRoot,
        [Parameter(Mandatory = $true)][string]$HomePath
    )

    $seedDir = Join-Path (Get-DockerSessionTempDir) "wsl-runner"
    New-Item -ItemType Directory -Path $seedDir -Force | Out-Null
    $runnerPath = Join-Path $seedDir "ai-jail-run"
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($runnerPath, (New-WslIsolatedRunScriptContent -ProfileRoot $ProfileRoot -ContextRoot $ContextRoot -HomePath $HomePath), $utf8NoBom)

    $targetPath = "{0}/.ai-jail-run" -f $ProfileRoot.TrimEnd('/')
    if (Copy-WslReadableFile -SourcePath $runnerPath -TargetPath $targetPath) {
        $chmodCommand = 'chmod 700 {0}' -f (Quote-BashArg -Value $targetPath)
        $null = & wsl -- bash -lc $chmodCommand 2>$null
        Write-Log "Prepared isolated WSL runner script."
    }
}

function Initialize-WslIsolatedAgentProfile {
    $wslHome = Get-WslHomePath
    $profileRoot = "{0}/.scriply/ai-jail/profiles/{1}" -f $wslHome.TrimEnd('/'), $AgentProfile
    $contextRoot = "{0}/.scriply/ai-jail/context/{1}" -f $wslHome.TrimEnd('/'), $AgentProfile

    $initCommand = 'set -e; mkdir -p "{0}/.codex" "{0}/.agents" "{0}/.claude" "{0}/.config" "{0}/.antigravity" "{0}/.opencode" "{1}"' -f $profileRoot, $contextRoot
    $output = & wsl -- bash -lc $initCommand 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log ("Failed to initialize WSL isolated profile: {0}" -f (($output | Out-String).Trim())) "WARN"
    }

    Sync-WslIsolatedRunScript -ProfileRoot $profileRoot -ContextRoot $contextRoot -HomePath $wslHome

    if ($DryRun) {
        Write-Log ("WSL isolated agent profile would use: {0}" -f $profileRoot)
    } else {
        Sync-WslIsolatedAgentTools -ProfileRoot $profileRoot
        Sync-WslIsolatedCodexSeed -ProfileRoot $profileRoot

        if ($SyncAgentContext) {
            Sync-WslAgentContext -TargetRoot $contextRoot
            Write-Log "Agent context sync enabled for isolated WSL profile."
        } else {
            Write-Log "Agent context sync skipped for isolated WSL profile."
        }
    }

    return [pscustomobject]@{
        ProfileRoot = $profileRoot
        ContextRoot = $contextRoot
        HomePath    = $wslHome
    }
}

function New-WslIsolatedCommandArgs {
    param(
        [Parameter(Mandatory = $true)][string]$ProfileRoot,
        [Parameter(Mandatory = $true)][string]$ContextRoot,
        [Parameter(Mandatory = $true)][string]$HomePath,
        [Parameter(Mandatory = $true)][string[]]$InnerCommand
    )

    $runnerPath = "{0}/.ai-jail-run" -f $ProfileRoot.TrimEnd('/')
    return @('bash', $runnerPath) + $InnerCommand
}

function Get-DisplayValue {
    param(
        [string]$Value,
        [int]$Width = 36
    )

    if ($null -eq $Value) {
        return "".PadRight($Width)
    }

    if ($Value.Length -le $Width) {
        return $Value.PadRight($Width)
    }

    return ("..." + $Value.Substring($Value.Length - ($Width - 3))).PadRight($Width)
}

function Get-ProjectScopeWarning {
    if ($ProjectDir -eq $env:USERPROFILE) {
        return "HOME inteira exposta"
    }

    if ($ProjectDir -match "^[A-Za-z]:\\?$") {
        return "Raiz do drive exposta"
    }

    if ($ProjectDir -like "$env:WINDIR\System32*" -or $ProjectDir -like "$env:WINDIR\SysWOW64*") {
        return "System32 nao e projeto"
    }

    return $null
}

function Assert-SafeProjectScope {
    $scopeWarning = Get-ProjectScopeWarning
    if (-not $scopeWarning) {
        return
    }

    Write-Host ""
    Write-Host "  AI JAIL BLOQUEADO" -ForegroundColor Red
    Write-Host ("  Motivo: {0}" -f $scopeWarning) -ForegroundColor Yellow
    Write-Host "  Entre em uma pasta de projeto especifica e rode o comando novamente." -ForegroundColor DarkGray
    Write-Host ("  Exemplo: cd {0}" -f (Join-Path $env:USERPROFILE "Projetos\MeuProjeto")) -ForegroundColor DarkGray
    Write-Host ""
    Write-Log ("Blocked unsafe project scope: {0} ({1})" -f $ProjectDir, $scopeWarning) "WARN"
    exit 1
}

function Write-Row {
    param(
        [string]$Label,
        [string]$Value,
        [string]$ValueColor = "White"
    )

    $innerWidth = 60
    $labelWidth = 10
    $valueWidth = $innerWidth - $labelWidth - 5

    Write-Host "  | " -NoNewline -ForegroundColor DarkMagenta
    Write-Host (Format-ScriplyUiCell -Text $Label -Width $labelWidth) -NoNewline -ForegroundColor DarkGray
    Write-Host " | " -NoNewline -ForegroundColor DarkGray
    Write-Host (Format-ScriplyUiCell -Text $Value -Width $valueWidth) -NoNewline -ForegroundColor $ValueColor
    Write-Host " |" -ForegroundColor DarkMagenta
}

function Write-Banner {
    param(
        [string]$Mode,
        [string]$Agent,
        [bool]$IsLockdown,
        [bool]$IsDryRun
    )

    $modeColor = if ($Mode -like "*Docker*") { "DarkYellow" } else { "Magenta" }
    $protectionValue = if ($Mode -like "*Docker*") { "container fallback (menos restrito)" } else { "kernel sandbox (bwrap + Landlock)" }
    $protectionColor = if ($Mode -like "*Docker*") { "DarkYellow" } else { "Green" }
    $networkValue = if ($IsLockdown) { "sem rede (lockdown)" } elseif ($Mode -like "*Docker*") { "rede liberada (use --lockdown)" } else { "rede gerenciada pelo ai-jail" }
    $networkColor = if ($IsLockdown) { "Red" } elseif ($Mode -like "*Docker*") { "Yellow" } else { "DarkGray" }
    $scopeWarning = Get-ProjectScopeWarning

    Write-Host ""
    Write-Host (Get-ScriplyUiBoxTop -Indent '  ' -InnerWidth 60 -Style Single) -ForegroundColor DarkMagenta
    Write-Host (Get-ScriplyUiBoxLine -Text (Get-ScriplyUiTitleText -Title 'AI JAIL ATIVO' -Icon '◉') -Indent '  ' -InnerWidth 60 -Style Single -Center) -ForegroundColor White
    Write-Host (Get-ScriplyUiBoxDivider -Indent '  ' -InnerWidth 60 -Style Single) -ForegroundColor DarkMagenta
    Write-Row -Label "Modo" -Value $Mode -ValueColor $modeColor
    Write-Row -Label "Protecao" -Value $protectionValue -ValueColor $protectionColor
    Write-Row -Label "Projeto" -Value $ProjectDir -ValueColor "White"
    Write-Row -Label "Visivel" -Value "somente este projeto" -ValueColor "Green"
    Write-Row -Label "Escrita" -Value "projeto atual + dotfiles permitidos" -ValueColor "Green"
    Write-Row -Label "Rede" -Value $networkValue -ValueColor $networkColor
    Write-Row -Label "Agente" -Value $Agent -ValueColor "Yellow"

    if ($scopeWarning) {
        Write-Row -Label "Alerta" -Value $scopeWarning -ValueColor "Red"
    }

    if ($IsLockdown) {
        Write-Row -Label "Lockdown" -Value "ATIVO (read-only, sem rede)" -ValueColor "Red"
    }

    if ($IsDryRun) {
        Write-Row -Label "Dry-Run" -Value "ATIVO (nenhuma acao sera executada)" -ValueColor "Magenta"
    }

    $sshEnabled = Test-AiJailOptionPresent -Options $AiJailOptions -Name '--ssh'
    $blockedValue = if ($sshEnabled) { ".gnupg  .aws  .mozilla  (ssh seletivo)" } else { ".gnupg  .aws  .ssh  .mozilla" }

    Write-Host (Get-ScriplyUiBoxDivider -Indent '  ' -InnerWidth 60 -Style Single) -ForegroundColor DarkMagenta
    Write-Row -Label "Bloqueado" -Value $blockedValue -ValueColor "Red"
    Write-Row -Label "Log" -Value $LogFile -ValueColor "DarkGray"
    Write-Host (Get-ScriplyUiBoxBottom -Indent '  ' -InnerWidth 60 -Style Single) -ForegroundColor DarkMagenta

    if ($Mode -like "*Docker*") {
        Write-Host "  Nota: Docker e o fallback de compatibilidade. Para isolamento mais forte, prefira WSL2 + ai-jail." -ForegroundColor DarkYellow
    }

    Write-Host ""
}

function Test-WSL {
    try {
        $null = wsl --status 2>$null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

function Test-AkitaJailWSL {
    try {
        $null = wsl -- bash -lc "source ~/.cargo/env 2>/dev/null; which ai-jail" 2>$null
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

function Start-AkitaMode {
    $mode = "Akita via WSL2 (bwrap + Landlock)"
    $wslPath = Convert-ToWslPath -Path $ProjectDir
    $finalCommandArgs = @($CommandArgs)
    $isolatedWslProfile = $null
    $jailParts = @("source ~/.cargo/env 2>/dev/null")

    if ($HostAgentLogin) {
        $jailParts += $DefaultWslBootstrap
        if ($SyncAgentContext -and -not (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--private-home")) {
            if ($DryRun) {
                Write-Log "Agent context sync would run for WSL mode (dry-run)."
            } else {
                Sync-WslAgentContext
                Write-Log "Agent context sync enabled for WSL mode."
            }
        } else {
            Write-Log "Agent context sync skipped for WSL mode."
        }
    } else {
        $isolatedWslProfile = Initialize-WslIsolatedAgentProfile
        $finalCommandArgs = New-WslIsolatedCommandArgs -ProfileRoot $isolatedWslProfile.ProfileRoot -ContextRoot $isolatedWslProfile.ContextRoot -HomePath $isolatedWslProfile.HomePath -InnerCommand $finalCommandArgs
        Write-Log ("Host agent login disabled; isolated WSL profile: {0}" -f $AgentProfile)
    }

    $aiJailParts = @("ai-jail")
    if ($HostAgentLogin) {
        $aiJailParts += $DefaultWslRwMaps
    }

    if ($HostAgentLogin -and $SyncAgentContext -and -not (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--private-home")) {
        $aiJailParts += (Get-WslAgentContextMapArgs)
    }

    if (-not $HostAgentLogin -and $isolatedWslProfile) {
        $aiJailParts += @("--rw-map", (Quote-BashArg -Value ([string]$isolatedWslProfile.ProfileRoot)))
        if ($SyncAgentContext) {
            $aiJailParts += @("--map", (Quote-BashArg -Value ([string]$isolatedWslProfile.ContextRoot)))
        }

        foreach ($source in Get-AgentContextSources) {
            if (-not $source.CopyToWsl -and -not [string]::IsNullOrWhiteSpace([string]$source.WslPath)) {
                $aiJailParts += @("--map", (Quote-BashArg -Value ([string]$source.WslPath)))
            }
        }
    }

    if (-not (Test-AiJailConfigShouldPersist -Options $AiJailOptions) -and -not (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--no-save-config")) {
        $aiJailParts += "--no-save-config"
        Write-Log "Flag: --no-save-config (default from Scriply wrapper)"
    }

    if ($Lockdown) {
        $aiJailParts += "--lockdown"
        Write-Log "Flag: --lockdown"
    }

    if ($DryRun) {
        $aiJailParts += @("--dry-run", "--verbose")
        Write-Log "Flag: --dry-run --verbose"
    }

    if ($AiJailOptions.Count -gt 0) {
        $quotedAiJailOptions = @(
            @($AiJailOptions) |
                Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) } |
                ForEach-Object { Quote-BashArg -Value ([string]$_) }
        )
        $aiJailParts += $quotedAiJailOptions
        Write-Log ("Flags ai-jail: {0}" -f (($AiJailOptions | ForEach-Object { [string]$_ }) -join " "))
    }

    $quotedCommand = ($finalCommandArgs | ForEach-Object { Quote-BashArg -Value $_ }) -join " "
    $aiJailParts += $quotedCommand
    $jailParts += ($aiJailParts -join " ")
    $jailCommand = $jailParts -join "; "
    $wslArgs = @("--cd", $wslPath, "--", "bash", "-lc", $jailCommand)

    Write-Banner -Mode $mode -Agent $CommandLabel -IsLockdown $Lockdown -IsDryRun $DryRun
    if ($AgentAliasWarning) {
        Write-Host ("  Aviso: {0}" -f $AgentAliasWarning) -ForegroundColor Yellow
        Write-Log $AgentAliasWarning "WARN"
    }
    Write-Log ("Session started - Mode: Akita WSL2, Agent: {0}, Project: {1}" -f $CommandLabel, $ProjectDir)

    if ($DryRun) {
        Write-Host "  [DRY-RUN] Comando que seria executado:" -ForegroundColor Magenta
        Write-Host ("  wsl {0}" -f ($wslArgs -join " ")) -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  Executando ai-jail --dry-run dentro do WSL..." -ForegroundColor DarkGray
    }

    & wsl @wslArgs
    $exitCode = $LASTEXITCODE
    Remove-AutoGeneratedAiJailConfig -ConfigPath $AiJailConfigPath -ConfigExistedBefore $AiJailConfigExistedBeforeLaunch -PreserveGeneratedConfig $PreserveGeneratedConfig -ExpectedContent $ExpectedAiJailConfig
    Remove-DockerSessionTempDir
    Write-Log ("Session finished - Exit code: {0}" -f $exitCode)
    exit $exitCode
}

function Start-DockerMode {
    $mode = "Docker Container (fallback)"
    Write-Banner -Mode $mode -Agent $CommandLabel -IsLockdown $Lockdown -IsDryRun $DryRun
    if ($AgentAliasWarning) {
        Write-Host ("  Aviso: {0}" -f $AgentAliasWarning) -ForegroundColor Yellow
        Write-Log $AgentAliasWarning "WARN"
    }
    Write-Log ("Session started - Mode: Docker, Agent: {0}, Project: {1}" -f $CommandLabel, $ProjectDir)

    if ($AiJailOptions.Count -gt 0) {
        $ignoredOptions = (($AiJailOptions | ForEach-Object { [string]$_ }) -join " ")
        Write-Host "  Aviso: fallback Docker tem paridade parcial com o ai-jail oficial." -ForegroundColor Yellow
        Write-Host ("  Flags recebidas: {0}" -f $ignoredOptions) -ForegroundColor DarkGray
        Write-Log ("ai-jail flags received in Docker fallback: {0}" -f $ignoredOptions) "WARN"
    }

    $dockerInteractiveFlag = if ([Console]::IsInputRedirected -or [Console]::IsOutputRedirected) { "-i" } else { "-it" }
    $wslProjectPath = Convert-ToWslPath -Path $ProjectDir
    $sshEnabled = Test-AiJailOptionPresent -Options $AiJailOptions -Name '--ssh'
    $codexDockerVolume = Get-AgentProfileDockerVolume -ProfileName $AgentProfile
    $dockerArgs = @(
        "run",
        $dockerInteractiveFlag,
        "-v", "${ProjectDir}:${wslProjectPath}",
        "-w", $wslProjectPath,
        "--hostname", "ai-jail",
        "-e", "NPM_CONFIG_PREFIX=/home/devuser/.npm-global",
        "-e", "PATH=/home/devuser/.npm-global/bin:/home/devuser/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "-e", "XDG_DATA_HOME=/home/devuser/.local/share-linux",
        "--rm",
        "--memory", $Memory,
        "--cpus", [string]$Cpus
    )

    if ($Lockdown) {
        $dockerArgs += @("--read-only", "--network", "none", "--tmpfs", "/tmp:rw,noexec,nosuid,size=512m")
        Write-Log "Flag: --lockdown (read-only, network none)"
    }

    $codexHomeTarget = "/home/devuser/.codex"
    if ($Lockdown) {
        $dockerArgs += @("--tmpfs", "${codexHomeTarget}:rw,noexec,nosuid,size=256m")
        Write-Log "Docker Codex home uses tmpfs because lockdown is active"
    } else {
        $dockerArgs += @("-v", "${codexDockerVolume}:${codexHomeTarget}")
        Write-Log ("Docker Codex home uses Docker volume: {0}" -f $codexDockerVolume)
    }

    $codexHostDir = Join-Path $env:USERPROFILE ".codex"
    $codexHostConfig = Join-Path $codexHostDir "config.toml"
    $dockerCodexConfigDir = New-DockerJailCodexConfig -HostConfigPath $codexHostConfig

    if ($dockerCodexConfigDir) {
        $agentsFile = Join-Path $codexHostDir "AGENTS.md"
        if (Test-Path $agentsFile) {
            Copy-Item -LiteralPath $agentsFile -Destination (Join-Path $dockerCodexConfigDir "AGENTS.md") -Force
        }

        if ($HostAgentLogin -and -not $DockerPrivateHome) {
            $authFile = Join-Path $codexHostDir "auth.json"
            if (Test-Path $authFile) {
                Copy-Item -LiteralPath $authFile -Destination (Join-Path $dockerCodexConfigDir "auth.json") -Force
                Write-Log "Host Codex auth copied by explicit opt-in."
            }
        } else {
            Write-Log "Host agent login disabled; auth.json not copied."
        }

        $dockerArgs += @("-v", "${dockerCodexConfigDir}:/tmp/codex-mount:ro")
    }

    if ($SyncAgentContext) {
        $dockerArgs += (Get-DockerAgentContextMountArgs)
        Write-Log "Agent context sync enabled for Docker mode."
    } else {
        Write-Log "Agent context sync skipped for Docker mode."
    }

    if ($DockerPrivateHome) {
        Write-Host "  Private-home: dotdirs do host nao serao montados no Docker fallback." -ForegroundColor DarkGray
        Write-Log "Docker private-home enabled: host dotdirs skipped"
    } elseif (-not $HostAgentLogin) {
        Write-Host "  Login host: desativado; dotdirs do host nao serao montados no Docker fallback." -ForegroundColor DarkGray
        Write-Log "Host agent login disabled; host dotdirs skipped in Docker fallback."
    } else {
        foreach ($dir in $AllowedRWDirs) {
            $hostPath = Join-Path $env:USERPROFILE $dir
            if ($dir -eq ".npm-global" -and -not (Test-Path -LiteralPath $hostPath)) {
                New-Item -ItemType Directory -Path $hostPath -Force | Out-Null
            }

            if (Test-Path $hostPath) {
                $containerDir = "/home/devuser/{0}" -f ($dir -replace "\\", "/")
                $dockerArgs += @("-v", "${hostPath}:${containerDir}")
            }
        }

        $gitConfig = Join-Path $env:USERPROFILE ".gitconfig"
        if (Test-Path $gitConfig) {
            $dockerArgs += @("-v", "${gitConfig}:/home/devuser/.gitconfig:ro")
        }

        $claudeJson = Join-Path $env:USERPROFILE ".claude.json"
        if (Test-Path $claudeJson) {
            $dockerArgs += @("-v", "${claudeJson}:/home/devuser/.claude.json")
        }
    }

    # Se --ssh foi passado, montar chaves SSH especificas read-only no container em diretorio temporario.
    # Configure com AI_JAIL_SSH_KEY_MAP: "C:\path\key=alias;C:\path\other=other_alias".
    if ($sshEnabled -and -not $Lockdown) {
        $jailSshDir = '/tmp/.ssh-mount'
        $sshKeyMappings = Get-AiJailSshKeyMappings -MountRoot $jailSshDir

        foreach ($mapping in $sshKeyMappings) {
            if (Test-Path $mapping.Host) {
                $dockerArgs += @('-v', "$($mapping.Host):$($mapping.Container):ro")
                Write-Log ("SSH key mounted to temp: {0}" -f $mapping.Container)
            }
        }

        # Montar config SSH do jail se existir no WSL (gerado pelo setup-jail-ssh.sh).
        $wslDistro = [Environment]::GetEnvironmentVariable("AI_JAIL_WSL_DISTRO", "Process")
        if ([string]::IsNullOrWhiteSpace($wslDistro)) {
            $wslDistro = "Ubuntu"
        }

        $wslSshRoot = "\\wsl$\$wslDistro\root\.ssh"
        $wslSshConfig = Join-Path $wslSshRoot "config"
        $dockerSshConfig = Copy-DockerReadableTempFile -SourcePath $wslSshConfig -FileName "ssh_config"
        if ($dockerSshConfig) {
            $dockerArgs += @('-v', "${dockerSshConfig}:${jailSshDir}/config:ro")
            Write-Log "SSH config mounted to temp from readable copy"
        }

        $wslKnownHosts = Join-Path $wslSshRoot "known_hosts"
        $dockerKnownHosts = Copy-DockerReadableTempFile -SourcePath $wslKnownHosts -FileName "known_hosts"
        if ($dockerKnownHosts) {
            $dockerArgs += @('-v', "${dockerKnownHosts}:${jailSshDir}/known_hosts:ro")
            Write-Log "SSH known_hosts mounted to temp from readable copy"
        }
    }

    foreach ($dir in $SensitiveDirs) {
        $hostPath = Join-Path $env:USERPROFILE $dir
        if (Test-Path $hostPath) {
            Write-Log ("Blocked sensitive dir: {0}" -f $dir)
        }
    }

    $finalCommandArgs = $CommandArgs
    if ($sshEnabled -and -not $Lockdown) {
        # Copia as chaves do ponto de montagem temporário para o ~/.ssh/ real do container e corrige permissões
        $bootstrapCmd = 'mkdir -p ~/.ssh; if [ -d /tmp/.ssh-mount ]; then cp -rp /tmp/.ssh-mount/* ~/.ssh/; fi; chmod 700 ~/.ssh; chmod 600 ~/.ssh/* 2>/dev/null || true; exec "$@"'
        $finalCommandArgs = @('bash', '-c', $bootstrapCmd, '_') + $CommandArgs
    }

    if ($DryRun) {
        Write-Host "  [DRY-RUN] Comando que seria executado:" -ForegroundColor Magenta
        Write-Host ""
        Write-Host ("  docker {0} {1} {2}" -f ($dockerArgs -join " "), $DockerImage, ($finalCommandArgs -join " ")) -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  Mounts configurados:" -ForegroundColor Cyan

        for ($i = 0; $i -lt $dockerArgs.Count; $i++) {
            if ($dockerArgs[$i] -eq "-v" -and ($i + 1) -lt $dockerArgs.Count) {
                Write-Host ("    - {0}" -f $dockerArgs[$i + 1]) -ForegroundColor DarkGray
            }
        }

        Write-Log "Dry-run executed - no action taken"
        Remove-DockerSessionTempDir
        exit 0
    }

    $dockerImageQuery = @(docker images -q $DockerImage 2>&1)
    $dockerQueryExitCode = $LASTEXITCODE
    $dockerQueryText = ($dockerImageQuery | Out-String).Trim()

    if ($dockerQueryExitCode -ne 0) {
        Write-Host "  Docker nao respondeu. Verifique se o Docker Desktop esta aberto." -ForegroundColor Yellow
        if (-not [string]::IsNullOrWhiteSpace($dockerQueryText)) {
            Write-Host ("  Detalhe: {0}" -f $dockerQueryText) -ForegroundColor DarkGray
        }

        Write-Log ("Docker availability check failed: {0}" -f $dockerQueryText) "ERROR"
        Remove-DockerSessionTempDir
        exit 1
    }

    if ([string]::IsNullOrWhiteSpace($dockerQueryText)) {
        Write-Host ("  Imagem '{0}' nao encontrada." -f $DockerImage) -ForegroundColor Yellow
        Write-Host "  Execute docker build no contexto configurado para o ai-jail ou defina AI_JAIL_DOCKER_ROOT." -ForegroundColor DarkGray
        Write-Log "Docker image not found" "ERROR"
        Remove-DockerSessionTempDir
        exit 1
    }

    if ($CommandArgs.Count -eq 1 -and $CommandArgs[0] -eq "bash") {
        Write-Host "  Abrindo shell bash interativo no container. Se parecer parado, pressione Enter. Use 'exit' para sair." -ForegroundColor DarkGray
        Write-Host ""
    }

    $fullDockerArgs = @($dockerArgs + @($DockerImage) + $finalCommandArgs)
    Write-Log ("Executing: docker {0}" -f ($fullDockerArgs -join " "))
    & docker @fullDockerArgs
    $dockerExitCode = $LASTEXITCODE
    Remove-DockerSessionTempDir
    Write-Log ("Session finished - Exit code: {0}" -f $dockerExitCode)
    exit $dockerExitCode
}

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

if (-not $HostAgentLogin) {
    if (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--no-private-home") {
        Write-Error "--no-private-home exige --host-agent-login, pois pode expor login existente do agente no HOME do WSL."
        exit 1
    }

    if (-not (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--private-home")) {
        Add-AiJailOptionIfMissing -Options $AiJailOptions -Name "--private-home"
        $DockerPrivateHome = $true
        Write-Log "Flag: --private-home (default because host agent login is disabled)"
    }

    if (-not (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--ssh") -and -not (Test-AiJailOptionPresent -Options $AiJailOptions -Name "--no-ssh")) {
        Add-AiJailOptionIfMissing -Options $AiJailOptions -Name "--no-ssh"
        Write-Log "Flag: --no-ssh (default because host agent login is disabled)"
    }

    Write-Log ("Host agent login disabled; profile={0}" -f $AgentProfile)
} else {
    Write-Log "Host agent login enabled by explicit opt-in."
}

Assert-SafeProjectScope

$AiJailConfigPath = Join-Path $ProjectDir ".ai-jail"
$AiJailConfigExistedBeforeLaunch = Test-Path -LiteralPath $AiJailConfigPath
$PreserveGeneratedConfig = Test-AiJailConfigShouldPersist -Options $AiJailOptions
$ExpectedAiJailConfig = $null

if (-not $AiJailConfigExistedBeforeLaunch -and -not $PreserveGeneratedConfig) {
    $ExpectedAiJailConfig = Get-AiJailDefaultConfigContent -Command $CommandArgs
}

$UseDocker = $Docker

if (-not $UseDocker) {
    if (-not (Test-WSL)) {
        Write-Host "  WSL2 nao encontrado. Usando Docker fallback." -ForegroundColor Yellow
        $UseDocker = $true
    } elseif (-not (Test-AkitaJailWSL)) {
        Write-Host "  ai-jail nao instalado no WSL. Usando Docker fallback." -ForegroundColor Yellow
        Write-Host "  Execute 12-AI-Jail-Setup.ps1 para instalar." -ForegroundColor DarkGray
        $UseDocker = $true
    }
}

if (-not $UseDocker) {
    Start-AkitaMode
}

Start-DockerMode
