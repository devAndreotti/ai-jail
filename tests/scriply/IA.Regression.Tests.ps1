#Requires -Version 5.1

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$iaRoot = Join-Path $repoRoot 'ia'
$dockerRoot = Join-Path $repoRoot 'docker-fallback'

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Get-FileText {
    param([string]$RelativePath)
    $path = Join-Path $repoRoot $RelativePath
    $text = [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($path))
    if ($text.Length -gt 0 -and $text[0] -eq [char]0xfeff) { $text = $text.Substring(1) }
    return $text
}

function Assert-Contains {
    param([string]$Text, [string]$Pattern, [string]$Message)
    Assert-True -Condition ([regex]::IsMatch($Text, $Pattern, [Text.RegularExpressions.RegexOptions]::Singleline)) -Message $Message
}

function Assert-NotContains {
    param([string]$Text, [string]$Pattern, [string]$Message)
    Assert-True -Condition (-not [regex]::IsMatch($Text, $Pattern, [Text.RegularExpressions.RegexOptions]::Singleline)) -Message $Message
}

Assert-True -Condition (Test-Path -LiteralPath $iaRoot) -Message 'ia/ deve existir.'
Assert-True -Condition (Test-Path -LiteralPath $dockerRoot) -Message 'docker-fallback/ deve existir.'

$parseErrors = @()
foreach ($file in Get-ChildItem -LiteralPath $iaRoot -Filter '*.ps1') {
    $tokens = $null
    $errors = $null
    $text = [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($file.FullName))
    if ($text.Length -gt 0 -and $text[0] -eq [char]0xfeff) { $text = $text.Substring(1) }
    [void][System.Management.Automation.Language.Parser]::ParseInput($text, [ref]$tokens, [ref]$errors)
    if ($errors) { $parseErrors += "$($file.Name): $($errors[0].Message)" }
}
Assert-True -Condition ($parseErrors.Count -eq 0) -Message ("Parser errors: " + ($parseErrors -join '; '))

$launcher = Get-FileText 'ia/12-AI-Jail.ps1'
Assert-Contains $launcher '#Requires\s+-Version\s+5\.1' 'Launcher deve declarar PowerShell minimo.'
Assert-Contains $launcher '--agent-profile' 'Launcher deve expor profile isolado.'
Assert-Contains $launcher '--host-agent-login' 'Launcher deve exigir opt-in para login host.'
Assert-Contains $launcher 'function\s+Sync-WslIsolatedAgentTools' 'Launcher deve sincronizar binarios de agente no profile isolado.'
Assert-Contains $launcher 'auth\.json not copied' 'Launcher deve logar que auth.json nao foi copiado por padrao.'
Assert-Contains $launcher 'AI_JAIL_SSH_KEY_MAP' 'SSH seletivo deve ser configurado por ambiente, nao por caminho pessoal.'
Assert-NotContains $launcher 'github_pat_|ghp_|gho_|sk-[A-Za-z0-9_-]{20,}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY' 'Launcher nao deve conter segredo hardcoded.'

$setup = Get-FileText 'ia/12-AI-Jail-Setup.ps1'
Assert-Contains $setup 'https://github\.com/akitaonrails/ai-jail' 'Setup deve preservar credito/link upstream.'
$githubTokenName = 'GH' + '_TOKEN'
Assert-NotContains $setup ('export\s+{0}=' -f $githubTokenName) 'Setup nao deve exportar token GitHub literal.'
Assert-Contains $setup 'gh auth status' 'Setup deve checar autenticacao antes do gh-copilot.'

$dockerfile = Get-FileText 'docker-fallback/Dockerfile'
Assert-NotContains $dockerfile ('ARG\s+{0}|{0}=' -f $githubTokenName) 'Dockerfile nao deve aceitar token GitHub via build arg.'
Assert-Contains $dockerfile 'gh extension install github/gh-copilot \|\| true' 'Dockerfile deve instalar gh-copilot sem exigir token.'
Assert-Contains $dockerfile '~/.ssh' 'Dockerfile deve documentar dotfiles sensiveis bloqueados.'

$dockerWrapper = Get-FileText 'docker-fallback/jail.ps1'
Assert-Contains $dockerWrapper 'Join-Path \$repoRoot ''ia\\12-AI-Jail\.ps1''' 'Wrapper Docker deve preferir launcher deste repo.'
Assert-NotContains $dockerWrapper 'Dev\\Scripts\\ia\\12-AI-Jail\.ps1''.*\$driveRoot' 'Wrapper Docker nao deve depender de caminho pessoal por drive.'

Write-Host 'Scriply AI Jail regression checks passed.'
