---
date: "2026-07-03"
title: "Workflow-Scripts Deep Review Remediation Plan"
category: "review"
status: "completed"
notes: "Completed the remaining remediation from the corrected Workflow-Scripts deep review. The work preserved the existing artifact-routing baseline, hardened scripts, normalized review "
---
# Workflow-Scripts Deep Review Remediation Plan

**Date:** 2026-07-03
**Category:** review
**Status:** completed
**Branch:** `v1.7`
**Completion commit:** `7b50fd4`

## Summary
Completed the remaining remediation from the corrected Workflow-Scripts deep review. The work preserved the existing artifact-routing baseline, hardened scripts, normalized review policy, added untrusted-content guidance, replaced universal build-command assumptions, retired stale one-shot tooling, and added regression validation coverage.

## Completed Scope
- [✅] Hardened `scripts/sync-workflow-scripts.sh` for bash 3.2 compatibility, `git -C` usage, SSH/HTTPS Workflow-Scripts remotes, bounded auto-discovery, guarded status fetches, and stash recovery guidance.
- [✅] Fixed `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh` to pass the review prompt as the positional `opencode run` message and default output to the reviewed plan's sibling `.reviews/` directory.
- [✅] Added `00-Meta-Workflow/00-meta/agent-spawning-policy.md` and updated review/security workflows to reference it.
- [✅] Added untrusted-content guidance to plan/code/security review flows and security fix guidance.
- [✅] Replaced generic `npm run build` assumptions in active build/debug/security workflow guidance with project-specific verification discovery.
- [✅] Moved `scripts/migrate-changelog.py` to `00-project/build/archive/migrate-changelog.py`.
- [✅] Renamed `05-review/fable-review.md` to `05-review/05-comprehensive-audit.md` and added it to the review README.
- [✅] Added validation coverage:
  - `scripts/validation/check-sync-workflow-scripts.sh`
  - `scripts/validation/check-update-workflows.sh`
  - `scripts/validation/check-review-workflow-policy.sh`
  - Expanded `scripts/validation/check-orchestrator-review.sh`
- [✅] Added changelog and troubleshooting entries for the remediation.

## Verification
The following checks passed before the remediation commit:

```bash
./scripts/validation/check-active-markdown-links.sh
./scripts/validation/check-orchestrator-review.sh
./scripts/validation/check-sync-workflow-scripts.sh
./scripts/validation/check-update-workflows.sh
./scripts/validation/check-review-workflow-policy.sh
git diff --check
```

## Follow-Up
- Filed this completed plan after the initial remediation commit because `00-project/plans-completed/` had not been updated yet.
