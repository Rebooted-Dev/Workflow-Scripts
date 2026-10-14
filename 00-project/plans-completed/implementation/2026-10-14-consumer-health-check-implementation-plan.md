# Implementation Plan: Consumer project health check with confirmed repairs

**Created:** 2026-10-14 00:15
**Reviewed/Finalised:** 2026-10-14 00:27
**Status:** ✅ COMPLETED
**Tier:** T2

## Goal

Provide one deterministic command that reports a defined subset of mechanically verifiable consumer setup requirements and offers only explicitly approved mechanical repairs. NuBible-App is the first acceptance target. A PASS is not certification that every interactive, content-based, or user-level setup step is complete.

- Read-only by default: no consumer-project file is left changed. Any temporary scratch data is created outside the project and cleaned on exit.
- Every proposed repair names each exact target, command-equivalent, and backup path before its own `y/N` prompt. Default is no.
- Repairs are a fixed, reversible allowlist. Content migration, row rewriting, and skill-owned content are reported for manual handling.
- The health-check makes no model or network call unless `--canary` is explicitly supplied.
- Each check is grounded in the setup workflow or its referenced validation script; ambiguities are not guessed into automatic repairs.

The submitted draft records two decisions: ask before each repair, and target consumer projects rather than Workflow-Scripts itself.

## Scope and non-goals

**In scope**
- `scripts/validation/health-check.sh`, isolated fixtures, and its selftest.
- `00-project-setup/12-health-check.md`, an index entry in `00-project-setup/README.md`, and replacement only of the Step 3 commands represented by H01–H11/H13–H14 with a health-check pointer. Uncovered Step 3 checks remain in place.
- Checks for the consumer layout in `00-project-setup/01-setup-project.md` and `11-agent-learnings.md`: repository map and Workflow-Scripts checkout, agent files, Claude-only rules, `.gitignore`, learnings/log structure, skill docs, and the retired root `AGENT_LEARNINGS.md` file.
- A read-only baseline run on NuBible-App after the tool is implemented.

**Non-goals**
- Rewriting or migrating content: `AGENTS.md`/`PROJECT.md` sections, log rows or entries, and skill-owned files are never auto-edited.
- Mutating Git state from the health-check (no add/stage, commit, push, reset, checkout, or removal). Read-only `git -C … rev-parse` and `git check-ignore` are permitted for H02/H03.
- Network access or model calls in ordinary checks. The explicit `--canary` opt-in is the sole exception because the existing rules-load checker starts a headless Claude session.
- Installing/updating skills or checking Workflow-Scripts as a consumer. The scope guard rejects the Workflow-Scripts root.
- Certifying the complete setup workflow. Checks for project/plans/docs directories, user-level Claude cache status, backup migration, interactive sessions, and content correctness remain in Step 3 and are not implied by a health-check PASS.
- Windows support; the first version follows the current macOS/bash setup environment.
- A `GEMINI.md` presence/absence policy until the remaining setup references agree on whether it is a supported consumer artifact (see Deferred & Debt).

## Assumptions

- `00-project-setup/01-setup-project.md` and `11-agent-learnings.md` are the canonical consumer requirements. Check implementation must use the exact folder and header names in those files.
- Repair backups are durable recovery artifacts at `project/build/health-check/<run-id>/` inside the consumer project. The path is printed before confirmation; creating backups may leave this directory untracked in Git. If `project/` does not yet exist, the first accepted repair creates the displayed backup-parent hierarchy as part of that confirmed operation; `project/` is not offered as a separate repair target. The health-check does not change `.gitignore` to hide its backups, and it never cleans old backups automatically.
- A non-interactive invocation may report but cannot repair. The implementation detects this from standard input and reports `repairs skipped: no terminal` without changing a project file.
- The project path is the first positional argument; optional flags follow it. Invalid, duplicate, or unknown flags exit `2` with usage text.

## Change Surface

| Behavior | Sites (file:line) | Class | Found with |
|---|---|---|---|
| Canonical repo map and repo-path expectations | `00-project-setup/04-track-repos-and-agent-map.md:8-9,96-101`; `00-project-setup/01-setup-project.md:1093-1108,1235-1242` | restates | `grep -nE 'Repositories|repo map|CLAUDE.md' 00-project-setup/04-track-repos-and-agent-map.md 00-project-setup/01-setup-project.md` |
| `.gitignore` workflow-path rule and health-check invocation | `00-project-setup/01-setup-project.md:364-376,1150-1168` | restates | `grep -nE 'Verify \.gitignore|workflows directory|git status|health-check\.sh' 00-project-setup/01-setup-project.md` |
| AGENTS/PROJECT, CLAUDE symlink, and rules-file layout | `00-project-setup/01-setup-project.md:1050-1088,1217-1230`; `00-project-setup/skills/03-project-scaffold.md:44-48` | restates | `grep -nE 'CLAUDE\.md|Claude-Specific Instructions|Agent skills' 00-project-setup/01-setup-project.md 00-project-setup/skills/03-project-scaffold.md` |
| Selected Step 3 checks and the single automated entry point | `00-project-setup/01-setup-project.md:1150-1157,1161-1168,1170-1182,1201-1207,1217-1246` | implements | `grep -nE '^## Step 3|^### 3\.|project/(changelog|troubleshooting|learnings)|Agent skills|health-check\.sh' 00-project-setup/01-setup-project.md` |
| Health-check implementation for H01–H14 and per-target repair handlers | `scripts/validation/health-check.sh:179-821` | implements | `grep -nE '^workflow_path_ignored_by_project|^check_h[0-9]+|^apply_repair|^run_checks' scripts/validation/health-check.sh` |
| Health-check fixture/repair/canary regression coverage | `scripts/validation/health-check-selftest.sh:151-600`; `scripts/validation/fixtures/health-check/**` | guards | `grep -nE '^run_case |^# H[0-9]+|health-check-selftest:' scripts/validation/health-check-selftest.sh` |
| Consumer-facing health-check contract | `00-project-setup/12-health-check.md` | restates | `grep -nE '^## (Purpose|Command|Output|Check catalog|Repair|Verification)|^\| H[0-9]+' 00-project-setup/12-health-check.md` |
| Manual Step 3 checks that must remain outside this health-check | `00-project-setup/01-setup-project.md:1173-1175,1184-1199,1203-1207,1209-1215,1248-1278` | restates | `grep -nE '^### 3\.(2|3|4|4\.1|5|7\.1|7\.2|8|9)' 00-project-setup/01-setup-project.md` |
| Required learnings categories and root-file migration | `00-project-setup/11-agent-learnings.md:164-180`; `00-project-setup/01-setup-project.md:978-989,1201-1207,1326` | implements | `grep -nE 'workflow code tooling facts communication|AGENT_LEARNINGS\.md|project/learnings' 00-project-setup/11-agent-learnings.md 00-project-setup/01-setup-project.md` |
| Existing structural learnings check | `scripts/validation/check-learnings.sh:15-27,29-80` | implements | `grep -nE 'CATEGORIES|README\.md|index\.md|mktemp|fail ' scripts/validation/check-learnings.sh` |
| Existing subfolder rules canary and its model/network boundary | `scripts/validation/check-agent-rules-load.sh:2-12,26-53` | implements | `grep -nE 'claude|mktemp|ANTHROPIC_API_KEY|canary|Usage' scripts/validation/check-agent-rules-load.sh` |
| Skills docs expectation | `00-project-setup/01-setup-project.md:1244-1246`; `00-project-setup/skills/README.md:50`; `00-project-setup/skills/02-project-scan.md:35-39,59` | restates | `grep -nE 'Agent skills|issue-tracker\.md|triage-labels\.md|domain\.md' 00-project-setup/01-setup-project.md 00-project-setup/skills/README.md 00-project-setup/skills/02-project-scan.md` |
| GEMINI references conflict with proposed retirement check | `00-project-setup/README.md:52`; `00-project-setup/skills/README.md:53` | restates | `grep -RnE 'GEMINI\.md|Gemini CLI' 00-project-setup` |
| Historical canary evidence, not a current normative requirement | `00-project/research/2026-10-13-agent-learnings-load-and-accuracy-report.md:320-347` | historical | `grep -nE '^## 12|check-agent-rules-load|GEMINI\.md' 00-project/research/2026-10-13-agent-learnings-load-and-accuracy-report.md` |

