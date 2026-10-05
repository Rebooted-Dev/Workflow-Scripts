# Implementation Plan: Consistent plan checkboxes and completion ticks

**Created:** 2026-10-05 15:25
**Status:** ✅ COMPLETED 2026-10-05 — executed and verified in the same session; Workflow-Scripts changes committed and pushed as `28be480` on `v1.82`. Filed to `plans-completed/implementation/` on owner instruction (the host Update-AI-Tools changes remain uncommitted in that repository). See the execution addendum and filing note.
**Tier:** T2

**Consolidated from:** the owner's problem statement of 2026-10-05 (no prior plan document), finalised with `01-planning-and-organizing/02-finalise-plan.md`. There were no inline addenda and no `PLAN.reviews/` directory, so nothing was archived and no source plan was marked superseded.

## Goal

Every plan that the workflows create, update, or execute has a checkbox for each task and criterion, and every box ends an execution either ticked `[✅]` or carrying a written reason for staying open. The owner never has to request a second scan to get the ticks applied.

Success is observable as:

- A new plan without checkbox tasks, or with `[x]` ticks, fails a command the authoring workflow must run.
- An executed plan with a silently unticked task or criterion fails a command the execution chain must run before it reports.
- A plan that arrives without checkboxes (for example a Cursor `.plan.md`) gains them before it is executed or archived.

## Scope and non-goals

In scope: the plan contract, `check-plan.sh`, the planning and code-build workflows, the terminal gate, the two related skills, the policy validators, the pre-commit hook, the project-setup template, and the Update-AI-Tools host copy of the affected conventions.

Not in scope:

- Retrofitting ticks or checkboxes into plans already archived. They stay as historical records.
- Verifying that a tick is *true*. That remains the job of the Verification Bar and the gate; this plan only removes silent omissions.
- Refreshing hosts other than Update-AI-Tools (see Deferred & Debt).
- A harness hook that ticks boxes automatically (see Decision, Option C).

## Findings

All findings are `observed` (reproduced locally on 2026-10-05, Workflow-Scripts `v1.82` at `2cd0a55`, clean tree) unless labelled otherwise.

| # | Finding | Evidence |
|---|---|---|
| F1 | A plan with no `**Tier:**` header is treated as legacy and passes the linter, so it needs no checkboxes at all. | `check-plan.sh` on a tier-less plan with plain numbered tasks: `warning: no **Tier:** header; treating as legacy`, exit 0. `Tier: T1` without bold does the same. |
| F2 | The authoring workflows never run the linter. `00-research-and-plan.md` does not mention it; `02-finalise-plan.md` says to "reference" it; `01-plan-review.md` does not run it. Only `01-execution.md` Preparation runs it, after the plan is already written. | `grep -rn check-plan` across the workflow directories. |
| F3 | The linter accepts `[x]` and `[X]` as valid, while every workflow requires `[✅]`. Nothing flags the difference. | A T1 plan with `1. [x] …` returns `OK (T1)`. Five plans filed 2026-10-02 to 2026-10-04 use `[x]` (17 boxes). |
| F4 | `## Success Criteria` checkboxes have no owner. The template calls them "criteria, not tasks"; `01-execution`, `02-confirm-execution`, and the gate only name tasks and sub-tasks. | Every executed tiered plan sampled has open criteria next to ticked tasks: v3 reliability plan 6 open / 2 ticked, hardening plan 1 / 8, opencode2 plan 3 / 2, Homebrew overlap plan 6 / 2. |
| F5 | Nothing checks tick state after execution. `03-execute-and-confirm.md` step 4 says "re-read the plan's task list"; there is no command. | `check-plan.sh` on a plan with every task ticked and an open criterion: `OK (T1)`. No validator has a state mode. |
| F6 | An unticked box cannot be told apart from a forgotten one. Two plans were archived as `CLOSED` with open tasks that the status line says were retired. | `project/plans-completed/implementation/2026-10-02-…-v3-plan.md` (12 open tasks) and `2026-10-03-…-meta-plan.md` (6 open tasks) in Update-AI-Tools. |
| F7 | Plans written outside the workflows keep their own format when filed. `02-confirm-execution.md` tells the agent to add an addendum instead of checkboxes, and "file … as completed" moves the file without running the gate. | `2026-10-02-quiet-brew-update-noise.plan.md` (YAML `todos:` with `status: completed`, no checkboxes) and `2026-10-02-update-pipeline-performance-execution-plan.md` (numbered prose, no checkboxes), both archived as completed. |
| F8 | Two active documents still state the pre-fix rule that the 2026-09-25 fix removed. | `glossary.md:48` says `01-execution` "may mark"; `README.md:933` calls the gate the "sole ✅/marker/archive owner". |
| F9 | The tick rule exists only inside workflow files. The host `AGENTS.md` says to follow a workflow "only when it was selected", so "execute the plan" without naming a workflow loads no tick rule. | `AGENTS.md` and `PROJECT.md` in Update-AI-Tools contain no plan-marking rule; the setup template's AGENTS block has none either. |
| F10 | When execution is delegated, no rule says who writes the ticks. Plan review has a single-writer rule; execution does not. | `hypothesis` as a cause: no failing run was traced to it. Verify by checking the next delegated execution. |

