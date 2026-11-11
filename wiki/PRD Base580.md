---
type: prd
title: "Base580 — Product Requirements Document"
status: draft
created: 2026-11-11
updated: 2026-11-11
tags: [prd, base580, crm, product, history]
owner: "Cliente Base580 / Equipo de producto"
---

# PRD: Base580

## 0. Propósito del documento

Este es el documento vivo de requisitos de Base580. Sirve como referencia para el cliente, producto, diseño, desarrollo y despliegue. Conserva el estado histórico del proyecto, separa lo terminado de lo pendiente y registra los cambios solicitados con fecha, impacto y criterio de aceptación.

Este PRD resume y enlaza la documentación detallada de la bóveda de Obsidian, las iniciativas y los tickets de `_bmad-output`; no reemplaza esas fuentes especializadas.

**Regla de mantenimiento:** una solicitud nueva del cliente se agrega como cambio fechado. No se borra una decisión anterior: se marca como reemplazada, cancelada o vigente.

## 1. Visión

Base580 es un CRM operativo para administrar socios, operaciones, boletos, tarifas y reportes de una base de taxis. Busca conservar la funcionalidad de negocio del sistema actual, pero con una experiencia web moderna, explícita y mantenible.

La plataforma debe permitir que el personal operativo capture y consulte información diaria sin depender de hojas de cálculo dispersas, manteniendo un historial confiable de las acciones y de los cortes. El despliegue debe funcionar en un ambiente local para desarrollo y en una VM de producción.

La primera línea de trabajo funcional es el corte de pago de boletos 2026. La primera entrega útil ya está implementada en `/boletos`; la siguiente evolución debe concentrarse en impresión, consulta histórica, folios y reglas de negocio confirmadas por el cliente.

## 2. Usuarios y trabajos principales

### 2.1 Usuario operador

- Consultar tarifas por base, vigencia, ámbito, tipo y zona.
- Capturar operaciones y cortes con la menor fricción posible.
- Ver importes, descuentos, ahorro y consolidado antes de imprimir.
- Corregir datos sin perder claridad sobre el estado actual.
- Volver a consultar información guardada.

### 2.2 Usuario administrador operativo

- Mantener catálogos y tarifas.
- Revisar reportes y movimientos.
- Supervisar el historial de cambios.
- Validar que la información publicada corresponda al proceso operativo.

### 2.3 No usuarios de la primera etapa

- No se implementa una matriz de roles o permisos en esta fase.
- No se sustituye el sistema contable ni se automatizan pagos bancarios.
- No se convierte el corte de boletos en un historial de socios.

## 3. Alcance del producto

### 3.1 Módulos

| Módulo | Estado | Descripción |
|---|---|---|
| Shell y navegación | Hecho | Marco general, menú lateral y navegación responsive. |
| Socios | Parcial | Estado y catálogos base; el historial completo queda pendiente. |
| Captura | Parcial | `/captura` edita datos operativos del socio; no es la pantalla de corte. |
| Boletos | Hecho en primera versión | `/boletos` replica la captura del libro y guarda cortes. |
| Lista de precios | Hecho en primera versión | Catálogo de tarifas del flujo de boletos. |
| Operaciones | Prototipo | Presenta líneas con precios de ejemplo; todavía no persiste el flujo completo. |
| Catálogos | Parcial | Persiste el catálogo plano actual; no reemplaza el catálogo de tarifas de boletos. |
| Reportes | Prototipo | Filas de ejemplo y `window.print`; impresión de cortes pendiente. |
| Cancelación / reimpresión | Pendiente | Fuera del alcance actual de boletos. |
| Infraestructura | Hecho | Compose, red, persistencia, Caddy y despliegue a VM. |

### 3.2 Arquitectura vigente

Tres repositorios independientes:

- [[base580-frontend]] — Angular 22, Node 24 y Nginx.
- [[base580-backend]] — Java 24, Spring Boot 4 y MongoDB.
- [[base580-infra]] — Docker Compose, Caddy, scripts de despliegue y esta bóveda.

Flujo de ejecución:

```text
Navegador → Nginx/frontend:80 → /api/* → backend:8080 → MongoDB:27017
```

### 3.3 Ambientes

