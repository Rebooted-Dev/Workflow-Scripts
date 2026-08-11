# Workflow: Execute and Confirm

## Purpose

Run implementation (Execution) followed by validation (Confirm Execution) in one workflow. Use this when you want to execute a plan and then verify completion without switching workflows.

**When to use:** When the user says "execute the plan and confirm" or "run execution then confirm" or wants a single workflow that does both.

## Inputs

- Same as **[`01-execution.md`](./01-execution.md):** goal and acceptance criteria, repository root, implementation plan (typically in `project/build/` or per `plans/README.md`).

## Output

- Everything from **[`01-execution.md`](./01-execution.md):** implemented code, updated changelog and (when applicable) troubleshooting, implementation plan updated with task status and completion marker, verification evidence.
- Plus everything from **[`02-confirm-execution.md`](./02-confirm-execution.md):** plan updated with any corrected marking, verification addendum (what was checked, any misreporting, next steps for incomplete items).

## Completion Bar

This workflow is **not finished** when code is written. It is finished when **one** terminal outcome is reached:

1. **01** met the shared **Verification Bar** per phase and at finalization (project verify, automated tests when present, acceptance/smoke when user-facing or runtime-dependent; skipped checks are blockers, not success). See **[`01-execution.md`](./01-execution.md)**.
2. **02** audited every claimed completion against code **and** verification evidence; misreporting corrected; addendum lists commands, tests, smoke, and residual risk.
3. **Terminal outcome (mandatory):**
   - **`Verified Complete`** — `01` and `02` report all applicable Verification Bar items passed, evidence is present, and no blocker remains → run [`03-mark-completed.md`](../04-documentation/03-mark-completed.md), the **sole** finalizer (terminal `✅`, completion marker, log/docs reconciliation, host-policy archive).
   - **`Not Eligible`** — any applicable check is blocked, skipped, failed, partial, or under-evidenced → plan stays **active** with the addendum; **no** completion marker, **no** archive.

Do not treat "build green" as a substitute for tests or acceptance smoke when those apply. Prefer the plan's named verify/test commands and acceptance criteria over generic checks alone.

## Steps

1. **Execute the plan** – Follow **[`01-execution.md`](./01-execution.md)** in full:
   - Preparation, phase definition, implementation loop (implement → **Verification Bar** → phase report), finalization.
   - Do **not** treat the optional "run 02-confirm-execution" at the end of 01 as optional in this workflow; step 2 replaces it.

2. **Confirm execution** – Follow **[`02-confirm-execution.md`](./02-confirm-execution.md)** in full to audit the plan and add the verification addendum (re-run or confirm verify/tests/smoke when evidence is missing or unconvincing). Confirmation audits and appends evidence; it does **not** finalize or archive.
3. **Resolve the terminal outcome (mandatory).** Exactly one of:
   - **`Verified Complete`** — `01` and `02` report all applicable Verification Bar items passed (verify command, tests when present, acceptance/smoke when user-facing or runtime-dependent), evidence is present, and no blocker remains. Then run the terminal gate **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** in full: it is the **only** step that applies terminal `✅` task marks, creates the completion marker, reconciles changelog/troubleshooting/docs, and archives the plan. Archive routing is resolved from the **host repository's policy** (not a global default).
   - **`Not Eligible`** — any applicable check is blocked, skipped, failed, partial, or insufficiently evidenced. Leave the plan **active**, append the blocker/addendum/next step from `02`, and apply **no** completion marker and **no** archive. Blocked/skipped/failed/missing evidence is **not** success.

   There is no "optional" or "when appropriate" path around the terminal gate for this workflow: a `Verified Complete` plan must invoke the gate; a `Not Eligible` plan must not.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed; plan identified (e.g. in `project/build/` or per `plans/README.md`)
- [ ] **01** run in full: phases implemented; **Verification Bar** met (verify command + tests when present + smoke when user-facing/runtime); plan and logs updated; residual blockers documented if any
- [ ] **02** run in full: plan audited against code **and** verification evidence; addendum lists commands/tests/smoke; marking corrected if needed; completion marker only if fully verified
- [ ] **Terminal outcome resolved:** `Verified Complete` → gate run; or `Not Eligible` → plan active, addendum, no marker/archive

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execution only (implement and verify in phases)
- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Confirm only (audit plan vs code; run after 01 or standalone)
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create implementation plans before execution
- **[`../01-planning-and-organizing/01-plan-review.md`](../01-planning-and-organizing/01-plan-review.md)** - Review plans before execution
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Code review after implementation
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