## Decision

- **Option A (minimal):** add only a read-only health report. Benefit: smallest behavior surface. Cost: leaves the known, mechanically repairable layout gaps as manual work.
- **Option B (checks plus confirmed repairs):** read-only default, a small fixed repair allowlist, an exact per-operation preview, a backup, and a separate `y/N` confirmation for each operation. Benefit: closes simple setup gaps while preserving owner control. Cost: a larger fixture and repair-test matrix.
- **Option C:** use a skill instead of a script. Benefit: can reason about arbitrary content. Cost: non-deterministic, model-dependent, and cannot provide the promised fixed repair/exit contract.
- **Chosen:** Option B, bounded to the checks and repair allowlist below. The submitted draft's ask-first and consumer-only decisions are retained. **Reversibility:** cheap; each accepted operation has a durable backup or an explicit “target absent” record, and no repair is automatic.

## Design & Interfaces

**Command**

```bash
bash scripts/validation/health-check.sh <PROJECT_PATH> [--repair] [--canary]
```

- Default: run H01–H11 and H13–H14 read-only, print one finding per check and a summary. H12 is explicitly reported as not run unless requested.
- `--repair`: after the initial report, offer each permitted target/action separately. Show check ID, exact target, a safely quoted command-equivalent, and exact backup path before asking `y/N`; a no/empty answer changes nothing. Do not build commands from project content or evaluate shell text.
- `--canary`: after any selected repair attempts, run `check-agent-rules-load.sh <PROJECT_PATH>` only if H04/H05 preconditions pass. This opt-in may make one headless Claude model call; no other health-check path may call a model or access the network. If a precondition fails, H12 is FAIL and no model call is made.
- Exit codes: `0` when no check is FAIL (WARN and the default skipped H12 are allowed); `1` when at least one check is FAIL; `2` for invalid usage or a rejected/non-consumer target.
- H12 result mapping: PASS when the existing canary succeeds; FAIL when its structural precondition fails or the canary token is not observed; WARN/inconclusive when the CLI, login, credit, or model service prevents a meaningful result. A canary environment WARN does not turn the consumer-layout result into exit `1`.
- Only read-only Git queries are used for repository identity/ignore checks. The check and repair code do not stage, commit, push, or otherwise mutate Git state.
- Resolve the single Workflow-Scripts repo-map path as a relative path from the consumer root; reject absolute paths, `..` components, glob patterns, and shell metacharacters. Spaces are allowed and quoted; following a symlink at the validated path is allowed.

**Example output**

```text
PASS  H05  CLAUDE.md is a symlink to AGENTS.md
WARN  H07  Claude-specific heading found in CLAUDE.md; move it to .claude/rules/claude-code.md
FAIL  H09  project/learnings/index.md missing
summary: 10 PASS, 2 WARN, 1 FAIL (13 checks); H12 not run (use --canary); repairable: H09 (confirmation required)
```

When a repair is offered, show its exact target and command-equivalent with the actual run ID expanded in the backup path, for example:

```text
repair H09: create missing category folder
target: project/learnings/code/
command-equivalent: mkdir -p 'project/learnings/code/'
backup: project/build/health-check/<actual-run-id>/absent/project/learnings/code/
Apply? [y/N]
```

**Check catalog**

