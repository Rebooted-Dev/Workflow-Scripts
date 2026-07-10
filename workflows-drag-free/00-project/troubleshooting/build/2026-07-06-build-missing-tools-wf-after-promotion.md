---
date: 2026-07-06
category: build
title: Missing tools/wf after Drag-Free-v2 promotion
status: resolved
---

# Missing tools/wf After Drag-Free-v2 Promotion

## Issue

The live `Workflow-Scripts/` promotion contains generated `catalog.json`, `ROUTER.md`, generated README tables, and `scripts/validation/check-wf-cli.sh`, but the promoted source tree does not contain the executable `tools/wf` CLI.

## Impact

Canonical validation is blocked:

```bash
bash scripts/validation/check-wf-cli.sh
```

failed with:

```text
scripts/validation/check-wf-cli.sh: line 6: tools/wf: No such file or directory
```

This also blocks current-state confirmation for `tools/wf validate`, `tools/wf build --check`, `tools/wf build skills --check`, and `tools/wf route`.

## Evidence

- `find Drag-Free-v2 -path '*/.git' -prune -o -type f -name 'wf' -print` returned no file.
- `Drag-Free-v2/Workflow-Scripts-consolidated/workflow-scripts-untracked-files.txt` lists `tools/wf`, which indicates the CLI was untracked in the original source snapshot.
- Fallback validators passed in the live `Workflow-Scripts/` repo:
  - `bash scripts/validation/check-workflow-skills.sh`
  - `bash scripts/validation/check-active-markdown-links.sh`
  - `bash scripts/validation/check-orchestrator-review.sh`
  - `bash scripts/validation/check-review-workflow-policy.sh`
  - `bash scripts/validation/check-sync-workflow-scripts.sh`
  - `bash scripts/validation/check-update-workflows.sh`
  - `git diff --check`

## Resolution

Resolved on 2026-07-06 by recreating `tools/wf`, mirroring it into `Workflow-Scripts/tools/wf`, regenerating `catalog.json`, `ROUTER.md`, and `dist/skills/`, and rerunning the canonical validation suite.

Passed:

- `bash scripts/validation/check-wf-cli.sh`
- `bash scripts/validation/check-workflow-skills.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `bash scripts/validation/check-orchestrator-review.sh`
- `bash scripts/validation/check-review-workflow-policy.sh`
- `bash scripts/validation/check-sync-workflow-scripts.sh`
- `bash scripts/validation/check-update-workflows.sh`
- `git diff --check`

`tools/wf validate` still reports the expected 55 warnings; those are tracked as separate active cleanup tasks in `00-project/plans/TODO.md`.
