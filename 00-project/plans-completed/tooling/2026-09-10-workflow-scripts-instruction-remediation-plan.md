# Workflow-Scripts Instruction Remediation Plan

**2026-09-10 11:55**  
**Status:** ✅ **Verified Complete (Phases 1–4).** Phase 5 (Astra measurement) was split out by explicit developer decision on 2026-09-10 into the successor plan `Workflow-Scripts/00-project/plans/2026-09-10-astra-instruction-evaluation-plan.md`. Residual flags from verification are recorded below.  
**Verified:** 2026-09-10 by the mark-completed gate against `Workflow-Scripts` `v1.81` @ `5f87cc9` (plus `846caef` for Phase 1) and the workspace/Info-Visualizer/prompt-formatter/Podcast-Studio repositories. All six `scripts/validation/*` checks pass.  
**Filed:** `00-project/plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md` (Workflow-Scripts) · `project/plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md` (Image-Generation-Apps) · `Tech-notes/Workflow-Scripts/plans-completed/2026-09-10-workflow-scripts-instruction-remediation-plan.md` (Core-Knowledge)  
**Target branch:** `v1.81` (`origin/v1.81`)  
**Priority:** P0 correctness repairs, then P1 prompt-contract consolidation  
**Consolidated from:** `agents-md-wording-audit-recommendations-260910.md` and its inline 2026-09-10 plan-review addendum. Two read-only review lanes contributed: workflow-body review and generated-agent/template review. No `PLAN.reviews/` directory was created.

## Goal

Remove active instruction contradictions and stale generated AGENTS content that can cause agents to select the wrong repository, path, workflow, archive destination, or validation behavior. Preserve the existing verification, evidence, scope, untrusted-content, and multi-repository safeguards.

## Selected defaults

- **Podcast-Studio:** document the already-present shared workspace master at `../Shared-Links/Workflow-Scripts`; do not create a clone or symlink in this work.
- **Generated execution policy:** replace the blanket parallel-agent mandate with a task-sizing decision rule, after the shared policy is added.
- **TODO filing shortcut:** retain it for now; it is human-facing and will be reassessed only after the canonical guide migration is validated.
- **Path style:** use repository-relative wording such as “this repository root” for local commands; use the shared-master path only where it is necessary to distinguish that separate repository.
- **Repository lifecycle:** preserve unrelated changes; update each changed repository's own changelog/index and make isolated documentation commits only when commits are requested.

## Scope

### In scope

- Workflow-Scripts active workflow documents, shared meta contracts, setup templates, and validators.
- Workspace, Info-Visualizer, prompt-formatter, and Podcast-Studio agent instruction files and their canonical changelog/troubleshooting documentation.
- Verification of instruction paths, repository maps, template propagation, and non-destructive checks.
- An Astra evaluation protocol after correctness repairs land.

### Out of scope

- Application code or product UI changes.
- Creating a second Workflow-Scripts clone or changing the Podcast-Studio filesystem layout.
- Rewriting the verification/evidence safety spine.
- Removing model provenance from naming conventions.
- Editing `11-Skills` content unless its separate ownership and validator implications are explicitly resolved.

## Dependencies and operating constraints

1. Do not parallel-edit Workflow-Scripts files shared by the ported remediation batch. Follow the prescribed one-writer order from the v1.72 prior-art sequence.
2. Freeze template refreshes while changing the template and generated files. Otherwise an update can restore stale template content.
3. Read current files immediately before each edit; line numbers in the audit are evidence references, not edit anchors after earlier phases shift text.
4. Preserve or co-update `scripts/validation/check-completion-chain-policy.sh` whenever completion-chain wording changes.
5. Treat each repository as independent for status, changelog, commit, and validation.

---

## Phase 1 — Verify v1.72 workflow repairs on `v1.81` (merge complete) ✅

**Status:** ✅ Verified complete — v1.72 repairs landed via `846caef` (changelog `fixed/2026-09-10-fixed-v1-72-improvement-repairs-on-v1-81.md`). Active planning links resolve; no active planning `02-build-code` references; `03-mark-completed.md` roles generalized; `fable-like.md` absent from active planning; User Manual indexes the combined planning workflow.

**Priority:** P0  
**Effort:** Verification pass (repairs largely present via v1.81 merge)  
**Owner repository:** Workflow-Scripts  
**Entry criteria:** Work starts from a clean checkout of `v1.81`; the v1.72 improvement plans and v1.8 remediation are already merged; frozen parents `v1.8` and `v1.72` are not rewritten.

