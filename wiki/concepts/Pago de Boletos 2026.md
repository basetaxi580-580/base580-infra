---
type: concept
title: "Pago de Boletos 2026"
status: active
created: 2026-10-21
updated: 2026-10-21
tags: [concept, boletos, tarifas, corte, excel-ui]
session_note: "2026-10-21 cierre: 19 pestañas + 861 tarifas ancladas al xlsx; ver hot.md"
source: "C:\\Users\\carlo\\Downloads\\PAGO BOLETOS 2026.xlsx"
---

# Pago de Boletos 2026

Calculadora de corte de boletos de taxi por base. No es un historial de socios ni de pagos. Origen: `PAGO BOLETOS 2026.xlsx` (133 KB). Creado el 2022-12-25 por Alma. Último guardado el 2026-10-19 por SITIO 580 NVA ADMINISTRACIÓN. 19 hojas, todas visibles. Sin macros (`xlsx`, sin `vbaProject.bin`). Sin nombres definidos, sin validación de datos, sin comentarios, sin celdas combinadas, sin tablas dinámicas, sin fechas. La caché de fórmulas existe: los importes de captura están en 0 porque la columna SERV está vacía.

Producto relacionado: [[CRM Product]]. Arquitectura: [[Architecture Overview]].

## Hojas

Catálogos de tarifa (el usuario no captura boletos aquí): `BASE NTE 25 ` (el nombre lleva espacio final), `BASE NTE 26`, `BASE NORTE ESPECIALES`, `BASE TAPO 24`, `BASE TAPO 25`, `BASE TAPO REZ`, `BASE PTE 25`, `BASE PTE`, `BASE SUR 25`, `BASE SUR 26`.

Captura de un corte (SERV vacío): `NORTE 25 `, `NORTE 26`, `NORTE ESPECIALES`, `SUR 25`, `SUR 26`, `TAPO 25`, `PTE`, `MANUALES`.

Consolidado para imprimir: `TOTAL`. Campos en blanco y desbloqueados: placas (`B37`/`D37`), nombre (`B39`, `D39:F39`), tipo de ahorro (`B41`, `D41` dice SENCILLO) y `D42:D49`.

## Modelo

Una tarifa es base + vigencia + ámbito (CDMX o Estado de México) + tipo (sencillo, doble o nocturno) + zona.

Campos de tarifa: `precio` (lista), `descuento` (de la base), `sitio`, `plata` (solo Norte y Sur), `neto`.

```
neto = precio - descuento - sitio - plata
```

En TAPO y Poniente no hay columna PLATA: `neto = precio - descuento - sitio`. En especiales Norte tampoco hay plata.

Un corte tiene cuatro bloques de cantidades. Cada bloque: zona, cantidad (`SERV`), precio de lista (muchas veces escrito a mano) e importe `cantidad * neto de la tarifa`. El precio escrito en la hoja de captura no es el que multiplica, salvo en `PTE`, que sí enlaza el precio a `BASE PTE`.

Bloques típicos de Norte: DF sencillos, DF dobles, Edomex sencillos, Edomex nocturnos. Sur dice CDMX / ESTADO. TAPO dice DF / EDO. Poniente dice DF / EDOS.

`TOTAL` suma los cortes de Norte (25 + 26 + especiales), Sur (25 + 26), TAPO, Poniente y manuales. No hay folio, fecha, estatus, forma de pago ni catálogo de socios. Placas y nombre se escriben a mano en el consolidado.

Volumen del libro: decenas de zonas por hoja, no miles de filas. Un corte son unas 80 a 170 cantidades. El riesgo de `app_state` no es este archivo; es guardar cada corte futuro dentro del documento único. Ver [[base580-backend]].

## Tarifas leídas (neto a pagar)

Norte DF sencillo, zona 1: 2025 lista 58, neto 41.94 (desc 8.70, sitio 5, plata 2.36). 2026 lista 78, neto 59 (desc 10, sitio 6, plata 3). Zona 12: neto 339.64 en 2025 y 355 en 2026. SAL: neto 22.64 (2025) y 35 (2026). Edomex A sencillo 2025: lista 137, neto 102.04. Plata 2025 de Norte y del bloque nocturno sigue en 2.36; en DF 2026 la plata del sencillo es 3. En `BASE NTE 26` las zonas U–Z nocturnas siguen con `precio = sencillo + 20` y plata 2.36.

