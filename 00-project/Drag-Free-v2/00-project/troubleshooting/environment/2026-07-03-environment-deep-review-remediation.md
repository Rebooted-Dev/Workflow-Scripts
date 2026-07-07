---
date: "2026-07-03"
title: "Deep review remediation"
category: "environment"
status: "resolved"
---
# Deep review remediation

**Date:** 2026-07-03
**Category:** environment
**Status:** resolved

## Symptom
The corrected deep review identified script and workflow defects: bash 3.2-incompatible sync code, `set -e` counter hazards, unguarded status fetches, stale `opencode run --prompt` examples, universal npm verification guidance, and conflicting review-agent limits.

## Root Cause
Workflow helper scripts and active docs had drifted independently. Several examples encoded old OpenCode invocation and root `plans/reviews` routing, while sync/update helpers did not have regression coverage for dirty trees, SSH remotes, or untracked files.

## Fix
- Converted sync counters and discovery to portable shell patterns.
- Used `git -C` for repo operations and guarded per-project fetch failures.
- Reapplied stashed sync changes only after successful update and printed exact recovery commands on failure.
- Updated orchestrator invocation/output routing and review policies.
- Added validation scripts for sync, update helper, orchestrator, and review-policy consistency.

## Verification
- `./scripts/validation/check-active-markdown-links.sh`
- `./scripts/validation/check-orchestrator-review.sh`
- `./scripts/validation/check-sync-workflow-scripts.sh`
- `./scripts/validation/check-update-workflows.sh`
- `./scripts/validation/check-review-workflow-policy.sh`
- `git diff --check`
