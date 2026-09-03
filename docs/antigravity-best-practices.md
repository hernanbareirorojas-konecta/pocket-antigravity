# Google Antigravity (AGY) Best Practices & Architecture Guide

A comprehensive architectural reference for building, configuring, and orchestrating Google Antigravity agents with maximum token efficiency.

---

## 1. The Antigravity Customization System

Antigravity provides 5 modular customization mechanisms. Choosing the right mechanism prevents context pollution and minimizes token consumption:

| Customization Type | Config Location | Scope | Token Impact | Best Used For |
| :--- | :--- | :--- | :--- | :--- |
| **Directory Rules** | `GEMINI.md`, `AGENTS.md`, `.agents/rules/*.md` | Hierarchical directory scope | Evaluated per turn in scope | Enforcing coding standards, file constraints, API usage |
| **Skills** | `.agents/skills/<name>/SKILL.md` | On-demand (Progressive) | Frontmatter (~50 tokens) always loaded; body loaded **only on invocation** | Multi-step runbooks, operational workflows, tool procedures |
| **Lifecycle Hooks** | `.agents/hooks.json` | Event-driven execution | Zero token cost; intercepts or modifies tool I/O | Output condensation, linting, security guardrails |
| **Plugins** | `plugins/<name>/plugin.json` | Bundle | Modular package | Distributing collections of skills, rules, and configs |
| **MCP Servers** | `mcp_config.json` | Tool integration | High: full tool schema in context on every turn | Connecting to external enterprise services |

---

## 2. Progressive Disclosure Architecture

The number one cause of context bloat is dumping reference material directly into root instructions or skill bodies.

### The Correct Pattern:
```text
.agents/skills/my-workflow/
├── SKILL.md            # Concise instructions (< 300 lines) + pointers
├── scripts/            # Executable helper scripts (0 token overhead)
└── references/         # Deep manuals, schemas (loaded strictly on-demand)
```

1. **Skill Frontmatter:** Keep `description` under 500 characters. It is used by the orchestrator to decide when to activate the skill.
2. **Body:** Provide step-by-step actions and link to external scripts or documents with markdown links.
3. **References:** Put API schemas and architectural diagrams in `references/`. The agent will only read them if needed during execution.

---

## 3. Subagents vs. Background Tasks: The Token Trade-Off

Antigravity offers two mechanisms for asynchronous and secondary execution:

### Comparison:
| Feature | Subagent (`invoke_subagent`) | Background Task (`manage_task` / `schedule`) |
| :--- | :--- | :--- |
| **Startup Cost** | **~25,000–35,000 tokens** | **0 tokens** |
| **Execution Runtime** | Independent LLM conversation loop | Local shell process |
| **Context Window** | Isolated scratchpad | Shared terminal stream |
| **Use Case** | Complex multi-domain research needing LLM reasoning | Long builds, dev servers, test suites, cron jobs |

> [!TIP]
> Never launch a subagent to run a build or test suite. Run it as a background task (`run_command` with `manage_task`) or directly through the `filter_test_output.py` hook.

---

## 4. Antigravity Slash Commands

Encourage users and agent routines to leverage native Antigravity slash commands:

- **/goal**: Activates deep, thorough multi-turn execution until the objective is completely resolved without stopping prematurely.
- **/schedule**: Configures background cron jobs or one-shot timers via the `schedule` tool without burning tokens in active wait loops.
- **/browser**: Launches visual browser automation for web scraping and UI validation.
- **/grill-me**: Initiates an interactive interview to disambiguate architecture decisions before code is written.
- **/learn**: Persists corrections and user preferences to global memory for future sessions.

---

## 5. Lifecycle Hooks (`hooks.json`)

Antigravity hooks execute shell scripts before or after agent lifecycle events:
- `PreToolUse`: Can inspect, allow, deny, or **overwrite** tool arguments before execution.
- `PostToolUse`: Can run linters or log diagnostic data after tool execution completes.
- `PreInvocation`: Injects contextual reminders before the model generates a response.
- `PostInvocation`: Runs after tool calls are executed.
- `Stop`: Clean up temporary resources on loop termination.

In `pocket-antigravity`, we leverage `PreToolUse` on `run_command` to transparently rewrite test-runner commands, running them through our lightweight Python condensation filter to strip hundreds of noisy passing test lines.
