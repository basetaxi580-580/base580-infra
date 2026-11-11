---
type: meta
title: "Hot Cache"
status: active
created: 2026-10-15
updated: 2026-11-11
tags: [meta, context]
---

# Recent Context

## Estado actual de `/boletos` — 2026-11-11

- El editor Excel vigente es la única entrada del flujo; se retiraron `/boletos/anterior`, `/lista-precios` y la barra de búsqueda global.
- UI: fondos sólidos, pestañas opacas, encabezados A–AL y 1–200 en rosa, tipografía redondeada y menús contextuales con estilo consistente.
- Interacciones: clic derecho → `Opciones de formato` → `Combinar celdas` / `Quitar combinación`; seleccionar rangos con clic + Shift. También se pueden redimensionar columnas y filas arrastrando sus encabezados.
- Persistencia: cambios, formatos, estructura, medidas, combinaciones, pestañas y orden se guardan en `ticket_workbook` mediante `PUT /api/boletos/libro`.
- Verificación: frontend 36 pruebas y build de producción correctos. Los últimos cambios están en commits locales; no se han subido ni desplegado.
- Para publicar, revisar [[Deploy Flow]]: cada repositorio tiene su propio workflow de GitHub Actions, por lo que el PR de esta tanda corresponde principalmente a `base580-frontend`.

## Ambientes local y producción

2026-11-11: se separaron los ambientes operativos. Local usa `docker-compose.local.yml` para levantar únicamente MongoDB con el volumen `base580-local-mongo-data`; backend y frontend corren nativamente en `localhost:8080` y `localhost:4200`. Producción conserva el Compose completo con frontend, backend, MongoDB y Caddy; sus puertos HTTP/HTTPS ahora son configurables mediante `CADDY_HTTP_PORT` y `CADDY_HTTPS_PORT`. Plantillas: `env.local.example` y `env.production.example`.

También se añadió `levantar-local.bat` en la raíz del workspace para validar requisitos, levantar MongoDB y abrir backend/frontend en ventanas separadas.

2026-11-11: `/boletos` incorpora pestañas BASE personalizadas persistentes en `ticket_workbook`; las pruebas de frontend, backend Java 24 y el build de producción pasan. Las pestañas nuevas empiezan vacías, se renombrarán con migración segura y no modifican las 19 hojas importadas.

## Comando habitual: levantar local

Cuando se solicite **levantar local**, ejecutar el archivo `C:\Users\carlo\Documents\base580\levantar-local.bat` desde la raíz del workspace. El script valida Docker/Java/Node, levanta MongoDB con `.env.local` y abre backend y frontend en terminales separadas. No ejecutar `docker compose down -v`.

El script prioriza automáticamente `C:\Program Files\Java\jdk-24` si existe, aunque la terminal tenga JDK 21 en su `PATH`.

Verificación 2026-11-11: Docker Desktop 29.8.2 disponible, frontend `http://localhost:4200` responde 200, backend `http://localhost:8080/actuator/health` responde `UP`, y MongoDB está disponible en `localhost:27017`.

Se creó [[PRD Base580]] como documento vivo para solicitudes del cliente, histórico, pendientes, cambios y criterios de aceptación.

Cambio 1 del cliente: en `/boletos` se necesitan dos nuevas pestañas de catálogo `BASE ...` como las visibles en la franja inferior. No se refiere a las hojas libres. La gestión debe abrirse con clic derecho y ofrecer **Añadir libro**, **Eliminar** y **Cambiar nombre**. Hoy los catálogos están definidos de forma fija en el frontend.

## Last Updated

2026-10-21 (cierre). `/boletos` **en productivo** bajo cuenta GitHub `basetaxi580-580`. Sesión cerrada. Continuar en [[Pago de Boletos 2026]] / [[Deploy Flow]].

## Producción — desplegado

Cuenta: **basetaxi580-580**. Sitio: http://34.41.156.148/ (ruta `/boletos`). La IP externa `34.41.156.148` está reservada en GCP como `base580-web-ip` (`us-central1`) para el dominio futuro.

