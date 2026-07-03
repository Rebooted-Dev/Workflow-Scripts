# Rewrote update-workflows.sh to be a maintainer-only helper that commits stage...
**Date:** 2026-01-20
**Type:** refactor

---

## Summary
- Rewrote update-workflows.sh to be a maintainer-only helper that commits staged changes and pushes (no parent repo interaction)

## Scope
- Migrated from root `CHANGELOG.md` (legacy monolithic changelog).
