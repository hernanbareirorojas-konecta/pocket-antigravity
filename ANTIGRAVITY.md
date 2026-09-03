# pocket-antigravity baseline

This is the pocket-antigravity template, dropped into this project's root to minimize
token spend while working with Google Antigravity & Gemini models. It intentionally
avoids repeating the agent's default behavioral instructions to prevent burning tokens
on every turn.

## Reference Material (Read on demand ONLY)

`docs/` contains deep guides on token optimization and system integration.
`references/` contains prompt engineering cookbooks.
**Do NOT load these wholesale.** Only read specific files when actively designing
or debugging related components.

## Token Economy Rules

1. **Subagents:** Never spawn a subagent for simple lookups, single greps, or edits.
   Only invoke subagents if a task involves parallel processing across 10+ files or deep
   independent research whose output is smaller than the ~30,000-token startup cost.
2. **Context Hygiene:** Read only targeted line ranges (`StartLine`/`EndLine`). Never dump
   full logs, large CSVs, or entire files into context.
3. **Response Brevity:** Be direct, concise, and technical. Omit conversational filler
   and redundant summaries.

## Commands

<!-- Fill per project:
- Test: pytest
- Build: python -m build
- Lint: ruff check .
-->

## Architecture

<!-- Fill per project (2-3 lines max):
- Core logic lives in `src/domain/`, APIs in `src/api/`.
-->