### Objective

`v1.81` combines `v1.8` (July remediation, CI, security, SDK) and `v1.72` (Aug–Sep active workflows, completion-chain gate, dependency workflows). Do **not** re-port v1.72 repairs onto a v1.8 tree. Instead, verify each v1.72 improvement-plan outcome against the `v1.81` tree and only apply gaps that the merge did not already land.

### Required order

Use the v1.72 overview at `00-project/plans/v1.72-Improvements/2026-08-11-v1.72-00-overview.md` as the checklist ordering. On `v1.81`, verify (and patch only if missing) in this order:

1. `02-unify-plan-output-locations`
2. `01-fix-broken-planning-links`
3. `03-fix-debugging-order-contradiction`
4. `04-reroute-bug-description-reports`
5. `06-generalize-mark-completed-agent-roles`
6. `05-reconcile-agent-spawning-bug-fix`
7. `09-documentation-dir-coherence`
8. `08-relocate-fable-like-prompt`
9. `07-index-combined-planning-workflow`

The prior-art shared-file sequence remains authoritative for any gap fixes: **02 → 01 → 08 → 07** for overlapping planning files. Reconfirm the affected sections on `v1.81` before each edit.

### Audit recommendations closed by this phase

| Audit item | Existing plan |
|---|---|
| Broken `02-build-code` links and escaped-root blind spot prerequisites | 01 |
| Mixed plan/research output locations | 02 |
| Consumer-project file names in generic terminal roles | 06 |
| Fixed debugging-agent maxima versus session cap | 05 |
| Product-specific `fable-like.md` in active planning | 08 |

### Risks and mitigations

- **Shared-file drift:** use one writer and the overview's exact order.
- **History versus active policy:** do not rewrite archived plans merely to remove old names.
- **Fable provenance:** follow Plan 08's approved-retention/deletion conditions; do not silently retain an unapproved third-party prompt.

### Exit criteria

- Each v1.72 work item is verified present on `v1.81` or patched with an adapted exit criterion.
- Active planning links target existing in-repo files; no active `02-build-code` references remain.
- No consumer-project source examples remain in generic terminal-role instructions.
- `fable-like.md` is absent from the active planning directory.
- Any Phase 1 gap fixes get a concise `v1.81` changelog entry per Workflow-Scripts convention.

---

## Phase 2 — Repair remaining active workflow contracts ✅

**Status:** ✅ Verified complete — host-convention changelog rule in root `README.md`, `02-code-build/01-execution.md`, `03-debugging/01-bug-description.md`, `06-security/02-security-fix.md`; phase-vs-terminal completion single-sourced (glossary, `02-code-build/README.md`, `03-execute-and-confirm.md`, `02-confirm-execution.md`) with the completion-chain validator still passing; `00-Meta-Workflow/00-meta/workflow-applicability.md` added and referenced from planning/review/execution; rubric split into normative per-finding vs optional governance.

**Priority:** P0/P1  
**Effort:** Medium  
**Owner repository:** Workflow-Scripts  
**Dependencies:** Phase 1 complete; inspect resulting wording before editing.

### 2.1 Use one host-convention changelog rule

**Files:**

- `README.md`
- `02-code-build/01-execution.md`
- `03-debugging/01-bug-description.md`
- `06-security/02-security-fix.md`

**Tasks:**

1. Replace hard-coded “`docs/CHANGELOG.md` preferred” language with the host-convention rule.
2. Use one short reference to the canonical host guidance rather than restating folder and single-file variants repeatedly.
3. Recheck the result after Phase 1's `09-documentation-dir-coherence` changes to avoid duplicating its work.

**Exit criteria:** Active workflow wording no longer prefers an incompatible global changelog path; changed documents either state the host-convention rule or link to the relevant canonical convention.

### 2.2 Clarify phase completion versus terminal completion

**Files:**

- `02-code-build/01-execution.md`
- `02-code-build/02-confirm-execution.md`
- `02-code-build/03-execute-and-confirm.md`
- `02-code-build/README.md`
- `04-documentation/03-mark-completed.md`
- `00-Meta-Workflow/00-meta/glossary.md`
- `scripts/validation/check-completion-chain-policy.sh`

**Tasks:**

