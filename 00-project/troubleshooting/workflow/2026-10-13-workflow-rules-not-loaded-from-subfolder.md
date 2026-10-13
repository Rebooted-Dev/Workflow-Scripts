# Rules did not load from a subfolder session; learnings entries could state unsupported claims

**Date:** 2026-10-13
**Category:** workflow
**Status:** resolved; interactive check open

## Symptom
- In headless test sessions, the AGENTS.md rules did not load when the session started in a subfolder (`00-project-setup/` in Workflow-Scripts, `docs/agents/` in NuBible-App). Sessions started at a repo root loaded them.
- A correction entry written in a sandbox replica of the learnings layout said the developer had confirmed something, and that the agent had failed to follow a rule. The prompt contained neither.

## Root Cause
- Subfolder case: Claude Code treats an `@` import whose target is outside the session's working directory as an external import. It loads only after a one-time approval dialog, which a headless session never shows. From a subfolder, the root `AGENTS.md` is outside the working directory, so the import is skipped without a message. Established on 2026-10-13 from the Claude Code memory documentation and canary tests; see section 11 of `research/2026-10-13-agent-learnings-load-and-accuracy-report.md`.
- For the content case: the learnings README template had no rule against unsupported claims, and the checker tests format only.
- Earlier, the Agent Learnings rule sat only in the nested `00-project/AGENTS.md`. That gap was fixed separately (`changelog/fixed/2026-10-13-fixed-agent-learnings-rule-in-root-agents.md`).

## Fix
- The root `CLAUDE.md` is a symlink to `AGENTS.md` instead of an `@AGENTS.md` import. A file inside the working directory needs no approval. The subfolder case is fixed in Workflow-Scripts; the NuBible-App change is recorded in its own logs.
- Added 01 Step 3.6.1 (headless check that the rules load), now pointing to `scripts/validation/check-agent-rules-load.sh`, which runs the canary test from a subfolder.
- Added an **Accuracy** section to the learnings README template in `11-agent-learnings.md` and to both learnings READMEs. Entries now need a `**Source:**` line; an `ACTIVE` entry needs a `**Approved:**` date.
- `scripts/validation/check-learnings.sh` checks the Source and Approved fields; its selftest has 11 cases. The pre-commit hook runs the checker when a staged path is under `00-project/learnings/`.

## Verification
- Before the change, a headless session started in `00-project-setup/` reported `NONE` for the rules. After the change, the same check quoted the Agent Learnings section, from `CLAUDE.md`.
- `check-agent-rules-load.sh` passes on the Workflow-Scripts layout. Run against the old import layout, it fails (the symlink check and the canary check both report it).
- `check-learnings-selftest.sh` passes (11 cases). `check-learnings.sh` passes on the Workflow-Scripts log (22 rows, 22 entries).

## Notes / Lessons
- Open: an interactive check at a subfolder (developer). The headless canary is the automated check.
- The checker cannot judge whether an entry's claims are true. Only the developer's approval (`**Approved:**`) makes an entry ACTIVE.
- `/setup-matt-pocock-skills` (outside this repo) writes its `## Agent skills` block to `CLAUDE.md` when that file exists. With the symlink, the block would land in the shared `AGENTS.md`. The docs now place the Claude-only block in `.claude/rules/claude-code.md`. The external skill was changed on 2026-10-13 to write there when `CLAUDE.md` is a symlink (outside this repository, so it is not in git).
