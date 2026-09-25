# Planning/build delegation was over-prescriptive

**Date:** 2026-09-25
**Category:** workflow
**Status:** resolved

## Symptom
- Planning and code-build instructions used categorical agent wording and fixed role rosters without consistently pointing to the shared task-sizing/applicability guidance.

## Root Cause
- Several workflow families had locally copied delegation rules instead of consistently referring to `workflow-applicability.md`, allowing fixed prescriptions and wording to drift.

## Fix
- Replaced the rosters with applicability-sized delegation and role menus, removed prohibited terms, and linked parallel-agent instructions to the shared policy. Added a dedicated guard and negative fixture/self-test to CI.

## Verification
- Parent reports the planning/build policy guard and self-test passed; the prohibited-term search over planning/build returned no matches.

## Notes / Lessons
- Keep sizing policy centralized and guard active workflow language; the text validator does not by itself establish behavioral compliance.
