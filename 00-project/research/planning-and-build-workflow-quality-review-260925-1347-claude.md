# Planning and Code-Build Workflow Quality Review

**Date:** 260925 1347 (24-hour format)  
**Model:** claude-opus-5-5 (Claude Code)  
**Scope:** `01-planning-and-organizing/` (all 5 files), `02-code-build/` (all 5 files), the shared contracts they depend on (`00-Meta-Workflow/00-meta/workflow-applicability.md`, `agent-spawning-policy.md`, `severity-priority-rubric.md`, `review-workflow-core.md`, `naming-conventions.md`), `05-review/01-code-review.md` and `03-code-refactoring.md`, `03-debugging/02-bug-fix-workflow.md`, `scripts/validation/`, `.github/workflows/validation.yml`, the two related skills in `11-Skills/`, and the prior proposal set in `00-project/plans/Drag-Free-v2/`. One real plan produced with these workflows (Flash-UI `project/plans/2026-09-23-prompt-quality-p0-p1-implementation.md`) and its source research (`project/research/prompt-system-audit.md`) serve as a case study.  
**Branch / HEAD:** Workflow-Scripts `v1.82` (clean apart from pre-existing uncommitted 2026-09-23 research files).  
**Status:** Complete. Recommendations only; no workflow files were changed.  
**Commit pin (added 2026-09-25):** `1ab9fcb`. This is inferred: the report's 13:47 timestamp is after that commit (13:39), and `HEAD` did not move before re-verification.

> **Current state (2026-09-25).** Extracted into the implementation plan [`2026-09-25-planning-and-build-workflow-quality-implementation-plan.md`](../plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md). Each finding below carries a `Plan:` line that names the task implementing it; **Not extracted** marks items deliberately left out. The plan's re-verification found 5 errors or gaps in this report. They are corrected in place and each correction is marked **Corrected 2026-09-25**: M2 link fix (§4), R1 site list (§5), R4 vocabulary (§5), Q6 wiring (§6), and the E1 sketch (§7). §9 Roadmap is superseded by the plan's Tasks section, which adds a Phase 0 baseline.

**Evidence labels used below:** **Observed** = read or run in this session, with a file:line or command. **Case study** = observed in the Flash-UI plan and code. **Hypothesis** = a proposed benefit, not measured. Line numbers refer to the files as they were on 2026-09-25.

---

## 1. Executive summary

**Verdict.** The planning → build → confirm → gate chain is now **strong at proving what was done**. The Verification Bar, the "skipped is not success" rule, the two-way tick correction and the single terminal gate are better than most agent workflow systems. The chain is **weak at deciding what should be built and how it should be shaped**. Planning is organized around *priority buckets* rather than *design*. The plan template drops the alternatives analysis the workflow asks for. No step makes the planner find every place a behavior lives before writing tasks. Build has no code-design, reuse or error-handling standard to build *to*: those criteria exist only in the review workflows, after the code is written.

**The case study shows the cost concretely.** The Flash-UI prompt-quality research correctly diagnosed duplicated rules as a root cause and recommended "a single canonical Quality Baseline… stop duplicating" (`prompt-system-audit.md:215`). It scored that consolidation **P2** (`:448`). The planning rules then forced Phase N to equal priority P(N-1) and deferred "larger redesigns" to P3. The plan was scoped as P0/P1 only and its safeguard literally said "if a task appears to require P2 architecture changes, stop" (`plan:96`). So the P0 fix removed the "3-layer shadow / spring" mandate from the two prompt files it listed (`plan:39`) and missed the two remaining copies in `lib/style-loader.ts:444` and `:506` (**verified in this session**). The same shape recurs in three other residual defects in that plan. **The workflow did exactly what it said, and what it said produced an incomplete fix.**

**Separately, the mechanics have three live defects** (Section 4): `04-review-finalise-commit-execute.md` still has the Not-Eligible wording that the 2026-09-25 fix removed everywhere else; CI does not run on the active `v1.8x` line, so `v1.82` currently has 4 broken links that CI would flag; and agent-sizing rules were updated in `00-research-and-plan.md` §1.2 but not in the rest of the planning chain.

**On the engineering-quality question:** the July `Drag-Free-v2` engineering-quality proposal (KI-12–KI-18) diagnosed most of this correctly. It has sat **unreviewed for 81 days** because it is built on a v2 platform (`core/` partials, `wf` CLI, frontmatter) that does not exist. Its line citations are now stale. This report recommends **decoupling its substance from that platform**: the repository already has the shared-contract mechanism it needs (`00-meta/*.md`).

### Top recommendations (ordered by priority)

| # | Recommendation | Priority | Effort |
|---|---|---|---|
| 1 | Fix the three mechanics defects; add a positive invariant to the completion-chain validator; run CI on the active line (§4, §7) | P1 | S |
| 2 | Add **Change Surface**, **Decision (≥2 options)** and a per-task **Verify:** line to the plan template; separate phase order (dependency/risk) from priority (§5) | P1 | S–M |
| 3 | Add an **enabling-refactor rule**: when a fix must be repeated at two or more sites, consolidation is part of the fix, not a P3 refactor (§5 R1) | P1 | S |
| 4 | Ship `scripts/validation/check-plan.sh`, a plan linter host projects can run, and make "plan passes check-plan" a finalise acceptance criterion (§7 E1, tested sketch included) | P1 | S |
| 5 | Land one shared `00-meta/engineering-standards.md` (design, reuse, errors/recovery), referenced *forward* by planning/execution and *backward* by review (§6) | P2 | M |
| 6 | Add tiered **Failure Modes & Recovery** and **Rollout & Rollback** plan sections, plus per-phase checkpoints in execution (§6 Q4–Q5) | P2 | S |
| 7 | Codify research-quality rules: claim labels, primary sources, access dates, version pins, re-verification of stale evidence (§5 R4) | P2 | S |
| 8 | Check verification **feasibility** at plan time: cost, credentials, authorization (§5 R5) | P2 | S |
| 9 | Review `Drag-Free-v2` engineering-quality proposal; mark the parts this report lands as superseded; keep ADR ledger / debt ledger / greenfield lane as later work (§6, §9) | P3 | S |

---

## 2. What already works (keep it)

