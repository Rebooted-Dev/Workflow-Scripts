# Restore Plan 01 link targets in TODO handoff

**Date:** 2026-09-26
**Type:** fixed

## Summary

The Phase E TODO summary had dropped A3's four explicit Plan 01 link targets. The parent restored them as a nested TODO handoff. The source links remain unrepaired and owned by Plan 01; this tracker correction does not repair links or complete the plan.

**Troubleshooting:** [Plan 01 link handoff targets lost from TODO](../../troubleshooting/workflow/2026-09-26-workflow-plan01-link-handoff-lost.md)

## Verification

- Confirmed the restored TODO mapping for `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`: `:7` and `:95` → `./2026-09-10-astra-instruction-evaluation-protocol.md` (recovered protocol planned in the same directory); `:96` → `../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`; `:97` → `../../../00-Meta-Workflow/00-meta/workflow-applicability.md`.
- The four source links remain broken and Plan 01 owns their repair. This records restored destinations, not a green link-check result.
