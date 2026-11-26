---
type: flow
status: active
purpose: "Publicación, despliegue independiente y recuperación de Base580"
tags: [flow, deploy]
created: 2026-10-15
updated: 2026-11-26
---

# Deploy Flow

## Deploy del backend a la VM nueva — requisitos (2026-11-26)

Tras migrar a `base580-vm` (`34.41.156.148`) el 24-nov, el deploy automático del backend estuvo roto hasta el 26-nov. Dejar fijos estos puntos para no repetirlo:

- **Secrets del repo `base580-backend`** deben apuntar a la VM nueva, no solo `DEPLOY_HOST`:
  - `DEPLOY_USER=basetaxi580` (usuario SSH con `sudo` sin contraseña; su `$HOME` contiene los clones `base580-backend`/`base580-infra`).
  - `DEPLOY_SSH_KEY` = llave privada `~/.ssh/base580_deploy` (ed25519, etiqueta `github-actions-base580`), cuya pública ya está autorizada en la metadata de la instancia para `basetaxi580`.
  - `DEPLOY_KNOWN_HOSTS` quedó obsoleto, pero el workflow backend (`appleboy/ssh-action`) no lo usa.
- **La VM requiere Docker Compose v2.** `scripts/deploy.sh` construye la imagen desde el código solo con v2 (`docker compose config --format json` + `--wait`); si solo hay `docker-compose` v1 aborta con `Building from a source directory requires Docker Compose v2`. El plugin oficial se instaló en `/usr/local/lib/docker/cli-plugins/docker-compose` (disponible para root). Re-provisionar la VM sin v2 repite la falla.
- **GCP:** proyecto `project-aec4ec0c-c3a8-468a-b10` (plataforma580); instancia `base580-vm`, zona `us-central1-a`. Inspección/administración con `gcloud compute ssh base580-vm --project <id> --zone us-central1-a` bajo la cuenta `basetaxi580@gmail.com`.
- Re-disparo manual del deploy: `gh workflow run deploy.yml -R basetaxi580-580/base580-backend --ref main` (el workflow admite `workflow_dispatch`). Verificar luego `GET https://sitio580.com.mx/api/boletos/libro` → `200`.

Síntoma que esto resuelve: en `/boletos` el botón Guardar se activaba pero no persistía (`PUT /api/boletos/libro` → 404 porque la imagen del backend era anterior a `BoletosLibroController`).

## Destino fijo de producción — 2026-11-24

La producción oficial es la VM GCP `base580-vm` con IP estática `34.41.156.148` (`base580-web-ip`, `us-central1`). El registro DNS `@` de `sitio580.com.mx` debe apuntar a esa IP y `www` debe permanecer como CNAME hacia el dominio raíz. Los tres repositorios usan `DEPLOY_HOST=34.41.156.148`.

No usar `179.236.81.226`: es un destino anterior que no responde por SSH ni HTTP. No modificar DNS ni secretos de Actions desde un PR funcional. Antes de cada publicación, leer esta página y [[hot]], comprobar la cuenta `basetaxi580-580`, y verificar la URL pública después del deploy. El deploy frontend `45476619835` fue verificado en GCP el 2026-11-24.

Si una máquina continúa llegando a `179.236.81.226` aunque el DNS público ya devuelva `34.41.156.148`, revisar `C:\Windows\System32\drivers\etc\hosts`, eliminar entradas antiguas del dominio y ejecutar `ipconfig /flushdns`. No corregir este síntoma cambiando otra vez el DNS o `DEPLOY_HOST`.

## Último despliegue verificado — 2026-11-11

Los cambios de `/boletos` ya están integrados y publicados bajo la cuenta `basetaxi580-580`:

