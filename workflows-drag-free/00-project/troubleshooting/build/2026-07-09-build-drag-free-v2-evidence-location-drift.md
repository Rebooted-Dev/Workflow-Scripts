---
date: 2026-07-09
category: build
title: Drag-Free-v2 evidence location drift
status: resolved
---

# Drag-Free-v2 Evidence Location Drift

## Issue

The active v2 workflow root had been consolidated under `workflows-drag-free/`, but the legacy `00-Drag-Free-v2/` planning and research evidence tree still lived at the repository root.

## Impact

The repository still had two root-level v2-looking locations: the active consolidated root and the historical evidence folder. That made it less clear which path contained active workflow content and risked validators treating archived planning material as part of the active library after the move.

## Resolution

Resolved on 2026-07-09 by moving `00-Drag-Free-v2/` into `workflows-drag-free/00-Drag-Free-v2/`, updating direct references to the moved path, and excluding the relocated evidence tree from active workflow and markdown-link scans.

## Validation

- `workflows-drag-free/tools/wf validate`
- `workflows-drag-free/tools/wf build --check`
- `workflows-drag-free/tools/wf build skills --check`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