What already works: tiered plans executed through `01-execution.md` do get task ticks (the v3 plan went from 1 to 10 ticked tasks in its implementation commit `ff6fcff`). The 2026-09-25 fix holds. The remaining misses are F1–F9.

## Assumptions

- `[✅]` stays the only completion mark (confirm by: `glossary.md:54` records this as intentional for readability).
- Host projects reach the linter through their Workflow-Scripts checkout or symlink (confirm by: `Shared-Links/Workflow-Scripts/scripts/validation/check-plan.sh` resolves in Update-AI-Tools).
- Hosts will accept one extra indented `Open:` line under an unticked task (confirm by: owner review of Decision D2).

## Change Surface

| Behavior | Sites (file:line) | Class | Found with |
|---|---|---|---|
| Task checkbox syntax and criteria status | `00-Meta-Workflow/00-meta/plan-template.md:13`, `:81`, `:98`, `:103`, `:107`, `:117` | implements | `grep -nE "\[ \]\|Tier\|check-plan" 00-Meta-Workflow/00-meta/plan-template.md` |
| Structural lint, legacy exemption, accepted markers | `scripts/validation/check-plan.sh:52-55`, `:102`, `:294` | guards | `grep -nE "LEGACY\|marker !=\|no top-level" scripts/validation/check-plan.sh` |
| Linter regression fixtures | `scripts/validation/check-plan-selftest.sh:30-49`, `scripts/validation/fixtures/check-plan/` | guards | `ls scripts/validation/fixtures/check-plan` |
| Plan authoring without a lint run | `01-planning-and-organizing/00-research-and-plan.md:142`, `:207`; `02-finalise-plan.md:43`, `:72`; `01-plan-review.md:17`, `:30`; `03-plan-review-and-finalise.md:17` | implements | `grep -rn "check-plan\|plan-template" 01-planning-and-organizing` |
| Tick on verification | `02-code-build/01-execution.md:20`, `:22`, `:48`, `:50`, `:73`, `:89`, `:100` | implements | `grep -n "✅" 02-code-build/01-execution.md` |
| Audit ticks; addendum instead of checkboxes | `02-code-build/02-confirm-execution.md:61-65`, `:68`, `:83` | implements | `grep -n "✅\|task list syntax" 02-code-build/02-confirm-execution.md` |
| Final tick check by re-reading | `02-code-build/03-execute-and-confirm.md:27`, `:44`, `:52` | implements | `grep -n "\[ \]" 02-code-build/03-execute-and-confirm.md` |
| Gate task extraction and write-back | `04-documentation/03-mark-completed.md:107`, `:140`, `:168-170`, `:203` | implements | `grep -n "✅" 04-documentation/03-mark-completed.md` |
| Pointers to the marking rule from other plan-touching workflows | `03-debugging/02-bug-fix-workflow.md:133`, `06-security/02-security-fix.md:106`, `05-review/05-comprehensive-audit.md:73` | restates | `grep -rnE "plans/\|mark-completed" 03-debugging 05-review 06-security` |
| Skills that restate the chain | `11-Skills/execute-and-confirm-plan/SKILL.md:20`, `:39`, `:41`; `11-Skills/workflow-plan-review-finalize/SKILL.md:38` | restates | `grep -rn "✅\|plan-template" 11-Skills` |
| Stale pre-fix wording | `00-Meta-Workflow/00-meta/glossary.md:48`; `README.md:933` | restates | `grep -nE "may mark\|sole ✅" README.md 00-Meta-Workflow/00-meta/glossary.md` |
| Correct wording to keep aligned | `README.md:378`, `:389`; `02-code-build/README.md:37`, `:59` | restates | `grep -n "✅" README.md 02-code-build/README.md` |
| Policy regression guard | `scripts/validation/check-completion-chain-policy.sh:70` | guards | `grep -n "tick" scripts/validation/check-completion-chain-policy.sh` |
| Pre-commit plan lint, tiered active plans only | `scripts/hooks/pre-commit:15`, `:28-30` | guards | `grep -n "check-plan\|00-project/plans" scripts/hooks/pre-commit` |
| Host always-on rules and "file as completed" | `00-project-setup/01-setup-project.md:168-172`, `:284-296`, `:535`, `:614-618`; `00-project/plans-completed/README.md:40` | implements | `grep -nE "marking convention\|file .* as completed" 00-project-setup/01-setup-project.md` |
| Earlier fix and its record | `00-project/troubleshooting/workflow/2026-09-25-workflow-verified-tasks-never-ticked.md`; `00-project/changelog/fixed/2026-09-25-fixed-completion-chain-task-ticking.md` | historical | `ls 00-project/troubleshooting/workflow` |

