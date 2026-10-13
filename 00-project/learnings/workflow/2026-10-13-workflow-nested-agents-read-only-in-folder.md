# Rules for the whole repo go in the root AGENTS.md

**Date:** 2026-10-13
**Category:** workflow
**Status:** NOTED
**Source:** command: grep of the import chain in the CLAUDE.md files

---

## Situation
- I put the agent learnings rule in `00-project/AGENTS.md`. Root `CLAUDE.md` imports only the root `AGENTS.md`, so most changes never loaded the rule.

## Pattern to avoid
- A nested AGENTS.md as the only home for a rule that applies to every change.

## Better approach
- Put a repo-wide rule in the root `AGENTS.md`. A nested file keeps a one-line pointer.

## Verification
- Checked the import chain: only the root `CLAUDE.md` and the setup doc import an AGENTS.md. The fix is logged in `changelog/fixed/` and `troubleshooting/workflow/` (2026-10-13).

## Notes
- Same class as the 2026-10-05 tick-rule entry: `../../troubleshooting/workflow/2026-10-05-workflow-plans-without-checkboxes-or-ticks.md`.
