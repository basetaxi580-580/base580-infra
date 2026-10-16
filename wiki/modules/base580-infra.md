---
type: module
path: "base580-infra/"
status: active
language: yaml/bash
purpose: "Orquestación Docker Compose, scripts de deploy y CI de infra"
maintainer: ""
last_updated: 2026-10-15
linked_issues: []
depends_on: ["Docker Compose v2", "jq", "flock"]
used_by: ["base580-backend", "base580-frontend"]
tags: [module, infra]
created: 2026-10-15
updated: 2026-10-15
---

# base580-infra

Vault Obsidian + repo de infraestructura.

## Responsabilidades

- `docker-compose.yml` — servicios frontend, backend, mongo
- `env.example` → `.env` — puertos e imagenes
- `scripts/deploy.sh` — deploy serializado (`all` | `backend` | `frontend`)
- `.github/workflows/deploy.yml` — aplica Compose en la VM
- Este wiki (`wiki/`, `.raw/`, `CLAUDE.md`)

## Notas

- No construye código de apps; consume imágenes ya construidas (o construidas en la VM por workflows de app).
- Secretos GitHub: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`.
- No ejecutar `docker compose down -v` (borra `mongo_data`).

See [[Deploy Flow]], [[Infrastructure]].
