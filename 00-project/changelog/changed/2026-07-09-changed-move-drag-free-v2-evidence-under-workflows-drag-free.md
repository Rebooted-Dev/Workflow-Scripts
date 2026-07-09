---
date: 2026-07-09
type: changed
title: Move Drag-Free-v2 evidence under workflows-drag-free
status: complete
---

# Move Drag-Free-v2 Evidence Under Workflows Drag Free

## Summary

Moved the legacy `00-Drag-Free-v2/` planning and research evidence tree under the consolidated `workflows-drag-free/` root.

## Details

- Relocated `00-Drag-Free-v2/` to `workflows-drag-free/00-Drag-Free-v2/`.
- Updated the migration problem statement references that identified the old root-level evidence path.
- Updated active markdown and `tools/wf` discovery skips so the relocated evidence tree is retained as archive material, not scanned as active workflow content.

## Validation

- `workflows-drag-free/tools/wf validate`
- `workflows-drag-free/tools/wf build --check`
- `workflows-drag-free/tools/wf build skills --check`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
