# check-meta-logs.sh needs a staged or ranged diff
**Date:** 2026-10-13
**Category:** tooling
**Status:** NOTED
**Source:** command: check-meta-logs.sh run on the changelog entries (exit 0)

---

## Situation
- Running check-meta-logs.sh with no arguments prints usage and exits. It checks only staged or ranged changes, so unstaged changelog files are not checked.

## Pattern to avoid
- Assuming a passing run covers files that are not staged.

## Better approach
- Stage the new entry and the index row, run --staged, then unstage them with git restore --staged.

## Verification
- Exit 0 with meta log checks OK for the changelog entries in this session; nothing was committed.

## Notes
- The pre-commit hook (core.hooksPath is scripts/hooks) runs the same check on commit.
