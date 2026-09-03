#!/usr/bin/env bash
# pocket-antigravity Native Installer for macOS & Linux (Zero Python Dependency)
# Cut up to 95% token spend across Google Antigravity & Gemini agents.
set -e

REPO_TAR_URL="https://github.com/hernanbareirorojas-konecta/pocket-antigravity/archive/refs/heads/main.tar.gz"
ITEMS_TO_INSTALL=("ANTIGRAVITY.md" "GEMINI.md" "docs" ".geminiignore" ".antigravityignore" ".agents")

TARGET_DIR="."
GLOBAL_MODE=false

for arg in "$@"; do
    case "$arg" in
        --global|-g)
            GLOBAL_MODE=true
            ;;
        *)
            TARGET_DIR="$arg"
            ;;
    esac
done

echo ""
echo "============================================================"
echo "  [pocket-antigravity] Token Optimization Installer"
echo "============================================================"
echo ""

# --- GLOBAL ZERO-COPY MODE ---
if [ "$GLOBAL_MODE" = true ]; then
    echo "[*] Installing in Global Zero-Copy mode..."
    GLOBAL_CONFIG_DIR="$HOME/.gemini/config"
    GLOBAL_RULES_DIR="$GLOBAL_CONFIG_DIR/rules"
    mkdir -p "$GLOBAL_RULES_DIR"

    TARGET_RULE="$GLOBAL_RULES_DIR/token-efficiency.md"
    TARGET_GEMINI="$GLOBAL_CONFIG_DIR/GEMINI.md"

    # Locate source rule locally or download
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
    if [ -f "$SCRIPT_DIR/.agents/rules/token-efficiency.md" ]; then
        cp "$SCRIPT_DIR/.agents/rules/token-efficiency.md" "$TARGET_RULE"
        [ -f "$SCRIPT_DIR/GEMINI.md" ] && cp "$SCRIPT_DIR/GEMINI.md" "$TARGET_GEMINI" || cp "$SCRIPT_DIR/ANTIGRAVITY.md" "$TARGET_GEMINI"
    elif [ -f "./.agents/rules/token-efficiency.md" ]; then
        cp "./.agents/rules/token-efficiency.md" "$TARGET_RULE"
        [ -f "./GEMINI.md" ] && cp "./GEMINI.md" "$TARGET_GEMINI" || cp "./ANTIGRAVITY.md" "$TARGET_GEMINI"
    else
        curl -fsSL "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/.agents/rules/token-efficiency.md" -o "$TARGET_RULE"
        curl -fsSL "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/ANTIGRAVITY.md" -o "$TARGET_GEMINI"
    fi

    echo " [OK] Installed global rule: $TARGET_RULE"
    echo " [OK] Installed global root rule: $TARGET_GEMINI"
    echo ""
    echo "All Antigravity and Gemini sessions on this machine now benefit from"
    echo "up to 95% token savings automatically across all your projects."
    echo "No files were added to individual project repositories."
    echo "============================================================"
    echo ""
    exit 0
fi

# --- PROJECT MODE ---
mkdir -p "$TARGET_DIR"
RESOLVED_TARGET="$(cd "$TARGET_DIR" && pwd)"

echo "Installing pocket-antigravity into:"
echo "    $RESOLVED_TARGET"
echo ""

# Check for local source
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
SOURCE_DIR=""
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/ANTIGRAVITY.md" ] && [ -d "$SCRIPT_DIR/.agents" ]; then
    SOURCE_DIR="$SCRIPT_DIR"
elif [ -f "./ANTIGRAVITY.md" ] && [ -d "./.agents" ]; then
    SOURCE_DIR="$(pwd)"
fi

# Avoid self-copy
if [ -n "$SOURCE_DIR" ] && [ "$RESOLVED_TARGET" = "$SOURCE_DIR" ]; then
    echo "[!] Target directory is the pocket-antigravity repository itself."
    echo "    No self-copy needed. Project is already fully armed!"
    echo "============================================================"
    exit 0
fi

if [ -n "$SOURCE_DIR" ]; then
    echo "[1/3] Local repository detected. Copying assets directly..."
    for item in "${ITEMS_TO_INSTALL[@]}"; do
        if [ -e "$SOURCE_DIR/$item" ]; then
            cp -R "$SOURCE_DIR/$item" "$RESOLVED_TARGET/"
        fi
    done