| Ambiente | Configuración | Estado |
|---|---|---|
| Local | MongoDB nativo o Docker; backend con Java 24; frontend con Node 24. | Validado el 2026-11-11. |
| Producción | Frontend, backend, MongoDB y Caddy en Docker Compose sobre VM. | Último despliegue registrado: 2026-10-21; requiere reconfirmación cuando se modifique. |

Comando local oficial: `C:\Users\carlo\Documents\base580\levantar-local.bat`.

## 4. Requisitos funcionales

### 4.1 Plataforma y navegación

#### FR-1: Acceso a los módulos

El operador puede navegar entre los módulos disponibles desde el shell de la aplicación.

**Criterios:**

- El menú funciona en escritorio y móvil.
- Las rutas no implementadas muestran su estado sin simular funcionalidad completa.
- El marco no muestra elementos retirados como “Accesos rápidos” o “Estado del sistema”.

#### FR-2: Persistencia de estado operativo

La plataforma puede cargar y guardar el estado general del CRM sin incluir datos que pertenecen a colecciones específicas de boletos.

**Criterios:**

- `app_state` no contiene cortes futuros.
- Las tarifas y cortes de boletos viven fuera de `AppStateDocument` y `PriceItem`.
- La auditoría conserva el historial definido por el producto.

### 4.2 Socios y captura

#### FR-3: Gestión básica de socios

El operador puede consultar y editar la información operativa disponible de un socio.

**Criterios:**

- `/captura` permite editar sitio, placas, engomado, vencimiento, estatus y observaciones.
- La pantalla no inventa empleado, resumen o historial si esos datos no están implementados.
- La relación entre un corte de boletos y un socio queda pendiente de decisión.

### 4.3 Tarifas y cortes de boletos

#### FR-4: Consultar tarifas

El operador puede consultar una tarifa identificada por base, vigencia, ámbito, tipo y zona.

**Criterios:**

- El catálogo usa la colección `ticket_tariffs`.
- El neto de Norte y Sur es `precio - descuento - sitio - plata`.
- El neto de TAPO, Poniente y especiales es `precio - descuento - sitio`.
- La primera semilla contiene 861 tarifas.

#### FR-5: Capturar un corte

El operador puede capturar cantidades por zona y obtener el importe del corte.

**Criterios:**

- Los cortes se guardan en `ticket_settlements`.
- Diez boletos sencillos de Norte 2026 zona 1 producen importe 590, sin ahorro 587 y ahorro sencillo 537.
- La columna derecha cuenta dos veces para el ahorro sin ahorro.
- El precio editado en el corte no reescribe la semilla.

#### FR-6: Trabajar con las hojas del libro de boletos

El operador puede trabajar con las hojas de captura y consolidado implementadas en `/boletos`.

**Criterios:**

- La interfaz contiene las 19 hojas base del Excel, además de hojas libres.
- Permite editar cantidad, precio, descuento, sitio y plata cuando corresponda.
- Incluye autosave, undo/redo, formato de celdas, navegación tipo Excel y pestañas configurables.
- La pestaña `Total` conserva placas, nombre y cálculos de consolidado.

#### FR-12: Crear nuevas bases de tarifas

El operador autorizado puede crear nuevas pestañas de catálogo `BASE ...` dentro de `/boletos` para incorporar nuevas bases solicitadas por el cliente. Estas pestañas son distintas de las hojas libres de captura: deben aparecer junto a las pestañas de catálogo existentes, como `BASE NTE 25`, `BASE NTE 26`, `BASE TAPO 25` y similares.

**Criterios iniciales:**

- El usuario puede crear al menos las dos nuevas bases solicitadas por el cliente.
- La gestión se inicia con clic derecho sobre la franja de pestañas o sobre una pestaña de catálogo.
- El menú contextual ofrece las acciones **Añadir libro**, **Eliminar** y **Cambiar nombre**.
- **Añadir libro** abre el flujo para crear una nueva base de catálogo, no una hoja libre genérica.
- **Eliminar** solicita confirmación y evita borrar silenciosamente una base con tarifas o capturas asociadas.
- **Cambiar nombre** actualiza el nombre visible sin romper la identidad interna ni las referencias de fórmulas.
- La nueva pestaña solicita y conserva un nombre de base visible.
- La nueva base puede recibir sus zonas, precios, descuento, sitio, plata, vigencia y tipo de boleto según la regla que confirme el cliente.
- La base creada permanece disponible después de recargar la pantalla y no depende únicamente de `localStorage`.
- La pestaña puede ser utilizada por las hojas de captura y por el consolidado cuando corresponda.
- La creación no altera las pestañas BASE existentes ni las tarifas históricas.

