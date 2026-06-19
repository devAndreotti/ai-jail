#Requires -Version 5.1

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

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

$dockerignore = Get-FileText 'docker-fallback/.dockerignore'
foreach ($pattern in @('.env', '*.pem', '*.key', '*.pfx', '*.p12', 'id_rsa', 'id_ed25519')) {
    Assert-Contains $dockerignore ([regex]::Escape($pattern)) "docker-fallback/.dockerignore deve bloquear $pattern."
}

$launcher = Get-FileText 'ia/12-AI-Jail.ps1'
Assert-Contains $launcher '\$SensitiveDirs = @\("\.gnupg", "\.aws", "\.ssh", "\.mozilla"' 'Launcher deve listar dotdirs sensiveis.'
Assert-Contains $launcher 'Flag: --private-home \(default because host agent login is disabled\)' 'Launcher deve ativar private-home por padrao.'
Assert-Contains $launcher 'Flag: --no-ssh \(default because host agent login is disabled\)' 'Launcher deve desativar SSH por padrao.'
Assert-Contains $launcher '--no-private-home exige --host-agent-login' 'Launcher deve bloquear no-private-home sem opt-in.'
Assert-NotContains $launcher 'auth\.json",\s*"AGENTS\.md"' 'auth.json nao pode ser copiado junto com AGENTS.md sem gate.'

Write-Host 'Scriply AI Jail sandbox checks passed.'
