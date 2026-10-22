---
type: meta
title: "Wiki Log"
status: active
created: 2026-10-15
updated: 2026-10-21
tags: [meta, log]
---

# Wiki Log

## 2026-10-21 — Cierre: /boletos en productivo (basetaxi580-580)

- PRs mergeados y deploy OK: backend [#2](https://github.com/basetaxi580-580/base580-backend/pull/2), frontend [#4](https://github.com/basetaxi580-580/base580-frontend/pull/4) + CSS budget [#5](https://github.com/basetaxi580-580/base580-frontend/pull/5), wiki infra [#2](https://github.com/basetaxi580-580/base580-infra/pull/2).
- Actions: backend `39706545908` success; frontend `39706976442` success (tras subir `anyComponentStyle` a 16 kB).
- [[hot]] actualizado con URLs/PRs. Sesión cerrada. Cuenta correcta: basetaxi580-580 (no CharlyTlelo).

## 2026-10-21 — Cierre de sesión (memoria Obsidian, pre-deploy)

- Guardado en [[hot]] el estado de `/boletos` antes del deploy: 19 pestañas, 861 tarifas, UX. Luego se publicó a productivo (ver entrada de arriba).

## 2026-10-21 — Anclar /boletos a PAGO BOLETOS 2026.xlsx

- Fuente oficial: `C:\Users\carlo\Downloads\PAGO BOLETOS 2026.xlsx`.
- **19 pestañas** en `/boletos` con nombres/orden del libro (10 BASE* + captura + TOTAL) y colores TAPO / NORTE 26 / especiales / PTE.
- Extractor: **861** tarifas (añade BASE TAPO 24, BASE TAPO REZ completo, BASE PTE 25).
- Catálogo = sin SERV; captura = cantidad/importe. TOTAL sin ponderar D31; sin copiar I15 ni desfase TAPO.

## 2026-10-21 — Memoria Obsidian: UX pestañas /boletos

- Actualizados [[hot]], [[Pago de Boletos 2026]], [[base580-frontend]] e [[index]].
- Hechos fijados: temblor a 1 s (ciclo ~0.7 s), × rojo sólido, grow al hover, `+` con nombre, autosave 1.5 s, undo 5, claves `localStorage` de hojas/formato.
- Código de referencia: `boletos.page.ts` (+ hojas/grid/formula/math). Sin commit/deploy.

## 2026-10-21 — Menú de celda en /boletos

- Clic derecho en celda abre menú con alineación, tipo de dato y combinar (si hay 2 o más seleccionadas). Separar cuando ya hay fusión.
- Barra de formato: botón B para negrita / normal; Atrás/Adelante con historial de 5.
- Sin botón Guardar: el corte se guarda solo al editar.
- Herramienta `+` para nueva pestaña/hoja libre.
- Pulsación larga 1 s: pestañas tiemblan, se reordenan y se borran/ocultan con × rojo + confirmación.
- Títulos de sección y encabezados de columna son editables y tienen menú de clic derecho.

## 2026-10-21 — Letras y números rosa en /boletos

- Encabezados A, B, C… y 1, 2, 3… con fondo `#fbcfe8` y texto `#9f1239` para contrastar con Sitio.
- Trazo suave y celdas parejas; solo la esquina de origen (arriba-izquierda) va redondeada.

## 2026-10-21 — Redimensionar celdas en /boletos

- Arrastre en el borde de letras (ancho) y números (alto), como Excel. Se guarda por hoja en `boletos-medidas`.

## 2026-10-21 — Cuadrícula más gruesa en /boletos

- Bordes de celda a 2px en `#4b5563` para que no se pierdan sobre zona, desc, sitio y PAGAR.

## 2026-10-21 — Norte 2025 igual a BASE NTE 25

- Una sola hoja: A–F sencillos, G hueco, H–M dobles o nocturnos. Renglones 16 y 17 vacíos. EDOS empieza en 18. Títulos DF SENCILLOS, DF DOBLES, EDOS SENCILLOS y EDOS SENCILLOS NOCTURNOS.
- PAGAR y TOTAL usan `=B3-C3-D3-E3` e `=I3-J3-K3-L3`. U–Z nocturno: precio `=B40+20`. Colores de zona, desc, sitio y pagar como el Excel. Norte 2026 usa el mismo mapa sobre BASE NTE 26 (zona 1: 78 → 59).

## 2026-10-21 — Barra de fórmulas en /boletos

- Arriba de la hoja: referencia de la celda, icono fx y caja de contenido.
- Un texto que empieza con `=` es fórmula. Usa las letras y números de la hoja, por ejemplo `=B3-C3-D3-E3`. También SUMA, PROMEDIO, MIN, MAX, REDONDEAR y ABS.
- La fórmula se guarda en el navegador y se vuelve a calcular cuando cambia una celda que usa.

## 2026-10-21 — Una sola hoja por pestaña en /boletos

- CDMX, Edomex y el resto de una pestaña comparten una tabla. El lado izquierdo es sencillos y el derecho dobles o nocturnos.
- Las letras siguen de A en adelante y los números no se reinician en cada bloque. El renglón 1 es el título de la sección.

## 2026-10-21 — Coordenadas en las tablas de /boletos

- Arriba de cada tabla van las letras A, B, C… A la izquierda, los números de renglón.
- El renglón 1 nombra el campo (zona, precio, descuento…). El primer dato es el renglón 2. Cada bloque empieza de nuevo en A y en 1.

## 2026-10-21 — Menú de formato en /boletos

- Debajo de las pestañas: tamaño de fuente, color de fuente, color de celda y ver u ocultar la cuadrícula.
- El formato cae en las celdas seleccionadas. Sin selección, cubre la hoja activa. Queda en `localStorage` (`boletos-formatos`, `boletos-cuadricula`).

## 2026-10-21 — Toda la fila de /boletos es editable

- Zona, neto e importe son celdas, igual que precio, descuento, sitio, plata y cantidad.
- Precio, descuento, sitio o plata regresan el neto a la fórmula. Neto o cantidad recalculan el importe. Supr en neto o importe devuelve la fórmula. El pie usa el importe de la celda.
- El guardado conserva zona, neto e importe. La tarifa se busca con la clave original, así que renombrar la zona no pierde el renglón.

## 2026-10-21 — Cuadrícula de /boletos como Excel

- Flechas, Enter, Tab, Inicio y Fin mueven la celda. Al salir por la derecha se entra al bloque de al lado; abajo, al bloque siguiente.
- Doble clic, F2 o una tecla abren la edición. Escape restaura la celda. Mayús y el arrastre seleccionan un rango. Ctrl+C y Ctrl+V copian y pegan, también varias celdas. Supr limpia la selección.
- El neto y el pie se recalculan al escribir. Diez sencillos de zona 1 Norte 2026 siguen en 590, 587 y 537.

## 2026-10-21 — Renombrar pestañas de /boletos

- Clic derecho en una pestaña abre «Cambiar nombre». Enter guarda, Escape cancela y un nombre vacío restaura el original.
- El nombre queda en `localStorage` (`boletos-hoja-nombres`) y se muestra en la pestaña, el encabezado y la hoja Total.

## 2026-10-21 — Pestañas y datos editables en /boletos

- `/boletos` muestra Norte 2026, Norte 2025, Norte especiales, Sur 2026, Sur 2025, TAPO, Poniente, Manuales y Total. La pestaña activa va en `?hoja=`.
- En la tarifa se editan cantidad, precio, descuento, sitio y plata (Norte y Sur). TAPO, Poniente y especiales no tienen plata. El neto se recalcula al escribir. Lo editado queda en `ticket_settlements`; un corte nuevo abre la semilla.
- Semilla idempotente: 612 tarifas. Las 26 de Norte 2026 CDMX no se reescriben. Anclas: zona 1 neto 59, zona 12 neto 355, SAL neto 35, Poniente zona 1 neto 61.50, especiales AA neto 1381.50, Sur 2026 zona 1 neto 59.
- Diez sencillos zona 1 Norte 2026 siguen en 590 / 587 / 537 / 484 / 431. Con precio 88 el neto es 69 y el importe 690 (687 / 637 / 584 / 531). Al guardar y recargar, el precio editado sigue.
- Manuales: pagar = importe − central − orga; total = pagar × cantidad. Se agregan y quitan renglones. Zonas repetidas: `AER (2)`, `5 (2)`, `TAP (2)`, `G (2)`.
- Total consolida los pies. Cuádruple, quíntuple y séptuple restan servicios × 5.30, × 10.60 y × 21.20 al triple. No hay séxtuple. Esa cuenta usa cada boleto una vez; el Excel TOTAL usa el conteo ponderado de D31. Con solo columna izquierda coinciden (378 / 325 / 219 para esos 10).
- Fuera: impresión, consulta histórica, TAPO 24, BASE PTE 25, corrimiento de fila de TAPO, `NORTE 26!I15`, zona SL, plata U–Z (sigue 2.36) y `dayTickets`.

## 2026-10-21 — Corte Norte 2026 en /boletos

- La pantalla `/boletos` deja de ser marcador. `/lista-precios` abre la misma pantalla. El marco no muestra título de sprint.
- Colecciones `ticket_tariffs` y `ticket_settlements`. API `/api/boletos/tarifas` y `/api/boletos/cortes`. Fuera de `app_state`.
- Semilla de BASE NTE 26, CDMX, sencillo y doble, zonas 1–12 y SAL. Zona 1 neto 59, zona 12 neto 355, SAL neto 35.
- Diez sencillos zona 1 quedan en 590, 587, 537, 484 y 431. Con el mismo importe en la columna derecha, sin ahorro queda en 584. Al recargar el corte, las cifras siguen. `dayTickets` no cambia.
- Siguen fuera Sur, TAPO, Poniente, especiales, Edomex, nocturnos U–Z, manuales, consolidado, cuádruple, quíntuple, séptuple, impresión y consulta histórica.

## 2026-10-21 — Sprints de Pago de boletos

- Escritos cinco sprints de planificación en [[Sprints Pago de Boletos 2026]]. El árbol está en `_bmad-output/initiative-pago-boletos-2026`.
- Primera entrega: Norte 2026 CDMX. El resto de bases queda bloqueado por las preguntas abiertas. No se programó frontend ni backend.

## 2026-10-21 — Pago de boletos 2026

- Analizado `PAGO BOLETOS 2026.xlsx`: 19 hojas visibles, sin macros ni cantidades capturadas. Modelo, reglas y plan en [[Pago de Boletos 2026]].
- No se programó frontend ni backend. Los cortes futuros no deben guardarse dentro de `app_state`.

## 2026-10-20 — Buscador centrado

- Quitados los títulos de sprint del encabezado, del hero y de validación e inicio.
- El buscador global queda centrado, en una sola barra, en todas las rutas.

## 2026-10-20 — Marco sin tarjetas fijas

- Quitadas de `app.html` las tarjetas Accesos rápidos y Estado del sistema. Dejan de mostrarse en todas las rutas. El menú lateral permanece.

## 2026-10-20 — Lector de Excel

- Instalado openpyxl 3.1.5 en `C:\Python312` para abrir libros .xlsx. Comprobado un libro de ida y vuelta.

## 2026-10-20 — BMAD-METHOD instalado

- Skills de `bmad-code-org/BMAD-METHOD` copiadas a `.agents/skills` para Cursor. Runtime `_bmad` creado. Versión 6.13.0-next, módulos core-tools, method y toolsmith.
- `bmad-retrospective` no se instaló: el SKILL.md del origen no parsea. El resto quedó current.

## 2026-10-20 — Captura enfocada

- `/captura` quedó en sitio, placas, engomado, vencimiento, estatus y observaciones.
- Se quitaron de esa pantalla el campo empleado, el tipo de socio, el resumen duplicado y el historial.
- Actualizado [[base580-frontend]].

## 2026-10-20 — Revisión de arquitectura

- Contrastado el código de frontend, backend y Compose con el wiki.
- El runtime de tres repos se confirma. El dominio vivo es un documento `app_state`; `MemberDocument` no tiene repositorio.
- Persistencia real: GET/PUT `/api/state` desde captura, catálogos y validación. Operaciones y reportes no escriben colecciones propias. Historial y auditoría se truncan.
- Actualizados [[Architecture Overview]], [[base580-backend]], [[base580-frontend]] y [[hot]].

## 2026-10-15 — Despliegue completado

- Integrados los PR #1 de infraestructura, backend y frontend; workflows de despliegue correctos.
- Verificado sitio público, API HTTP 200, usuario Miguel Rios Bravo y menú con flecha. Contenedores saludables; volumen Mongo original conservado.
- Autorización SSH validada. Respaldo completo en /root/base580-backups/20261016T011735Z y etiquetas rollback preservadas; fuentes originales con cambios locales conservadas.
- Probadas imágenes con Java 24 y stack Docker aislado. Normalizados permisos del favicon y reconstruida la imagen frontend.
- Reescritos [[Deploy Flow]] y [[hot]] con estado actual y recuperación; actualizado [[index]].

## 2026-10-15 — Inspección SSH de VM

- Usuario proporcionó destino SSH. Actualizados DEPLOY_HOST y DEPLOY_USER de los tres repositorios.
- Acceso local denegado; inspección GitHub Actions 38833979789 confirmó llave de despliegue no autorizada.
- Agregado modo inspect_only al workflow de infraestructura. Preparada llave dedicada fuera de los repositorios, pendiente de autorizar en la VM; secretos privados sin publicar.
- Sin merge ni cambios remotos en contenedores. Actualizados [[Deploy Flow]], [[hot]] e [[index]].

Append-only. Newest entries at the TOP.

---

## 2026-10-15 — PR creados y preparación para deploy

- Creados PR #1 independientes de frontend, backend e infraestructura; sin conflictos y adjuntos al chat.
- Pruebas frontend 5/5 y backend 2/2 repetidas, configuración Compose y sintaxis Bash correctas.
- Revisados logs: workflows anteriores fallan al conectar SSH. Solicitados IP/dominio de VM y usuario SSH. main no modificado; sin deploy hasta verificar acceso y conservación de Mongo.
- Actualizados [[Deploy Flow]], [[hot]] e [[index]].

## 2026-10-15 — Cuenta verificada y publicación de ramas

- Usuario completó autorización GitHub; sesión activa basetaxi580-580, con permisos de escritura comprobados en los tres repositorios.
- Frontend y backend publicados en origin/codex/integracion-repos-ui. Infraestructura incorpora este registro para publicar su rama a continuación.
- main sin modificar; no se activa despliegue. Actualizados [[Deploy Flow]], [[hot]] e [[index]].

## 2026-10-15 — Preparación de publicación GitHub

- Verificados los tres remotos en `basetaxi580-580`; publicación solicitada con `basetaxi580@gmail.com`.
- Sesión gh encontrada: CharlyTlelo, sin permiso de escritura al backend. Se requiere iniciar sesión con la cuenta propietaria antes de publicar.
- Documentado proceso de publicación y diferencia entre push a rama de trabajo y despliegue automático desde main en [[Deploy Flow]].

## 2026-10-15 — Navegación adaptable

- Usuario de demostración cambiado a Miguel Rios Bravo en encabezado y reportes.
- Flecha inferior para mostrar/ocultar módulos; panel móvil animado y gestos horizontales.
- Comprobación de escritorio y viewport 390 px con navegador; cinco pruebas correctas.
- Actualizados [[base580-frontend]], [[hot]] e [[index]].

## 2026-10-15 — Arranque local nativo

- Frontend y backend iniciados en segundo plano. MongoDB local existente disponible.
- Verificados frontend HTTP 200, backend salud UP y `/api/state` vía Angular HTTP 200 JSON.
- Actualizados [[Deploy Flow]], [[hot]] e [[index]]. Pendiente prueba Docker/VM.

## 2026-10-15 — Integración de repositorios verificada localmente

- Configurados proxy `/api`, red compartida y conexión MongoDB para Spring Boot 4.
- Workflows independientes usan Compose mediante `scripts/deploy.sh`; infraestructura no compila código de otros repositorios.
- Corregida carga/guardado de socios, catálogos y auditoría; frontend 5/5 y backend 2/2 pruebas correctas. Build Angular correcto.
- Actualizados [[Deploy Flow]], [[hot]] e [[index]]. Falta prueba completa Docker y aplicación en VM; no se publicó ni desplegó.

## 2026-10-15 — Vault scaffold

- Created Obsidian vault inside `base580-infra` (Mode B + C).
- Scaffolded wiki/, .raw/, .obsidian/, _templates/, CLAUDE.md.
- Seeded architecture, modules, flows, decisions, tech stack from README + sprint-plan.
- Copied `docs/sprint-plan.md` → `.raw/sprint-plan.md`.
- Added Cursor rules + AGENTS.md so frontend/backend/infra AIs consult and update this vault.
