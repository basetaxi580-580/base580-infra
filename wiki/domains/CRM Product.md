---
type: domain
status: active
tags: [domain, product]
created: 2026-10-15
updated: 2026-10-21
---

# CRM Product

CRM operativo moderno alineado al sistema actual.

## Sprints (plan)

1. Foundation y navegación (shell, sidebar, search)
2. Perfil de socio / member
3. Captura y edición
4. Operaciones y boletos
5. Cancelación y reimpresión
6. Reportes + PDF
7. Audit / history
8. Catálogos (engomados, precios, estatus, motivos, tipos)

Detalle: [[sources/sprint-plan]]. Decisiones: [[Key Decisions]].

El corte de boletos del Excel 2026 está en `/boletos`. El detalle vive en [[Pago de Boletos 2026]] y el avance de sprints en [[Sprints Pago de Boletos 2026]]. Las tarifas de ese libro no caben en el `PriceItem` de un solo precio: usan `ticket_tariffs` y `ticket_settlements`. El plan de ocho sprints de arriba es el del CRM, no el de este corte.
