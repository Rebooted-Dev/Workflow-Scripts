# Validation CI omitted active v1.8 branches

**Date:** 2026-09-25
**Category:** workflow
**Status:** resolved

## Symptom
- Validation CI listened to `main` and the exact `v1.8` branch but did not trigger for active maintenance branches such as `v1.82`.

## Root Cause
- The branch filters did not include a wildcard for the active `v1.8*` line.

## Fix
- Added quoted `'v1.8*'` patterns to both push and pull-request filters while retaining the existing branch patterns.

## Verification
- Local inspection confirms the two filters include `'v1.8*'` and preserve `main` and `v1.8`; the existing fixture branch filter remains on push.
- Remote CI has not run because no push was authorized. The active-link baseline is still owned by Plan 01, so no remote-green result is claimed.

## Notes / Lessons
- Branch-filter inspection verifies trigger configuration only; an actual workflow run remains a separate remote check.