Especiales Norte (AA–ZZ y AAA–ZZZ, 52 zonas × sencillo/doble): descuento ≈ 7.5 % del precio y sitio ≈ 2.5 %. AA sencillo: lista 1,535, desc 115.12, sitio 38.38, neto 1,381.50. Excepción: en PPP el descuento es la fórmula `=376.12+2.36` (378.48), no el 7.5 %.

TAPO DF sencillo zona 1: neto 45.90 en 2024 y 2025; en rezago 43.90. Edomex A, tarifa nueva: neto 161 en 2024 y 191.20 en 2025 y en rezago. El doble de lista en TAPO es `sencillo + 45`.

Poniente zona 1 sencillo: neto 62.00 en `BASE PTE 25` y 61.50 en `BASE PTE`. El doble de lista suma 35 en 2025 y 38 en la hoja vigente.

Sur CDMX zona 1 sencillo: los mismos netos que Norte (41.94 en 2025 y 59 en 2026). Estado de Sur agrega AIFA, AERO TOL, TOLUCA, CUERNAVACA y OAXTEPEC.

## Reglas de fórmulas

No hay `BUSCARV`, `SUMAR.SI`, `INDICE` ni `COINCIDIR`. Solo resta, suma, producto y referencias fijas a otra hoja.

1. Neto de catálogo, como arriba. En Norte/Sur la plata es un importe fijo por boleto (2.36 o 3). En TAPO el descuento y el sitio de Edomex sí son porcentaje del precio: 2024 descuento `precio*0.07+1` y sitio `precio*0.03`; 2025 sitio `precio*0.03+1`.
2. Importe del renglón = cantidad × neto de la misma zona en la hoja de tarifa. Ejemplos: `NORTE 26!D3 = 'BASE NTE 26'!F3*A3`. `TAPO 25!D3 = A3*'BASE TAPO REZ'!E3`.
3. Ahorro, en pesos por boleto contado, no en porcentaje. Etiquetas: S/AH 0.30, SENC 5.30, DOB 10.60, TRI 15.90. «Sin ahorro» igual resta 0.30.
4. La base del ahorro es `todos los servicios + otra vez los de la columna derecha`. En Norte, `D24` suma los cuatro bloques y `D25` vuelve a sumar DF dobles y Edomex nocturnos. `H24 = D28-(D24*0.3)-(D25*0.3)`. Un boleto de la izquierda resta una vez; uno de la derecha, dos. Sur, TAPO, Poniente, especiales y manuales hacen la misma cuenta con otras celdas (`L26`, `V2+V3`, `D33`, `R11`).
5. En `TOTAL`, cuádruple, quíntuple y séptuple salen del importe ya triple, no de la tarifa: `F33 = H31-(D31*5.3)`, `G33 = H31-(D31*10.6)`, `H33 = H31-(D31*21.2)`. No hay séxtuple. `D31` ya trae el doble conteo del punto 4.

Referencias que no se deben copiar sin confirmar:

- `NORTE 26` e `SUR 26` cobran CDMX con tarifa 2026, pero Edomex sigue apuntando a la hoja 2025.
- `NORTE 26!I15 = 'BASE NTE 25 '!M7*F15`: la cantidad de CENTRO (fila 15) se multiplica por el neto de la zona 5 doble de 2025.
- `TAPO 25` cobra DF contra `BASE TAPO REZ`, Edomex A–M contra `BASE TAPO 25`, y TIZ / AT / AIFA contra `BASE TAPO 24`. A partir de NOC/FORO el doble queda desfasado una fila (`I29` usa `K30`).
- `NORTE ESPECIALES!A1 = 2707` no entra en ninguna suma.

## Encaje con la plataforma

