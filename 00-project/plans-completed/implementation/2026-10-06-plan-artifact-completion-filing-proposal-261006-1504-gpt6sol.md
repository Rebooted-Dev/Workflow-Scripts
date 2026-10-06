2026-10-06 15:45

# Plan-Artifact Completion Filing — Implementation Plan and Retained Proposal

**Created for execution:** 2026-10-06 15:45 (+08)
**Status:** ✅ COMPLETED
**Implementation verification:** VERIFIED
**Package filing:** VERIFIED
**Actual current plan path:** `00-project/plans-completed/implementation/2026-10-06-plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md`
**Tier:** T3
**Execution baseline:** `844fa6c6fb74f0f413b9668e14a4224d6a39b738`, `v1.82`.
**Workflow:** `02-code-build/03-execute-and-confirm.md`; no commit/push authorized.
**Provenance:** The user moved the previously filed proposal from `00-project/research/` to this named plan path, then authorized execute-and-confirm. Conversion is additive; the historical proposal remains below. Its research-only status/baseline describe the earlier investigation, not current execution.

## Goal

Generated/finalised plans account for their associated artifacts, and the existing terminal gate files task-exclusive historical material after verified implementation. Completed packages have accounted-for artifacts, repaired links/indexes and truthful filing status, without moving live/shared records or requiring a new archive engine.

## Scope and non-goals

Adopt the proposal's minimal lifecycle contract, planning/build handoffs, completion sequencing and scoped archived-link verification. Preserve host-policy routing, canonical documentation, existing two modes, debt rules, default link-scan behavior, and task verification. No automatic mover, mandatory separate manifest, new closure mode, zip bundles, consumer-application changes, archive-wide historical cleanup, staging, commits or pushes.

A small enabling hygiene correction is included: replace the existing escaped-root hyperlink in `00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15` with an explicitly external historical locator, preserving its provenance rather than weakening the checker. Repair the proposal's moved-path inbound changelog link. These known failures would otherwise obscure the required repository link gate.

## Change Surface

Paths are repository-root-relative; re-run these searches before phase reports. Comments/example text are restatements, active prose implements agent behavior, validators/tests guard it, and this retained proposal is historical evidence.

| Behavior | Sites | Class | Search |
|---|---|---|---|
| Shared task/marking contract | `00-Meta-Workflow/00-meta/plan-template.md:101–131` | implements | `rg -n 'Task and Decision|Marking Contract|Success Criteria|Files:|Verify:' 00-Meta-Workflow/00-meta/plan-template.md` |
| Research/generation/review/finalisation handoff | `01-planning-and-organizing/*.md` | implements | `rg -n 'template|archive|reviews|Output|Acceptance|artifact' 01-planning-and-organizing` |
| Execution/confirmation/wrapper authority | `02-code-build/*.md` | implements | `rg -n 'Terminal|gate|Verified Complete|Not Eligible|archive|state' 02-code-build` |
| Terminal filing/status/debt | `04-documentation/03-mark-completed.md:6–17,150–173,198–213`; directory README | implements | `rg -n 'Full completion|Reconcile only|Phase 4|policy unresolved|State check|Deferred|Completion marker' 04-documentation/03-mark-completed.md 04-documentation/README.md` |
| Owner routing and local filing guidance | `00-Meta-Workflow/00-meta/naming-conventions.md:44–73`; `00-project/docs/agents/changelog-and-troubleshooting.md:49–59`; `00-project/plans-completed/README.md:35–44` | implements | `rg -n 'archive|completed|filing|owner|Move|gate' 00-Meta-Workflow/00-meta/naming-conventions.md 00-project/docs/agents/changelog-and-troubleshooting.md 00-project/plans-completed/README.md` |
| Link/check policy and fixtures | `scripts/validation/check-active-markdown-links.sh`; `check-completion-chain-policy.sh`; `check-planning-build-policy*.sh`; `.github/workflows/validation.yml`; `scripts/hooks/pre-commit` | guards | `rg -n 'skipPath|self-test|scope|root|archive|step 3|state|validation/check-' scripts/validation/check-active-markdown-links.sh scripts/validation/check-completion-chain-policy.sh scripts/validation/check-planning-build-policy*.sh .github/workflows/validation.yml scripts/hooks/pre-commit` |
| Proposal references and original escaped-root failure | `00-project/changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md:8`; `00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15`; retained proposal below | historical | `rg -n 'proposal-261006|Personal/Update-AI-Tools' 00-project/changelog 00-project/plans/README.md 00-project/plans/TODO.md` |

## Decision

- **Option A (minimal):** Inline inventory plus explicit terminal task/criterion, existing gate filing, existing link checker extended with explicit scope and policy/selftest regressions. Inventory/disk coverage remains gate evidence, not a manifest parser.
- **Option B:** New manifest format, archive mover and bundle hierarchy with automatic relocation. Adds tooling/policy not needed for agent-driven filing.
- **Chosen:** A. **Reversibility:** cheap reviewed document/script diff; no irreversible migration. Default checker scope stays unchanged.

## Design & Interfaces

The independent design review (@oracle, 2026-10-06) approved the MVP before implementation planning, with the following concrete choices:

