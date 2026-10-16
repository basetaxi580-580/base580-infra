---
type: meta
title: "Wiki Log"
status: active
created: 2026-10-15
updated: 2026-10-15
tags: [meta, log]
---

# Wiki Log

Append-only. Newest entries at the TOP.

---

## 2026-10-15 — Cuenta verificada y publicación de ramas

- Usuario completó autorización GitHub; sesión activa basetaxi580-580, con permisos de escritura comprobados en los tres repositorios.
- Frontend y backend publicados en origin/codex/integracion-repos-ui. Infraestructura incorpora este registro para publicar su rama a continuación.
- main sin modificar; no se activa despliegue. Actualizados [[Deploy Flow]], [[hot]] e [[index]].

## 2026-10-15 — Preparación de publicación GitHub

- Verificados los tres remotos en `basetaxi580-580`; publicación solicitada con `basetaxi580@gmail.com`.
- Sesión gh encontrada: CharlyTlelo, sin permiso de escritura al backend. Se requiere iniciar sesión con la cuenta propietaria antes de publicar.
- Documentado proceso de publicación y diferencia entre push a rama de trabajo y despliegue automático desde main en [[Deploy Flow]].

## 2026-10-15 — Navegación adaptable

- Usuario de demostración cambiado a Miguel Rios Bravo en encabezado y reportes.
- Flecha inferior para mostrar/ocultar módulos; panel móvil animado y gestos horizontales.
- Comprobación de escritorio y viewport 390 px con navegador; cinco pruebas correctas.
- Actualizados [[base580-frontend]], [[hot]] e [[index]].

## 2026-10-15 — Arranque local nativo

- Frontend y backend iniciados en segundo plano. MongoDB local existente disponible.
- Verificados frontend HTTP 200, backend salud UP y `/api/state` vía Angular HTTP 200 JSON.
- Actualizados [[Deploy Flow]], [[hot]] e [[index]]. Pendiente prueba Docker/VM.

## 2026-10-15 — Integración de repositorios verificada localmente

- Configurados proxy `/api`, red compartida y conexión MongoDB para Spring Boot 4.
- Workflows independientes usan Compose mediante `scripts/deploy.sh`; infraestructura no compila código de otros repositorios.
- Corregida carga/guardado de socios, catálogos y auditoría; frontend 5/5 y backend 2/2 pruebas correctas. Build Angular correcto.
- Actualizados [[Deploy Flow]], [[hot]] e [[index]]. Falta prueba completa Docker y aplicación en VM; no se publicó ni desplegó.

## 2026-10-15 — Vault scaffold

- Created Obsidian vault inside `base580-infra` (Mode B + C).
- Scaffolded wiki/, .raw/, .obsidian/, _templates/, CLAUDE.md.
- Seeded architecture, modules, flows, decisions, tech stack from README + sprint-plan.
- Copied `docs/sprint-plan.md` → `.raw/sprint-plan.md`.
- Added Cursor rules + AGENTS.md so frontend/backend/infra AIs consult and update this vault.
