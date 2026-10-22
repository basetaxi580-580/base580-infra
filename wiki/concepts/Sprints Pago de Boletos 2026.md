---
type: concept
title: "Sprints Pago de Boletos 2026"
status: active
created: 2026-10-21
updated: 2026-10-21
tags: [concept, boletos, sprints]
---

# Sprints Pago de Boletos 2026

Sprints de planificación del corte de [[Pago de Boletos 2026]]. No son un título de pantalla: el marco ya no muestra el sprint.

El árbol de planificación es la iniciativa `initiative-pago-boletos-2026`, en `_bmad-output/initiative-pago-boletos-2026`. Cada sprint es una épica. La captura ya está en `/boletos`.

## En la aplicación

2026-10-21: `/boletos` cubre las hojas de captura del sprint 3 y el consolidado del sprint 4, menos la impresión. `/lista-precios` abre esa misma pantalla. La tarifa y el corte viven en `ticket_tariffs` y `ticket_settlements`. Placas y nombre se editan en la pestaña Total. Cuádruple, quíntuple y séptuple se calculan restando servicios × 5.30, × 10.60 y × 21.20 al triple. La impresión y la consulta histórica siguen pendientes.

## Hecho

Un sprint está hecho cuando se cumplen sus comprobaciones en la aplicación en marcha, con prueba automática de los números, y el corte no quedó dentro de `app_state`.

## Sprint 1 — Tarifa Norte 2026 CDMX

Objetivo: consultar la tarifa vigente de Norte 2026, ámbito CDMX, en `/lista-precios`.

Se entrega la colección `ticket_tariffs`, la semilla sencillo y doble de BASE NTE 26, y la ruta que hoy es marcador en `app.routes.ts`.

Historias:

- Zona 1 Norte 2026 visible en lista de precios. Neto 59, fuera de `app_state`.
- Neto calculado e índice único por base, vigencia, ámbito, tipo y zona.
- Semilla CDMX de BASE NTE 26. Zona 12 sencillo en 355 y SAL sencillo en 35. Sin Edomex ni otras bases.
- Barrido de refactor, solo limpieza.

Hecho: en `/boletos`, zona 1 sencillo se ve con precio 78, descuento 10, sitio 6, plata 3 y neto 59.

Depende de: nada. Es el primer trabajo.

Fuera: corte, ahorro, cantidades, otras bases.

Riesgo: copiar de más la hoja, o guardar la tarifa dentro de `AppStateDocument.PriceItem`.

## Sprint 2 — Captura Norte 2026

Objetivo: guardar un corte Norte 2026 CDMX y volver a abrirlo con el mismo importe.

Se entrega la colección `ticket_settlements` y la captura en `/boletos`. `/captura` sigue siendo la ficha del socio.

Historias:

- Diez sencillos zona 1 guardados en 590.
- Ahorro: sin ahorro 587, sencillo 537. Los mismos 10 en la columna derecha, sin ahorro 584. Doble 484 y triple 431 salen de aplicar 10.60 y 15.90 a esos 10; no son otra celda del libro.
- Corte con varias zonas CDMX, reabrible, sin pedir Edomex.
- Barrido de refactor, solo limpieza.

Hecho: esa prueba numérica sigue igual después de cerrar y volver a abrir, y `dayTickets` del socio no cambia. En esta entrega el corte también guarda placas y nombre.

Depende de: el sprint 1.

Fuera: impresión y otras bases. Placas y nombre sí se guardan en el corte de esta entrega.

Riesgo: contar la columna derecha una sola vez. Ahí el 0.30 se resta dos veces.

## Sprint 3 — Resto de bases

Objetivo: capturar cada base solo después de confirmarla, en el mismo corte.

Historias, capturadas el 2026-10-21 con la tarifa de cada hoja de precios y sin copiar los desfases:

- Sur 2026 CDMX. Si entra, zona 1 sencillo queda en 59.
- TAPO con una sola vigencia confirmada, sin plata y sin el corrimiento de fila.
- Poniente desde BASE PTE, no BASE PTE 25. Zona 1 sencillo en 61.50, sin plata.
- Especiales Norte. AA sencillo en 1,381.50. PPP conserva el descuento 378.48.
- Edomex y nocturnos U–Z, con la vigencia y la plata que se confirmen.
- Manuales con importe, central y orga editables.
- Barrido de refactor, solo limpieza.

