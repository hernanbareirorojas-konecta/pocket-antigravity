<#
.SYNOPSIS
    pocket-antigravity Native PowerShell Installer (Zero Python Dependency)
.DESCRIPTION
    Installs pocket-antigravity token optimization directives into any project
    or globally for Google Antigravity and Gemini agents.
.PARAMETER TargetDir
    The target directory where pocket-antigravity should be installed. Defaults to current directory.
.PARAMETER Global
    If specified, installs token-efficiency rules globally into $HOME/.gemini/config/
#>
[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [string]$TargetDir = (Get-Location).Path,

    [switch]$Global
)

$ErrorActionPreference = "Stop"

# Ensure UTF-8 console output without crashes
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch {}

$REPO_ZIP_URL = "https://github.com/hernanbareirorojas-konecta/pocket-antigravity/archive/refs/heads/main.zip"
$ITEMS_TO_INSTALL = @(
    "ANTIGRAVITY.md",
    "GEMINI.md",
    "docs",
    ".geminiignore",
    ".antigravityignore",
    ".agents"
)

function Write-Banner {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  [pocket-antigravity] Token Optimization Installer" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}

# --- GLOBAL ZERO-COPY MODE ---
if ($Global) {
    Write-Banner
    Write-Host "[*] Installing in Global Zero-Copy mode..." -ForegroundColor Yellow

    $geminiConfigDir = Join-Path $HOME ".gemini\config"
    $rulesDir = Join-Path $geminiConfigDir "rules"

    if (-not (Test-Path $rulesDir)) {
        New-Item -ItemType Directory -Path $rulesDir -Force | Out-Null
    }

    # Locate source rule
    $localRule = Join-Path $PSScriptRoot ".agents\rules\token-efficiency.md"
    if (-not (Test-Path $localRule)) {
        $localRule = Join-Path (Get-Location).Path ".agents\rules\token-efficiency.md"
    }

    $targetRule = Join-Path $rulesDir "token-efficiency.md"
    $targetGemini = Join-Path $geminiConfigDir "GEMINI.md"

    if (Test-Path $localRule) {
        Copy-Item -Path $localRule -Destination $targetRule -Force
    } else {
        # Fetch directly from GitHub
        $rawRuleUrl = "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/.agents/rules/token-efficiency.md"
        Invoke-RestMethod -Uri $rawRuleUrl -OutFile $targetRule
    }

    # Also install global GEMINI.md in config if available
    $localGemini = Join-Path $PSScriptRoot "GEMINI.md"
    if (-not (Test-Path $localGemini)) {
        $localGemini = Join-Path (Get-Location).Path "GEMINI.md"
    }
    if (Test-Path $localGemini) {
        Copy-Item -Path $localGemini -Destination $targetGemini -Force
    } else {
        $rawGeminiUrl = "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/ANTIGRAVITY.md"
        Invoke-RestMethod -Uri $rawGeminiUrl -OutFile $targetGemini
    }

    Write-Host " [OK] Installed global rule: $targetRule" -ForegroundColor Green
    Write-Host " [OK] Installed global root rule: $targetGemini" -ForegroundColor Green
    Write-Host ""
    Write-Host "All Antigravity and Gemini sessions on this machine now benefit from" -ForegroundColor Green
    Write-Host "up to 95% token savings automatically across all your projects." -ForegroundColor Green
    Write-Host "No files were added to individual project repositories." -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

# --- PROJECT MODE ---
$resolvedTarget = (Resolve-Path -Path $TargetDir -ErrorAction SilentlyContinue)
if (-not $resolvedTarget) {
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
    $resolvedTarget = (Resolve-Path -Path $TargetDir).Path
} else {
    $resolvedTarget = $resolvedTarget.Path
}

Write-Banner
Write-Host "Installing pocket-antigravity into:" -ForegroundColor White
Write-Host "    $resolvedTarget" -ForegroundColor Gray
Write-Host ""

# Determine if we have local source files (Local Mode) or need to download (Remote Mode)
$sourceDir = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "ANTIGRAVITY.md")) -and (Test-Path (Join-Path $PSScriptRoot ".agents"))) {
    $sourceDir = $PSScriptRoot
} elseif ((Test-Path ".\ANTIGRAVITY.md") -and (Test-Path ".\.agents")) {
    $sourceDir = (Get-Location).Path
}

# If target is identical to source directory, avoid self-copy
if ($sourceDir -and ($resolvedTarget -eq (Resolve-Path $sourceDir).Path)) {
    Write-Host "[!] Target directory is the pocket-antigravity repository itself." -ForegroundColor Yellow
    Write-Host "    No self-copy needed. Project is already fully armed!" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Cyan
    exit 0
}