else
    echo "[1/3] Downloading latest pocket-antigravity package..."
    TEMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t 'pocket-antigravity')"
    trap 'rm -rf "$TEMP_DIR"' EXIT

    curl -fsSL "$REPO_TAR_URL" | tar -xz -C "$TEMP_DIR"
    EXTRACTED_ROOT="$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"

    echo "[2/3] Extracting optimization configuration..."
    for item in "${ITEMS_TO_INSTALL[@]}"; do
        if [ -e "$EXTRACTED_ROOT/$item" ]; then
            cp -R "$EXTRACTED_ROOT/$item" "$RESOLVED_TARGET/"
        fi
    done
fi

# Ensure GEMINI.md exists
if [ -f "$RESOLVED_TARGET/ANTIGRAVITY.md" ] && [ ! -f "$RESOLVED_TARGET/GEMINI.md" ]; then
    cp "$RESOLVED_TARGET/ANTIGRAVITY.md" "$RESOLVED_TARGET/GEMINI.md"
fi

# Ecosystem auto-detection
echo "[3/3] Detecting project ecosystem & configuring..."
CMD_TEST=""
CMD_BUILD=""
CMD_LINT=""
FRAMEWORK="Generic"

if [ -f "$RESOLVED_TARGET/package.json" ]; then
    CMD_TEST="npm test"
    CMD_BUILD="npm run build"
    CMD_LINT="npm run lint"
    FRAMEWORK="Node / npm"
elif [ -f "$RESOLVED_TARGET/pyproject.toml" ] || [ -f "$RESOLVED_TARGET/requirements.txt" ]; then
    CMD_TEST="pytest"
    CMD_BUILD="python -m build"
    CMD_LINT="ruff check ."
    FRAMEWORK="Python (pytest)"
elif [ -f "$RESOLVED_TARGET/Cargo.toml" ]; then
    CMD_TEST="cargo test"
    CMD_BUILD="cargo build"
    CMD_LINT="cargo clippy"
    FRAMEWORK="Rust (cargo)"
elif [ -f "$RESOLVED_TARGET/go.mod" ]; then
    CMD_TEST="go test ./..."
    CMD_BUILD="go build ./..."
    CMD_LINT="golangci-lint run"
    FRAMEWORK="Go"
fi

if [ -n "$CMD_TEST" ]; then
    for doc in "ANTIGRAVITY.md" "GEMINI.md"; do
        DOC_PATH="$RESOLVED_TARGET/$doc"
        if [ -f "$DOC_PATH" ]; then
            if command -v python3 >/dev/null 2>&1; then
                python3 -c "
import sys
p, t, b, l, f = sys.argv[1:6]
with open(p, 'r', encoding='utf-8') as fh:
    c = fh.read()
c = c.replace('<!-- fill per project:\n- Test: pytest\n- Build: python -m build\n- Lint: ruff check .\n-->', f'- Test: {t}\n- Build: {b}\n- Lint: {l}')
c = c.replace('<!-- fill per project:\n- Framework: pytest\n- Runner hook: .agents/hooks/filter_test_output.py active\n-->', f'- Framework: {f}\n- Runner hook: .agents/hooks/filter_test_output.py active')
with open(p, 'w', encoding='utf-8') as fh:
    fh.write(c)
" "$DOC_PATH" "$CMD_TEST" "$CMD_BUILD" "$CMD_LINT" "$FRAMEWORK" 2>/dev/null || true
            fi
        fi
    done
fi

echo ""
echo "============================================================"
echo "  [OK] pocket-antigravity installed successfully!"
echo "============================================================"
echo "  Installed assets into $RESOLVED_TARGET :"
echo "    - ANTIGRAVITY.md & GEMINI.md (lean prompt directives)"
echo "    - docs/ (deep guides loaded strictly on-demand)"
echo "    - .geminiignore & .antigravityignore (indexer shield)"
echo "    - .agents/ (token rules and optimization hooks)"
if [ -n "$CMD_TEST" ]; then
    echo "  Detected ecosystem: $FRAMEWORK"
    echo "    - Test command: $CMD_TEST"
fi
echo ""
echo "  Token savings (up to 95%) are active automatically in Antigravity."
echo "============================================================"
echo ""
