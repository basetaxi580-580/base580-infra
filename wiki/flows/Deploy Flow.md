---
type: flow
status: active
purpose: "Cómo se construyen imágenes y se actualizan servicios"
tags: [flow, deploy]
created: 2026-10-15
updated: 2026-10-15
---

# Deploy Flow

## Publicación en GitHub

### PR y preparación del despliegue — 2026-10-15

- PR creados, abiertos y sin conflictos: [infra #1](https://github.com/basetaxi580-580/base580-infra/pull/1), [backend #1](https://github.com/basetaxi580-580/base580-backend/pull/1), [frontend #1](https://github.com/basetaxi580-580/base580-frontend/pull/1).
- Pruebas locales repetidas: frontend 5/5 y backend 2/2 (override Java 21 local); Compose y sintaxis Bash correctos. Los PR no tienen checks automáticos configurados.
- Deploy pendiente de acceso a la VM. Últimos runs frontend/backend terminaron con `ssh: handshake failed ... connection reset by peer`; el run histórico de infra falló por host no configurado (anterior a la creación de secretos).
- Los nombres de secretos existen, pero sus valores no pueden recuperarse mediante GitHub. Se solicitó al usuario IP/dominio y usuario SSH, sin pedir contraseñas ni llaves privadas.
- No integrar main hasta comprobar acceso, volumen Mongo y preparación de Compose en la VM. No se ejecutó despliegue en esta fase.

- Cuenta solicitada por el usuario: `basetaxi580@gmail.com`. Propietario de los remotos existentes: `basetaxi580-580` (GitHub no publica su correo; verificar la identidad al iniciar sesión).
- Repositorios independientes: `https://github.com/basetaxi580-580/base580-frontend`, `https://github.com/basetaxi580-580/base580-backend` y `https://github.com/basetaxi580-580/base580-infra`.
- Verificar `gh auth status`, `git remote -v`, rama y cambios de cada repositorio antes de publicar. La cuenta usada debe tener permiso de escritura; configurar `user.email` no autentica GitHub.
- Preparar commits y subir ramas de trabajo por repositorio para revisión. No mezclar sus historiales ni subir dependencias, builds o secretos.
- Un push a `main` activa el workflow de despliegue. La migración a Compose requiere preparación de la VM y respaldo/verificación del volumen Mongo descritos en el README antes de integrar las ramas.
- Autenticación completada por el usuario: cuenta activa `basetaxi580-580`, con permiso de escritura verificado en los tres repositorios. Rama de publicación: `codex/integracion-repos-ui`; frontend y backend subidos a origin. Infraestructura incluye este registro de publicación. No se modifica main ni se activa despliegue.

## Local

```bash
docker build -t base580-backend:latest ../base580-backend
docker build -t base580-frontend:latest ../base580-frontend
cp env.example .env
docker compose up -d --wait --wait-timeout 180
```

## VM

1. Actualizar clon de [[base580-infra]].
2. `.env` con `FRONTEND_PORT=80`.
3. Construir imágenes o dejar que workflows lo hagan.
4. `sudo bash scripts/deploy.sh all` (o `backend` / `frontend` con path al clon).

`deploy.sh` usa flock para serializar deploys de los tres repos. Nginx re-resuelve el backend si cambia su IP. Deploy frontend verifica `/api/state`.

Secretos Actions: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`.

## Verificación local — 2026-10-15

- Arranque local nativo comprobado: Angular en `http://localhost:4200`, backend en `http://localhost:8080` y Mongo existente en `127.0.0.1:27017`. Salud `UP`; `/api/state` a través del proxy Angular devuelve HTTP 200 con JSON. Procesos iniciados en segundo plano; logs en `%TEMP%/base580-local`.

- Configuración de Compose y sintaxis Bash validadas.
- Build de producción Angular correcto; advertencia existente de presupuesto CSS (4.94 kB / 4 kB).
- Frontend: cinco pruebas pasan, incluidas tres regresiones de sincronización.
- Backend: dos pruebas pasan con Java 21 mediante override local; el proyecto y su Dockerfile mantienen Java 24.
- La prueba Mongo verifica que `MONGODB_URI` selecciona la base indicada mediante `spring.mongodb.uri`, sin leer ni modificar datos.
- Pendiente: prueba completa con contenedores (motor Docker local apagado) y aplicación en VM. No se hizo push ni despliegue.
- La sincronización carga todos los socios, catálogos y auditoría sin registrar una edición ficticia. El guardado conserva las auditorías de todos los socios.
- Sigue pendiente resolver concurrencia del endpoint que reemplaza el estado completo y persistir los flujos operativos que aún usan datos de demostración.

See [[base580-infra]], [[Infrastructure]].
