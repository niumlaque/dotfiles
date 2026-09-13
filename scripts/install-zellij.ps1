$ErrorActionPreference = "Stop"

$repoDir = Split-Path $PSScriptRoot -Parent
$sourceDir = (Resolve-Path (Join-Path $repoDir "zellij")).Path
$configDir = Join-Path $HOME ".config\zellij"

if (-not (Get-Command zellij -ErrorAction SilentlyContinue)) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget is required."
    }

    winget install --exact --id Zellij.Zellij `
        --accept-package-agreements `
        --accept-source-agreements

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install Zellij."
    }
}

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command zellij -ErrorAction SilentlyContinue)) {
    throw "zellij was installed but is not available in PATH."
}

if (Test-Path $configDir) {
    $config = Get-Item $configDir

    if ($config.LinkType -ne "Junction" -or
        (Resolve-Path $config.Target).Path -ne $sourceDir) {
        throw "$configDir already exists and does not point to $sourceDir."
    }
} else {
    $configParent = Split-Path $configDir -Parent
    New-Item -ItemType Directory -Path $configParent -Force | Out-Null
    New-Item -ItemType Junction -Path $configDir -Target $sourceDir | Out-Null
}

zellij --version