Hoy el dominio vivo del CRM sigue siendo un solo `app_state`. `PriceItem` guarda un precio, zona y terminal. No alcanza para descuento, sitio, plata, vigencia ni tipo de boleto. El corte de este libro no usa ese documento: vive en `ticket_tariffs` y `ticket_settlements`, y la pantalla es `/boletos`. `/operaciones` arma líneas en pantalla con precios fijos 173/145 y no las guarda. `/reportes` imprime cuatro filas de ejemplo con `window.print`. `/catalogos` sí persiste, pero la lista de precios del CRM es plana. `MemberDocument` no tiene repositorio.

Los cortes no deben vivir dentro de `app_state`: cada `PUT /api/state` reemplaza socios, catálogos y auditoría. El catálogo de tarifas de este libro cabe en unos cientos de documentos; el historial de cortes, no.

## En la aplicación

**Fuente oficial del corte:** `C:\Users\carlo\Downloads\PAGO BOLETOS 2026.xlsx`. Semilla: `extract_boletos_tarifas.py` → `tarifas.tsv` (**861** tarifas, incluye BASE TAPO 24/REZ y BASE PTE 25).

2026-10-21: `/boletos` replica las **19 pestañas** del Excel (orden y nombres del libro; colores TAPO/NORTE 26/especiales/PTE). `?hoja=`. `/lista-precios` = misma pantalla. API `/api/boletos/tarifas` y `/api/boletos/cortes`. Llave única base + vigencia + ámbito + tipo + zona. Cortes en `ticket_settlements`. UI: `boletos.page.ts` (+ hojas/grid/formula/math).

### Mapa pestaña ↔ Excel (orden del libro)

| App (`HojaId`) | Excel | Rol |
|----------------|-------|-----|
| `base-nte-25` | `BASE NTE 25 ` | Catálogo (sin SERV) |
| `base-nte-26` | `BASE NTE 26` | Catálogo |
| `base-norte-especiales` | `BASE NORTE ESPECIALES` | Catálogo |
| `base-tapo-24` | `BASE TAPO 24` | Catálogo · vigencia `2024` |
| `base-tapo-25` | `BASE TAPO 25` | Catálogo |
| `base-tapo-rez` | `BASE TAPO REZ` | Catálogo · vigencia `REZ` |
| `base-pte-25` | `BASE PTE 25` | Catálogo · vigencia `2025` |
| `base-pte` | `BASE PTE` | Catálogo · `VIGENTE` |
| `base-sur-25` / `base-sur-26` | `BASE SUR 25` / `26` | Catálogo |
| `tapo` | `TAPO 25` | Captura (color `#FF66FF`) |
| `norte-2025` / `norte-2026` | `NORTE 25 ` / `NORTE 26` | Captura (`#FFC000` en 26) |
| `especiales` | `NORTE ESPECIALES` | Captura (`#FFFF00`) |
| `poniente` | `PTE` | Captura (`#00B0F0`) |
| `sur-2025` / `sur-2026` | `SUR 25` / `SUR 26` | Captura |
| `manuales` | `MANUALES` | Captura |
| `total` | `TOTAL` | Consolidado |

Catálogo = layout tipo BASE (hueco central, sin cantidad/importe). Captura Norte también usa layout BASE + SERV. Omisiones de fórmulas del libro: no se copian `NORTE 26!I15` ni el desfase TAPO `I29→K30`. TOTAL sigue con servicios sin ponderar D31.

### Matriz de fidelidad (2026-10-21)

Semilla re-extraída: **861** filas; anchors OK (Norte 2026 z1→59, AA 1381.50, PTE vigente 61.50, PTE 2025→62.00, TAPO 45.90, REZ z1→43.90).

| Área | Excel | App | Gap / decisión |
|------|-------|-----|----------------|
| Pestañas | 19 | 19 (+ libres) | Nombres/orden/colores del libro |
| BASE* | catálogo | `catalogo: true` | Sin SERV |
| Captura | SERV | cantidad/importe | OK |
| TOTAL | D31 ponderado | servicios sin ponderar | Intencional |
| I15 / desfase TAPO | en libro | no copiados | Locked |

### Captura tipo Excel (UI local)

