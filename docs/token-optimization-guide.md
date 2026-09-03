# Token Optimization Reference & Architecture Guide

A technical reference for engineers building with Google Antigravity, Gemini models, and enterprise LLM pipelines.

---

## 1. Prompt Caching Mechanics (Gemini / Vertex AI)

- **Byte-Prefix Matching:** Gemini server-side prompt caching matches exact byte prefixes of the serialized request payload.
- **Cache Economics:**
  - Cached input tokens receive up to a **90% discount** compared to standard input pricing.
  - Cache hits reduce Time-to-First-Token (TTFT) by up to 80%.
- **Layering Order (Crucial for Prefix Hits):**
  1. `Layer 0 (Static):` Core harness instructions & system rules.
  2. `Layer 1 (Static):` Tool schemas & function declarations (`view_file`, `replace_file_content`, `run_command`).
  3. `Layer 2 (Semi-static):` Domain guidelines, stable project configurations (`ANTIGRAVITY.md`).
  4. `Layer 3 (Dynamic):` Conversation turns, live user inputs, timestamps, UUIDs.
- **Cache Invalidation Pitfalls:**
  - Injecting dynamic timestamps, process IDs, or session UUIDs into the system prompt or early rules invalidates caching for the entire prompt.
  - Adding, removing, or reordering tools / MCP servers mid-session breaks prefix alignment.

---

## 2. The Subagent Economic Threshold

A frequent anti-pattern in agentic development is spawning subagents for trivial tasks (e.g., finding a function, running a single grep, or reading a single file).

### The Math:
- **Subagent Startup Cost:** ~25,000 to 35,000 tokens (re-paying the entire harness system prompt, tool definitions, and baseline rules).
- **Direct Tool Cost:** ~200 to 1,500 tokens (calling `grep_search`, `find_by_name`, or `view_file` directly in the existing context).
- **Break-even Point:** A subagent is economically justified **only** when the raw text/code to be inspected exceeds **40,000 tokens** across 10+ files and can be condensed down into a small summary before returning to the parent context.

```text
+-------------------------------------------------------------+
| Task: Find a function definition in a 500-line codebase     |
| - Via Subagent:   32,000 tokens (Startup) + 300 = 32,300    |
| - Via Direct Grep: 0 tokens (No overhead) + 50 = 50 tokens  |
| Efficiency Gain: 99.8% token reduction                      |
+-------------------------------------------------------------+
```

### When to Use Subagents vs. Alternatives:
| Task Type | Recommended Approach | Reason |
| :--- | :--- | :--- |
| Single file inspection | Direct `view_file` (with line range) | 0 startup overhead |
| Search across codebase | Direct `grep_search` / `find_by_name` | Direct tool response |
| Long-running build / test | Background task (`run_command` async) | Uses `manage_task`, 0 agent overhead |
| Massive multi-repo audit | Dedicated subagent (`invoke_subagent`) | Isolate 100k+ tokens from main context |

---

## 3. Model Routing Strategy (Gemini 2.5 Ecosystem)

| Model Tier | Optimal Workloads | Token / Cost Strategy |
| :--- | :--- | :--- |
| **Gemini 2.5 Flash Lite** | Fast mechanical grep, linting, data filtering, simple transforms | Lowest token cost, ultra-low latency |
| **Gemini 2.5 Flash** | Default workhorse: coding, debugging, refactoring, test execution | High speed, excellent reasoning, balanced cost |
| **Gemini 2.5 Pro** | Deep architectural planning, large multi-module design, complex root-cause analysis | Maximum reasoning depth; reserve for planning mode |

---

## 4. Wire Formats & Data Serialization

When passing structured datasets between backend APIs, tools, and models:

| Format | Relative Token Cost | Best Use Case |
| :--- | :--- | :--- |
| **Markdown / Tables** | -35% vs JSON | Text-heavy summaries, reports, RAG contexts |
| **TOON / Delimited** | -45% to -60% vs JSON | Uniform tabular records (e.g. agent rosters, logs) |
| **YAML** | -20% to -30% vs JSON | Hierarchical configuration files |
| **JSON** | Standard Baseline | Strict API contracts requiring machine parsing |
| **XML** | +15% vs JSON | Strict prompt boundary delimitation only |

---

## 5. Tool Minimalism & MCP Overhead

- **MCP Schema Burden:** Every connected MCP server injects its complete tool schemas on **every turn**, whether invoked or not. 3 idle MCP servers can easily consume 4,000–8,000 tokens per interaction.
- **Prefer Native CLI Tools:** Use native CLI binaries (`gh`, `gcloud`, `docker`, `git`) via `run_command` instead of heavy MCP server wrappers. The CLI costs 0 tokens when idle.
- **Output Condensation:** Test suites and build tools produce hundreds of noisy lines. Enforcing targeted test runner flags or harness prompt rules condenses output down to failure lines and summary counts, cutting 90–95% of test run tokens.

---

## 6. Context Rot & Compaction

Retrieval accuracy degrades as context windows exceed 200,000 tokens (Needle-in-a-haystack decay).
- Keep conversations focused on a single feature or bug.
- Use planning mode artifacts (`implementation_plan.md`, `walkthrough.md`) to maintain persistent state across turns without re-reading transcripts.
- Paginate shell commands (`git status -s`, piping to `head`/`Select-Object`).
