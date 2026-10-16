---
type: decision
status: active
priority: 1
date: 2026-10-15
owner: ""
context: "Decisiones de producto e infra ya cerradas"
tags: [decision, product, infra]
created: 2026-10-15
updated: 2026-10-15
---

# Key Decisions

## Producto (locked)

- Nueva UI moderna
- Mismos módulos de negocio que el sistema actual
- Sin roles en esta fase — acceso completo
- Búsqueda funcional/operativa primero
- Export PDF para reportes
- Historial almacenado; sin purge por ahora
- Despliegue local/VM por ahora

## Ejecución de sprints

- Un sprint a la vez, siempre demoable
- UI simple y explícita sobre comportamiento oculto
- Toda acción crítica queda en historial

## Infra

- Tres repos independientes; Compose no hace build de código de apps
- Solo frontend expuesto; backend/mongo en red interna / localhost
- No `docker compose down -v` (protege `mongo_data`)

Source: [[sources/sprint-plan]], README de infra.