- **Verification Bar** (`02-code-build/01-execution.md:26-37`): the build-green-is-not-done rule, required tests and smoke, "skipped or blocked checks are not success", and named evidence. The case-study plan shows it working: honest `Not Eligible`, per-task evidence tables with file:line, exact commands and pass counts (`plan:123`).
- **Two-way tick correction and a single terminal owner** (`02-confirm-execution.md:28`, `03-execute-and-confirm.md:18-27`), guarded by `check-completion-chain-policy.sh`.
- **Composition over duplication in the combined workflows.** `03-plan-review-and-finalise.md` is 27 lines and explicitly says "Do not duplicate review or finalisation rules in this file" (`:26`). This is the right pattern and should become the norm (Section 6 applies the same idea to engineering standards).
- **Over-engineering guardrails** in `01-plan-review.md:96-99` and `02-finalise-plan.md:101-104`. These are valuable; Section 5 R1 narrows them rather than removing them.
- **Shared contracts** (`review-workflow-core.md`, `workflow-applicability.md`, the rubric) are referenced rather than restated by review workflows. They are the mechanism Section 6 reuses.
- **Planning commit checkpoint** in `04-review-finalise-commit-execute.md:26-31, 52`: a clean revert boundary between plan and code.

---

## 3. Method

1. Pulled Workflow-Scripts (`Already up to date`) and read every file in both directories in full, plus the shared contracts and review/debugging workflows they reference.
2. Read the prior `Drag-Free-v2` engineering-quality proposal and survey, and checked their current state (`git log`: last touched 2026-07-20; `plans/TODO.md` lists only the companion v2 redesign for review, not this proposal).
3. Searched the tree for ADR, debt-ledger or decision-record mechanisms outside `Drag-Free-v2`: **none found**.
4. Ran every `scripts/validation/check-*.sh`. Two exited non-zero: `check-active-markdown-links.sh` (a **real failure**: 4 broken links) and `check-meta-logs.sh` (a **usage error only**: it needs `--staged` or `--range`).
5. Read `.github/workflows/validation.yml` and compared its branch triggers with the active line.
6. Case study: read the Flash-UI plan end to end and the outline and relevant sections of its 917-line source audit. Then **verified the plan's key residual claim against code** (`grep` of `lib/style-loader.ts`, prompt files and `lib/skill-loader.ts`).
7. Wrote the two validator sketches in Section 7 and **ran them** against the live tree and fixtures.

**Limits.** Grep-based validators check wording, not agent behavior. Whether an agent *follows* a rule can only be measured behaviorally (the parallel-agent harness concept test in `plans/v1.82-fixes/03-…`). All proposed quality benefits in this report are hypotheses until piloted. I relied on one case study, so it shows a mechanism, not a frequency.

---

## 4. Findings: workflow mechanics defects

These findings are defects under this repository's own definition ("a contradiction, a broken handoff, a rule agents follow wrongly… a wrong or broken reference", root `AGENTS.md`), so fixing each one requires a troubleshooting entry.

### M1 — `04-review-finalise-commit-execute.md` still skips the gate for Not Eligible plans · S2 / P1

> **Plan:** Phase A task 1 (fix plus E2 invariant).

- **Observed:** `02-code-build/04-review-finalise-commit-execute.md:35` says "`Not Eligible` → plan stays active with addendum, no completion marker, no archive", and the checklist at `:48` says the same. It never says the gate runs in **Reconcile only** mode. `03-execute-and-confirm.md:24-27, 40-42` (which 04 delegates to) says the gate runs for **both** outcomes. This is the exact deadlock fixed in commit `d4407bd` (2026-09-25, "tick verified plan tasks for every completion-chain outcome"). The fix did not reach 04.
- **Impact:** An agent running the full pipeline via 04 can read 04's summary as permission to stop, which leaves verified tasks unticked: the same symptom as troubleshooting entry `2026-09-25-workflow-verified-tasks-never-ticked.md`.
- **Why the validator missed it:** `check-completion-chain-policy.sh` blacklists the *old sentences* (`'a \`Not Eligible\` plan must not|reaches this gate only on a \`Verified Complete\`'`). 04 uses different words for the same rule.
- **Fix:** Replace 04 `:35` and `:48` with the 03 wording (gate always runs; Reconcile only for `Not Eligible`). Add the positive invariant in §7 E2.
- **Verification:** The E2 snippet, run in this session, currently prints `WOULD FAIL: 04-review-finalise-commit-execute.md` and nothing else. After the fix it should print nothing.

### M2 — CI never runs on the active line; `v1.82` has 4 broken links · S2 / P1

> **Plan:** Phase A task 2 (CI trigger); task 3 hands the links to v1.82 Plan 01.

- **Observed:** `.github/workflows/validation.yml` triggers on `push`/`pull_request` to `main` and `v1.8` only. The active line is `v1.81`/`v1.82` (`00-project/AGENTS.md` "Tracked Repositories"; current branch `v1.82`). `bash scripts/validation/check-active-markdown-links.sh` fails on `v1.82`:
  ```
  00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md:7  -> ../research/2026-09-10-astra-instruction-evaluation-protocol.md
  …:95 -> ../research/2026-09-10-astra-instruction-evaluation-protocol.md
  …:96 -> ../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md
  …:97 -> ../../00-Meta-Workflow/00-meta/workflow-applicability.md
  ```
  The file was moved one directory deeper into `v1.82-fixes/` without its relative links being updated.
- **Impact:** Every validator, including the meta-log and completion-chain guards, is silent on the branch where work actually happens. The local pre-commit hook runs only `check-meta-logs.sh --staged`.
- **Fix:** Trigger on `'v1.8*'` (or on every branch) and fix the 4 links. Optionally have the pre-commit hook run the fast validators (links and completion chain) too.
- **Corrected 2026-09-25 (plan re-verification):** "Add one `../` to each" is right for only 2 of the 4 links. `:96` becomes `../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md` and `:97` becomes `../../../00-Meta-Workflow/00-meta/workflow-applicability.md`, both targets exist. `:7` and `:95` point at `2026-09-10-astra-instruction-evaluation-protocol.md`, which is absent from the worktree at any depth. They can only be fixed after v1.82 Plan 01 recovers the protocol from history, and that file sits in Plan 01's lane anyway. The CI trigger change will therefore show red on `v1.82` until Plan 01 P1.2 lands.
- **Original wording:** ~~and fix the 4 links (add one `../` to each).~~
- **Verification:** `bash scripts/validation/check-active-markdown-links.sh` exits 0, and a push to `v1.82` shows a Validation run.

