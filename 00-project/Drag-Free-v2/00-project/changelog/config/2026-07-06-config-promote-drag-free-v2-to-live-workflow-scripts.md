---
date: 2026-07-06
type: config
title: Promote Drag-Free-v2 to live Workflow-Scripts
status: partial
---

# Promote Drag-Free-v2 to Live Workflow-Scripts

## Summary

Mechanically promoted the prepared `Drag-Free-v2/` tree into the live `Workflow-Scripts/` repository, excluding `.git/`, `.DS_Store`, and `Workflow-Scripts-consolidated/`.

## Details

- Synced promoted roots including `workflows/`, `core/`, `skills/`, `11-Skills/`, `MOVED.md`, `MOVED.json`, `ROUTER.md`, `catalog.json`, and updated metadata under `00-project/`.
- Preserved the live repository boundary by writing only inside `Workflow-Scripts/`.
- Left the promotion task open because the prepared tree does not include the `tools/wf` source file required by the canonical validation gate.

## Validation

- `bash scripts/validation/check-workflow-skills.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-active-markdown-links.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-orchestrator-review.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-review-workflow-policy.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-sync-workflow-scripts.sh` passed in `Workflow-Scripts/`.
- `bash scripts/validation/check-update-workflows.sh` passed in `Workflow-Scripts/`.
- `git diff --check` passed in `Workflow-Scripts/` after removing trailing whitespace from `00-project/troubleshooting/index.md`.
- `bash scripts/validation/check-wf-cli.sh` failed because `tools/wf` is missing from the promoted source tree.
