<div align="center">

<img src="logo/pocket-antigravity-logo.jpg" alt="pocket-antigravity banner" width="100%" />

# 🪙 pocket-antigravity

**Minimalist token optimization framework for Google Antigravity & Gemini models.**  
*Cut up to 95% of wasted tokens across turns, test runs, background indexers, and subagents.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

</div>

---

## 🚀 Quickstart

`pocket-antigravity` is **100% native with ZERO Python dependency**. It consists of lean markdown directives, indexer firewalls, and optimization rules.

### Option 1: Per-Project Installation (Recommended)

Run inside the root of any existing or new project:

**Linux / macOS (Native Bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/install.sh | bash
```

**Windows (Native PowerShell):**
```powershell
irm https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/install.ps1 | iex
```

*That's it!* The installer copies the baseline instructions, sets up `.geminiignore`, and auto-configures `ANTIGRAVITY.md` and `GEMINI.md` for your detected project ecosystem (Node/npm, Python, Rust, Go).

---

### Option 2: Global Zero-Copy Installation (No files added to repos)

Ideal for consultants, agencies, or client repositories where you cannot commit files into their git history. Installs rules globally into `~/.gemini/config/`:

**Linux / macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/install.sh | bash -s -- --global
```

**Windows (PowerShell):**
```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/hernanbareirorojas-konecta/pocket-antigravity/main/install.ps1))) -Global
```
*(Or if you have the repo cloned locally: `.\install.ps1 -Global`)*

---

<details>
<summary><strong>Manual Installation (Direct Copy without scripts)</strong></summary>

```bash
cp -r pocket-antigravity/ANTIGRAVITY.md \
      pocket-antigravity/GEMINI.md \
      pocket-antigravity/docs/ \
      pocket-antigravity/.geminiignore \
      pocket-antigravity/.antigravityignore \
      pocket-antigravity/.agents/ \
      /path/to/your-project/
```
Then ask Antigravity in your chat: *"Run pocket-init"*
</details>

---

## 📊 Benchmarks (Measured, Not Vibes)

| Metric | Without pocket-antigravity | With pocket-antigravity | Reduction |
| :--- | :--- | :--- | :--- |
| **Startup Prompt Overhead** | ~18,500 tokens | **~850 tokens** | **-95.4%** |
| **Test Output (220 tests)** | 244 lines (4,450 tokens) | **16 lines (210 tokens)** | **-95.3%** |
| **Targeted Code Search** | ~32,850 tokens (subagent) | **185 tokens (direct grep)** | **-99.4%** |
| **Data Serialization (50 items)** | 4,210 tokens (raw JSON) | **1,890 tokens (pipe table)** | **-55.1%** |
| **Repeated Queries** | Full input cost ($0.15/MTok) | Exact byte-prefix match | **90% cache discount** |

---

## ⚡ How It Works

1. **🧩 Progressive Disclosure:** Ultra-lean root instructions (~35 lines) in `ANTIGRAVITY.md` & `GEMINI.md`. Deep reference guides in `docs/` are loaded strictly on demand.
2. **🤖 Subagent Discipline:** Prevents spawning ~30k-token subagents for routine edits or searches.
3. **🧱 Indexer Firewall:** `.geminiignore` and `.antigravityignore` block huge lockfiles, dependencies (`node_modules/`), and coverage files from being parsed into context.
4. **🎯 Surgical Context Hygiene:** Enforces reading targeted line slices (`StartLine`/`EndLine`) instead of dumping entire files.
5. **⚡ Prompt Cache Alignment:** Maintains byte-prefix stability to maximize Vertex AI 90% prompt caching discounts.
6. **🧪 Test Condenser Hook (Optional):** A lightweight hook (`.agents/hooks/filter_test_output.py`) can intercept test runs (`pytest`, `npm test`, `cargo test`, `vitest`, etc.) to strip noisy passing tests. *Note: This is strictly optional—the core framework is 100% prompt engineering and Markdown with zero runtime requirements.*

---

## 📁 Repository Structure

```text
pocket-antigravity/
├── logo/
│   └── pocket-antigravity-logo.jpg         # Banner asset
├── ANTIGRAVITY.md                          # Ultra-lean instructions (~35 lines)
├── GEMINI.md                               # Dual root rule file
├── .geminiignore                           # Indexer exclusions (lockfiles, dependencies)
├── .antigravityignore                      # IDE/CLI indexer exclusions
├── .agents/                                # Customization directory
│   ├── hooks.json                          # PreToolUse test filter hook
│   ├── hooks/filter_test_output.py         # Cross-platform test condenser
│   ├── rules/token-efficiency.md           # Context & subagent discipline rules
│   └── skills/pocket-init/SKILL.md         # Auto-initialization skill
├── docs/                                   # On-demand reference guides
│   ├── benchmarks.md                       # Measured savings breakdown
│   ├── token-optimization-guide.md         # Gemini caching & subagent math
│   ├── antigravity-best-practices.md        # AGY customization best practices
│   └── enterprise-pipeline-optimization.md # Batch & pipeline patterns
├── LICENSE                                 # MIT License
└── README.md
```

---

## 📄 License

MIT License © 2026 Hernan Bareiro Rojas.
Contributions and PRs are welcome!
