# Grep the whole repo for a rule's wording before listing the files to change
**Date:** 2026-10-13
**Category:** workflow
**Status:** NOTED
**Source:** command: grep for @AGENTS.md and CLAUDE.md across Workflow-Scripts found about 15 files; the proposal listed six

---

## Situation
- The proposal for the import change listed six files to update. A grep for the import wording found about 15, including 01-setup-project.md, 04-track-repos, 07-migrate, and the skills folder.

## Pattern to avoid
- Taking the file list from a proposal or report as complete.

## Better approach
- Grep the whole repo for the old wording before editing, and update every hit that describes the changed behaviour. Leave hits that describe other harnesses, such as GEMINI.md, when the change does not apply to them.

## Verification
- Grep with `grep -rln -e "@AGENTS.md" -e "CLAUDE.md" .`, excluding .git and the logs. The updates were made to every Claude-specific hit.

## Notes
- Report: `research/2026-10-13-agent-learnings-load-and-accuracy-report.md`, section 11.4.
