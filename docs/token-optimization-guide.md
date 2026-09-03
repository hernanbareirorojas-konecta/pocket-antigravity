# Token Optimization Reference & Architecture Guide

A technical reference for engineers building with Google Antigravity, Gemini models, and enterprise LLM pipelines.

---

## 1. Prompt Caching Mechanics (Gemini / Vertex AI & Anthropic)

- **Byte-Prefix Matching:** Prompt caching operates on an exact prefix match of the prompt payload.
- **Layering Order (Crucial):**
  1. `Layer 0 (Static):` System instructions & core rules.
  2. `Layer 1 (Static):` Tool schemas & function declarations.
  3. `Layer 2 (Semi-static):` Few-shot examples & domain reference context.
  4. `Layer 3 (Dynamic):` User inputs, live timestamps, UUIDs, conversation history.
- **Invalidation Triggers:**
  - Injecting timestamps or session IDs at the top of the prompt completely invalidates all downstream caching.
  - Adding or removing tools mid-session breaks cache alignment.

---

## 2. The Subagent Economic Threshold

A common anti-pattern is spawning subagents for trivial tasks (e.g., reading a single file or running a grep).

### The Math:
- **Subagent Startup Cost:** ~20,000 to 35,000 tokens (re-paying tool schemas + harness system prompt).
- **Direct Tool Cost:** ~200 to 1,500 tokens.
- **Break-even Point:** A subagent is only economically viable if the raw content to be reviewed exceeds **40,000 tokens** and can be condensed down into a small summary before returning to the parent context.

```
+-------------------------------------------------------------+
| Task: Find a function definition in a 500-line codebase     |
| - Via Subagent:   33,000 tokens (Startup) + 500 = 33,500    |
| - Via Direct Grep: 0 tokens (No overhead) + 50 = 50 tokens  |
| Efficiency Gain: 99.8% token reduction                      |
+-------------------------------------------------------------+
```

---

## 3. Wire Formats & Data Serialization

When passing structured datasets between backend APIs and LLMs:

| Format | Relative Token Cost | Best Use Case |
| :--- | :--- | :--- |
| **Markdown / Tables** | Baseline (-35% vs JSON) | Text-heavy summaries, reports, RAG contexts |
| **TOON / Delimited** | -45% to -60% vs JSON | Uniform tabular records (e.g. agent rosters) |
| **YAML** | -20% to -30% vs JSON | Nested configuration files |
| **JSON** | Standard | Strict API contracts requiring machine parsing |
| **XML** | +15% vs JSON | Strict prompt section delimiter only |

---

## 4. Context Rot & Compaction

LLM retrieval precision drops as context windows grow beyond 200k tokens (Needle-in-a-haystack decay).
- Keep conversations focused on a single feature or debugging cycle.
- Reset sessions or archive past completed phases when starting distinct tasks.
- Avoid large raw terminal dumps (use `Select-Object -First 10` or `tail -n 20`).
