---
date: 2026-07-06
type: fixed
title: Restore rationalized planning targets
status: complete
---

# Restore Rationalized Planning Targets

## Summary

Restored canonical files referenced by `MOVED.md`, `catalog.json`, and planning README generated tables.

## Details

- Added `workflows/planning/04-architecture-design.md`.
- Added `workflows/planning/README.md`.
- Added `workflows/planning/fable-like.md`.
- Filed the engineering-quality survey rerun after restoring the architecture-design target.

## Validation

- `tools/wf validate`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
