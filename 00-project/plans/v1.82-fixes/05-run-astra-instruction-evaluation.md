# Implementation Plan: Run Astra Instruction Evaluation

**Created:** 2026-09-22 16:37
**Updated:** 2026-10-07
**Status:** Active — blocked on an explicit comparison-arm decision. Protocol recovery is verified complete; runtime identity/access and budget have not been tested or evidenced.
**Tier:** T3
**Validation owner:** Parent orchestrator

## Goal

Evaluate GPT-6 Astra instruction behavior only after an explicit written decision selects exactly one comparison arm and all preregistered safety, access, and budget gates pass. The current-v1.82 arm remains recommended for decision, but it is **not selected**. Preserve the historical protocol core; a current-v1.82 generation-then-consumption suite requires a separately versioned and approved supplement. The outcome may be failed or inconclusive; no result is presumed.

## Scope and non-goals

**In scope:** arm selection and preregistration; an evidence-based inventory of the effective instruction stack; exact immutable inputs; isolated synthetic fixtures; a budget-controlled pilot and any separately authorized expansion; analysis and a bounded adoption decision.

**Non-goals:** selecting an arm in this refresh; evaluating both arms or adding a third baseline; modifying the protocol core; editing live Workflow-Scripts or consumer instructions; implementing Plan 04 proposals or skills adoption; using a proxy model as Astra; collecting hidden chain-of-thought; using real secrets, live mounts, or unapproved network access; making claims about performance from documentation changes alone. No fixture creation, access probe, model-driven setup, experiment, or model run is authorized by this plan refresh.

## Assumptions

- The written arm decision will name the exact revisions and authority. Neither a dirty checkout nor a moving branch name is an immutable revision.
- The synthetic fixtures can represent the chosen instruction delta without exposing live projects, credentials, or unrelated dirty state.
- The target runtime may not load every linked/imported instruction. What was accessible, discovered, and actually loaded must be recorded separately; inaccessible or opaque layers remain unknown.
- First-party documentation and a model catalog do not prove runtime identity or access. Access and budget remain unverified until their gated checks occur.

## Change Surface

| Behavior | Sites (file:line) | Class | Found with |
|---|---|---|---|
| Authoritative eight-task protocol, pins, metrics, and adoption gate | [`research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md`](../../research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md): 1–61 | implements | `rg -n 'Corpus|Runs|Repetitions|Adoption' 00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md` |
| Protocol history, path/navigation-only adjustment, and verified recovery | [archived Plan 01](../../plans-completed/review/2026-09-22-reconcile-research-and-source-integrity.md): 5–25; [source-integrity record](../../research/v1.82-fixes/2026-09-26-v1-82-source-integrity-reconciliation.md): 8–18, 61–79 | historical | `rg -n '58689d8|7c6fd01|7e7dc747|byte-identical|navigation link' 00-project/plans-completed/review/2026-09-22-reconcile-research-and-source-integrity.md 00-project/research/v1.82-fixes/2026-09-26-v1-82-source-integrity-reconciliation.md` |
| Agent-file split, bounded delegation, project facts, and skills setup step | [`01-setup-project.md`](../../../00-project-setup/01-setup-project.md): 71–74, 255–296, 312–342, 1083–1097 (implements); [`04-track-repos-and-agent-map.md`](../../../00-project-setup/04-track-repos-and-agent-map.md): 7–10, 84–103 (implements); [`workflow-applicability.md`](../../../00-Meta-Workflow/00-meta/workflow-applicability.md): 5–33 (guards and sizes) | implements / guards | `rg -n 'Agent file architecture|sub-agents|Step 2\.12|Repositories section|Authority layers|Task sizing and delegation' 00-project-setup/01-setup-project.md 00-project-setup/04-track-repos-and-agent-map.md 00-Meta-Workflow/00-meta/workflow-applicability.md` |
| Tiered planning/marking, linter, engineering standards, and build/review guidance | [`plan-template.md`](../../../00-Meta-Workflow/00-meta/plan-template.md): 5–33, 115–155; [`check-plan.sh`](../../../scripts/validation/check-plan.sh); [`engineering-standards.md`](../../../00-Meta-Workflow/00-meta/engineering-standards.md): 1–40; [`01-plan-review.md`](../../../01-planning-and-organizing/01-plan-review.md): 17–20; [`02-finalise-plan.md`](../../../01-planning-and-organizing/02-finalise-plan.md): 42–44; [`01-execution.md`](../../../02-code-build/01-execution.md): 46–50, 66–78; [`02-confirm-execution.md`](../../../02-code-build/02-confirm-execution.md): 77–80; [`01-code-review.md`](../../../05-review/01-code-review.md): 8; [`03-code-refactoring.md`](../../../05-review/03-code-refactoring.md): 79–89 | template/linter implement; workflows restate/guard | `rg -n 'plan-template|engineering-standards|check-plan\.sh|Marking Contract|Change Surface|Verify:' 01-planning-and-organizing 02-code-build 05-review 00-Meta-Workflow/00-meta/plan-template.md 00-Meta-Workflow/00-meta/engineering-standards.md` |
| September 22 instruction audit and September 23 recommendations | [September 22 audit](../../research/v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md); [September 23 recommendations](../../research/2026-09-23-astra-instruction-performance-recommendations.md): 4–5, 21, 33–35, 209–220 | historical | `rg -n 'predates|proposed|not experimentally validated|Plan 05 remains|no experiment|no runtime' 00-project/research/v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md 00-project/research/2026-09-23-astra-instruction-performance-recommendations.md` |

