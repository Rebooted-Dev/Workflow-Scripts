# Check a template's commands and rules against the project before adopting it
**Date:** 2026-10-13
**Category:** workflow
**Status:** NOTED
**Source:** command: grep of NuBible docs/agents for the cargo, Flutter, and secrets rules

---

## Situation
- The learnings patch's AGENTS.md used pnpm commands and repeated the secrets and testing rules. NuBible uses cargo and Flutter, and those rules already live in docs/agents/.

## Pattern to avoid
- Pasting a template's AGENTS.md into a project as a whole.

## Better approach
- Keep only the new behaviour, and point to the existing docs for everything else. Delete placeholder entries before migrating.

## Verification
- Grepped NuBible docs/agents for the cargo and Flutter commands and the secrets rule. The verdict table in the proposal records each part.

## Notes
- 00-project/plans/agents-patches/agent-learnings-proposal.md, section 2.
