---
type: module
path: "../base580-backend/"
status: active
language: java
purpose: "API Spring Boot y persistencia MongoDB"
maintainer: ""
last_updated: 2026-10-15
linked_issues: []
depends_on: ["MongoDB", "Java 24"]
used_by: ["base580-frontend"]
tags: [module, backend]
created: 2026-10-15
updated: 2026-10-15
---

# base580-backend

Repo hermano: `../base580-backend`.

## Hechos conocidos

- Java 24 + Spring Boot (`./mvnw spring-boot:run` / `mvnw.cmd` en Windows).
- Default Mongo URI: `mongodb://localhost:27017/base580` (`MONGODB_URI` override).
- Contenedor escucha 8080; health usado por Compose/frontend.
- Endpoint de estado vía proxy: `/api/state`.

## Gaps

> [!gap] Detalle de dominio
> Módulos Java, modelos de socio/operación y contratos API aún no ingestados. Añadir README/export al `.raw/` y decir "ingest".
