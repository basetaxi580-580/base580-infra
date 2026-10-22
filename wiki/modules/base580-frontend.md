---
type: module
path: "../base580-frontend/"
status: active
language: typescript
purpose: "UI Angular y reverse proxy Nginx hacia el backend"
maintainer: ""
last_updated: 2026-10-21
linked_issues: []
depends_on: ["Node 24", "base580-backend"]
used_by: []
tags: [module, frontend]
created: 2026-10-15
updated: 2026-10-21
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

## Estado de módulos — 2026-10-20

Angular 22. `MemberStore` en signals es la copia local. `APP_INITIALIZER` hace `GET /api/state`; si el backend no responde, queda el ejemplo embebido.

Persisten con `PUT /api/state`: captura, catálogos y validación.

Captura (`/captura`) edita solo datos operativos del socio: sitio, placas, engomado, vencimiento, estatus y observaciones. No muestra empleado, tipo de socio, resumen ni historial. El número de empleado sigue en la ficha.

El marco compartido ya no incluye las tarjetas Accesos rápidos ni Estado del sistema. La navegación queda en el menú lateral. Tampoco muestra títulos de sprint. El buscador global está centrado en todas las rutas.

Pantalla local, sin ese guardado: operaciones (precios fijos 173/145), cancelación, reimpresión. Reportes filtran cuatro filas de ejemplo y exportan con `window.print`.

`/boletos` y `/lista-precios` son el corte de boletos y no pasan por `app_state`. Fuente: `PAGO BOLETOS 2026.xlsx` — **19 pestañas** (BASE* catálogo + captura + TOTAL). Ver [[Pago de Boletos 2026]]. Temblor 1 s, reorden, × rojo, libres, autosave 1.5 s. Rutas marcador: inicio, búsqueda, credenciales y engomados.
