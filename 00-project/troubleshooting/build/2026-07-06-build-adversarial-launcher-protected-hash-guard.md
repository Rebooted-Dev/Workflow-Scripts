---
date: 2026-07-06
category: build
title: Adversarial launcher protected hash guard
status: resolved
---

# Adversarial Launcher Protected Hash Guard

## Issue

Phase 4 needed proof that the fan-out launcher can reject a pass that changes a protected source while still allowing normal local/manual smoke runs.

## Impact

Without a negative guard, a launcher implementation could silently accept source mutation during adversarial fan-out and make later synthesis or review outputs untrustworthy.

## Resolution

Resolved on 2026-07-06 by adding `scripts/validation/check-adversarial-launcher.sh` and `00-project/build/adversarial-multi-model-workflow/prototypes/configs/hash-guard-negative.json`.

The validator runs:

- a two-pass research smoke;
- a two-pass review smoke;
- a deliberately mutating negative pass, then restores the fixture and requires the launcher to fail with `protected path changed during run`.

## Validation

- `bash scripts/validation/check-adversarial-launcher.sh`
- `shellcheck 00-project/build/adversarial-multi-model-workflow/prototypes/fan-out-adversarial.sh scripts/validation/check-adversarial-launcher.sh`
