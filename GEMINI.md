# pocket-antigravity baseline

This is the pocket-antigravity baseline template for Google Antigravity & Gemini models.
It minimizes token expenditure across turns by enforcing progressive disclosure and eliminating
redundant harness instructions.

## Reference Material (Read on demand ONLY)

- `docs/`: In-depth guides on prompt caching, subagent economics, benchmarks, and best practices.
**Do NOT load these wholesale.** Read specific files only when actively designing or debugging.

## Token Economy Rules

1. **Subagents:** Never spawn a subagent for routine lookups, single greps, or file edits.
   A subagent costs ~25,000–35,000 tokens of startup overhead. Only invoke subagents for massive,
   isolated, parallel research across 10+ directories where output is smaller than the overhead.
2. **Context Hygiene:** Read only targeted line slices (`StartLine`/`EndLine`). Never dump raw logs,
   large CSVs, or entire multi-hundred line files into context.
3. **Response Brevity:** Be direct, concise, and technical. Omit conversational filler, boilerplate
   introductions, and redundant summaries of artifacts.

## Commands

<!-- fill per project:
- Test: pytest
- Build: python -m build
- Lint: ruff check .
-->

## Architecture

<!-- fill per project (2-3 lines max):
- Core logic in `src/domain/`, APIs in `src/api/`.
-->

## Testing

<!-- fill per project:
- Framework: pytest
- Runner hook: .agents/hooks/filter_test_output.py active
-->
