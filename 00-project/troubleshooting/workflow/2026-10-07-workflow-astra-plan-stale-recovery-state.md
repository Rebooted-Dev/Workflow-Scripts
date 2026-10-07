# Plan 05's protocol-recovery gate and instruction snapshot were stale

**Date:** 2026-10-07
**Category:** workflow
**Status:** RESOLVED for plan documentation; evaluation remains blocked on an explicit arm decision

---

## Symptom

Active Plan 05 still treated protocol recovery and its old source path as future work, and used dated setup/recommendation material as though it described the current instruction stack. It also phrased the completed planning/build implementation as ongoing work.

## Root Cause

Plan 05 had not been reconciled after Plan 01 recovered and filed the protocol on `9714c15`, repaired active references, and was archived Verified Complete. Subsequent setup, skills, planning/build, and plan-marking sources changed, while the September 22 audit and September 23 recommendation report remained historical snapshots.

## Fix

- Refreshed Plan 05 as a T3 plan with the completed protocol-recovery evidence and current source references. The provenance record documents a one-line Status-link/path adjustment from the historical protocol; it does not claim byte identity.
- Replaced the stale current-stack description with the implemented `PROJECT.md`/AGENTS/harness/import and topical-guidance/skills inventory, requiring actual per-runtime load evidence.
- Kept the September 22 audit dated as historical and the September 23 recommendations as proposals, not experiment results. No evaluation arm was selected and no protocol, research source, instruction, fixture, or runtime was changed.
- Cross-linked the [Plan 05 changelog entry](../../changelog/docs/2026-10-07-docs-refresh-astra-evaluation-plan.md).

## Verification

- Parent reports that `check-plan.sh --require-tier` and `check-plan.sh --state` passed and the plan was reviewed.
- Local `check-active-markdown-links.sh --root . --scope 00-project/plans/v1.82-fixes` passed after the plan refresh; links for this entry and its changelog cross-reference are included in the current scoped check.
- No model run, runtime/access probe, or budget check was performed. No performance result is claimed.

## Notes / Lessons

- A recovered protocol and its active links are completed evidence; they do not select an arm or authorize evaluation. Plan 05 remains blocked on the written arm decision. Runtime identity/access and budget have not been evidenced.
- Keep historical audits/recommendations dated and distinguish documentation state from observed runtime behavior. This was a historical-plan reconciliation, not a runtime or model fault.
