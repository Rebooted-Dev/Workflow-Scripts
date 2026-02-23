# Workflow: Execute and Confirm

## Purpose

Run implementation (Execution) followed by validation (Confirm Execution) in one workflow. Use this when you want to execute a plan and then verify completion without switching workflows.

**When to use:** When the user says "execute the plan and confirm" or "run execution then confirm" or wants a single workflow that does both.

## Inputs

- Same as **[`01-execution.md`](./01-execution.md):** goal and acceptance criteria, repository root, implementation plan in `plans/`.

## Output

- Everything from **[`01-execution.md`](./01-execution.md):** implemented code, updated changelog and (when applicable) troubleshooting, implementation plan updated with task status and completion marker.
- Plus everything from **[`02-confirm-execution.md`](./02-confirm-execution.md):** plan updated with any corrected marking, verification addendum (what was checked, any misreporting, next steps for incomplete items).

## Steps

1. **Execute the plan** – Follow **[`01-execution.md`](./01-execution.md)** in full:
   - Preparation, phase definition, implementation loop (implement → verify → phase report), finalization.
   - Do **not** treat the optional "run 02-confirm-execution" at the end of 01 as optional in this workflow; step 2 replaces it.

2. **Confirm execution** – Follow **[`02-confirm-execution.md`](./02-confirm-execution.md)** in full:
   - Read the plan; verify completion against the repo (parallel agents as in 02).
   - Systematically review every task; correct misreporting; add the verification addendum.
   - Add completion marker if the plan is fully complete and not already present.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed; plan identified in `plans/`
- [ ] **01** run in full: phases implemented, verified, plan and logs updated, final build passes
- [ ] **02** run in full: plan audited, addendum added, marking corrected if needed, completion marker if done

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execution only (implement and verify in phases)
- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Confirm only (audit plan vs code; run after 01 or standalone)
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create implementation plans before execution
- **[`../01-planning/01-plan-review.md`](../01-planning/01-plan-review.md)** - Review plans before execution
- **[`../05-review-audit/01-code-review.md`](../05-review-audit/01-code-review.md)** - Code review after implementation
- **[`../03-debug/02-bug-fix-workflow.md`](../03-debug/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
