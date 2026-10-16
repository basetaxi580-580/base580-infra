---
type: module
path: ".."
status: active
language: multi
purpose: "Mapa de arquitectura de los tres repositorios Base580"
maintainer: ""
last_updated: 2026-10-15
linked_issues: []
depends_on: []
used_by: []
tags: [module, architecture]
created: 2026-10-15
updated: 2026-10-15
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
