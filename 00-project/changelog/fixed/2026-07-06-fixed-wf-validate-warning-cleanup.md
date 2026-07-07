---
date: 2026-07-06
type: fixed
title: Clear wf validate warnings
status: complete
---

# Clear wf Validate Warnings

## Summary

Reduced `tools/wf validate` from the retained 55-warning set to zero warnings in the live `Workflow-Scripts/` promotion.

## Details

- Added missing `core/roles/` records for workflow `agents:` references.
- Corrected stale planning workflow links from legacy build paths to canonical `workflows/build` paths.
- Fixed broken rubric links in planning workflows.
- Updated historical/meta path references that still pointed at legacy legacy numbered build, debugging, and review paths, and old `Workflow-Scripts/...` paths.
- Regenerated `catalog.json`, `ROUTER.md`, and skill bundles.

## Validation

- `tools/wf validate` passed with `Validated 205 frontmatter records with 0 warnings`.
- `bash scripts/validation/check-wf-cli.sh` passed.
- `bash scripts/validation/check-active-markdown-links.sh` passed.