- Canonical lifecycle rules live in `plan-template.md`; task fields and inventories stay small enough for T1. Inventory columns: source locator, owner repository, relationship, disposition/exact destination or retained reason, verification. Sources are code-form provenance; working final references are Markdown links rebased after moving.
- Exactly one explicitly gate-owned terminal filing task and one paired filing criterion may be excluded from implementation-entry eligibility. Normal docs/tests/acceptance/tool-building obligations and deferred scoped work are not excluded. Filing boxes remain unchecked until concrete filing effects verify.
- Keep Phase 4 step numbering: perform steps 1,2,4,5,6,7 before deferred step 3. Step 6 reconciles status without final completion marker; step 7 validates current path with `--require-tier --state`. Step 3 moves/account-verifies, ticks filing boxes, applies final marker and rechecks final path. Reconcile-only table includes step 7.
- Gate reports `Implementation verification: VERIFIED/NOT VERIFIED` and `Package filing: PENDING/BLOCKED/PARTIAL/VERIFIED`. Final COMPLETED requires both verified. Missing policy/failing move/link leaves filing unchecked and reports actual locations; no false completion or new closure mode.
- Link checker gains `--root <repository-root>` and repeatable `--scope <file-or-directory>`. Explicit scopes include archives skipped by default, stay within the selected root, fail on missing/unreadable/escaped scopes, and remain read-only. Default scan and existing self-test stay compatible. It checks files/relative targets, not anchors, artifact inventory semantics or automatic discovery of every inbound consumer. Gate must separately account for inventory/indexes/incoming references.
- No overwrite or duplicate rows on resume: source-only may move; destination-only must match recorded artifact; both/neither blocks investigation. Privacy/active-consumer decisions precede moving. Cross-repo/shared/live records remain linked in their owner's canonical location.

## Failure Modes & Recovery

| Failure | Detection | Recovery |
|---|---|---|
| Pending filing boxes block their own gate | policy regression and tiny-plan rehearsal | exempt only designated task/criterion from entry; never pre-tick |
| Missing policy or partial move | mappings/disk check | filing BLOCKED/PARTIAL; record locations; explicit safe resume |
| Broken inbound/outbound links | scoped/final global link checks | repair references before verified filing; don't hide historical failures |
| Shared research or live docs swept into archive | inventory disposition/active-consumer review | retain canonical path with reason and link |
| Checker scope escape/missing path | isolated CLI regression | fail closed without walking unintended root |

## Test Strategy

Verification owner: orchestrator; single plan writer. Independent implementation lanes return evidence, not plan edits. Baseline: completion/planning/review/orchestrator/update/sync policy checks and existing selftests pass; active links fail on the known moved-proposal target and pre-existing escaped-root link. New regression affordance is scoped link scanning plus policy negative fixtures, not an archive mover.

Run existing CI-equivalent commands from the Workflow-Scripts root: `check-completion-chain-policy.sh`, `check-planning-build-policy.sh`, `check-planning-build-policy-selftest.sh`, `check-plan-selftest.sh`, `check-meta-logs-selftest.sh`, `check-review-workflow-policy.sh`, `check-orchestrator-review.sh`, `check-sync-workflow-scripts.sh`, `check-update-workflows.sh`, `check-active-markdown-links.sh`, all under `scripts/validation/` with `bash`. Add scoped-link and artifact-lifecycle policy selftests. Validate this plan with `bash scripts/validation/check-plan.sh --require-tier --state <current-plan>`. No staged/range meta-log pass will be claimed for uncommitted work; inspect actual log/index pairing directly.

Acceptance uses private fixtures/rehearsal: archived links intentionally broken/pass, missing scope, incoming old path repaired, small plan without research, full task-exclusive artifacts retained/moved with evidence, pending filing boxes, policy-blocked and incomplete implementation, shared/cross-repo/privacy decisions, resumable collision handling. Policy fixtures can test instruction contracts, not prove an agent will always follow prose; final actual filing exercises the declared terminal path. No live providers or consumer apps.

## Rollout & Rollback

Adopt contract/gate and upstream pointers together before reporting new lifecycle supported. Implement validation in independent non-overlapping script scope. Record diff checkpoints; no commits authorized. On failure, fix bounded defects or preserve a truthful blocker; restore only reviewed edits without clobbering the user's moved proposal. File this same plan only after implementation proof and confirmation. Archive preserves original proposal in-place within this file; canonical workflows/logs remain where they are.

## Artifact lifecycle

Source/destination mappings are root-relative and retained even after moves. This plan is the proposal plus executable design and evidence; no independent draft/review/evidence files were created for this effort.

| Source locator | Owner repository | Relationship | Disposition / exact destination or retained reason | Verification |
|---|---|---|---|---|
| `00-project/plans/plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md` (previously `00-project/research/…`) | Workflow-Scripts | historical proposal + executable plan + inline review/evidence | moved → [archived plan](2026-10-06-plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md) | destination exists; both former locations absent; scoped links and pre-mark final-path lint passed |
| `00-project/changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md` | Workflow-Scripts | original research log | retain — [canonical history](../../changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md); repair its final plan locator | present; final locator checked by gate |
| `00-project/changelog/fixed/2026-10-06-fixed-plan-artifact-completion-filing.md` | Workflow-Scripts | adoption/fix log | retain — [canonical changelog](../../changelog/fixed/2026-10-06-fixed-plan-artifact-completion-filing.md) | verified; final locator checked by gate |
| `00-project/changelog/index.md` | Workflow-Scripts | change/completion index | retain — canonical index | fixed row and one newest-first Type=plan completion row verified |
| `00-project/troubleshooting/workflow/2026-10-06-workflow-plan-artifact-completion-filing.md` | Workflow-Scripts | completion handoff/validation defect record | retain — [canonical troubleshooting](../../troubleshooting/workflow/2026-10-06-workflow-plan-artifact-completion-filing.md) | verified; indexed |
| `00-project/troubleshooting/index.md` | Workflow-Scripts | incident index | retain — canonical index | verified fix row present |
| `00-project/plans-completed/index.md` | Workflow-Scripts | completed-plan navigation | retain — canonical index | one newest-first implementation completion row verified |
| `00-project/plans/README.md` and `TODO.md` | Workflow-Scripts | active/completed navigation | retain — canonical task tracking | completed/filed references verified; obsolete active reference removed; unrelated tasks/debt preserved |
| maintained workflow/template/validator/test source set enumerated in execution evidence below | Workflow-Scripts | maintained product sources and regression guards | retain — active product, not historical package material | source coverage verified; exact members recorded below |

