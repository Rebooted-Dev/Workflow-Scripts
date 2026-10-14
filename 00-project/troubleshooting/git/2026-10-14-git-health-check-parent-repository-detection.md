# Health-check H02 must reject an inherited parent Git repository

**Date:** 2026-10-14
**Category:** git
**Status:** RESOLVED

---

## Symptom
- A health check that only runs `git -C <path> rev-parse --show-toplevel` can accept a directory that is merely inside its consumer's Git repository, even when that directory is not a separate Workflow-Scripts repository.

## Root Cause
- Git searches upward from the requested directory and returns the ancestor repository root; command success alone does not establish that the configured directory is itself the repository root.

## Fix
- H02 now requires an empty `git -C <path> rev-parse --show-prefix` and requires the reported top-level path to match the resolved configured path.

## Verification
- On `scripts/validation/fixtures/health-check/healthy/Workflow-Scripts`, `--show-toplevel` returned the enclosing Workflow-Scripts checkout and `--show-prefix` returned `scripts/validation/fixtures/health-check/healthy/Workflow-Scripts/`.
- `bash scripts/validation/health-check-selftest.sh` passed, including the non-Git `bad-workflow-repo` fixture nested inside a disposable consumer Git repository.

## Notes / Lessons
- The related verified fact is recorded as NOTED in `00-project/learnings/facts/2026-10-14-facts-git-subdirectory-inherits-parent-repository.md`.