## Decision

- **Option A (minimal):** wording only. Correct the two stale lines, state that criteria are ticked, and tell the authoring workflows to run the existing linter. Cheap and low risk. It leaves F3, F5, F6, and F7 open, and it repeats the approach of the 2026-09-25 fix, which improved the wording and still left misses.
- **Option B:** one marking contract plus commands that enforce it. Extend `check-plan.sh` with strict markers, a required-tier flag, and a state mode; make each workflow run the matching command at authoring, update, phase end, and the gate; convert plans that arrive without checkboxes. Costs a moderate change to one script and about fifteen documents, and existing tiered plans that use `[x]` will fail until corrected.
- **Option C:** a harness hook that edits the plan when a task verifies. Works only in harnesses with hooks, and moves the decision away from the agent that holds the evidence.
- **Chosen:** Option B. The misses are omissions that instructions alone have not prevented, and a failing command is the one signal an agent reliably acts on before reporting. **Reversibility:** cheap. The new behaviour sits behind new flags and one marker rule; reverting the commits restores the current state.

Defaults selected for the open choices, each open to owner override at review:

- **D1 — `[x]` in a tiered plan:** fail the lint, with a message naming the line. No automatic rewrite, because `[x]` is an unverified claim and the gate decides whether it becomes `[✅]`.
- **D2 — unticked boxes after execution:** each one needs a reason on an indented `Open:` line, using one of `pending`, `blocked`, `deferred`, or `retired`. An `Open:` line directly under a phase heading covers every unticked task in that phase.
- **D3 — tier-less plans:** the default stays lenient so old plans keep passing. Authoring and execution-intake steps pass `--require-tier`.

## Design & Interfaces

**Marking contract (single source: `plan-template.md`).** A box is in one of two states. `[✅]` means verified complete. `[ ]` means not complete, and once execution has started it carries an `Open:` reason. This applies to tasks, sub-tasks, and `## Success Criteria` items. Criteria still need no `Files:` or `Verify:` lines. All other documents link to this section and do not restate it.