## Tasks

### Phase 1: Preparation and executable contract

1. [✅] P1 — Convert the supplied proposal additively, validate it and establish baseline/design evidence (Effort: Small).
   - Files: this plan; read-only source/validator inputs.
   - Verify: `bash scripts/validation/check-plan.sh --require-tier --state 00-project/plans/plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md` → T3 OK; baseline/design/ownership recorded (cost/prereqs: local reads/validators, no commits).

### Phase 2: Independent document and validation lanes

2. [✅] P1 — Adopt canonical lifecycle/gate and planning/build handoffs, keeping terminal ownership singular (Effort: Medium).
   - Files: `00-Meta-Workflow/00-meta/plan-template.md`; `01-planning-and-organizing/*.md`; `02-code-build/*.md`; `04-documentation/03-mark-completed.md`; `04-documentation/README.md`; `00-project/docs/agents/changelog-and-troubleshooting.md`; `00-project/plans-completed/README.md`.
   - Verify: completion/planning/artifact-lifecycle policy checks and post-edit review → paired eligibility, pre/post validation, Reconcile step7, missing-policy status, safe mappings, artifact handoffs and retained debt contract consistent (cost/prereqs: task 3 guards; local documentation source checks).

3. [✅] P1 — Implement scoped archive-aware links and regression/policy coverage without changing default scan behavior (Effort: Medium).
   - Files: `scripts/validation/check-active-markdown-links.sh`; new scoped-link/lifecycle-policy selftests and fixtures; `scripts/validation/check-completion-chain-policy.sh`; CI/hook wiring only if required for durable guard execution.
   - Verify: new selftests plus existing policy/selftests → explicit archived file/directory pass/fail, incoming repair, missing/escaped scope, default exclusions, eligibility/status/order mutations caught; no manifest parser/mover (cost/prereqs: Node/bash, temporary fixture roots).

4. [✅] P1 — Repair known link hygiene, record adoption/fix logs and inventory/navigation evidence (Effort: Small).
   - Files: proposal/historical changelog entries above; new fixed/troubleshooting entries and indexes; `00-project/plans/README.md`; `00-project/plans/TODO.md`; this plan.
   - Verify: full active link check and `git diff --check` → moved proposal links resolve, external historical locator isn't an escaped hyperlink, paired fix logs indexed, no user/consumer changes (cost/prereqs: local git/link checks).

### Phase 3: Verification, confirmation and terminal filing

5. [✅] P1 — Run final CI-equivalent regressions and acceptance rehearsal, and record coverage/checkpoint (Effort: Medium).
   - Files: source/validator test scope above; this plan's evidence.
   - Verify: all Test Strategy commands plus scoped-link/artifact-policy selftests and current plan lint → pass; real fixture filing has correct retained/moved paths, repaired incoming/outgoing links and no pre-ticks; failures remain explicit (cost/prereqs: local Node/bash, private fixtures; no real package installs).

6. [✅] P1 — Confirm every adopted task/criterion against source and evidence; run terminal reconciliation (Effort: Medium).
   - Files: this plan; `02-code-build/02-confirm-execution.md`; named-target `04-documentation/03-mark-completed.md`; canonical logs/navigation.
   - Verify: independent source/evidence coverage + current-path `check-plan.sh --require-tier --state` → all non-filing obligations verified; gate mode and filing maps explicit; any blocker produces Reconcile only (cost/prereqs: local review, existing valid verification evidence).

7. [✅] P2 — Gate-owned terminal filing: move and verify this completed plan package (Effort: Small).
   - Files: Artifact lifecycle inventory; `00-project/plans-completed/index.md`; `00-project/changelog/index.md`; retained original log; active README/TODO references.
   - Verify: recorded mappings match disk; scoped archived/incoming links and full active links pass; indexes nonduplicated; `bash scripts/validation/check-plan.sh --require-tier --state 00-project/plans-completed/implementation/2026-10-06-plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md` → package VERIFIED; tick only after filing effects verify (cost/prereqs: verified tasks 1–6, resolved repository archive policy, local checks).

## Dependencies

Task 1 gates parallel non-overlapping task 2 document and task 3 validator lanes. Logging task 4 follows their results; task 5 verifies merged state; task 6 confirms; gate-owned task 7 is last. Orchestrator owns this plan and status/index reconciliation. Specialists never tick plan boxes. Any discovered required scope change is recorded before execution, not silently added.

## Deferred & Debt

No adopted scope deferred. New closure-with-deferred mode, automated archive moves, structural inventory parsing, zip bundles and broad historical archive validation are excluded. Markdown anchors remain outside the existing checker: check affected anchors manually and never claim automatic anchor coverage.

## Success Criteria

All adopted implementation and terminal filing criteria are verified complete. Historical illustrative checkboxes below are examples, not executable scope.

- [✅] Generated/finalised plans include proportional artifact inventory and explicit paired terminal filing boxes via one canonical contract.
- [✅] Existing execution/confirmation entry points consistently pass artifact/evidence handoffs to the sole terminal gate.
- [✅] Gate orders reconciliation/pre-check before filing, exempts only designated filing boxes from entry, and never labels blocked/partial filing COMPLETED.
- [✅] Explicit archive scopes and incoming-reference checks have passing positive/negative regressions, while default behavior and existing policy checks remain compatible.
- [✅] Canonical/shared/cross-repository records and deferred-work rules remain protected; required fix logs and all CI-equivalent acceptance evidence are present.
- [✅] Terminal filing: this plan package is filed and verified at its exact recorded archive path.

## Execution evidence and confirmation

**2026-10-06 16:49 (+08) — Current state:** tasks 1–6 and the first five criteria are VERIFIED. No open implementation blocker or deferred adopted task remains. Task 7 and its paired criterion stay unchecked pending actual filing. No commit/push or consumer-application change occurred.

