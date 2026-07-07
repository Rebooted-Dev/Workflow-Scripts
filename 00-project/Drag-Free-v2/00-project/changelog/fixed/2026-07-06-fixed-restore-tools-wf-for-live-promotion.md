---
date: 2026-07-06
type: fixed
title: Restore tools/wf for live promotion
status: complete
---

# Restore tools/wf for Live Promotion

## Summary

Recreated the dependency-free `tools/wf` CLI in the promoted Drag-Free-v2 tree and mirrored it into the live `Workflow-Scripts/` repository so canonical validation can run again.

## Details

- Added `tools/wf` with frontmatter validation, generated `catalog.json` and `ROUTER.md` freshness checks, route lookup, bookkeeping commands, completed-plan filing, debt ledger helpers, plan-review run manifests, run stats, and skill bundle generation.
- Regenerated `catalog.json`, `ROUTER.md`, and `dist/skills/` in the live repo, then synced generated outputs back to `Drag-Free-v2/`.
- Kept the existing 55 `wf validate` warnings as active cleanup items instead of hiding them.

## Validation

- `bash scripts/validation/check-wf-cli.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-workflow-skills.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-active-markdown-links.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-orchestrator-review.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-review-workflow-policy.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-sync-workflow-scripts.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-update-workflows.sh` passed in `Workflow-Scripts/`.
- `git diff --check` passed in `Workflow-Scripts/`.
