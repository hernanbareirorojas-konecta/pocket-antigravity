# One Journey (OJ) Integration & Token Optimization

Guidance for Prompt Engineers integrating Google Cloud / Gemini with Konecta One Journey workflows.

---

## 1. Node Selection: GenAI Action vs. GenAI Chat

- **GenAI Action (Headless/Back-office):**
  - **Best for:** Asynchronous email generation, sentiment scoring, data extraction, feedback drafting.
  - **Token Optimization:** Runs in single-turn mode. Does not accumulate session conversational history.
  - **Destination Property:** Assign directly to `$.agente_actual.texto_corporativo` or similar, avoiding redundant JSON wrappers.

- **GenAI Chat (Conversational):**
  - **Best for:** Interactive virtual agents, live customer messaging.
  - **Token Risk:** Loops keep full transcript in memory. Use `@WAIT` and timeout limits carefully to avoid unbounded token accumulation.

---

## 2. Array vs. Object Pitfall in Foreach Nodes

- **The Issue:** The OJ `node-for-each` requires a strict Array (`[]`), not a Keyed Object (`{}`).
- **Best Practice:** The upstream Python Cloud Run / Cloud Function should deliver:
  ```json
  {
    "agentes": [
      { "id": "60050003", "nombre": "ROSA", "indicadores": { ... } }
    ]
  }
  ```
  Passing an array directly eliminates the need for intermediate `node-json-data-transform` scripts, removing points of failure and reducing platform latency.

---

## 3. Handlebars Injection vs. Raw Prompts

- Inject only necessary properties into prompt templates:
  - `{{agente_actual.nombre}}`
  - `{{agente_actual.indicadores.tasa_reconduccion}}`
- Avoid injecting large raw JSON blocks into prompts. Let Python calculate KPIs upfront so the LLM acts purely as a coach/writer rather than a calculator.
