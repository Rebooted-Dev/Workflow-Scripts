# Docs: refresh v1.82-fixes plan set against current workflow instructions

**Date:** 2026-10-06
**Type:** docs
**Scope:** `00-project/plans/v1.82-fixes/` (all five documents)

## What changed

Reconcile-only refresh of the v1.82-fixes plan set against the current Workflow-Scripts instructions. No lane status, gate, authorization, or tick changed.

- **Roadmap:** added a 2026-10-06 cross-reference for the adopted plan-artifact completion filing lifecycle — lanes archived after adoption file through the canonical terminal gate (`04-documentation/03-mark-completed.md`, Full completion mode) with a proportional artifact inventory; the plan set keeps its legacy tier-less structure under the template's legacy-plan leniency. P3 closeout task 1 now names that gate for future lane filing.
- **Plan 03:** the 2026-09-25 cross-reference now records that the planning/build quality plan was archived Verified Complete on 2026-09-27 and its behavioral-evidence deferred item is tracked in `plans/TODO.md` ("Quality-plan Deferred & Debt"); trigger unchanged.
- **Plan 04:** added the 2026-10-04 curated skills stack (`00-project-setup/skills/`, `01-setup-project.md` Step 2.12) as reference context for the target/inheritance inventory and the conditional Visualize-rule decision; explicitly changes no approval gate or rollout boundary.
- **Plan 05:** updated the `01-setup-project.md` reference description for the bounded sub-agent Step 1.2 template (2026-10-03) and the Step 2.12 agent-skills stack (2026-10-04), both inside the effective stack P1 task 2 freezes.
- **Plan 06:** relabeled `11-Skills/README.md` as a held-bundles tombstone (bundles moved out 2026-08-18), described `06-skills-setup.md` as the discovery catalog behind the setup front door, and recorded the 2026-10-04 Workflow-Scripts-only skills-stack adoption as reactivation reassessment context; the 2026-09-22 KIV user decision stands unchanged.

## Why

Supersession audit: the set was last reconciled on 2026-09-27 (`856cfb1`); commits `213conde` (sub-agent bounds), `2cd0a55` (skills stack + setup front door), `28be480` (tick consistency), and the 2026-10-06 artifact-filing adoption changed referenced workflow content without updating these plan documents. `11-Skills/README.md` had also become a hold tombstone while Plan 06 still called it the "current skill inventory entry point".

## Verification

- `check-plan.sh --state` passes on all five plans (legacy tier warnings only, exit 0).
- `check-active-markdown-links.sh --root . --scope 00-project/plans/v1.82-fixes` — OK.
