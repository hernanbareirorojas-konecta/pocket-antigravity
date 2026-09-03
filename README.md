<div align="center">

<img src="logo/pocket-antigravity-logo.jpg" alt="pocket-antigravity banner" width="100%" />

# 🪙 pocket-antigravity

**Minimalist token optimization framework for Google Antigravity & Gemini models.**  
*Cut up to 95% of wasted tokens across turns, background indexers, and subagents.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

</div>

---

## 🎯 Pure Markdown. Zero Scripts. Zero Dependencies.

`pocket-antigravity` is **100% pure Markdown and configuration files**.

- ❌ **No installer scripts** (no `.sh`, `.ps1`, or `.py`)
- ❌ **No terminal commands or execution privileges required**
- ❌ **No runtime dependencies** (no Python, Node, etc.)

Token savings are achieved strictly through **prompt engineering, context discipline, and indexer exclusion rules** loaded and interpreted natively by Google Antigravity and Gemini models.

---

## 📦 The Fundamental Files (What to download)

You only need to download or copy these core files into your project:

| File / Folder | Purpose & Token Savings |
| :--- | :--- |
| **[`ANTIGRAVITY.md`](ANTIGRAVITY.md)** *(or [`GEMINI.md`](GEMINI.md))* | **Lean Root Directive (~35 lines):** Replaces verbose system instructions. Enforces progressive disclosure, subagent economics, and context hygiene. |
| **[`.geminiignore`](.geminiignore)** & **[`.antigravityignore`](.antigravityignore)** | **Indexer Firewall:** Blocks Antigravity from burning tens of thousands of tokens indexing `node_modules/`, lockfiles (`package-lock.json`), binaries, and logs. |
| **[`.agents/rules/token-efficiency.md`](.agents/rules/token-efficiency.md)** | **Agent Behavioral Rules:** Hard guidelines for subagents (~30k token economic threshold), targeted line slicing (`StartLine`/`EndLine`), and direct answers. |
| **[`docs/`](docs/)** *(Optional)* | **On-Demand Reference Guides:** Technical documentation (caching, benchmarks, architecture). Loaded strictly when the agent is actively designing or debugging, never upfront. |

---

## 🚀 How to Use It

### Option 1: Drop into Your Project (Recommended)

Simply download or copy the fundamental files into your project root:

```text
your-project/
├── ANTIGRAVITY.md              # Root instructions (~35 lines)
├── GEMINI.md                   # Dual root rule file (mirrors ANTIGRAVITY.md)
├── .geminiignore               # Excludes dependencies & lockfiles from indexer
├── .antigravityignore          # IDE/CLI indexer exclusions
├── .agents/
│   └── rules/
│       └── token-efficiency.md # Subagent & context discipline rules
└── docs/                       # (Optional) Reference guides loaded on demand
```

**That's it!** Open Google Antigravity in your project. It will automatically discover the files and enforce the token-saving rules immediately.

> **💡 Quick Tip:** In `ANTIGRAVITY.md`, optionally fill in the 3 commented command lines (`Test`, `Build`, `Lint`) for your project, or simply tell Antigravity in the chat:
> *"Read ANTIGRAVITY.md and configure the test and build commands for this project."*

---

### Option 2: Global Zero-Copy (No files added to your project)

If you work on client repositories, shared corporate repos, or open-source projects where you cannot commit external files, configure your rules globally once:

Copy `token-efficiency.md` and `GEMINI.md` directly into your user's Antigravity configuration directory:

- **Windows:**
  - Put `token-efficiency.md` into `C:\Users\<YourUser>\.gemini\config\rules\token-efficiency.md`
  - Put `ANTIGRAVITY.md` into `C:\Users\<YourUser>\.gemini\config\GEMINI.md`
- **macOS / Linux:**
  - Put `token-efficiency.md` into `~/.gemini/config/rules/token-efficiency.md`
  - Put `ANTIGRAVITY.md` into `~/.gemini/config/GEMINI.md`

Every Antigravity session on your machine will automatically benefit from token optimization across all your projects without modifying any git repository.

---

## 📊 Benchmarks (Measured, Not Vibes)

| Metric | Without pocket-antigravity | With pocket-antigravity | Reduction |
| :--- | :--- | :--- | :--- |
| **Startup Prompt Overhead** | ~18,500 tokens | **~850 tokens** | **-95.4%** |
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
├── .agents/                                # Antigravity rules directory
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
