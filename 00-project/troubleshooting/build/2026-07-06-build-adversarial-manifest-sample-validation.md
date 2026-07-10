---
date: 2026-07-06
category: build
title: Adversarial manifest samples need validation
status: resolved
---

# Adversarial Manifest Samples Need Validation

## Issue

The adversarial multi-model Phase 1 exit criteria require hand-written sample manifests for research, planning, and review to validate by checklist.

## Impact

Without an executable check, manifest examples could drift from the documented `_manifest.json` contract while still appearing complete.

## Resolution

Resolved on 2026-07-06 by adding `scripts/validation/check-adversarial-manifest-samples.sh`, which parses all `*-manifest.sample.json` files and validates required top-level fields, pass fields, allowed profiles, pass statuses, and cleanup decisions.

## Validation

`bash scripts/validation/check-adversarial-manifest-samples.sh` passes.
