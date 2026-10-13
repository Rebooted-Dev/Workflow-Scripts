# Start agent sessions at the repository root

**Date:** 2026-10-13
**Category:** workflow
**Status:** SUPERSEDED
**Source:** command: headless claude -p in 00-project-setup/ and docs/agents/ did not quote the section

---

## Situation
- Headless test sessions did not load the AGENTS.md rules when they started in a subfolder. Sessions started at the Workflow-Scripts root and the NuBible-App root quoted the Agent Learnings section.

## Pattern to avoid
- Starting an agent session in a subfolder and assuming the root rules are loaded.

## Better approach
- Start agent sessions at the repository root. Run the 01 Step 3.6.1 check from the root.

## Verification
- Headless sessions at `00-project-setup/` (Workflow-Scripts) and `docs/agents/` (NuBible-App) did not quote the section. An explicit `@../../AGENTS.md` import and `--add-dir` did not change this in a sandbox replica. Interactive sessions were not tested.

## Notes
- Superseded by facts/2026-10-13-facts-imports-outside-cwd-need-approval.md (CLAUDE.md is now a symlink to AGENTS.md).
- Cause not established. See `troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md`.