**`check-plan.sh` interface.** Existing calls keep their behaviour except for the D1 marker rule.

| Invocation | Checks | Used by |
|---|---|---|
| `check-plan.sh <plan>` | Current structure checks, plus: `[x]`, `[X]`, `[✓]` in `## Tasks` or `## Success Criteria` fail in a tiered plan | Any edit to a plan; pre-commit |
| `check-plan.sh --require-tier <plan>` | As above, and a missing `**Tier:**` header fails | Authoring, review, finalise, execution intake |
| `check-plan.sh --state <plan>` | As the first row, plus: every unticked task or criterion has an `Open:` reason (own line or phase line); a ticked parent has no unticked child | Phase report, confirm, gate, pre-commit for archived plans |

Exit codes stay 0 (pass), 1 (violations, one line each with the plan line number), 2 (usage).

**Who writes ticks.** The agent that ran the verification ticks the box in the same step. When work is delegated, the orchestrator is the only writer of the plan file and sub-agents return evidence. The gate reconciles; it is not the first place ticks appear.

**Plans without checkboxes.** Before executing or archiving such a plan, the agent adds a `## Tasks` section with one checkbox per step or per YAML todo, leaves the original prose in place, and adds the `**Tier:**` header. Completed todos become `[✅]` only after the gate verifies them.

**Invariants and enforcement.**

- No tiered plan contains a non-canonical tick: enforced by the default lint.
- No execution reports while a box is silently open: enforced by `--state` in the phase report, the confirm step, and the gate.
- No plan is archived with a silent open box: enforced by the gate and by pre-commit on files added under `00-project/plans-completed/`.

## Failure Modes & Recovery

| Failure | Detection | User sees | Recovery |
|---|---|---|---|
| An existing tiered plan uses `[x]` and now fails the lint | `check-plan.sh` exit 1 naming each line | Execution Preparation stops with the line list | Verify each item and change it to `[✅]`, or reset it to `[ ]` |
| An agent adds `Open: pending` to everything to pass `--state` | `02-confirm-execution` and the gate verify every task regardless of mark | Gate ticks the verified ones and reports the mismatch | Gate output lists them; no manual scan needed |
| `--state` is run on a draft plan | Every task reported as missing `Open:` | A long failure list before execution starts | Workflows call `--state` only from the phase report onward; the usage text says so |
| The `Open:` parser misreads nested or oddly indented lines | New fixtures in the self-test | Self-test fails in CI and pre-commit | Fix the parser; the default lint path is unaffected |
| A host has no Workflow-Scripts checkout at the expected path | Command not found | The step cannot run | The workflow records it as a blocked check and performs the same checks by reading; the host adds the path to `PROJECT.md` |
| Converting a non-checkbox plan loses or changes its content | Diff review at the intake step | Extra `## Tasks` section only | Conversion is additive; revert the one hunk |

## Test Strategy

- **Linter self-test:** `bash scripts/validation/check-plan-selftest.sh` with new fixtures for each rule: `[x]` fails; missing tier fails only with `--require-tier`; silent open task fails `--state`; task with `Open:` passes; phase-level `Open:` passes; open criterion fails; ticked parent with open child fails. All twenty existing fixtures keep their current result.
- **Policy validators:** `bash scripts/validation/check-completion-chain-policy.sh` and `bash scripts/validation/check-planning-build-policy.sh` pass on the changed tree. Negative check: run the updated completion-chain validator against a `git archive HEAD` copy of the pre-change documents and confirm it fails.
- **Real-plan replay:** run the new modes against the Update-AI-Tools plans named in Findings and confirm each known defect is reported (F3, F4, F6).
- **Links and logs:** `bash scripts/validation/check-active-markdown-links.sh` reports no new failures (one failure predates this plan, in `00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15`); `bash scripts/validation/check-meta-logs.sh --staged` passes.
- **Acceptance smoke:** execute one small tiered plan end to end through `03-execute-and-confirm.md` and confirm it ends with no silent open box and no follow-up scan.

