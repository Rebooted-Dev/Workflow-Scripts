---
date: 2026-07-09
category: build
title: V2 root rename reference drift
status: resolved
---

# V2 Root Rename Reference Drift

## Issue

The active v2 workflow tree was renamed from `workflows/` to `workflows-drag-free/`, but supporting v2 directories and generated files still lived at the repository root and several validators still referenced the old paths.

## Impact

The repository had split v2 topology: workflow files were under `workflows-drag-free/`, while `core/`, `reference/`, `tools/`, `MOVED.json`, `catalog.json`, and `ROUTER.md` remained outside the renamed root. Current validation and documentation paths also still pointed at the previous root layout.

## Resolution

Resolved on 2026-07-09 by consolidating active v2 files under `workflows-drag-free/`, retargeting redirects and stubs, updating validators and CI, and regenerating the consolidated catalog/router.

## Validation

- `workflows-drag-free/tools/wf validate`
- `bash scripts/validation/check-moved-targets.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `bash scripts/validation/check-wf-cli.sh`
- `bash scripts/validation/check-workflow-skills.sh`
- `bash scripts/validation/check-orchestrator-review.sh`
- `bash scripts/validation/check-review-workflow-policy.sh`
