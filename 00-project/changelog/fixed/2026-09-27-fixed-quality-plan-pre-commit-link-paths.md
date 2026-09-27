# Correct pre-commit hook links in quality plan

**Date:** 2026-09-27
**Type:** fixed

## Summary

Fixed three markdown links to `scripts/hooks/pre-commit` in the planning/build quality plan so they resolve from `00-project/plans/` without escaping the repository root.

**Troubleshooting:** not needed — straightforward relative-path correction; no debugging or workaround required.

## Verification

- `bash scripts/validation/check-active-markdown-links.sh` → exit 0 locally.
- GitHub Actions Validation run `36314447856` on `33467b1` → success.
