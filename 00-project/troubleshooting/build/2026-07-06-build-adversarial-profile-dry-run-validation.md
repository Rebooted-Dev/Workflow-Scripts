---
date: 2026-07-06
category: build
title: Adversarial profile dry-run validation
status: resolved
---

# Adversarial Profile Dry-run Validation

## Issue

Phase 2 requires dry-runs against synthetic artifacts for each profile, but without validation those outputs could drift from the profile contracts.

## Impact

The profile specs might appear complete while missing required roles, schema sections, merge rules, model/harness appendix, or synthesis/reconciliation audit outputs.

## Resolution

Resolved on 2026-07-06 by extending `scripts/validation/check-adversarial-manifest-samples.sh` to check profile draft files and synthetic dry-run outputs in addition to sample manifests.

## Validation

`bash scripts/validation/check-adversarial-manifest-samples.sh` passes and reports profile/dry-run validation.
