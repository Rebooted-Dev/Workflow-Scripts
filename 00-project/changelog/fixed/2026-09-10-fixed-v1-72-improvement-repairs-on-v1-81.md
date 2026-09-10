# Apply v1.72 improvement repairs on v1.81

**Date:** 2026-09-10  
**Type:** fixed  
**Status:** Complete

## Summary

Executed the nine finalized v1.72 improvement plans against the live `v1.81` tree. The merge had brought the plan documents but not the workflow-doc repairs; this batch closes that gap.

## Changes

- Plan 02: host-policy-first metadata-root resolution; planning workflows route research → `<metadata-root>/research/` and plans → `<metadata-root>/plans/`
- Plan 01: fixed broken `02-build-code` / Meta-Workflow links in planning workflows and README
- Plan 03: debugging README order corrected
- Plan 04: bug-description findings route through metadata-root research
- Plan 06: generalized mark-completed verification roles (no consumer-specific Electron/hooks examples)
- Plan 05: aligned bug-fix agent spawning with shared session policy
- Plan 09: documentation directory coherence updates
- Plan 08: recorded intentional `fable-like.md` non-retention (no unlicensed snapshot)
- Plan 07: indexed combined plan-review-and-finalise workflow in the User Manual

## Validation

- Spot checks: no active `02-build-code`, no 3–5 agent maxima, no consumer path examples in mark-completed roles, `fable-like.md` absent
- Shell validators run after this entry
