---
date: "2026-07-06"
title: "wf CLI foundation"
type: "added"
notes: "Added the dependency-free `tools/wf` CLI foundation with frontmatter-driven `validate`, `init-frontmatter`, `prune-skipped-frontmatter`, `build`, `build --check`, and `route` comma"
---
# wf CLI foundation

**Date:** 2026-07-06
**Type:** added
**Scope:** Workflow-Scripts machine-readable routing foundation

## Summary

Added the dependency-free `tools/wf` CLI foundation with frontmatter-driven `validate`, `init-frontmatter`, `prune-skipped-frontmatter`, `build`, `build --check`, and `route` commands.

## Files

- `tools/wf`
- `catalog.json`
- `ROUTER.md`
- `scripts/validation/check-wf-cli.sh`
- v2 frontmatter across active workflow/reference/template/policy files
- Generated README/category catalog tables
- `../Drag-Free-v2/2026-07-06-wf-validate-phase1.txt`

## Verification

- `scripts/validation/check-wf-cli.sh`
- `scripts/validation/check-active-markdown-links.sh`
- `scripts/validation/check-orchestrator-review.sh`
- `scripts/validation/check-review-workflow-policy.sh`
- `scripts/validation/check-sync-workflow-scripts.sh`
- `scripts/validation/check-update-workflows.sh`
- `git diff --check`
