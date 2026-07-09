---
date: 2026-07-09
type: changed
title: Number workflows-drag-free folders
status: complete
---

# Number Workflows Drag Free Folders

## Summary

Finished aligning the consolidated `workflows-drag-free/` folder names with the legacy numbered Workflow-Scripts layout.

## Details

- Completed remaining active tree renames for setup, deployment, API integration, meta workflow reference, technical docs, and SEO/GEO content.
- Updated redirect stubs, `MOVED.json`, `MOVED.md`, generated routing, and current references to point at the numbered `workflows-drag-free/` paths.
- Regenerated `workflows-drag-free/catalog.json` and `workflows-drag-free/ROUTER.md`.

## Validation

- `workflows-drag-free/tools/wf validate`
- `workflows-drag-free/tools/wf build --check`
- `workflows-drag-free/tools/wf build skills --check`
- `bash scripts/validation/check-moved-targets.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
