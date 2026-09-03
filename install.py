#!/usr/bin/env python3
"""
pocket-antigravity Installer
Zero-dependency Python installer that injects pocket-antigravity into any project
or installs rules globally for Google Antigravity & Gemini agents.
Supports Windows, macOS, and Linux without external libraries.
"""

import io
import os
import shutil
import sys
import zipfile
import urllib.request

# Safe UTF-8 console output on Windows to prevent UnicodeEncodeError
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except AttributeError:
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8", errors="replace")

REPO_ZIP_URL = "https://github.com/hernanbareirorojas-konecta/pocket-antigravity/archive/refs/heads/main.zip"
ZIP_ROOT_PREFIX = "pocket-antigravity-main/"

ITEMS_TO_INSTALL = [
    "ANTIGRAVITY.md",
    "GEMINI.md",
    "docs",
    ".geminiignore",
    ".antigravityignore",
    ".agents",
]


def detect_ecosystem(target_dir):
    """Detect ecosystem and populate commands automatically."""
    commands = {"test": "", "build": "", "lint": "", "framework": "Generic"}

    pkg_json = os.path.join(target_dir, "package.json")
    pyproject = os.path.join(target_dir, "pyproject.toml")
    cargo_toml = os.path.join(target_dir, "Cargo.toml")
    go_mod = os.path.join(target_dir, "go.mod")

    if os.path.exists(pkg_json):
        commands["test"] = "npm test"
        commands["build"] = "npm run build"
        commands["lint"] = "npm run lint"
        commands["framework"] = "Node / npm"
    elif os.path.exists(pyproject) or os.path.exists(os.path.join(target_dir, "requirements.txt")):
        commands["test"] = "pytest"
        commands["build"] = "python -m build"
        commands["lint"] = "ruff check ."
        commands["framework"] = "Python (pytest)"
    elif os.path.exists(cargo_toml):
        commands["test"] = "cargo test"
        commands["build"] = "cargo build"
        commands["lint"] = "cargo clippy"
        commands["framework"] = "Rust (cargo)"
    elif os.path.exists(go_mod):
        commands["test"] = "go test ./..."
        commands["build"] = "go build ./..."
        commands["lint"] = "golangci-lint run"
        commands["framework"] = "Go"

    return commands


def apply_detected_commands(target_dir, commands):
    """Update placeholders in ANTIGRAVITY.md and GEMINI.md if detected."""
    for filename in ["ANTIGRAVITY.md", "GEMINI.md"]:
        filepath = os.path.join(target_dir, filename)
        if not os.path.exists(filepath):
            continue

        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()

            if commands["test"]:
                new_cmds = (
                    f"- Test: {commands['test']}\n"
                    f"- Build: {commands['build']}\n"
                    f"- Lint: {commands['lint']}"
                )
                content = content.replace("<!-- fill per project:\n- Test: pytest\n- Build: python -m build\n- Lint: ruff check .\n-->", new_cmds)

                new_testing = (
                    f"- Framework: {commands['framework']}\n"
                    f"- Runner hook: .agents/hooks/filter_test_output.py active"
                )
                content = content.replace("<!-- fill per project:\n- Framework: pytest\n- Runner hook: .agents/hooks/filter_test_output.py active\n-->", new_testing)

                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(content)
        except Exception:
            pass


def install_global():
    """Install token efficiency rules globally to ~/.gemini/config/."""
    home_dir = os.path.expanduser("~")
    config_dir = os.path.join(home_dir, ".gemini", "config")
    rules_dir = os.path.join(config_dir, "rules")
    os.makedirs(rules_dir, exist_ok=True)

    print("\n" + "=" * 60)
    print("  [pocket-antigravity] Global Zero-Copy Installer")
    print("=" * 60 + "\n")
    print("[*] Installing rules globally into:")
    print(f"    {config_dir}\n")

    # Locate source rule locally or download
    script_dir = os.path.dirname(os.path.abspath(__file__))
    local_rule = os.path.join(script_dir, ".agents", "rules", "token-efficiency.md")
    local_gemini = os.path.join(script_dir, "GEMINI.md")
    if not os.path.exists(local_gemini):
        local_gemini = os.path.join(script_dir, "ANTIGRAVITY.md")

    target_rule = os.path.join(rules_dir, "token-efficiency.md")
    target_gemini = os.path.join(config_dir, "GEMINI.md")

    if os.path.exists(local_rule):
        shutil.copy2(local_rule, target_rule)
        shutil.copy2(local_gemini, target_gemini)
    else:
        raw_rule_url = "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/.agents/rules/token-efficiency.md"
        raw_gemini_url = "https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/ANTIGRAVITY.md"
        req1 = urllib.request.Request(raw_rule_url, headers={"User-Agent": "pocket-antigravity-installer"})
        with urllib.request.urlopen(req1) as resp, open(target_rule, "wb") as f:
            f.write(resp.read())
        req2 = urllib.request.Request(raw_gemini_url, headers={"User-Agent": "pocket-antigravity-installer"})
        with urllib.request.urlopen(req2) as resp, open(target_gemini, "wb") as f:
            f.write(resp.read())

    print("  [OK] Installed global rule: " + target_rule)
    print("  [OK] Installed global root rule: " + target_gemini)
    print("\n" + "=" * 60)
    print("  All Antigravity and Gemini sessions on this machine now benefit from")
    print("  up to 95% token savings automatically across all projects.")
    print("  No files were added to individual project repositories.")
    print("=" * 60 + "\n")


