# Setup docs describe the CLAUDE.md symlink layout

**Date:** 2026-10-13
**Type:** changed

---

## Summary
- `01-setup-project.md` (Steps 1.1, 1.2, 2.10, 3.6, 3.6.1, 3.7.1 and the checklists) now describes `CLAUDE.md` as a symlink to `AGENTS.md`. Claude-only instructions go in `.claude/rules/claude-code.md`. `GEMINI.md` keeps the `@AGENTS.md` / `@PROJECT.md` import form. Step 1.2's `AGENTS.md` template gains an `@PROJECT.md` line.
- Step 3.6.1 runs `scripts/validation/check-agent-rules-load.sh` from a subfolder instead of a root-only quote test.
- The same wording change in `04-track-repos-and-agent-map.md`, `07-migrate-project-structure.md`, `08-kaparthy-template.md`, `03-debugging/02-bug-fix-workflow.md`, the setup README, and the skills folder (`02-project-scan.md`, `03-project-scaffold.md`, `README.md`, and the Agent skills stub). The earlier list of six files was incomplete.
- `skills/03-project-scaffold.md` notes that the external `/setup-matt-pocock-skills` skill may still target `CLAUDE.md`. That skill is outside this repository and was not changed.
- The research report records the implementation in section 12.

**Troubleshooting:** [2026-10-13 entry](../../troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md)
