---
date: "2026-07-06"
title: "Engineering quality lifecycle"
type: "added"
notes: "Completed Drag-Free-v2 Phase 3 by adding engineering standards, wiring planning/execution/review/security workflows to those standards, adding T2/T3 quality sections to the plan sk"
---
# Engineering quality lifecycle

**Date:** 2026-07-06
**Type:** added
**Scope:** Workflow-Scripts Drag-Free-v2 Phase 3

## Summary

Completed Drag-Free-v2 Phase 3 by adding engineering standards, wiring planning/execution/review/security workflows to those standards, adding T2/T3 quality sections to the plan skeleton, adding architecture-design and greenfield-MVP workflows, adding a generic deploy workflow, and defining a debt ledger contract.

## Files

- `core/standards/code-design.md`
- `core/standards/error-handling.md`
- `core/standards/observability.md`
- `core/standards/security-baseline.md`
- `01-planning-and-organizing/04-architecture-design.md`
- `00-project-setup/08-greenfield-mvp.md`
- `07-deployment/00-deploy.md`
- `core/debt-ledger.md`
- `../Drag-Free-v2/2026-07-06-wf-validate-phase3-start.txt`

## Verification

- `tools/wf validate`
- `tools/wf route "architecture design"`
- `tools/wf route "deploy this project"`
- `tools/wf route "greenfield mvp"`
- `scripts/validation/check-wf-cli.sh`
- `scripts/validation/check-active-markdown-links.sh`
- `scripts/validation/check-orchestrator-review.sh`
- `scripts/validation/check-review-workflow-policy.sh`
- `scripts/validation/check-sync-workflow-scripts.sh`
- `scripts/validation/check-update-workflows.sh`
- `git diff --check`
