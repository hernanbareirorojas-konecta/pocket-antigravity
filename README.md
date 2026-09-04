<div align="center">

<img src="logo/pocket-antigravity-logo.jpg" alt="pocket-antigravity banner" width="100%" />

# 🪙 pocket-antigravity

**La guía definitiva y kit Markdown para recortar hasta un 95% del consumo de tokens en Google Antigravity & Gemini.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Pure Markdown](https://img.shields.io/badge/Built%20With-Pure%20Markdown-blue.svg?style=flat-square)](#)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero-brightgreen.svg?style=flat-square)](#)

</div>

---

## 🧐 ¿Por qué Antigravity gasta tantos tokens?

| Causa | El Problema Oculto | Despilfarro Real |
| :--- | :--- | :--- |
| 🤖 **Subagentes Innecesarios** | Lanzar subagentes para búsquedas cotidianas o editar un archivo. | **+25.000 a 35.000 tokens** fijos por subagente en prompts y esquemas. |
| 📄 **Volcado Ciego de Archivos** | Leer archivos enteros de cientos de líneas en vez de rangos específicos. | **+3.000 a 8.000 tokens** por lectura que colapsan la atención del modelo. |
| 🧱 **Indexador Hambriento** | Antigravity parsea `node_modules/`, `.git/` o lockfiles gigantes en segundo plano. | **Decenas de miles de tokens** quemados en cada turno sin avisar. |
| 💬 **Verborrea y Relleno** | Saludos, introducciones largas y explicaciones obvias de código ya escrito. | **+500 a 1.500 tokens** desperdiciados por cada respuesta. |

---

## ⚡ Inicio Rápido: Clona y activa con el Prompt Maestro

La forma más rápida y directa de optimizar cualquier proyecto en 30 segundos:

### 1️⃣ Clona o añade el repositorio a tu proyecto

Ejecuta en la raíz de tu proyecto:
```bash
git clone https://github.com/hernanbareirorojas-konecta/pocket-antigravity.git
```
*(O descárgalo como ZIP y arrastra los archivos a tu carpeta).*

---

### 2️⃣ Pega el Prompt Maestro en el chat de Antigravity

Copia y pega este prompt al iniciar sesión:

#### 🇪🇸 Prompt Maestro (Español):
```markdown
A partir de ahora, sigue estrictamente las directivas de diseño y eficiencia de `pocket-antigravity`:

1. 🚫 Cero Subagentes: No lances subagentes para tareas cotidianas o búsquedas. Usa herramientas directas (grep_search, find_by_name, view_file).
2. 🎯 Contexto Quirúrgico: Lee solo los rangos de líneas estrictamente necesarios con StartLine y EndLine. Prohibido volcar archivos enteros o logs masivos.
3. 🤐 Brevedad Absoluta: Respuestas técnicas, directas y sin relleno. Omite saludos, introducciones y obviedades.
4. 📚 Documentación bajo demanda: Consulta la carpeta docs/ únicamente cuando diseñes o depures arquitecturas complejas, nunca de golpe.
```

#### 🇬🇧 Master Prompt (English):
```markdown
From now on, strictly follow the token efficiency directives from `pocket-antigravity`:

1. 🚫 Zero Subagents: Never spawn subagents for routine lookups or single file edits. Always use direct tools (grep_search, find_by_name, view_file).
2. 🎯 Surgical Context: Read only targeted line slices using StartLine and EndLine. Never dump entire files, CSVs, or unpaginated logs into context.
3. 🤐 Extreme Brevity: Be direct, concise, and technical. Omit greetings, conversational filler, and obvious code explanations.
4. 📚 Docs On-Demand: Consult docs/ strictly when designing or debugging complex architectures, never wholesale.
```

---

### 3️⃣ ¡Listo! Ahorro del 95% garantizado

Tu asistente operará inmediatamente en modo económico: sin subagentes costosos, con lecturas quirúrgicas y respuestas concisas.

---

## 📦 Desglose de Archivos (¿Qué hace cada uno?)

| Archivo / Carpeta | Función | Impacto |
| :--- | :--- | :--- |
| **[`ANTIGRAVITY.md`](ANTIGRAVITY.md)** / **[`GEMINI.md`](GEMINI.md)** | Directiva raíz ultra-ligera (~35 líneas). Sustituye los system prompts gigantescos. | Reduce el arranque de **18.500 a ~850 tokens**. |
| **[`.geminiignore`](.geminiignore)** / **[`.antigravityignore`](.antigravityignore)** | Cortafuegos que bloquea `node_modules/`, lockfiles y binarios del indexador. | Evita quemar **decenas de miles de tokens** en segundo plano. |
| **[`.agents/rules/token-efficiency.md`](.agents/rules/token-efficiency.md)** | Reglas que prohíben subagentes para tareas cotidianas y fuerzan `StartLine`/`EndLine`. | Ahorra **~32.000 tokens** en cada búsqueda de código. |
| **[`docs/`](docs/)** *(Opcional)* | Guías técnicas (caching, benchmarks, pipelines). Leídas **solo bajo demanda**. | **0 tokens** de coste inicial si no se consultan. |

---

## 🎯 Prompts Específicos para el Día a Día

### 🛠️ Configuración Inicial del Proyecto (Test, Build, Lint)
```markdown
Inspecciona los archivos de configuración de este proyecto (package.json, pyproject.toml, Cargo.toml, go.mod, etc.) y actualiza las líneas de Test, Build y Lint en `ANTIGRAVITY.md` y `GEMINI.md`. Sé conciso y no uses subagentes.
```

### 🔍 Búsqueda y Refactor Quirúrgico
```markdown
Localiza la función/módulo [NOMBRE] usando exclusivamente grep_search y view_file con rangos de líneas. No lances subagentes ni leas archivos enteros. Muestra solo el fragmento y tu propuesta.
```

### 🧪 Ejecución Limpia de Tests
```markdown
Ejecuta la suite de pruebas. Muestra únicamente los tests que fallen y un resumen de 1 línea con el total. Omite la lista de tests exitosos.
```

---

## 🌐 Opción Global Zero-Copy (Sin tocar tus repositorios)

Si trabajas en proyectos donde **no puedes commitear archivos externos**, configura las reglas una sola vez en tu usuario:

Copia `token-efficiency.md` y `GEMINI.md` a tu configuración global:

- **Windows:**
  - `token-efficiency.md` ➔ `C:\Users\<TuUsuario>\.gemini\config\rules\token-efficiency.md`
  - `ANTIGRAVITY.md` ➔ `C:\Users\<TuUsuario>\.gemini\config\GEMINI.md`
- **Linux / macOS:**
  - `token-efficiency.md` ➔ `~/.gemini/config/rules/token-efficiency.md`
  - `ANTIGRAVITY.md` ➔ `~/.gemini/config/GEMINI.md`

Todas las sesiones de Antigravity en tu máquina aplicarán las directivas en cualquier repositorio que abras.

---

## 📊 Benchmarks Medidos (Gemini 2.5 Flash / Pro)

| Métrica / Tarea | Sin pocket-antigravity | Con pocket-antigravity | Ahorro |
| :--- | :--- | :--- | :--- |
| **Sobrecarga Inicial** | ~18.500 tokens | **~850 tokens** | **-95.4%** |
| **Búsqueda de Código** | ~32.850 tokens (subagente) | **185 tokens (grep directo)** | **-99.4%** |
| **Salida de Tests (220 tests)** | 244 líneas (~4.450 tokens) | **16 líneas (~210 tokens)** | **-95.3%** |
| **Serialización (50 registros)** | 4.210 tokens (JSON crudo) | **1.890 tokens (tabla pipe)** | **-55.1%** |
| **Consultas Repetidas** | Tarifa completa ($0.15/MTok) | Prefijo exacto Vertex AI | **90% descuento caché** |

---

## 📁 Estructura del Repositorio

```text
pocket-antigravity/
├── logo/
│   └── pocket-antigravity-logo.jpg         # Banner del proyecto
├── ANTIGRAVITY.md                          # Directiva raíz (~35 líneas)
├── GEMINI.md                               # Directiva raíz dual
├── .geminiignore                           # Cortafuegos del indexador (lockfiles, dependencias)
├── .antigravityignore                      # Exclusiones de la interfaz IDE/CLI
├── .agents/                                # Reglas de comportamiento
│   ├── rules/token-efficiency.md           # Disciplina de subagentes y contexto
│   └── skills/pocket-init/SKILL.md         # Habilidad de auto-detección
├── docs/                                   # Referencias profundas (solo bajo demanda)
│   ├── benchmarks.md                       # Métricas detalladas
│   ├── token-optimization-guide.md         # Economía de caché y subagentes
│   ├── antigravity-best-practices.md        # Buenas prácticas en Antigravity
│   └── enterprise-pipeline-optimization.md # Arquitectura eficiente
├── LICENSE                                 # Licencia MIT
└── README.md                               # Guía visual completa
```

---

## 📄 Licencia

MIT License © 2026 Hernan Bareiro Rojas.  
¡Las contribuciones, ideas y PRs son bienvenidas!
