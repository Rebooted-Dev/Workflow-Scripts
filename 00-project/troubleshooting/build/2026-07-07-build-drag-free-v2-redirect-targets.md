---
date: 2026-07-07
category: build
title: Drag-Free-v2 redirect targets incomplete
status: resolved
---

# Drag-Free-v2 Redirect Targets Incomplete

## Issue

The v2.0a branch contained a promoted `MOVED.json` redirect map, but many canonical targets under `workflows/`, `core/`, `reference/`, and `tools/` were missing or were themselves `# Moved` stubs.

## Impact

The active v2.0a tree depended on legacy numbered paths and staged `00-project/Drag-Free-v2/` content instead of being self-contained. The 2026-07-06 directory rationalization completion note was therefore incomplete for the live branch.

## Resolution

Resolved on 2026-07-07 by auditing every `MOVED.json` row, restoring broken canonical targets from the highest-priority real source, refreshing legacy compatibility stubs, and adding a redirect-terminal validator.

The pre-fix diagnosis remains filed at `00-project/research/2026-07-07-drag-free-v2-migration-problem-statement.md`. Repair evidence is filed at `00-project/build/drag-free-v2-separation/`.

## Validation

- `bash scripts/validation/check-moved-targets.sh`
- `bash scripts/validation/check-wf-cli.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