- Una tabla por pestaña; sencillos a la izquierda y dobles/nocturnos a la derecha; secciones apiladas; renglón 1 = título de sección.
- Navegación de celdas como Excel (flechas, Tab, Enter, F2, selección, copiar/pegar). Barra de fórmulas con `=` y funciones básicas.
- Formato: tamaño/color de fuente, color de celda, negrita, cuadrícula on/off, alineación, tipo de dato, fusiones. Resize de columnas/filas. Coords A… / 1… en rosa.
- Autosave del corte: debounce 1.5 s o al salir de la celda. Historial undo/redo de hasta 5 pasos. Sin botón Guardar/Nuevo en la tarjeta superior.

### Pestañas: crear, ordenar, ocultar

- `+` abre diálogo de nombre y crea hoja libre (`libre-*`).
- Mantener **1 segundo** una pestaña entra a modo temblor (ciclo ~0.7 s). Arrastrar reordena. Esc o clic fuera sale.
- En temblor, × rojo sólido (x blanca) arriba-derecha pide confirmación. Libre: borra datos de esa hoja. Fija: la oculta (no hay deshacer).
- Hover: la pestaña crece suave; la activa queda un poco más grande (sin grow en temblor).
- Clic derecho → «Cambiar nombre».

Claves `localStorage` del navegador (por equipo, no van al API): `boletos-hoja-nombres`, `boletos-hojas-orden`, `boletos-hojas-ocultas`, `boletos-hojas-libres`, `boletos-formatos`, `boletos-fusiones`, `boletos-etiquetas`, `boletos-medidas`, `boletos-formulas`, `boletos-formulas-tocadas`, `boletos-cuadricula`.

Pestañas fijas, en este orden:

1. Norte 2026. Hoja NORTE 26, tarifa BASE NTE 26. CDMX y Edomex de esa hoja: sencillo, doble y nocturno.
2. Norte 2025. NORTE 25 / BASE NTE 25.
3. Norte especiales. NORTE ESPECIALES / BASE NORTE ESPECIALES. Sin plata.
4. Sur 2026. SUR 26 / BASE SUR 26.
5. Sur 2025. SUR 25 / BASE SUR 25.
6. TAPO. Una vigencia, BASE TAPO 25, para las zonas de esa hoja. Sin plata. Si la zona solo existe en el rezago, se toma de ahí y queda editable: 12A, 12B, 12C, 12D, 12E y 32.
7. Poniente. PTE / BASE PTE vigente. Sin plata. Zona 1 sencillo neto 61.50.
8. Manuales. Cantidad, zona, importe, central y orga. Pagar = importe − central − orga. Total = pagar × cantidad. Se agregan y quitan renglones.
9. Total. Suma los pies del mismo corte. Placas y nombre se editan aquí y se comparten con el corte.

En cada renglón de tarifa se editan cantidad, precio, descuento, sitio y plata donde la base la usa. Norte y Sur tienen plata. TAPO, Poniente y especiales no. Al cambiar cualquiera, el neto se recalcula sin guardar: precio − descuento − sitio − plata (plata 0 si no aplica). Importe = cantidad × neto. La columna izquierda cuenta la cuota una vez. Dobles y nocturnos la cuentan dos veces. Cuotas: sin ahorro 0.30, sencillo 5.30, doble 10.60, triple 15.90.

Manuales usa las mismas piezas con otros nombres: importe, central y orga. Zonas repetidas dentro de la misma llave quedan distinguibles: `AER (2)`, `5 (2)`, `TAP (2)` y `G (2)`.

Total agrega cuádruple, quíntuple y séptuple sobre el importe triple: restar servicios × 5.30, servicios × 10.60 y servicios × 21.20. Servicios es cada boleto una vez, no el conteo ponderado. No hay séxtuple. En el Excel, TOTAL usa D31 (la columna derecha cuenta dos). Con solo columna izquierda las dos cuentas coinciden. Con boletos a la derecha, divergen.

