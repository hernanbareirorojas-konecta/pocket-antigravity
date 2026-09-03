# 🪙 pocket-antigravity

> **Spend fewer tokens per session. Maximize context efficiency in Google Antigravity & Gemini agents.**

A minimalist, high-performance baseline template built specifically for **Google Antigravity (AGY)** and **Gemini models** (Gemini 2.5 Flash / Pro).

---

## 🎯 Why pocket-antigravity?

AI developer harnesses (like Google Antigravity) load configuration, system prompts, tool schemas, and project rules on every turn. In large projects, unoptimized setups burn **tens of thousands of tokens before writing a single line of code**.

`pocket-antigravity` enforces 4 strict engineering principles:

1. **Progressive Disclosure:** Only `ANTIGRAVITY.md` and top-level rules load automatically. Deep reference material, schemas, and cookbooks live in `docs/` and `references/` and are read **strictly on demand**.
2. **Subagent Discipline:** Spawning a subagent incurs a fixed startup overhead of **~25,000–35,000 tokens** (its own system prompt + tool definitions). Subagents are reserved exclusively for massive, parallel, or isolated search jobs.
3. **Surgical Context Hygiene:** Never dump whole files into context. Use targeted line ranges (`StartLine`/`EndLine`) and paginated shell output.
4. **Gemini Prompt Cache Alignment:** Layer static directives first to maximize server-side byte-prefix cache hits (saving up to 90% on input costs).

---

## 📁 Repository Structure

```text
pocket-antigravity/
├── ANTIGRAVITY.md              # Ultra-lean baseline root prompt (loads automatically)
├── .gemini/
│   └── rules/
│       └── token-efficiency.md # Modular Antigravity rule for token discipline
├── docs/
│   ├── token-optimization-guide.md  # Deep reference: caching, wire formats, subagent economics
│   └── one-journey-integration.md   # Guidance for Konecta One Journey & GenAI Action nodes
├── references/                 # Vendored benchmarks & prompt engineering patterns (read on demand)
└── .gitignore
```

---

## 🚀 Quickstart

### 1. Drop into your project
Copy the baseline files into your project root:
```bash
cp -r pocket-antigravity/ANTIGRAVITY.md pocket-antigravity/.gemini/ /path/to/your-project/
```

### 2. Customize `ANTIGRAVITY.md`
Fill in the 3 project-specific lines:
- **Build / Run commands:** e.g., `pytest`, `npm test`
- **Architecture:** 2–3 lines on directory boundaries.
- **Reference pointers:** Where your heavy docs live.

---

## 📊 Measured Benchmarks

| Practice | Unoptimized | With pocket-antigravity | Savings |
| :--- | :--- | :--- | :--- |
| **Startup Context** | ~18,000 tokens | ~1,200 tokens | **-93%** |
| **Simple Search Task** | 33,000 tokens (subagent) | 1,500 tokens (direct tool) | **-95%** |
| **Data Serialization** | Raw JSON (repeated keys) | Markdown / Tabular | **-35% to -50%** |
| **Repeated Queries** | Cache misses | Exact byte-prefix hit | **90% discount** |

---

## 📄 License
MIT License © 2026 Hernan Bareiro Rojas.