| Repo | PR | Deploy Actions |
|------|-----|----------------|
| backend | [#2](https://github.com/basetaxi580-580/base580-backend/pull/2) | success `39706545908` |
| frontend | [#4](https://github.com/basetaxi580-580/base580-frontend/pull/4) + fix CSS [#5](https://github.com/basetaxi580-580/base580-frontend/pull/5) | #4 falló (budget CSS); #5 success `39706976442` |
| infra wiki | [#2](https://github.com/basetaxi580-580/base580-infra/pull/2) | docs en main |

## `/boletos` (estado shipped)

Fuente: `C:\Users\carlo\Downloads\PAGO BOLETOS 2026.xlsx`.

- **19 pestañas** (BASE* catálogo + captura + TOTAL); colores TAPO / NORTE 26 / especiales / PTE.
- Semilla **861** tarifas (`tarifas.tsv`); `ensureSeed` en backend.
- UX: temblor 1 s, × rojo, grow hover, autosave 1.5 s, undo 5, fórmulas, `localStorage` de hojas/formato.
- Pendiente producto: impresión, historial, folio, `I15` / desfase TAPO, TOTAL D31 ponderado.

## Estado actual (resto)

2026-10-21: Norte 2025/2026 copian BASE NTE: A–F y H–M, G vacía; PAGAR `=B3-C3-D3-E3`; U–Z nocturno `=B40+20`.

2026-10-20: el marco ya no muestra Accesos rápidos ni Estado del sistema; el menú lateral sigue en todas las pantallas.

2026-10-20: openpyxl 3.1.5 instalado en Python 3.12 del sistema para leer libros .xlsx.

2026-10-20: BMAD-METHOD 6.13.0-next instalado en la raíz del workspace para Cursor. Skills en `.agents/skills`, runtime en `_bmad`. Falta `bmad-retrospective` por un YAML inválido en el origen.

2026-10-20: `/captura` solo edita sitio, placas, engomado, vencimiento, estatus y observaciones. Sin empleado, resumen ni historial en esa pantalla.

2026-10-20: revisión de arquitectura contra el código. El despliegue de tres repos
sigue cerrado. El dominio es un documento `app_state` (`_id=default`) que el
frontend reemplaza con PUT /api/state. Solo captura, catálogos y validación
persisten. Operaciones, cancelación, reimpresión y reportes son de pantalla o
ejemplo. Historial recortado a 10 y auditoría a 20. POST /api/seed y el API
viajan sin autenticación por el mismo Nginx público. `MemberDocument` no se usa.

2026-10-16: Base580 publicado en http://34.41.156.148/ y verificado. PR #1 de
frontend, backend e infraestructura integrados en main; workflows correctos.
Los tres contenedores están saludables y /api/state responde HTTP 200 desde Nginx.

## Arquitectura y decisiones

- Tres repositorios independientes bajo GitHub basetaxi580-580: frontend Angular/Nginx,
  backend Spring Boot/MongoDB e infraestructura Compose/deploy/Obsidian.
- Navegador -> frontend:80 -> /api/* -> backend:8080 -> mongo:27017.
- Sólo frontend se publica a la red; puertos backend/Mongo en loopback.
- Red base580-net; volumen persistente base580-infra_mongo_data conservado.
- Cuenta solicitada: basetaxi580@gmail.com. gh autenticado como basetaxi580-580.
- Producto: CRM operativo, mismos módulos del sistema anterior, sin roles en esta fase,
  reportes PDF e historial conservado como requisito.

## Despliegue y respaldo

- VM: clones limpios /root/base580-infra, /root/base580-backend y /root/base580-frontend.
- Cada workflow construye su imagen y usa scripts/deploy.sh con bloqueo flock.
- Respaldo y evidencia de Actions en [[Deploy Flow]]. No borrar volúmenes.

## Cambios y validación

- Miguel Rios Bravo en encabezado y reportes.
- Flecha inferior para ocultar/mostrar módulos; slide y gestos en móvil.
- Proxy /api, propiedad Mongo Spring Boot 4 y sincronización completa de socios,
  catálogos y auditoría corregidos.
- Frontend: cinco pruebas y build correctos. Backend: dos pruebas dentro de Docker
  con Java 24. Prueba aislada Docker de las tres capas correcta.
- Local nativo: localhost:4200, backend localhost:8080 y Mongo localhost:27017.

## Pendientes

Pago de boletos: las hojas de captura ya están en pestañas y los importes se editan en el corte. Siguen fuera la impresión, la consulta histórica de cortes, folio, formas de pago y ligar el corte a un socio. Ver [[Pago de Boletos 2026]].

## 2026-11-11 — Gestión completa de pestañas en boletos

- El menú contextual se fija en la parte superior y muestra añadir, cambiar nombre y eliminar para cualquier pestaña.
- La réplica importada del Excel es editable: renombrar y eliminar hojas originales se persiste como estructura del libro; las fórmulas se actualizan al renombrar.
- Las nuevas hojas conservan el nombre escrito sin anteponer `BASE`.

## 2026-11-11 — Tamaño y filas de hojas nuevas

- Las hojas nuevas comienzan con columnas A–Z y filas 1–200.
- El menú contextual de columnas permite insertar/eliminar columnas también en hojas nuevas.
- El menú contextual de números de fila permite agregar filas arriba/abajo y eliminar filas, conservando la estructura al guardar.
- Todas las hojas muestran la misma rejilla base de A–AL y filas 1–200 para evitar cortes visuales entre pestañas.
- La barra de pestañas permanece visible en la parte inferior mientras se desplaza la hoja.
- Las pestañas se pueden reordenar manteniendo presionado el libro y arrastrándolo a otra posición; el orden se comparte al guardar.

Despliegue terminado; quedan funcionalidades del prototipo: concurrencia al guardar
estado completo, historial truncado y operaciones/reportes con datos de ejemplo.
Todos los agentes consultan y actualizan este vault compartido según CLAUDE.md.