## Rollout & Rollback

Rollout follows the phase order. Phases 1 and 2 land together, because the contract and the linter must agree. Phases 3 and 4 follow as one commit each, so a wording problem can be reverted without touching the script. Phase 5 turns on the guards last, after the documents they check are in place. Every project that uses Workflow-Scripts picks the change up on its next pull; only Update-AI-Tools gets its host conventions refreshed in this plan.

Rollback: revert the phase commits in reverse order. The linter change is the only behavioural one; reverting it restores `[x]` acceptance and removes the two flags. No data migration is involved, and plans that gained `Open:` lines remain valid under the old linter.

## Tasks

### Phase 1: Marking contract

Entry: plan approved. Exit: one contract section exists and no active document contradicts it.

1. [✅] Add a "Marking Contract" section to the plan template (P1, Effort: S)
   - Files: `00-Meta-Workflow/00-meta/plan-template.md`
   - Verify: `grep -n "Marking Contract" 00-Meta-Workflow/00-meta/plan-template.md` → one heading; the section covers the two states, the `Open:` reason and its four values, the phase-level form, and that Success Criteria are status-tracked; the legacy paragraph names `--require-tier` (cost/prereqs: none)
2. [✅] Correct the two stale statements of the pre-fix rule (P1, Effort: S)
   - Files: `00-Meta-Workflow/00-meta/glossary.md`, `README.md`
   - Verify: `grep -nE "may mark|sole ✅" README.md 00-Meta-Workflow/00-meta/glossary.md` → no output (cost/prereqs: none)

### Phase 2: Linter enforcement

Entry: Phase 1 contract text agreed. Exit: self-test passes with the new fixtures.

1. [✅] Reject non-canonical ticks in tiered plans and add `--require-tier` (P1, Effort: M)
   - Files: `scripts/validation/check-plan.sh`, `scripts/validation/check-plan-selftest.sh`, `scripts/validation/fixtures/check-plan/`
   - Verify: `bash scripts/validation/check-plan-selftest.sh` → `check-plan self-test OK`, including new fixtures for `[x]` (fail) and tier-less with and without the flag (fail, pass) (cost/prereqs: none)
2. [✅] Add `--state` mode for silent open boxes (P1, Effort: M)
   - Files: `scripts/validation/check-plan.sh`, `scripts/validation/check-plan-selftest.sh`, `scripts/validation/fixtures/check-plan/`
   - Verify: `bash scripts/validation/check-plan-selftest.sh` → OK with fixtures for silent open task, task `Open:`, phase `Open:`, open criterion, and ticked parent with open child (cost/prereqs: none)
3. [✅] Replay the new modes against real plans (P2, Effort: S)
   - Files: none changed; evidence recorded in this plan's execution addendum
   - Verify: `--state` on the Update-AI-Tools v3 reliability plan reports its open tasks and criteria; default lint on a 2026-10-04 `[x]` plan given a Tier header reports each `[x]` line (cost/prereqs: Update-AI-Tools checkout; run on copies in a scratch directory)

### Phase 3: Authoring and update workflows

Entry: Phase 2 flags exist. Exit: every workflow that writes or edits a plan runs the lint and says so in its acceptance criteria.

1. [✅] Make research-and-plan and finalise-plan run the lint (P1, Effort: S)
   - Files: `01-planning-and-organizing/00-research-and-plan.md`, `01-planning-and-organizing/02-finalise-plan.md`, `01-planning-and-organizing/03-plan-review-and-finalise.md`
   - Verify: `grep -n "check-plan.sh --require-tier" 01-planning-and-organizing/*.md` → a run step and an acceptance criterion in `00` and `02`; `03` verifies the result (cost/prereqs: none)
