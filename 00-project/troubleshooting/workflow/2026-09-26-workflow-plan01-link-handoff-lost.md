# Plan 01 link handoff targets lost from TODO

**Date:** 2026-09-26
**Category:** workflow
**Status:** resolved

## Symptom

The Phase E TODO summary replaced the A3 handoff's four explicit target mappings with a brief Plan 01 ownership note. Plan 01 still owned the source repairs, but the TODO no longer retained the concrete destinations needed to execute that handoff.

## Root Cause

The summary edit retained lane ownership but omitted the nested target mapping. The A3 completion record therefore risked treating a handoff as fully tracked even though the actionable destinations were no longer present in TODO.

## Fix

The parent restored a nested Plan 01 handoff in `00-project/plans/TODO.md` with these intended targets, relative to `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`:

- `:7` and `:95` → recovered protocol planned at `./2026-09-10-astra-instruction-evaluation-protocol.md`.
- `:96` → `../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`.
- `:97` → `../../../00-Meta-Workflow/00-meta/workflow-applicability.md`.

The source links were not changed; Plan 01 retains ownership of source recovery and link repairs.

## Verification

- The restored TODO handoff contains all four explicit target mappings above.
- The current known link-check result remains exactly four failures at lines 7, 95, 96, and 97; those failures remain Plan 01-owned. Restored tracking is not a green link-check result.

## Notes / Lessons

- When condensing a TODO item, retain its nested lane-specific paths and decisions; ownership alone is not an actionable handoff.
- Track intended destinations separately from source-link repair, and do not claim that a restored TODO mapping closes the Plan 01 lane.
- Matching fix record: [changelog entry](../../changelog/fixed/2026-09-26-fixed-plan01-link-handoff-tracker.md).
