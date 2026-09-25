# Implementation Plan: Planning and Code-Build Workflow Quality

**Created:** 2026-09-25 15:10
**Status:** DRAFT - Ready for Review
**Tier:** T2
**Research:** [`planning-and-build-workflow-quality-review-260925-1347-claude.md`](../research/planning-and-build-workflow-quality-review-260925-1347-claude.md) (researched at `1ab9fcb`, inferred from the 13:47 report time vs the 13:39 commit; re-verified at the same commit on 2026-09-25, see [Research summary](#research-summary-and-re-verification)). The source documents are annotated: the research carries in-place corrections and a `Plan:` line per finding, and the Drag-Free-v2 and v1.82-fixes documents carry extraction or cross-reference notes.
**Workflow:** [`00-research-and-plan.md`](../../01-planning-and-organizing/00-research-and-plan.md). Next step: [`01-plan-review.md`](../../01-planning-and-organizing/01-plan-review.md) by a different model.
**Validation owner:** parent orchestrator (the session that executes the plan), per phase.

This plan is written on the template it proposes (research §8). That makes it the first pilot: Phase B's `check-plan.sh` must pass on this file.

## Goal

Make the planning → build chain decide **what to build and how to shape it** as rigorously as it already proves **what was done**. Concretely:

1. Repair the four live mechanics defects (M1–M4), so the chain's own rules agree with each other and CI checks the active line.
2. Make plans carry the inputs that prevent incomplete fixes: a **Change Surface** with search commands, a **Decision** with at least 2 options, and a **Verify:** line per task. Order phases by dependency and risk rather than by priority, and enforce the structure with a host-usable plan linter.
3. Give builders and reviewers **one shared engineering standard** (boundaries, reuse, errors/recovery, tests, checkpoints), referenced forward from planning and execution and backward from review.

**Success is observable:** a new host plan written on the template passes `check-plan.sh`; its Change Surface searches, re-run after the build, show zero stale sites; all validators are green in CI on `v1.8*`; and no T1 plan exceeds about 20 lines.

## Research summary and re-verification

The research findings document is the linked review (§1–§10). It is not restated here. Summary: the chain is strong on verification (Verification Bar, two-way ticking, single terminal gate) and weak on design. Priority buckets drive phase order, alternatives are dropped from the template, no step inventories every site of a behavior, and code-design criteria exist only in review workflows. The Flash-UI prompt-quality case study shows the result: a correct diagnosis became an incomplete fix.

**Re-verified on `1ab9fcb` (2026-09-25, this session).** Evidence labels follow the research: *observed* = command or file:line run or read in this session.

| Research claim | Result | Evidence (observed) |
|---|---|---|
| M1: 04 routes `Not Eligible` without Reconcile only | Holds | `grep -n 'Not Eligible\|Reconcile only' 02-code-build/04-…md` → `:35`, `:48` only; E2 loop prints `WOULD FAIL 02-code-build/04-review-finalise-commit-execute.md` |
| M2: CI ignores active line; 4 broken links | Holds, **with a correction** | `validation.yml` branches `main`, `v1.8`; `check-active-markdown-links.sh` exit 1, same 4 links. **Correction:** "add one `../`" fixes only links 3–4. Links 1–2 target `2026-09-10-astra-instruction-evaluation-protocol.md`, which exists nowhere in the worktree (`ls 00-project/research/ research/v1.82-fixes/`). Recovering it is [v1.82 Plan 01](v1.82-fixes/01-reconcile-research-and-source-integrity.md) P0.4/P1.2 |
| M3: unsized rosters | Holds | `00-research-and-plan.md:71, 329`; `01-plan-review.md:17, 29, 102`; `02-finalise-plan.md:23, 34, 44, 113`; `01-execution.md:66, 79`; `02-confirm-execution.md:74` |
| M4: path drift | Holds | `01-execution.md:13, 20, 45, 112`; `03-execute-and-confirm.md:11, 48` |
| Case study residual | Holds | Flash-UI `lib/style-loader.ts:444, 506` still emit "layered box-shadows (3+ layers)… spring-physics" (working tree and `HEAD`) |

**Research gaps found while building this plan's Change Surface** (all observed):

1. **Phase = priority is stated in 5 places, not 3.** The research names `00-research-and-plan.md:124`, `02-finalise-plan.md:15, 103`, and `01-plan-review.md:99`. Also: the rubric's **Ordering Rule** ("Present work items in descending urgency… P0, P1, P2, P3", `severity-priority-rubric.md` §Ordering Rule, which applies to "reports and plans"), `01-planning-and-organizing/README.md:77-102`, and root `README.md:828` ("Push speculative refactors to P3"). Changing only the 3 named files would create the kind of contradiction M3 describes.
2. **Debt → TODO copying touches the terminal gate.** Research Q6 ("the terminal gate copies open entries into `TODO.md`") changes `04-documentation/03-mark-completed.md:161`, a file guarded by `check-completion-chain-policy.sh`. The research's wiring table does not list it.
3. **Evidence vocabularies would multiply.** R4 proposes *observed/sourced/hypothesis*. The Astra plan uses five labels (`05-run-astra-instruction-evaluation.md` §Operating boundaries), and `review-workflow-core.md:38-42` already requires "hypotheses" to be labeled. R4 must extend the review-core wording rather than add a third, independent vocabulary.
4. **The E1 `check-plan.sh` sketch rejects valid plans.** It treats every checkbox anywhere in the file as a task, so the `## Success Criteria` checklist that the current template requires fails with "task without Verify:". Observed by running the sketch on this plan: 7 false errors, all from Success Criteria, and every real task passed. Fix: only open tasks inside `## Tasks` (reset on any `## ` heading). The scoped version, run in this session, gives this plan exit 0, and a copy with one `Verify:` line removed gives exit 1 naming that task. Phase B task 5 builds on the scoped version.
5. **Search hits need classifying.** The retro-check search `rg -n "3\+ layers|spring-physics|html-ui-base" lib prompts` also matches `prompts/catalog/design-templates.txt:23, 35`. Those lines are example user prompts, not quality mandates. A Change Surface must classify every hit, not just count hits. This is the same rule Plan 01 applies to old-path hits ("classify every remaining hit").

**Lessons taken from the reference plan sets:**

| Source | Taken into this plan |
|---|---|
| `v1.82-fixes/` (roadmap, Plans 01, 03, 04, 05) | Protected dirty-state baseline before any write (Phase 0); explicit commit authorization; a validation owner per phase; objective exit criteria; scope and non-goals; single ownership of each lane. The broken links belong to Plan 01 and are not edited here. Plan 05 freezes the "effective instruction stack", and these workflow edits change that stack, hence the per-phase commits and recorded SHAs. Plan 04 owns the raw "ask only when materially ambiguous" rule, which is the same as R7. "A rejected pilot is a valid outcome" |
| `Drag-Free-v2/` engineering-quality proposal | Tiering as the load-bearing guard against process tax; rules phrased as checkable questions; ≤80-line standards body plus language appendix; the July survey's Q1–Q8 questions reused as a before/after measure (Phase E) |
| `Drag-Free-v2/` v2 redesign (KI-2, KI-10) | "Reference, don't restate": the template moves out of `00-research-and-plan.md` into a shared contract rather than growing a 333-line workflow; positive-token validators instead of retired-sentence blacklists; the v2 platform can later *move* the new `00-meta/` files, and nothing here depends on the `wf` CLI, frontmatter or `core/` |

## Assumptions

- The active line stays `v1.82` for the duration (confirm by: `git branch --show-current` at Phase 0).
- No Astra evaluation run is using the live `v1.82` tree as an arm while this plan executes (confirm by: ask the Plan 05 owner at Phase 0; Plan 05 is currently blocked on Plan 01).
- Host projects pick up changes through `scripts/sync-workflow-scripts.sh`, so each phase must be internally consistent when it lands (confirm by: reading the sync script's mode at Phase 0).
- The user authorizes commits per phase. Without authorization, work stays uncommitted and each phase report records a diff hash instead (engineering-standards §5 draft rule).

## Scope and non-goals

**In scope:** `01-planning-and-organizing/`, `02-code-build/`, the shared contracts in `00-Meta-Workflow/00-meta/`, the review and refactoring references named in the Change Surface, `scripts/validation/`, `.github/workflows/validation.yml`, the two skills in `11-Skills/` that restate these rules, and the READMEs that restate them.

**Non-goals:** the v2 platform (frontmatter, `wf` CLI, `core/`, role registry); July KI-12 (full design workflow and ADR directory), KI-15 (greenfield lane), KI-16 (deploy workflow) and KI-17 (debt ledger directory); observability and security baselines (July KI-13 partials 3–4); repairing the 4 broken links (Plan 01's lane); host-project code, including the Flash-UI residuals (the Flash-UI plan owns those); behavioral A/B testing of agents (the Plan 03 harness); rewriting historical or archived plans.

## Change Surface

Every site that states a rule this plan changes. "Class" = implements / restates / guards / historical (historical = not edited).

| Behavior | Sites (file:line) | Class | Found with |
|---|---|---|---|
| Phase order = priority | `01-planning-and-organizing/00-research-and-plan.md:123-127`; `02-finalise-plan.md:15`; `02-finalise-plan.md:103`; `01-plan-review.md:99`; `00-Meta-Workflow/00-meta/severity-priority-rubric.md` §Ordering Rule; `01-planning-and-organizing/README.md:77-102`; `README.md:828` | implements ×4, restates ×3 | `grep -rnE 'Phase 1 = P0\|phase numbering must follow priority\|Larger redesigns are explicitly deferred\|speculative refactors\|priority ordering' --exclude-dir=00-project --exclude-dir=.git .` |
| Phase order (already correct) | `11-Skills/workflow-plan-review-finalize/SKILL.md:38` ("severity and dependency order") | restates (keep) | same search plus `grep -n 'dependency' 11-Skills/*/SKILL.md` |
| Same rule, historical | `12-SEO-GEO-checklist/2026-03-18-SEO-Dashboard/…-implementation-plan.md:1096` | historical | same search |
| Plan template | `00-research-and-plan.md:216-261`; §2.3 task rules `:138-143`; status marker `:268` | implements | `grep -rlnE '# Implementation Plan: \|\*\*Status:\*\* DRAFT' --exclude-dir=00-project .` |
| `Not Eligible` routing | `02-code-build/04-review-finalise-commit-execute.md:35, 48` (defect); `03-execute-and-confirm.md`, `02-confirm-execution.md`, `README.md`, `04-documentation/03-mark-completed.md`, `04-documentation/README.md:109`, `11-Skills/execute-and-confirm-plan/SKILL.md:39` (correct) | implements / guards | `grep -rlnE 'Not Eligible' --exclude-dir=00-project .` |
| Agent rosters | M3 row in the re-verification table | implements | `grep -nE 'aggressively\|librarian agents\|Use parallel agents' 01-planning-and-organizing/*.md 02-code-build/*.md` |
| Plan path | M4 row in the re-verification table | implements | `grep -rn 'project/build/' 02-code-build 01-planning-and-organizing`; `grep -nE '(^\|[^/a-z-])plans/' 02-code-build/01-execution.md` |
| Code-quality criteria | `02-code-build/01-execution.md:70` (no referent); `05-review/03-code-refactoring.md:77-89`; `05-review/01-code-review.md` focus list | implements | `grep -n 'code quality\|Focus' 02-code-build/01-execution.md 05-review/0[13]-*.md` |
| Debt → TODO | `04-documentation/03-mark-completed.md:161` | implements | `grep -n 'TODO' 04-documentation/03-mark-completed.md` |
| Evidence labels | `00-Meta-Workflow/00-meta/review-workflow-core.md:38-42`; `00-research-and-plan.md:294-297` ("no unverified claims") | implements | `grep -rn 'hypothes\|unverified claims' 00-Meta-Workflow/00-meta 01-planning-and-organizing` |
| Validators and CI | `scripts/validation/check-completion-chain-policy.sh`, `check-review-workflow-policy.sh`, `.github/workflows/validation.yml:5-12`, `scripts/hooks/pre-commit` | guards | `ls scripts/validation scripts/hooks` |

## Decision

Four decisions. Each lists the minimal option first.

**D1 — Where the plan template lives**
- **Option A (minimal):** Edit the template in place in `00-research-and-plan.md:216-261`. Pros: one edit. Cons: grows a 333-line workflow; `02-finalise-plan.md`, `01-execution.md` and `check-plan.sh` would each have to restate or re-derive the required sections.
- **Option B:** New shared contract `00-Meta-Workflow/00-meta/plan-template.md` (template, tier rule, per-section guidance). Workflows link to it, and `check-plan.sh` enforces the same section list.
- **Chosen:** B. It follows the `review-workflow-core.md` pattern, which is the least drift-prone family in the repo (research §2; July KI-2). **Reversibility:** cheap (inline it back).

**D2 — Home for the new structural lints (E4, E5, invariants)**
- **Option A (minimal):** Extend `check-review-workflow-policy.sh`. Cons: that script's contract is the review family; mixing families blurs what a failure means.
- **Option B:** New `scripts/validation/check-planning-build-policy.sh`, added to CI, owning planning/build invariants and skill-token drift checks.
- **Chosen:** B. **Reversibility:** cheap.

**D3 — How `check-plan.sh` treats existing plans**
- **Option A (minimal):** A `--legacy` flag, as in the research. Cons: callers must know which plans are legacy, and the flag is easy to forget in hooks and CI.
- **Option B:** Enforce only when the plan declares `**Tier:**`. Without the header, print a warning and exit 0. New plans opt in by using the template; old plans and host plans (e.g. Flash-UI's active plan) are unaffected.
- **Chosen:** B. **Reversibility:** cheap (a flag can be added later).

**D4 — Engineering standards: one file or four partials**
- **Option A (minimal):** No new file. Add a short standards list inside `01-execution.md`. Cons: review workflows cannot reference it symmetrically, so the builder and the reviewer would still judge against different text.
- **Option B:** One `00-meta/engineering-standards.md` (§1 boundaries, §2 reuse, §3 errors, §4 tests, §5 recovery), ≤ ~80 lines plus a language appendix.
- **Option C:** July KI-13's four partials, including observability and security.
- **Chosen:** B. C adds observability and security scope that no current evidence requires (the Flash-UI case study shows no gap in either), and July's own risk table warns about standards growing into long style guides. **Reversibility:** cheap; v2 can split the file later.

## Design & Interfaces

| Artifact | Responsibility (one sentence) | Public interface | Hides |
|---|---|---|---|
| `00-meta/plan-template.md` | Defines what a plan must contain per tier. | Section names and the tier rule, which workflows link and `check-plan.sh` enforces | Per-section writing guidance and examples |
| `scripts/validation/check-plan.sh <plan>` | Checks a plan's structure, not its quality. | Exit 0 = pass or legacy warning; exit 1 = errors on stderr as `check-plan: <file>: <reason>` | awk parsing details |
| `scripts/validation/check-planning-build-policy.sh` | Keeps planning/build workflows and skills consistent with the contracts. | Exit code; one failure line per violated invariant | Grep patterns |
| `00-meta/engineering-standards.md` | States the build-to and judge-against criteria as checkable questions. | Numbered sections (§1–§5) that build and review workflows cite | Language appendix detail |

**Invariants**, and where each is enforced:
- Any code-build file that names `Not Eligible` also names `Reconcile only` (`check-completion-chain-policy.sh`, E2).
- No planning/build file says `aggressively` or `librarian agents`, and any file that says "parallel agents" links `workflow-applicability.md` (`check-planning-build-policy.sh`).
- No active workflow says "Phase 1 = P0" or "phase numbering must follow priority" (`check-planning-build-policy.sh`).
- The enabling-refactor sentence appears in `01-plan-review.md` and `02-finalise-plan.md` (`check-planning-build-policy.sh`).
- `01-execution.md`, `02-confirm-execution.md`, `01-plan-review.md`, `05-review/01-code-review.md` and `05-review/03-code-refactoring.md` each link `engineering-standards.md` (`check-planning-build-policy.sh`).
- Both skills contain `Change Surface` and `Verify:` (`check-planning-build-policy.sh`, E5).

**Reuse:** positive-token checks copy the style of `check-completion-chain-policy.sh` (`fail()` helper, `$CB` paths). Fixture self-tests copy `check-meta-logs-selftest.sh`. `check-plan.sh` starts from the research §7 E1 sketch, which the research ran on macOS bash 3.2 and BSD awk.

## Failure Modes & Recovery

| Failure | Detection | User sees | Recovery |
|---|---|---|---|
| A host pulls mid-migration (template changed, linter not yet shipped, or the reverse) | Phase lands as one commit; `check-planning-build-policy.sh` runs in CI on that commit | Nothing inconsistent, if each phase is atomic | `git revert <phase commit>`; the host re-syncs |
| CI goes red on `v1.82` after A2 because Plan 01 has not fixed the links yet | Validation run fails at "Check active Markdown links" | A red CI badge on `v1.82` | Expected and honest. It clears when Plan 01 P1.2 lands. Do not skip the step or exclude the file |
| New lint false positive (e.g. "parallel agents" in a quoted example) | Self-test fixtures; a first full run on the tree before the CI step is added | A blocked commit or a red CI run | Narrow the pattern and add a fixture for the case; never add an ignore list without a recorded reason |
| `check-plan.sh` diverges between BSD and GNU awk | Self-test runs locally (macOS) and in CI (ubuntu) | Different result per platform | Restrict to POSIX awk features; the fixture covering the divergence stays |
| Workflow edits contaminate an Astra arm | Phase 0 check; commit SHAs recorded per phase | — | Plan 05 pins the arm on recorded SHAs; no workflow edit during an active Astra run |
| Terminal-gate edit (C3) breaks the completion chain | `check-completion-chain-policy.sh` in the same commit | A red validator | Revert the C3 commit; the gate's text is restored |

## Test Strategy

- **Defect fixes (Phase A):** each invariant ships with a failing case before the fix. For example, the E2 loop prints `WOULD FAIL …04…` before M1 is fixed and nothing after. This is the repo's "Bugs: add regression test" rule applied to validators.
- **Linters:** fixture self-tests. `check-plan.sh` gets 6 fixtures (T1 pass, T2 pass, missing `Verify:`, single Decision option, legacy file without a Tier header that warns and exits 0, and Success Criteria checkboxes outside `## Tasks` that must pass). `check-planning-build-policy.sh` gets one negative fixture per invariant.
- **Dogfood:** `check-plan.sh` passes on this plan.
- **Retro-check (zero cost):** apply the R2 rule to Flash-UI's 2026-09-23 prompt-quality plan. The Change Surface search must list `lib/style-loader.ts:444, 506` and `lib/skill-loader.ts`, and classify `prompts/catalog/design-templates.txt` hits as non-mandates.
- **Forward pilot:** the next non-trivial Flash-UI plan uses the template. Pass = `check-plan.sh` passes and the post-build Change Surface re-run shows zero stale sites. A failed or declined pilot is a valid, recorded outcome.
- **Limit:** these tests check wording and structure, not whether agents follow the rules. Behavioral evidence is deferred (see Deferred & Debt).

## Rollout & Rollback

- One commit per phase on `v1.82`, after user authorization, each with its own `00-project` changelog (and troubleshooting where required) so `check-meta-logs.sh --staged` passes.
- Record each phase's commit SHA in the phase report and in [the v1.82 roadmap's](v1.82-fixes/00-meta-v1-82-fixes-roadmap.md) P3 closeout note so that Plan 05 can select clean arm boundaries.
- Rollback = `git revert <phase SHA>`. Phases B–D depend on earlier phases, so revert in reverse order.
- Hosts are unaffected until they sync. Host plans without `**Tier:**` are never failed by the linter (D3).

## Tasks

Phases are ordered by dependency, then risk. For this plan that order also matches priority (A, B = P1; C, D = P2; E = P3), so it satisfies both the current rule and R1. Phase C and Phase D are independent of each other after B and may run in either order.

### Phase 0: Baseline and gates (prerequisite)

**Exit:** baseline recorded; Plan 05 conflict cleared; commit authorization recorded (or "uncommitted mode" chosen).

1. [ ] Capture branch, `HEAD`, upstream and `git status --porcelain=v1`. List the pre-existing dirty paths as protected (currently: `00-project/changelog/index.md`, three untracked `changelog/docs/` entries, and the untracked `research/2026-09-23-astra-*` files and research review). These are not staged by this plan unless the user says so. (P1, Effort: S)
   - Files: none (record in the Phase 0 report)
   - Verify: after each phase, `git status --porcelain=v1` differs from the baseline only in this plan's Change Surface and log entries → no protected path appears in `git diff --cached --name-only` (cost/prereqs: none)
2. [ ] Confirm with the user/Plan 05 owner that no Astra run uses the live tree; record the pre-change SHA. (P1, Effort: S)
   - Files: this plan (Phase 0 report)
   - Verify: SHA and confirmation recorded in the report (cost/prereqs: user answer)
3. [ ] Get commit authorization for per-phase commits, or choose uncommitted mode. (P1, Effort: S)
   - Files: none
   - Verify: the decision is recorded (cost/prereqs: user answer)

### Phase A: Repair the mechanics (P1)

**Scope:** M1–M4, M7, E2, E3, E4. **Depends on:** Phase 0. **Exit:** all validators pass locally except the 4 Plan 01 links; the CI trigger covers `v1.8*`; log entries exist.

1. [ ] M1: replace `04-review-finalise-commit-execute.md:35` and `:48` with the 03 wording (the gate always runs; `Not Eligible` uses Reconcile only). Add the E2 positive invariant to `check-completion-chain-policy.sh`. (P1, Effort: S)
   - Files: `02-code-build/04-review-finalise-commit-execute.md`, `scripts/validation/check-completion-chain-policy.sh`
   - Verify: before the fix, the E2 loop prints `WOULD FAIL …04…`; after it, `bash scripts/validation/check-completion-chain-policy.sh` → exit 0 (cost/prereqs: none)
2. [ ] E3: add `'v1.8*'` to `push.branches` and `pull_request.branches` in `validation.yml`, keeping `main`, `v1.8` and the fixture pattern. (P1, Effort: S)
   - Files: `.github/workflows/validation.yml`
   - Verify: after an authorized push, `gh run list --branch v1.82 --workflow Validation` shows a run. Every step except the links check passes until Plan 01 lands (cost/prereqs: push authorization, `gh` auth)
3. [ ] M2 links: hand over, don't edit. Record the corrected targets for Plan 01: link 3 → `../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`; link 4 → `../../../00-Meta-Workflow/00-meta/workflow-applicability.md`; links 1–2 → wherever Plan 01 files the recovered protocol (planned as the same directory, `./2026-09-10-astra-instruction-evaluation-protocol.md`). Add the note to `plans/TODO.md` under the v1.82 item. (P1, Effort: S)
   - Files: `00-project/plans/TODO.md`
   - Verify: the TODO row names all 4 links and their targets. The final check (`check-active-markdown-links.sh` → exit 0) is owned by Plan 01 (cost/prereqs: Plan 01)
4. [ ] M3 + E4: replace the rosters at the M3 sites with the §1.2 pattern (a one-line link to `workflow-applicability.md` sizing plus a role *menu*). Delete "aggressively". Move `01-execution.md:66-76` review to after the change. Create `check-planning-build-policy.sh` with the sizing invariant and a negative fixture, and add it to CI. (P1, Effort: M)
   - Files: `01-planning-and-organizing/00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, `02-code-build/01-execution.md`, `02-confirm-execution.md`, `scripts/validation/check-planning-build-policy.sh`, `.github/workflows/validation.yml`
   - Verify: `grep -nE 'aggressively|librarian agents' 01-planning-and-organizing/*.md` → empty; `bash scripts/validation/check-planning-build-policy.sh` → exit 0; the negative fixture → exit 1 (cost/prereqs: none)
5. [ ] M4: replace bare `plans/` and `project/build/` with `<metadata-root>/plans/` plus a link to Metadata Root Resolution. (P1, Effort: S)
   - Files: `02-code-build/01-execution.md`, `02-code-build/03-execute-and-confirm.md`
   - Verify: `grep -rn 'project/build/' 02-code-build 01-planning-and-organizing` → empty; `bash scripts/validation/check-completion-chain-policy.sh` → exit 0 (cost/prereqs: none)
6. [ ] M7 wording: `02-finalise-plan.md:1` title → "Finalise Plan"; `03-execute-and-confirm.md:15` marker attributed to the gate; `00-research-and-plan.md:268` drop the ✅ from the draft status; `:166-171` risk scale → rubric Impact × Likelihood; `02-finalise-plan.md:73-74` default to archiving `PLAN.reviews/`. (P3, Effort: S)
   - Files: `01-planning-and-organizing/02-finalise-plan.md`, `00-research-and-plan.md`, `02-code-build/03-execute-and-confirm.md`
   - Verify: `grep -n 'Ready for Review ✅' 01-planning-and-organizing/*.md` → empty; `head -1 01-planning-and-organizing/02-finalise-plan.md` → contains "Finalise Plan" (cost/prereqs: none)
7. [ ] Logs: `changelog/fixed/` and a matching `troubleshooting/workflow/` entry for each of M1, M3, M4 and the CI gap (E3). M7 gets a `changed/` entry. Add the rows to both indexes. (P1, Effort: S)
   - Files: `00-project/changelog/…`, `00-project/troubleshooting/…`
   - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

### Phase B: Planning quality (P1)

**Scope:** R1, R2, R3, R8, E1, E5, M5, M6. **Depends on:** Phase A (green local validators; `check-planning-build-policy.sh` exists). **Exit:** the template contract exists and is linked; `check-plan.sh` and its self-test pass in CI; this plan passes `check-plan.sh`; all 7 phase-order sites agree.

1. [ ] D1: create `00-meta/plan-template.md` from research §8, with these changes: the Risks table uses the rubric's scales (Impact Low/Medium/High, Likelihood Rare/Possible/Likely, with S0–S3); add a Scope and non-goals section; each `Verify:` names cost and prerequisites (R5 hook); add the tier rule and default-tier inference. Replace `00-research-and-plan.md:216-261` and §2.3 `:138-143` with a link to it. (P1, Effort: M)
   - Files: `00-Meta-Workflow/00-meta/plan-template.md`, `00-Meta-Workflow/00-meta/README.md`, `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `bash scripts/validation/check-active-markdown-links.sh` shows no new broken links; `wc -l 01-planning-and-organizing/00-research-and-plan.md` is lower than 333 (cost/prereqs: none)
2. [ ] R1: phases ordered by dependency, then risk; each task carries its own P label; add the enabling-refactor rule (research §5 R1 wording) next to the over-engineering checks. Update all 7 phase-order sites in the Change Surface. For the rubric's Ordering Rule: findings in reports stay ordered P0→P3; plans order phases by dependency and tasks within a phase by priority. Adopt the skill's wording. (P1, Effort: M)
   - Files: `00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, `01-planning-and-organizing/README.md`, `README.md`, `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
   - Verify: `grep -rnE 'Phase 1 = P0|phase numbering must follow priority' --exclude-dir=00-project --exclude-dir=12-SEO-GEO-checklist .` → empty; `check-planning-build-policy.sh` (enabling-refactor invariant added) → exit 0 (cost/prereqs: none)
3. [ ] R2: add a Change Surface step to `00-research-and-plan.md` §1.4 (list every site that implements, duplicates or falls back to the behavior, give the search command, and classify each hit); `01-plan-review.md` re-runs the searches; `02-confirm-execution.md` re-runs them after build and treats stale hits as incomplete. (P1, Effort: S)
   - Files: `00-research-and-plan.md`, `01-plan-review.md`, `02-code-build/02-confirm-execution.md`
   - Verify: `grep -l 'Change Surface' 01-planning-and-organizing/00-research-and-plan.md 01-planning-and-organizing/01-plan-review.md 02-code-build/02-confirm-execution.md` lists all 3 (cost/prereqs: none)
4. [ ] R3 + R8: Decision with ≥2 options including the minimal one, plus reversibility; one-way decisions get a review flag. Each top-level task has `Files:` and `Verify:` lines; `01-execution.md`'s tick rule points at the task's `Verify:` line. (P1, Effort: S)
   - Files: `00-meta/plan-template.md`, `01-plan-review.md`, `02-code-build/01-execution.md`
   - Verify: `grep -n 'Verify:' 02-code-build/01-execution.md` → at least 1 hit in the tick rule (cost/prereqs: none)
5. [ ] E1: `scripts/validation/check-plan.sh` (D3 activation; the `Verify:` check is scoped to `## Tasks`, research gap 4), `check-plan-selftest.sh` with the 6 fixtures listed in Test Strategy under `scripts/validation/fixtures/check-plan/`, and a CI step. Reference it from `02-finalise-plan.md` acceptance criteria and from `01-execution.md` Preparation, including the host-side path (`<workflow-scripts>/scripts/validation/check-plan.sh <plan>`). (P1, Effort: M)
   - Files: `scripts/validation/check-plan.sh`, `scripts/validation/check-plan-selftest.sh`, `scripts/validation/fixtures/check-plan/*`, `.github/workflows/validation.yml`, `01-planning-and-organizing/02-finalise-plan.md`, `02-code-build/01-execution.md`
   - Verify: `bash scripts/validation/check-plan-selftest.sh` → exit 0 on macOS and in CI; `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md` → exit 0 (cost/prereqs: none)
6. [ ] M5 + M6: `02-finalise-plan.md` marks the source plan `**Status:** Superseded by <link>`. Appending workflows (`01-plan-review.md`, `02-confirm-execution.md`) keep a "Current state" block at the top of the appended document, one line per open recommendation. (P2, Effort: S)
   - Files: `01-planning-and-organizing/02-finalise-plan.md`, `01-plan-review.md`, `02-code-build/02-confirm-execution.md`
   - Verify: `grep -n 'Superseded by' 01-planning-and-organizing/02-finalise-plan.md` and `grep -ln 'Current state' 01-planning-and-organizing/01-plan-review.md 02-code-build/02-confirm-execution.md` → hits in all 3 files (cost/prereqs: none)
7. [ ] E5: update `11-Skills/workflow-plan-review-finalize/SKILL.md` and `11-Skills/execute-and-confirm-plan/SKILL.md` (Change Surface, `Verify:`, plan-template link); add the token checks to `check-planning-build-policy.sh`. (P2, Effort: S)
   - Files: the two `SKILL.md` files, `scripts/validation/check-planning-build-policy.sh`
   - Verify: `bash scripts/validation/check-planning-build-policy.sh` → exit 0; deleting `Verify:` from a fixture copy of a skill → exit 1 (cost/prereqs: none)
8. [ ] Logs: `changelog/changed/` (template, rules) and `changelog/added/` (linters); no troubleshooting entry, because these are new rules rather than defect fixes. (P1, Effort: S)
   - Files: `00-project/changelog/…`
   - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

### Phase C: Engineering standards (P2)

**Scope:** research §6, Q6. **Depends on:** Phase B (the template sections it references). **Exit:** `engineering-standards.md` exists (body ≤ ~90 lines) and is linked from all 5 build/review workflows; the Deferred & Debt → TODO step is live in the gate; completion-chain and review-policy validators pass.

1. [ ] Author `00-meta/engineering-standards.md` following research §6 §1–§5, each rule a checkable question, plus a language appendix (TypeScript, Python, shell). Keep the paradigm note (composition, functional core in hook-based code; no class hierarchies required). (P2, Effort: M)
   - Files: `00-Meta-Workflow/00-meta/engineering-standards.md`, `00-Meta-Workflow/00-meta/README.md`
   - Verify: `awk '/^## Appendix/{exit} {n++} END{print n}' 00-Meta-Workflow/00-meta/engineering-standards.md` ≤ 90 (cost/prereqs: none)
2. [ ] Wire forward: `01-execution.md` Preparation (load Design, Decision and Change Surface plus the standards), Implement (search for reuse first; re-run Change Surface after the change; record shortcuts in Deferred & Debt), phase report (checkpoint reference); `02-confirm-execution.md` checks the built code against Design and Failure Modes. `01-execution.md:70` "code quality" links §1–§3. (P2, Effort: S)
   - Files: `02-code-build/01-execution.md`, `02-code-build/02-confirm-execution.md`
   - Verify: `check-planning-build-policy.sh` standards-link invariant → exit 0 (cost/prereqs: none)
3. [ ] Wire backward: replace `05-review/03-code-refactoring.md:77-89` and the `01-code-review.md` focus list with links to the standards sections, keeping the domain-specific additions. `01-plan-review.md` judges the Design section against §1–§3. (P2, Effort: S)
   - Files: `05-review/01-code-review.md`, `05-review/03-code-refactoring.md`, `01-planning-and-organizing/01-plan-review.md`
   - Verify: `bash scripts/validation/check-review-workflow-policy.sh` → exit 0; `check-planning-build-policy.sh` → exit 0 (cost/prereqs: none)
4. [ ] Q6: the terminal gate copies open Deferred & Debt entries into the host TODO (under the existing `03-mark-completed.md:161` host-TODO rule, with no new location); `00-research-and-plan.md` Phase 1 reads open entries that touch the Change Surface. (P2, Effort: S)
   - Files: `04-documentation/03-mark-completed.md`, `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `bash scripts/validation/check-completion-chain-policy.sh` → exit 0; `grep -n 'Deferred & Debt' 04-documentation/03-mark-completed.md` → at least 1 hit (cost/prereqs: none)
5. [ ] Strengthen `03-debugging/02-bug-fix-workflow.md:151` (failing test first) to a required step with a link to standards §4. (P2, Effort: S)
   - Files: `03-debugging/02-bug-fix-workflow.md`
   - Verify: `grep -n 'engineering-standards.md' 03-debugging/02-bug-fix-workflow.md` → at least 1 hit (cost/prereqs: none)
6. [ ] Logs: `changelog/added/` (standards) and `changelog/changed/` (wiring). (P2, Effort: S)
   - Files: `00-project/changelog/…`
   - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

### Phase D: Research and review rigor (P2)

**Scope:** R4–R7. **Depends on:** Phase B (template `Verify:` cost field). Independent of Phase C except that R6 links the standards file if C has landed. **Exit:** the research standard is linked from `00-research-and-plan.md`; the plan review has the feasibility check and the checklist.

1. [ ] R4: add a research standard (claim labels; primary sources with access date and version; commit pin; re-verify claims whose files changed since the pinned commit (`git diff --stat <sha>..HEAD -- <paths>`); state what was not checked; replace "no unverified claims" with "no unlabeled claims"). Extend `review-workflow-core.md` §Evidence Quality with the label set so research and review share one vocabulary. Map the Astra labels to it in one line. (P2, Effort: S)
   - Files: `00-Meta-Workflow/00-meta/review-workflow-core.md`, `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `grep -n 'unverified claims' 01-planning-and-organizing/00-research-and-plan.md` → empty; `bash scripts/validation/check-review-workflow-policy.sh` → exit 0 (cost/prereqs: none)
2. [ ] R5 + R6: add the feasibility check (each exit criterion is achievable in the expected environment; otherwise split it into a separate evaluation plan or get authorization now) and the review checklist (completeness, boundaries, failure, reversibility, pre-mortem, feasibility) to `01-plan-review.md`. (P2, Effort: S)
   - Files: `01-planning-and-organizing/01-plan-review.md`
   - Verify: `grep -nE 'Pre-mortem|Feasibility' 01-planning-and-organizing/01-plan-review.md` → at least 2 hits (cost/prereqs: none)
3. [ ] R7: replace the generic intake list (`00-research-and-plan.md:46-57`) with the ask-or-assume rule and an Assumptions list. **Coordinate with v1.82 Plan 04:** if Plan 04 has adopted the same rule for agent files, link to it instead of restating it; otherwise land it workflow-scoped and add this site to Plan 04's inventory note. (P3, Effort: S)
   - Files: `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `grep -n 'Assumptions' 01-planning-and-organizing/00-research-and-plan.md` → at least 1 hit (cost/prereqs: Plan 04 status check)
4. [ ] Logs: `changelog/changed/`. (P2, Effort: S)
   - Files: `00-project/changelog/…`
   - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

### Phase E: Reconcile and measure (P3)

**Scope:** research §9 Phase E, plus the before/after measure. **Depends on:** Phases B–D. **Exit:** July proposal status recorded; survey re-run filed; TODO updated.

1. [ ] Run `01-plan-review.md` on `Drag-Free-v2/2026-07-06-engineering-quality-and-lifecycle-proposal.md`: mark KI-13 (partials 1–2) and KI-14 as superseded by Phases B–C with links (extraction tags and refreshed citations were already added on 2026-09-25, so this step only turns **Extracted →** tags into superseded status); keep KI-12, KI-15, KI-16, KI-17 and KI-13 partials 3–4 as open. Add the proposal to `plans/TODO.md` (it is not listed there today). (P3, Effort: S)
   - Files: the July proposal (review addendum), `00-project/plans/TODO.md`
   - Verify: the addendum names each KI with its status; the TODO row exists (cost/prereqs: none)
2. [ ] Re-run the July survey's 8 questions (`Drag-Free-v2/workflow-engineering-quality-survey-260706-0137-gpt55.md`) against the new tree and file the result as `research/engineering-quality-survey-rerun-YYMMDD-HHMM-<model>.md`. Expected: Q1–Q3 and Q8 move from PARTIAL to COVERED; Q7 moves to PARTIAL+; Q4–Q6 stay PARTIAL (non-goals). (P3, Effort: S)
   - Files: `00-project/research/…`
   - Verify: the report exists with a before/after table and every change cites a file:line (cost/prereqs: none)
3. [ ] Optional: extend `scripts/hooks/pre-commit` to also run the links, completion-chain and planning-build validators, plus `check-plan.sh` on staged plan files that declare a Tier. (P3, Effort: S)
   - Files: `scripts/hooks/pre-commit`
   - Verify: staging a fixture plan that lacks `Verify:` blocks the commit; staging this plan does not (cost/prereqs: none)
4. [ ] Hand off to the execution chain: this plan's completion runs through `02-code-build/03-execute-and-confirm.md` and the terminal gate. (P3, Effort: S)
   - Files: this plan
   - Verify: the terminal gate outcome is recorded (cost/prereqs: none)

## Dependencies

```
Phase 0 ──► A ──► B ──┬──► C ──┐
                      └──► D ──┴──► E
v1.82 Plan 01 (P1.2 links) ──► "CI green on v1.82" success criterion
v1.82 Plan 04 status ──► D3 (R7) wording choice
v1.82 Plan 05 ◄── recorded phase SHAs (arm boundaries)
```

- **Critical path:** 0 → A → B → C → E.
- **Parallel:** C and D after B. Within Phase A, tasks 1, 2, 4 and 5 touch different files and are independent.
- **External:** push authorization (A2); the Plan 01 owner for links (A3); the Flash-UI owner for the forward pilot.

## Deferred & Debt

- **Behavioral evidence** that agents follow the new rules (structure ≠ behavior) — the v1.82 Plan 03 harness — trigger: harness concept test passes — S2.
- **Superseded-plan lint** (a superseded plan still listed as active in TODO) — `check-plan.sh` — trigger: first observed stale-TODO case — S3.
- **`research/` filename convention mixing** (M7 bullet 5) — `00-project/research/` — trigger: next meta-hygiene plan — S3.
- **Standalone ADRs and `<metadata-root>/decisions/`** (July KI-12) — `naming-conventions.md` — trigger: first T3 plan or first one-way decision — S3.
- **Host-project verify gates** (research E6) — `00-project-setup/` — trigger: the next project setup — S3.

## Risks

| Risk | Impact (S) | Likelihood | Mitigation |
|---|---|---|---|
| Process tax on small changes | Medium (S2) | Likely without tiers | T1 = Goal, Change Surface, Tasks only; linter enforces T2+ sections only when the Tier is T2+; success criterion "T1 ≤ ~20 lines" |
| Rule restated in a site this plan missed, creating a new contradiction | Medium (S2) | Possible | The Change Surface searches are part of each task's `Verify:`; the positive invariants in `check-planning-build-policy.sh` catch regressions |
| Standards file becomes an unread style guide | Low (S3) | Possible | ≤ ~90-line body; checkable questions; reviewers cite section numbers |
| Linters create false confidence | Medium (S2) | Possible | Linters guarantee reviewable inputs only; judgement stays with the R6 review; behavioral evidence is tracked in Deferred & Debt |
| Collision with the v2 redesign or July proposal | Low (S3) | Possible | Everything lives in the existing `00-meta/` mechanism; Phase E records which KIs are superseded |
| Contaminating an Astra arm | Medium (S2) | Rare | Phase 0 check; one commit per phase with SHAs recorded |
| CI red on `v1.82` read as a regression | Low (S3) | Likely until Plan 01 lands | Named in Failure Modes; the A3 TODO row explains the cause |

## Success Criteria

- [ ] All validators, including the new `check-plan-selftest.sh` and `check-planning-build-policy.sh`, pass in CI on `v1.82` (after Plan 01 P1.2).
- [ ] The E2 loop and the M3 grep are empty; the 7 phase-order sites agree.
- [ ] This plan passes `check-plan.sh`; the retro-check lists `lib/style-loader.ts:444, 506` and `lib/skill-loader.ts` and classifies the catalog hits.
- [ ] The next non-trivial Flash-UI plan uses the template, passes `check-plan.sh`, and its post-build Change Surface re-run shows zero stale sites (or a declined or failed pilot is recorded with its reason).
- [ ] No T1 plan written on the template exceeds about 20 lines.
- [ ] `engineering-standards.md` is linked from all 5 build and review workflows (validator-enforced).
- [ ] The survey re-run shows Q1–Q3 and Q8 COVERED.
