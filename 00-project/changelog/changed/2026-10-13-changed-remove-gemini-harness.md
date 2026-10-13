# Remove GEMINI.md and the Gemini CLI from the agent harness docs

**Date:** 2026-10-13
**Type:** changed

---

## Summary
- The Gemini CLI is no longer used, so `GEMINI.md` is no longer a harness file. The setup docs (01, 04, 07, the setup README, the skills folder, and the proj-organisation doc) no longer describe it. `CLAUDE.md` is the only harness file: a symlink to `AGENTS.md`.
- The skills-setup doc (06) no longer lists Gemini CLI install paths, its manifest example, or its agent list. Gemini API reference material is unchanged.
- Setup-doc Step 2.10 now has `2.10.1` (CLAUDE.md) and `2.10.2` (migration); the GEMINI template section is removed.
- The external `/setup-matt-pocock-skills` skill, outside this repository, now writes its `## Agent skills` block to `.claude/rules/claude-code.md` when `CLAUDE.md` is a symlink, so the block cannot land in the shared `AGENTS.md`.
- NuBible-App: `GEMINI.md` deleted in its own changelog entry.

**Historical records** (changelog, troubleshooting, research, plans) still mention GEMINI.md where they describe what was true at the time.

**Troubleshooting:** [2026-10-13 entry](../../troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md)
