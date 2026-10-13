# Agent learnings rule was only in a nested AGENTS.md

**Date:** 2026-10-13
**Category:** workflow
**Status:** resolved

## Symptom
The agent learnings rule (read the index before non-trivial work; log mistakes and corrections) was written only into `00-project/AGENTS.md`. Nothing failed. The gap was found by checking which files load the rule.

## Root Cause
- Root `CLAUDE.md` imports only the root `AGENTS.md`. No other file imports `00-project/AGENTS.md`; the root file only links to it.
- So changes to the workflow docs (for example under `00-project-setup/`) never loaded the rule. A nested `AGENTS.md` is read only for work inside its folder.
- Same class as `troubleshooting/workflow/2026-10-05-workflow-plans-without-checkboxes-or-ticks.md` (item 8): a rule that lived only in workflow files, not in the always-loaded AGENTS.md.

## Fix
- Moved the **Agent Learnings** section to the root `AGENTS.md`, which applies to every Workflow-Scripts change.
- `00-project/AGENTS.md` keeps a one-line pointer to the root section and the `00-project/learnings/` log, so there is one source of truth.
- Logged in `changelog/fixed/2026-10-13-fixed-agent-learnings-rule-in-root-agents.md`.

## Verification
- `grep` for `@…AGENTS.md` imports finds only the root `CLAUDE.md` and `00-project-setup/01-setup-project.md`; the root `CLAUDE.md` is `@AGENTS.md`.
- The root `AGENTS.md` now contains the `## Agent Learnings` section, and the anchor `#agent-learnings` resolves.

## Notes / Lessons
- A rule that applies to every change belongs in the root `AGENTS.md`. Nested files keep pointers only.
- Consumer projects already get this placement from `01-setup-project.md` Step 1.2; Workflow-Scripts had drifted from it.
