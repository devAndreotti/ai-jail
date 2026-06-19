@echo off
setlocal
REM # ID: scriply-ia-ai-jail-bat
REM # Nome: AI Jail Batch
REM # Resumo: Wrapper batch interno do AI Jail.
REM # Descricao: Encaminha argumentos para 12-AI-Jail.ps1 e existe apenas para compatibilidade com chamadas .bat.
REM # Categoria: ia
REM # MostrarNoApp: false
REM # Admin: false
REM # Versao: 1.1.0
REM # Logs: $env:ProgramData\Scriply\Logs\AI-Jail
REM # Params: --docker, --lockdown, --no-lockdown, --dry-run, --memory, --cpus, --display, --no-display, --no-docker, --status-bar, --no-status-bar, --clean, --init, --bootstrap, --gpu, --no-gpu, --verbose, --landlock, --no-landlock, --seccomp, --no-seccomp, --rlimits, --no-rlimits, --mise, --no-mise, --worktree, --no-worktree, --private-home, --no-private-home, --agent-profile, --host-agent-login, --no-host-agent-login, --save-config, --no-save-config, --hide-config, --no-hide-config, --ssh, --no-ssh, --pictures, --no-pictures, --browser, --no-browser, --exec, --mask, --hide-dotdir, --claude-dir, --allow-tcp-port, --map, --rw-map, comando
REM # ParamMeta: --docker | Docker | Forca o fallback Docker em vez do AI Jail no WSL.
REM # ParamMeta: --lockdown | Lockdown | Executa com rede restrita e escrita limitada quando suportado.
REM # ParamMeta: --dry-run | Simulacao | Mostra o comando final sem iniciar a sessao real.
REM # ParamMeta: --memory | Memoria | Define o limite de memoria usado no fallback Docker.
REM # ParamMeta: --cpus | CPUs | Define a quantidade de CPUs usada no fallback Docker.
REM # ParamMeta: --private-home | Home Privado | Nao monta dotdirs normais do host.
REM # ParamMeta: --agent-profile | Perfil Agente | Usa perfil persistente isolado para login do agente.
REM # ParamMeta: --host-agent-login | Login Host | Opt-in para copiar/montar login do agente do host.
REM # ParamMeta: --no-host-agent-login | Sem Login Host | Mantem login do agente isolado do host.
REM # ParamMeta: --mask | Mascara | Oculta arquivo/pasta do projeto dentro do sandbox oficial.
REM # ParamMeta: --browser | Browser | Habilita perfil isolado de navegador no ai-jail oficial.
REM # ParamMeta: --map | Mapear Leitura | Repassa um mapeamento de caminho para o ai-jail.
REM # ParamMeta: --rw-map | Mapear Escrita | Repassa um mapeamento gravavel para o ai-jail.
REM # ParamMeta: comando | Comando | Define o comando executado dentro do AI Jail; se omitido, abre bash.

set "SCRIPT_PATH=%~dp012-AI-Jail.ps1"

if not exist "%SCRIPT_PATH%" (
    echo [ERRO] Script nao encontrado: "%SCRIPT_PATH%"
    exit /b 1
)

where pwsh.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %*
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %*
)

exit /b %ERRORLEVEL%
