---
type: meta
title: "Hot Cache"
status: active
created: 2026-10-15
updated: 2026-10-21
tags: [meta, context]
---

# Recent Context

## Last Updated

2026-10-21 (cierre de sesión). Memoria Obsidian actualizada. Sin commit/push/deploy pedidos. Continuar en [[Pago de Boletos 2026]].

## Cierre de sesión — `/boletos`

Fuente oficial: `C:\Users\carlo\Downloads\PAGO BOLETOS 2026.xlsx`.

- **19 pestañas** = orden/nombres del libro (10 `BASE *` catálogo + captura + `TOTAL`). Colores: TAPO `#FF66FF`, NORTE 26 `#FFC000`, especiales `#FFFF00`, PTE `#00B0F0`.
- Catálogo (`catalogo: true`): sin SERV. Captura: cantidad/importe. Norte captura = layout BASE NTE + SERV.
- Semilla: `extract_boletos_tarifas.py` → `tarifas.tsv` (**861** tarifas; incluye TAPO 24, REZ, PTE 25). Al reiniciar backend, `ensureSeed` mete las faltantes.
- Código: `boletos.page.ts`, `boletos-hojas.ts`, `boletos-grid.ts`. Default hoja `base-nte-26`. Orden localStorage se resetea si faltan ids `base-*`.

## UX pestañas / cuadrícula

- Mantener **1 s** → temblor (~0.7 s/ciclo); × rojo sólido; drag reorder; Esc/fuera sale.
- Hover crece suave (no en temblor). `+` crea libre con nombre. Renombrar clic derecho.
- Autosave 1.5 s / salir celda. Undo 5. Menú celda, negrita, fusiones, fórmulas, coords rosa, resize.
- `localStorage`: `boletos-hojas-orden|ocultas|libres|nombres|formatos|fusiones|etiquetas|medidas|formulas|formulas-tocadas|cuadricula`.

## Negocio / pendiente

Fuera aún: impresión, historial de cortes, folio, formas de pago, copiar `I15` / desfase TAPO `I29→K30`, TOTAL con D31 ponderado. Detalle: [[Pago de Boletos 2026]].

## Estado actual (resto)

2026-10-21: Norte 2025/2026 copian BASE NTE: A–F y H–M, G vacía; PAGAR `=B3-C3-D3-E3`; U–Z nocturno `=B40+20`.

2026-10-20: el marco ya no muestra Accesos rápidos ni Estado del sistema; el menú lateral sigue en todas las pantallas.

2026-10-20: openpyxl 3.1.5 instalado en Python 3.12 del sistema para leer libros .xlsx.

2026-10-20: BMAD-METHOD 6.13.0-next instalado en la raíz del workspace para Cursor. Skills en `.agents/skills`, runtime en `_bmad`. Falta `bmad-retrospective` por un YAML inválido en el origen.

2026-10-20: `/captura` solo edita sitio, placas, engomado, vencimiento, estatus y observaciones. Sin empleado, resumen ni historial en esa pantalla.

2026-10-20: revisión de arquitectura contra el código. El despliegue de tres repos
sigue cerrado. El dominio es un documento `app_state` (`_id=default`) que el
frontend reemplaza con PUT /api/state. Solo captura, catálogos y validación
persisten. Operaciones, cancelación, reimpresión y reportes son de pantalla o
ejemplo. Historial recortado a 10 y auditoría a 20. POST /api/seed y el API
viajan sin autenticación por el mismo Nginx público. `MemberDocument` no se usa.

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
  reportes PDF e historial conservado como requisito.

## Despliegue y respaldo

- VM: clones limpios /root/base580-infra, /root/base580-backend y /root/base580-frontend.
- Cada workflow construye su imagen y usa scripts/deploy.sh con bloqueo flock.
- Respaldo y evidencia de Actions en [[Deploy Flow]]. No borrar volúmenes.

## Cambios y validación

- Miguel Rios Bravo en encabezado y reportes.
- Flecha inferior para ocultar/mostrar módulos; slide y gestos en móvil.
- Proxy /api, propiedad Mongo Spring Boot 4 y sincronización completa de socios,
  catálogos y auditoría corregidos.
- Frontend: cinco pruebas y build correctos. Backend: dos pruebas dentro de Docker
  con Java 24. Prueba aislada Docker de las tres capas correcta.
- Local nativo: localhost:4200, backend localhost:8080 y Mongo localhost:27017.

## Pendientes

Pago de boletos: las hojas de captura ya están en pestañas y los importes se editan en el corte. Siguen fuera la impresión, la consulta histórica de cortes, folio, formas de pago y ligar el corte a un socio. Ver [[Pago de Boletos 2026]].

Despliegue terminado; quedan funcionalidades del prototipo: concurrencia al guardar
estado completo, historial truncado y operaciones/reportes con datos de ejemplo.
Todos los agentes consultan y actualizan este vault compartido según CLAUDE.md.
