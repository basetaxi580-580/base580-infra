---
type: flow
status: active
purpose: "Publicación, despliegue independiente y recuperación de Base580"
tags: [flow, deploy]
created: 2026-10-15
updated: 2026-10-15
---

# Deploy Flow

## Estado actual — 2026-10-15

Sitio publicado y verificado: http://179.236.81.226/.

Los tres PR #1 están integrados mediante squash en main:

| Repositorio | PR | Commit desplegado | Workflow |
| --- | --- | --- | --- |
| Infraestructura | [#1](https://github.com/basetaxi580-580/base580-infra/pull/1) | 3366f6a | [38834522441](https://github.com/basetaxi580-580/base580-infra/actions/runs/38834522441) |
| Backend | [#1](https://github.com/basetaxi580-580/base580-backend/pull/1) | 5818b99 | [38834621044](https://github.com/basetaxi580-580/base580-backend/actions/runs/38834621044) |
| Frontend | [#1](https://github.com/basetaxi580-580/base580-frontend/pull/1) | 96b65eb | [38834742069](https://github.com/basetaxi580-580/base580-frontend/actions/runs/38834742069) |

Los workflows terminaron correctamente. Frontend, backend y MongoDB están saludables.
Nginx y /api/state responden HTTP 200 desde el sitio público. El navegador muestra
Miguel Rios Bravo y permite ocultar el menú con la flecha inferior.

## Repositorios y publicación

Cuenta GitHub autenticada: basetaxi580-580; correo solicitado por el usuario:
basetaxi580@gmail.com. Los remotos son repositorios independientes:

- https://github.com/basetaxi580-580/base580-frontend
- https://github.com/basetaxi580-580/base580-backend
- https://github.com/basetaxi580-580/base580-infra

Verificar cuenta, permisos y rama antes de publicar. user.email sólo configura la
autoría y no autentica GitHub. Crear una rama y PR por repositorio. Push a main
activa el workflow de ese servicio; no mezclar sus historiales.

## VM

Los clones de despliegue están en /root/base580-infra, /root/base580-backend y
/root/base580-frontend. Los tres son clones limpios en main. Se instalaron jq y flock
está disponible. Docker Compose administra la red base580-net y conserva el volumen
base580-infra_mongo_data.

La configuración local de VM está en /root/base580-infra/.env (no versionada):
FRONTEND_PORT=80, BACKEND_IMAGE=base580-backend:latest,
FRONTEND_IMAGE=base580-frontend:latest y COMPOSE_PROJECT_NAME=base580-infra.
Backend y MongoDB sólo publican sus puertos al loopback del host.

Cada workflow actualiza su clon y ejecuta el script de infraestructura:

```bash
sudo bash ~/base580-infra/scripts/deploy.sh backend ~/base580-backend
sudo bash ~/base580-infra/scripts/deploy.sh frontend ~/base580-frontend
```

El script construye la imagen configurada, serializa despliegues mediante flock y
actualiza sólo el servicio solicitado. Nginx vuelve a resolver el nombre del backend
si cambia su IP. El despliegue del frontend verifica también /api/state.

El workflow de infraestructura admite inspect_only=true para inspeccionar sin
cambiar servicios. Secretos Actions: DEPLOY_HOST, DEPLOY_USER y DEPLOY_SSH_KEY.
La llave dedicada local es ~/.ssh/base580_deploy; su parte pública fue autorizada
por el usuario en la VM y los secretos de los tres repositorios se actualizaron.
No publicar la llave privada. La inspección autenticada pasó en el run 38834332594.

## Respaldo y recuperación

Respaldo previo: /root/base580-backups/20261016T011735Z en la VM, accesible por root.
Incluye mongo.archive.gz, source-before-deploy.tar.gz, containers.json y los clones
originales bajo original-base580-infra/backend/frontend. El backend original tenía
cambios sin commit en dos nombres de demostración; se conservaron sin sobrescribir.
El frontend original no tenía .git; se conservó completo y se instaló un clon limpio.

Las imágenes anteriores se conservaron como
base580-backend:rollback-20261016T011735Z y
base580-frontend:rollback-20261016T011735Z. Para recuperar aplicaciones se pueden
seleccionar estas referencias en .env y aplicar Compose. Restaurar Mongo desde el
archivo sólo si fuera necesario; el despliegue conserva el volumen original.
Nunca ejecutar docker compose down -v para una actualización.

## Verificación realizada

- Frontend: build de producción y cinco pruebas correctas.
- Backend: dos pruebas correctas dentro de Docker con Java 24 y Maven verify.
- Prueba aislada Docker de Nginx -> API -> MongoDB temporal, eliminada al terminar.
- Configuración Compose y sintaxis Bash correctas.
- Sitio público, API, favicon y controles del menú verificados en navegador.
- Se corrigieron permisos de favicon en el origen de la VM y se reconstruyó la
  imagen mediante el workflow; el archivo servido tiene permisos 644.

## Local

```bash
docker build -t base580-backend:latest ../base580-backend
docker build -t base580-frontend:latest ../base580-frontend
cp env.example .env
docker compose up -d --wait --wait-timeout 180
```

El entorno local nativo también funciona con Angular en localhost:4200, backend
en localhost:8080 y MongoDB en localhost:27017. Ver README de infraestructura.

## Pendientes funcionales

El despliegue está completado. Persisten pendientes del prototipo: concurrencia del
endpoint que reemplaza el estado completo, conservación integral del historial y
flujos operativos que todavía utilizan datos de demostración. No confundir un
despliegue saludable con la finalización de todos los módulos del producto.
