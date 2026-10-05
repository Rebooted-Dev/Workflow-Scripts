# File plan for consistent plan checkboxes and completion ticks

**Date:** 2026-10-05
**Type:** docs

## Summary

Investigated the owner's report that plans do not always have checkboxes and that executing them does not always tick completed tasks, then ran `01-planning-and-organizing/02-finalise-plan.md` to file a T2 plan under `plans/`. It passed `check-plan.sh` as a draft and was executed the same day; it is now filed at [`plans-completed/implementation/2026-10-05-plan-checkbox-and-tick-consistency-implementation-plan.md`](../../plans-completed/implementation/2026-10-05-plan-checkbox-and-tick-consistency-implementation-plan.md).

- **Findings:** the 2026-09-25 tick fix holds for tiered plans run through `01-execution.md`. The remaining misses are: tier-less plans bypass the linter; authoring workflows never run it; `[x]` is accepted while `[✅]` is required; `## Success Criteria` boxes have no owner; nothing checks tick state after execution; plans from other tools are filed without checkboxes; `glossary.md:48` and `README.md:933` still state the pre-fix rule; hosts carry no always-on tick rule.
- **Plan:** one marking contract in `plan-template.md`, three `check-plan.sh` additions (strict markers, `--require-tier`, `--state`), required run steps in the planning and execution workflows, regression guards, and a setup-template rule.
- **Inputs:** owner problem statement only. No source plan to supersede and no `PLAN.reviews/` directory to archive.

This entry covers the investigation and planning step only. The implementation is recorded in [`../fixed/2026-10-05-fixed-plan-checkbox-and-tick-consistency.md`](../fixed/2026-10-05-fixed-plan-checkbox-and-tick-consistency.md).
