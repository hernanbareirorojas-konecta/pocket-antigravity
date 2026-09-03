# Antigravity Rule: Token Efficiency & Context Discipline

## Directives for Agent Execution

1. **Direct Tools Over Subagents (Economic Threshold):**
   - Subagents incur a fixed startup overhead of ~25,000–35,000 tokens (re-paying tool schemas and system prompts).
   - Use direct tools (`view_file` with line slices, `grep_search`, `find_by_name`, `run_command`) for all routine lookups, inspections, and file edits.
   - Only spawn subagents for genuinely decoupled parallel research across 10+ directories or tasks where output is significantly smaller than the ~30,000-token startup cost.
   - For long-running CLI processes, use asynchronous background tasks (`manage_task`), NOT subagents.

2. **Surgical Context Hygiene:**
   - Always specify `StartLine` and `EndLine` in `view_file` for files exceeding 100 lines.
   - Use targeted regex in `grep_search` and `find_by_name` rather than recursively listing entire directory trees.
   - Do not dump large data blobs, raw CSVs, or unpaginated logs into context.

3. **Response Brevity & Zero Echo:**
   - Never repeat or re-summarize content already present in artifacts or tool outputs.
   - Omit conversational pleasantries, introductory remarks, and boilerplate summaries.
   - Use direct technical bullet points, tables, and code snippets.

4. **Prompt Caching Alignment (Gemini / Vertex AI):**
   - Maintain static system prompts and tool schemas at the byte prefix to maximize cache hits (90% discount on input tokens).
   - Never inject timestamps, random IDs, or changing session metadata into top-level instructions.
