# pocket-antigravity One-Line Installer for Windows PowerShell
$ErrorActionPreference = "Stop"

$url = "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/install.py"

if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = "python"
} elseif (Get-Command python3 -ErrorAction SilentlyContinue) {
    $pythonCmd = "python3"
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    $pythonCmd = "py -3"
} else {
    Write-Error "Error: Python 3 is required to install pocket-antigravity."
    exit 1
}

$scriptContent = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
& $pythonCmd -c $scriptContent $args