def copy_tree_contents(src_dir, dst_dir):
    """Copy all items from src_dir to dst_dir recursively."""
    os.makedirs(dst_dir, exist_ok=True)
    for root, dirs, files in os.walk(src_dir):
        rel_path = os.path.relpath(root, src_dir)
        target_root = dst_dir if rel_path == "." else os.path.join(dst_dir, rel_path)
        os.makedirs(target_root, exist_ok=True)
        for f in files:
            shutil.copy2(os.path.join(root, f), os.path.join(target_root, f))


def main():
    args = sys.argv[1:]
    if "--global" in args or "-g" in args:
        install_global()
        return

    target_dir = os.path.abspath(args[0] if args else ".")
    print("\n" + "=" * 60)
    print("  [pocket-antigravity] Token Optimization Installer")
    print("=" * 60 + "\n")
    print("  Installing pocket-antigravity into:")
    print(f"      {target_dir}\n")

    script_dir = os.path.dirname(os.path.abspath(__file__))
    is_local_repo = (
        os.path.exists(os.path.join(script_dir, "ANTIGRAVITY.md"))
        and os.path.exists(os.path.join(script_dir, ".agents"))
    )

    if is_local_repo and os.path.abspath(target_dir) == script_dir:
        print("[!] Target directory is the pocket-antigravity repository itself.")
        print("    No self-copy needed. Project is already fully armed!\n")
        return

    if is_local_repo:
        print("[1/3] Local repository detected. Copying assets directly...")
        for item in ITEMS_TO_INSTALL:
            src = os.path.join(script_dir, item)
            dst = os.path.join(target_dir, item)
            if not os.path.exists(src):
                continue
            if os.path.isdir(src):
                copy_tree_contents(src, dst)
            else:
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                shutil.copy2(src, dst)
    else:
        print("[1/3] Downloading latest pocket-antigravity package...")
        try:
            req = urllib.request.Request(
                REPO_ZIP_URL,
                headers={"User-Agent": "pocket-antigravity-installer"}
            )
            with urllib.request.urlopen(req) as resp:
                zip_bytes = resp.read()
        except Exception as e:
            print(f"Error downloading package: {e}")
            sys.exit(1)

        print("[2/3] Extracting optimization configuration...")
        with zipfile.ZipFile(io.BytesIO(zip_bytes)) as z:
            for member in z.namelist():
                if not member.startswith(ZIP_ROOT_PREFIX):
                    continue

                rel_path = member[len(ZIP_ROOT_PREFIX):]
                if not rel_path:
                    continue

                top_level = rel_path.split("/")[0]
                if top_level not in ITEMS_TO_INSTALL:
                    continue

                target_path = os.path.join(target_dir, rel_path.replace("/", os.sep))

                if member.endswith("/"):
                    os.makedirs(target_path, exist_ok=True)
                else:
                    os.makedirs(os.path.dirname(target_path), exist_ok=True)
                    with z.open(member) as src, open(target_path, "wb") as dst:
                        shutil.copyfileobj(src, dst)

    # Ensure GEMINI.md exists
    antigravity_path = os.path.join(target_dir, "ANTIGRAVITY.md")
    gemini_path = os.path.join(target_dir, "GEMINI.md")
    if os.path.exists(antigravity_path) and not os.path.exists(gemini_path):
        shutil.copy2(antigravity_path, gemini_path)

    print("[3/3] Detecting project ecosystem & configuring...")
    detected = detect_ecosystem(target_dir)
    apply_detected_commands(target_dir, detected)

    print("\n" + "=" * 60)
    print("  [OK] pocket-antigravity installed successfully!")
    print("=" * 60)
    print(f"  Installed assets into {target_dir} :")
    print("    - ANTIGRAVITY.md & GEMINI.md (lean prompt directives)")
    print("    - docs/ (deep guides loaded strictly on-demand)")
    print("    - .geminiignore & .antigravityignore (indexer shield)")
    print("    - .agents/ (token rules and optimization hooks)")
    if detected["test"]:
        print(f"  Detected ecosystem: {detected['framework']}")
        print(f"    - Test command: {detected['test']}")
    print("\n  Token savings (up to 95%) are active automatically in Antigravity.")
    print("=" * 60 + "\n")


if __name__ == "__main__":
    main()
