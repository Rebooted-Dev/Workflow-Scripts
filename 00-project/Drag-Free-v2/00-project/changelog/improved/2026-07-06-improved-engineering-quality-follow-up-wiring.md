---
date: 2026-07-06
type: improved
title: Complete local engineering quality follow-up wiring
status: complete
---

# Complete Local Engineering Quality Follow-up Wiring

## Summary

Added the missing shared engineering-quality contracts and wired active workflows to use them.

## Details

- Added `core/standards/code-design.md`, `error-handling.md`, `observability.md`, and `security-baseline.md`.
- Added `core/debt-ledger.md` and `templates/walking-skeleton-checklist.md`.
- Added active `workflows/setup/08-greenfield-mvp.md` and `workflows/deployment/00-deploy.md` entries.
- Wired execution, planning, finalise-plan, optimization review, and refactoring review to debt and standards rules.

## Validation

- `tools/wf validate` passes with 0 warnings.
- `tools/wf build --check` passes.
- `tools/wf build skills --check` passes.
