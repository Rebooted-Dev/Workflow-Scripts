---
date: 2026-07-09
category: build
title: Numbered workflows-drag-free path drift
status: resolved
---

# Numbered Workflows Drag Free Path Drift

## Issue

Some `workflows-drag-free/` folders had been renamed to numbered names while the remaining setup, deployment, reference, and SEO/GEO folders still used unnumbered canonical paths.

## Impact

The active v2 tree mixed numbered and unnumbered layouts. Redirect stubs, generated routing, and validators could disagree about canonical targets until all remaining folders and references were updated together.

## Resolution

Resolved on 2026-07-09 by finishing the numbered folder renames, updating redirect stubs and current path references, and regenerating the catalog/router from the new layout.

## Validation

- `workflows-drag-free/tools/wf validate`
- `workflows-drag-free/tools/wf build --check`
- `workflows-drag-free/tools/wf build skills --check`
- `bash scripts/validation/check-moved-targets.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