2. [✅] Make plan review lint the plan before and after its addendum (P1, Effort: S)
   - Files: `01-planning-and-organizing/01-plan-review.md`
   - Verify: the Steps list runs `check-plan.sh --require-tier` on intake and again after writing; new tasks proposed by a review are written as checkbox tasks under `## Tasks` when the reviewer edits the plan (cost/prereqs: none)
3. [✅] State where the linter lives for host projects (P2, Effort: S)
   - Files: `00-Meta-Workflow/00-meta/naming-conventions.md`, `02-code-build/01-execution.md`
   - Verify: `grep -rn "<workflow-scripts>" 0*/ 1*/` → every use links to one definition that resolves it to the checkout containing the workflow being followed (cost/prereqs: none)
4. [✅] Point the other plan-touching workflows at the contract (P2, Effort: S)
   - Files: `03-debugging/02-bug-fix-workflow.md`, `06-security/02-security-fix.md`, `05-review/05-comprehensive-audit.md`
   - Verify: each names the plan template for a plan it creates and the lint for a plan it edits; none restates the marking rule (cost/prereqs: none)

### Phase 4: Execution chain

Entry: Phases 1–3 landed. Exit: the chain cannot report with a silent open box.

1. [✅] Require ticks, criteria, and a state check in the execution workflow (P0, Effort: M)
   - Files: `02-code-build/01-execution.md`
   - Verify: the phase report ticks criteria as well as tasks, writes an `Open:` reason on anything left unticked, and runs `check-plan.sh --state`; Preparation runs `--require-tier`; the delegation bullet names the orchestrator as the only plan writer; the Quick Checklist matches (cost/prereqs: none)
2. [✅] Convert plans without checkboxes at intake (P1, Effort: M)
   - Files: `02-code-build/01-execution.md`, `02-code-build/02-confirm-execution.md`, `04-documentation/03-mark-completed.md`
   - Verify: `grep -n "does not use task list syntax" 02-code-build/02-confirm-execution.md` → no output; all three describe the additive `## Tasks` conversion, including YAML `todos:` (cost/prereqs: none)
3. [✅] Extend confirm and the gate to criteria and the state check (P1, Effort: M)
   - Files: `02-code-build/02-confirm-execution.md`, `04-documentation/03-mark-completed.md`
   - Verify: both list Success Criteria in scope; the gate's Phase 4 write-back and Acceptance Criteria require `check-plan.sh --state` to pass in both modes; a retired or deferred task keeps `[ ]` with its `Open:` reason (cost/prereqs: none)
4. [✅] Replace the re-read step with the command in the combined workflows and skills (P1, Effort: S)
   - Files: `02-code-build/03-execute-and-confirm.md`, `02-code-build/04-review-finalise-commit-execute.md`, `02-code-build/README.md`, `11-Skills/execute-and-confirm-plan/SKILL.md`, `11-Skills/workflow-plan-review-finalize/SKILL.md`
   - Verify: `grep -rl "check-plan.sh --state" 02-code-build 11-Skills` → all four code-build files and the execution skill; the planning skill names `--require-tier` instead, since it never executes; step 4 of `03` names the command and its expected `OK` (cost/prereqs: none)

### Phase 5: Guards and rollout

Entry: Phase 4 landed. Exit: regressions fail CI or pre-commit, and the host template carries the rule.

1. [✅] Add regression checks to the completion-chain policy validator (P1, Effort: S)
   - Files: `scripts/validation/check-completion-chain-policy.sh`
   - Verify: `check-completion-chain-policy.sh` and `check-planning-build-policy.sh` pass on the changed tree; the completion-chain validator fails on a `git archive HEAD` copy of the pre-change tree (cost/prereqs: none)
   - Revised during execution: all new guards went into the completion-chain validator (section 9). The planning-build validator runs against copied fixture roots, so adding guards there meant rebuilding its fixtures for no extra coverage.
