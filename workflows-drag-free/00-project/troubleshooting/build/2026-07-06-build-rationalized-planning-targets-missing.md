---
date: 2026-07-06
category: build
title: Rationalized planning targets missing
status: resolved
---

# Rationalized Planning Targets Missing

## Issue

The rationalized planning redirects and generated catalog referenced `workflows/planning/04-architecture-design.md`, `workflows/planning/README.md`, and `workflows/planning/fable-like.md`, but those canonical target files were missing.

## Impact

The engineering-quality survey rerun could not honestly mark architecture/design coverage as complete while the architecture-design workflow existed only as a redirect to a missing target.

## Resolution

Resolved on 2026-07-06 by restoring the three canonical planning targets in `workflows/planning/`.

## Validation

- `tools/wf validate`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
