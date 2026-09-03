---
name: pocket-init
description: Explores this project and fills in ANTIGRAVITY.md and GEMINI.md Commands, Architecture, and Testing placeholders with real, confirmed project configuration. Use right after pocket-antigravity is dropped into a new project, or whenever asked to initialize or update project instructions.
---

# pocket-init

Fill in the three `<!-- fill per project -->` placeholder sections in `ANTIGRAVITY.md` and `GEMINI.md`:
- **Commands** (test, build, lint)
- **Architecture** (key boundaries and dependencies)
- **Testing** (detected runner and flags)

Strict rule: Never guess, assume, or hallucinate a command that is not confirmed in an actual configuration file.

## 1. Detect Ecosystem(s)

Inspect the root directory for configuration markers (projects may contain multiple):

| File Marker | Ecosystem |
| :--- | :--- |
| `package.json` (check also for `bun.lockb` or `pnpm-lock.yaml`) | Node / Bun / pnpm |
| `pyproject.toml` / `requirements.txt` / `setup.py` / `uv.lock` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `pom.xml` / `build.gradle` / `build.gradle.kts` | Java / Kotlin (JVM) |
| `*.csproj` / `*.sln` | .NET |
| `composer.json` | PHP |
| `pubspec.yaml` | Dart / Flutter |
| `mix.exs` | Elixir |
| `Package.swift` | Swift |
| `Makefile` / `CMakeLists.txt` | C / C++ / Generic |

## 2. Extract Real Commands

Extract commands directly from project configuration:
- `package.json` scripts (`npm run build`, `npm test`, etc.)
- `pyproject.toml` or `Makefile` targets
- Standard tool commands (`cargo build`, `go build`, `dotnet build`)
Only record commands that are verified to exist.

## 3. Map Architecture (2–3 Lines Maximum)

Use `find_by_name` or `list_dir` at depth 1–2 (do not read full file bodies):
- Note entrypoints and package boundaries (e.g., `src/core/` for business logic, `src/api/` for endpoints).
- Note external dependencies if evident from config (e.g., Postgres, Redis, GCP Cloud Run).
- Keep to 2–3 terse bullet points.

## 4. Detect Testing Framework

Identify test framework and configuration:
- Python: `pytest` (`pytest.ini`, `pyproject.toml`), `unittest`
- JavaScript/TypeScript: `vitest` (`vitest.config.*`), `jest` (`jest.config.*`), `playwright`
- Rust / Go / .NET: native runner (`cargo test`, `go test ./...`, `dotnet test`)
- Record test command and whether `.agents/hooks/filter_test_output.py` is configured to condense it.

## 5. Update ANTIGRAVITY.md and GEMINI.md

Use `replace_file_content` to update the placeholder blocks in `ANTIGRAVITY.md` and `GEMINI.md`.
Leave all other sections and directives untouched. If a component does not exist (e.g., no tests yet), state "None configured" rather than inventing boilerplate.
