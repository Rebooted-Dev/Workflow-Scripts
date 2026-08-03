# Strengthen 02-code-build Verification Bar

**Date:** 2026-08-03

**Type:** improved

---

## Summary

- Raised the shared **Verification Bar** across `02-code-build/` so agents cannot treat "code written" or a single build pass as done.
- Made automated tests (when present) and acceptance/smoke for user-facing or runtime changes first-class requirements; **skipped or blocked checks are unresolved evidence, not success**.
- Aligned the `execute-and-confirm-plan` skill with the same bar.

## Files

- `02-code-build/01-execution.md` — Verification Bar section; phase exit criteria must include how success is verified; stronger verify loop and checklists
- `02-code-build/02-confirm-execution.md` — audit table; re-run/confirm tests and smoke; addendum must list commands, smoke, residual risk
- `02-code-build/03-execute-and-confirm.md` — Completion Bar; checklist ties 01+02 to full verification before archive
- `02-code-build/README.md` — shared Verification Bar table; fixed mark-completed source-of-truth link
- `11-Skills/execute-and-confirm-plan/SKILL.md` — verify steps and completion bar aligned