### M3 — Agent-sizing policy applied to one file, not the chain · S3 / P2

> **Plan:** Phase A task 4 (plus E4, in the new `check-planning-build-policy.sh`).

- **Observed:** The September remediation replaced the fixed roster in `00-research-and-plan.md` §1.2 with Localized/Bounded/Broad sizing (`:61-67`). Still unsized:
  - `00-research-and-plan.md:71-76`: four "librarian agents" always, and `:329`: "Use parallel agents aggressively during research phases". This directly contradicts `:67` ("Do not treat a large default roster as required") and `workflow-applicability.md:23`.
  - `01-plan-review.md:17-46`: two consecutive rounds of 4 roles plus "spawn additional" (8+ roles), against the 6-per-session cap (`agent-spawning-policy.md:13`).
  - `02-finalise-plan.md:23-57`: three rounds of 3–4 roles plus extras (up to 12+).
  - `01-execution.md:66-76`: "Use parallel agents" in the *Implement* step, including "Concurrently review for risks… breaking changes" of a change that does not exist yet.
- **Impact:** Contradictory instructions. The Astra research (`research/2026-09-23-astra-instruction-performance-recommendations.md`) already identifies accessible contradictions as a model-performance risk. For a localized plan the rosters are pure cost.
- **Fix:** Replace each roster with a one-line reference to `workflow-applicability.md` sizing plus a *menu* of candidate roles, as §1.2 already does. Delete "aggressively". In `01-execution.md`, make review a post-change step.
- **Verification:** `grep -nE 'aggressively|librarian agents' 01-planning-and-organizing/*.md` returns nothing. §7 E4 automates the check.

### M4 — Path drift from `naming-conventions.md` · S3 / P2

> **Plan:** Phase A task 5.

- **Observed:** `01-execution.md:13, 20, 45, 112` use bare `plans/` rather than `<metadata-root>/plans/`. `03-execute-and-confirm.md:11, 48` say plans are "typically in `project/build/`". `naming-conventions.md:63-64` makes `<metadata-root>/plans/` the default and `build/` opt-in only.
- **Fix:** Use `<metadata-root>/plans/` and link Metadata Root Resolution, as `00-research-and-plan.md:31` already does.

### M5 — Plan supersession is undefined · S3 / P2

> **Plan:** Phase B task 6 (supersession step). The TODO lint is **not extracted** yet (plan Deferred & Debt).

- **Observed:** `02-finalise-plan.md:65` writes a **new** dated plan; `:70-76` covers the fate of `PLAN.reviews/` but not of the **original plan**. After `03-plan-review-and-finalise.md`, both the draft (with its review addendum) and the finalised plan sit in `plans/` as active.
- **Fix:** Add a step: mark the source `**Status:** Superseded by <link>` (or move it into `plans-completed/review/`), and have `check-plan.sh` or the link validator reject a superseded plan that is still listed as active in `TODO.md`.

### M6 — Addendum accretion makes current truth hard to read · S3 / P2

> **Plan:** Phase B task 6.

- **Observed:** Both `01-plan-review.md` (append the review) and `02-confirm-execution.md` (append verification) append to the source document. Case study: `prompt-system-audit.md` is 917 lines with §10 (execution addendum), §11 (re-verification), §12 (redesign) and a review addendum. The plan cites "§12.6-C" and "§12.11". A reader has to reconstruct which recommendation is still current.
- **Fix:** Keep appending (it is a good audit trail), but require a short **"Current state" block at the top** that each appending workflow updates: one line per open recommendation with its status and the section that last changed it.

### M7 — Minor consistency items · S3 / P3

> **Plan:** Phase A task 6 (bullets 1–4, 6). Bullet 5 (`research/` naming) is **not extracted** (plan Deferred & Debt).

- `02-finalise-plan.md:1` is titled "Workflow: Implementation Plan"; the file and README call it "Finalise Plan".
- `03-execute-and-confirm.md:15` lists "completion marker" as an output of 01, but the marker is gate-owned.
- `00-research-and-plan.md:268`: `DRAFT - Ready for Review ✅` reuses the glyph that the marking convention reserves for verified tasks.
- `00-research-and-plan.md:166-171` scores risk on High/Medium/Low while the rubric uses impact × Rare/Possible/Likely. Two scales for the same concept.
- `00-project/research/` mixes `YYYY-MM-DD-name.md` (the two newest reports) with the normative `{type}-YYMMDD-HHMM-{model}.md` (`naming-conventions.md:12`). Pick one; this report follows the normative rule.
- `02-finalise-plan.md:73-74` allows *deleting* `PLAN.reviews/`. Given the evidence-retention culture elsewhere, default to archiving instead.

---

## 5. Findings: quality of research, solution design and planning

### Case study: how a correct diagnosis became an incomplete fix

| Step | What happened | Workflow rule responsible |
|---|---|---|
| Research | Duplicated quality rules identified as a root cause; "create a single canonical Quality Baseline… stop duplicating" (`prompt-system-audit.md:213-215`) | — (research was right) |
| Scoring | Consolidation scored **P2 / 2h** (`:448`), because duplication was framed as token cost, not as a correctness hazard for future edits | Rubric scores *impact of the issue*, never *the cost the issue imposes on the next change* |
| Planning | Plan scoped "P0/P1"; "YAML source-of-truth refactor" explicitly out of scope (`plan:21`); "if a task appears to require P2 architecture changes, stop" (`plan:96`) | `00-research-and-plan.md:123-127` "Phase 1 = P0 … Phase 4 = P3"; `01-plan-review.md:99` "Push speculative refactors… to P3"; `02-finalise-plan.md:103` "Larger redesigns are explicitly deferred to P3" |
| Tasks | Task 1.7 names the sites to edit ("shared baseline and variation instructions", `plan:39`). The fallback builder in `style-loader.ts` is not listed | No step requires an inventory of *every* site implementing a behavior before tasks are written |
| Build | Two named sites fixed; `lib/style-loader.ts:444` and `:506` still emit "layered box-shadows (3+ layers)… spring-physics" (**verified this session**) | Execution has "check for unintended impacts" (`01-execution.md:69`) but nothing checks *completeness*: "did I change every copy?" |
| Confirm | Correctly caught and flagged (`plan:152`) | The Verification Bar worked, but downstream of the design error |

