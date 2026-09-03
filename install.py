#!/usr/bin/env python3
"""
pocket-antigravity One-Line Installer
Zero-dependency installer that injects pocket-antigravity into any project in seconds.
Supports Windows, macOS, and Linux.
"""

import io
import os
import shutil
import sys
import zipfile
import urllib.request

REPO_ZIP_URL = "https://github.com/hernanbareirorojas-konecta/pocket-antigravity/archive/refs/heads/main.zip"
ZIP_ROOT_PREFIX = "pocket-antigravity-main/"

ITEMS_TO_INSTALL = [
    "ANTIGRAVITY.md",
    "GEMINI.md",
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


def main():
    target_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else ".")
    print("\n" + "=" * 60)
    print("  🪙  Installing pocket-antigravity into:")
    print(f"      {target_dir}")
    print("=" * 60 + "\n")

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

            # Check if this item matches one of the items to install
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

    print("[3/3] Detecting project ecosystem & configuring...")
    detected = detect_ecosystem(target_dir)
    apply_detected_commands(target_dir, detected)

    print("\n" + "✓" * 60)
    print("  🎉 pocket-antigravity installed successfully!")
    print("=" * 60)
    print("  Installed assets:")
    print("    • ANTIGRAVITY.md & GEMINI.md (~35 lines lean instructions)")
    print("    • .geminiignore & .antigravityignore (indexer firewall)")
    print("    • .agents/ (test condensation hook & token rules)")
    if detected["test"]:
        print(f"  Detected ecosystem: {detected['framework']}")
        print(f"    • Test command: {detected['test']}")
    print("\n  👉 You're all set! Open Google Antigravity and start coding.")
    print("     Token savings (up to 95%) are active automatically.")
    print("=" * 60 + "\n")


if __name__ == "__main__":
    main()
