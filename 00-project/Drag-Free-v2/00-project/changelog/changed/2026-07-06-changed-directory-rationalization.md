---
date: "2026-07-06"
type: "changed"
title: "Directory rationalization"
notes: "Completed Drag-Free-v2 Phase 6 with workflows/reference/core/tools layout migration, MOVED redirect map, catalog redirect metadata, compatibility stubs, updated validation paths, and final layout verification."
---
# Directory rationalization

**Date:** 2026-07-06
**Type:** changed

## Summary

Completed Drag-Free-v2 Phase 6 with workflows/reference/core/tools layout migration, MOVED redirect map, catalog redirect metadata, compatibility stubs, updated validation paths, and final layout verification.

## Verification

- `tools/wf validate` after directory rationalization was captured in `logs/2026-07-06-wf-validate-phase6.txt`.
- `git diff --check`, `tools/wf build --check`, and `tools/wf build skills --check` are listed as passed in `logs/README.md`; archive-only remediation reclassified missing CLI source as a validation limitation.
