# Base580 Wiki: LLM Wiki

Mode: B (GitHub / Repository) + C (Project)
Purpose: Knowledge base compartida del monorepo Base580 (infra, backend, frontend) para que todas las IAs consulten y actualicen el mismo contexto.
Owner: carlo
Created: 2026-10-15

## Structure

```
base580-infra/          # vault root (abrir en Obsidian)
├── .raw/               # fuentes inmutables (nunca modificar)
├── .archive/           # fuentes frías
├── wiki/
│   ├── index.md        # catálogo maestro
│   ├── log.md          # bitácora append-only (nuevas entradas ARRIBA)
│   ├── hot.md          # caché reciente (~500 palabras)
│   ├── overview.md     # resumen ejecutivo
│   ├── modules/        # infra, backend, frontend
│   ├── components/     # piezas reutilizables
│   ├── decisions/      # ADRs y decisiones de producto
│   ├── dependencies/   # deps externas y riesgo
│   ├── flows/          # flujos de datos, auth, deploy
│   ├── sources/        # resumen por fuente en .raw/
│   ├── entities/       # personas, orgs, productos, repos
│   ├── concepts/       # ideas, patrones, módulos de negocio
│   ├── domains/        # áreas temáticas
│   ├── comparisons/    # análisis lado a lado
│   ├── questions/      # respuestas archivadas
│   └── meta/           # dashboards, lint, convenciones
├── _templates/
├── .obsidian/
└── CLAUDE.md           # este archivo
```

Repos hermanos (fuera del vault, pero documentados aquí):
- `../base580-backend` — Spring Boot + MongoDB
- `../base580-frontend` — Angular + Nginx

## Conventions

- All notes use YAML frontmatter: type, status, created, updated, tags (minimum)
- Wikilinks use [[Note Name]] format: filenames are unique, no paths needed
- .raw/ contains source documents: never modify them
- wiki/index.md is the master catalog: update on every ingest
- wiki/log.md is append-only: never edit past entries
- New log entries go at the TOP of the file
- After every significant operation: update wiki/hot.md

## Operations

- Ingest: drop source in .raw/, say "ingest [filename]"
- Query: ask any question: AI reads index first, then drills in
- Lint: say "lint the wiki" to run a health check
- Archive: move cold sources to .archive/ to keep .raw/ clean
- Save: say "save this" to file decisions/facts from chat into wiki

## Wiki Knowledge Base (for sibling repos)

Path: `C:\Users\carlo\Documents\base580\base580-infra`

When you need context not already in this project:
1. Read wiki/hot.md first (recent context, ~500 words)
2. If not enough, read wiki/index.md (full catalog)
3. If you need domain specifics, read wiki/domains/_index.md or wiki/modules/_index.md
4. Only then read individual wiki pages

Do NOT read the wiki for:
- General coding questions or language syntax
- Things already in this project's files or conversation
- Tasks unrelated to Base580

When you learn something durable (decisions, architecture, sprint status, conventions):
- Write or update the relevant wiki page
- Update wiki/index.md and wiki/hot.md
- Append a log entry at the top of wiki/log.md