2. [✅] Lint archived plans at commit (P2, Effort: S)
   - Files: `scripts/hooks/pre-commit`
   - Verify: staging a tiered plan with a silent open task under `00-project/plans-completed/` → commit refused with the `--state` message; an untiered archived plan is unaffected (cost/prereqs: `git config core.hooksPath scripts/hooks`, already set in this clone; test in a scratch clone)
3. [✅] Add an always-on plan-status rule and gated filing to the setup template (P1, Effort: M)
   - Files: `00-project-setup/01-setup-project.md`, `00-project/plans-completed/README.md`
   - Verify: the AGENTS block in Step 1.2 has a plan-status rule that applies whether or not a workflow was named; "file … as completed" runs the gate, or at least `check-plan.sh --state`, before the move (cost/prereqs: none)
4. [✅] Refresh the Update-AI-Tools host conventions (P2, Effort: S)
   - Files: `AGENTS.md` and `docs/agents/changelog-and-troubleshooting.md` in the Update-AI-Tools repository
   - Verify: `grep -n "check-plan.sh --state" AGENTS.md docs/agents/changelog-and-troubleshooting.md` from the host root → present; logged in the host's `project/changelog/` (cost/prereqs: separate commit in the host repository)
   - Revised during execution: the draft made this wait for owner approval. The owner's goal for the session required the fix to be applied, not only planned, so the two instruction files were edited and left uncommitted for review.
5. [✅] Record the fix and run the acceptance smoke (P1, Effort: S)
   - Files: `00-project/changelog/fixed/`, `00-project/troubleshooting/workflow/`, both index files, `00-project/plans/TODO.md`
   - Verify: `bash scripts/validation/check-meta-logs.sh --staged` passes; one real tiered plan run through the execution chain ends with `check-plan.sh --state` OK and no follow-up scan (cost/prereqs: a real plan to execute; this plan served as that run)

## Dependencies

- Phase 2 depends on the contract wording in Phase 1; the linter messages quote it.
- Phases 3 and 4 depend on the Phase 2 flags existing, or their run steps would name commands that fail.
- Phase 5 task 1 depends on Phases 3 and 4, because the validators assert the new wording.
- Phase 5 task 4 depends on task 3 and on owner approval, since it changes a second repository.

## Deferred & Debt

- Refresh of other host projects' `AGENTS.md` and conventions — each host repository — trigger: next setup or update run in that host — S3.
- Automatic tick through a harness hook (Option C) — per-harness configuration — trigger: a silent open box reaches the owner after this plan ships — S3.
- Retrofitting archived plans — `plans-completed/` in each repository — trigger: an archived plan is reopened — S3.
- Applying `--state` to hosts' own pre-commit hooks — host repositories — trigger: Phase 5 task 2 proves stable here — S3.

## Risks

| Risk | Impact (Low/Medium/High) | Likelihood (Rare/Possible/Likely) | Severity (S0–S3) | Mitigation |
|---|---|---|---|---|
| The `[x]` rule breaks an in-flight tiered plan in a host | Medium | Likely | S2 | The message names each line; correction is one edit per box; announced in the changelog entry |
| `Open:` reasons become filler that hides real misses | Medium | Possible | S2 | Confirm and the gate still verify every task; the smoke in Phase 5 task 5 checks one real run |
| More required commands lengthen every planning run | Low | Likely | S3 | One command per step, sub-second on a plan file |
| Agents in harnesses that never load the workflows still skip the rule | Medium | Possible | S2 | The always-on AGENTS rule in Phase 5 task 3; hook option kept as debt |

## Success Criteria

- [✅] `check-plan.sh --require-tier` fails a plan with no checkbox task and a plan with no Tier header.
- [✅] `check-plan.sh` fails a tiered plan that uses `[x]`.
- [✅] `check-plan.sh --state` fails a plan with an unticked task or criterion that has no `Open:` reason.
- [✅] Authoring, review, execution, confirm, and gate workflows each name the command they must run.
- [✅] No active document states that only the gate may tick, or that execution "may" tick.
- [✅] One real plan executed end to end finishes with no silent open box and no follow-up scan.
- [✅] `bash scripts/validation/check-plan.sh` reports `OK (T2)` for this file.