if ($sourceDir) {
    Write-Host "[1/3] Local repository detected. Copying assets directly..." -ForegroundColor Green
    foreach ($item in $ITEMS_TO_INSTALL) {
        $src = Join-Path $sourceDir $item
        $dst = Join-Path $resolvedTarget $item
        if (Test-Path $src) {
            if (Test-Path -PathType Container $src) {
                if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force | Out-Null }
                Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
            } else {
                Copy-Item -Path $src -Destination $dst -Force
            }
        }
    }
} else {
    Write-Host "[1/3] Downloading latest pocket-antigravity package..." -ForegroundColor Cyan
    $tempZip = Join-Path ([System.IO.Path]::GetTempPath()) "pocket-antigravity-main-$([guid]::NewGuid().ToString('N')).zip"
    $tempExtract = Join-Path ([System.IO.Path]::GetTempPath()) "pocket-antigravity-extract-$([guid]::NewGuid().ToString('N'))"

    try {
        Invoke-RestMethod -Uri $REPO_ZIP_URL -OutFile $tempZip
        Write-Host "[2/3] Extracting optimization configuration..." -ForegroundColor Cyan
        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

        $extractedRoot = Join-Path $tempExtract "pocket-antigravity-main"
        if (-not (Test-Path $extractedRoot)) {
            $extractedRoot = (Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1).FullName
        }

        foreach ($item in $ITEMS_TO_INSTALL) {
            $src = Join-Path $extractedRoot $item
            $dst = Join-Path $resolvedTarget $item
            if (Test-Path $src) {
                if (Test-Path -PathType Container $src) {
                    if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force | Out-Null }
                    Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
                } else {
                    Copy-Item -Path $src -Destination $dst -Force
                }
            }
        }
    } finally {
        if (Test-Path $tempZip) { Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue }
        if (Test-Path $tempExtract) { Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

# Ensure GEMINI.md exists (replicate ANTIGRAVITY.md if not present)
$antigravityFile = Join-Path $resolvedTarget "ANTIGRAVITY.md"
$geminiFile = Join-Path $resolvedTarget "GEMINI.md"
if ((Test-Path $antigravityFile) -and (-not (Test-Path $geminiFile))) {
    Copy-Item -Path $antigravityFile -Destination $geminiFile -Force
}

# Ecosystem auto-detection
Write-Host "[3/3] Detecting project ecosystem & configuring..." -ForegroundColor Cyan
$cmdTest = ""
$cmdBuild = ""
$cmdLint = ""
$framework = "Generic"

if (Test-Path (Join-Path $resolvedTarget "package.json")) {
    $cmdTest = "npm test"
    $cmdBuild = "npm run build"
    $cmdLint = "npm run lint"
    $framework = "Node / npm"
} elseif ((Test-Path (Join-Path $resolvedTarget "pyproject.toml")) -or (Test-Path (Join-Path $resolvedTarget "requirements.txt"))) {
    $cmdTest = "pytest"
    $cmdBuild = "python -m build"
    $cmdLint = "ruff check ."
    $framework = "Python (pytest)"
} elseif (Test-Path (Join-Path $resolvedTarget "Cargo.toml")) {
    $cmdTest = "cargo test"
    $cmdBuild = "cargo build"
    $cmdLint = "cargo clippy"
    $framework = "Rust (cargo)"
} elseif (Test-Path (Join-Path $resolvedTarget "go.mod")) {
    $cmdTest = "go test ./..."
    $cmdBuild = "go build ./..."
    $cmdLint = "golangci-lint run"
    $framework = "Go"
}

if ($cmdTest) {
    foreach ($docName in @("ANTIGRAVITY.md", "GEMINI.md")) {
        $docPath = Join-Path $resolvedTarget $docName
        if (Test-Path $docPath) {
            $content = [System.IO.File]::ReadAllText($docPath, [System.Text.Encoding]::UTF8)
            $placeholderCmds = "<!-- fill per project:`n- Test: pytest`n- Build: python -m build`n- Lint: ruff check .`n-->"
            $replacementCmds = "- Test: $cmdTest`n- Build: $cmdBuild`n- Lint: $cmdLint"
            $content = $content.Replace($placeholderCmds, $replacementCmds)

            $placeholderTesting = "<!-- fill per project:`n- Framework: pytest`n- Runner hook: .agents/hooks/filter_test_output.py active`n-->"
            $replacementTesting = "- Framework: $framework`n- Runner hook: .agents/hooks/filter_test_output.py active"
            $content = $content.Replace($placeholderTesting, $replacementTesting)

            [System.IO.File]::WriteAllText($docPath, $content, [System.Text.Encoding]::UTF8)
        }
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  [OK] pocket-antigravity installed successfully!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Installed assets into $resolvedTarget :" -ForegroundColor White
Write-Host "    - ANTIGRAVITY.md & GEMINI.md (lean prompt directives)" -ForegroundColor Gray
Write-Host "    - docs/ (deep guides loaded strictly on-demand)" -ForegroundColor Gray
Write-Host "    - .geminiignore & .antigravityignore (indexer shield)" -ForegroundColor Gray
Write-Host "    - .agents/ (token rules and optimization hooks)" -ForegroundColor Gray
if ($cmdTest) {
    Write-Host "  Detected ecosystem: $framework" -ForegroundColor Yellow
    Write-Host "    - Test command: $cmdTest" -ForegroundColor Gray
}
Write-Host ""
Write-Host "  Token savings (up to 95%) are active automatically in Antigravity." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
