# Workflow: Execute and Confirm

## Purpose

Run implementation (Execution) followed by validation (Confirm Execution) in one workflow. Use this when you want to execute a plan and then verify completion without switching workflows.

**When to use:** When the user says "execute the plan and confirm" or "run execution then confirm" or wants a single workflow that does both.

## Inputs

- Same as **[`01-execution.md`](./01-execution.md):** goal and acceptance criteria, repository root, implementation plan under `<metadata-root>/plans/` (or host-permitted `<metadata-root>/build/`); resolve the metadata root and filename convention via [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution).

## Output

- Everything from **[`01-execution.md`](./01-execution.md):** implemented code, updated changelog and (when applicable) troubleshooting, implementation plan updated with verified task status, and verification evidence. The plan-level completion marker and archive are applied only by the terminal gate.
- Plus everything from **[`02-confirm-execution.md`](./02-confirm-execution.md):** plan updated with any corrected marking, verification addendum (what was checked, any misreporting, next steps for incomplete items).

## Completion Bar

This workflow is **not finished** when code is written. It is finished when **one** terminal outcome is reached:

1. **01** met the shared **Verification Bar** per phase and at finalization (project verify, automated tests when present, acceptance/smoke when user-facing or runtime-dependent; skipped checks are blockers, not success). See **[`01-execution.md`](./01-execution.md)**.
2. **02** audited every claimed completion against code **and** verification evidence; misreporting corrected; addendum lists commands, tests, smoke, and residual risk.
3. **Terminal outcome (mandatory):** run [`03-mark-completed.md`](../04-documentation/03-mark-completed.md) for **both** outcomes; the outcome only picks its mode:
   - **`Verified Complete`** — `01` and `02` report all applicable Verification Bar items passed, evidence is present, and no blocker remains, with every committed in-scope task and criterion verified **except** the designated terminal filing pair → gate in **Full completion** mode (task `✅` reconciliation, package filing per the plan's `## Artifact lifecycle` inventory, completion marker only after filing verifies, log/docs reconciliation, host-policy routing).
   - **`Not Eligible`** — any applicable check is blocked, skipped, failed, partial, or under-evidenced → gate in **Reconcile only** mode (verified tasks still get `✅`; logs, docs, and TODO reconciled). Reconcile initiates **no further moves**: artifacts already moved by a failed Full-completion attempt stay where they are, recorded for named-path resume through the gate. The plan stays **active** with the addendum; **no** completion marker, **no** archive.
4. **Every verified task and criterion is ticked, and nothing is silently open.** When this workflow ends, no box whose implementation and evidence are present is still `[ ]`, in either outcome, and every remaining `[ ]` has an `Open:` reason. `check-plan.sh --state` passes.

Do not treat "build green" as a substitute for tests or acceptance smoke when those apply. Prefer the plan's named verify/test commands and acceptance criteria over generic checks alone.

## Steps

1. **Execute the plan** – Follow **[`01-execution.md`](./01-execution.md)** in full:
   - Preparation, phase definition, implementation loop (implement → **Verification Bar** → phase report), finalization.
   - Do **not** treat the optional "run 02-confirm-execution" at the end of 01 as optional in this workflow; step 2 replaces it.

2. **Confirm execution** – Follow **[`02-confirm-execution.md`](./02-confirm-execution.md)** in full to audit the plan and add the verification addendum (re-run or confirm verify/tests/smoke when evidence is missing or unconvincing). Confirmation audits and appends evidence; it does **not** finalize or archive.
3. **Resolve the terminal outcome and run the gate (mandatory).** Decide exactly one outcome, then run **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** in the matching mode:
   - **`Verified Complete`** — `01` and `02` report all applicable Verification Bar items passed (verify command, tests when present, acceptance/smoke when user-facing or runtime-dependent), evidence is present, and no blocker remains — with every committed in-scope task and criterion verified **except** the gate-owned terminal filing pair. Run the gate in **Full completion** mode: it ticks every verified task `[✅]`, files the completed **package** (plan plus task-exclusive artifacts per its `## Artifact lifecycle` inventory), reconciles changelog/troubleshooting/docs/TODO, applies the completion marker only after the filing verifies, and reports the actual final path. Archive routing is resolved from the **host repository's policy** (not a global default).
   - **`Not Eligible`** — any applicable check is blocked, skipped, failed, partial, or insufficiently evidenced. Run the gate in **Reconcile only** mode: it still ticks every individually verified task `[✅]` and reconciles changelog/troubleshooting/docs/TODO, and initiates no further moves — artifacts already moved by a failed Full-completion attempt stay recorded at their actual locations for named-path resume. Leave the plan **active**, append the blocker/addendum/next step from `02`, and apply **no** completion marker and **no** archive. Blocked/skipped/failed/missing evidence is **not** success for the blocked task or for the plan. It does **not** stop verified sibling tasks from being ticked.

   There is no "optional" or "when appropriate" path around the gate: it runs for **every** outcome. Only the completion marker and archive depend on the outcome.

4. **Final check before reporting.** Run `bash <workflow-scripts>/scripts/validation/check-plan.sh --require-tier --state <plan-at-its-actual-current-path>` (path per [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#workflow-scripts-checkout)): use the plan's **actual current path** as the gate reported it — the archived path once it has moved (even if other artifacts have not), the active path while it has not; after a partial filing, use the plan's current location, never an assumed one. It must print `OK (…, state)`. Each line it reports is a box that is neither ticked nor explained: tick it if its implementation and evidence are present, otherwise give it an `Open:` reason ([Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract)), and re-run. If a verified task was still `[ ]`, the gate was skipped or cut short: go back and finish it. Include the gate's two status lines (`Implementation verification`, `Package filing`) and its actual-path report in the report; a pending, blocked, or partial filing is reported as such, never as completion. Do not hand this check back to the user.

## Quick Checklist

- [ ] Goal and acceptance criteria confirmed; plan identified under `<metadata-root>/plans/` (or host-permitted `<metadata-root>/build/`) using [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#metadata-root-resolution)
- [ ] **01** run in full: phases implemented; **Verification Bar** met (verify command + tests when present + smoke when user-facing/runtime); plan and logs updated; residual blockers documented if any
- [ ] **02** run in full: plan audited against code **and** verification evidence; addendum lists commands/tests/smoke; ticks corrected in both directions (verified `[ ]` → `[✅]`, unverified `[✅]` → `[ ]`)
- [ ] **Gate run for the outcome:** `Verified Complete` → Full completion mode (marker + archive); `Not Eligible` → Reconcile only mode (verified tasks ticked, logs reconciled, plan active, no marker/archive)
- [ ] **No verified task or criterion left `[ ]`; `check-plan.sh --state` prints `OK`**

## Related Workflows

- **[`01-execution.md`](./01-execution.md)** - Execution only (implement and verify in phases)
- **[`02-confirm-execution.md`](./02-confirm-execution.md)** - Confirm only (audit plan vs code; run after 01 or standalone)
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create implementation plans before execution
- **[`../01-planning-and-organizing/01-plan-review.md`](../01-planning-and-organizing/01-plan-review.md)** - Review plans before execution
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Code review after implementation
- **[`../03-debugging/02-bug-fix-workflow.md`](../03-debugging/02-bug-fix-workflow.md)** - Fix bugs discovered during implementation
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** - Update documentation after code changes
