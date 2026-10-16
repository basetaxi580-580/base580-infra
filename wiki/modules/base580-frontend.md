---
type: module
path: "../base580-frontend/"
status: active
language: typescript
purpose: "UI Angular y reverse proxy Nginx hacia el backend"
maintainer: ""
last_updated: 2026-10-15
linked_issues: []
depends_on: ["Node 24", "base580-backend"]
used_by: []
tags: [module, frontend]
created: 2026-10-15
updated: 2026-10-15
---

# base580-frontend

Repo hermano: `../base580-frontend`.

## Hechos conocidos

- Angular (Node 24): `npm ci` + `npm start`.
- Dev proxy reenvía `/api/**` a `127.0.0.1:8080`.
- En Compose, Nginx publica el puerto frontend y proxea `/api` al servicio backend.
- Health: `/healthz`; API smoke: `/api/state`.
- Usuario de demostración: Miguel Rios Bravo (encabezado y reportes).
- Menú de módulos: flecha inferior para ocultar/mostrar. En móvil (hasta 900 px), panel lateral con slide de 250 ms, fondo para cerrar y gestos horizontales: abrir desde el borde izquierdo, cerrar hacia la izquierda. Respeta movimiento reducido e impide foco en el panel cerrado.
- Verificado en navegador a 390 px: apertura por botón y cierre por gesto; en escritorio, flecha inferior oculta/restaura el menú. Cinco pruebas del frontend correctas.

## Gaps

> [!gap] Detalle de UI
> Rutas de módulos, stores y shell aún no documentados en el wiki. Ingestar README/docs del frontend.
