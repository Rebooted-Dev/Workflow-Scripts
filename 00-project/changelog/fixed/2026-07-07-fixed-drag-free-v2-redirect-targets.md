---
date: 2026-07-07
type: fixed
title: Repair Drag-Free-v2 redirect targets
status: complete
---

# Repair Drag-Free-v2 Redirect Targets

## Summary

Repaired the v2.0a canonical redirect targets listed in `MOVED.json` so the root `workflows/`, `core/`, `reference/`, and `tools/` tree is self-contained.

## Details

- Restored missing and self-stubbed canonical targets from existing v2 content, staged `00-project/Drag-Free-v2/` sources, or `v1.7` only where no v2 source existed.
- Refreshed legacy numbered-directory files as compatibility stubs matching `MOVED.json`.
- Added `scripts/validation/check-moved-targets.sh` and wired it into `scripts/validation/check-wf-cli.sh`.
- Updated `tools/wf` markdown discovery to skip archived `00-project/Drag-Free-v2/` evidence during active validation and catalog generation.
- Filed repair evidence in `00-project/build/drag-free-v2-separation/`.
- Marked `00-project/Drag-Free-v2/` as archived promotion evidence, not a second active v2 tree.

## Validation

- `bash scripts/validation/check-moved-targets.sh`
- `bash scripts/validation/check-wf-cli.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
