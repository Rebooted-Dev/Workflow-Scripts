# Agent learnings rule moved to the root AGENTS.md

**Date:** 2026-10-13
**Type:** fixed

---

## Summary
- The **Agent Learnings** section was only in `00-project/AGENTS.md`, which loads for meta work alone. Root `CLAUDE.md` imports only the root `AGENTS.md`, so changes to the workflow docs never loaded the rule.
- Moved the section to the root `AGENTS.md`, before **Logging changes to this repository**.
- `00-project/AGENTS.md` now holds a one-line pointer to the root section and to `00-project/learnings/`.

**Troubleshooting:** [2026-10-13 entry](../../troubleshooting/workflow/2026-10-13-workflow-learnings-rule-only-in-nested-agents.md)
