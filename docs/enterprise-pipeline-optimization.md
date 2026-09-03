# Enterprise GenAI Pipeline Token Optimization

A technical architectural guide for engineers building and optimizing automated LLM pipelines, batch processing jobs, and agentic workflows with Gemini and Google Cloud.

---

## 1. Single-Turn (Headless Action) vs. Multi-Turn (Conversational)

When orchestrating automated workflows (e.g. backend workers, event-driven Cloud Run services, or automated review bots):

### The Single-Turn Pattern (Recommended for Pipelines):
- **Mechanism:** Deliver system instructions, input data, and expected output schema in a single, stateless request.
- **Token Impact:** Context size is strictly proportional to that specific item ($O(1)$ per turn).
- **Best For:** Data extraction, email drafting, KPI evaluation, sentiment scoring, classification.

### The Conversational Anti-Pattern:
- **Risk:** Reusing a conversational chat loop for iterative back-office tasks accumulates the entire conversation transcript across iterations.
- **Token Waste:** By iteration 10, each call sends 10x the input tokens, burning budget exponentially ($O(n^2)$ total tokens).
- **Rule:** Never reuse a conversational session for independent sequential tasks. Always instantiate fresh single-turn contexts or wipe historical dialogue turns between items.

---

## 2. Array vs. Object Serialization in Iteration Nodes

When processing collections of items (e.g. iterating over users, files, or records in parallel):

- **The Pitfall:** Many pipeline orchestrators and JSON transforms struggle with keyed dictionary objects (`{"item1": {...}, "item2": {...}}`), requiring intermediate conversion scripts that inflate latency and token payload size.
- **Best Practice:** Upstream microservices should deliver clean, uniform JSON Arrays:
  ```json
  [
    { "id": "1001", "name": "Alice", "score": 94 },
    { "id": "1002", "name": "Bob", "score": 88 }
  ]
  ```
- **Token Savings:** Arrays eliminate redundant outer keys and simplify downstream prompting. When passing large arrays to the LLM, format them as pipe-delimited tables or Markdown lists to cut token overhead by **35–50%** compared to pretty-printed JSON.

---

## 3. Pre-computation vs. Raw Prompt Dumps

A common mistake in agent pipelines is feeding raw, unprocessed data dumps into the LLM and asking the model to calculate statistics, filter records, and generate prose simultaneously.

### Anti-Pattern (Raw Dump):
```text
Here are 5,000 lines of raw server log JSON.
Calculate the average latency and summarize errors.
```
*Token Cost: ~25,000 tokens per request.*

### Optimized Pattern (Pre-calculated Payload):
1. Let your upstream service (Python, Go, Node.js) compute the math, aggregations, and metrics deterministically (latency mean, p99, error counts).
2. Inject only the high-value summary into the prompt:
```text
System Metrics:
- Total Requests: 142,500
- Mean Latency: 42ms (p99: 180ms)
- Errors: 3 (500 Internal Error)

Summarize the operational status for the morning report.
```
*Token Cost: ~120 tokens per request (99.5% reduction).*

**Rule:** LLMs are exceptional writers, classifiers, and synthesizers. Let standard code do the math and filtering; let the LLM do the reasoning and drafting.

