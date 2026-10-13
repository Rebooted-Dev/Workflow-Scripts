# An @ import outside the working directory needs approval, so it fails from a subfolder

**Date:** 2026-10-13
**Category:** facts
**Status:** ACTIVE
**Source:** developer message: "go with your recommendations, proceed with implementaiton of" the agent learnings report (goal set 2026-10-13)
**Approved:** 2026-10-13

---

## Situation
- A root `CLAUDE.md` that contains `@AGENTS.md` loaded the rules in a session started at the repo root. It did not load them in a session started in a subfolder, or in a host project that added the repo with `--add-dir`.

## Pattern to avoid
- Delivering agent rules to Claude Code through an `@` import, or through a symlink in `.claude/rules/`.

## Better approach
- Put rules in the file Claude Code loads, or make `CLAUDE.md` a symlink to `AGENTS.md`. Use an `@` import only for a file whose absence a session can tolerate.

## Verification
- Claude Code memory documentation (`https://code.claude.com/docs/en/memory`): an import is external when its path resolves outside the working directory, and external imports need a one-time approval dialog.
- Canary tests in throwaway git repos, headless, Claude Code 2.1.296: the import layout returned the canary from the root and `NONE` from `sub/deep/`; the symlink layout returned the canary from `sub/deep/` and with `--add-dir`. Not yet run in the real repos.

## Notes
- Full results: section 11 of `research/2026-10-13-agent-learnings-load-and-accuracy-report.md`.
- Related: `workflow/2026-10-13-workflow-start-sessions-at-repo-root.md`, which stays ACTIVE until the symlink fix is applied.
