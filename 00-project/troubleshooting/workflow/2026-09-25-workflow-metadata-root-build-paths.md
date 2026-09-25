# Build workflow used a project-specific path

**Date:** 2026-09-25
**Category:** workflow
**Status:** resolved

## Symptom
- Active code-build instructions referred to the host-specific `project/build/` path, making routing inconsistent with metadata-root resolution and less portable across consumers.

## Root Cause
- The build workflows retained a hard-coded host path rather than using the shared metadata-root contract and its resolution guidance.

## Fix
- Replaced the bare plan/build paths with `<metadata-root>` routing and a link to Metadata Root Resolution.

## Verification
- Parent reports the `project/build/` search over planning/build returned no matches and the completion-chain policy validator passed.

## Notes / Lessons
- Use the metadata-root abstraction in reusable workflows; host-specific paths belong only where host policy explicitly permits them.
