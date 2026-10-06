# Workflow: Review, Finalise, Commit, and Execute

## Purpose

Run the full plan-to-code pipeline in one workflow: review and finalise a plan, stage and commit the planning artifacts, then execute and confirm the finalised plan.

Use this workflow when you would otherwise ask for both:

1. [`../01-planning-and-organizing/03-plan-review-and-finalise.md`](../01-planning-and-organizing/03-plan-review-and-finalise.md)
2. [`03-execute-and-confirm.md`](./03-execute-and-confirm.md)

**When to use:** When the user says "review and finalise the plan, commit it, then execute" or wants a single workflow that takes a draft plan through to verified implementation with a clean commit boundary in between.

## Inputs

- Primary plan document path, supplied by the user (draft or reviewable plan).
- Repository root of the **host project** (where the plan lives and where code will be implemented).
- Any context, constraints, or prior feedback supplied by the user.

## Steps

1. **Review and finalise** – Execute [`../01-planning-and-organizing/03-plan-review-and-finalise.md`](../01-planning-and-organizing/03-plan-review-and-finalise.md) in full against the supplied plan:
   - Review via [`../01-planning-and-organizing/01-plan-review.md`](../01-planning-and-organizing/01-plan-review.md), then finalise via [`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md).
   - Verify the finalised implementation plan satisfies the acceptance criteria in [`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md) before continuing.

2. **Stage and commit the planning artifacts** – Before any implementation work begins:
   - Run git commands from the **host repository root** (the project the plan belongs to), not from `Workflow-Scripts/`.
   - Stage the finalised plan and any related planning artifacts (review feedback, changelog entries) with `git add`.
   - Commit with a conventional prefix and imperative subject line (e.g. `docs: finalise implementation plan for <feature>`), per the host repo's commit conventions.
   - Do **not** push unless the user explicitly asks.
   - If the working tree has no changes after finalisation, note this and continue — do not create an empty commit.

3. **Execute and confirm** – Execute [`03-execute-and-confirm.md`](./03-execute-and-confirm.md) in full on the finalised plan:
   - Implementation via [`01-execution.md`](./01-execution.md), confirmation via [`02-confirm-execution.md`](./02-confirm-execution.md).
   - Resolve the terminal outcome and always run the terminal gate [`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md): `Verified Complete` → **Full completion** (it files the completed package per the plan's `## Artifact lifecycle` inventory and applies the marker only after filing verifies); `Not Eligible` → **Reconcile only** (reconcile verified task ticks and logs, leave the plan active, and apply no completion marker or archive).
   - Record the gate's reported actual final path and its two status lines (`Implementation verification`, `Package filing`) in the report. A pending, blocked, or partial filing is reported as such — never as completion.
   - This step adds no commit behavior: the planning checkpoint in step 2 is the only commit in this workflow, and it stays a user-selected boundary; do not commit or push at close unless separately authorized.
   - Finish with the final check in `03-execute-and-confirm.md` step 4: `check-plan.sh --require-tier --state` on the plan's actual path prints `OK`.

## Output

- Review feedback and a finalised implementation plan produced per [`../01-planning-and-organizing/03-plan-review-and-finalise.md`](../01-planning-and-organizing/03-plan-review-and-finalise.md).
- A commit containing the staged planning artifacts, created before execution began.
- Everything produced by [`03-execute-and-confirm.md`](./03-execute-and-confirm.md): implemented code, updated logs, verification addendum, a resolved terminal outcome, and the gate's reported final path with its filing status.

## Quick Checklist

- [ ] Plan supplied and reviewed; finalisation acceptance criteria met
- [ ] Finalised plan and planning artifacts staged and committed in the host repo (conventional commit message; no push unless requested)
- [ ] [`03-execute-and-confirm.md`](./03-execute-and-confirm.md) run in full on the finalised plan
- [ ] Terminal gate always run: `Verified Complete` → **Full completion**; `Not Eligible` → **Reconcile only** (plan stays active, no marker/archive)

## Notes

- The commit in step 2 is a **checkpoint boundary**: it separates planning changes from implementation changes so each phase can be reverted or reviewed independently. Do not mix implementation edits into it.
- If review or finalisation fails or the plan is rejected, stop before step 2 — there is nothing to commit or execute.
- If the host repository has its own commit workflow documentation (e.g. `content/agents/commit-workflow.md`), follow it for message format and staging scope.
- Do not duplicate review, finalisation, or execution rules in this file; defer to the linked workflows as the source of truth.

## Related Workflows

- [`../01-planning-and-organizing/03-plan-review-and-finalise.md`](../01-planning-and-organizing/03-plan-review-and-finalise.md) - Step 1 (review + finalise only)
- [`03-execute-and-confirm.md`](./03-execute-and-confirm.md) - Steps 2–3 without the upstream review/finalise phases
- [`../01-planning-and-organizing/00-research-and-plan.md`](../01-planning-and-organizing/00-research-and-plan.md) - Use first if no plan exists yet
- [`../05-review/01-code-review.md`](../05-review/01-code-review.md) - Code review after implementation
