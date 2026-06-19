param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Command
)

function Get-EnvOverride {
    param([string]$Name)

    foreach ($scope in 'Process', 'User', 'Machine') {
        $value = [Environment]::GetEnvironmentVariable($Name, $scope)
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            return $value
        }
    }

    return $null
}

function Resolve-FirstExistingPath {
    param([string[]]$Candidates)

    foreach ($candidate in @($Candidates)) {
        if ([string]::IsNullOrWhiteSpace($candidate)) {
            continue
        }

        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    return $null
}

$scriptsRoot = Get-EnvOverride -Name 'SCRIPLY_SCRIPTS_ROOT'
$fallbackRoot = Split-Path -Parent $PSScriptRoot
$repoRoot = Split-Path -Parent $fallbackRoot
$launcherPath = Resolve-FirstExistingPath -Candidates @(
    (Join-Path $repoRoot 'ia\12-AI-Jail.ps1'),
    $(if ($scriptsRoot) { Join-Path $scriptsRoot 'ia\12-AI-Jail.ps1' }),
    (Join-Path $env:USERPROFILE 'Dev\Scripts\ia\12-AI-Jail.ps1')
)

if (-not (Test-Path -LiteralPath $launcherPath)) {
    Write-Error 'Launcher do AI Jail nao encontrado. Defina SCRIPLY_SCRIPTS_ROOT ou mantenha ia\\12-AI-Jail.ps1 neste repo.'
    exit 1
}

& $launcherPath @Command
exit $LASTEXITCODE