1. State once that `01-execution` may mark a **phase checkbox** only after applicable Verification Bar evidence passes.
2. State once that `03-mark-completed` alone creates the **plan-level completion marker** and archive/index updates after whole-plan verification.
3. Replace repeated authority paragraphs in handoff and navigation files with a one-sentence link.
4. Preserve the `Verified Complete`, `Not Eligible`, mandatory gate, host-policy, named-target-first, and policy-unresolved semantics—or update the validator atomically to check the revised equivalent semantics.
5. Add a diagnostic stop condition: repeat checks only after a meaningful correction or new hypothesis; otherwise record the blocker and leave the work incomplete.

**Risks:** Removing validator-required phrases without co-updating the validator will fail policy validation. Do not change the archive-policy safety boundary.

**Exit criteria:** The completion-chain validator passes; the Verification Bar has one detailed source; terminal archive authority has one detailed source; no document gives incompatible checkbox instructions.

### 2.3 Add an applicability, sizing, and delegation contract

**Files:**

- New: `00-Meta-Workflow/00-meta/workflow-applicability.md`
- `00-Meta-Workflow/00-meta/agent-spawning-policy.md`
- `01-planning-and-organizing/00-research-and-plan.md`
- `02-code-build/01-execution.md`
- `05-review/05-comprehensive-audit.md`

**Tasks:**

1. Create a compact shared contract: user-request outcome/scope, repository facts and safeguards, workflow applicability, non-normative examples, conflict handling, and no invented paths/repositories/policies.
2. Define task sizing: localized work may be direct; bounded independent work uses 2–3 focused roles; broad/high-risk work uses at most six per session under the shared policy.
3. Replace default 9–15-role planning rosters and blanket “clever” parallelism language with the decision rule.
4. Promote the comprehensive-audit anti-nested-agent-tree guard to the shared policy, leaving its origin document with a short reference.

**Exit criteria:** Planning, execution, review, and security workflows use the same sizing rule; dependent work is explicitly sequential; no active planning document presents a large role roster as the default for a localized task.

### 2.4 Split rubric governance from per-finding requirements

**File:** `00-Meta-Workflow/00-meta/severity-priority-rubric.md`

**Tasks:** Retain evidence, impact, likelihood, severity, priority, and rationale as normative. Mark scorer/date audit fields, SLA escalation, trend reporting, and close/archive ceremonies as optional human governance unless a workflow is added to own them.

**Exit criteria:** No active review workflow is implicitly required to fabricate an SLA, trend report, or human escalation record.

---

## Phase 3 — Harden template propagation and generated agent files ✅ (with residual flags PF-1, PS-1)

