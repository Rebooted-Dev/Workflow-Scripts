---
date: 2026-07-06
type: added
title: Add adversarial multi-model Phase 1 contracts
status: complete
---

# Add Adversarial Multi-Model Phase 1 Contracts

## Summary

Implemented Phase 1 of `2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md` by filing shared draft contracts and sample manifests under the Workflow-Scripts metadata root.

## Details

- Added artifact, manifest, cleanup, and source-resolution draft contracts under `00-project/build/adversarial-multi-model-workflow/draft-workflows/`.
- Added sample research, planning, and review manifests under `00-project/build/adversarial-multi-model-workflow/samples/`.
- Added `scripts/validation/check-adversarial-manifest-samples.sh` to validate required manifest shape.
- Mirrored the same artifacts into `Drag-Free-v2/`.

## Validation

- `bash scripts/validation/check-adversarial-manifest-samples.sh`
- `bash scripts/validation/check-wf-cli.sh`
- `bash scripts/validation/check-active-markdown-links.sh`
- `git diff --check`