The same pattern appears in three more residuals of that plan: skill removal done on one path while `lib/skill-loader.ts` still wires them in on others (`plan:153`); stored `designConcept` not forwarded on the variation path (`plan:154`); and a variation change that had to be applied separately to *three* generation paths (`plan:59`). Each is a **duplicated-path** defect that a planning-time inventory would have exposed, and that consolidation would have prevented.

### R1 — Phase order is conflated with priority · S2 / P1

> **Plan:** Phase B task 2.

- **Observed:** `00-research-and-plan.md:123-127` and `02-finalise-plan.md:15`: "phase numbering must follow priority order (Phase 1 = P0 work)".
- **Corrected 2026-09-25 (plan re-verification):** The rule is stated at **7** sites, not the 3 named here and in the case-study table. The other four are `02-finalise-plan.md:103`, the rubric's **Ordering Rule** (`severity-priority-rubric.md`, "reports and plans": P0→P3), `01-planning-and-organizing/README.md:77-102`, and root `README.md:828` ("Push speculative refactors to P3"). Changing only the named files would leave a contradiction of the M3 kind. The rubric fix keeps P0→P3 order for findings in reports and orders plan phases by dependency. Search: `grep -rnE 'Phase 1 = P0|phase numbering must follow priority|Larger redesigns are explicitly deferred|speculative refactors|priority ordering' --exclude-dir=00-project --exclude-dir=.git .`
- **Problem:** Priority measures *how bad it is if this is not done*. Phase order should follow **dependency and risk**. An enabling step (a seam, a consolidation, a characterization test) is often low-priority on its own merits but a precondition for doing the P0 work correctly. The present rule forces it after the P0 work or out of scope.
- **Fix:** (a) Phases are ordered by dependency, then risk-first (the riskiest assumption proven earliest); each task carries its own P label. (b) **Enabling-refactor rule**, added to `01-plan-review.md` and `02-finalise-plan.md` next to the over-engineering checks: *"If a P0/P1 change must be applied at two or more sites that implement the same behavior, consolidating those sites is part of the P0/P1 task, sized and verified with it, not a deferred refactor. The over-engineering check applies to consolidation beyond those sites."* This keeps the MVP guardrail and removes the trap.
- **Note:** The skill `11-Skills/workflow-plan-review-finalize/SKILL.md` already says "Prioritize phases by severity **and dependency order**". The skill has drifted *ahead* of the workflow here; adopt its wording.

### R2 — No change-surface inventory before tasks are written · S2 / P1

> **Plan:** Phase B task 3; the plan's Change Surface section applies it to this change.

- **Observed:** `00-research-and-plan.md` §1.4 asks for "Areas that would be affected" (`:92`) but in prose, not as a verifiable list. `01-execution.md:62` asks for "Expected touch points" at build time, after the plan is fixed.
- **Fix:** Add a required **Change Surface** plan section. For each behavior being changed, list every site that implements, duplicates, or falls back to it, **together with the search command used to find them** (for example ``rg -n "3\+ layers|spring-physics" lib prompts``). `01-plan-review.md` checks this section by re-running the searches. `02-confirm-execution.md` re-runs them after build and expects zero stale hits. This is the single highest-leverage addition for fault prevention: it turns "did we change every copy?" from memory into a command.

### R3 — Alternatives are analyzed, then dropped · S2 / P2

> **Plan:** Phase B task 4; the plan's Decisions D1–D4 apply it.

- **Observed:** §2.1 asks for a Decision Record with "What alternatives did you consider and reject?" (`00-research-and-plan.md:113-117`), but the plan template (`:216-261`) has only "Recommended Approach". The alternatives never reach the artifact that reviewers and implementers read. §1.3 frames alternatives as *external libraries/patterns*, not *internal design options*.
- **Fix:** Add a **Decision** section to the template with at least two options, one of which is always the **minimal** option (patch in place), plus the chosen option, the reason, the rejected options with reasons, and **reversibility** (cheap / expensive / one-way). One-way decisions get a review flag. This is the lightweight in-plan version of the ADR idea (§6 Q1).

### R4 — Research has no source-quality or claim-labeling standard · S2 / P2

> **Plan:** Phase D task 1.

- **Observed:** `00-research-and-plan.md:294-297` requires "no unverified claims". That is binary, unenforceable, and invites overclaiming. There are no rules on source type, access date, version, or staleness. Yet the best research in this repository already does all of these ad hoc. The 2026-09-23 Astra report labels every claim ("local observation", "fact", "hypothesis"), cites the vendor's own documentation with section names and access dates, pins the HEAD it inspected, and explicitly says what it did *not* measure. The Flash-UI audit needed a whole re-verification section (§11) because earlier claims had gone stale against 2026-09 code.
- **Fix:** Add a short **Research standard** to `00-research-and-plan.md` Phase 3 (or a shared `00-meta/research-standard.md` for the `research` skill and review reports to reuse):
  1. Label every claim: *observed* (file:line or command), *sourced* (primary source + access date + version), or *hypothesis* (plus the evidence that would confirm it).
  2. Prefer primary sources (official documentation, changelogs, source code) over blogs and model memory. For libraries, record the **version** researched and check it against the lockfile.
  3. Record the HEAD commit the research was done against. Before planning from research, re-verify any claim whose files changed since that commit (`git diff --stat <sha>..HEAD -- <paths>`).
  4. State what was *not* checked.
  5. Replace "no unverified claims" with "no *unlabeled* claims".
- **Corrected 2026-09-25 (plan re-verification):** Do not create a third, independent label set. `review-workflow-core.md:38-42` already requires hypotheses to be labeled, and the Astra plan uses five labels (`plans/v1.82-fixes/05-run-astra-instruction-evaluation.md` §Operating boundaries). Extend the review-core Evidence Quality section with these labels and map the Astra labels onto them.

### R5 — Verification feasibility is not assessed at plan time · S2 / P2

> **Plan:** Phase D task 2; the template's `Verify:` cost/prereqs field is in Phase B task 1.

- **Case study:** The plan made a paid, multi-model, blind-judged evaluation a **P0 exit criterion** (`plan:35-37, 43`). Credentials and credit were not confirmed at plan time. Two providers failed (credit exhausted, timeout; `plan:106`), and the user then declined further paid calls (`plan:104`). The plan is now **permanently Not Eligible** even though most code tasks are verified. The workflow was honest about the result; the design error was upstream.
- **Fix:** Every exit criterion in the template names its **cost, prerequisites (credentials, hardware, display, network) and who authorizes it**. `01-plan-review.md` gains a check: "Is every exit criterion achievable in the expected environment? If a criterion depends on paid or unavailable resources, split it into a separate evaluation plan that does not gate code completion, or get authorization now."

