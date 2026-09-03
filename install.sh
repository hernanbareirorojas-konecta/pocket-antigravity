#!/usr/bin/env bash
# pocket-antigravity One-Line Installer for macOS & Linux
set -e

INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/install.py"

if command -v python3 >/dev/null 2>&1; then
    PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python"
else
    echo "Error: Python 3 is required to install pocket-antigravity."
    exit 1
fi

$PYTHON_CMD -c "import urllib.request; exec(urllib.request.urlopen('$INSTALL_SCRIPT_URL').read().decode('utf-8'))" "$@"
