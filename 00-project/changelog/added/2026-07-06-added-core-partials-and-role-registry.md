---
date: "2026-07-06"
title: "Core partials and role registry"
type: "added"
notes: "Completed Drag-Free-v2 Phase 2 by adding shared core partials and canonical role contracts, wiring planning/build/review/security workflows to `requires` and `agents` frontmatter f"
---
# Core partials and role registry

**Date:** 2026-07-06
**Type:** added
**Scope:** Workflow-Scripts Drag-Free-v2 Phase 2

## Summary

Completed Drag-Free-v2 Phase 2 by adding shared core partials and canonical role contracts, wiring planning/build/review/security workflows to `requires` and `agents` frontmatter fields, replacing free-text role menus in the main workflow surfaces, adding role-reference validation, adding core-phrase duplication linting, and recording token-reduction evidence.

## Files

- `core/metadata-root.md`
- `core/filing-and-logging.md`
- `core/parallel-agents.md`
- `core/verification-gates.md`
- `core/artifact-contract.md`
- `core/roles/*.md`
- `tools/wf`
- `catalog.json`
- `ROUTER.md`
- `../Drag-Free-v2/2026-07-06-phase2-token-reduction-report.md`
- `../Drag-Free-v2/2026-07-06-wf-validate-phase2-final.txt`

## Verification

- `scripts/validation/check-wf-cli.sh`
- `scripts/validation/check-active-markdown-links.sh`
- `scripts/validation/check-orchestrator-review.sh`
- `scripts/validation/check-review-workflow-policy.sh`
- `scripts/validation/check-sync-workflow-scripts.sh`
- `scripts/validation/check-update-workflows.sh`
- `git diff --check`