### R6 — Plan review has no criteria for "design flaw" · S2 / P2

> **Plan:** Phase D task 2.

- **Observed:** `01-plan-review.md:31, 41` asks reviewers to "Identify design flaws and architectural concerns" without defining one. Reviewers bring their own unstated criteria, so review quality varies by model.
- **Fix:** Give the review a short checklist of checkable questions, and point it at `engineering-standards.md` once that exists (§6):
  - *Completeness:* Does the Change Surface list every site? Re-run its searches.
  - *Boundaries:* What can change inside each new or changed module without touching its callers?
  - *Failure:* For each new boundary, what fails, how is it detected, and what does the user see?
  - *Reversibility:* Which decisions are one-way, and did they get an explicit rationale?
  - *Pre-mortem:* "It is two weeks after merge and this plan failed. What is the most likely reason?" Record the top answer and its mitigation.
  - *Feasibility:* R5.

### R7 — Intake guidance is generic · S3 / P3

> **Plan:** Phase D task 3, coordinated with v1.82 Plan 04 (same raw rule).

- **Observed:** `00-research-and-plan.md:46-57` asks for stakeholders, timeline and budget, which are rarely known to an agent and rarely decision-relevant. It gives no rule for *when* to ask a clarifying question versus proceeding on a stated assumption. The Astra report independently flags over-asking and under-asking as a model risk.
- **Fix:** Replace the list with: "Ask only when the answer changes the design or scope and cannot be derived from code, docs or sensible defaults. Otherwise proceed and record the assumption in the plan's Assumptions list, where the review can challenge it."

### R8 — The template contradicts its own task rules · S2 / P1

> **Plan:** Phase B task 4.

- **Observed:** §2.3 requires each task to have "Acceptance criteria… Dependencies" (`:138-143`). The template's task line carries only `(Effort: Small)` (`:235-238`). Execution then invents verification per task (`01-execution.md:63`), and confirm has to reconstruct it.
- **Fix:** Every top-level task carries a `Verify:` line (a command, test or smoke step with an expected result) and a `Files:` line. This is the input `01-execution.md`'s tick rule needs, and it is mechanically checkable (§7 E1).

---

## 6. Engineering quality: architecture, reuse, abstraction, fault prevention and recovery

### Status of the July proposal, and a way to unblock it

`00-project/plans/Drag-Free-v2/2026-07-06-engineering-quality-and-lifecycle-proposal.md` (KI-12–KI-18) is the right diagnosis. Re-checked on the 2026-09-25 tree:

| Gap (July ID) | Still true? | Evidence now |
|---|---|---|
| W13 Architecture analyzed, never designed | **Yes** | No design step or ADR anywhere (`grep -rE 'decisions/|\bADR\b'` finds only the Drag-Free-v2 files). The July citation `00-research-and-plan.md:63` ("Architecture agent") is **stale**: that line is now sizing text |
| W14 No code-design standard at build time | **Yes** | `01-execution.md:70` "Validate code quality and adherence to project conventions" still has no referent; criteria live only in `05-review/03-code-refactoring.md:77-89` |
| W15 Error handling is a review concern only | **Yes** | No build-time error or recovery contract; `03-debugging/02-bug-fix-workflow.md:67` has "Rollback plan", but only for bug fixes |
| W19 No debt ledger | **Yes** | Debt appears only as review output (`03-code-refactoring.md:56`) |

**Why it stalled:** it assumes `core/standards/` partials (KI-2), frontmatter (KI-1), a `wf` CLI and a role registry (KI-11) from the companion v2 redesign. None of these exist, and the companion is itself unreviewed (`plans/TODO.md:20`).

**Unblocking move:** The repository **already has** the partial mechanism: `00-meta/review-workflow-core.md` and `00-meta/workflow-applicability.md` are exactly "write once, reference from many workflows" contracts, validated by `check-review-workflow-policy.sh`. Land the substance of KI-13/KI-14 now as **one** file, `00-meta/engineering-standards.md`, and wire it into the chain. The v2 platform can later *move* the file; it does not need to *invent* it. Keep July's tiering principle, which is load-bearing against process tax.

### The tier rule

> **Plan:** Phase B task 1 (moved into the new `00-meta/plan-template.md`, plan Decision D1).

Declare a tier in every plan header (`**Tier:** T1|T2|T3`):

- **T1 (fix / small, localized):** Goal, Change Surface, Tasks with `Verify:`. Nothing else is required; the standards apply implicitly.
- **T2 (feature, or any new or changed boundary):** add Decision, Design & Interfaces, Failure Modes & Recovery, Test Strategy, Rollout & Rollback.
- **T3 (system, cross-cutting, greenfield):** T2 plus a design review before implementation planning (reuse `01-plan-review.md` on the Design section).

Default tier is inferred from the request ("fix this bug" → T1, "add X" → T2, "new project / re-architect" → T3). The review may raise it. **Hypothesis:** this keeps small work cheap while forcing design thinking exactly where boundaries move.

### Proposed `00-meta/engineering-standards.md` (outline, ≤ ~80 lines)

