---
type: meta
title: "Hot Cache"
updated: 2026-10-15T18:45:00
---

# Recent Context

## Last Updated
2026-10-15. Vault Obsidian scaffolded in `base580-infra` as shared AI knowledge base.

## Key Recent Facts
- Base580 = 3 independent repos: infra (Compose/deploy), backend (Spring Boot + Mongo), frontend (Angular + Nginx).
- Browser → frontend:80 → `/api/*` → backend:8080 → mongo:27017. Only frontend is public.
- Product: modern CRM-like app, same modules as current system, no roles this phase, PDF reports, history kept.
- Sprint plan locked through Sprint 8 (foundation → catalogs). Build one sprint at a time.
- Wiki path for all AIs: `C:\Users\carlo\Documents\base580\base580-infra` — read `wiki/hot.md` then `wiki/index.md`.

## Recent Changes
- PR #1 abierto en cada repositorio, sin conflictos. Pruebas frontend 5/5 y backend 2/2 repetidas; Compose/Bash correctos. Deploy pendiente de IP/dominio y usuario SSH: últimos workflows fallan en handshake; no se integró main. Ver [[Deploy Flow]].
- Publicación GitHub: cuenta `basetaxi580-580` autenticada por el usuario y con permiso push en los tres repositorios. Cambios en `codex/integracion-repos-ui`; frontend/backend publicados, infra incluye este registro. No se integra main ni se despliega. Proceso en [[Deploy Flow]].
- UI: Miguel Rios Bravo en encabezado/reportes; menú con flecha inferior y slide/gestos en móvil. Verificación en navegador a 390 px y escritorio; pruebas 5/5. Ver [[base580-frontend]].
- Stack local nativo iniciado y verificado: Angular `localhost:4200`, backend `localhost:8080`, Mongo `127.0.0.1:27017`; salud `UP` y `/api/state` vía Angular devuelve 200 JSON. Continúa pendiente la prueba Docker/VM.
- Integración corregida localmente: `/api` relativo, proxy Angular/Nginx, red Docker compartida, propiedad Mongo de Spring Boot 4 y despliegues por servicio con Compose. [[Deploy Flow]] registra validación y pendientes.
- Pruebas: frontend 5/5, backend 2/2 (Java 21 local; objetivo Java 24), build Angular y configuración Compose correctos. Falta validación con contenedores y despliegue VM; cambios sin publicar.
- Created: [[overview]], [[Architecture Overview]], [[base580-infra]], [[base580-backend]], [[base580-frontend]], [[Data Flow]], [[Deploy Flow]], [[Key Decisions]], [[Tech Stack]], [[CRM Product]], [[Infrastructure]], [[sources/sprint-plan]]
- Updated: wiki indexes + CLAUDE.md + Cursor rules in all three repos

## Active Threads
- User wants all IAs to consult and update this vault
- Open Obsidian vault folder: `base580-infra` (app already installed)
- Next useful ingest: READMEs de backend/frontend, ADRs, estado real de sprints