### Task-to-verifier coverage

| Task | Responsible verification | Evidence |
|---|---|---|
| 1 | orchestrator | additive T3 conversion; independent @oracle design selection before implementation; `check-plan.sh --require-tier --state` OK |
| 2 | @oracle review; @explorer source confirmation; orchestrator policy checks | canonical inventory/pair; all direct and wrapper handoffs; intake, eligibility, status ordering, partial-path/resume and marking exceptions inspected; all policy guards pass |
| 3 | validator specialist regressions; orchestrator final suite | 31 scoped CLI cases plus legacy built-in invocation; 29 policy mutations plus positive live-copy baseline; private filing rehearsal S1–S5 and S2b; syntax/CLI checks |
| 4 | logging specialist; @explorer scope inspection; orchestrator link/diff check | both known link failures repaired without weakening root guard; fixed/troubleshooting entries and indexes paired; no out-of-scope consumer changes |
| 5 | orchestrator | final merged CI-equivalent suite below, all exit 0; safe fixture-model acceptance and tracked/new-source checkpoint recorded |
| 6 | @explorer independent source coverage; orchestrator | all seven Change Surface searches rerun and classified; actual implementation/evidence matches tasks and criteria; oracle R1–R6 findings resolved, final status-before-marker clause corrected and regression guarded |
| 7 | terminal gate, orchestrator | actual archive move; accounted-for retained rows; rebased outgoing/inbound references; nonduplicate indexes/navigation; scoped and global links; final-path combined lint passed with filing pair pending before final marking |

### Final merged verification

The following were run from the Workflow-Scripts repository root after the final gate-order correction and regression additions; **every command exited 0**:

```text
bash scripts/validation/check-active-markdown-links-selftest.sh
bash scripts/validation/check-artifact-lifecycle-policy.sh
bash scripts/validation/check-artifact-lifecycle-policy-selftest.sh
bash scripts/validation/check-artifact-filing-selftest.sh
bash scripts/validation/check-completion-chain-policy.sh
bash scripts/validation/check-planning-build-policy.sh
bash scripts/validation/check-planning-build-policy-selftest.sh
bash scripts/validation/check-plan-selftest.sh
bash scripts/validation/check-meta-logs-selftest.sh
bash scripts/validation/check-review-workflow-policy.sh
bash scripts/validation/check-orchestrator-review.sh
bash scripts/validation/check-sync-workflow-scripts.sh
bash scripts/validation/check-update-workflows.sh
bash scripts/validation/check-active-markdown-links.sh
bash scripts/validation/check-active-markdown-links.sh --self-test
bash scripts/validation/check-plan.sh --require-tier --state <current-plan>
git diff --check
```

CLI regressions demonstrated empty values previously widened scope and in-root directory cycles previously crashed; both now fail/terminate correctly. Policy mutations fail on broad eligibility, premature ticks, lost Reconcile step 7, wrong partial paths, missing rollback/revalidation and status-after-marker ordering even when correct wording also exists. The filing rehearsal has 13 staged expectations and deliberately labels its limit: it models fixture states using the real linter/link checker, not execution of natural-language instructions. The actual terminal filing below provides a real package-path exercise. Anchors/inventory semantics are not automatically proven by link-target checks; the gate accounts for them separately.

All hosted CI command equivalents applicable to the working tree passed. Hosted CI and a real pre-commit invocation were not run: no commits/staging were authorized. `check-meta-logs.sh --staged/--range` would not validate these unstaged additions; fixed-entry/troubleshooting/index pairing was directly inspected, while its automated selftest passed.

### Maintained product source set (retained)