**Situación actual:** existe un menú de clic derecho, pero hoy solo permite cambiar nombre y eliminar hojas libres; el botón `+` crea una hoja libre genérica. Las pestañas de catálogo están definidas de forma fija en `boletos-hojas.ts`. Se requiere ampliar el menú contextual y diseñar el modelo persistente de base/tarifa antes de implementar.

**Preguntas específicas:**

- ¿Cuál es el nombre exacto de cada una de las dos nuevas bases?
- ¿Qué vigencia, ámbito, tipos de boleto y reglas de cálculo tiene cada una?
- ¿Las nuevas bases deben ser visibles para todos los usuarios o solo para el navegador que las creó?
- ¿Deben iniciar vacías, copiar la estructura de una base existente o cargar tarifas entregadas por el cliente?

#### FR-7: Consultar cortes guardados

El operador puede encontrar un corte guardado por placas y fecha de guardado, abrirlo en solo lectura y revisar su consolidado.

**Estado:** Pendiente de implementación.

#### FR-8: Imprimir un corte

El operador puede imprimir el consolidado con placas, nombre, importes y columnas adicionales.

**Estado:** Pendiente de implementación; el consolidado de pantalla ya existe.

### 4.4 Operaciones, reportes y catálogos

#### FR-9: Operaciones persistentes

El operador puede registrar operaciones reales y consultar sus resultados.

**Estado:** Parcial. Las operaciones actuales usan datos de ejemplo y todavía no persisten el flujo completo.

#### FR-10: Reportes operativos

El administrador puede generar reportes de negocio en PDF o mediante impresión del navegador.

**Estado:** Parcial. El objetivo de PDF permanece vigente; el reporte de cortes necesita implementación.

#### FR-11: Administración de catálogos

El administrador puede gestionar catálogos generales del CRM sin confundirlos con el catálogo estructurado de tarifas de boletos.

**Estado:** Parcial.

## 5. Requisitos no funcionales y guardrails

- **NFR-1 — Separación de datos:** no guardar cortes de boletos en `app_state`.
- **NFR-2 — Persistencia:** MongoDB debe conservar datos mediante volumen persistente en producción.
- **NFR-3 — Despliegue:** los tres repositorios deben poder desplegarse de forma independiente.
- **NFR-4 — Red:** solo el frontend/Caddy se publica; backend y MongoDB quedan en red interna o loopback.
- **NFR-5 — Compatibilidad local:** backend Java 24 y frontend Node 24.
- **NFR-6 — Seguridad operativa:** nunca ejecutar `docker compose down -v` durante una actualización; protege `mongo_data`.
- **NFR-7 — Trazabilidad:** las decisiones y cambios relevantes deben quedar registrados en esta wiki.
- **NFR-8 — UX:** la interfaz debe ser explícita, simple y usable en escritorio y móvil.

## 6. Estado de trabajo

### 6.1 Hecho

- Arquitectura de tres repositorios y despliegue Compose.
- Flujo navegador → Nginx → API → MongoDB.
- Primera versión funcional de `/boletos`.
- Catálogo de 861 tarifas.
- Captura de Norte, Sur, TAPO, Poniente, especiales, Edomex, nocturnos y manuales según las decisiones registradas.
- Consolidado con placas, nombre, cuádruple, quíntuple y séptuple.
- Ambiente local documentado y script `levantar-local.bat`.
- Verificación local del 2026-11-11: frontend, backend y MongoDB activos.

### 6.2 Pendiente priorizado

| Prioridad | Pendiente | Motivo / resultado esperado |
|---|---|---|
| P0 | Reconfirmar estado de producción | Evitar que el histórico de octubre sea la única evidencia vigente. |
| P1 | Crear dos nuevas bases en `/boletos` | Permitir que el cliente agregue y utilice nuevas pestañas de catálogo BASE. |
| P1 | Impresión de cortes | Entregar el resultado operativo fuera de pantalla. |
| P1 | Consulta histórica de cortes | Encontrar y abrir cortes guardados sin modificar datos. |
| P2 | Folio y reimpresión | Identificar cortes impresos y repetir su salida. |
| P2 | Forma de pago | Completar el proceso operativo del corte. |
| P2 | Ligar corte con socio | Resolver si el corte representa a un socio, a una base o a un periodo. |
| P3 | Persistencia completa de operaciones | Sustituir ejemplos por flujo real. |
| P3 | Historial y auditoría sin recortes | Revisar límites actuales de historial 10 y auditoría 20. |
| P3 | Autenticación y autorización | Definir roles y acceso cuando el cliente lo solicite. |

