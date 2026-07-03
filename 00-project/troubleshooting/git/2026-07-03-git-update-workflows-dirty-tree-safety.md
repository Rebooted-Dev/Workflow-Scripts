# Update workflows dirty tree safety

**Date:** 2026-07-03
**Category:** git
**Status:** resolved

## Symptom
`scripts/update-workflows.sh` could rely on separate tracked and untracked checks before committing staged Workflow-Scripts changes. The deep review follow-up flagged the lingering `git diff --name-only` pattern as a fragile safety contract.

## Root Cause
The helper checked unstaged tracked changes and untracked files through separate commands instead of using Git's porcelain status as the single dirty-tree source. That made the safety contract harder to validate and easier to regress.

## Fix
- Replaced the split check with one `git status --porcelain` parser that reports any unstaged tracked or untracked paths before commit.
- Expanded the validator to assert untracked failures, modified tracked failures, staged-only success, mocked push reachability, and removal of `git diff --name-only`.

## Verification
- `bash scripts/validation/check-update-workflows.sh`
