---
date: 2026-07-06
category: build
title: Adversarial Phase 3 pilot validation
status: resolved
---

# Adversarial Phase 3 Pilot Validation

## Issue

Phase 3 requires manual pilots with accepted canonical outputs, unchanged protected sources, and evidence of singleton or conflict/near-conflict handling.

## Impact

Without a validator, the pilot could appear complete while missing pass artifacts, synthesis/reconciliation outputs, canonical outputs, or protected-source hash checks.

## Resolution

Resolved on 2026-07-06 by adding `scripts/validation/check-adversarial-phase3-pilots.sh`.

The validator checks:

- the Phase 3 pilot manifest exists;
- each profile has at least two completed pass artifacts;
- research/planning synthesis and review reconciliation outputs exist;
- canonical pilot outputs exist;
- protected source hashes still match the manifest.

## Validation

`bash scripts/validation/check-adversarial-phase3-pilots.sh` passes.
