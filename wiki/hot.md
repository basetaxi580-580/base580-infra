---
type: meta
title: "Hot Cache"
status: active
created: 2026-10-15
updated: 2026-10-21
tags: [meta, context]
---

# Recent Context

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

Despliegue terminado; quedan funcionalidades del prototipo: concurrencia al guardar
estado completo, historial truncado y operaciones/reportes con datos de ejemplo.
Todos los agentes consultan y actualizan este vault compartido según CLAUDE.md.