| Servicio | PR integrado | Commit en `main` | Workflow |
| --- | --- | --- | --- |
| Frontend | [#11](https://github.com/basetaxi580-580/base580-frontend/pull/11) | `49e5104` | [43112205518](https://github.com/basetaxi580-580/base580-frontend/actions/runs/43112205518) success |
| Backend | [#5](https://github.com/basetaxi580-580/base580-backend/pull/5) | `905dea7` | [43112622446](https://github.com/basetaxi580-580/base580-backend/actions/runs/43112622446) success |
| Infraestructura | [#5](https://github.com/basetaxi580-580/base580-infra/pull/5) | `dce31e4` | workflow sin cambios funcionales al producto |

El frontend se actualizó a las `2026-11-11 22:39:30 GMT` y dejó de servir la versión anterior del 6 de noviembre.

> ⚠️ **Corrección 2026-11-26:** la verificación del 11-11 cubrió solo la **página** `/boletos` (frontend), no el guardado. El deploy backend `43112622446` marcó "success" como workflow, pero su destino era anterior a la migración de la VM (24-nov), así que **nunca llegó a la VM productiva actual `base580-vm`**: `GET /api/boletos/libro` estuvo en **404** hasta el 26-nov. Ver la sección "Deploy del backend a la VM nueva — requisitos (2026-11-26)" arriba y [[log]].

### Recuperación de una cola de Actions

Si un despliegue de `main` aparece pausado:

1. Consultar el estado del PR y del run con `gh pr view` y `gh run view`.
2. Revisar `jobs` y `pending_deployments`; si el job está `queued` sin runner y no hay aprobación pendiente, el problema está en la cola.
3. Revisar concurrencia. En frontend, los eventos `pull_request` y `push` comparten `frontend-deploy` y `cancel-in-progress: false`.
4. Si el PR ya fue integrado, cancelar únicamente el run de PR obsoleto.
5. Esperar o reencolar el run de `main`; verificar que termine en `success` antes de revisar producción.
6. Confirmar la fecha `Last-Modified` de `https://sitio580.com.mx/boletos` y hacer `Ctrl + F5` en el navegador.

No cancelar runs que estén ejecutando una transferencia activa al servidor. Esta recuperación no cambia código ni hace otro merge.

## Estado actual — 2026-10-21

Cuenta GitHub: **basetaxi580-580**. `/boletos` (19 pestañas + API tarifas/cortes) publicado:

| Repo | PR | Workflow |
| --- | --- | --- |
| Backend | [#2](https://github.com/basetaxi580-580/base580-backend/pull/2) | [39706545908](https://github.com/basetaxi580-580/base580-backend/actions/runs/39706545908) success |
| Frontend | [#4](https://github.com/basetaxi580-580/base580-frontend/pull/4) + CSS [#5](https://github.com/basetaxi580-580/base580-frontend/pull/5) | [39706976442](https://github.com/basetaxi580-580/base580-frontend/actions/runs/39706976442) success |
| Infra wiki | [#2](https://github.com/basetaxi580-580/base580-infra/pull/2) | docs en main |

Sitio: http://34.41.156.148/ (`/boletos`). La IP externa estática es `34.41.156.148` (`base580-web-ip`, región `us-central1`). El acceso por los dominios `sitio580.com.mx` y `www.sitio580.com.mx` termina TLS en Caddy y se reenvía al frontend Nginx. Detalle producto: [[Pago de Boletos 2026]].

## Histórico — 2026-10-15

Sitio publicado y verificado (IP de entonces en el run de Actions).

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

## Preparar un Pull Request

Obsidian no crea ni sube PRs automáticamente; funciona como contexto compartido y checklist. Para los cambios actuales de `/boletos`, el repositorio principal es `base580-frontend`.

1. Revisar [[hot]], esta página y [[base580-frontend]].
2. En el repositorio correspondiente, confirmar pruebas, build, rama y diff.
3. Crear una rama de trabajo, subirla al remoto y abrir un PR independiente en GitHub.
4. Esperar el workflow `deploy.yml`; el deploy se realiza después de integrar en `main`, no al editar la wiki.

La documentación de Obsidian ayuda a preparar el PR y conservar el contexto, pero no reemplaza GitHub, Git ni GitHub Actions. No ejecutar push o merge sin confirmación explícita.

## VM

> ⚠️ **Corrección 2026-11-26 (VM actual `base580-vm`):** los clones de despliegue están en el `$HOME` del usuario **`basetaxi580`** (`~/base580-backend`, `~/base580-infra`, `~/base580-frontend`), **no en `/root`**. Las rutas `/root/...` de abajo describen la VM anterior y ya no aplican. El usuario SSH de deploy es `basetaxi580` (sudo sin contraseña) y la VM requiere Docker Compose v2.

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
