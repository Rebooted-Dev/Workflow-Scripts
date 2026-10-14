# Consumer Project Health Check

**Status:** Active

## Purpose and scope

`scripts/validation/health-check.sh` checks a bounded subset of the consumer-project setup requirements that can be verified mechanically. A PASS is not certification that every interactive, content-based, or user-level setup step is complete. Continue the manual checks in [01-setup-project.md, Step 3](./01-setup-project.md#step-3-verification), especially project/plans/docs layout, user-level Claude Code cache status, backups, migrations, and interactive-session checks.

The first version is Bash/macOS-oriented and applies to consumer projects only. It refuses to run on the Workflow-Scripts root.

## Command

From the consumer project root:

```bash
bash <WORKFLOWS_DIR>/scripts/validation/health-check.sh <PROJECT_PATH>
```

- No flags: read-only H01–H11 and H13–H14 checks. H12 is reported as not run.
- `--repair`: after the initial report, offers each allowed operation separately. The preview names the check, exact target, safely quoted command-equivalent, and exact backup path. Each operation requires its own `y/N` answer; the default is no. The command-equivalent is displayed only; the tool applies fixed operations and never evaluates project-provided shell text.
- `--canary`: also runs the subfolder rules-load canary after repairs. It is the only option that can make a headless Claude model/network call. If H04/H05 preconditions fail, H12 is FAIL and the model is not called.
- Flags follow the project path. Duplicate or unknown flags are usage errors.

For example, opt in to the canary explicitly:

```bash
bash <WORKFLOWS_DIR>/scripts/validation/health-check.sh <PROJECT_PATH> --canary
```

## Output and exit codes

Each check reports `PASS`, `WARN`, or `FAIL`. H12 reports `SKIP` when `--canary` is absent.

```text
PASS  H05  CLAUDE.md is a symlink to AGENTS.md
WARN  H11  check-learnings.sh reports a structural/content issue: ...
SKIP  H12  not run (pass --canary to make the opt-in model call)
summary: 12 PASS, 1 WARN, 0 FAIL (13 checks); H12 not run
```

| Exit | Meaning |
|---|---|
| `0` | No FAIL findings; WARN and a skipped H12 are allowed |
| `1` | At least one FAIL finding |
| `2` | Invalid usage or rejected/non-consumer target |

If the Claude CLI, login, credits, or model service prevents a meaningful canary result, H12 is WARN/inconclusive and does not change the layout exit result to `1`. A deterministic failed layout precondition or a canary token not observed is FAIL.

## Check catalog

| ID | Area | Check | Default severity | Mechanical repair |
|---|---|---|---|---|
| H01 | Repos | `PROJECT.md` contains a `## Repositories` table | FAIL | None; content is manual |
| H02 | Repos | Exactly one Workflow-Scripts row exists; its safe relative path is its own Git root (`git -C <path> rev-parse --show-prefix` is empty and the resolved top-level path matches) | FAIL | None |
| H03 | Git | A rule in the consumer root `.gitignore` ignores the Workflow-Scripts path, including an ignored symlink parent; global excludes alone do not satisfy the check | FAIL | Append the root-relative path and setup comment; create `.gitignore` only if absent |
| H04 | Agent files | `AGENTS.md` exists and points to `PROJECT.md` | FAIL | None; content is manual |
| H05 | Agent files | `CLAUDE.md` is a symlink whose link text is exactly `AGENTS.md` | FAIL | Create if absent; replace a regular file only when every nonblank line is exactly `@AGENTS.md` or `@PROJECT.md` |
| H06 | Agent files | `AGENTS.md` has an `@PROJECT.md` import | WARN | Insert only after the unique “Read `PROJECT.md` before starting work” anchor |
| H07 | Agent files | If a regular root `CLAUDE.md` has `## Claude-Specific Instructions` or `## Agent skills`, `.claude/rules/claude-code.md` exists | WARN | None; migrate content manually |
| H08 | Agent files | `AGENTS.md` is at most 40 lines | WARN | None; content is manual |
| H09 | Learnings | `project/learnings/` has README, index, and `workflow/`, `code/`, `tooling/`, `facts/`, `communication/` | FAIL | Create missing directories and an absent/missing-header index; preserve rows; missing README or malformed header is manual |
| H10 | Logs | Changelog has README/index and `added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/`, `plans/`; troubleshooting has README/index and `build/`, `runtime/`, `data/`, `environment/`, `security/`; both indexes have their canonical header | WARN | Create missing directories and absent/missing-header indexes; preserve rows; missing README or malformed header is manual |
| H11 | Learnings | `check-learnings.sh <PROJECT_PATH>/project/learnings` passes | WARN | None; entry content is the developer's call |
| H12 | Rules | Rules load from a subfolder (`--canary` only) | FAIL or WARN | None; unavailable canary environment is WARN/inconclusive |
| H13 | Skills | If `.claude/rules/claude-code.md` contains `## Agent skills`, `docs/agents/issue-tracker.md`, `triage-labels.md`, and `domain.md` exist | WARN | None; skill-owned content, see `/setup-matt-pocock-skills` |
| H14 | Migration | No root `AGENT_LEARNINGS.md` remains | WARN | None; migrate manually using `11-agent-learnings.md`, Step 5 |

## Repair and backup policy

Only H03, H05, H06, H09, and H10 have mechanical repairs. Each file or directory is a separate confirmation. The tool refuses symlink parents, existing symlink targets, unsupported file types, and any file it cannot back up safely. H05 does not replace a custom `CLAUDE.md`; malformed index headers and missing README content are reported for manual handling.

Before applying an accepted change, the tool saves the original file or writes an explicit absence marker under:

```text
project/build/health-check/<run-id>/
```

The exact backup path appears before the prompt. Backups are durable and may appear as untracked project data; the tool neither modifies `.gitignore` to hide them nor deletes old backups. File changes use a same-directory temporary file and atomic rename. A declined repair changes nothing. Without a terminal, `--repair` reports only and says `repairs skipped: no terminal`.

If the consumer does not yet have `project/`, the first accepted repair creates the displayed `project/build/health-check/<run-id>/` backup hierarchy as part of that confirmed operation; the parent `project/` is not offered as a separate target.

The health-check performs only read-only Git queries (`rev-parse` and `check-ignore`). It never stages, commits, pushes, resets, checks out, or removes Git content.

## Verification

The implementation's selftest is:

```bash
bash scripts/validation/health-check-selftest.sh
```

It uses copied fixtures and disposable Git repositories, checks accepted and declined repairs, backup failures, no-terminal behavior, and the canary boundary. The canary tests use a stub; they do not require a live model call.