Hecho: esas bases se capturan en pestañas del mismo corte. La prueba del sprint 2 no se mueve. La edición de un precio cambia el importe de ese corte y no reescribe la semilla.

Depende de: el sprint 2.

Fuera: consolidado, consulta, copiar desfases.

Riesgo: sembrar una base ambigua antes de la respuesta.

## Sprint 4 — Consolidado e impresión

Objetivo: imprimir el corte con placas, nombre y las columnas extra.

Historias:

- Consolidado con placas, nombre e importe 590 en el ejemplo de 10 sencillos.
- Cuádruple 378, quíntuple 325 y séptuple 219 para esos 10 en la columna izquierda. Salen de restar 5.30, 10.60 y 21.20 al importe triple. No hay séxtuple.
- Impresión con `window.print`, como `exportPdf` en `reports.page.ts`, sin folio y sin tocar las filas de ejemplo de `/reportes`.
- Barrido de refactor, solo limpieza.

Hecho a medias: el consolidado, las placas, el nombre y las tres columnas extra ya están en la pestaña Total. La impresión todavía no.

Depende de: el sprint 3, porque el guardado del corte es el mismo. Si se quiere imprimir solo Norte antes de confirmar las otras bases, esta espera se puede adelantar.

Fuera: consulta histórica, folio, formas de pago.

Riesgo: el significado de cuádruple, quíntuple y séptuple sigue abierto. La cuenta no: sale de la fórmula de TOTAL.

## Sprint 5 — Consulta de cortes

Objetivo: encontrar un corte guardado y abrirlo sin modificarlo.

Historias:

- Lista con placas, nombre, fecha de guardado e importe.
- Filtro por placas y por rango de esa fecha de guardado.
- Apertura en solo lectura del consolidado.
- Barrido de refactor, solo limpieza.

Hecho: el corte del sprint 2 aparece, se filtra y se abre, y recargar no lo borra.

Depende de: el sprint 4.

Fuera: cancelación, reimpresión de folio, ligar el corte a un socio.

Riesgo: bajo. El libro no trae fecha; el filtro usa la fecha en que la plataforma guardó.

## Supuestos

- Primera entrega: Norte 2026 CDMX. El 2026-10-21 se sumaron el resto de hojas de captura, con datos editables en el corte.
- Los desfases no se copian (`NORTE 26!I15`, Edomex 2026 leyendo 2025, corrimiento de TAPO).
- Un corte es un documento con placas y nombre, no un socio y no `MemberDocument`.
- Sin ahorro resta 0.30. La pantalla no lo llama cuota.
- Cuádruple, quíntuple y séptuple se calculan aunque no se sepa el nombre de negocio. No hay séxtuple.
- La plata U–Z no se cambia de 2.36 a 3, y no entra en la primera semilla.
- La semilla carga tarifas, no cantidades. SERV está vacío.
- `/boletos` es el corte. `/captura` no.

## Bloqueos

El 2026-10-21 la captura tomó estas decisiones, todas editables en el corte:

- Sur 2026 entra con CDMX y Edomex de BASE SUR 26. Zona 1 sencillo neto 59.
- TAPO usa una vigencia, BASE TAPO 25, sin plata y sin el corrimiento de fila. Del rezago solo entran las zonas que esa hoja no trae: 12A–12E y 32.
- Poniente usa BASE PTE, no BASE PTE 25. Zona 1 sencillo neto 61.50, sin plata.
- Especiales entran sin plata. AA sencillo neto 1381.50. PPP conserva el descuento 378.48.
- Edomex 2026 sale de BASE NTE 26, no de la referencia hacia 2025. La plata U–Z sigue en 2.36.
- Manuales entran, con importe, central, orga y zona editables.

Sigue sin cerrarse el nombre de negocio de cuádruple, quíntuple y séptuple, si el corte debe ligarse a un socio, y si los 0.30 son una cuota. La cuenta ya está en la pantalla.

## Fuera de todo el trabajo

Copiar las 19 hojas, TAPO 2024, rezago, meter cortes en `app_state`, rellenar `dayTickets` del socio, roles, formas de pago, folios, cancelación y reimpresión. El plan de ocho sprints del CRM, en [[sources/sprint-plan]], es otro trabajo.
