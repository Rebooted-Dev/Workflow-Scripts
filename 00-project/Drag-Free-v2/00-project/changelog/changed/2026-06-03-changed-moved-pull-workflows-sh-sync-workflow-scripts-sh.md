---
date: "2026-06-03"
title: "Moved `pull-workflows.sh`, `sync-workflow-scripts.sh`, and `update-workflows...."
type: "changed"
notes: "- Moved `pull-workflows.sh`, `sync-workflow-scripts.sh`, and `update-workflows.sh` into `scripts/` only (removed repo-root wrappers); scripts resolve repo root via `REPO_ROOT`. Use"
---
# Moved `pull-workflows.sh`, `sync-workflow-scripts.sh`, and `update-workflows....
**Date:** 2026-06-03
**Type:** changed

---

## Summary
- Moved `pull-workflows.sh`, `sync-workflow-scripts.sh`, and `update-workflows.sh` into `scripts/` only (removed repo-root wrappers); scripts resolve repo root via `REPO_ROOT`. Use `./Workflow-Scripts/scripts/pull-workflows.sh` from host projects.

## Scope
- Migrated from root `CHANGELOG.md` (legacy monolithic changelog).
