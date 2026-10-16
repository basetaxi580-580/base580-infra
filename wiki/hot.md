---
type: meta
title: "Hot Cache"
status: active
created: 2026-10-15
updated: 2026-10-15
tags: [meta, context]
---

# Recent Context

## Estado actual

2026-10-15: Base580 publicado en http://179.236.81.226/ y verificado. PR #1 de
frontend, backend e infraestructura integrados en main; workflows correctos.
Los tres contenedores están saludables y /api/state responde HTTP 200 desde Nginx.

## Arquitectura y decisiones

- Tres repositorios independientes bajo GitHub basetaxi580-580: frontend Angular/Nginx,
  backend Spring Boot/MongoDB e infraestructura Compose/deploy/Obsidian.
- Navegador -> frontend:80 -> /api/* -> backend:8080 -> mongo:27017.
- Sólo frontend se publica a la red; puertos backend/Mongo en loopback.
- Red base580-net; volumen persistente base580-infra_mongo_data conservado.
- Cuenta solicitada: basetaxi580@gmail.com. gh autenticado como basetaxi580-580.
- Producto: CRM operativo, mismos módulos del sistema anterior, sin roles en esta fase,
  reportes PDF e historial conservado como requisito. Trabajar por sprint.

## Despliegue y respaldo

- VM: clones limpios /root/base580-infra, /root/base580-backend y /root/base580-frontend.
- Cada workflow construye su imagen y usa scripts/deploy.sh con bloqueo flock.
- La llave local dedicada ~/.ssh/base580_deploy fue autorizada por el usuario;
  DEPLOY_HOST, DEPLOY_USER y DEPLOY_SSH_KEY actualizados en los tres repositorios.
- Respaldo previo: /root/base580-backups/20261016T011735Z, con Mongo, fuentes,
  metadatos de contenedores y carpetas originales. Imágenes rollback preservadas.
- Backend previo tenía cambios sin commit; frontend previo no era clon Git. Todo
  se conservó en el respaldo al preparar clones nuevos.
- Detalles, commits y evidencia de Actions en [[Deploy Flow]]. No borrar volúmenes.

## Cambios y validación

- Miguel Rios Bravo en encabezado y reportes.
- Flecha inferior para ocultar/mostrar módulos; slide y gestos en móvil.
- Proxy /api, propiedad Mongo Spring Boot 4 y sincronización completa de socios,
  catálogos y auditoría corregidos.
- Frontend: cinco pruebas y build correctos. Backend: dos pruebas dentro de Docker
  con Java 24. Prueba aislada Docker de las tres capas correcta.
- Local nativo: localhost:4200, backend localhost:8080 y Mongo localhost:27017.

## Pendientes

Despliegue terminado; quedan funcionalidades del prototipo: concurrencia al guardar
estado completo, historial truncado y operaciones/reportes con datos de ejemplo.
Todos los agentes consultan y actualizan este vault compartido según CLAUDE.md.
