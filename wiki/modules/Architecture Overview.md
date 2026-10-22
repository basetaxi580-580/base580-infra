---
type: module
path: ".."
status: active
language: multi
purpose: "Mapa de arquitectura de los tres repositorios Base580"
maintainer: ""
last_updated: 2026-10-20
linked_issues: []
depends_on: []
used_by: []
tags: [module, architecture]
created: 2026-10-15
updated: 2026-10-20
---

# Architecture Overview

Tres clones hermanos independientes. Las imágenes se construyen en cada repo de app; [[base580-infra]] solo orquesta red, puertos, volúmenes y despliegue.

```text
~/base580-infra
~/base580-backend
~/base580-frontend
```

## Componentes

- **frontend** — Angular servido por Nginx en el puerto publicado (dev 4200 / VM 80). Proxy `/api/*` al backend.
- **backend** — Spring Boot en 8080 (solo 127.0.0.1 en compose de desarrollo).
- **mongo** — MongoDB 27017, volumen `mongo_data`.

Red compartida: `base580-net`.

Ver [[Data Flow]] y [[Deploy Flow]]. Stack en [[Tech Stack]].

## Modelo vivo — revisión 2026-10-20

El dominio cabe en un documento Mongo `app_state` con `_id` `default`: socios, catálogos y auditoría. El frontend lo carga al arrancar y lo reemplaza con `PUT /api/state`. Solo captura, catálogos y validación vuelven a enviarlo.

`MemberDocument` (`@Document("members")`) no tiene repositorio. El perfil que viaja en el API es `AppStateDocument.MemberProfile`.

Operaciones, cancelación, reimpresión y reportes viven en la pantalla. Los reportes usan filas fijas y exportan con `window.print`. El historial de ficha se recorta a 10 y la auditoría a 20 dentro de `AppStateService`.

`POST /api/seed` restaura el ejemplo. No hay Spring Security; Nginx publica todo `/api` en el mismo origen que la UI.

## Siguiente corte

Colecciones separadas para socios, operaciones y catálogos. Escrituras parciales e historial append-only.
