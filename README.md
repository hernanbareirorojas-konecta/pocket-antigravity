<div align="center">

<img src="logo/pocket-antigravity-logo.jpg" alt="pocket-antigravity banner" width="100%" />

# 🪙 pocket-antigravity

**The Definitive Guide & Markdown Blueprint to Cut Token Spend by 95% in Google Antigravity & Gemini Agents.**

*Guía definitiva y conjunto de archivos Markdown para optimizar y reducir drásticamente el consumo de tokens en tus proyectos con Google Antigravity.*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Pure Markdown](https://img.shields.io/badge/Built%20With-Pure%20Markdown-blue.svg?style=flat-square)](#)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero-brightgreen.svg?style=flat-square)](#)

</div>

---

## 🧐 ¿Por qué tu asistente de Antigravity gasta tantos tokens?

Muchos desarrolladores notan que en sesiones largas o proyectos medianos, **el asistente gasta decenas de miles de tokens antes de escribir una sola línea de código**. ¿A qué se debe esto?

1. **Subagentes descontrolados:** Cada vez que el asistente lanza un subagente (`invoke_subagent`), paga una penalización de arranque fija de **~25.000 a 35.000 tokens** (su propio system prompt, esquemas de herramientas y contexto inicial). Lanzar un subagente para buscar una función o editar un archivo es quemar presupuesto innecesariamente.
2. **Volcado masivo de archivos:** Leer archivos completos de 400 líneas en lugar de usar rangos específicos (`StartLine`/`EndLine`) llena rápidamente la ventana de contexto y diluye la atención del modelo.
3. **Indexadores hambrientos:** Sin archivos de exclusión explícitos, Antigravity puede intentar parsear e indexar carpetas como `node_modules/`, `target/`, `.venv/` o lockfiles gigantescos (`package-lock.json`, `pnpm-lock.yaml`), gastando miles de tokens de fondo en cada turno.
4. **Instrucciones redundantes y charlatanería:** Prompts de sistema gigantescos de cientos de líneas que se repiten en cada interacción y respuestas con introducciones y despedidas innecesarias.

`pocket-antigravity` resuelve estos problemas **sin necesidad de instalar programas, scripts ni librerías de Python**: es una metodología basada en **archivos Markdown puros, ingeniería de prompts y reglas de contexto**.

---

## ⚡ Guía Rápida en 3 Pasos (Sin Instaladores, Sin Scripts)

### Paso 1: Descarga y coloca los archivos en tu proyecto

Simplemente copia los siguientes archivos en la raíz de tu proyecto:

```text
tu-proyecto/
├── ANTIGRAVITY.md              # Directiva raíz ultra-ligera (~35 líneas)
├── GEMINI.md                   # Copia de ANTIGRAVITY.md para compatibilidad dual
├── .geminiignore               # Cortafuegos para el indexador de Antigravity
├── .antigravityignore          # Exclusiones adicionales de indexación
├── .agents/
│   └── rules/
│       └── token-efficiency.md # Reglas de disciplina de contexto y subagentes
└── docs/                       # (Opcional) Guías técnicas leídas solo bajo demanda
```

---

### Paso 2: Dale a tu asistente el Prompt de Activación

Abre el chat de Google Antigravity en tu proyecto y **copia y pega el siguiente prompt de activación** (puedes usarlo en español o inglés):

#### 🇪🇸 Prompt de Activación (Español):
```markdown
A partir de ahora, sigue estrictamente las directivas de diseño y eficiencia de `ANTIGRAVITY.md` y `.agents/rules/token-efficiency.md` con el objetivo de ahorrar tokens en este proyecto:

1. Subagentes: Nunca lances subagentes para tareas cotidianas, búsquedas o ediciones de archivos. Usa siempre herramientas directas (como grep_search, find_by_name y view_file).
2. Higiene de contexto: Lee únicamente los rangos de líneas estrictamente necesarios usando StartLine y EndLine en view_file. Nunca vuelques archivos enteros ni logs masivos.
3. Brevedad: Sé directo, conciso y técnico en todas tus respuestas. Omite introducciones conversacionales, saludos y explicaciones obvias de código.
4. Documentación: Consulta la carpeta docs/ únicamente bajo demanda cuando estés diseñando o depurando una arquitectura compleja, nunca de golpe.
```

#### 🇬🇧 Activation Prompt (English):
```markdown
From now on, strictly adhere to the design and token efficiency directives in `ANTIGRAVITY.md` and `.agents/rules/token-efficiency.md` to minimize token expenditure in this project:

1. Subagent Discipline: Never spawn subagents for routine lookups, single searches, or file edits. Always use direct tools (grep_search, find_by_name, view_file).
2. Surgical Context Hygiene: Read only targeted line slices using StartLine and EndLine in view_file. Never dump entire files, large CSVs, or unpaginated logs into context.
3. Response Brevity: Be direct, concise, and technical in all responses. Omit conversational filler, polite intros, and obvious code explanations.
4. Progressive Disclosure: Read specific files in docs/ strictly on demand when designing or debugging, never wholesale.
```

---

### Paso 3: ¡Listo! Programa con un ahorro de hasta el 95%

Tu asistente asumirá automáticamente la disciplina de tokens:
- No gastará 35.000 tokens en subagentes innecesarios.
- Sus lecturas de código serán quirúrgicas.
- Tus respuestas serán instantáneas, limpias y directas al grano.

---

## 📦 El Kit de Archivos Markdown (¿Qué hace cada uno?)

| Archivo / Carpeta | Propósito y Por qué ahorra tokens |
| :--- | :--- |
| **[`ANTIGRAVITY.md`](ANTIGRAVITY.md)** / **[`GEMINI.md`](GEMINI.md)** | **Directiva Raíz Ultra-Ligera (~35 líneas):** Sustituye las típicas instrucciones de 400 líneas por un resumen estructurado con *revelación progresiva*. Es lo primero que lee el agente en cada turno. |
| **[`.geminiignore`](.geminiignore)** y **[`.antigravityignore`](.antigravityignore)** | **Cortafuegos del Indexador:** Evita que el agente indexe y consuma tokens de `node_modules/`, `.git/`, lockfiles gigantes (`package-lock.json`), binarios o reportes de cobertura. |
| **[`.agents/rules/token-efficiency.md`](.agents/rules/token-efficiency.md)** | **Reglas de Comportamiento:** Directrices explícitas que fijan el umbral económico de los subagentes, obligan al uso de `StartLine`/`EndLine` y prohíben volcados masivos. |
| **[`docs/`](docs/)** *(Opcional)* | **Guías Técnicas en Profundidad:** Benchmarks, optimización de pipelines y guías de caching. El agente **sabe que existen pero solo las lee bajo demanda** cuando se lo pides expresamente. |

---

## 🎯 Más Prompts Útiles para Copiar y Pegar

### 🛠️ Prompt de Configuración Inicial del Proyecto
Usa este prompt la primera vez que configures tu repositorio para que el asistente rellene los comandos de test y build en `ANTIGRAVITY.md`:

```markdown
Revisa los archivos de configuración de este proyecto (package.json, pyproject.toml, Cargo.toml, go.mod, etc.) y rellena las líneas comentadas en `ANTIGRAVITY.md` y `GEMINI.md` con los comandos reales de Test, Build y Lint. Sé conciso y no uses subagentes.
```

### 🔍 Prompt para Tareas de Búsqueda o Refactor
Usa este prompt cuando le pidas buscar o modificar código en un proyecto grande:

```markdown
Localiza dónde se define la función/módulo [NOMBRE] usando exclusivamente grep_search y view_file con rangos de líneas específicos. No lances subagentes ni leas archivos enteros. Muestra solo el fragmento relevante y la propuesta de cambio.
```

### 🧪 Prompt para Ejecución de Tests
Usa este prompt para evitar que la salida de 200 tests pasando inunde tu ventana de contexto:

```markdown
Ejecuta la suite de tests del proyecto. Muestra únicamente los tests que fallen con su traza de error y un resumen de 1 línea con el total. Omite la lista de tests que hayan pasado exitosamente.
```

---

## 🌐 Opción Alternativa: Uso Global Zero-Copy (Sin tocar el proyecto)

Si trabajas en repositorios de clientes, proyectos de código abierto o equipos donde **no puedes commitear archivos de configuración personales en git**, puedes aplicar esta optimización de forma global para toda tu máquina:

Simplemente copia `token-efficiency.md` y `GEMINI.md` en tu carpeta global de Antigravity:

- **Windows:**
  - Copia `.agents/rules/token-efficiency.md` ➔ `C:\Users\<TuUsuario>\.gemini\config\rules\token-efficiency.md`
  - Copia `ANTIGRAVITY.md` ➔ `C:\Users\<TuUsuario>\.gemini\config\GEMINI.md`
- **Linux / macOS:**
  - Copia `.agents/rules/token-efficiency.md` ➔ `~/.gemini/config/rules/token-efficiency.md`
  - Copia `ANTIGRAVITY.md` ➔ `~/.gemini/config/GEMINI.md`

Todas las sesiones de Antigravity en tu máquina aplicarán las directivas de ahorro de tokens en cualquier repositorio que abras, **sin añadir un solo archivo a git**.

---

## 📊 Benchmarks Reales (Medidos, No Suposiciones)

Comparativa medida en sesiones reales con modelos Gemini 2.5 Pro y Flash en Google Antigravity:

| Métrica / Tarea | Sin pocket-antigravity | Con pocket-antigravity | Reducción de Tokens |
| :--- | :--- | :--- | :--- |
| **Sobrecarga del Prompt Inicial** | ~18.500 tokens | **~850 tokens** | **-95.4%** |
| **Búsqueda puntual de código** | ~32.850 tokens (subagente) | **185 tokens (grep directo)** | **-99.4%** |
| **Salida de Tests (220 tests)** | 244 líneas (~4.450 tokens) | **16 líneas (~210 tokens)** | **-95.3%** |
| **Serialización de datos (50 items)** | 4.210 tokens (JSON crudo) | **1.890 tokens (tabla pipe)** | **-55.1%** |
| **Consultas repetidas** | Coste íntegro ($0.15/MTok) | Coincidencia de prefijo exacta | **90% descuento de caché** |

---

## 📁 Estructura del Repositorio

```text
pocket-antigravity/
├── logo/
│   └── pocket-antigravity-logo.jpg         # Banner del proyecto
├── ANTIGRAVITY.md                          # Directiva raíz principal (~35 líneas)
├── GEMINI.md                               # Archivo raíz dual compatible
├── .geminiignore                           # Exclusiones del indexador (node_modules, lockfiles)
├── .antigravityignore                      # Exclusiones de la interfaz IDE/CLI
├── .agents/                                # Reglas y directivas de comportamiento
│   ├── rules/token-efficiency.md           # Reglas de disciplina de contexto y subagentes
│   └── skills/pocket-init/SKILL.md         # Habilidad de auto-configuración
├── docs/                                   # Guías técnicas bajo demanda (no se cargan de golpe)
│   ├── benchmarks.md                       # Desglose de métricas de ahorro
│   ├── token-optimization-guide.md         # Matemáticas de caché y subagentes en Gemini
│   ├── antigravity-best-practices.md        # Buenas prácticas en Antigravity
│   └── enterprise-pipeline-optimization.md # Patrones de arquitectura eficiente
├── LICENSE                                 # Licencia MIT
└── README.md                               # Esta guía completa
```

---

## 📄 Licencia

MIT License © 2026 Hernan Bareiro Rojas.  
¡Las contribuciones, ideas y mejoras son bienvenidas!
