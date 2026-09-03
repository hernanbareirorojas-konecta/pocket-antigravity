# Antigravity Rule: Token Efficiency & Context Discipline

## Directives for Agent Execution
1. **Direct Tool Execution Over Subagents:**
   - A subagent call carries a fixed overhead of ~25,000 to ~35,000 tokens (own tool schemas + system instructions).
   - Use direct tools (`view_file` with ranges, `grep_search`, `run_command`) for all routine research and edits.
   - Only launch a subagent when truly parallelizing workloads across multiple distinct domains.

2. **Surgical File Operations:**
   - Always specify `StartLine` and `EndLine` when reading files larger than 100 lines.
   - Use targeted regex in `grep_search` rather than reading entire directory listings.

3. **Concise User Communication:**
   - Avoid echoing back full files or repeating explanations already presented in artifacts.
   - Use direct bullet points and code blocks rather than conversational prose.

4. **Prompt Caching Alignment:**
   - Preserve static system prompts and instructions at the top level.
   - Keep dynamic timestamps, random IDs, and user turn data at the bottom of payloads to prevent cache invalidation on the model provider side.
