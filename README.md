# Base580: infraestructura

Los tres repositorios son independientes. Frontend y backend construyen sus
propias imagenes; este repositorio define red, puertos, volumenes y despliegue.
Compose consume imagenes, sin rutas de codigo ni contextos de build externos.

## Wiki Obsidian (conocimiento compartido)

Este repo es el vault Obsidian de Base580. Abre la carpeta `base580-infra` en
Obsidian. Todas las IAs deben consultar y actualizar `wiki/` (empezar por
`wiki/hot.md` y `wiki/index.md`). Fuentes inmutables en `.raw/`. Esquema en
`CLAUDE.md`.

Navegador -> frontend:80 (Nginx) -> /api/* -> backend:8080 -> mongo:27017

Solo el frontend se publica hacia la red. Backend y Mongo exponen puertos de
desarrollo en 127.0.0.1. La red compartida es base580-net. El volumen mongo_data
conserva los datos entre despliegues.

## Inicio local con contenedores

Requisitos: Docker con el motor iniciado y Compose v2 con soporte para up --wait.
Los ejemplos suponen tres clones hermanos, pero las imagenes pueden construirse
desde cualquier ubicacion.

```bash
docker build -t base580-backend:latest ../base580-backend
docker build -t base580-frontend:latest ../base580-frontend
cp env.example .env
docker compose config --quiet
docker compose up -d --wait --wait-timeout 180
```

Abre http://localhost:4200. http://localhost:4200/api/state debe responder JSON.
El navegador llama al mismo origen. Backend espera a Mongo saludable y frontend
espera a backend saludable.

## Desarrollo sin contenedores para las aplicaciones

```bash
docker compose up -d --wait mongo
# En el repositorio backend (Java 24):
./mvnw spring-boot:run
# En el repositorio frontend (Node 24):
npm ci
npm start
```

En Windows usa mvnw.cmd. Angular reenvia /api/** a 127.0.0.1:8080. Backend usa
mongodb://localhost:27017/base580 por defecto; cambia MONGODB_URI si es necesario.
Si cambias los puertos de desarrollo, ajusta el proxy y/o esa URI.

## VM y despliegues independientes

La VM necesita Docker Compose v2, Bash, flock, jq y los clones:

```text
~/base580-infra
~/base580-backend
~/base580-frontend
```

1. Actualiza primero el clon de infraestructura con estos cambios.
2. Copia env.example a .env; usa FRONTEND_PORT=80 en la VM.
3. Construye ambas imagenes con los comandos del inicio local.
4. Ejecuta sudo bash scripts/deploy.sh all desde infraestructura.

Despues cada workflow actualiza su propio clon y llama a:

```bash
sudo bash ~/base580-infra/scripts/deploy.sh backend ~/base580-backend
sudo bash ~/base580-infra/scripts/deploy.sh frontend ~/base580-frontend
```

El script construye la imagen configurada en .env, valida Compose y actualiza
solo el servicio solicitado. Un bloqueo compartido serializa despliegues de
los tres repositorios. Nginx vuelve a resolver el nombre del backend si cambia
la IP de su contenedor. El despliegue del frontend tambien verifica /api/state.

Los tres repositorios requieren los secretos de GitHub Actions DEPLOY_HOST,
DEPLOY_USER y DEPLOY_SSH_KEY. La cuenta SSH necesita acceso de lectura a sus
clones y permiso para ejecutar estos comandos con sudo sin interaccion.

El workflow de infraestructura aplica Compose a las imagenes disponibles;
no descarga ni compila codigo de las aplicaciones. Si usas imagenes de un
registro, configura sus referencias en .env y ejecuta docker compose pull
antes del despliegue. Los workflows actuales construyen en la VM y no publican
imagenes en un registro.

## Migrar desde los antiguos docker run

Los contenedores manuales usan los mismos nombres. Antes del primer compose up,
verifica con docker inspect base580-mongo donde estan los datos y respalda Mongo.
Deten y retira los contenedores antiguos de frontend/backend durante una ventana
de mantenimiento. Si Mongo tambien fue creado manualmente, configura Compose
para reutilizar su volumen existente antes de reemplazarlo. No ejecutes
'docker compose down -v': elimina los datos del volumen.

## Comprobaciones

```bash
docker compose config --quiet
docker compose ps
docker compose logs --tail=100 backend frontend
curl -f http://localhost:4200/healthz
curl -f http://localhost:4200/api/state
```

Usa el puerto configurado en .env si difiere de 4200. Un 502 en /api indica que
Nginx no alcanza el backend; revisa salud, red y logs.