> **Plan:** Phase C task 1 (plan Decision D4: one file rather than July's four partials).

Phrase each rule as a **checkable question**, so both builder and reviewer can apply it and cite the section in findings.

**§1 Boundaries and abstraction**
- Each module or component has a one-sentence responsibility. *Can you state it without "and"?*
- **Information hiding:** *What can change inside this module without touching any caller?* If the answer is "nothing", the boundary is in the wrong place.
- **Dependency direction:** domain and decision logic does not import I/O, UI or provider SDKs. Adapters depend on the core, not the reverse.
- **Invariants live in one place:** a constructor, factory, parser or type enforces them. Callers never re-check. *Parse, don't validate* at trust boundaries.
- **Make illegal states unrepresentable** where the language allows (discriminated unions, enums, branded or opaque types).
- **Paradigm note:** "object-oriented" here means *encapsulated invariants behind narrow interfaces*, not "use classes". In function- and hook-based codebases such as Flash-UI (React 19 + hooks), the same principles are met with modules, closures, typed interfaces and a *functional core / imperative shell*. Prefer composition over inheritance; use inheritance only for a true is-a relationship that respects substitutability (LSP). Do not introduce class hierarchies to satisfy this standard.

**§2 Reuse and a single source of truth**
- **Search before you write:** before adding a helper, type, prompt fragment, constant or validation, search for an existing one and record the search in the phase report.
- **Rule of two:** the second copy of a *behavior* (not incidental similarity) triggers extraction, or a recorded reason not to extract. This is the executable form of R1's enabling-refactor rule.
- **One authority per fact:** configuration, defaults, limits (for example the 100,000-character variation bound in the case study) and policy tables (for example temperature policy) are defined once and imported. Two literals with the same meaning are a defect.
- **Parallel paths share a core:** when N code paths (web / streamed / desktop) do the same job, they call one shared function and differ only in transport. A change applied N times is a design smell to raise in the plan.

**§3 Errors, fallbacks and fault prevention**
- Decide an **error taxonomy per boundary at design time**: expected-and-recoverable (retry or degrade), expected-and-unrecoverable (surface to the user), or a bug (fail fast).
- **No silent failure:** every catch handles meaningfully, adds context and rethrows, or logs at error level with context. Empty catches and `catch { return default }` need a written justification.
- **Fallbacks are designed, not improvised:** a fallback that masks a primary-path failure *is* a silent failure; fallback activation is always logged. (Case study: the plan's own instinct, "over-limit must produce visible evidence, never silent truncation" (`plan:11`), is exactly this rule; codify it.)
- **Retries** only for transient faults, with backoff and a bound.
- **User-facing errors** say what happened and what to do next, and never leak internals or secrets.
- **Resources are bounded and released:** timeouts on every network call, bounded queues and buffers, deterministic cleanup (AbortController, `finally`, `using`).

**§4 Tests that prevent regressions**
- A bug fix starts with a **failing test** that reproduces it (strengthening `02-bug-fix-workflow.md:151`, which already says this under Best Practices).
- A new or changed boundary gets **contract tests** on its public interface, not on its internals.
- Tests assert behavior, not wiring. (Case study: the residual "desktop test inspects policy wiring rather than executing IPC", `plan:119`, is a known gap. The standard should call a wiring-only test *partial* evidence under the Verification Bar.)

**§5 Recovery**
- Each phase has a **checkpoint**. When the user has authorized commits: one commit per verified phase. Otherwise: record `git stash create` or the diff hash in the phase report so the phase can be rolled back.
- Risky runtime changes ship behind a **flag or a reversible config switch** when the codebase has one.
- Data and storage migrations state reversibility; a one-way migration needs a backup step and explicit sign-off.

**Appendix (per language, short tables):** TypeScript (`strict`, no `any` without a recorded reason, `noUncheckedIndexedAccess`), Python (type hints and mypy/pyright, context managers), shell (`set -euo pipefail`, quoting, `shellcheck`).

### Wiring (the part that changes behavior)

> **Plan:** Phase C tasks 2–4; the `02-confirm-execution.md` Change Surface re-run is in Phase B task 3.

| Workflow | Change |
|---|---|
| `00-research-and-plan.md` | Template gains tiered sections (§8); research lists reuse candidates as part of the Change Surface |
| `01-plan-review.md` | R6 checklist; judge the Design section against `engineering-standards.md` §1–§3 |
| `02-finalise-plan.md` | Acceptance: plan passes `check-plan.sh`; enabling-refactor rule (R1) |
| `01-execution.md` Preparation | "Load the plan's Design, Decision and Change Surface sections and `engineering-standards.md`; they are build requirements" |
| `01-execution.md` Implement | Before writing new code: *search for reuse* (§2). After the change: re-run Change Surface searches. Record shortcuts in the plan's **Deferred & Debt** section |
| `01-execution.md` Phase report | Checkpoint reference (§5); shortcuts taken |
| `02-confirm-execution.md` | Verify the built code against the plan's Design and Failure Modes sections, and re-run Change Surface searches; stale hits make the task incomplete |
| `04-documentation/03-mark-completed.md` | **Corrected 2026-09-25 (plan re-verification):** missing from the original table. Q6's "terminal gate copies open Deferred & Debt entries into `TODO.md`" changes this file (`:161`, the host-TODO rule), which `check-completion-chain-policy.sh` guards |
| `05-review/01-code-review.md`, `03-code-refactoring.md` | Replace free-floating focus lists (for example `03-code-refactoring.md:77-89`) with references to the same standards sections, so **builder and reviewer judge against the same text** |

### Q6 — Technical debt, minimal version

> **Plan:** Phase C task 4.

Rather than a new `debt/` directory now, add a **Deferred & Debt** section to the plan template. Each entry records the shortcut, its location, the trigger that makes it due and a severity. When the plan is filed, the terminal gate copies open entries into `TODO.md`. Planning Phase 1 reads open entries touching the Change Surface. **Hypothesis:** this delivers most of KI-17's value with no new directory or tooling; promote it to a ledger if the TODO list becomes noisy.

### Q7 — Architecture decisions, minimal version

> **Plan:** Decision section in Phase B task 4. Standalone ADRs are **not extracted** (plan Deferred & Debt).

The in-plan **Decision** section (R3) with a reversibility flag covers most T2 work. Reserve standalone ADRs (July KI-12's `<metadata-root>/decisions/`) for T3 and one-way decisions. Add that location to `naming-conventions.md` only when first used.

---

## 7. Enforcement: how the scripts can make this stick

Today's validators check **the workflow text** (does 01 still say X?). Nothing checks **the artifacts the workflows produce** (does this plan have Y?), and nothing ships to host projects. Prose rules without a failing check drift, as M1 and M3 show.

### E1 — `scripts/validation/check-plan.sh <plan.md>` (host-usable plan linter) · P1

> **Plan:** Phase B task 5 (using the corrected sketch below).

Deterministic and cheap. Referenced from `02-finalise-plan.md` acceptance criteria ("the finalised plan passes `check-plan.sh`") and from the execution Preparation step. **Tested in this session** against a passing and a failing fixture on macOS bash 3.2 / BSD awk. The failing fixture reported exactly: `Decision lists 1 option(s); need >= 2` and `task without Verify: 2. [✅] Other`.

> **Corrected 2026-09-25 (plan re-verification):** The original sketch treated **every** checkbox in the file as a task, so it rejected valid plans. Its `## Success Criteria` checklist, which the current template requires, produced 7 false "task without Verify:" errors when the sketch ran on the implementation plan. The awk block below is now scoped to `## Tasks`. The corrected version, run on the plan, gives exit 0; a copy with one `Verify:` removed gives exit 1 naming that task. The plan replaces `--legacy` with opt-in by `**Tier:**` header (plan Decision D3).

```bash
#!/usr/bin/env bash
# check-plan.sh <plan.md> - structural lint for implementation plans (host-usable).
set -euo pipefail
plan="${1:?usage: check-plan.sh <plan.md>}"
status=0
err() { echo "check-plan: $plan: $*" >&2; status=1; }
need() { grep -qE "^## +($1)" "$plan" || err "missing section: ## $1"; }

tier="$(grep -m1 -oE '^\*\*Tier:\*\* *T[123]' "$plan" | grep -oE 'T[123]' || true)"
[ -n "$tier" ] || err "missing '**Tier:** T1|T2|T3' header"

need 'Goal'
need 'Change Surface'
need 'Tasks'
if [ -n "$tier" ] && [ "$tier" != "T1" ]; then
  need 'Decision'
  need 'Design & Interfaces'
  need 'Failure Modes & Recovery'
  need 'Test Strategy'
  need 'Rollout & Rollback'
  opts="$(awk '/^## +Decision/{f=1;next} /^## /{f=0} f && /^[-*] +\*\*Option/' "$plan" | wc -l | tr -d ' ')"
  [ "$opts" -ge 2 ] || err "Decision lists $opts option(s); need >= 2 (include the minimal option)"
fi

# Every top-level task must carry a 'Verify:' line before the next task or heading.
awk '
  function close_task() { if (open && !v) { print "task without Verify: " t; bad=1 } open=0 }
  /^## +Tasks/ { close_task(); in_t=1; next }
  /^## /       { close_task(); in_t=0; next }
  /^#/         { close_task(); next }
  in_t && /^([-*]|[0-9]+\.) \[/ { close_task(); open=1; v=0; t=$0; next }
  /Verify:/    { v=1 }
  END { close_task(); exit bad }
' "$plan" >&2 || status=1
exit "$status"
```

Follow-ups: a `--legacy` flag that only warns (existing plans predate the template), and a fixture self-test in the style of `check-meta-logs-selftest.sh`. It deliberately checks **structure, not quality**: it guarantees the reviewer has something to review.

### E2 — Positive invariant for the completion chain · P1

> **Plan:** Phase A task 1.

Add to `check-completion-chain-policy.sh`. **Run in this session:** it flags `04-review-finalise-commit-execute.md` and nothing else (M1).

```bash
# Any code-build workflow that names the Not Eligible outcome must route it
# through the gate's Reconcile only mode (regression guard for M1).
for f in "$CB"/*.md; do
  if grep -q 'Not Eligible' "$f" && ! grep -q 'Reconcile only' "$f"; then
    fail "$(basename "$f") names Not Eligible without the Reconcile only gate mode"
  fi
done
```

General lesson for this repository: **prefer "if A is mentioned, B must be too" invariants over blacklists of retired sentences.** Blacklists only catch the wording that was already fixed.

### E3 — CI on the active line · P1

> **Plan:** Phase A task 2; the optional pre-commit extension is Phase E task 3.

`.github/workflows/validation.yml`: add `'v1.8*'` to both `push.branches` and `pull_request.branches`, or drop the branch filter. Optionally extend `scripts/hooks/pre-commit` to run `check-active-markdown-links.sh` and `check-completion-chain-policy.sh` (both fast) alongside `check-meta-logs.sh --staged`.

### E4 — Sizing lint · P2

> **Plan:** Phase A task 4.

In `check-review-workflow-policy.sh` (or a new `check-planning-build-policy.sh`): fail if any file in `01-planning-and-organizing/` or `02-code-build/` contains `aggressively` or `librarian agents`, or mentions "parallel agents" without linking `workflow-applicability.md` in the same file.

### E5 — Skill and workflow drift check · P3

> **Plan:** Phase B task 7.

`11-Skills/workflow-plan-review-finalize/SKILL.md` and `execute-and-confirm-plan/SKILL.md` restate workflow rules. Extend the existing pattern (the completion-chain validator already greps the execute skill for `terminal gate`) with each new required token: `Change Surface`, `Verify:`, `engineering-standards.md`.

### E6 — Host-project gates (cross-reference, out of scope here)

> **Not extracted** (plan non-goal; listed in Deferred & Debt).

The strongest code-quality enforcement lives in the host repository: one `verify` script (typecheck + lint + test), a pre-commit hook, and CI. `00-project-setup/` should offer this when a project lacks it (the `setup-pre-commit` skill already exists). The Verification Bar can then say "run `verify`" instead of each plan rediscovering its commands.

---

## 8. Proposed plan template (replaces `00-research-and-plan.md:216-261`)

> **Plan:** Phase B task 1. Changes: the Risks table uses the rubric's own Impact and Likelihood scales, a Scope and non-goals section is added, and `Verify:` names cost and prereqs.

```markdown
# Implementation Plan: <name>

**Created:** YYYY-MM-DD HH:MM
**Status:** Draft | Ready for review | Final | Superseded by <link>
**Tier:** T1 | T2 | T3
**Research:** <link> (researched at <commit sha>)

## Goal
<one paragraph; success criteria as observable behavior>

## Assumptions
- <assumption> (confirm by: <how>)

## Change Surface
| Behavior | Sites (file:line) | Found with |
|---|---|---|
| <behavior> | a.ts:10, b.ts:88 (fallback) | `rg -n "<pattern>" src` |

## Decision                                   <!-- T2+ -->
- **Option A (minimal):** … Pros/cons.
- **Option B:** … Pros/cons.
- **Chosen:** B, because … **Reversibility:** cheap | expensive | one-way

## Design & Interfaces                        <!-- T2+ -->
<new/changed boundaries: responsibility, public interface, what each hides,
 invariants and where they are enforced; reuse candidates found>

## Failure Modes & Recovery                   <!-- T2+ -->
| Failure | Detection | User sees | Recovery |
|---|---|---|---|

## Test Strategy                              <!-- T2+ -->
<failing-first tests for bugs; contract tests for boundaries; smoke paths>

## Rollout & Rollback                         <!-- T2+ -->
<flag/config switch; checkpoint per phase; migration reversibility>

## Tasks
<phases ordered by dependency, then risk; each task labelled with priority>

### Phase 1: <name>
1. [ ] <task> (P0, Effort: S)
   - Files: <paths>
   - Verify: `<command>` → <expected result> (cost/prereqs: <none | credentials | paid>)

## Deferred & Debt
- <shortcut or deferred item> — where — trigger — S-level

## Risks
| Risk | Impact (S0–S3) | Likelihood (Rare/Possible/Likely) | Mitigation |
|---|---|---|---|
```

For T1, the sections marked `T2+` are omitted, which keeps a bug-fix plan to about 15 lines.

---

## 9. Roadmap

> **Superseded 2026-09-25** by the implementation plan's Tasks section ([plan](../plans/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md#tasks)). The plan keeps Phases A–E, adds a Phase 0 baseline and gates, and applies the corrections above. The text below is kept as the original record.

Each phase is small enough to land and verify independently. Phases are ordered by dependency, following R1's own rule.

### Phase A — Repair the mechanics (P1, Effort S)
- [ ] M1: align 04 `:35`, `:48` with 03; add the E2 invariant (Verify: `bash scripts/validation/check-completion-chain-policy.sh` passes and the E2 loop prints nothing)
- [ ] M2: fix 4 links; E3 CI triggers (Verify: `check-active-markdown-links.sh` exits 0; a push to `v1.82` shows a Validation run). **Corrected 2026-09-25 (plan re-verification):** links go to v1.82 Plan 01 (see M2); only the CI trigger lands here.
- [ ] M3: sizing references in 00 §1.3/Notes, 01, 02, 01-execution; E4 lint (Verify: E4 check passes; `grep -nE 'aggressively|librarian'` empty)
- [ ] M4, M7 wording fixes
- Logs: `changelog/fixed/` plus a matching troubleshooting entry (workflow defects count as bugs here)

### Phase B — Planning quality (P1, Effort M; depends on A for the green CI baseline)
- [ ] Template (§8); R1 enabling-refactor rule; R2 Change Surface; R3 Decision; R8 `Verify:`/`Files:` lines
- [ ] E1 `check-plan.sh` + self-test fixtures; referenced from `02-finalise-plan.md` acceptance
- [ ] M5 supersession step; M6 "Current state" block for appended documents
- [ ] Update `workflow-plan-review-finalize` skill in lockstep (E5)

### Phase C — Engineering standards (P2, Effort M; depends on B, whose template sections it references)
- [ ] Author `00-meta/engineering-standards.md` (§6 outline, ≤ ~80 lines + language appendix)
- [ ] Wire forward (planning, execution, confirm) and backward (code review, refactoring review) per the §6 wiring table
- [ ] Failure Modes & Recovery, Rollout & Rollback, Deferred & Debt sections active at T2+

### Phase D — Research and review rigor (P2, Effort S)
- [ ] R4 research standard (claim labels, primary sources, version pins, commit pin, re-verification)
- [ ] R5 feasibility check and R6 review checklist in `01-plan-review.md`; R7 intake rule

### Phase E — Reconcile the July proposal (P3, Effort S)
- [ ] Run `01-plan-review.md` on `Drag-Free-v2/2026-07-06-engineering-quality-and-lifecycle-proposal.md`; mark KI-13/KI-14 as superseded by Phases B–C; refresh stale line citations; keep KI-12 (full design workflow), KI-15 (greenfield lane), KI-16 (deploy) and KI-17 (debt ledger) as later work

### Pilot and success criteria
- [ ] The next non-trivial Flash-UI plan is written on the new template and passes `check-plan.sh`. Its Change Surface, re-run after build, shows zero stale sites.
- [ ] Retro-check: applying R2 to the 2026-09-23 prompt-quality plan would have listed `lib/style-loader.ts:444, 506` and `lib/skill-loader.ts` (the search `rg -n "3\+ layers|spring-physics|html-ui-base" lib prompts` finds them). This is a zero-cost validation of the rule. **Corrected 2026-09-25 (plan re-verification):** the same search also matches `prompts/catalog/design-templates.txt:23, 35`. Those lines are example user prompts, not mandates, so a Change Surface must classify hits, not only count them.
- [ ] No T1 plan exceeds about 20 lines (tiering guards against process tax).
- [ ] All validators green on the active line in CI.

### Risks

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| Process tax on small changes | S2 | Likely without tiers | T1 requires only Goal, Change Surface, Tasks; `check-plan.sh` enforces extra sections only at T2+ |
| Standards become a style guide nobody reads | S3 | Possible | ≤ ~80 lines; checkable questions; reviewers cite section numbers |
| Linters create false confidence (structure ≠ quality) | S2 | Possible | Linter guarantees reviewable *inputs*; judgement stays with R6 review; behavioral testing via the v1.82 harness plan |
| Collision with the v2 redesign | S3 | Possible | One file in the existing `00-meta/` mechanism; v2 can relocate it |
| Existing plans fail the new linter | S3 | Likely | `--legacy` warn-only mode; apply to new plans only |

---

## 10. Evidence index (commands run this session)

| Check | Result |
|---|---|
| `git pull --ff-only` (Workflow-Scripts) | Already up to date; branch `v1.82` |
| `for s in scripts/validation/check-*.sh; do bash $s; done` | 6 pass; `check-active-markdown-links.sh` fails (4 links, M2); `check-meta-logs.sh` usage error without args (not a defect) |
| `grep -n "Not Eligible" 02-code-build/04-…md` | `:35`, `:48`, without Reconcile only (M1) |
| E2 loop over `02-code-build/*.md` | `WOULD FAIL: 04-review-finalise-commit-execute.md` only |
| `grep -rn "project/build/" 02-code-build 01-planning-and-organizing` | `03-execute-and-confirm.md:11, 48` (M4) |
| `grep -nE "aggressively|librarian" 01-planning-and-organizing/*.md` | `00-research-and-plan.md:71, 329` (M3) |
| `grep -rlnE 'decisions/|\bADR\b|debt/' --include='*.md' .` excluding Drag-Free-v2 | No matches (W13/W19 still open) |
| `grep -nE "3-layer|3\+ shadow|spring" lib/style-loader.ts` (Flash-UI) | `:437`, `:444`, `:506`: mandate still present (case study) |
| Same pattern over `prompts/generation/_universal-baseline.txt`, `variations.txt` | No matches: removed there (case study) |
| `check-plan.sh` sketch on good and bad fixtures | good: pass; bad: 2 expected errors, exit 1 |