The following exact members stay canonical, not relocated as historical artifacts: `00-Meta-Workflow/00-meta/plan-template.md`; planning `00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, `README.md`; code-build `01-execution.md`, `02-confirm-execution.md`, `03-execute-and-confirm.md`, `04-review-finalise-commit-execute.md`, `README.md`; documentation `03-mark-completed.md`, `README.md`; `00-project/docs/agents/changelog-and-troubleshooting.md`; `00-project/plans-completed/README.md`; `scripts/validation/check-active-markdown-links.sh`, `check-active-markdown-links-selftest.sh`, `check-artifact-lifecycle-policy.sh`, `check-artifact-lifecycle-policy-selftest.sh`, `check-artifact-filing-selftest.sh`, `check-completion-chain-policy.sh`; `.github/workflows/validation.yml`; `scripts/hooks/pre-commit`. The combined review/finalisation wrapper inherits changes without a redundant edit. Every source-set member is verified present in its normal topical directory.

### Source checkpoint (before terminal bookkeeping)

Tracked patch SHA-256: `f75fbcdcb73ea8d1840252d7aa111b124ded57881f96b4226a5143b6ec187d44` (`git diff --binary | shasum -a 256` at 16:49). New script hashes, since untracked files are not part of that tracked diff:

```text
358d4cd32b1fb1774c25c3af200f881592f99d03512dbf2162b649135364db59  check-active-markdown-links-selftest.sh
54636e377fe67528ad9da37a31a241a238f2b2b3cb35954c7d5ef277b2fc9585  check-artifact-lifecycle-policy.sh
d2be31b66060d7b93acab345565f6d8a569fda5071defabdda3ea4e84fb8a90c  check-artifact-lifecycle-policy-selftest.sh
0cfe6d792d7546e27c141a7fea093d3288cc922566d1416b709be1ec773b6b7a  check-artifact-filing-selftest.sh
```

These identify the verified source state, not a commit and not a hash of this mutable evidence document. Existing unrelated host-project changes remain untouched.

### Terminal gate filing report (2026-10-06)

**Implementation verification:** VERIFIED. **Package filing:** VERIFIED. **Mode:** Full completion. **Flagged issues:** none in the adopted scope.

The package is this single plan, retaining the original proposal, executable contract, independent review/confirmation and verification evidence inline. No separate task-exclusive draft, research folder or review artifact remains to move. Canonical source/test/log/index files stay in place as inventoried; other repositories' work was not moved. The former research location had already been removed by the user's relocation; the gate moved the active plan exactly once to its dated implementation archive, with no destination collision or overwrite.

Before moving, the current-path combined `--require-tier --state` check passed while the filing pair remained pending. After moving, 70 relative Markdown links were rebased without altering source-locator provenance. The original proposal changelog and adoption log now target the archived plan. Completed-plans/changelog indexes each have one new completion row; README/TODO show a filed reference, not an obsolete active task, without changing unrelated open debt.

Actual disk checks confirmed destination presence, active/research-source absence and retained canonical records. An explicit scoped link check covered this archived file plus all eight affected incoming/navigation/index files; it passed. The full active Markdown link check also passed. Separately inspected inventory, mapping, index uniqueness and affected anchors match the filing effects; scoped outgoing success alone was not treated as coverage proof.

The combined final-path plan check passed **before final marking**, while the filing boxes were unchecked and explained. Only then were Package filing VERIFIED, the filing pair ticks and the completion marker applied. The **post-edit final-path check passed**, as did archived scoped links, the full active link scan and `git diff --check`. Any future failed revalidation must remove the marker/reset affected filing boxes per the gate failure rule rather than retain a false completed record.

Recorded terminal output: `check-plan: 00-project/plans-completed/implementation/2026-10-06-plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md: OK (T3, state)`; both link checks reported `Active markdown links OK`.

No source-code changes were made during filing; prior final merged regression evidence remains valid. No staging, commits, push or hosted CI execution was authorized or performed.

## Retained research proposal (historical)

The following research is retained verbatim except metadata labeling; recommendations describe the investigation baseline. Adopted changes and current outcomes are governed by the executable sections above and later evidence, not this historical status.

# Plan-Artifact Completion Filing Proposal (Research)

**Date:** 2026-10-06 15:04 (+08, Asia/Singapore)
**Model:** openai/gpt-6.1-sol
**Historical proposal status:** PROPOSAL — not adopted at the time of research. This document changed no workflow, template, script, or README during research.
**Research baseline:** Workflow-Scripts branch `v1.82`, HEAD `0adbe2d7913b622d0858f362a83ba57a8c75be16`, clean tree before that work.
**Evidence:** all existing-state claims were verified read-only against that baseline; proposed-state claims are labeled **proposed**.

## 1. Question and recommendation

Question: study all instruction files in `01-planning-and-organizing/` and `02-code-build/` and recommend where the lifecycle **generate plans → execute → package all associated docs/research/plans → file completed** belongs.

Recommendation (**proposed**): add no competing workflow. The existing terminal gate, [`04-documentation/03-mark-completed.md`](../../../04-documentation/03-mark-completed.md), already declares itself the **only** workflow applying plan-level terminal actions — the completion marker and the archive move — with archive routing resolved from the host repository's policy ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:6`), and it is mandatory for every execution outcome ([`02-code-build/README.md`](../../../02-code-build/README.md) `:37`). Extend that gate, mainly Phase 4 step 3 ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:154-160`), to carry an **associated-artifact inventory** and to verify the filed package before its own filing task is ticked.

Two placement roles, and only two (**proposed**):

1. **Seed role — inside plans.** Generated and finalised plans contain the inventory and one gate-owned terminal filing task, added through the shared template (§3, §4).
2. **Execute role — the terminal gate.** Only the gate performs the actual moves, links, verification, and the final tick of the filing task (§5).

The gate sits downstream of **both** directories the question names — not only the compound wrapper. [`02-code-build/04-review-finalise-commit-execute.md`](../../../02-code-build/04-review-finalise-commit-execute.md) reaches it after planning (steps 1 and 3, `:22-36`), but the direct paths run it with no wrapper at all: [`01-execution.md`](../../../02-code-build/01-execution.md) `:93` (gate always at finalization), [`02-confirm-execution.md`](../../../02-code-build/02-confirm-execution.md) `:96-98` (hand-off for both outcomes), and [`03-execute-and-confirm.md`](../../../02-code-build/03-execute-and-confirm.md) `:38-42` ("no path around the gate"). Anchoring filing in `04` alone would miss every direct execution and confirmation path.

## 2. Existing state (cited)

- **Completion ownership.** Gate modes: Full completion runs Phases 1–5; Reconcile only omits the marker and Phase 4 step 3 ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:12-17`). Task-level ticks are not gate-reserved: execution ticks as its Verification Bar passes, confirmation corrects both directions (`:6`; [`01-execution.md`](../../../02-code-build/01-execution.md) `:22`).
- **Plan contract.** The shared template requires checkbox tasks with `Files:`/`Verify:` lines, priority and effort labels, and the Marking Contract's two-state ticking ([`plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md) `:101-118`). It has no artifact-inventory or terminal filing concept today; `check-plan.sh` enforces structure and open-box hygiene only ([`plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md) `:128-131`).
- **Associated artifacts today.** Research output and plan output are siblings with no lifecycle link between them ([`00-research-and-plan.md`](../../../01-planning-and-organizing/00-research-and-plan.md) `:30-31`, `:170-205`). Review artifacts live in `PLAN.reviews/` ([`01-plan-review.md`](../../../01-planning-and-organizing/01-plan-review.md) `:44-51`); finalisation marks the source plan superseded and moves `PLAN.reviews/` to `PLAN.reviews-archive/` ([`02-finalise-plan.md`](../../../01-planning-and-organizing/02-finalise-plan.md) `:44-48`) — that archival of temporary reviews is **not** completion filing. Execution and confirmation hand off without moving anything ([`01-execution.md`](../../../02-code-build/01-execution.md) `:89-94`; [`02-confirm-execution.md`](../../../02-code-build/02-confirm-execution.md) `:96-98`). The gate archives the plan file alone, plus index rows ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:154-160`).

## 3. Plan-template artifact lifecycle contract (proposed)

Add one concise section to [`plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md) beside the Task and Decision Requirements (`:101-118`), making it the source of truth other workflows reference (**proposed**):