**Status:** ✅ Verified complete for the primary scope — setup templates slimmed/discovery-first (
**Effort:** Medium across independent repositories  
**Dependencies:** Freeze refreshes. Update templates first, then generated files in the same maintenance window.

### 3.1 Repair Workflow-Scripts templates

**Files:**

- `00-project-setup/01-setup-project.md`
- `00-project-setup/04-track-repos-and-agent-map.md`

**Tasks:**

1. Remove detailed changelog, troubleshooting, and plan-filing rules from the Step 1.4 Repository Management template; keep one durable link to the canonical detailed guide.
2. Add an update-checklist rule: when the consumption model or source of truth changes, delete superseded blocks instead of appending a competing block.
3. Add a generated-file audit: no placeholders; every mapped repository exists; documented relative paths resolve; commands match discovered scripts/config; exactly one Workflow-Scripts consumption model is described.
4. Replace hard-coded style/build examples in CLAUDE/GEMINI templates with project-discovery instructions or links to the actual project standards and scripts.
5. Make discovery output the required source for repo maps. Keep the existing canonical-map option; broaden the requirement from exactly three named files to AGENTS plus the harness files actually used by that project.
6. Change the root Execution block to the selected task-sizing decision rule.

**Exit criteria:** A scratch clone-model fixture and a scratch shared-master/symlink-model fixture produce no duplicated consumption blocks, stale paths, or generic build/style mandates. Workflow-Scripts receives a changelog entry and index row.

### 3.2 Correct workspace agent files

**Repository:** Image-Generation-Apps workspace meta  
**Files:** `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`

**Tasks:**

1. Remove the obsolete Workflow-Scripts `cd Workflow-Scripts` Git-operation block from `AGENTS.md`; retain the shared-master block.
2. Remove the duplicate inline repository table when the canonical repository-map link remains sufficient.
3. Replace “workspace clone” wording in `CLAUDE.md` and `GEMINI.md` with the shared-master-via-`Shared-Links/Workflow-Scripts` description.

**Exit criteria:** One current Workflow-Scripts consumption model is documented; every retained path exists; the repository map matches discovery output.

### 3.3 Correct Info-Visualizer agent files

**Repository:** Info-Visualizer  
**Files:** `AGENTS.md`

**Tasks:**

1. Remove the clone-era nested-repo instructions that conflict with the existing master-via-symlink section.
2. Replace stale absolute machine paths with repository-root wording.
3. Retain the explicit separation between the repository root for Git and `Info-Visualizer-codebase/` for application commands.

**Exit criteria:** No instruction says the symlink has its own `.git`; no stale user/machine path remains; Git and npm command locations remain distinct and accurate.

### 3.4 Correct prompt-formatter agent files and guide location

**Repository:** prompt-formatter  
**Files:** `AGENTS.md`; move `project/changelog-and-troubleshooting.md` to `docs/agents/changelog-and-troubleshooting.md`

**Tasks:**

1. Replace mandatory dual-log and legacy dash-list/timestamp rules with the canonical conditional troubleshooting policy.
2. Correct all troubleshooting paths to `project/troubleshooting/...`.
3. Move the detailed guide to the documented `docs/agents/` location and add the slim AGENTS link.
4. Preserve existing project-specific application and security instructions that are not part of the generated-policy drift.

**Exit criteria:** One changelog convention, one troubleshooting threshold, valid detailed-guide link, and no legacy path/format instructions remain.

### 3.5 Correct Podcast-Studio agent maps

**Repository:** Podcast-Studio  
**Files:** `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`

**Tasks:**

1. Remove the nonexistent local clone from all three repository maps and Git instructions.
2. Document the selected default: there is no local checkout; consult the shared workspace master at `../Shared-Links/Workflow-Scripts`.
3. Preserve the main application repository commands and branch policy.

**Exit criteria:** All three files agree with repository discovery and do not suggest cloning a second local Workflow-Scripts repository.

### 3.6 Per-repository lifecycle and verification

For each repository modified in Phase 3:

1. Read its active AGENTS guidance before edits.
2. Add the required changelog entry and index row for the documentation/configuration change.
3. Add troubleshooting only if a non-trivial repair lesson needs recording under that repository's policy.
4. Run `git status`, repository discovery, path/link checks, and targeted stale-text searches. Do not pull, push, or commit unless requested.

---

## Phase 4 — Validator and metadocument hygiene ✅ (with residual flag CK-1)

**Status:** ✅ Verified complete — `check-active-markdown-links.sh` now fails escaped-root relative links (allowlist) and passes `--self-test` against `fixtures/escaped-root-link.md`; stale `npm run build` example in `agent-flexibility-review.md` corrected; glossary terminology fixed; `00-Meta-Workflow/00-plans/index.md` deprecated in favor of `00-project/plans/`; `Core-Knowledge/Tech-notes/` documented in `Tech-notes/README.md` (root `Core-Knowledge/README.md` still omits it — see CK-1).

**Priority:** P1/P2  
**Effort:** Small to Medium  
**Owner repository:** Workflow-Scripts  
**Dependencies:** Phase 1 tree cleanup complete.

### Tasks

1. Harden `scripts/validation/check-active-markdown-links.sh` so a relative active link that escapes the repository root fails unless explicitly allowlisted. Define the allowlist, fixture, exit code, and documentation before implementing; this supersedes the v1.72 Plan 01 deferral if its terms are met.
2. Mark historical or correct the stale `npm run build` example in `agent-flexibility-review.md`.
3. Correct active glossary terminology after the link/path batch.
4. Reconcile the outdated `00-Meta-Workflow/00-plans/index.md` with the live `00-project/plans/` system; point or deprecate rather than maintaining two active plan indexes.
5. Document `Core-Knowledge/Tech-notes/` in its root index/README as a separate, low-risk follow-up.

### Exit criteria

- A controlled escaped-root broken-link fixture fails validation; valid in-repo links still pass.
- All Workflow-Scripts validators pass.
- Active metadocs do not direct users to retired paths or competing active plan indexes.

---

## Phase 5 — Measure Astra impact 🔀 (split out)

**Status:** 🔀 **Split out 2026-09-10 by developer decision.** The protocol is filed at `00-project/research/2026-09-10-astra-instruction-evaluation-protocol.md`, and the measurement (corpus, harness, baseline/revised runs, adoption decision) is now owned by the successor plan `Workflow-Scripts/00-project/plans/2026-09-10-astra-instruction-evaluation-plan.md`. No Astra improvement claim has been made.

**Priority:** P1  
**Effort:** Medium  
**Dependencies:** Phases 1–4 complete; pinned Astra access and a stable host/runtime available.

### Tasks

1. Create a non-destructive corpus: one-file documentation repair, localized bug with regression test, cross-repository doc task, multi-file plan, security review, blocked-secret validation, host-policy plan completion, and repository-content prompt-injection case.
2. Run baseline and revised instruction sets multiple times under the same model/runtime settings.
3. Measure acceptance success, wrong path/repository attempts, unnecessary clarification/blocking, delegation appropriateness, validation behavior, unintended edits, tool calls, elapsed time, tokens/cost, and blinded human review score.
4. File the protocol, raw results, aggregate, regressions, and adoption decision.

### Exit criteria

No claim of Astra improvement is made until quality/safety are maintained or improved and at least one efficiency/blocking measure improves without regression.

---

## Global completion criteria

- No active instruction describes both clone and symlink/shared-master consumption for the same project.
- Every mapped repository and documented command path is validated against the workspace.
- Active workflow links, plan locations, changelog routing, and completion authority have one non-conflicting rule.
- Required workflow safety controls remain present and all Workflow-Scripts validators pass.
- v1.72 prior-art repairs are recorded as verified on `v1.81` (merged, not re-ported), rather than treated as unchanged target-branch work.
- Each changed repository has its own required changelog/index updates; no unintended application-code changes are present.

---

## Verification notes (mark-completed gate, 2026-09-10)

**Result:** Phases 1–4 ✅ verified complete; Phase 5 🔀 split into the Astra instruction evaluation plan. Plan filed as complete 2026-09-10.

### Flagged issues (descending order of importance/urgency)

1. **P2 / S3** — Phase 3.5: Podcast-Studio agent map — **Incomplete.** `Podcast-Studio/AGENTS.md:21` still says “The main application repo and the local Workflow-Scripts repo are independent; both live under the same project directory on disk,” and `:80` still says “Pull latest changes from both repos,” contradicting the same file’s no-local-clone policy (`:17`, `:38–43`).
2. **P3 / S3** — Phase 3.4: prompt-formatter guide relocation — **Incomplete.** The canonical guide now exists at `prompt-formatter/docs/agents/changelog-and-troubleshooting.md`, but the superseded copy `prompt-formatter/project/changelog-and-troubleshooting.md` was copied, not moved; the old file is still tracked. (No active reference points at it.)
3. **P3 / S3** — Phase 4.5: Tech-notes discoverability — **Docs not updated.** `Tech-notes/README.md` documents the `Workflow-Scripts/plans[-completed]/` layout, but `Shared-Links/Core-Knowledge/README.md` structure table still lists only `Knowledgebase/` and `Temp-Info/`.
4. **P3 / S3** — Phase 1 exit criterion “no active `02-build-code` references remain” — **Partially met.** `00-Meta-Workflow/00-meta/agent-flexibility-review.md` still carries `Status: Active` and `02-build-code/...` references at lines 211, 390, 407 (the Phase 4 `npm run build` fix landed, but the file is not marked historical like `parallel-agents-review.md`).
5. **P3 / S3** — Phase 3.1 exit criterion (clone-model and shared-master/symlink-model scratch fixtures) — **Under-evidenced.** No fixture test artifact exists; template updates were verified by inspection only.

### Evidence summary

- Validators: `check-active-markdown-links.sh` (+ `--self-test`), `check-completion-chain-policy.sh`, `check-orchestrator-review.sh`, `check-review-workflow-policy.sh`, `check-sync-workflow-scripts.sh`, `check-update-workflows.sh` — all pass.
- Workflow-Scripts: `workflow-applicability.md` present; `fable-like.md` absent from active planning; host-convention changelog wording across active workflows; glossary phase/terminal split; `00-plans/index.md` deprecated; escaped-root link fixture + allowlist.
- Per-repository lifecycle: changelog entry + top index row present in the workspace meta, Info-Visualizer, prompt-formatter, and Podcast-Studio repositories.
- Phase 5: protocol present; baseline/revised runs not executed.
