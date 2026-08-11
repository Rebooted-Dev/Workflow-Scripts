# Enforce single terminal-gate owner in completion chain
**Date:** 2026-08-11
**Type:** changed

---

## Summary
- Made `04-documentation/03-mark-completed.md` the sole positive terminal owner (terminal `✅` marks, completion marker, archive). `01-execution` and `02-confirm-execution` now report verification and may downgrade false claims but never finalize or archive.
- Added a mandatory `01 → 02 → gate` handoff in `03-execute-and-confirm` with explicit `Verified Complete` / `Not Eligible` outcomes (no "optional/when appropriate" bypass); aligned the `execute-and-confirm-plan` skill to route through the gate.
- Replaced generic hardcoded archive paths in the code-build chain with host-policy archive routing resolved inside the gate (fails closed on unresolved policy), plus deterministic active-plan discovery (named target first; `plans/**`+`build/**`; never scan archives).
- Repaired navigation (code-build sequence diagram, root Quick Start, root file tree, documentation README) to reference the terminal gate.
- Added `scripts/validation/check-completion-chain-policy.sh` and registered it in `scripts/README.md`.

## Scope
- Branch `v1.72` (from `v1.71`), commit `ea76fb5`.
- Files: `02-code-build/{01,02,03}-*.md`, `02-code-build/README.md`, `04-documentation/03-mark-completed.md`, `04-documentation/README.md`, `11-Skills/execute-and-confirm-plan/SKILL.md`, `README.md`, `scripts/README.md`, `scripts/validation/check-completion-chain-policy.sh` (new).

## Verification
- `check-completion-chain-policy.sh` PASS; `check-active-markdown-links.sh` PASS; `check-review-workflow-policy.sh` PASS (sibling regression).
- Negative checks: reintroducing a hardcoded archive path and removing the `Verified Complete` token each fail the validator with the correct diagnostic.
- All six manual policy scenarios pass (recorded in the plan's verification addendum).

## Related
- Plan: `../plans-completed/implementation/2026-08-08-workflow-completion-chain-remediation.md` (Type=`plan`)
- Research: `../../research/2026-08-08-workflow-completion-chain-remediation.md`
