#!/usr/bin/env python3
"""
pocket-antigravity test output condensation hook.
Cross-platform: Works natively on Windows (PowerShell/CMD), macOS, and Linux without jq/awk.

Modes:
1. Hook mode (default): Reads PreToolUse JSON on stdin from Antigravity.
   If CommandLine matches a test runner outside quotes, rewrites CommandLine
   to run through this script in runner mode.
2. Runner mode (--run-b64 <base64> or --run <command>):
   Executes the original test command, streams combined stdout/stderr,
   suppresses verbose passing lines, and displays failures + summary.
   Propagates the child process exit code.
"""

import sys
import os
import re
import json
import base64
import subprocess

FAIL_PATTERNS = [
    r"fail",
    r"error",
    r"traceback",
    r"assertionerror",
    r"panic:",
    r"exception",
    r"fatal",
    r"✕",
    r"✗",
    r"err!",
    r"failures?:\s*\d+",
    r"failed\s+in",
    r"short test summary info",
    r"passed.*failed",
    r"passed in \d+",
    r"tests?:.*passed",
    r"ran \d+ test",
    r"test result: (FAILED|ok)",
]
FAIL_REGEX = re.compile("|".join(FAIL_PATTERNS), re.IGNORECASE)


def is_inside_quotes(cmd: str, match_pos: int) -> bool:
    """Check if match_pos in cmd falls inside an unclosed single or double quote."""
    prefix = cmd[:match_pos]
    dq_count = prefix.count('"')
    sq_count = prefix.count("'")
    return (dq_count % 2 == 1) or (sq_count % 2 == 1)


def matches_test_pattern(cmd: str, patterns_path: str) -> bool:
    """Return True if cmd contains any test runner pattern outside quotes."""
    if not os.path.isfile(patterns_path):
        return False
    cmd_lower = cmd.lower()
    try:
        with open(patterns_path, "r", encoding="utf-8") as f:
            for line in f:
                pattern = line.strip()
                if not pattern or pattern.startswith("#"):
                    continue
                p_lower = pattern.lower()
                pos = cmd_lower.find(p_lower)
                if pos != -1 and not is_inside_quotes(cmd, pos):
                    return True
    except Exception:
        return False
    return False


def run_test_command(original_cmd: str) -> int:
    """Run original command, condense output to failure lines + count summary."""
    proc = subprocess.Popen(
        original_cmd,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
    )

    total_lines = 0
    kept_lines = []
    all_lines = []
    traceback_buffer_remaining = 0

    while True:
        line = proc.stdout.readline()
        if not line and proc.poll() is not None:
            break
        if not line:
            continue

        total_lines += 1
        all_lines.append(line)
        line_clean = line.strip()

        # If we are in an active traceback / failure block, keep the next lines
        if traceback_buffer_remaining > 0:
            kept_lines.append(line)
            traceback_buffer_remaining -= 1
            continue

        if FAIL_REGEX.search(line_clean):
            kept_lines.append(line)
            # If line introduces a traceback or failure, capture subsequent lines
            if any(term in line_clean.lower() for term in ["traceback", "failures:", "failed:"]):
                traceback_buffer_remaining = 15
            elif "assertionerror" in line_clean.lower():
                traceback_buffer_remaining = 5

    proc.wait()
    returncode = proc.returncode

    # Safety: If tests failed or had error but filter was too aggressive, show the last lines
    if returncode != 0 and len(kept_lines) == 0:
        kept_lines = all_lines[-25:] if len(all_lines) > 25 else all_lines

    # Output condensed results
    for l in kept_lines:
        sys.stdout.write(l)

    summary_note = f"\n[pocket-antigravity condensed: {len(kept_lines)}/{total_lines} lines shown]\n"
    sys.stdout.write(summary_note)
    sys.stdout.flush()

    return returncode


def handle_hook_mode():
    """Handle Antigravity PreToolUse hook on run_command."""
    try:
        raw_input = sys.stdin.read()
        if not raw_input.strip():
            print(json.dumps({"decision": "allow"}))
            return

        data = json.loads(raw_input)
    except Exception:
        print(json.dumps({"decision": "allow"}))
        return

    # Extract CommandLine argument
    cmd = data.get("toolCall", {}).get("args", {}).get("CommandLine", "")
    if not cmd or "--run-b64" in cmd or "--pocket-filter-active" in cmd:
        print(json.dumps({"decision": "allow"}))
        return

    # Locate test-patterns.txt relative to this script
    script_dir = os.path.dirname(os.path.abspath(__file__))
    patterns_file = os.path.join(script_dir, "test-patterns.txt")

    if not matches_test_pattern(cmd, patterns_file):
        print(json.dumps({"decision": "allow"}))
        return

    # Encode command into base64 to avoid shell escaping issues across all platforms
    b64_cmd = base64.b64encode(cmd.encode("utf-8")).decode("ascii")
    # Determine hook script path relative to workspace
    workspace_paths = data.get("workspacePaths", [])
    if workspace_paths and os.path.isabs(workspace_paths[0]):
        try:
            hook_script = os.path.relpath(os.path.abspath(__file__), workspace_paths[0]).replace("\\", "/")
        except Exception:
            hook_script = ".agents/hooks/filter_test_output.py"
    else:
        hook_script = ".agents/hooks/filter_test_output.py"

    rewritten_cmd = f"python {hook_script} --run-b64 {b64_cmd}"

    response = {
        "decision": "allow",
        "overwrite": {
            "CommandLine": rewritten_cmd
        }
    }
    print(json.dumps(response))


def main():
    if len(sys.argv) >= 3 and sys.argv[1] == "--run-b64":
        try:
            cmd = base64.b64decode(sys.argv[2].encode("ascii")).decode("utf-8")
        except Exception as e:
            sys.stderr.write(f"Error decoding base64 test command: {e}\n")
            sys.exit(1)
        sys.exit(run_test_command(cmd))
    elif len(sys.argv) >= 3 and sys.argv[1] == "--run":
        cmd = " ".join(sys.argv[2:])
        sys.exit(run_test_command(cmd))
    else:
        handle_hook_mode()


if __name__ == "__main__":
    main()
