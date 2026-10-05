# Plans without checkboxes, and completed work left unticked

**Date:** 2026-10-05
**Category:** workflow
**Status:** resolved

## Symptom
Plans did not always have checkboxes, and executing a plan did not always leave green check marks against finished work. The owner had to ask for another scan to get the plan updated. Seen in Update-AI-Tools after the 2026-09-25 fix: plans archived with no checkboxes, plans ticked with `[x]`, every executed plan with open Success Criteria, and two plans archived as `CLOSED` with 12 and 6 open tasks.

## Root Cause
The 2026-09-25 fix settled *who may tick*. It added no check on the result, and it left several ways for a plan to avoid checkboxes entirely:
1. `check-plan.sh` is opt-in through the `**Tier:**` header. A plan without one exits 0 as "legacy", so it needs no checkboxes.
2. The planning workflows never ran the linter. `02-finalise-plan.md` said to "reference" it; it first ran at execution.
3. The linter accepted `[x]` while every workflow required `[✅]`.
4. `## Success Criteria` boxes were declared "criteria, not tasks", and no workflow ticked them.
5. The last step of the chain was "re-read the plan's task list". No command checked tick state.
6. An intentionally open box (retired, deferred, blocked) looked the same as a forgotten one.
7. `02-confirm-execution.md` told the agent to add an addendum when a plan had no task-list syntax, and "file … as completed" moved a plan without running the gate. Plans from other tools (Cursor `.plan.md` with YAML `todos:`) were archived as they came.
8. The tick rule lived only in the workflow files. A host `AGENTS.md` that says to follow a workflow "only when it was selected" loaded no tick rule for a plain "execute the plan".
9. `glossary.md` ("may mark") and `README.md` ("sole ✅ owner") still stated the rule the earlier fix removed.

## Fix
- One Marking Contract in `plan-template.md`; other documents link to it.
- `check-plan.sh`: canonical-tick rule, `--require-tier`, `--state`.
- Required run steps: `--require-tier` at authoring, review, finalise, and execution intake; `--state` at each phase report, confirmation, the combined workflows' final check, and the gate.
- Additive conversion for plans without checkboxes.
- Always-on **Plans** rule in the setup template's `AGENTS.md` block; reconcile step before filing.
- Regression guards in `check-completion-chain-policy.sh` section 9 and the pre-commit hook.

## Verification
- `bash scripts/validation/check-plan-selftest.sh` → OK, with nine new fixtures.
- `bash scripts/validation/check-completion-chain-policy.sh` → OK on the fixed tree; fails on a `git archive HEAD` copy of the pre-fix tree with `plan-template.md lacks the Marking Contract section`.
- `check-plan.sh --state` on a copy of the archived Update-AI-Tools v3 reliability plan reports exactly its 12 open tasks and 6 open criteria.
- Pre-commit hook in a scratch clone refuses a tiered archived plan with a silent open task.
- `check-active-markdown-links.sh`: one failure that predates this fix, none added.

## Notes / Lessons
- A rule that says who must do something needs a command that fails when it was not done. Two rounds of wording changes did not stop the omission.
- An opt-in linter also needs a strict mode at the points where new documents are created, or new documents take the lenient path.
- Give "not done" a required reason. Without one, a deliberate open box and a forgotten one are indistinguishable, and only a rescan can tell them apart.
- `--state` proves a box is ticked or explained. It does not prove a tick is true.