Anclas que no se inventaron: Norte 2026 zona 1 sencillo 78, 10, 6, 3, neto 59. Zona 12 sencillo neto 355. SAL sencillo neto 35. Diez sencillos zona 1: 590 / 587 / 537 / 484 / 431. Esos 10 en la columna derecha, con neto 59, dejan sin ahorro en 584. Un doble real de zona 1 no vale 59: su neto es 71.45. Si el precio de esos 10 pasa de 78 a 88, el neto pasa a 69, el importe a 690, sin ahorro a 687, sencillo a 637, doble a 584 y triple a 531. Especiales AA sencillo neto 1381.50. Sur 2026 zona 1 sencillo neto 59. TAPO zona 1 sencillo neto 45.90. Edomex A de Norte 2026 sencillo neto 102.04, tomado de BASE NTE 26 y no de la referencia de la hoja de captura hacia 2025.

## Qué quedó fuera

- Impresión con `window.print` y la consulta histórica con filtro. El sprint 5 no está hecho.
- Folio, forma de pago, roles, cancelación y reimpresión.
- `dayTickets` y `nightSaving` del socio.
- El corrimiento de fila de TAPO (`I29` usa `K30`) y la referencia `NORTE 26!I15` (las pestañas BASE TAPO 24 / PTE 25 sí existen como catálogo).
- La zona SL de la captura TAPO. AIFA sale de BASE TAPO 25.
- Los alias CENTRO, TAPO, AERO, PTE y SUR de la hoja de captura no son renglones de tarifa aparte.
- La plata de las zonas U–Z sigue en 2.36. No se cambió a 3.
- No hay séxtuple. Cuádruple, quíntuple y séptuple restan sobre servicios, no sobre el conteo ponderado D31 del Excel.

## Plan de implementación

Ese orden ya está en sprints: [[Sprints Pago de Boletos 2026]]. El árbol está en `_bmad-output/initiative-pago-boletos-2026`. Las hojas de captura ya están en `/boletos`. No se copian los desfases.

Orden:

1. Catálogo vigente en colección propia `ticket_tariffs`. Índice único `base + vigencia + ámbito + tipo + zona`. Hecho: 861 tarifas.
2. Corte con cantidades, importe = cantidad × neto y las cuatro columnas de ahorro. Colección `ticket_settlements`. Pantalla `/boletos`. Hecho. El precio editado también se guarda en el corte.
3. Sur, Poniente, TAPO, especiales, Edomex, nocturnos y manuales. Hecho, con las decisiones de arriba. Manuales deja editar importe, central, orga y zona.
4. Consolidado tipo `TOTAL`, con placas y nombre. Hecho en la pestaña Total, incluido cuádruple, quíntuple y séptuple. Falta la impresión.
5. Consulta del historial de cortes. Pendiente. Cancelación y reimpresión de folio no están en este libro.

No hacer: copiar BASE TAPO 24, BASE PTE 25 ni el corrimiento de fila; del rezago solo entran las zonas que BASE TAPO 25 no trae. No meter cortes en `app_state`, no rellenar `dayTickets` / `nightSaving` del socio, ni agregar roles, formas de pago o folios.

Criterio de aceptación del primer corte, tarifa Norte 2026 zona 1 sencillo (neto 59): 10 boletos en DF sencillos dan importe 590; sin ahorro 587; ahorro sencillo 537. Esos 10 en la columna de dobles dan sin ahorro 584, porque el 0.30 se resta dos veces.

## Preguntas que el libro no cierra

La pantalla ya tomó una decisión editable para cada una. El detalle está en «En la aplicación» y en «Qué quedó fuera».

- Si Edomex 2026 debe seguir cobrando tarifa 2025.
- Si `I15` de Norte 2026 y el desfase de TAPO son errores.
- Si TAPO debe seguir mezclando rezago, 2025 y 2024.
- Qué significan cuádruple, quíntuple y séptuple (21.20 pesos) y por qué no hay séxtuple.
- Si un corte es un socio por día o el corte de toda la base. No hay fecha ni folio.
- Si los 0.30 de «sin ahorro» son una cuota intencional.
- Si la plata 2.36 de las zonas U–Z en 2026 ya debería ser 3.
