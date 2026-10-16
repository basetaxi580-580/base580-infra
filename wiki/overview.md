---
type: meta
title: "Base580 Overview"
status: active
created: 2026-10-15
updated: 2026-10-15
tags: [meta, overview]
---

# Base580 Overview

Base580 es un CRM operativo moderno (socios, operaciones, boletos, reportes) desplegado como tres repositorios independientes orquestados por Docker Compose.

## Repos

| Repo | Rol | Stack |
|------|-----|-------|
| [[base580-infra]] | Red, puertos, volúmenes, deploy | Docker Compose, Bash, GitHub Actions |
| [[base580-backend]] | API y persistencia | Java 24, Spring Boot, MongoDB |
| [[base580-frontend]] | UI y reverse proxy | Angular, Nginx |

## Runtime path

Ver [[Data Flow]]: Navegador → frontend (Nginx) → `/api/*` → backend → MongoDB.

## Product north star

Ver [[CRM Product]] y [[Key Decisions]]: misma funcionalidad de negocio que el sistema actual, UX moderna, sin roles en esta fase, historial inmutable, PDF en reportes, despliegue local/VM.

## Where to start

1. [[hot]] — contexto reciente
2. [[Architecture Overview]] — mapa técnico
3. [[sources/sprint-plan]] — plan de sprints
