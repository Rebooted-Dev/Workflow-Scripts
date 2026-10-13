# Edit and Write refuse to write through a symlink
**Date:** 2026-10-13
**Category:** tooling
**Status:** NOTED
**Source:** command: Edit on a scratch CLAUDE.md that was a symlink to AGENTS.md; the tool refused and named the target path

---

## Situation
- CLAUDE.md is a symlink to AGENTS.md, so the agent rules load from any folder.

## Pattern to avoid
- Editing CLAUDE.md with Edit or Write. The tool refuses: "it is a symbolic link. Write to the link's target path instead."

## Better approach
- Edit AGENTS.md, the link target. Reading CLAUDE.md still shows the shared rules.

## Verification
- Scratch pair in the session scratchpad: AGENTS.md and CLAUDE.md -> AGENTS.md. Read of CLAUDE.md worked; Edit on CLAUDE.md was refused and named the AGENTS.md path.

## Notes
- Troubleshooting: `troubleshooting/workflow/2026-10-13-workflow-rules-not-loaded-from-subfolder.md`.
