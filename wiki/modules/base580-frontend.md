---
type: module
path: "../base580-frontend/"
status: active
language: typescript
purpose: "UI Angular y reverse proxy Nginx hacia el backend"
maintainer: ""
last_updated: 2026-11-11
linked_issues: []
depends_on: ["Node 24", "base580-backend"]
used_by: []
tags: [module, frontend]
created: 2026-10-15
updated: 2026-11-11
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

Captura (`/captura`) edita datos operativos del socio: sitio, placas, engomado, **fecha de alta** (campo `expiry`, antes "vencimiento"), **venc. licencia**, **venc. seguro** (fechas en texto `aaaammdd`, `pattern=\\d{8}`), **celular**, **modelo** (selector de año 2026→1980) y **marca**, además de estatus y observaciones. "Guardar" persiste directo con `PUT /api/state`; se eliminó el flujo de borrador en 2 pasos (botones "Publicar mi borrador", "Ver versión actual", "Ver mi borrador", "Restaurar" y el `localStorage` del borrador). La lista muestra cada socio como tarjeta expandible: clic en el texto despliega toda la info con Editar/Eliminar; la navegación resalta el botón activo según la vista. No muestra empleado, tipo de socio, resumen ni historial. El número de empleado sigue en la ficha.

El marco compartido ya no incluye las tarjetas Accesos rápidos ni Estado del sistema. La navegación queda en el menú lateral. Tampoco muestra títulos de sprint. La barra de búsqueda global fue retirada.

Pantalla local, sin ese guardado: operaciones (precios fijos 173/145), cancelación, reimpresión. Reportes filtran cuatro filas de ejemplo y exportan con `window.print`.

`/boletos` es el editor del libro y no pasa por `app_state`. Fuente: `PAGO BOLETOS 2026.xlsx` — **19 pestañas** (BASE* catálogo + captura + TOTAL). Ver [[Pago de Boletos 2026]]. Incluye pestañas personalizadas, reorden, filas/columnas redimensionables, selección con Shift, combinación de celdas y persistencia de estructura en `ticket_workbook`. `/lista-precios` y `/boletos/anterior` fueron retiradas.
