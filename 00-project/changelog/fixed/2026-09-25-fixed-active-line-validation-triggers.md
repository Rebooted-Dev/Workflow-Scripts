# Trigger validation on active v1.8 lines
**Date:** 2026-09-25
**Type:** fixed

---

## Summary
- Added the quoted `'v1.8*'` pattern to both push and pull-request branch filters while retaining `main`, `v1.8`, and the existing `ci-validation-fixture/**` push pattern.

## Verification
- Local inspection confirmed both filters include `'v1.8*'` and the existing branch filters remain.
- Remote CI has not run; no push was authorized. Remote status remains pending, not passed.

## Related
- Troubleshooting: [Active-line CI coverage](../../troubleshooting/workflow/2026-09-25-workflow-active-line-ci-coverage.md)
