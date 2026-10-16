# Base580 Sprint Plan

## Goal
Build a modern CRM-like web app with the same business modules as the current system, but with a cleaner and faster UX.

## Product decisions already locked
- New modern UI
- Same modules as the current system
- No roles in this phase
- Full access for now
- Functional/operational search first
- PDF export for reports
- History is stored and not purged for now
- Local deployment for now

## Sprint 1 — Foundation and navigation
### Goal
Make the app navigable and searchable.

### Scope
- App shell
- Top header
- Left sidebar navigation
- Module routing placeholders
- Global search entry point
- Basic table/list shell

### Acceptance criteria
- User can open the app and see the modern shell.
- User can navigate to each module placeholder.
- User can search by the agreed identifiers.
- Screens feel usable on desktop.

## Sprint 2 — Socio / member profile
### Goal
Show the main member profile with the key fields seen in the current system.

### Scope
- Member profile screen
- Photo area
- ID, name, status, validity
- Engomado, sitio, placas
- Basic history panel

### Acceptance criteria
- User can open a member from search results.
- User sees the complete summary profile.
- User can inspect historical events for that member.

## Sprint 3 — Capture and edit flows
### Goal
Allow basic operational capture and edits.

### Scope
- Editable fields allowed by business
- Save/update flow
- Field validation
- Change history entry on save

### Acceptance criteria
- User can edit supported fields.
- Changes are saved.
- History is retained.

## Sprint 4 — Operations and tickets
### Goal
Implement the main ticket/operation workflow.

### Scope
- Create operation
- Capture terminal, zona, num. boletos
- Calculate amounts
- Line item table
- Generate ticket

### Acceptance criteria
- User can build an operation from lines.
- Totals are calculated automatically.
- User can generate a ticket folio.

## Sprint 5 — Cancelation and reprint
### Goal
Support correction workflows without deleting history.

### Scope
- Cancel operation with reason
- Reprint ticket by folio
- Keep audit trail

### Acceptance criteria
- Cancelation marks the record, it does not delete it.
- Reprint returns the same ticket layout.
- The action is recorded.

## Sprint 6 — Reports
### Goal
Provide operational reporting and PDF export.

### Scope
- Report by ID
- Report by date range
- Report by member
- PDF export
- Totals and detail rows

### Acceptance criteria
- User can filter reports.
- User can export a PDF.
- Report data matches the selected filters.

## Sprint 7 — Audit/history
### Goal
Persist all meaningful actions.

### Scope
- History timeline per member
- Operation history
- Cancelation history
- Reprint history

### Acceptance criteria
- Critical actions are stored.
- History is queryable later.
- No purge/deletion flow yet.

## Sprint 8 — Catalogs and configuration
### Goal
Administer the core lookup data.

### Scope
- Engomados
- Price list
- Status catalog
- Cancelation reasons
- Member types

### Acceptance criteria
- Catalogs can be viewed and edited.
- Operational screens use the catalog values.

## Sprint execution rules
- Build one sprint at a time.
- Keep each sprint demoable.
- Do not add roles until later phases.
- Prefer simple, explicit UI over hidden behavior.
- Record every critical action in history.
