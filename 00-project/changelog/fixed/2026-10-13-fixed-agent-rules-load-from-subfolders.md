# Agent rules load from subfolder sessions; learnings entries need a source and approval

**Date:** 2026-10-13
**Type:** fixed

---

## Summary
- `CLAUDE.md` is now a symlink to `AGENTS.md`, not an `@AGENTS.md` import. The import was treated as external from a subfolder and dropped silently; a symlink loads from any folder. Verified: the session started in `00-project-setup/` quotes the Agent Learnings section after the change, where it reported none before.
- Claude-only instructions for Claude Code belong in `.claude/rules/claude-code.md` (setup docs updated; NuBible-App adopts it in its own logs).
- Learnings entries now need a `**Source:**` line, and an `ACTIVE` entry needs a verified source and a developer `**Approved:**` date. Agents write new entries as `NOTED`. The checker enforces both fields, and the pre-commit hook runs it when learnings files are staged.
- Added `scripts/validation/check-agent-rules-load.sh`, a canary check that runs a headless session from a subfolder. It copies the repo's real `CLAUDE.md`, so an old import layout fails.
- The setup docs (01, 04, 07, 08, the skills folder, and the setup README) now describe the symlink layout for Claude. `GEMINI.md` keeps the import form; it was not tested.
- Of the 18 ACTIVE entries, 15 are now NOTED because no developer approval is recorded for them, and `start-sessions-at-repo-root` is SUPERSEDED. Two stay ACTIVE: the imports entry (approved in the goal that started this change) and the log-only entry (the developer accepted the accuracy rule, per report section 6.2).

**Troubleshooting:** [2026-10-13 entry](../../troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md)
**Research:** [agent learnings load and accuracy report](../../research/2026-10-13-agent-learnings-load-and-accuracy-report.md), sections 11.4 and 11.5
