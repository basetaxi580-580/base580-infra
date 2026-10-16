---
type: domain
status: active
tags: [domain, infra]
created: 2026-10-15
updated: 2026-10-15
---

# Infrastructure

Dominio técnico de despliegue y runtime. Dueño principal: [[base580-infra]].

Temas clave: [[Data Flow]], [[Deploy Flow]], Compose, VM layout, secretos Actions, volumen Mongo.

> [!key-insight] Separación de repos
> Frontend y backend construyen sus propias imágenes; infra solo define red, puertos, volúmenes y el script de deploy.
