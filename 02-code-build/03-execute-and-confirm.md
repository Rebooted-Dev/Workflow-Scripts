# Workflow: Execute and Confirm

## Purpose

Run implementation (Execution) followed by validation (Confirm Execution) in one workflow. Use this when you want to execute a plan and then verify completion without switching workflows.

**When to use:** When the user says "execute the plan and confirm" or "run execution then confirm" or wants a single workflow that does both.

## Inputs

- Same as **[`01-execution.md`](./01-execution.md):** goal and acceptance criteria, repository root, implementation plan (typically in `project/build/` or per `plans/README.md`).

## Output

- Everything from **[`01-execution.md`](./01-execution.md):** implemented code, updated changelog and (when applicable) troubleshooting, implementation plan updated with task status and completion marker.
- Plus everything from **[`02-confirm-execution.md`](./02-confirm-execution.md):** plan updated with any corrected marking, verification addendum (what was checked, any misreporting, next steps for incomplete items).

## Steps

1. **Execute the plan** – Follow **[`01-execution.md`](./01-execution.md)** in full:
   - Preparation, phase definition, implementation loop (implement → verify → phase report), finalization.
   - Do **not** treat the optional "run 02-confirm-execution" at the end of 01 as optional in this workflow; step 2 replaces it.

2. **Confirm execution** – Follow **[`02-confirm-execution.md`](./02-confirm-execution.md)** in full to audit the plan and add the verification addendum.
  - **Then, when the plan is fully verified complete:** Execute the full **`03-mark-completed.md` workflow** to:
    - Verify implementation with parallel agents
    - Reconcile changelog, troubleshooting, and documentation
    - Mark tasks with ✅ consistently
    - Archive the plan into `project/changelog/plans/` and update `project/changelog/index.md`

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed; plan identified (e.g. in `project/build/` or per `plans/README.md`)
- [ ] **01** run in full: phases implemented, verified, plan and logs updated, final build passes
- [ ] **02** run in full: plan audited, addendum added, marking corrected if needed, completion marker if done

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execution only (implement and verify in phases)
- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Confirm only (audit plan vs code; run after 01 or standalone)
- **[`../01-Planning & Organizing/02-finalise-plan.md`](../01-Planning & Organizing/02-finalise-plan.md)** - Create implementation plans before execution
- **[`../01-Planning & Organizing/01-plan-review.md`](../01-Planning & Organizing/01-plan-review.md)** - Review plans before execution
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Code review after implementation
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
