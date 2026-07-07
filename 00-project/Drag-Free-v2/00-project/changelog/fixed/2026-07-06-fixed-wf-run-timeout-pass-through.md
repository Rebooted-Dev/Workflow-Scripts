---
date: 2026-07-06
type: fixed
title: Honor wf run timeout
status: complete
---

# Honor wf run Timeout

## Summary

Updated `tools/wf run` to pass its `--timeout` argument through to `tools/orchestrator/orchestrator-review.sh`.

## Details

- Preserved the existing `tools/wf run plan-review <plan> --output <path>` command shape.
- Forwarded `--timeout <minutes>` when supplied so callers can bound real non-stub provider runs.
- Mirrored the fix in both the live `Workflow-Scripts/` repo and the promoted `Drag-Free-v2/` tree.

## Validation

- Confirmed `tools/wf run ... --timeout 5` now reports `Timeout: 5 minutes` in orchestrator output.
