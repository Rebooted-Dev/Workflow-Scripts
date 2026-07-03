# Update workflows dirty tree safety
**Date:** 2026-07-03
**Type:** fixed

---

## Summary
- Replaced split dirty-tree checks in `scripts/update-workflows.sh` with one `git status --porcelain` based safety check.
- Expanded `scripts/validation/check-update-workflows.sh` to cover untracked files, modified-but-unstaged tracked files, staged-only commits, and the removed `git diff --name-only` pattern.

## Scope
- `scripts/update-workflows.sh`
- `scripts/validation/check-update-workflows.sh`
- `scripts/README.md`