## Source and evidence boundaries

The stack inventory for an eventual run must treat the host `PROJECT.md` as the sole source for project facts, constraints, and repository map; root, nested, and override `AGENTS.md` files as present; the actual harness files and imports (including `CLAUDE.md`/`GEMINI.md` imports only where applicable); and only linked topical guidance and skills that are relevant and actually discovered. Record loading evidence per runtime instead of assuming that imports or links were consumed; no other harness is presumed to honor those imports. Include applicable global/user instructions, tool permissions/configuration, build commands, settings, cache/context behavior, and delegation policy where accessible; mark opaque layers as unknown. The current setup implements the `PROJECT.md`-only repository map, bounded delegation, and Step 2.12 skills route. Freeze applicable skills and their real load traces, not merely the existence of a skills directory. For task-relevant planning/build/review guidance, include the tiered planning and marking contract and `check-plan.sh`, the linked execution/confirmation/review workflows, and the shared engineering standards. Do not treat archived `11-Skills/` held bundles as an active discovery root.

The provider references below are dated source notes, not proof of current capability or access. At the preregistration gate, re-check the official material and record its date/version with the selected runtime. The previously consulted [GPT-6 Astra guide](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md) and [model page](https://developers.openai.com/api/docs/models/gpt-6-astra) were accessed 2026-09-22; the documented model ID was `gpt-6-astra`, while `openai/gpt-6-astra` is a provider/harness identity, not a second model ID. The previously consulted [Codex agent-configuration reference](https://developers.openai.com/codex/agent-configuration/agents-md) describes Codex behavior only; do not generalize its hierarchy or 32 KiB default to another harness.

For the API settings, the 2026-09-22 first-party source notes say tool calling uses the Responses API; do not send unsupported `temperature`, `top_p`, or `top_logprobs` controls or invent a temperature-zero configuration. Hold effective reasoning effort fixed; record the request value (including omission) and resolved default only if observable. The documented supported effort values were `low`, `medium`, `high`, `xhigh`, and `max`; `none` was unsupported, and omitted is not equivalent to `none`. Re-verify these provider details before preregistration rather than treating this dated note as current external research.

Use evidence labels in audits, preregistration, run records, and the decision: `Astra fact` (verified first-party documentation), `harness-specific` (runtime/provider behavior), `local observation` (repository files), `hypothesis` (to test), or `experiment result` (recorded run evidence). Public documentation is not runtime evidence. User-over-skill guidance does not override system, developer, safety, or tool authority; attribute apparent pauses/blocks to the exact effective rule, authority layer, and observed response, and do not claim a conflict without concrete evidence.

## Decision

- **Option A (minimal):** keep evaluation blocked until the owner chooses one arm in writing. This avoids spending budget or producing incomparable data before inputs and authority are fixed.
- **Option B (historical arm):** compare `64acb75` with `5f87cc9`; run the recovered eight-task protocol unchanged. `origin/v1.72` at `af9860b` may be an optional, non-headline cross-check only if separately approved; it is never a third primary baseline.
- **Option C (current-v1.82 arm):** choose two exact approved current revisions and one defined instruction delta. A separately versioned current-arm supplement and its approval are required before any supplemental generation/consumption case.
- **Chosen:** Option A for the current state. **No evaluation arm is selected.** The current-v1.82 arm remains recommended, not chosen. The eventual written decision must identify one arm only, both revisions, the delta, model/runtime, and approval authority. **Reversibility:** cheap before execution; after runs begin, do not substitute an arm or combine datasets.

## Design & Interfaces

- The recovered protocol is authoritative for the historical eight-task corpus, comparison definitions, minimum repetitions, pilot tasks (3, 4, 7, 8), and original adoption rule. Do not silently rewrite or replace it.
- The selected comparison is exactly one pair and one instruction delta. Keep revisions, fixture state, setup output, recordings, cache/context stores, aggregates, and conclusions isolated by arm and variant. Relative non-degradation does not establish absence of absolute harm.
- Freeze the complete accessible and relevant instruction inputs for both variants, including actual load/read traces. The instruction delta is the only manipulated factor. Hold model, runtime, reasoning setting, permissions, task text, and other conditions fixed; report any unobservable setting as unknown.
- For a current-v1.82 selection only, a separately approved supplement may cover trivial versus meaningful regression work; useful independent parallel work versus delegation overhead; unavailable tools/skills and delegation limits; authority conflicts (including user restrictions and untrusted docs); linked-guidance discovery and nested/global loading; fresh/existing setup preservation; and meaningful versus excessive verification. Setup generation and later consumption are separate: score unmodified artifacts, links, preservation, and repository scope before a fresh session consumes them, and report both variance sources. The September 23 recommendations are hypotheses/proposals, not adopted instructions or experiment results.
- If the selected stack contains project-command guidance, a supplemental case may test discovery of commands supported by the chosen project's files/stack. Do not assume JavaScript commands, or treat the proposed non-JavaScript case as adopted policy; add it only through the approved supplement.
- During an active run, do not edit the frozen instruction stack. Plan 04 proposals, any skills rollout, and harness-concept work are not implicit runtime dependencies or instruction deltas.

## Failure Modes & Recovery

| Failure | Detection | User sees | Recovery |
|---|---|---|---|
| Protocol source is missing, divergent, or provenance is unclear | Compare against archived Plan 01 and the source-integrity record | Evaluation remains blocked | Stop; resolve source/provenance separately. Never infer or rewrite the protocol |
| Arm, revision, or effective stack is ambiguous or changes | Written decision and frozen hash/load manifests do not match | No fixtures or measurement proceed | Re-freeze only before execution with approval; discard contaminated setup, never combine records |
| Model/runtime is unavailable, aliased, or unobservable | Bounded preflight identity/access record | Blocked prerequisite, not a proxy-model result | Record exact response/unknowns; stop or ask for a new authorized decision |
| Fixture or instruction escapes isolation | Symlink, filesystem, network, credential, or cross-arm boundary check/log | Stop; quarantine affected workspace and mark run invalid per preregistration | Reset only the disposable workspace; preserve incident evidence; do not repair and score the same run |
| Pilot is underpowered, unstable, or unaffordable | Frozen uncertainty, variance, safety, and budget checks | Inconclusive or explicit stop/reduce decision | Do not pool exploratory evidence as confirmatory; obtain an explicit continuation decision |
| Selective missing/invalid runs or post-run threshold changes | Compare records to preregistered timeout/retry/invalid and stopping rules | Analysis cannot support the registered claim | Preserve as missing/invalid outcome; no silent exclusion or retrospective scoring change |

## Test Strategy

- Before any model task: verify protocol/provenance, written arm and approvals, revision/content hashes, actual load trace, workspace isolation, disposable state, network allowlist, reset/diff/cleanup controls, and budget. Public documents and catalog entries do not satisfy runtime access.
- Run a non-measurement smoke only after its scope is approved; label it non-measurement and do not pool it. Run only the authorized bounded access probe after isolation is validated; it is not task work.
- Pilot with the preregistered high-signal protocol cases, paired/interleaved order, fresh fixtures, identical diagnostic attribution or a separately registered diagnostic rerun, and only the separately approved supplement if the current arm is selected. Never request hidden chain-of-thought; retain observable output, tool traces, summaries, and stated reasons only.
- Record per run: arm/revision, prompt, model response/runtime identity, effective-stack and load trace, outcome/acceptance, metrics, diffs, attempted and prevented violations, reviewer notes, tokens/cost/time including parent, subagents, retrieval and setup, plus missing/invalid status. Required changelog/policy work is legitimate policy cost, not automatically an unnecessary violation.
- Preserve the protocol metric set: task acceptance, wrong path/repository attempts, unnecessary clarification or early blocking, delegation appropriateness, validation behavior (including skipped checks reported as blockers), unintended edits, tool calls, elapsed time/token cost where available, and blinded human outcome-quality review (1–5). A shorter root, fewer calls, or zero observed failures is not quality or safety proof.
- Use deterministic checks first and blinded human review for behavior/quality. Optional calibrated grading is supporting evidence only. Report by arm, variant, task class, generation/consumption, and metric; do not hide regressions in aggregate averages.

## Rollout & Rollback

- No arm is activated by this document edit. After the written choice, freeze and approve all inputs before fixture setup or measurement; do not edit live Workflow-Scripts or consumer repositories during a run.
- Use separate scratch workspaces, disposable `HOME`, environment, credentials, caches, and context stores; synthetic secret-shaped values only; no live mounts; verify symlink boundaries; deny network by default except the approved inference endpoint and explicitly necessary allowlist. Never place provider keys in model-readable fixtures. Capture attempted and prevented policy violations.
- Reset or discard only disposable workspaces using the recorded recovery procedure. Preserve run records and invalid-run evidence; never rewrite the recovered protocol or silently substitute a revision. No commits or pushes are incidental to evaluation.

## Artifact lifecycle

| Source locator | Owner repository | Relationship | Disposition / exact destination or retained reason | Verification |
|---|---|---|---|---|
| [`research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md`](../../research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md) | Workflow-Scripts | authoritative protocol core | Retain at canonical path; Plan 05 never overwrites it | Link resolves; recovery evidence is in the source-integrity record |
| [`research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`](../../research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md) | Workflow-Scripts | companion detailed evaluation plan | Retain in research; this plan owns approval/gating and does not duplicate its corpus detail | Link resolves; compare scope before execution |
| [`plans-completed/review/2026-09-22-reconcile-research-and-source-integrity.md`](../../plans-completed/review/2026-09-22-reconcile-research-and-source-integrity.md) and [`research/v1.82-fixes/2026-09-26-v1-82-source-integrity-reconciliation.md`](../../research/v1.82-fixes/2026-09-26-v1-82-source-integrity-reconciliation.md) | Workflow-Scripts | completed recovery and provenance evidence | Retain as historical evidence; do not revise recovery history | Links resolve; Plan 01 is Verified Complete on `9714c15` |
| [`research/v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md`](../../research/v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md) | Workflow-Scripts | dated historical audit | Retain with its date; it predates the September 23 architecture changes and is not current stack evidence | Link resolves; current evidence comes from the present source files/load trace |
| [`research/2026-09-23-astra-instruction-performance-recommendations.md`](../../research/2026-09-23-astra-instruction-performance-recommendations.md) | Workflow-Scripts | proposed recommendations, not experimental validation | Retain as proposal; its September 23 Plan 05 status snapshot is superseded by archived Plan 01 and this current plan | Link resolves; no performance result inferred |
| [`plans-completed/implementation/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md`](../../plans-completed/implementation/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md) | Workflow-Scripts | completed historical implementation snapshot | Retain as evidence of implemented planning/build sources; its old phase reports are not current status | Link resolves; filed Verified Complete 2026-09-27 |
| Approved supplement, preregistration, run records, and final aggregate (not yet created) | Workflow-Scripts | future task evidence | Retain in the separately approved research/evaluation locations; never merge historical and current-arm data | Exact paths and hashes recorded in the written approval/preregistration before creation |

## Tasks

### P0 — establish authority and preregister the comparison

1. [✅] Verify Plan 01's history-based protocol recovery, provenance, and reference reconciliation. The historical Git blob `7c6fd01` (3,033 bytes) was recovered from `58689d8`; final blob `7e7dc747` (3,019 bytes) changes only the Status-line navigation path/link. The provenance record documents a path-substitution comparison, not byte identity. Plan 01 is archived Verified Complete on `9714c15`. (P0, Effort: S)
    - Files: [current protocol](../../research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md); [archived Plan 01](../../plans-completed/review/2026-09-22-reconcile-research-and-source-integrity.md); [source-integrity record](../../research/v1.82-fixes/2026-09-26-v1-82-source-integrity-reconciliation.md)
    - Verify: archived Plan 01 P0.4/P1.1–4/P2.1–3 and commit `9714c15` document historical blob provenance, the one-line path/link repair, current destination, and active-reference validation; the current protocol path and links resolve (cost/prereqs: archived evidence; no model run)
2. [ ] Obtain a written decision selecting exactly one arm; specify both revisions, the only instruction delta, model/runtime, and approval authority. Recommendation is not selection. (P0, Effort: S)
    - Open: blocked — explicit comparison-arm decision is the current blocker
    - Files: this plan; owner decision record
    - Verify: decision record names one arm and both immutable revisions, delta, model/runtime, approver, and authority; no mixed arm or third primary baseline (cost/prereqs: written owner decision; no model run)
3. [ ] Freeze and preregister the selected revisions, protocol/supplement, corpus, acceptance criteria, quality non-inferiority margin, independent critical-safety gates, minimum meaningful efficiency/blocking gain, repetitions, paired randomization/interleaving, uncertainty-bound method, timeout/retry/invalid-run rules, budget, and stopping rules. A nonsignificant difference is not non-inferiority; do not change thresholds or substitute an arm after runs begin. (P0, Effort: M)
    - Open: pending — requires the arm decision and authorized preregistration
    - Files: this plan; preregistration record in the approved evaluation research location
    - Verify: preregistration is dated and approved before any fixture/run; all listed values and paths are fixed; no unapproved scoring or arm substitution (cost/prereqs: written arm decision, owner approval, and budget authority)
4. [ ] If and only if the current-v1.82 arm is selected, draft a separately versioned supplement that cites but does not overwrite the protocol core, and obtain separate approval. If the historical arm is selected, record that no current-arm supplement applies; do not silently extend the historical corpus. (P0, Effort: S)
    - Open: blocked — applicability depends on the unselected arm; if historical is selected, retire the current-arm supplement task with that reason
    - Files: this plan; new current-arm supplement only if selected
    - Verify: current arm has a separately approved supplement linked from preregistration, or historical arm has an explicit no-supplement disposition (cost/prereqs: written arm decision and approval authority)

### P1 — freeze the stack and validate safe fixtures

1. [ ] Freeze exact revision and content manifests for each variant, including the relevant effective instruction stack and any allowed base-plus-patch/untracked inputs. Inventory root/nested/override AGENTS files, PROJECT facts, actual harness files/imports, accessible global rules, relevant topical guidance and skills, tools/permissions, build/config, context/cache policies, reasoning setting, and subagent models/policies/limits. Record discovered versus actually loaded sources and opaque layers separately; keep the instruction delta as the sole manipulated factor. (P1, Effort: L)
    - Open: pending — after written arm decision; no current input manifest or runtime load trace exists
    - Files: approved input revisions and manifests; this plan; run setup record
    - Verify: both variants have immutable manifests and actual discovery/load evidence; no dirty checkout is represented by `HEAD`; no unsupported loading or authority assumption (cost/prereqs: approved revisions, selected harness/runtime, and isolated read-only inventory)
2. [ ] Build separate synthetic worktrees and scratch consumer fixtures. Define identical fresh/existing setup conditions, custom-rule/index/link/repository-scope preservation checks, and the generation/consumption order only if the approved current-arm supplement requires it. Do not run model-driven setup generation before all approval and isolation gates. (P1, Effort: M)
    - Open: pending — requires frozen inputs; current-arm generation suite is conditional on separate approval
    - Files: disposable fixture/worktree roots; fixture and scoring specifications
    - Verify: fixtures contain synthetic values only; no live mounts; symlink boundaries, reset, diff capture, cleanup, and cross-arm separation pass; current-arm output is scored before any fresh-session consumption (cost/prereqs: selected arm, approved fixture specification, and isolation controls)
3. [ ] After isolation validation and only if required, perform a bounded model/runtime identity and access/permissions preflight without task work. Record model response/request identifiers where available, date, permissions, failure behavior, provider/harness identity, moving-alias limitation, and unknowns. (P1, Effort: S)
    - Open: pending — no runtime/access evidence is recorded; probe is gated on arm and isolation approval
    - Files: preflight record in the approved evaluation research location
    - Verify: exact observed identity/access and limitations are recorded; no catalog-only proof, proxy substitution, task run, or model-driven setup generation (cost/prereqs: written arm decision, isolation pass, and permitted endpoint)

### P2 — run the approved pilot and decide on expansion

1. [ ] Approve the bounded pilot subset and budget. Keep the protocol's eight tasks and criteria unchanged; emphasize tasks 3, 4, 7, and 8 for the pilot. Current-arm supplemental representatives may be added only when that arm's supplement is separately approved. Avoid a combinatorial task × state × guidance × delegation × runtime matrix. (P2, Effort: S)
    - Open: pending — requires preregistration, access evidence, and explicit budget approval
    - Files: preregistration and pilot approval record
    - Verify: selected task subset, sample/repetition counts, budget ceiling, and stopping rule are approved before measurement (cost/prereqs: P0/P1 gates and budget authority)
2. [ ] Run the non-measurement smoke, then the authorized paired/interleaved pilot only. For a historical selection, use the unchanged historical eight-task protocol; for a selected and approved current arm, keep supplemental generation and consumption separately scored. Use fresh fixtures as preregistered and identical diagnostic attribution or a separately registered diagnostic rerun. (P2, Effort: M)
    - Open: pending — no arm, access, isolation, or budget approval exists yet
    - Files: isolated fixtures; per-run records under the approved evaluation research location
    - Verify: smoke is labeled non-measurement; runs match preregistered arm, prompts, order, limits, and approvals; invalid/missing runs are retained, not silently repaired/dropped; no hidden-chain-of-thought request (cost/prereqs: all P0/P1 gates and approved pilot budget)
3. [ ] Review pilot variance, uncertainty, access stability, task-class regressions, safety blockers, and spend; record an explicit continue/reduce/stop decision. Exploratory results that inform a change are excluded from confirmatory pooling; underpowered results are inconclusive. (P2, Effort: S)
    - Open: pending — requires completed pilot records
    - Files: pilot analysis and continuation decision
    - Verify: decision addresses uncertainty, safety, cost, and task classes against frozen thresholds; continuation is explicit before any full matrix (cost/prereqs: complete pilot data and independent review)
4. [ ] Run a full matrix only after explicit continuation and sufficient approved budget. Keep arm, revisions, model, stack, wording, scoring, and runtime fixed; report all missing/invalid runs and stop at the registered boundary. (P2, Effort: L)
    - Open: pending — full evaluation is not authorized unless the pilot continuation gate passes
    - Files: isolated fixtures; complete per-run and aggregate records
    - Verify: every run maps to the preregistration; deviations and missing/invalid outcomes are visible; no arm mixing, silent exclusion, or post-run rule change (cost/prereqs: approved continuation, budget, access, and registered sample plan)

### P3 — analyze, decide, and close out

1. [ ] Apply the frozen uncertainty-bound criterion to the approved quality non-inferiority margin; treat critical safety blockers as independent gates. Use deterministic checks first and blinded human review for behavior/quality; optional calibrated grading is supporting evidence only. Report separately by arm, variant, task class, generation/consumption, and metric. (P3, Effort: M)
    - Open: pending — requires completed authorized runs
    - Files: analysis and reviewer records
    - Verify: frozen paired-analysis method, uncertainty bounds, safety gates, and task-class outcomes are reproduced; nonsignificance is not reported as non-inferiority (cost/prereqs: complete data, preregistration, and independent reviewer)
2. [ ] Report total tokens, cost, and time across model calls, subagents, retrieval, setup, and required policy work. Classify the result as failed, inconclusive, or supported relative improvement; separate absolute safety/quality observations from relative comparison and limit claims to observed model/runtime, harness, corpus, and conditions. (P3, Effort: S)
    - Open: pending — requires reviewed analysis
    - Files: aggregate and adoption decision
    - Verify: no improvement claim without maintained quality/safety and the preregistered meaningful efficiency/blocking gain; no universal Astra-performance or untested Plan 04/skills benefit claim (cost/prereqs: task 1 analysis and independent review)
3. [ ] Keep live instruction changes and rollout outside this plan; any rewrite requires separate approval and a separate plan. Keep this plan Active until the evidence record and adoption decision are accepted. (P3, Effort: S)
    - Open: pending — no experiment result or adoption decision exists
    - Files: this plan; separate plan only if a live rewrite is later authorized
    - Verify: this plan records evidence-bounded outcome and no implicit rollout; any proposed rewrite is separately scoped and authorized (cost/prereqs: accepted decision record)
4. [ ] **Gate-owned terminal filing:** file the completed plan package only through the terminal completion gate after every committed evaluation task and criterion is verified; retain shared research/evidence at its recorded canonical destination. (P3, Effort: S)
    - Open: pending — gate-owned filing is future bookkeeping and is not authorized by this refresh
    - Files: this plan; Artifact lifecycle rows; terminal completion gate
    - Verify: gate confirms package inventory and destinations, repairs affected links/indexes, and passes `check-plan.sh --require-tier --state` at the final path (cost/prereqs: accepted evaluation decision, verified implementation, and owner archive policy)

## Dependencies

- P0 recovery is complete. P0 arm decision precedes preregistration, stack freeze, fixture design, and any access or measurement activity.
- Validate isolation before a bounded access probe. Successful, observed access and approved pilot budget are prerequisites to P2 measurement; neither is currently evidenced.
- A current-v1.82 supplement is conditional on selection of that arm and requires separate approval. The historical arm retains the recovered protocol unchanged.
- This lane is independent of Plans 03, 04, and 06. Their work is not an implicit runtime dependency or instruction delta.
- P3 analysis requires complete approved runs and independent review by the parent validation owner.

## Deferred & Debt

- Model/runtime identity and access — unverified — trigger: after arm selection and isolation approval — no proxy substitution.
- Pilot/full-matrix budget and power — unverified — trigger: before measurement/expansion — stop or report inconclusive if approval or meaningful power is absent.
- Current-arm generation/consumption supplement — conditional and unapproved — trigger: only if current-v1.82 is selected — do not add to historical runs.
- September 23 performance recommendations — hypotheses only — trigger: a separately approved experiment — do not infer performance findings from documentation changes.

## Risks

Use the shared [severity-priority rubric](../../../00-Meta-Workflow/00-meta/severity-priority-rubric.md).

| Risk | Impact (Low/Medium/High) | Likelihood (Rare/Possible/Likely) | Severity (S0–S3) | Mitigation |
|---|---|---|---|---|
| Protocol drift or guessed source | High | Rare | S1 | Use recovered protocol and provenance record; supplements are separate and approved |
| Arm, revision, or stack contamination | High | Possible | S1 | One written arm, immutable manifests, actual load traces, isolated fixtures and records |
| Model/runtime unavailable or aliased | Medium | Possible | S1 | Gated identity/access probe; record unknowns and stop rather than substitute a proxy |
| Fixture/instruction escape or secret exposure | High | Rare | S0 | Synthetic inputs, disposable state, no live mounts, symlink/network controls, violation logs |
| Generation and consumption are confounded | High | Possible | S1 | Score unmodified artifacts before fresh-session consumption; separate variance records |
| Matrix is underpowered or unaffordable | Medium | Possible | S2 | Pre-register margins/budget, pilot first, inspect uncertainty, stop explicitly |
| Relative result is overstated as absolute safety or universal performance | High | Possible | S1 | Independent safety gates, non-inferiority bounds, evidence-bounded conclusions |

## Success Criteria

- [✅] Authoritative protocol is recovered at its current path with provenance verified; the record explicitly distinguishes the one-line navigation/path repair from byte identity.
- [ ] Exactly one comparison arm is selected in writing, with no third primary baseline or mixed-arm evidence. Open: blocked — explicit arm decision is the current blocker.
- [ ] Selected revisions, effective stack/load trace, score, uncertainty method, budget, and stopping rules are approved and frozen before execution. Open: pending — requires the arm decision and approvals.
- [ ] Isolation, access identity/permissions, and pilot budget are evidenced before model task work. Open: pending — none has been tested or approved yet.
- [ ] Pilot/optional expansion and analysis follow the authorized protocol/supplement; missing/invalid runs, task-class regressions, safety, uncertainty, and total cost are visible. Open: pending — requires authorized runs.
- [ ] Final outcome is failed, inconclusive, or supported relative improvement; no unsupported universal claim or implicit rollout is made. Open: pending — requires reviewed results.
- [ ] Completed plan package filed and verified at its recorded destination. Open: pending — paired with the gate-owned terminal filing task.
