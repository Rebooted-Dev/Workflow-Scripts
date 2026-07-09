---
date: 2026-07-09
type: changed
title: Consolidate v2 under workflows-drag-free
status: complete
---

# Consolidate v2 Under Workflows Drag Free

## Summary

Moved the active Drag-Free-v2 workflow library under `workflows-drag-free/` and updated current references, generated routing files, and validators for the renamed root.

## Details

- Consolidated active v2 `core/`, `reference/`, `tools/`, `MOVED.*`, `catalog.json`, and `ROUTER.md` under `workflows-drag-free/`.
- Retargeted `MOVED.json` and legacy stubs so old paths resolve to `workflows-drag-free/...`.
- Updated `workflows-drag-free/tools/wf` default root discovery and repo-level metadata handling.
- Updated validation scripts, CI commands, README, and sharing docs for the relocated v2 root.
- Regenerated `workflows-drag-free/catalog.json` and `workflows-drag-free/ROUTER.md`.

## Validation

- `workflows-drag-free/tools/wf validate`
- `bash scripts/validation/check-moved-targets.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `bash scripts/validation/check-wf-cli.sh`
- `bash scripts/validation/check-workflow-skills.sh`
- `bash scripts/validation/check-orchestrator-review.sh`
- `bash scripts/validation/check-review-workflow-policy.sh`