- **Artifact inventory.** Each generated/finalised plan carries an inventory whose fields are, at minimum: artifact path, owning repository, relationship (e.g., research, source plan superseded, review archive, evidence), and disposition/destination or a retained-in-place reason. A finalised plan retains rows for its superseded source, review archives, and research/evidence. An optional summary or manifest link is permitted where useful — not required.
- **Terminal filing task.** Each plan ends with one gate-owned terminal task with the normal `Files:`/`Verify:` fields, a priority, an effort label, and a filing criterion (see §7). It is bookkeeping owned by the gate, never an implementation task.
- **Eligibility separation.** Committed implementation and acceptance eligibility exclude the unperformed gate-owned filing task **and its corresponding filing Success Criterion**, so a plan whose implementation is verified complete is not self-gated by its own unticked bookkeeping boxes. This exception applies only to terminal filing, not ordinary tests/docs/acceptance obligations; only the gate ticks those filing boxes, after verified filing (§5).
- **Proportionality.** A small T1 plan may use a single-row inventory and a short filing task. No elaborate manifest file, and no tier bump solely for filing.

## 4. Upstream insertion points (proposed)

| File | Existing anchor | Proposed insertion |
|---|---|---|
| [`plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md) | `:101-118` | Artifact lifecycle inventory + terminal filing task contract (§3); single source of truth |
| [`00-research-and-plan.md`](../../../01-planning-and-organizing/00-research-and-plan.md) | Phase 3.2 `:201-209`; outputs `:30-31`, `:170-205` | Initialize the inventory and terminal task via the shared template; list the research document as the first artifact |
| [`01-plan-review.md`](../../../01-planning-and-organizing/01-plan-review.md) | Steps `:31-33`; Output `:59-74` | Check artifact coverage, ownership/disposition, and terminal-task presence; reference the shared contract, do not restate it |
| [`02-finalise-plan.md`](../../../01-planning-and-organizing/02-finalise-plan.md) | Steps `:37-48` | Maintain the inventory while writing the new plan; record the superseded source (`:44`) and `PLAN.reviews/` → `PLAN.reviews-archive/` (`:45-48`) as inventory rows; note that archival ≠ completion filing |
| [`03-plan-review-and-finalise.md`](../../../01-planning-and-organizing/03-plan-review-and-finalise.md) | Steps `:15-18`; no-duplication rule `:26` | Inherits both checks via the linked workflows; add no local rules |
| [`01-execution.md`](../../../02-code-build/01-execution.md) | Finalization `:89-94` | Hand the updated inventory plus evidence to the gate; execution does not independently archive planning artifacts |
| [`02-confirm-execution.md`](../../../02-code-build/02-confirm-execution.md) | Steps `:96-98` | Audit inventory/evidence completeness and hand off; confirmation moves nothing |
| [`03-execute-and-confirm.md`](../../../02-code-build/03-execute-and-confirm.md) | Completion Bar `:24-27`; Steps `:37-44` | Full completion requires the bundled filing result returned by the gate |
| [`04-review-finalise-commit-execute.md`](../../../02-code-build/04-review-finalise-commit-execute.md) | Steps `:26-31`, `:33-36` | Planning commit (`:26-31`) stays an optional user-selected checkpoint, not authorization to commit/push at close; gate step returns the final archived location; no generator step needed — Related already says use research first when no plan exists (`:62`) |
| [`01-planning-and-organizing/README.md`](../../../01-planning-and-organizing/README.md) | Shared-template note `:82` | One-line parity reference to the artifact lifecycle contract |
| [`02-code-build/README.md`](../../../02-code-build/README.md) | Gate paragraph `:37` | One-line parity reference: gate files the package; concise, no duplicate policy |
| [`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) | Phase 4 step 3 `:154-160` | The execute role itself (§5) |

## 5. Terminal filing sequence (proposed)

The gate's Phase 4 step 3 extension, in order (**proposed**):

1. Reconcile actual evidence against the plan: verified-but-unticked tasks get ticked; blocked tasks stay `[ ]` with explained reasons (existing rule, [`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:107`, `:140-141`).
2. Identify completed-implementation eligibility, **excluding** the exclusively gate-owned pending filing task and its corresponding filing Success Criterion (§3), avoiding self-gate deadlock.
3. Run `check-plan.sh --require-tier --state` on the plan **before** any move (flag combination already parses; see §6.4).
4. Apply the owner host's archive-policy mappings ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:154-156`; [`naming-conventions.md`](../../../00-Meta-Workflow/00-meta/naming-conventions.md) `:48-54` — owning repository first; Workflow-Scripts' own metadata root is `00-project/`, `:54`).
5. Before moving, review artifact ownership, active consumers and privacy. Retain canonical live product docs, changelog, troubleshooting and shared/active research; link each retained row with its reason. Sanitize or exclude sensitive evidence per host policy before it enters the archive; record the exclusion and safe evidence reference, never secret values. Do not move another repository's records or duplicate/delete active shared research.
6. Move eligible task-exclusive historical artifacts: the plan, superseded source plans, review archives, research, and evidence. No invented directory tree: the category describes the work's purpose, not a bundle ID — host policy may keep dated siblings, a per-task directory, or a logical linked package. Example path (illustrative only): `<metadata-root>/plans-completed/<category>/<plan>.md` ([`naming-conventions.md`](../../../00-Meta-Workflow/00-meta/naming-conventions.md) `:65`).
7. Reconcile the recorded source→destination mappings against the actual moves; retain progress so partial filing is resumable.
8. After all moves: verify the inventory against disk, report missing artifacts, check outgoing and inbound links and index rows, and route open Deferred & Debt per the existing reconciliation step (`:162-167`).
9. Tick the filing task and its criterion **only after** the effects are verified; lint the final archived path.
10. Final output reports two distinct facts: implementation verification status, and package filed status.

