---
date: "2026-07-03"
title: "Flatten 00-project directory layout"
type: "config"
notes: "- Removed the intermediate `project/` wrapper; meta directories now live directly under `00-project/`. - Updated path references across `AGENTS.md`, `README.md`, `docs/`, `plans/`,"
---
# Flatten 00-project directory layout

**Date:** 2026-07-03
**Type:** config

---

## Summary

- Removed the intermediate `project/` wrapper; meta directories now live directly under `00-project/`.
- Updated path references across `AGENTS.md`, `README.md`, `docs/`, `plans/`, `plans-completed/`, `troubleshooting/`, and `changelog/` files.

## Scope

- Path convention: relative to `00-project/` use `changelog/`, `docs/`, `plans/`, etc. (not `project/changelog/`).
- From Workflow-Scripts repo root: `00-project/changelog/`, `00-project/docs/`, etc.