| ID | Area | Check | Severity | Repair (mechanical only) |
|---|---|---|---|---|
| H01 | Repos | `PROJECT.md` contains a `## Repositories` table | FAIL | none (content) |
| H02 | Repos | Exactly one Workflow-Scripts row is identified in that table; its path exists and is itself a Git root (`git -C <path> rev-parse --show-prefix` is empty) | FAIL | none |
| H03 | Git | If the configured Workflow-Scripts path is inside the consumer tree, a rule in the consumer root `.gitignore` ignores it (`git check-ignore --no-index -v`, including a matching ignored symlink parent); global excludes alone do not pass | FAIL | append the exact root-relative path and setup comment to `.gitignore`; create `.gitignore` only if absent |
| H04 | Agent files | `AGENTS.md` exists and contains a `PROJECT.md` pointer | FAIL | none (content) |
| H05 | Agent files | `CLAUDE.md` is a symlink whose link text is exactly `AGENTS.md` | FAIL | create the symlink if absent; replace a regular file only if all nonblank lines are exactly `@AGENTS.md` or `@PROJECT.md`; never replace an existing symlink or other/custom content |
| H06 | Agent files | `AGENTS.md` has an `@PROJECT.md` import | WARN | insert only if the unique “Read `PROJECT.md`” anchor exists; otherwise report |
| H07 | Agent files | If a regular root `CLAUDE.md` contains `## Claude-Specific Instructions` or `## Agent skills`, `.claude/rules/claude-code.md` exists | WARN | none; manual migration |
| H08 | Agent files | `AGENTS.md` is at most 40 lines | WARN | none (content) |
| H09 | Learnings | `project/learnings/` has `README.md`, `index.md`, and `workflow/`, `code/`, `tooling/`, `facts/`, `communication/` | FAIL | create missing directories; create a missing index or add only the canonical header if absent; never replace rows; missing README is manual |
| H10 | Logs | Changelog has README/index plus `added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/`, `plans/`; troubleshooting has README/index plus `build/`, `runtime/`, `data/`, `environment/`, `security/`; both indexes have the canonical header row | WARN | create missing folders and missing index files/headers; preserve all existing rows; missing README is manual |
| H11 | Learnings | `check-learnings.sh <PROJECT_PATH>/project/learnings` passes | WARN | none (entry content is the developer's call) |
| H12 | Rules | Rules load from a subfolder (`--canary` only) | FAIL or WARN | none; distinguish a real canary failure from an unavailable test environment as specified above |
| H13 | Skills | If `.claude/rules/claude-code.md` contains `## Agent skills`, the three `docs/agents/` files `issue-tracker.md`, `triage-labels.md`, and `domain.md` exist | WARN | none (skill-owned; suggest `/setup-matt-pocock-skills`) |
| H14 | Migration | No root `AGENT_LEARNINGS.md` remains | WARN | none; migration is Step 5 of `11-agent-learnings.md` |

For H09/H10, a malformed existing header is reported rather than rewritten. A missing README is not generated from memory. Every directory/file creation is a separate repair offer with its own exact target and absence backup record.

**Repair engine and safety boundary**

1. Represent each individual operation as a record containing its check ID, exact target, safely quoted command-equivalent from a fixed template, description, operation type, apply function, and proposed backup path. Print the command-equivalent before prompting, but never execute it through `eval` or a shell; apply through fixed operation handlers.
2. Give each invocation a collision-resistant run ID. Before any accepted mutation, save the regular-file target (preserving its mode) or write an explicit absence marker in `project/build/health-check/<run-id>/`. The backup hierarchy is created only after consent; if `project/` is absent, its creation is part of that confirmed backup setup.
3. Refuse automatic writes through symlink parents, to existing symlink targets, or to unexpected file types. H05's symlink operation may replace only an absent or import-only regular file. If a backup cannot be completed, do not mutate that target.
4. For file content changes, write a unique temporary file in the target directory, preserve required mode, then atomically rename it. For H05, create a temporary symlink beside the target and rename it into place. Clean only temporary files created by the current process; report stale files rather than deleting unowned files on a later run.
5. Re-run the repaired check after each accepted operation. Keep any remaining/new FAIL visible. List declined operations and post-repair outcomes in the summary.

**Scope guard**

- Exit `2` when both `AGENTS.md` and `PROJECT.md` are absent.
- Exit `2` on the Workflow-Scripts root, identified by its validation-script and `00-project/changelog/` markers, including when addressed through a symlink.
- Do not infer or execute arbitrary paths from project text; validate the one repo-map path as a plain path and use quoted arguments for all checks.

## Failure Modes & Recovery

| Failure | Detection | User sees | Recovery |
|---|---|---|---|
| Non-project directory | Both root agent files absent | Exit `2` with reason | Run against a consumer project root |
| Workflow-Scripts passed as target | Scope markers after resolving the directory | Exit `2`, consumer-only explanation | None needed |
| Invalid, duplicate, or ambiguous option | Argument parser | Usage text and exit `2` | Correct the invocation |
| Unsupported symlink/file type or custom CLAUDE content | Pre-write type/content checks | Finding remains; repair marked unavailable | Move content manually, then re-run |
| Backup path cannot be created or target backup fails | Backup operation returns nonzero | Repair skipped; target is unchanged | Resolve permissions/storage, re-run |
| Interrupted write | Unique temporary name and backup | Original target remains atomic; leftover temp may be reported | Inspect and remove only after confirming ownership; restore from the displayed backup if needed |
| Developer declines repair | `N` or empty answer | `declined` in summary | None; no change |
| No terminal | stdin is not a TTY | `repairs skipped: no terminal` | Re-run interactively if desired |
| Canary environment unavailable | CLI/model invocation diagnostic | H12 WARN/inconclusive, not a layout FAIL | Re-run with working Claude Code login/credits, or omit `--canary` |
| Repair fails its re-check | Post-operation check | Original FAIL remains visible with repair result | Restore from the exact backup path |

## Test Strategy

- **Fixtures** under `scripts/validation/fixtures/health-check/`: `healthy`, `no-project`, `no-agents`, `bad-workflow-repo`, `symlink-workflow-parent`, `bad-gitignore`, `import-claude`, `custom-claude`, `no-project-import`, `no-rules-dir`, `long-agents`, `no-learnings`, `no-project-metadata`, `missing-logs`, `invalid-learnings`, `skills-incomplete`, `legacy-agent-learnings`, `not-a-project`, and `workflow-root`. The workflow-root fixture contains only the guard-marker layout. The selftest copies fixtures to a temporary workspace and initializes isolated Git repos there for H02/H03; it never modifies the fixture sources.
- **Read-only selftest:** `health-check-selftest.sh` verifies expected findings and exit codes for every fixture, confirms all fixtures remain unchanged, and proves a global Git exclude alone does not satisfy H03.
- **Repair selftest:** execute repairs only against copies, with scripted yes/no answers through a pseudo-terminal. Cover H03 including a missing `.gitignore`, H05 absent/import-only/wrong-symlink/directory/backup-failure cases, H06 with and without its unique anchor, every H09/H10 creation/header operation, malformed-header and missing-README manual fallbacks, backup contents/absence markers, and re-check outcomes. For each repair, `n` leaves the target byte-identical and `y` changes only the advertised target after a backup exists.
- **No-terminal selftest:** run `--repair` with stdin redirected from `/dev/null`; assert the no-terminal message and compare the entire copied fixture before/after.
- **Canary selftest:** a stub `claude` records calls and echoes the canary token from its prompt. Without `--canary`, it records zero calls; with `--canary` and passing H04/H05 preconditions, H12 passes without a live model request. A failed precondition makes H12 FAIL without calling the stub; test environmental failure maps to WARN.
- **Acceptance:** run the default check on NuBible-App, record its output under Implementation Evidence, and compare `git -C <PROJECT_PATH> status --porcelain` snapshots before/after. Do not pass `--repair` or `--canary` for this acceptance run.
- **Docs:** run `bash scripts/validation/check-active-markdown-links.sh` from the Workflow-Scripts checkout after both setup docs are updated.

## Rollout & Rollback

- **Phase 1 — Read-only contract:** define fixtures, checks, output, and a complete read-only selftest. No consumer file is changed.
- **Phase 2 — Repairs and opt-in canary:** add the backup/atomic repair engine, allowlisted repairs, no-terminal rule, and model-call guard tests.
- **Phase 3 — Consumer acceptance:** run the no-flag health check against NuBible-App and save the clean-read evidence. Do not repair any existing findings during this acceptance task.
- **Phase 4 — Documentation and close-out:** publish the check spec, link it from Step 3, and add the implementation changelog entry.
- **Checkpoints:** after each phase, record test output and a diff hash; create a commit only if separately authorized. Keep the current inline Step 3 checks until the new script and its selftest pass, then replace them with the pointer.
- **Rollback:** revert only the health-check script/spec/setup-doc changes from the recorded phase diff (commit only if one was authorized). A consumer project is modified only after an individual `y`; its matching backup is retained at the printed path.

## Artifact lifecycle

| Source locator | Owner repository | Relationship | Disposition / exact destination or retained reason | Verification |
|---|---|---|---|---|
| `00-project/plans/2026-10-14-consumer-health-check-implementation-plan.md` | Workflow-Scripts | completed plan source | filed by the terminal gate at `00-project/plans-completed/implementation/2026-10-14-consumer-health-check-implementation-plan.md`; the plan was the only moved task artifact | final-path gate check |
| `## Current state` / Plan Review addendum in this file | Workflow-Scripts | inline review record | retain in this plan; no separate `PLAN.reviews/` artifact or archive is created | review dispositions recorded below |
| `00-project/research/2026-10-13-agent-learnings-load-and-accuracy-report.md` | Workflow-Scripts | historical evidence | retain in `00-project/research/`; it documents the canary precedent, not a new normative rule | retained-link check |
| `00-project/changelog/docs/2026-10-14-docs-consumer-health-check-proposal.md` | Workflow-Scripts | prior proposal record | retain as the initial proposal/change record; it is not replaced by this in-place plan revision | retained-link check |
| `00-project-setup/01-setup-project.md` | Workflow-Scripts | live setup workflow | retain in place; Step 3 pointer updated in task 11 | active markdown-link check |
| `00-project-setup/README.md` | Workflow-Scripts | live workflow index | retain in place; add spec index row in task 10 | active markdown-link check |
| `00-project-setup/12-health-check.md` | Workflow-Scripts | new live specification | create in task 10 and retain as the check contract | active markdown-link check |
| `scripts/validation/health-check.sh` | Workflow-Scripts | new live tool | create in tasks 2, 4–5, 7–8 | selftest and consumer acceptance |
| `scripts/validation/fixtures/health-check/**`; `scripts/validation/health-check-selftest.sh` | Workflow-Scripts | new test artifacts | create in tasks 1, 3, and 6–8; retain with the tool | selftest |
| `00-project/changelog/docs/2026-10-14-docs-finalise-consumer-health-check-plan.md` | Workflow-Scripts | plan review/finalisation record | retain in changelog; records this plan-only revision | changelog index and meta-log check |
| `00-project/changelog/added/2026-10-14-added-consumer-health-check.md` | Workflow-Scripts | implementation changelog | retain as the feature record; update through task 12 as later phases verify | changelog index and meta-log check |
| `00-project/troubleshooting/git/2026-10-14-git-health-check-parent-repository-detection.md` | Workflow-Scripts | resolved implementation issue | retain in troubleshooting; records the H02 ancestor-repository false-pass and correction | troubleshooting index and meta-log check |
| `00-project/learnings/facts/2026-10-14-facts-git-subdirectory-inherits-parent-repository.md` | Workflow-Scripts | verified non-obvious fact | retain as a NOTED learning; supports H02's own-root check | `check-learnings.sh` |
| NuBible-App default health-check output | NuBible-App | acceptance evidence | record in this plan under Implementation Evidence; do not change consumer files | before/after status snapshots match |

## Tasks

### Phase 1: Read-only checks and fixture contract

**Phase status:** Verified Complete.

**Objective:** establish a fixture-backed read-only contract before any repair code exists. **Exit:** all H01–H11/H13–H14 outcomes and exit codes are exercised; fixtures remain unchanged. **Primary risk:** fixture assumptions diverge from setup docs; compare each fixture against the Change Surface sources above.

1. [✅] Add the isolated health-check fixture matrix (P1 — enables deterministic validation; Effort: Small)
   - Files: `scripts/validation/fixtures/health-check/**` (new)
   - Verify: fixtures represent `healthy`, `no-project`, `no-agents`, `bad-workflow-repo`, `symlink-workflow-parent`, `bad-gitignore`, `import-claude`, `custom-claude`, `no-project-import`, `no-rules-dir`, `long-agents`, `no-learnings`, `no-project-metadata`, `missing-logs`, `invalid-learnings`, `skills-incomplete`, `legacy-agent-learnings`, `not-a-project`, and `workflow-root`; expected states are documented beside fixture data (cost/prereqs: none)
2. [✅] Implement read-only H01–H11 and H13–H14 checks, output, argument parsing, and scope guard (P1 — defines the core contract; Effort: Medium)
   - Files: `scripts/validation/health-check.sh` (new)
   - Verify: healthy fixture exits `0`; fixtures with FAIL findings exit `1`; a workflow directory that only inherits the consumer's parent Git root fails H02; invalid invocation, non-project, and workflow-root exit `2`; default output omits H12 work and clearly says it was not run (cost/prereqs: task 1)
3. [✅] Add the read-only fixture selftest (P1 — prevents drift in the documented contract; Effort: Small)
   - Files: `scripts/validation/health-check-selftest.sh` (new); `scripts/validation/fixtures/health-check/**`
   - Verify: `bash scripts/validation/health-check-selftest.sh` prints `health-check-selftest: OK`; expected findings and exit codes match for every fixture, and fixture snapshots are unchanged (cost/prereqs: tasks 1–2)

### Phase 2: Confirmed repairs and optional canary

**Phase status:** Verified Complete.

**Objective:** enable only the reversible, individually confirmed operations and isolate model use behind `--canary`. **Exit:** every repair is backed up, individually previewed/confirmed, rechecked, and covered by accepted/declined tests; no-terminal runs are inert. **Primary risks:** unintended consumer edits and paid/inconclusive canary calls; mitigate with the preview/backup boundary and stub-only selftests.

4. [✅] Add the repair transaction engine and safe H05 symlink repair (P1 — protects user files; Effort: Medium)
   - Files: `scripts/validation/health-check.sh`
   - Verify: H05 absent-target and import-only cases create the correct symlink only after `y`, with exact backup/absence record; custom files, existing symlinks, unsupported file types, and H05 backup failures do not mutate the target (cost/prereqs: tasks 1–3)
5. [✅] Add H03, H06, H09, and H10 mechanical repair operations (P1 — closes bounded structural failures; Effort: Medium)
   - Files: `scripts/validation/health-check.sh`
   - Verify: repairs are per-target; H03 requires a root `.gitignore` rule (including an ignored symlink parent) and preserves existing bytes except its appended line; H06 inserts only at a unique anchor; H09/H10 preserve existing rows byte-for-byte; malformed headers and missing README content remain manual findings (cost/prereqs: task 4)
6. [✅] Extend selftests across every accepted and declined repair operation (P1 — proves the write boundary; Effort: Medium)
   - Files: `scripts/validation/health-check-selftest.sh`; `scripts/validation/fixtures/health-check/**`
   - Verify: on copied fixtures, `y` changes only the previewed target after backup, `n` leaves it byte-identical, backups restore the original/absence state, malformed/manual findings are not offered, and each accepted operation is rechecked (cost/prereqs: tasks 4–5)
7. [✅] Enforce the no-terminal repair rule (P1 — prevents unattended writes; Effort: Small)
   - Files: `scripts/validation/health-check.sh`; `scripts/validation/health-check-selftest.sh`
   - Verify: `bash scripts/validation/health-check.sh <fixture> --repair < /dev/null` reports `repairs skipped: no terminal`; a full fixture comparison shows no change (cost/prereqs: task 6)
8. [✅] Add opt-in H12 `--canary` behavior and call-boundary tests (P2 — validates the optional integration without default cost; Effort: Small)
   - Files: `scripts/validation/health-check.sh`; `scripts/validation/health-check-selftest.sh`
   - Verify: a stub `claude` records zero calls by default; with `--canary` it echoes the prompt token and H12 passes; an unavailable CLI/model maps to WARN; no live model call is needed for selftest (cost/prereqs: task 2; live canary deliberately not required)

### Phase 3: Consumer acceptance

**Phase status:** Verified Complete.

**Objective:** establish the actual first-consumer baseline using the no-flag path. **Exit:** the full default output is recorded and the consumer's status snapshot is identical before/after. **Risk:** unrelated concurrent work can change status; take snapshots immediately around the check and report any mismatch rather than attributing it to the script without evidence.

9. [✅] Run the default health-check on NuBible-App and record output plus before/after status evidence below (P1 — proves the first consumer path is read-only; Effort: Small)
   - Files: this plan (`## Implementation Evidence`); no NuBible-App files
   - Verify: run without `--repair` or `--canary`; `git -C <PROJECT_PATH> status --porcelain` before/after matches exactly, output is recorded, and any findings remain findings (cost/prereqs: tasks 1–8)

### Phase 4: Documentation and close-out

**Objective:** make the executable contract discoverable and keep the setup workflow linked to one source of truth. **Exit:** spec and setup links pass, logs are complete, and the plan is ready for the terminal filing gate after implementation. **Risk:** duplicate check instructions drift; remove the duplicated Step 3 commands only after the script and spec exist.

10. [✅] Write the health-check spec and index it (P2 — documents the stable consumer interface; Effort: Small)
    - Files: `00-project-setup/12-health-check.md` (new); `00-project-setup/README.md`
    - Verify: spec states this is a bounded subset, and its catalog, exit codes, backup policy, prompts, and canary exception match the script; `bash scripts/validation/check-active-markdown-links.sh` prints OK (cost/prereqs: tasks 1–9)
11. [✅] Replace only the covered Step 3 commands with the health-check pointer; preserve every uncovered/manual check and the opt-in canary guidance (P2 — preserves the full setup procedure while removing duplicated checks; Effort: Small)
    - Files: `00-project-setup/01-setup-project.md`
    - Verify: Step 3 names the exact command for H01–H11/H13–H14; 3.6.1 states that model use requires `--canary`; checks outside that catalog (including project/plans/docs structure, user-level statusline, and backup/migration checks) remain present; active markdown-link check prints OK (cost/prereqs: task 10)
12. [✅] Update the implementation changelog/index and retain the H02 troubleshooting record (P2 — required repository record; Effort: Small)
    - Files: `00-project/changelog/added/2026-10-14-added-consumer-health-check.md`; `00-project/changelog/index.md`; `00-project/troubleshooting/git/2026-10-14-git-health-check-parent-repository-detection.md`; `00-project/troubleshooting/index.md`
    - Verify: entries record only implemented/verified facts; `check-meta-logs.sh --staged` passes against the authorized change set in an isolated temporary index, without changing the user's real Git index (cost/prereqs: tasks 1–11 and H02 resolution; no commit required)
13. [✅] File the completed plan package via the terminal gate (P2 — required lifecycle close-out; Effort: Small)
    - Files: this plan; `## Artifact lifecycle` rows
    - Verify: gate filing verified — inventory matches disk, affected links and indexes repaired, `check-plan.sh --require-tier --state` passes at the final path (cost/prereqs: verified implementation, resolved owner archive policy)

## Dependencies

- Task 1 precedes task 2; task 3 depends on tasks 1–2.
- Task 4 depends on the read-only contract and fixtures (tasks 1–3); task 5 depends on task 4; task 6 verifies tasks 4–5; task 7 depends on task 6.
- Task 8 depends on the check interface in task 2 and is tested through the task 6–8 selftest without a live model call.
- Task 9 follows tasks 1–8 and deliberately exercises only the default path.
- Task 10 depends on the implemented interface and acceptance result (tasks 1–9); task 11 depends on task 10; task 12 depends on tasks 10–11; task 13 is terminal and follows all implementation obligations.

## Deferred & Debt

- Windows symlink support — `scripts/validation/health-check.sh` — when a Windows consumer is in scope — low.
- Machine-readable `--json` output — health-check CLI — when another tool needs structured output — low.
- Running the check against every consumer project in the repo map — acceptance suite — after the NuBible-App first-consumer run is stable — low.
- GEMINI presence/absence check — setup docs and health-check catalog — after `00-project-setup/README.md:50` and `skills/README.md:53` are reconciled with the intended retirement policy — medium.
- Backup retention/cleanup policy — consumer `project/build/health-check/` — when backups accumulate enough to warrant a documented cleanup action — low. Until then, backups remain durable and are never removed by the tool.

## Risks

| Risk | Impact (Low/Medium/High) | Likelihood (Rare/Possible/Likely) | Severity (S0–S3) | Mitigation |
|---|---|---|---|---|
| A repair changes a target the owner did not intend | High | Possible | S1 | Per-target preview, explicit yes, backup before mutation, and re-check |
| H05 replacement removes custom Claude-only content | High | Rare | S1 | Replace only absent/import-only regular files; refuse custom content and symlinks |
| An interrupted write leaves a temporary artifact | Medium | Rare | S2 | Same-directory atomic rename, current-process cleanup only, visible backup; never auto-delete stale files |
| Backup directory appears as untracked consumer data | Low | Likely | S3 | Print exact path before confirmation; retain backups; do not change `.gitignore` or clean user data |
| Canary cannot distinguish a broken consumer layout from account/service failure | Medium | Possible | S2 | H12 is opt-in; deterministic canary/layout failures are FAIL, unavailable execution is WARN/inconclusive |
| Setup instructions and code catalog drift | Medium | Possible | S2 | Spec is canonical; Step 3 points to it and existing link check runs after edits |

## Success Criteria

- [✅] The default health-check reports H01–H11 and H13–H14, explicitly marks H12 not run, and uses the specified `0`/`1`/`2` exit contract.
- [✅] No consumer-project file changes during a default run, a declined repair, or a `--repair` run without a terminal; temporary scratch artifacts are cleaned.
- [✅] Each accepted repair is limited to the allowlist, individually confirmed, backed up first, and followed by a visible re-check.
- [✅] Read-only, repair, refusal, no-terminal, backup-failure, and canary-boundary selftests pass on copied fixtures; no test requires a live model call.
- [✅] No model/network call occurs unless `--canary` is supplied; an unavailable canary environment is reported as WARN/inconclusive.
- [✅] The NuBible-App default output and matching before/after status snapshots are recorded in this plan.
- [✅] The specification and setup workflow links validate; implementation changelog and required H02 troubleshooting entries are indexed.
- [✅] Completed plan package filed and verified at its recorded destination

## Implementation Evidence

### Phase 1 report — 2026-10-14 01:40

- Tasks 1–3 verified and ticked. The fixture README documents all 17 cases; the selftest materializes copies and initializes disposable Git repositories for H02/H03.
- `bash scripts/validation/health-check-selftest.sh` → `health-check-selftest: OK`.
- `bash -n scripts/validation/health-check.sh` and `bash -n scripts/validation/health-check-selftest.sh` → pass.
- `shellcheck scripts/validation/health-check.sh scripts/validation/health-check-selftest.sh` → no findings.
- `bash scripts/validation/check-learnings.sh` → OK (23 rows, 23 entries); `bash scripts/validation/check-learnings-selftest.sh` → OK.
- H02 was strengthened after verifying that `git -C <subdirectory> rev-parse --show-toplevel` can return an ancestor repository. The check now requires an empty `--show-prefix` and a matching resolved top-level path; the `bad-workflow-repo` test covers the parent-repository false-pass.
- Code/fixture checkpoint SHA-256 (tar stream): `b2b92b41cb3cf0af06a8c129130ccc2b807b275738be9292d32e05d402e3985e`. No commit was created.
- Added the Phase 1 changelog entry, the resolved H02 troubleshooting entry, and a NOTED learning for the verified Git behavior.

### Phase 2 report — 2026-10-14

- Tasks 4–8 verified and ticked. Repairs are individually previewed and backed up; H05 covers absent/import-only/whitespace-only targets and refuses custom files, existing symlinks, and unsupported types. H03/H06/H09/H10 repairs and per-operation rechecks are exercised.
- `bash scripts/validation/health-check-selftest.sh` → `health-check-selftest: OK`; the test covers accepted/declined operations and command previews, absent backup markers, header-row preservation, malformed/manual fallbacks, backup failure, no-terminal behavior, the parent-symlink ignore case, and a global-exclude-only H03 case.
- `bash -n scripts/validation/health-check.sh` and `bash -n scripts/validation/health-check-selftest.sh` → pass; ShellCheck → no findings.
- `bash scripts/validation/check-learnings.sh` → OK (23 rows, 23 entries); `bash scripts/validation/check-learnings-selftest.sh` → OK.
- H12 passed through a stub only with `--canary`; default path made zero stub calls; stubbed service failure mapped to WARN and failed H04/H05 preconditions skipped the call.
- Phase 2 code/fixture checkpoint SHA-256 (tar stream): `87003ca0b05b90f2e4f67172ea7cee1b9b9e1978f763a55b07cc37fb7dd465e5`. No commit was created.
- The implementation changelog now records verified Phase 1/2 behavior. The H02 issue and its resolution are retained in troubleshooting.

### Phase 3 report — 2026-10-14 02:17

- Task 9 verified. Ran the default command against `/Users/jesse/Development/Personal/NuBible-App` without `--repair` or `--canary`; exit `0`. The root repository was already dirty, and the before/after `git status --porcelain` snapshots were identical.
- Recorded output:

  ```text
  PASS  H01  PROJECT.md contains a ## Repositories table
  PASS  H02  Workflow-Scripts path is its own Git root (Shared-Links/Workflow-Scripts)
  PASS  H03  Workflow-Scripts path is ignored (Shared-Links/Workflow-Scripts)
  PASS  H04  AGENTS.md exists and points to PROJECT.md
  PASS  H05  CLAUDE.md is a symlink to AGENTS.md
  PASS  H06  AGENTS.md imports @PROJECT.md
  PASS  H07  Claude-only rules location is present when a recognized heading requires it
  PASS  H08  AGENTS.md is 40 lines (target <= 40)
  PASS  H09  project/learnings has its README, index header, and five category folders
  PASS  H10  changelog and troubleshooting indexes, headers, READMEs, and categories are present
  WARN  H11  check-learnings.sh reports a structural/content issue: workflow/2026-10-13-workflow-read-learning-index-before-work.md: Source must start with developer message, command, file, or unverified
  PASS  H13  Agent skills block has all three docs/agents files
  PASS  H14  no root AGENT_LEARNINGS.md remains
  SKIP  H12  not run (pass --canary to make the opt-in model call)
  summary: 12 PASS, 1 WARN, 0 FAIL (13 checks); H12 not run
  ```
- NuBible-App files were not modified by this acceptance run; H11 remains a warning and is not repaired by this plan.
- Confirmation rerun at 2026-10-14 03:02 returned the same output and exit `0`; status snapshots still matched. Acceptance evidence fingerprint (before-status, output, after-status): `70a407515209097ca4e620fdd927db28d964fa996d23982fec8eaea790683905`.

### Phase 4 report — 2026-10-14

- Tasks 10–12 verified. Added `00-project-setup/12-health-check.md`, indexed it in the setup README, replaced only the selected Step 3 checks with the health-check references, and retained the uncovered manual checks.
- `bash scripts/validation/check-active-markdown-links.sh` → `Active markdown links OK`.
- `check-meta-logs.sh --staged` → `meta log checks OK` using a temporary `GIT_INDEX_FILE`; the user's actual index was not staged or modified by this validation.
- The implementation changelog and H02 troubleshooting entry/indexes record verified facts only. `check-learnings.sh` and its selftest passed for the NOTED H02 fact.
- Phase 4 documentation/log checkpoint SHA-256 (tar stream): `3dd53e079295a44355b4fa68113c5044f3386cfca15145bb3082875327550cf8`.
- No commit was created; the gate subsequently verified package filing at the recorded path.

**Open:** None; separately deferred debt remains routed in the host TODO.

## Current state

- P1/S1 repair-safety finding: accepted; per-target backups, symlink/type refusals, collision-resistant run IDs, and no deletion of stale temp files are now in Design and the repair tests.
- P2/S2 task-order finding: accepted; fixtures precede implementation, tests follow the code they exercise, and the NuBible-App run is separated from documentation work.
- P2/S2 scope-completeness finding: resolved by narrowing the PASS claim to the listed deterministic subset and requiring Step 3 checks outside that subset to remain in the setup workflow.
- P2/S2 Git-boundary finding: accepted; the health-check forbids Git mutations but explicitly allows read-only repository/ignore queries; staging for the separate changelog validation is outside the script.
- P2/S2 canary-boundary finding: accepted; `--canary` is the sole network/model exception, and infrastructure/account failures are WARN rather than consumer-layout FAIL.
- P2/S2 backup-location finding: resolved; backups remain durable under `project/build/health-check/<run-id>` and may be untracked; no consumer `.gitignore` change is required.
- P2/S2 GEMINI finding: deferred; the check is removed until the two active setup references agree on a canonical policy.
- P2/S2 finalisation/lifecycle finding: resolved in place per the user's instruction; this plan is not superseded, and the inline review record plus retained sources/evidence are inventoried below.
- P3/S3 change-surface finding: accepted; searches and line ranges now identify current implementations, restatements, and historical evidence.
- P3/S3 artifact-inventory finding: accepted; prior proposal, inline review, changelog, and future acceptance evidence now have explicit disposition/verification rows.
- H02 implementation refinement: `git -C <subdir> rev-parse --show-toplevel` can succeed by finding the consumer's parent repository; require an empty `--show-prefix` so the recorded Workflow-Scripts path is its own Git root. Verified with the nested fixture path and recorded in the NOTED learning and RESOLVED troubleshooting entry.
- Phase 2 verification: all five repair/canary tasks and Success Criteria 1–5 are verified.
- Phase 3 verification: the NuBible-App default run returned exit `0`, with H11 WARN and no FAIL; consumer status snapshots were identical and no consumer file was modified.
- Phase 4 verification: specification, setup links, changelog/troubleshooting indexes, learnings validation, and isolated staged-equivalent meta-log check passed; confirmation audit and terminal gate remain.
- No open review recommendations remain; implementation tasks and the explicitly deferred debt remain open as planned.

2026-10-14 00:27 (local time, 24h) - Plan Review (Model: gpt-6-luna)

### P1

- **S1/P1 — Repair transaction needs a stricter ownership boundary.** **Impact:** high; a mistaken cleanup or replacement could damage consumer data. **Likelihood:** rare because each repair is opt-in, though interruption and ambiguous filesystem state are possible fault cases. **Rationale:** the submitted plan's Repair engine and Failure Modes allowed deletion of stale temporary files on a later run without proving ownership; grouped H09/H10 repairs also affected multiple paths. This is a boundary/fault-prevention concern (engineering standards §1 and §3). **Actionable fix:** use collision-resistant per-run backups, record absent targets, preview each exact command-equivalent and target separately, refuse unexpected symlinks/file types, and clean only temporary files created by the current process. **Disposition:** integrated in Design, Failure Modes, and repair selftests.

### P2

- **S2/P2 — Task prerequisites were cyclic or ordered after their consumers.** **Impact:** medium; implementation and its acceptance could not reach a valid test state in the stated order. **Likelihood:** possible on the planned execution path. **Rationale:** submitted draft tasks 1–2 each depended on outputs from the other, and task 3 tested H05 before task 4 implemented it. **Actionable fix:** establish fixtures first, then read-only checks, then selftests; implement H05 before testing repairs and put acceptance after its prerequisites. **Disposition:** task sequence and Dependencies rewritten.
- **S2/P2 — The goal implied a full setup audit, but the check catalog covered only a subset.** **Impact:** medium; users could misread PASS as proof that project/plans/docs directories, user-level setup, or migrations were complete. **Likelihood:** possible because the plan originally described whether a project was set up as specified while omitting several Step 3 checks. **Rationale:** Step 3 also verifies project/plans/docs structure (`01-setup-project.md:1162-1210`), user-level cache setup, backup files, and migration (`:1285-1315`), none of which appear in H01–H15; keeping one authoritative scope is also required by engineering standards §2. **Actionable fix:** label the checker as a bounded subset and retain all uncovered Step 3 checks when replacing duplicates. **Disposition:** Goal, Scope, Change Surface, and task 11 now enforce that boundary.
- **S2/P2 — Git prohibition contradicted both the checks and changelog verification.** **Impact:** medium; a literal reading would make H02/H03 and the required log check impossible. **Likelihood:** possible during implementation. **Rationale:** the submitted draft's Non-goals prohibited Git operations while H02/H03 need read-only Git facts and task 10 requires staging for `check-meta-logs.sh --staged`; the boundary between observations and mutations should be explicit (engineering standards §1). **Actionable fix:** prohibit Git mutations by the health-check, allow only the named read-only queries, and make any staging needed for the separate repository log check explicitly outside the script. **Disposition:** clarified in Scope, Design, and task 12.
- **S2/P2 — Canary/network and failure semantics were inconsistent.** **Impact:** medium; users could receive a false setup failure or incur a model call without clear opt-in scope. **Likelihood:** possible when Claude CLI, login, credits, or service are unavailable. **Rationale:** network access was a non-goal while H12 calls Claude; credit/CLI errors were described as FAIL even though the risk section says they should not be setup failures, contrary to deliberate error classification (engineering standards §3). **Actionable fix:** name `--canary` as the only network exception and map unavailable execution to WARN/inconclusive while retaining FAIL for deterministic layout/canary mismatch. **Disposition:** incorporated in Design, Failure Modes, tests, and Success Criteria.
- **S2/P2 — H14 lacked one authoritative GEMINI policy.** **Impact:** medium; a checker could flag or delete a file that current setup summaries still describe as a harness file. **Likelihood:** possible until the remaining docs are reconciled. **Rationale:** the proposed absent-file check/deletion conflicts with `00-project-setup/README.md:50` and `skills/README.md:53`; no current canonical thin-template is identified, violating the single-source-of-truth guidance (engineering standards §2). **Actionable fix:** remove the GEMINI check from this MVP and defer it until those references and the retirement policy are reconciled; retain only the setup-backed root `AGENT_LEARNINGS.md` check. **Disposition:** catalog renumbered to H14 for the root legacy file; GEMINI check deferred.
- **S2/P2 — Backup path and finalisation disposition were unresolved.** **Impact:** medium; an unchosen backup location could expose unexpected untracked data or leave recovery behavior undefined. **Likelihood:** possible because the draft explicitly left the ignore decision open. **Rationale:** the submitted draft left `project/build/` ignore behavior as an assumption and expected a new final plan/source supersession, while the user asked to update this plan in place; predictable recovery and ownership are boundary/fault-prevention concerns (engineering standards §1 and §3). **Actionable fix:** state the persistent-untracked backup tradeoff, keep this plan at its current path, retain review feedback inline, and inventory evidence and retained sources without creating a replacement plan. **Disposition:** resolved in Assumptions, Artifact lifecycle, and this addendum.

### P3

- **S3/P3 — Change Surface missed conditional skill checks and had incomplete retirement coverage.** **Impact:** low; an omitted source could let the checker and setup workflow drift. **Likelihood:** possible as either file changes. **Rationale:** H13's exact setup expectation is in Step 3.7.1 and the skills playbook; the root `AGENT_LEARNINGS.md` rule is in `11-agent-learnings.md`; GEMINI references expose a conflict rather than an approved absence rule. **Actionable fix:** list these sites with classifications and searches, and defer the unsupported GEMINI behavior. **Disposition:** Change Surface and Deferred & Debt updated.
- **S3/P3 — Artifact and evidence inventory did not account for all plan-associated records.** **Impact:** low; missing provenance would make later filing/review less reliable. **Likelihood:** possible at finalisation because the artifacts already existed or were planned. **Rationale:** the submitted draft listed research and implementation artifacts but omitted the inline review, prior proposal record, changelog record, and task 9 acceptance evidence. **Actionable fix:** add explicit retained/new rows with owner and verification, and reserve an evidence section in the plan. **Disposition:** integrated in Artifact lifecycle and Implementation Evidence.

**Plan Review Checklist**

- [✅] Completeness: assumptions, scope, tasks, dependencies, and success criteria reconciled.
- [✅] Boundaries: implementation/restatement/guard/historical sites classified; unsupported GEMINI check deferred.
- [✅] Failure modes: non-terminal, backup, interruption, canary, and post-repair outcomes have explicit detection and recovery.
- [✅] Reversibility: repair backups and implementation rollback/checkpoints are defined; no one-way change is selected.
- [✅] Pre-mortem: user-file replacement and canary-environment failure are risked and mitigated.
- [✅] Feasibility: fixture selftests require bash/Git but no live model; live canary remains opt-in; first-consumer acceptance is read-only.

## Current state

- H11 remains WARN on NuBible-App because its existing `project/learnings/workflow/2026-10-13-workflow-read-learning-index-before-work.md` entry has no Source field. The health-check reported it without changing the consumer project; repair is outside this plan's allowlist.
- Deferred & Debt items are routed in `00-project/plans/TODO.md` and remain open; they are not implementation blockers for this bounded subset.
- All tasks and Success Criteria are verified. The package is filed at the recorded destination, and the gate applied the completion marker after final-path checks.

2026-10-14 02:55 (local time) — Execute-and-Confirm Verification (Model: gpt-6-luna)

Implementation verification: VERIFIED
Package filing at confirmation: PENDING (the terminal gate later verified filing; see Terminal Gate Report)

### Verification performed

- Audited every task against the new script, fixture/selftest behavior, setup specification, setup README, Step 3 changes, changelog, troubleshooting entry, learning entry, and current files. Tasks 1–12 and Success Criteria 1–7 match verified evidence. No completion mark was removed or found unsupported.
- `bash scripts/validation/health-check-selftest.sh` → `health-check-selftest: OK`.
- `shellcheck scripts/validation/health-check.sh scripts/validation/health-check-selftest.sh` → no findings; `bash -n` passes for both scripts.
- `bash scripts/validation/check-learnings.sh` → OK (23 rows, 23 entries); `bash scripts/validation/check-learnings-selftest.sh` → OK.
- `bash scripts/validation/check-active-markdown-links.sh` → OK; `bash scripts/validation/check-active-markdown-links-selftest.sh` → OK.
- `bash scripts/validation/check-plan-selftest.sh` → OK; `check-plan.sh --require-tier --state <active plan>` → `OK (T2, state)`.
- `bash scripts/validation/check-meta-logs.sh --staged` → `meta log checks OK` using a temporary `GIT_INDEX_FILE`; the repository's actual index remained unchanged.
- NuBible-App default smoke: exit `0`; H01–H10/H13–H14 PASS, H11 WARN, H12 intentionally skipped; before/after consumer `git status --porcelain` snapshots match. Evidence fingerprint: `70a407515209097ca4e620fdd927db28d964fa996d23982fec8eaea790683905`.
- The live Claude canary was not run: the plan's selftest contract requires a stub and does not require a live model call. The stub verifies default zero calls, opt-in H12 PASS, environment WARN, and precondition FAIL without a call.
- Static review against Design/Failure Modes and engineering standards §1–§3 found no further implementation mismatch. No application/UI files were modified. No commit was created.

### Task-to-verifier coverage

Primary verifier: this execution session (direct verification; no delegation required).

| Task | Files/surfaces checked | Verification evidence |
|---|---|---|
| 1 | `scripts/validation/fixtures/health-check/README.md`; `healthy/**` | 19 fixture cases are documented/materialized; read-only selftest passes |
| 2 | `scripts/validation/health-check.sh` H01–H11/H13–H14 | Fixture selftest, `bash -n`, ShellCheck pass |
| 3 | `scripts/validation/health-check-selftest.sh` | `health-check-selftest: OK`; source fixture snapshots unchanged |
| 4 | `health-check.sh` H05 and backup/atomic handlers | Absent/import-only repairs pass; custom/symlink/directory/backup-failure cases refuse without target mutation |
| 5 | `health-check.sh` H03/H06/H09/H10 handlers | Yes/no, symlink-parent, global-ignore, header-row-preservation, malformed/manual cases pass |
| 6 | `health-check-selftest.sh` repair matrix | Accepted and declined target operations, backups, and per-repair rechecks pass |
| 7 | `health-check.sh` and selftest non-TTY path | Redirected-stdin run reports skip; complete fixture comparison unchanged |
| 8 | `health-check.sh` H12 and stub canary | Default zero calls; opted-in stub PASS; environment WARN; failed precondition skips call |
| 9 | NuBible-App default command and `git status --porcelain` | Exit `0`; H11 WARN recorded; before/after status snapshots identical |
| 10 | `00-project-setup/12-health-check.md`; `00-project-setup/README.md` | Catalog/spec and index row present; active Markdown links pass |
| 11 | `00-project-setup/01-setup-project.md` Step 3 | Automated subset points to health-check; uncovered manual checks remain; active Markdown links pass |
| 12 | Changelog/troubleshooting entries and indexes; H02 learning | Entries/index rows present; learnings check passes; temporary-index `check-meta-logs.sh --staged` passes |
| 13 | This plan's terminal filing pair and `## Artifact lifecycle` | Pair identity/prerequisites were audited; the terminal gate subsequently verified filing at the recorded final path |

### Next step

- No implementation next step remains. Deferred & Debt stays open and is routed in `00-project/plans/TODO.md` for its named triggers.

## Terminal Gate Report

- **Implementation verification:** VERIFIED.
- **Package filing:** VERIFIED.
- **Actual final path:** `00-project/plans-completed/implementation/2026-10-14-consumer-health-check-implementation-plan.md`.
- **Package mapping:** `00-project/plans/2026-10-14-consumer-health-check-implementation-plan.md` → `00-project/plans-completed/implementation/2026-10-14-consumer-health-check-implementation-plan.md`. No other task-exclusive artifacts were moved; the research, live docs, changelog/troubleshooting records, and learning remain at their owning paths.
- **Reconciliation:** deferred debt is in `00-project/plans/TODO.md`; the proposal, implementation changelog, and plan-finalisation changelog link to this archived path.
- **Final checks:** `check-plan.sh --require-tier --state` and scoped/full active Markdown-link checks passed at the archived path. The terminal filing pair was ticked only after those effects were verified.