## Execution and verification addendum — 2026-10-05 16:10 (Claude Opus 5.5)

## Current state

No open recommendations. All 18 tasks and 7 success criteria are verified. Nothing is committed: the owner reviews and commits Workflow-Scripts and Update-AI-Tools separately. Defaults D1–D3 were applied as written and remain open to owner override.

### What was run

| Check | Result |
|---|---|
| `bash scripts/validation/check-plan-selftest.sh` | `check-plan self-test OK` — 20 existing fixtures unchanged, 9 new fixtures, 13 new assertions, unknown-flag exit code |
| `bash scripts/validation/check-completion-chain-policy.sh` | `completion chain policy checks OK` |
| Same validator against a `git archive HEAD` copy of the pre-change tree | fails: `plan-template.md lacks the Marking Contract section` |
| `bash scripts/validation/check-planning-build-policy.sh` and its self-test | both OK |
| `bash scripts/validation/check-meta-logs-selftest.sh`, `check-review-workflow-policy.sh` | both OK |
| `bash scripts/validation/check-active-markdown-links.sh` | one failure, the same one as before this plan (`00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15`); none added |
| `scripts/hooks/pre-commit` in a scratch clone | refuses a tiered archived plan with a silent open task; accepts one with `Open:` reasons; ignores an untiered archived plan |
| `check-plan.sh --state` on a copy of the Update-AI-Tools v3 reliability plan | reports 18 lines: its 12 open tasks and 6 open criteria |
| `check-plan.sh` on a copy of the Homebrew overlap plan | reports its two `[x]` criteria (lines 462, 464) |
| `check-plan.sh --state` on the active Update-AI-Tools hardening plan | reports its two open tasks and one open criterion |
| `check-plan.sh --state` on this plan | `OK (T2, state)` |

### Change Surface re-run

Every search in the Change Surface table was re-run after the build. `may mark` and `sole ✅` return nothing. `does not use task list syntax, add an addendum` returns nothing. `<workflow-scripts>` now resolves through one definition in `naming-conventions.md`. The historical rows are unchanged, as intended.

### Mismatches and limits

- Task 5.1 and task 4.4 were revised to match what was built; the reasons are on the tasks.
- Task 5.4 was done without the separate approval the draft asked for; the reason is on the task.
- The acceptance smoke used this plan as the real run. A second, unrelated plan has not yet been executed under the new rules, so the first such run in a host project is the remaining real-world confirmation.
- F10 (delegated execution) stays a hypothesis. The single-writer rule was added because it is cheap; no failing run was traced to its absence.
- The linter checks that a box is ticked or explained. It cannot tell whether a tick is true; confirmation and the gate still own that.
- Existing tiered plans that use `[x]` now fail the default lint until corrected. In Update-AI-Tools that is `project/plans/wrap-up/2026-10-02-homebrew-overlap-experiments-implementation-plan.md`.

### Rollback reference

Workflow-Scripts base is `2cd0a55` on `v1.82`. The implementation is commit `28be480`; roll back with `git revert 28be480` (or reset to `2cd0a55` before the commit is shared). The edits are additive, and plans that gained `Open:` lines remain valid under the old linter.

## Filing note — 2026-10-05 (owner-instructed)

Filed via `04-documentation/03-mark-completed.md` on owner instruction. Workflow-Scripts changes were committed and pushed as `28be480` on `v1.82`; this plan moved from `plans/` to `plans-completed/implementation/`, `plans-completed/index.md` gained a top row, and `changelog/index.md` gained a Type=`plan` row. `check-plan.sh --state` re-ran green on the archived file. The host Update-AI-Tools edits to `AGENTS.md` and `docs/agents/changelog-and-troubleshooting.md` remain in that repository's working tree, uncommitted alongside unrelated owner changes.