## 7. Decisiones vigentes

- Nueva UI moderna con los módulos de negocio del sistema actual.
- Sin roles en la primera fase; el acceso es completo.
- Historial almacenado sin purge por ahora.
- Reportes con salida PDF o impresión.
- Tres repositorios independientes.
- Compose no construye código de frontend/backend desde el repositorio de infraestructura.
- Las tarifas y cortes de boletos no deben entrar en `app_state`.
- No se copian automáticamente los desfases ambiguos del Excel: `NORTE 26!I15`, Edomex 2026 hacia 2025 y corrimiento de TAPO.
- La plata U–Z permanece en 2.36 hasta confirmación del cliente.

Ver [[Key Decisions]], [[Pago de Boletos 2026]] y [[Sprints Pago de Boletos 2026]].

## 8. Preguntas abiertas del cliente

1. ¿El corte corresponde a un socio, a una base completa o a un periodo?
2. ¿Debe ligarse el corte con un socio?
3. ¿Qué significan en negocio cuádruple, quíntuple y séptuple?
4. ¿Por qué no existe séxtuple?
5. ¿Los 0.30 de “sin ahorro” son una cuota intencional?
6. ¿Edomex 2026 debe usar tarifa 2025 o 2026?
7. ¿TAPO debe mezclar vigencia vigente, rezago y 2024?
8. ¿La plata de U–Z 2026 debe cambiar de 2.36 a 3?
9. ¿Se requieren roles, folios, formas de pago, cancelación y reimpresión?
10. ¿Cuál es el criterio de retención y consulta del historial?

## 9. Registro de cambios del PRD

| Fecha | Cambio | Estado |
|---|---|---|
| 2026-11-11 | Se crea el PRD vivo de Base580 para organizar histórico, pendientes y solicitudes del cliente. | Vigente |
| 2026-11-11 | Se documentan los ambientes local y producción y el comando `levantar-local.bat`. | Vigente |
| 2026-11-11 | Cambio 1: se solicita crear dos nuevas pestañas de catálogo BASE en `/boletos`, gestionadas con clic derecho mediante Añadir libro, Eliminar y Cambiar nombre; se aclara que no son hojas libres. | Pendiente de definición e implementación |
| 2026-10-21 | Se registra `/boletos` en productivo y el cierre de la primera entrega del corte. | Vigente; producción por reconfirmar |

### Plantilla para futuros cambios

```markdown
### Cambio YYYY-MM-DD — Título solicitado por el cliente

- **Solicitud:** qué pidió el cliente.
- **Motivo:** por qué se necesita.
- **Impacto:** módulos, datos, UX, API, despliegue o documentación afectados.
- **Decisión:** aceptado, rechazado, pendiente o reemplaza una decisión anterior.
- **Criterio de aceptación:** cómo sabremos que quedó terminado.
- **Referencias:** enlaces a épica, ticket, diseño o decisión.
```

## 10. Referencias

- [[overview]]
- [[hot]]
- [[Architecture Overview]]
- [[Data Flow]]
- [[Deploy Flow]]
- [[Key Decisions]]
- [[Pago de Boletos 2026]]
- [[Sprints Pago de Boletos 2026]]
- `_bmad-output/initiative-pago-boletos-2026/initiative-pago-boletos-2026.md`
- `_bmad-output/initiative-pago-boletos-2026/tickets/`

## 11. Assumptions Index

- **[ASSUMPTION-1]** Esta versión reúne el contexto existente y no sustituye una sesión formal de descubrimiento con el cliente.
- **[ASSUMPTION-2]** Las funcionalidades marcadas como “Hecho” corresponden al último estado documentado y deben reconfirmarse cuando se cambie código o producción.
- **[ASSUMPTION-3]** Las solicitudes nuevas se registrarán en este documento y se desglosarán en iniciativas, épicas o tickets según su tamaño.
