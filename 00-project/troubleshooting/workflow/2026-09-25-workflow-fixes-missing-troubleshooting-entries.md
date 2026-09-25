# Workflow fixes logged without troubleshooting entries, or in the wrong repo

**Date:** 2026-09-25
**Category:** workflow
**Status:** resolved

## Symptom
- Of 27 `00-project/changelog/fixed/` entries, 22 have no troubleshooting entry. The host project Flash-UI-Idea-Generator is at 46 of 48, so the gap is specific to Workflow-Scripts' own logs.
- Agents working from a host project that edited the Workflow-Scripts clone sometimes logged those changes in the host's `project/`, because nothing in the host's instructions said otherwise.
- `check-meta-logs.sh --range HEAD~80..HEAD~12` reports 88 problems in older history, including unlogged commits such as `ea76fb5`.

## Root Cause
1. **Classification loophole.** `00-project/AGENTS.md` said to use the changelog only "for simple doc or workflow updates". In a repo whose product is workflow docs, almost every fix is a doc or workflow update, so troubleshooting was effectively optional.
2. **Escape hatches in the fix workflows.**
   - `03-debugging/02-bug-fix-workflow.md` and `06-security/02-security-fix.md` limited logging to "completed tasks that change or affect project code", which excludes prompt, config, and Markdown fixes.
   - The bug-fix workflow let agents skip troubleshooting for undefined "truly trivial" fixes.
   - The `workflow-bug-fix-plan-and-logs` skill asked for troubleshooting only for "non-trivial bugs".
   - Nothing checked the logs before a fix was reported as done.
3. **Wrong-repo routing.** Metadata-root resolution chose `00-project/` only "if the repository is Workflow-Scripts itself". From a host project session, "the repository" was the host. Workflow-Scripts had no root `AGENTS.md`/`CLAUDE.md`, and `00-project/AGENTS.md` only applies inside `00-project/`, so agents editing workflow files never saw the rule.
4. **No enforcement.** No validator or hook checked that logs existed. CI does not run on the active `v1.8x` lines (triggers are `main` and `v1.8` only).

## Fix
- Metadata-root resolution now starts from the repository that **owns the changed files** (`00-Meta-Workflow/00-meta/naming-conventions.md`).
- Added a root `AGENTS.md` and a `CLAUDE.md` (which imports it) so the rule loads whenever files in this repo are edited, from any host.
- The host `PROJECT.md` template (`00-project-setup/01-setup-project.md` §1.4) and Flash-UI's `PROJECT.md` now say Workflow-Scripts changes are logged in its `00-project/`.
- `00-project/AGENTS.md` and `docs/agents/changelog-and-troubleshooting.md` now treat workflow defects as bugs, require a troubleshooting entry for every `fixed/` entry, and allow a waiver only as a recorded `**Troubleshooting:** not needed — <reason>` line.
- The bug-fix workflow, the security-fix workflow, and the skill now require both logs for every fix, in the owning repo's `<metadata-root>`, with a blocking log gate before reporting done. `01-execution.md` names the owning repo too.
- Enforcement:
  - New `scripts/validation/check-meta-logs.sh` (`--staged` / `--range`).
  - Self-test `check-meta-logs-selftest.sh` (9 cases).
  - Pre-commit hook `scripts/hooks/pre-commit`.
  - Three new CI steps (checkout now uses `fetch-depth: 0`).

## Verification
- `bash scripts/validation/check-meta-logs-selftest.sh` → OK on macOS `/bin/bash` 3.2.57.
- `bash scripts/validation/check-meta-logs.sh --range HEAD~12..HEAD` → OK (recent history is compliant). The older range reports the historical gaps, so CI checks only new commits.
- `check-completion-chain-policy.sh` → OK; `validation.yml` parses as YAML.

## Notes / Lessons
- "Only when non-trivial" rules drift toward "never" when the agent is also the judge. Make the default mandatory and require a written reason to skip.
- Rules scoped to a subdirectory (`00-project/AGENTS.md`) do not reach agents editing sibling directories. Put repo-wide rules at the repo root.
- The 22 historical gaps were not backfilled; most are wording fixes from January to May 2026.
- CI still does not trigger on the `v1.8x` lines. Local enforcement depends on `git config core.hooksPath scripts/hooks` in each clone.
