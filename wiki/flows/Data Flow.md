---
type: flow
status: active
purpose: "Camino de una petición HTTP en runtime"
tags: [flow]
created: 2026-10-15
updated: 2026-10-15
---

# Data Flow

```text
Navegador
  → frontend:80 (Nginx)          # puerto publicado (dev suele ser 4200)
      → static Angular assets
      → /api/* → backend:8080
                    → mongo:27017
```

- Solo el frontend se publica hacia la red.
- Backend y Mongo exponen puertos de desarrollo en `127.0.0.1`.
- Red Docker: `base580-net`.
- Volumen: `mongo_data` persiste entre despliegues.

See [[Architecture Overview]], [[base580-frontend]], [[base580-backend]].