Failure handling (**proposed**): implementation incomplete → Reconcile only mode, as today. Archive policy unresolved, a move blocked, a collision, or a link validation failure → report "implementation verified; filing pending/blocked" — **not** successfully packaged. Source→destination mapping is recorded before moves, progress staged, and the sequence resumable with no-overwrite and no-duplicate-index rules (idempotent resume).

## 6. Gaps and contracts that require adoption (existing state cited)

1. **Order conflict.** Phase 4 step 3 archives the plan (`:154-160`) before step 7 requires `--state` to pass "before the plan is archived" ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:173`). Adoption must reorder or re-anchor the check (§5.3).
2. **Mode-table omission.** The Reconcile-only row lists Phase 4 steps 1, 2, 4, 5, 6 and omits step 7 (`:15`) while `:173` says both modes run it.
3. **Marker vs archive.** Unresolved archive policy blocks only the move, yet still applies the completion marker (`:160`); acceptance says Full completion is marker **and** archive (`:208`). The gate report must separate implementation verified from filing success (§5.10).
4. **Lint coverage.** `check-plan.sh --state` checks checkbox hygiene only — open boxes need `Open:` reasons ([`plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md) `:128-131`; [`check-plan.sh`](../../../scripts/validation/check-plan.sh) `:145-166`) — and a tier-less legacy plan warns and exits 0 without `--require-tier` ([`check-plan.sh`](../../../scripts/validation/check-plan.sh) `:79-86`). Proposed terminal run combines both flags — already parseable together ([`check-plan.sh`](../../../scripts/validation/check-plan.sh) `:17-31`) — after legacy conversion at the gate ([`03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) `:107`). This is a rule change, not new tooling.
5. **Link validation.** The active-link checker excludes `00-project/plans-completed` ([`check-active-markdown-links.sh`](../../../scripts/validation/check-active-markdown-links.sh) `:17-21`) and ignores anchors (`:62-67`), so passing today's tool cannot certify an archived bundle. A scoped archived-link/coverage regression extension is proposed **for** adoption; it does not exist yet.
6. **Guide divergence.** [`changelog-and-troubleshooting.md`](../../docs/agents/changelog-and-troubleshooting.md) `:55-59` teaches direct filing, while [`plans-completed/README.md`](../../plans-completed/README.md) `:37-44` makes gate reconciliation step 0. Adoption should link both to the canonical gate.
7. **Deferred work.** Incomplete/deferred scoped tasks remain unchecked and the plan active under the current Full-completion/Reconcile-only contract ([`03-execute-and-confirm.md`](../../../02-code-build/03-execute-and-confirm.md) `:26`). An owner-approved "CLOSED WITH DEFERRED" archival disposition is separately governed and is deferred out of this MVP.
8. **Doc markers are not plan archival.** Live documentation workflows write `**Status:** ✅ COMPLETED` on documents ([`01-create-docs.md`](../../../04-documentation/01-create-docs.md) `:44`; [`02-sync-documentation.md`](../../../04-documentation/02-sync-documentation.md) `:88`); those markers mean document results, not plan completion or filing.

## 7. Illustrative wording (proposed; examples are illustrative, not required text)

Template inventory section (illustrative):

```markdown
## Artifact lifecycle
| Artifact | Owner repo | Relationship | Disposition |
|---|---|---|---|
| research/findings-YYMMDD-HHMM-model.md | this repo | research | move to archive with plan |
| plans/2026-10-06-source-plan.md | this repo | superseded source | move; link new → old |
| plans/PLAN.reviews-archive/ | this repo | review archive | move; retain |
| docs/guide.md | this repo | live product doc | retain in place; reason: canonical |
```

Terminal task exemplar (illustrative; ticked only by the gate after verified filing):

```markdown
1. [ ] File the completed plan package via the terminal gate (P2, Effort: S)
   - Open: pending — gate-owned terminal bookkeeping, excluded with its filing criterion from implementation eligibility
   - Files: this plan; Artifact lifecycle rows
   - Verify: gate verifies artifact coverage, archived/inbound links and indexes; `check-plan.sh --require-tier --state` passes at the final path → package filed (cost/prereqs: verified implementation, resolved owner archive policy, local file/link checks)

## Success Criteria
- [ ] Completed plan package filed and verified by the terminal gate — Open: pending — gate-owned filing criterion, not an implementation eligibility prerequisite
```

## 8. Adoption steps (ranked) and test matrix (proposed)

| Rank | Change | Where |
|---|---|---|
| 1 | Artifact lifecycle contract (inventory + terminal task + eligibility exclusion) | `plan-template.md` |
| 2 | Gate Phase 4 step 3 extension + step 7 reorder + split report | `03-mark-completed.md` |
| 3 | Seed at generation; maintain at finalisation; check at review | `00-research-and-plan.md`, `02-finalise-plan.md`, `01-plan-review.md` |
| 4 | Hand-off and bundled-result wording | `01-execution.md`, `02-confirm-execution.md`, `03-execute-and-confirm.md`, `04-review-finalise-commit-execute.md` |
| 5 | README parity lines | both directory READMEs |
| 6 | Archived-bundle link/coverage regression extension | `scripts/validation/` (new, scoped) |

| Scenario | Expected under proposal |
|---|---|
| Tiny T1 plan, no research | single-row inventory; short filing task; no manifest, no tier bump |
| Full draft/final with reviews archive and evidence | inventory carries source, reviews-archive, research rows; all moved or retained-with-reason |
| Direct finalisation (no review) | inventory still initialized; missing rows reported, not invented |
| Direct 01 → gate vs 03/04 wrapper | identical filing result (parity) |
| Missing/contradictory host archive policy | move blocked; "implementation verified; filing blocked" |
| Incomplete task | Reconcile only; plan stays active; no filing |
| Allowed external debt | stays open; routed per `:162-167`; not archived away |
| Cross-repo / shared docs | other repo's records untouched; shared docs retained + linked |
| Interruption / name collision | staged, resumable; no overwrite; no duplicate index rows |
| Broken inbound links after move | flagged in post-move verification; filing stays pending until fixed |
| Sensitive artifacts | sanitized/excluded per host privacy; retained reason recorded |
| Eligibility with pending filing task and criterion | eligible to enter Full completion after implementation proof; both terminal bookkeeping boxes stay unchecked until filing verifies |

## 9. Explicitly not proposed

No zip/bundle packaging default; no new archive policy or global destination; no forced commits or pushes (planning commit stays an optional user-selected checkpoint); no new top-level workflow; no change to live documentation marker semantics; no auto-archive once code is done — the filing task is ticked only after verified filing effects. No troubleshooting entry accompanies this research: it fixes no workflow defect.

## Sources

All ten instruction files in the two studied directories, plus the core contracts they reference:

- [`01-planning-and-organizing/README.md`](../../../01-planning-and-organizing/README.md) — workflow index and sequence `:5-51`; shared-template note `:82`
- [`01-planning-and-organizing/00-research-and-plan.md`](../../../01-planning-and-organizing/00-research-and-plan.md) — outputs `:28-32`; Phase 3 `:168-226`; Phase 3.2 `:201-209`
- [`01-planning-and-organizing/01-plan-review.md`](../../../01-planning-and-organizing/01-plan-review.md) — steps `:16-33`; `PLAN.reviews/` `:42-51`; output `:59-74`
- [`01-planning-and-organizing/02-finalise-plan.md`](../../../01-planning-and-organizing/02-finalise-plan.md) — steps `:18-48`; supersede/archive `:44-48`; acceptance `:69-84`
- [`01-planning-and-organizing/03-plan-review-and-finalise.md`](../../../01-planning-and-organizing/03-plan-review-and-finalise.md) — steps `:14-18`; no-duplication `:24-27`
- [`02-code-build/README.md`](../../../02-code-build/README.md) — gate diagram `:16-35`; mandatory gate `:37`; Verification Bar `:70-84`
- [`02-code-build/01-execution.md`](../../../02-code-build/01-execution.md) — outputs `:15-22`; loop `:53-87`; Finalization `:89-94`
- [`02-code-build/02-confirm-execution.md`](../../../02-code-build/02-confirm-execution.md) — marking `:57-70`; steps `:72-98`; no plan-level completion `:96`; hand-off `:98`
- [`02-code-build/03-execute-and-confirm.md`](../../../02-code-build/03-execute-and-confirm.md) — Completion Bar `:18-29`; steps `:31-52`
- [`02-code-build/04-review-finalise-commit-execute.md`](../../../02-code-build/04-review-finalise-commit-execute.md) — commit checkpoint `:26-31` and notes `:53`; execute `:33-36`; related `:58-62`
- [`04-documentation/03-mark-completed.md`](../../../04-documentation/03-mark-completed.md) — terminal authority `:6-17`; phases `:100-178`; archive step `:154-160`; state check `:173`; acceptance `:205-213`
- [`00-Meta-Workflow/00-meta/plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md) — task/decision requirements `:101-107`; Marking Contract `:109-118`; validation modes `:124-131`
- [`00-Meta-Workflow/00-meta/naming-conventions.md`](../../../00-Meta-Workflow/00-meta/naming-conventions.md) — metadata-root resolution `:44-58`; storage `:60-69`; checkout `:71-73`
- [`scripts/validation/check-plan.sh`](../../../scripts/validation/check-plan.sh) — flags `:17-31`; legacy path `:79-86`; state logic `:109-166`
- [`scripts/validation/check-active-markdown-links.sh`](../../../scripts/validation/check-active-markdown-links.sh) — skip patterns `:16-21`; anchor handling `:60-67`
- [`00-project/plans-completed/README.md`](../../plans-completed/README.md) — categories `:17-25`; filing steps `:35-44`
- [`00-project/docs/agents/changelog-and-troubleshooting.md`](../../docs/agents/changelog-and-troubleshooting.md) — plans-completed conventions `:49-59`
- [`04-documentation/01-create-docs.md`](../../../04-documentation/01-create-docs.md) `:44` and [`04-documentation/02-sync-documentation.md`](../../../04-documentation/02-sync-documentation.md) `:88` — document-level completion markers
- Companion changelog entry: [`changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md`](../../changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md)

## Proposal verification

- All ten planning/build Markdown files were studied, with a separate read-only review of the terminal gate and shared contracts. The proposal records source-backed recommendations, not adopted instructions or completed implementation.
- `git diff --check` passed. The only Workflow-Scripts changes are this research file, its documentation changelog entry and one new changelog-index row; no workflow, template, validator, application file or completed-plan archive was changed. Nothing was staged, committed or pushed.
- `bash scripts/validation/check-active-markdown-links.sh` found no broken target in those three files, but the repository-wide run **failed** on an existing escaped-root link at `00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15`. That file is tracked and unchanged from HEAD; the unrelated failure was not repaired by this proposal. Do not treat this result as a passing repository-wide link gate or as archived-bundle/anchor validation.
- `check-plan.sh` was not run on this document: it is a research proposal, not an implementation plan. The fenced terminal task is an illustrative recommendation, not work being executed now.
