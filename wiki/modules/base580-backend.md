---
type: module
path: "../base580-backend/"
status: active
language: java
purpose: "API Spring Boot y persistencia MongoDB"
maintainer: ""
last_updated: 2026-10-20
linked_issues: []
depends_on: ["MongoDB", "Java 24"]
used_by: ["base580-frontend"]
tags: [module, backend]
created: 2026-10-15
updated: 2026-10-20
---

# base580-backend

Repo hermano: `../base580-backend`.

## Hechos conocidos

- Java 24 + Spring Boot (`./mvnw spring-boot:run` / `mvnw.cmd` en Windows).
- Default Mongo URI: `mongodb://localhost:27017/base580` (`MONGODB_URI` override).
- Contenedor escucha 8080; health usado por Compose/frontend.
- Endpoint de estado vía proxy: `/api/state`.

## Contrato real

Spring Boot 4.1, Java 24, `spring-boot-starter-data-mongodb`. URI `MONGODB_URI`, default `mongodb://localhost:27017/base580`.

Colección usada: `app_state`, un documento. Repositorio: `AppStateRepository`. `MemberDocument` no se persiste.

`AppStateController` en `/api`:

- `GET` y `PUT /state` — lectura y reemplazo del documento
- `GET` y `PUT /members`, `POST /members/{id}/history`, `GET /members/{id}/audit`
- `GET /catalogs/{key}`, `GET /catalogs/prices`, `PUT /catalogs`
- `POST /seed` — vuelve al ejemplo

El frontend solo llama `GET` y `PUT /state`. Los métodos del servicio son `synchronized` en una JVM. `appendAudit` conserva 20 entradas; `appendMemberHistory` conserva 10. Fechas de negocio son textos de pantalla (`Hoy`, `Ahora`).

No hay Spring Security. CORS declarado solo para `localhost:4200` y `127.0.0.1:4200`; en Compose el navegador habla con Nginx en el mismo origen.
