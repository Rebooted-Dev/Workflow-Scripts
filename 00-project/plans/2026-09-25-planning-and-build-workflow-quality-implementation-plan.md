# Implementation Plan: Planning and Code-Build Workflow Quality

**Created:** 2026-09-25 15:10
**Status:** Active — Not Eligible (Reconcile only; Plan 01 links and separately authorized remote CI remain pending)
**Tier:** T2
**Research:** [`planning-and-build-workflow-quality-review-260925-1347-claude.md`](../research/planning-and-build-workflow-quality-review-260925-1347-claude.md) (researched at `1ab9fcb`, inferred from the 13:47 report time vs the 13:39 commit; re-verified at the same commit on 2026-09-25, see [Research summary](#research-summary-and-re-verification)). The source documents are annotated: the research carries in-place corrections and a `Plan:` line per finding, and the Drag-Free-v2 and v1.82-fixes documents carry extraction or cross-reference notes.
**Workflow:** [`00-research-and-plan.md`](../../01-planning-and-organizing/00-research-and-plan.md). Pre-execution review by a different model is incorporated below; execute locally through [`03-execute-and-confirm.md`](../../02-code-build/03-execute-and-confirm.md).
**Validation owner:** parent orchestrator (the session that executes the plan), per phase.

This plan is written on the template it proposes (research §8). That makes it the first pilot: Phase B's `check-plan.sh` must pass on this file.

**Pre-execution review addendum (2026-09-25).** Decision: **Ready for local execution — remote CI/pilot pending**. DRAFT provenance is retained; this disposition is not a claim that implementation, remote CI, or the Flash-UI pilot has completed. The baseline, confirmed Astra status, commit/push authorization, link-failure handling, write ownership, and deferred pilot are recorded below. `.gitignore`/`.ignore` deepwork setup is separate from this plan and its baseline.

## Goal

Make the planning → build chain decide **what to build and how to shape it** as rigorously as it already proves **what was done**. Concretely:

1. Repair the four live mechanics defects (M1–M4), so the chain's own rules agree with each other and CI checks the active line.
2. Make plans carry the inputs that prevent incomplete fixes: a **Change Surface** with search commands, a **Decision** with at least 2 options, and a **Verify:** line per task. Order phases by dependency and risk rather than by priority, and enforce the structure with a host-usable plan linter.
3. Give builders and reviewers **one shared engineering standard** (boundaries, reuse, errors/recovery, tests, checkpoints), referenced forward from planning and execution and backward from review.

**Success is observable:** this plan passes `check-plan.sh` as the first dogfood case; its Change Surface searches, re-run after the build, show zero stale sites; applicable non-link local validators pass and the link checker reports no failures beyond the four recorded Plan 01 failures. A future host-plan pilot and remote CI on `v1.8*` remain external follow-ups. The named representative T1 fixture stays within about 20 lines (not a limit asserted for every T1 plan).

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

- The baseline is on branch `v1.82` tracking `origin/v1.82` (recorded in the Phase 0 report); re-confirm the branch before each phase and pause if it changes.
- The user confirmed at Phase 0 that no live Astra arm is using the tree. If an arm starts before this plan completes, pause workflow edits and coordinate with the Plan 05 owner.
- The sync script uses ff-only Git sync but stashes dirty changes; it does not sync a host project. Do not run host sync as part of this plan. Deepwork setup is separate.
- The user authorized local per-phase commits, but **did not authorize any push**. Keep remote CI pending; do not make a push part of a local phase gate.

## Scope and non-goals

**In scope:** `01-planning-and-organizing/`, `02-code-build/`, `03-debugging/02-bug-fix-workflow.md`, the shared contracts in `00-Meta-Workflow/00-meta/`, the review and refactoring references named in the Change Surface, `scripts/validation/`, `.github/workflows/validation.yml`, the two skills in `11-Skills/` that restate these rules, and the READMEs that restate them.

**Non-goals:** the v2 platform (frontmatter, `wf` CLI, `core/`, role registry); July KI-12 (full design workflow and ADR directory), KI-15 (greenfield lane), KI-16 (deploy workflow) and KI-17 (debt ledger directory); observability and security baselines (July KI-13 partials 3–4); repairing the 4 broken links (Plan 01's lane); host-project code, including the Flash-UI residuals (the Flash-UI plan owns those); behavioral A/B testing of agents (the Plan 03 harness); rewriting historical or archived plans. The Flash-UI forward pilot is deferred to its owner/TODO; this plan makes no host-project modifications.

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
| Regression-test-first guidance in the debug workflow | `03-debugging/02-bug-fix-workflow.md:151` | implements | `grep -nE 'failing test|regression test|engineering-standards' 03-debugging/02-bug-fix-workflow.md` |
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
| A later, separately authorized remote CI run reports the known links before Plan 01 fixes them | The link-check step reports the four recorded Plan 01 links | The run is not green; local phase validation is unaffected | Report the remote result honestly; do not skip or exclude the link check. Plan 01 P1.2 owns repair; after repair, rerun the full check |
| A local phase introduces a new broken Markdown link | Run `check-active-markdown-links.sh` and compare its failure set with the recorded Plan 01 baseline | A new failure blocks that phase | Fix the new link; never hide it by skipping or suppressing the checker |
| New lint false positive (e.g. "parallel agents" in a quoted example) | Self-test fixtures; a first full run on the tree before the CI step is added | A blocked commit or a red CI run | Narrow the pattern and add a fixture for the case; never add an ignore list without a recorded reason |
| `check-plan.sh` diverges between BSD and GNU awk | Self-test runs locally (macOS) and in CI (ubuntu) | Different result per platform | Restrict to POSIX awk features; the fixture covering the divergence stays |
| Workflow edits contaminate an Astra arm | Phase 0 check; commit SHAs recorded per phase | — | Plan 05 pins the arm on recorded SHAs; no workflow edit during an active Astra run |
| Terminal-gate edit (C3) breaks the completion chain | `check-completion-chain-policy.sh` in the same commit | A red validator | Revert the C3 commit; the gate's text is restored |

## Test Strategy

- **Local versus remote:** the parent owns validation. Local checks are the phase gates; remote CI is a separate, pending check because push is not authorized. Run `check-active-markdown-links.sh` locally at baseline and after every phase. Exactly the four existing Plan 01 failures are tolerated while they remain; record them, do not skip/suppress/exclude the link check, and block on any new failure. If Plan 01 repairs some or all, only the still-unfixed subset may remain. A nonzero link-check exit is not reported as a pass.
- **Defect fixes (Phase A):** each invariant ships with a failing case before the fix. For example, the E2 loop prints `WOULD FAIL …04…` before M1 is fixed and nothing after. This is the repo's "Bugs: add regression test" rule applied to validators.
- **Linters:** fixture self-tests. `check-plan.sh` gets 6 fixtures (`t1-pass.md`, T2 pass, missing `Verify:`, single Decision option, legacy file without a Tier header that warns and exits 0, and Success Criteria checkboxes outside `## Tasks` that must pass). `t1-pass.md` is the named representative fixture for the approximate 20-line T1 example; it does not establish a universal T1 limit. `check-planning-build-policy.sh` gets one negative fixture per invariant.
- **Dogfood:** `check-plan.sh` passes on this plan.
- **Retro-check (zero cost):** apply the R2 rule to Flash-UI's 2026-09-23 prompt-quality plan. The Change Surface search must list `lib/style-loader.ts:444, 506` and `lib/skill-loader.ts`, and classify `prompts/catalog/design-templates.txt` hits as non-mandates.
- **Forward pilot:** deferred to the Flash-UI owner and recorded in TODO; no host-project modification is part of this plan. When the owner later runs a non-trivial pilot, evidence is `check-plan.sh` passing and the post-build Change Surface re-run showing zero stale sites. A failed, declined, or still-pending pilot is a valid, recorded outcome.
- **Survey:** predicted movement of Q1–Q3 and Q8 to COVERED and Q7 to PARTIAL+ is a hypothesis only. The rerun's documented evidence determines every rating; predictions are not acceptance criteria.
- **Limit:** these tests check wording and structure, not whether agents follow the rules. Behavioral evidence is deferred (see Deferred & Debt).

## Rollout & Rollback

- One local commit per phase on `v1.82`, authorized by the user, each with its own `00-project` changelog (and troubleshooting where required) so `check-meta-logs.sh --staged` passes. Do not push; remote CI remains pending until push is separately authorized and the Plan 01 links are repaired.
- Record each phase's commit SHA in the phase report and in [the v1.82 roadmap's](v1.82-fixes/00-meta-v1-82-fixes-roadmap.md) P3 closeout note so that Plan 05 can select clean arm boundaries.
- Rollback = `git revert <phase SHA>`. Phases B–D depend on earlier phases, so revert in reverse order.
- Hosts are unaffected until they sync. Host plans without `**Tier:**` are never failed by the linter (D3).

## Tasks

Phases are ordered by dependency, then risk. For this plan that order also matches priority (A, B = P1; C, D = P2; E = P3), so it satisfies both the current rule and R1. Phases C and D are logically independent after B, but shared-document edits must be sequential or have one coordinated writer (see Phase C).

### Phase 0: Baseline and gates (prerequisite)

**Exit:** baseline and user confirmation recorded; local per-phase commits authorized; push not authorized.

1. [✅] Capture branch, `HEAD`, upstream and `git status --porcelain=v1`. The baseline is clean; it predates the separately committed `.gitignore`/`.ignore` deepwork setup. (P1, Effort: S)
    - Files: none (record in the Phase 0 report)
    - Verify: retain the clean pre-setup baseline as recorded; the setup was separately committed as `823bc04`; before Phase A the only worktree change is this plan; ensure each subsequent phase stages only its Change Surface and log entries (cost/prereqs: none)
2. [✅] Confirm with the user/Plan 05 owner that no Astra run uses the live tree; record the pre-change SHA. (P1, Effort: S)
    - Files: this plan (Phase 0 report)
    - Verify: SHA and the user's no-live-arm confirmation are recorded in the report (cost/prereqs: user answer)
3. [✅] Get commit authorization for per-phase commits, or choose uncommitted mode. (P1, Effort: S)
    - Files: none
    - Verify: local per-phase commit authorization and the explicit no-push boundary are recorded (cost/prereqs: user answer)

**Phase 0 report (2026-09-25):** Baseline SHA `0593467932cbb548855d8080ec8e63185e6a6a53`; branch `v1.82`, upstream `origin/v1.82`; `git status --porcelain=v1` was clean. The separate `.gitignore`/`.ignore` deepwork setup and its log were committed as `823bc04`; post-setup status before Phase A contains only this plan's pre-execution amendments. The user confirmed no live Astra arm. Local per-phase commits are authorized; push is **not** authorized. `scripts/sync-workflow-scripts.sh` uses ff-only Git sync but stashes dirty changes; do not run it or host sync during implementation. Baseline validators: completion-chain, review-policy and meta-log self-test pass; the active-link check reports exactly four broken references in `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md` at lines 7, 95, 96 and 97, owned by Plan 01. No host project was changed.

### Phase A: Repair the mechanics (P1)

**Scope:** M1–M4, M7, E2, E3, E4. **Depends on:** Phase 0. **Exit:** applicable local validators pass; the active-link checker reports only the four still-unfixed Plan 01 baseline failures and no new failures; the CI trigger covers `v1.8*`; log entries exist. Remote CI is pending a later authorized push and Plan 01's link repairs, not a local phase gate.

**Write ownership:** A2 and A4 both edit `.github/workflows/validation.yml`; integrate these edits through one writer or sequentially. A4 and A5 both edit `02-code-build/01-execution.md`; likewise use one writer or sequential edits. Do not make concurrent writes to either shared file.

1. [✅] M1: replace `04-review-finalise-commit-execute.md:35` and `:48` with the 03 wording (the gate always runs; `Not Eligible` uses Reconcile only). Add the E2 positive invariant to `check-completion-chain-policy.sh`. (P1, Effort: S)
   - Files: `02-code-build/04-review-finalise-commit-execute.md`, `scripts/validation/check-completion-chain-policy.sh`
   - Verify: before the fix, the E2 loop prints `WOULD FAIL …04…`; after it, `bash scripts/validation/check-completion-chain-policy.sh` → exit 0 (cost/prereqs: none)
2. [✅] E3: add `'v1.8*'` to `push.branches` and `pull_request.branches` in `validation.yml`, keeping `main`, `v1.8` and the fixture pattern. (P1, Effort: S)
   - Files: `.github/workflows/validation.yml`
    - Verify: local inspection confirms both branch filters cover `v1.8*`; `gh run list --branch v1.82 --workflow Validation` is deferred until a push is separately authorized. Remote CI is currently pending, not passed. After a future authorized push, record the run and expect the link step to report only the four still-unfixed Plan 01 failures (cost/prereqs: push authorization, Plan 01 for link repair, `gh` auth)
3. [✅] M2 links: hand over, don't edit. The existing `plans/TODO.md` v1.82 item records the corrected targets for Plan 01: link 3 → `../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`; link 4 → `../../../00-Meta-Workflow/00-meta/workflow-applicability.md`; links 1–2 → wherever Plan 01 files the recovered protocol (planned as the same directory, `./2026-09-10-astra-instruction-evaluation-protocol.md`). Verify the existing item and do not duplicate it. (P1, Effort: S)
    - Files: `00-project/plans/TODO.md` (verify existing entry; edit only if a target is missing or wrong)
    - Verify: the TODO row names all 4 links and their targets; `check-active-markdown-links.sh` is run and reports exactly the four still-unfixed Plan 01 failures, with no new failures (cost/prereqs: Plan 01 owns repairs)
4. [✅] M3 + E4: replace the rosters at the M3 sites with the §1.2 pattern (a one-line link to `workflow-applicability.md` sizing plus a role *menu*). Delete "aggressively". Move `01-execution.md:66-76` review to after the change. Create `check-planning-build-policy.sh` with the sizing invariant and a negative fixture, and add it to CI. (P1, Effort: M)
   - Files: `01-planning-and-organizing/00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, `02-code-build/01-execution.md`, `02-confirm-execution.md`, `scripts/validation/check-planning-build-policy.sh`, `.github/workflows/validation.yml`
    - Verify: `grep -nE 'aggressively|librarian agents' 01-planning-and-organizing/*.md` → empty; `bash scripts/validation/check-planning-build-policy.sh` → exit 0; the negative fixture → exit 1; shared CI-file edits are integrated with A2 by one writer (cost/prereqs: none)
5. [✅] M4: replace bare `plans/` and `project/build/` with `<metadata-root>/plans/` plus a link to Metadata Root Resolution. (P1, Effort: S)
   - Files: `02-code-build/01-execution.md`, `02-code-build/03-execute-and-confirm.md`
    - Verify: `grep -rn 'project/build/' 02-code-build 01-planning-and-organizing` → empty; `bash scripts/validation/check-completion-chain-policy.sh` → exit 0; shared `01-execution.md` edits are integrated with A4 by one writer or sequentially (cost/prereqs: none)
6. [✅] M7 wording: `02-finalise-plan.md:1` title → "Finalise Plan"; `03-execute-and-confirm.md:15` marker attributed to the gate; `00-research-and-plan.md:268` drop the ✅ from the draft status; `:166-171` risk scale → rubric Impact × Likelihood; `02-finalise-plan.md:73-74` default to archiving `PLAN.reviews/`. (P3, Effort: S)
   - Files: `01-planning-and-organizing/02-finalise-plan.md`, `00-research-and-plan.md`, `02-code-build/03-execute-and-confirm.md`
   - Verify: `grep -n 'Ready for Review ✅' 01-planning-and-organizing/*.md` → empty; `head -1 01-planning-and-organizing/02-finalise-plan.md` → contains "Finalise Plan" (cost/prereqs: none)
7. [✅] Logs: `changelog/fixed/` and a matching `troubleshooting/workflow/` entry for each of M1, M3, M4 and the CI gap (E3). M7 gets a `changed/` entry. Add the rows to both indexes. (P1, Effort: S)
    - Files: `00-project/changelog/…`, `00-project/troubleshooting/…`
    - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

**Phase A report (2026-09-25; local; parent validation):** A1–A7 task-level local acceptance evidence is recorded above. The parent reports all repository validation scripts passed except the active Markdown link checker, and shell syntax plus `git diff --check` passed. `rg 'project/build/|Ready for Review ✅|aggressively|librarian agents'` over planning/build returned no matches. The completion-chain checker and the planning/build policy guard/self-test passed. E2's pre-fix scan printed `WOULD FAIL 02-code-build/04-review-finalise-commit-execute.md`; the post-fix completion-chain check passes. E3's local inspection confirms both push and pull-request filters include quoted `'v1.8*'`, with `main` and `v1.8` retained and the existing `ci-validation-fixture/**` push pattern preserved. The M7 wording changes were inspected: the plan-finalisation title and review-artifact archive default are updated, the draft marker is unadorned, the risk scale uses the shared rubric, and the completion marker is attributed to the gate.

**Known link-check baseline / handoff:** The active-link checker reports exactly the four pre-existing Plan 01 references in `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md` at lines 7, 95, 96, and 97; no new link failures were reported. The existing `00-project/plans/TODO.md:17` entry already records the four corrected targets, so no duplicate TODO item was added. Plan 01 still owns repairing those references. Remote CI has **not** run and is not claimed green; after Plan 01's link repair, it remains a separate follow-up requiring explicit push authorization. No push is authorized for this phase.

### Phase B: Planning quality (P1)

**Scope:** R1, R2, R3, R8, E1, E5, M5, M6. **Depends on:** Phase A (local validators pass, except any still-unfixed known Plan 01 links; `check-planning-build-policy.sh` exists). **Exit:** the template contract exists and is linked; `check-plan.sh` and its self-test pass locally; this plan passes `check-plan.sh`; all 7 phase-order sites agree. Remote CI remains pending until a later authorized push.

1. [✅] D1: create `00-meta/plan-template.md` from research §8, with these changes: the Risks table uses the rubric's scales (Impact Low/Medium/High, Likelihood Rare/Possible/Likely, with S0–S3); add a Scope and non-goals section; each `Verify:` names cost and prerequisites (R5 hook); add the tier rule and default-tier inference. Replace `00-research-and-plan.md:216-261` and §2.3 `:138-143` with a link to it. (P1, Effort: M)
   - Files: `00-Meta-Workflow/00-meta/plan-template.md`, `00-Meta-Workflow/00-meta/README.md`, `01-planning-and-organizing/00-research-and-plan.md`
    - Verify: `bash scripts/validation/check-active-markdown-links.sh` reports only the four still-unfixed Plan 01 baseline failures and no new broken links; `wc -l 01-planning-and-organizing/00-research-and-plan.md` is lower than 333 (cost/prereqs: none)
2. [✅] R1: phases ordered by dependency, then risk; each task carries its own P label; add the enabling-refactor rule (research §5 R1 wording) next to the over-engineering checks. Update all 7 phase-order sites in the Change Surface. For the rubric's Ordering Rule: findings in reports stay ordered P0→P3; plans order phases by dependency and tasks within a phase by priority. Adopt the skill's wording. (P1, Effort: M)
   - Files: `00-research-and-plan.md`, `01-plan-review.md`, `02-finalise-plan.md`, `01-planning-and-organizing/README.md`, `README.md`, `00-Meta-Workflow/00-meta/severity-priority-rubric.md`
    - Verify: `grep -rnE 'Phase 1 = P0|phase numbering must follow priority' 01-planning-and-organizing 02-code-build README.md 00-Meta-Workflow/00-meta/severity-priority-rubric.md` → empty (negative validator fixtures and historical plans are intentionally excluded); `check-planning-build-policy.sh` (enabling-refactor invariant added) → exit 0 (cost/prereqs: none)
3. [✅] R2: add a Change Surface step to `00-research-and-plan.md` §1.4 (list every site that implements, duplicates or falls back to the behavior, give the search command, and classify each hit); `01-plan-review.md` re-runs the searches; `02-confirm-execution.md` re-runs them after build and treats stale hits as incomplete. (P1, Effort: S)
   - Files: `00-research-and-plan.md`, `01-plan-review.md`, `02-code-build/02-confirm-execution.md`
   - Verify: `grep -l 'Change Surface' 01-planning-and-organizing/00-research-and-plan.md 01-planning-and-organizing/01-plan-review.md 02-code-build/02-confirm-execution.md` lists all 3 (cost/prereqs: none)
4. [✅] R3 + R8: Decision with ≥2 options including the minimal one, plus reversibility; one-way decisions get a review flag. Each top-level task has `Files:` and `Verify:` lines; `01-execution.md`'s tick rule points at the task's `Verify:` line. (P1, Effort: S)
   - Files: `00-meta/plan-template.md`, `01-plan-review.md`, `02-code-build/01-execution.md`
   - Verify: `grep -n 'Verify:' 02-code-build/01-execution.md` → at least 1 hit in the tick rule (cost/prereqs: none)
5. [✅] E1: `scripts/validation/check-plan.sh` (D3 activation; the `Verify:` check is scoped to `## Tasks`, research gap 4), `check-plan-selftest.sh` with the 6 fixtures listed in Test Strategy under `scripts/validation/fixtures/check-plan/`, and a CI step. Reference it from `02-finalise-plan.md` acceptance criteria and from `01-execution.md` Preparation, including the host-side path (`<workflow-scripts>/scripts/validation/check-plan.sh <plan>`). (P1, Effort: M)
   - Files: `scripts/validation/check-plan.sh`, `scripts/validation/check-plan-selftest.sh`, `scripts/validation/fixtures/check-plan/*`, `.github/workflows/validation.yml`, `01-planning-and-organizing/02-finalise-plan.md`, `02-code-build/01-execution.md`
    - Verify: `bash scripts/validation/check-plan-selftest.sh` → exit 0 locally on macOS; remote CI result is recorded only after a separately authorized push and is currently pending; `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md` → exit 0 (cost/prereqs: none)
6. [✅] M5 + M6: `02-finalise-plan.md` marks the source plan `**Status:** Superseded by <link>`. Appending workflows (`01-plan-review.md`, `02-confirm-execution.md`) keep a "Current state" block at the top of the appended document, one line per open recommendation. (P2, Effort: S)
   - Files: `01-planning-and-organizing/02-finalise-plan.md`, `01-plan-review.md`, `02-code-build/02-confirm-execution.md`
   - Verify: `grep -n 'Superseded by' 01-planning-and-organizing/02-finalise-plan.md` and `grep -ln 'Current state' 01-planning-and-organizing/01-plan-review.md 02-code-build/02-confirm-execution.md` → hits in all 3 files (cost/prereqs: none)
7. [✅] E5: update `11-Skills/workflow-plan-review-finalize/SKILL.md` and `11-Skills/execute-and-confirm-plan/SKILL.md` (Change Surface, `Verify:`, plan-template link); add the token checks to `check-planning-build-policy.sh`. (P2, Effort: S)
   - Files: the two `SKILL.md` files, `scripts/validation/check-planning-build-policy.sh`
   - Verify: `bash scripts/validation/check-planning-build-policy.sh` → exit 0; deleting `Verify:` from a fixture copy of a skill → exit 1 (cost/prereqs: none)
8. [✅] Logs: `changelog/changed/` (template, rules) and `changelog/added/` (linters); no troubleshooting entry, because these are new rules rather than defect fixes. (P1, Effort: S)
    - Files: `00-project/changelog/…`
    - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

**Phase B report (2026-09-25; parent validation):** B1–B8 have task-level local evidence. Gate 2 passed on its third attempt, and `bash scripts/validation/check-meta-logs.sh --staged` passed for the Phase B change set. The phase has not yet been pushed; remote CI remains pending.

- Parent ran shell syntax checks, all non-link validators, both fixture suites, and `check-plan.sh` on this T2 plan; all passed after remediation. Gate 2 passed on its third review attempt: legacy plans use existing acceptance/exit criteria plus the Verification Bar rather than requiring a new `Verify:`, and the linter now checks nested parent/child/grandchild field ownership and indented top-level tasks with positive and negative fixtures. The final non-blocking six-space child-field fixture was strengthened and the self-test rerun passed. Remote CI is pending a separately authorized push.
- B8's two changelog entries and index rows are present; parent staged the intended Phase B files and `check-meta-logs.sh --staged` returned `meta log checks OK`.
- Parent-reported supporting evidence: `00-research-and-plan.md` is 273 lines (below 333); the named T1 representative fixture is 14 lines; the B2 active-site grep excludes intentional negative fixtures and the site guard passes.
- Read-only retro-check: `lib/style-loader.ts:444,506` are mandates; `lib/skill-loader.ts:197` is a fallback. `prompts/catalog/design-templates.txt:23,35,53,77,113,125,137,149` and `btn-styles.txt` hits are user prompt examples, not universal mandates. No host files were changed; the Flash-UI pilot remains deferred to its owner/TODO.
- Active-link baseline remains exactly the four Plan 01 failures at lines 7, 95, 96, and 97; no new failures. Remote CI has not run and is pending authorized push; no CI success is claimed.
- Baseline references: Phase 0 SHA `0d0dce0`; Phase A local commit SHA `79d6841d708938e126cbc28c207fd1cedbef6ba5`. No Phase B commit was made.

### Phase C: Engineering standards (P2)

**Scope:** research §6, Q6, and debug-workflow regression guidance. **Depends on:** Phase B (the template sections it references). **Exit:** `engineering-standards.md` exists (body ≤ ~90 lines) and is linked from all 5 build/review workflows; the Deferred & Debt → TODO step is live in the gate; debug-workflow regression guidance allows manual evidence only when automation is infeasible and the reason is recorded; completion-chain and review-policy validators pass.

**Shared-document ownership with Phase D:** C3 and D2 both edit `01-planning-and-organizing/01-plan-review.md`; C4 and D1/D3 both edit `01-planning-and-organizing/00-research-and-plan.md`. These shared files must be edited sequentially or by one coordinated writer. Other C/D tasks may proceed in parallel only on disjoint files.

1. [✅] Author `00-meta/engineering-standards.md` following research §6 §1–§5, each rule a checkable question, plus a language appendix (TypeScript, Python, shell). Keep the paradigm note (composition, functional core in hook-based code; no class hierarchies required). (P2, Effort: M)
   - Files: `00-Meta-Workflow/00-meta/engineering-standards.md`, `00-Meta-Workflow/00-meta/README.md`
   - Verify: `awk '/^## Appendix/{exit} {n++} END{print n}' 00-Meta-Workflow/00-meta/engineering-standards.md` ≤ 90 (cost/prereqs: none)
2. [✅] Wire forward: `01-execution.md` Preparation (load Design, Decision and Change Surface plus the standards), Implement (search for reuse first; re-run Change Surface after the change; record shortcuts in Deferred & Debt), phase report (checkpoint reference); `02-confirm-execution.md` checks the built code against Design and Failure Modes. `01-execution.md:70` "code quality" links §1–§3. (P2, Effort: S)
   - Files: `02-code-build/01-execution.md`, `02-code-build/02-confirm-execution.md`
   - Verify: `check-planning-build-policy.sh` standards-link invariant → exit 0 (cost/prereqs: none)
3. [✅] Wire backward: replace `05-review/03-code-refactoring.md:77-89` and the `01-code-review.md` focus list with links to the standards sections, keeping the domain-specific additions. `01-plan-review.md` judges the Design section against §1–§3. (P2, Effort: S)
   - Files: `05-review/01-code-review.md`, `05-review/03-code-refactoring.md`, `01-planning-and-organizing/01-plan-review.md`
   - Verify: `bash scripts/validation/check-review-workflow-policy.sh` → exit 0; `check-planning-build-policy.sh` → exit 0 (cost/prereqs: none)
4. [✅] Q6: the terminal gate copies open Deferred & Debt entries into the host TODO (under the existing `03-mark-completed.md:161` host-TODO rule, with no new location); `00-research-and-plan.md` Phase 1 reads open entries that touch the Change Surface. (P2, Effort: S)
   - Files: `04-documentation/03-mark-completed.md`, `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `bash scripts/validation/check-completion-chain-policy.sh` → exit 0; `grep -n 'Deferred & Debt' 04-documentation/03-mark-completed.md` → at least 1 hit (cost/prereqs: none)
5. [✅] Strengthen `03-debugging/02-bug-fix-workflow.md:151` (failing test first) to a required regression step with a link to standards §4. Require automated regression evidence when feasible; when it is infeasible, permit manual regression evidence only with the concrete reason documented. (P2, Effort: S)
    - Files: `03-debugging/02-bug-fix-workflow.md`
    - Verify: `grep -n 'engineering-standards.md' 03-debugging/02-bug-fix-workflow.md` → at least 1 hit; regression guidance requires an automated test when feasible and documents the reason plus reproducible manual evidence when not (cost/prereqs: none)
6. [✅] Logs: `changelog/added/` (standards), `changelog/changed/` (wiring), and a matching `changelog/fixed/` plus `troubleshooting/workflow/` entry for the Gate 3 debt/TODO workflow defect. Both new entries and their index rows are staged; parent `bash scripts/validation/check-meta-logs.sh --staged` passed. (P2, Effort: S)
    - Files: `00-project/changelog/…`, `00-project/troubleshooting/workflow/…`
    - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 with the Phase C records, including the fixed/troubleshooting pair, staged (cost/prereqs: parent staging and validation; passed)

**Phase C report (2026-09-26; parent validation):** C1–C6 have task-level local evidence. Gate 3 passed after its focused debt/TODO correction. The missing fixed/troubleshooting pair and index rows are now staged; parent `bash scripts/validation/check-meta-logs.sh --staged` passed. Phase C has not been pushed; remote CI remains pending.

- Parent-reported local passes: `awk '/^## Appendix/{exit} {n++} END{print n}' 00-Meta-Workflow/00-meta/engineering-standards.md` → 41 lines before Appendix; `bash scripts/validation/check-planning-build-policy.sh`; `bash scripts/validation/check-planning-build-policy-selftest.sh`; `bash scripts/validation/check-review-workflow-policy.sh`; `bash scripts/validation/check-completion-chain-policy.sh`; `bash scripts/validation/check-plan-selftest.sh`; `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md` → T2 dogfood pass; and `bash scripts/validation/check-meta-logs-selftest.sh`. Parent also reports Bash syntax checks and orchestration, sync, and update checks passed; exact argv for those checks was not provided.
- Parent verified all five build/review links and the planning/build guard, the terminal-gate/planning debt-transfer checks, and debugging's §4 reference with automated-first/manual-evidence fallback. Gate 3 initially found two debt/TODO defects; remediation restored ordinary verified-task TODO reconciliation alongside open debt transfer, and clarified that triggers prompt reassessment rather than closure. The completion-chain policy guard and focused Gate 3 re-review passed.
- Parent-reported `bash scripts/validation/check-active-markdown-links.sh` output remains exactly the four known Plan 01 links at lines 7, 95, 96, and 97; no new failures. Remote CI has not run; no CI success is claimed.
- The original added/changed Phase C records plus the fixed/troubleshooting pair and index rows are staged. Parent `bash scripts/validation/check-meta-logs.sh --staged` passed with the required records present. Phase A SHA `79d6841d708938e126cbc28c207fd1cedbef6ba5`; Phase B SHA `ac53e01dc6db456f658b5814b13e916fb3692ad3`. Phase C SHA `9aad15cf8ab96f16a6af6b9ea2bb795fa44e6ef1`.

### Phase D: Research and review rigor (P2)

**Scope:** R4–R7. **Depends on:** Phase B (template `Verify:` cost field). May proceed alongside Phase C only on disjoint files; the shared files listed in Phase C's ownership note are sequential or single-writer. **Exit:** the research standard is linked from `00-research-and-plan.md`; the plan review has the feasibility check and the checklist.

1. [✅] R4: add a research standard (claim labels; primary sources with access date and version; commit pin; re-verify claims whose files changed since the pinned commit, including staged, unstaged, and untracked working-tree content; state what was not checked; replace "no unverified claims" with "no unlabeled claims"). Extend `review-workflow-core.md` §Evidence Quality with the label set so research and review share one vocabulary. Map the Astra labels to it in one line. (P2, Effort: S)
   - Files: `00-Meta-Workflow/00-meta/review-workflow-core.md`, `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `grep -n 'unverified claims' 01-planning-and-organizing/00-research-and-plan.md` → empty; `bash scripts/validation/check-review-workflow-policy.sh` → exit 0 (cost/prereqs: none)
2. [✅] R5 + R6: add the feasibility check (each exit criterion is achievable in the expected environment; otherwise split it into a separate evaluation plan or get authorization now) and the review checklist (completeness, boundaries, failure, reversibility, pre-mortem, feasibility) to `01-plan-review.md`. (P2, Effort: S)
   - Files: `01-planning-and-organizing/01-plan-review.md`
   - Verify: `grep -nE 'Pre-mortem|Feasibility' 01-planning-and-organizing/01-plan-review.md` → at least 2 hits (cost/prereqs: none)
3. [✅] R7: replace the generic intake list (`00-research-and-plan.md:46-57`) with the ask-or-assume rule and an Assumptions list. **Coordinate with v1.82 Plan 04:** if Plan 04 has adopted the same rule for agent files, link to it instead of restating it; otherwise land it workflow-scoped and add this site to Plan 04's inventory note. (P3, Effort: S)
   - Files: `01-planning-and-organizing/00-research-and-plan.md`
   - Verify: `grep -n 'Assumptions' 01-planning-and-organizing/00-research-and-plan.md` → at least 1 hit (cost/prereqs: Plan 04 status check)
4. [✅] Logs: `changelog/changed/`. (P2, Effort: S)
    - Files: `00-project/changelog/…`
    - Verify: `bash scripts/validation/check-meta-logs.sh --staged` → exit 0 (cost/prereqs: none)

**Phase D report (2026-09-26; validation owner: parent):** D1–D4 have local acceptance evidence and are ticked above. Gate 4 passed after a focused evidence-freshness correction; `bash scripts/validation/check-meta-logs.sh --staged` returned `meta log checks OK`. No remote CI result is claimed.

- Parent-reported local passes: `bash scripts/validation/check-review-workflow-policy.sh`; `bash scripts/validation/check-plan-selftest.sh`; `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md`; `bash scripts/validation/check-planning-build-policy.sh`; `bash scripts/validation/check-planning-build-policy-selftest.sh`; `bash scripts/validation/check-completion-chain-policy.sh`; `bash scripts/validation/check-orchestrator-review.sh`; `bash scripts/validation/check-sync-workflow-scripts.sh`; `bash scripts/validation/check-update-workflows.sh`; and `bash scripts/validation/check-meta-logs-selftest.sh`.
- The research workflow uses the shared `observed`/`sourced`/`hypothesis` evidence vocabulary, maps Astra labels, records primary-source access date/version, and points to the shared freshness rule. Clean committed observations pin a SHA; dirty working-tree observations also record relevant staged/unstaged/untracked paths and fingerprints, and re-verify changes before reuse. Gate 4's focused re-review passed. Plan review adds feasibility/pre-mortem checks. Plan 04 remains Active, approval-gated, and without rollout authorization; its P0 workflow-text inventory note is not an adoption decision.
- Parent-reported `bash scripts/validation/check-active-markdown-links.sh` still reports exactly the four Plan 01 failures in `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md` at lines 7, 95, 96, and 97; no new failures. Remote CI has not run and is not claimed green.
- Phase C SHA: `9aad15cf8ab96f16a6af6b9ea2bb795fa44e6ef1`.
- **D4:** the Phase D changed entry and index row are present; parent staged only intended Phase D files and the staged meta-log check passed. Phase D's commit SHA is recorded in the following phase report.

### Phase E: Reconcile and measure (P3)

**Scope:** research §9 Phase E, plus the before/after measure. **Depends on:** Phases B–D. **Exit:** July proposal status recorded; survey re-run filed with evidence-based ratings; TODO updated, including the Flash-UI pilot deferral.

1. [✅] Review `Drag-Free-v2/2026-07-06-engineering-quality-and-lifecycle-proposal.md` against Phases B–C. Its 2026-09-26 Plan Review Addendum supersedes KI-13 partials 1–2 and KI-14's tiered plan sections; KI-12, KI-13 partials 3–4, KI-14's Observability Plan, and KI-15–KI-18 remain open or partial as documented. `plans/TODO.md` includes the proposal and the Flash-UI forward-pilot deferral; no host-project changes. (P3, Effort: S)
    - Files: the July proposal (review addendum), `00-project/plans/TODO.md`
    - Verify: the addendum names each KI disposition; the proposal and pilot-deferral TODO rows exist; no host-project path was changed (cost/prereqs: none)
2. [✅] Re-run the July survey's 8 questions (`Drag-Free-v2/workflow-engineering-quality-survey-260706-0137-gpt55.md`) against the new tree. The evidence-only result is filed at [`research/engineering-quality-survey-rerun-260926-0047-gpt6sol.md`](../research/engineering-quality-survey-rerun-260926-0047-gpt6sol.md): Q1 PARTIAL+; Q2/Q3 COVERED (documented standard); Q4–Q6 PARTIAL; Q7/Q8 PARTIAL+. No behavioral-compliance, host-pilot, or CI claim is made. (P3, Effort: S)
    - Files: `00-project/research/…`
    - Verify: the report exists with a before/after table, every change cites a file:line, and each COVERED/PARTIAL rating is supported by evidence rather than the hypothesis (cost/prereqs: none)
3. [ ] Optional hook follow-up — **deferred**; leave `scripts/hooks/pre-commit` unchanged. After Plan 01 repairs the four known broken links, a separately authorized follow-up may add the completion-chain and planning-build validators plus `check-plan.sh` for staged plans declaring a Tier. (P3, Effort: S)
    - Files: `scripts/hooks/pre-commit`
    - Verify: if authorized after the trigger, a staged fixture plan that lacks `Verify:` blocks the commit, staging this plan does not, and the link check is not added before Plan 01 repairs the baseline failures (cost/prereqs: Plan 01 link repairs and separate authorization)
4. [✅] Parent independently confirmed the plan and ran `04-documentation/03-mark-completed.md` in **Reconcile only** (`Not Eligible`) mode. Verified tasks are reconciled; the plan remains Active, with no completion marker or archive. (P3, Effort: S)
    - Files: this plan
    - Verify: parent reports the independent confirmation and Reconcile-only gate outcome; plan-level completion and archival are omitted (cost/prereqs: parent validation; passed)

**Phase E report (2026-09-26; local records pass; validation owner: parent):** E1 and E2 have local documentary evidence and are ticked above. The July proposal's Plan Review Addendum records KI-specific dispositions, and TODO includes the proposal and deferred Flash-UI pilot. The survey report exists with its evidence-based Q1–Q8 ratings. E3 remains deliberately deferred and open; E4's parent-owned Reconcile-only terminal gate has been run.

- Parent-reported local passes: `bash scripts/validation/check-plan-selftest.sh`; `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md` (T2); `bash scripts/validation/check-planning-build-policy-selftest.sh`; `bash scripts/validation/check-planning-build-policy.sh`; `bash scripts/validation/check-completion-chain-policy.sh`; `bash scripts/validation/check-review-workflow-policy.sh`; `bash scripts/validation/check-orchestrator-review.sh`; `bash scripts/validation/check-sync-workflow-scripts.sh`; `bash scripts/validation/check-update-workflows.sh`; and `bash scripts/validation/check-meta-logs-selftest.sh`.
- Parent-reported `bash scripts/validation/check-active-markdown-links.sh` remains nonzero and reports exactly the four Plan 01 failures in `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md` at lines 7, 95, 96, and 97; no additional link failures are reported. Plan 01 owns these repairs.
- Oracle Gate 5: PASS. The optional pre-commit hook expansion is accepted as deferred. Parent staged only intended Phase E records and `bash scripts/validation/check-meta-logs.sh --staged` returned `meta log checks OK`. Parent then ran the independent confirmation and terminal gate in Reconcile-only mode.
- Remote CI has not run and remains pending Plan 01 link repairs plus separate push authorization. No Flash-UI host pilot or host-project changes occurred. Reconcile-only updates task/TODO/log state only; no plan-level completion marker or archive is claimed.

## Dependencies

```
Phase 0 ──► A ──► B ──┬──► C ──┐
                      └──► D ──┴──► E
v1.82 Plan 01 (P1.2 links) ──► "CI green on v1.82" success criterion
v1.82 Plan 04 status ──► D3 (R7) wording choice
v1.82 Plan 05 ◄── recorded phase SHAs (arm boundaries)
```

- **Critical path:** 0 → A → B → C/D coordination → E.
- **Parallel:** C and D may run in parallel after B only on disjoint files; their shared documents are sequential or single-writer as specified in Phase C. Within Phase A, parallelize only tasks with disjoint `Files:` lists: A2/A4 share `validation.yml`, and A4/A5 share `01-execution.md`.
- **External:** a future push authorization for remote CI (not granted for this execution); the Plan 01 owner for links (A3); the Flash-UI owner for the deferred forward pilot.

## Deferred & Debt

- **Behavioral evidence** that agents follow the new rules (structure ≠ behavior) — the v1.82 Plan 03 harness — trigger: harness concept test passes — S2.
- **Superseded-plan lint** (a superseded plan still listed as active in TODO) — `check-plan.sh` — trigger: first observed stale-TODO case — S3.
- **Optional pre-commit validator expansion** — `scripts/hooks/pre-commit` — trigger: after Plan 01 repairs the four known active-link failures and a separate follow-up is authorized — S3.
- **`research/` filename convention mixing** (M7 bullet 5) — `00-project/research/` — trigger: next meta-hygiene plan — S3.
- **Standalone ADRs and `<metadata-root>/decisions/`** (July KI-12) — `naming-conventions.md` — trigger: first T3 plan or first one-way decision — S3.
- **Host-project verify gates** (research E6) — `00-project-setup/` — trigger: the next project setup — S3.

## Risks

| Risk | Impact (S) | Likelihood | Mitigation |
|---|---|---|---|
| Process tax on small changes | Medium (S2) | Likely without tiers | T1 = Goal, Change Surface, Tasks only; linter enforces T2+ sections only when the Tier is T2+; keep the named representative `t1-pass.md` fixture around 20 lines as an example, not a universal cap |
| Rule restated in a site this plan missed, creating a new contradiction | Medium (S2) | Possible | The Change Surface searches are part of each task's `Verify:`; the positive invariants in `check-planning-build-policy.sh` catch regressions |
| Standards file becomes an unread style guide | Low (S3) | Possible | ≤ ~90-line body; checkable questions; reviewers cite section numbers |
| Linters create false confidence | Medium (S2) | Possible | Linters guarantee reviewable inputs only; judgement stays with the R6 review; behavioral evidence is tracked in Deferred & Debt |
| Collision with the v2 redesign or July proposal | Low (S3) | Possible | Everything lives in the existing `00-meta/` mechanism; Phase E records which KIs are superseded |
| Contaminating an Astra arm | Medium (S2) | Rare | Phase 0 check; one commit per phase with SHAs recorded |
| Remote CI pending or reporting the known links misread as a validation result | Low (S3) | Likely until Plan 01 lands and a push is authorized | Local checks are the phase gates; remote CI is explicitly pending. If later run, report its result and the four-link baseline honestly; the A3 TODO row explains ownership |

## Success Criteria

- [ ] All local validators pass except the active-link checker, whose nonzero result reports only the still-unfixed subset of the four Plan 01 baseline links; the new `check-plan-selftest.sh` and `check-planning-build-policy.sh` pass locally. Staged meta-log validation passes. Remote CI on `v1.82` is pending until Plan 01 P1.2 repairs those links and a push is separately authorized; no remote CI success is claimed before then.
- [✅] The E2 loop and the M3 grep are empty; the 7 phase-order sites agree.
- [✅] This plan passes `check-plan.sh`; the retro-check lists `lib/style-loader.ts:444, 506` and `lib/skill-loader.ts` and classifies the catalog hits.
- [✅] The Flash-UI forward pilot is recorded as deferred to its owner in TODO; no host-project changes are made by this plan.
- [✅] The named representative `scripts/validation/fixtures/check-plan/t1-pass.md` fixture stays within about 20 lines; this example does not impose a maximum on every T1 plan.
- [✅] `engineering-standards.md` is linked from all 5 build and review workflows (validator-enforced).
- [✅] The survey rerun is filed with evidence-supported ratings; predicted COVERED/PARTIAL+ changes remain hypotheses unless confirmed by that evidence.

## Current state

**2026-09-26 01:29 +08 — Not Eligible; terminal gate ran in Reconcile only.**

- **P1 — Plan 01 links:** `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md:7,95,96,97` remain broken; restored TODO targets are a handoff only, and Plan 01 owns recovery/repair.
- **P1 — Remote CI:** not run; requires Plan 01 link repairs and separate push authorization.
- **P2 — Flash-UI pilot:** remains deferred to the host owner; no host-app changes were made.
- **P2/S2 — Behavioral evidence:** v1.82 Plan 03 harness; reassess when its concept test passes.
- **P3/S3 — Superseded-plan lint:** `scripts/validation/check-plan.sh`; reassess at the first observed stale-TODO case.
- **P3/S3 — Optional pre-commit validators:** `scripts/hooks/pre-commit`; consider only after Plan 01 repairs the links and a separate follow-up is authorized.
- **P3/S3 — Research filename convention:** `00-project/research/`; reassess in the next meta-hygiene plan.
- **P3/S3 — ADRs/decisions:** `<metadata-root>/decisions/` and `00-Meta-Workflow/00-meta/naming-conventions.md`; reassess at the first T3 plan or one-way decision (July KI-12).
- **P3/S3 — Host-project verify gates:** `00-project-setup/`; reassess at the next project setup.
- **July proposal:** remaining open KIs are tracked in its TODO entry; only KI-13 partials 1–2 and KI-14 tiered plan sections are superseded.

## Verification Addendum

**Confirmation timestamp:** 2026-09-26 01:29 +08. **Outcome:** Not Eligible — Reconcile only. **Validation owner:** parent orchestrator. The plan remains active; no completion marker or archive was applied.

### Commands and checks

Parent-reported PASS:

- `bash scripts/validation/check-plan-selftest.sh`
- `bash scripts/validation/check-plan.sh 00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md` (T2)
- `bash scripts/validation/check-planning-build-policy-selftest.sh`
- `bash scripts/validation/check-planning-build-policy.sh`
- `bash scripts/validation/check-completion-chain-policy.sh`
- `bash scripts/validation/check-review-workflow-policy.sh`
- `bash scripts/validation/check-orchestrator-review.sh`
- `bash scripts/validation/check-sync-workflow-scripts.sh`
- `bash scripts/validation/check-update-workflows.sh`
- `bash scripts/validation/check-meta-logs-selftest.sh`
- `bash scripts/validation/check-meta-logs.sh --staged` (includes staged C6 fixed/troubleshooting records and indexes)
- `bash scripts/validation/check-meta-logs.sh --range 0593467932cbb548855d8080ec8e63185e6a6a53..HEAD` (all local phase/setup commits)
- Shell syntax checks (PASS; exact argv not supplied).
- Oracle Gate 5: PASS.

Parent-reported NONZERO, not a pass: `bash scripts/validation/check-active-markdown-links.sh` reports exactly four pre-existing Plan 01 references in `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md:7,95,96,97`. No other link failures are reported; Plan 01 owns these repairs.

**Smoke and environment:** The parent statically smoke-checked the CLI validators listed above. No runtime or host-app smoke is applicable to this documentation/workflow-plan record reconciliation; the Flash-UI pilot remains deferred and no host project was changed. Remote CI was not run and no push is authorized.

### Corrected misreports

- **C6 log omission:** Phase C initially lacked the required fixed/troubleshooting pair for the Gate 3 workflow defect. Both entries and index rows are now staged, and parent `check-meta-logs.sh --staged` passed.
- **A3 tracker mapping:** The Phase E TODO summary dropped A3's four explicit target mappings; the parent restored the nested handoff in `00-project/plans/TODO.md:20`. The source links themselves remain broken and Plan 01-owned.

### Task-to-verifier coverage matrix (32 tasks)

**Citation key:** `plan:N` refers to `00-project/plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md:N`; Phase report references are within that file.

| Task | Verifier / evidence | Result |
|---|---|---|
| 0.1 | Parent records audit — Phase 0 baseline, plan:168-178 | ✅ |
| 0.2 | Parent + user confirmation — no live Astra arm and pre-change SHA, plan:171-178 | ✅ |
| 0.3 | Parent records audit — local commit authorization and no-push boundary, plan:174-178 | ✅ |
| A1 | Parent — M1 wording and completion-chain invariant, plan:186-188, Phase A report:208 | ✅ |
| A2 | Parent — local v1.8* push/PR trigger inspection; remote run explicitly deferred, plan:189-191, report:208 | ✅ |
| A3 | Parent — restored exact four-target Plan 01 TODO handoff, `00-project/plans/TODO.md:20`; source repair remains flagged to Plan 01, plan:192-194 | ✅ |
| A4 | Parent — agent-sizing edits and negative fixture/policy guard, plan:195-197, Phase A report:208 | ✅ |
| A5 | Parent — metadata-root path migration and completion-chain guard, plan:198-200, Phase A report:208 | ✅ |
| A6 | Parent — M7 terminology/rubric/review-archive updates, plan:201-203, Phase A report:208 | ✅ |
| A7 | Parent — Phase A fixed/troubleshooting and changed records/indexes, plan:204-210 | ✅ |
| B1 | Parent — shared tiered template and contract dogfood, plan:216-218, Phase B report:241-245 | ✅ |
| B2 | Parent — seven phase-order sites and policy guard, plan:219-221, Phase B report:243,245 | ✅ |
| B3 | Parent — Change Surface wiring across research/review/confirmation, plan:222-224, Phase B report:245 | ✅ |
| B4 | Parent — Decision options, reversibility and task evidence structure, plan:225-227, Phase B report:243 | ✅ |
| B5 | Parent — linter/self-test fixtures, CI step and T2 dogfood, plan:228-230, Phase B report:243 | ✅ |
| B6 | Parent — superseded-plan and Current state block rules, plan:231-233, Phase B report:243 | ✅ |
| B7 | Parent — skill references and planning/build guard, plan:234-236, Phase B report:243 | ✅ |
| B8 | Parent — changed/added Phase B entries, indexes and staged meta-log check, plan:237-245 | ✅ |
| C1 | Parent — standards body and appendix, plan:256-258, Phase C report:277 | ✅ |
| C2 | Parent — forward build wiring and confirmation checks, plan:259-261, Phase C report:278 | ✅ |
| C3 | Parent — backward review wiring and policy checks, plan:262-264, Phase C report:278 | ✅ |
| C4 | Parent — debt transfer plus verified-task reconciliation; corrected trigger semantics, plan:265-267, Phase C report:278 | ✅ |
| C5 | Parent — automated-first regression guidance, plan:268-270, Phase C report:278 | ✅ |
| C6 | Parent — fixed/troubleshooting pair plus indexes staged; `check-meta-logs.sh --staged` PASS, plan:271-280 | ✅ |
| D1 | Parent — evidence standard and shared vocabulary, plan:286-288, Phase D report:299-303 | ✅ |
| D2 | Parent — feasibility and review checklist, plan:289-291, Phase D report:299-302 | ✅ |
| D3 | Parent — ask-or-assume rule coordinated with Plan 04, plan:292-294, Phase D report:302 | ✅ |
| D4 | Parent — changed record/index and staged meta-log check, plan:295-305 | ✅ |
| E1 | Parent — July proposal review addendum and TODO entry, plan:311-313; proposal Plan Review Addendum | ✅ |
| E2 | Parent — evidence-only survey report and ratings, plan:314-316; survey:17-32 | ✅ |
| E3 | Explicitly deferred; no pre-commit hook edit, plan:317-319 and Deferred & Debt:349 | OPEN `[ ]` |
| E4 | Parent — independent confirmation and `03-mark-completed.md` Reconcile-only result, plan:320-329 and this addendum | ✅ |

### Reconciled TODO and flagged issues

- Open Deferred & Debt items are preserved in the active plan and transferred to existing TODO entries without claiming closure: behavioral evidence in the Plan 03 harness (trigger: concept test passes; S2); superseded-plan lint in `check-plan.sh` (trigger: first stale-TODO case; S3); optional hook in `scripts/hooks/pre-commit` (trigger: Plan 01 link repairs plus separate authorization; S3); research filename convention in `00-project/research/` (trigger: next meta-hygiene plan; S3); standalone ADRs in `<metadata-root>/decisions/`/`naming-conventions.md` (trigger: first T3 plan or one-way decision; S3); host verify gates in `00-project-setup/` (trigger: next project setup; S3). Existing proposal, Plan 03, and quality-plan TODO rows were updated rather than duplicated.
- **P1 / S2 — Link integrity:** four Plan 01 links remain broken; restore/repair and rerun the link check under Plan 01.
- **P1 / S3 — Remote CI:** not run; requires link repairs and separately authorized push.
- **P2 / S2 — Host pilot:** Flash-UI template pilot remains deferred to its owner; select and authorize a non-trivial host plan before testing.
- **P3 / S3 — Optional hook and remaining deferred work:** hook stays open; other transferred debt stays open until its recorded trigger prompts reassessment and its own acceptance evidence supports closure.
