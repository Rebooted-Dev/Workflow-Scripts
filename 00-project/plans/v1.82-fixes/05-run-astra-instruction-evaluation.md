# 2026-09-22 16:37

# Run Astra Instruction Evaluation

**Status:** Active — blocked pending protocol recovery and an explicit comparison-arm decision

**Summary:** Evaluate GPT-6 Astra instruction behavior only after Plan 01 restores the authoritative protocol and an explicit decision selects one comparison arm. The current-v1.82 arm is recommended for decision, but is **not selected**. Preserve the protocol core for the selected arm; if the current-v1.82 arm is selected, add a separately approved generation-then-consumption suite. Use isolated synthetic projects, immutable approved inputs, pre-registered scoring and budget, a pilot before any full matrix, and evidence-bounded conclusions. This lane does not depend on the harness concept test, AGENTS-file behavior-rule rollout, or skills decision.

## Operating boundaries and evidence labels

- **Blocked means blocked:** read-only planning and audit work is allowed now; fixture creation, live setup changes, experiments, and model runs are not.
- **Protocol authority:** the original protocol remains authoritative. Plan 01 must recover it from tracked history; Plan 05 owns any separately versioned, separately approved supplement for the current corpus. Never overwrite the recovered original or silently replace it with an inferred protocol.
- **Evidence labels:** mark statements in the audit, preregistration, run records, and decision as `Astra fact` (verified first-party documentation), `harness-specific` (runtime/provider behavior), `local observation` (this repository's files), `hypothesis` (to test), or `experiment result` (recorded run evidence). Public documentation is not proof of runtime access.
- **Instruction authority:** user-over-skill guidance does not override system, developer, safety, or tool authority. Treat an apparent pause/block as a hypothesis until the exact effective rule, authority layer, and observed response are recorded. Do not claim a conflict without concrete conflicting instructions and evidence.

## Source and review provenance

- Primary first-party behavior source: [GPT-6 Astra guide](https://developers.openai.com/api/docs/guides/latest-model/gpt-6-astra.md), accessed 2026-09-22. It recommends auditing accessible instructions, reports sensitivity to skills and AGENTS guidance, and warns that unclear or conflicting instructions can cause pauses or blocks; it also notes under-delegation and over-testing of small changes. Attribute any observed blocker to an exact rule rather than generalizing from the guide.
- First-party identity source: [GPT-6 Astra model page](https://developers.openai.com/api/docs/models/gpt-6-astra), accessed 2026-09-22. The model ID is `gpt-6-astra`. `openai/gpt-6-astra` is a provider/harness identity, not a second model ID.
- First-party API constraints to freeze: tool calling uses the Responses API; do not send unsupported `temperature`, `top_p`, or `top_logprobs` controls, and do not invent a temperature-zero Astra configuration. Use supported reasoning effort `low`, `medium`, `high`, `xhigh`, or `max`; hold effective effort fixed, record the request setting (omitted if omitted), and record the resolved default if observable. `none` is unsupported; an omitted setting is not equivalent to `none`, and an unobservable default remains unknown.
- Codex-specific reference: [Codex agent configuration](https://developers.openai.com/codex/agent-configuration/agents-md), accessed 2026-09-22. Its AGENTS hierarchy and 32 KiB `project_doc_max_bytes` default describe Codex; do not assert that OpenCode or another harness loads the same hierarchy or limit.
- Current evaluation source: [`Astra Instruction Evaluation Plan`](../../research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md).
- Protocol source to be restored by Plan 01: the historically tracked path `00-project/research/2026-09-10-astra-instruction-evaluation-protocol.md`. Plan 01 must recover and compare it from history rather than recreate it.
- Audit and local-risk inventory: [`Astra setup-instruction audit`](../../research/v1.82-fixes/2026-09-22-astra-setup-instruction-audit.md).
- Local setup references reviewed: [`01-setup-project.md`](../../../00-project-setup/01-setup-project.md) (existing-project preservation, slim/calibrated delegation, generated CLAUDE/GEMINI guidance, and repo-map handoff), [`04-track-repos-and-agent-map.md`](../../../00-project-setup/04-track-repos-and-agent-map.md) (identical inline map versus canonical-doc variants), and [`workflow-applicability.md`](../../../00-Meta-Workflow/00-meta/workflow-applicability.md) (authority, sizing, and delegation).
- Archived remediation context: [`Workflow-Scripts instruction remediation`](../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md).

## Blocking and arm-selection gates

1. **Plan 01 gate:** recovered bytes, headings, links, provenance, supersession, and active-reference validation must pass. If the protocol is missing, divergent, or provenance is unresolved, stop and report blocked.
2. **Arm gate:** before fixture creation or model runs, obtain a written decision selecting exactly one arm, naming both revisions, the instruction delta, model/runtime, and approval authority:
   - **Recommended, not selected — current-v1.82 arm:** define two exact approved current-v1.82 revisions and their instruction delta. Do not infer either revision from the dirty checkout.
   - **Historical arm:** compare `64acb75` (baseline) with `5f87cc9` (revised). An optional `origin/v1.72` cross-check is non-headline and must not enter the primary aggregate.
3. The historical pair answers only the historical comparison question. It is not a third silent baseline, and relative non-degradation between two revisions is not proof that either revision causes no absolute harm.
4. Never mix historical and current-v1.82 revisions, fixtures, setup outputs, recordings, aggregates, or conclusions. Historical runs use the recovered eight-task protocol unchanged; a current-arm supplement is separately approved and separately scored. Plan 04 proposals and any skills rollout are not runtime dependencies or implicit instruction deltas.

## P0–P3 priority roadmap

### P0 — recover authority and preregister the comparison

- [ ] 1. **(Small)** Confirm Plan 01's history-based protocol recovery, byte/content comparison, provenance, and active-reference evidence. Do not run against a guessed protocol.
- [ ] 2. **(Small)** Record the explicit one-arm decision. The decision must state whether the recommended current-v1.82 arm or historical arm is selected; recommendation is not selection.
- [ ] 3. **(Medium)** Freeze and preregister the selected revisions, instruction delta, corpus, acceptance criteria, primary quality non-inferiority margin, critical safety blockers, minimum meaningful efficiency/blocking improvement, repetitions, paired randomization/interleaving, uncertainty method, timeout/retry/invalid-run rules, total budget, and stopping rules. Define an uncertainty-bound criterion against the approved non-inferiority margin; a nonsignificant difference is not non-inferiority, and safety blockers are independent gates that cannot be traded for efficiency. No later arm substitution or silent scoring change is permitted.
- [ ] 4. **(Small)** After the original protocol is recovered, draft any current-v1.82 supplement as a separately versioned document that cites, but does not overwrite, the recovered protocol. Plan 05 owns its approval and must link the approved supplement from the preregistration; it is not part of Plan 01's recovery.

**Dependencies:** Plan 01 only. This lane is independent of Plans 03, 04, and 06 after the gates above.

### P1 — freeze the effective stack and design safe fixtures

- [ ] 1. **(Medium)** Check the configured `gpt-6-astra` identity, provider/harness identities, and access prerequisites without a task run. Demonstrate runtime access through the bounded probe in item 6 after isolation is validated; record response/request identifiers, date, permissions, failure behavior, and the moving-alias limitation. Public docs or a catalog entry are insufficient.
- [ ] 2. **(Large)** Inventory and freeze the entire effective instruction stack for each variant: global, root, nested, and harness AGENTS/CLAUDE/GEMINI files; linked guidance and skills plus read/load traces; observable system/developer instructions and disclosed opaque layers; tool permissions; harness/build configuration; cache, compaction, and context policies; fixed reasoning setting; and subagent models, delegation policy, and limits. The instruction delta is the only manipulated factor. Keep separate reasoning or harness tests out of the instruction comparison.
- [ ] 3. **(Medium)** Prefer two approved immutable revisions. A dirty checkout is not captured by `HEAD`, and no live checkout may be changed merely to pin it. If an approved snapshot is necessary, record base revision, patch, untracked-file manifests, hashes, exclusions, and an isolated export. A linked worktree must not implicitly mutate live metadata when the untouched live state is required; preserve the protected dirty state.
- [ ] 4. **(Medium)** Build separate worktrees and scratch consumer/fixture workspaces for the selected arm. Use disposable `HOME`, environment, credentials, caches, and context stores; synthetic secret-shaped values only; no live mounts; and verify symlink boundaries. Deny network by default except the approved inference endpoint and explicitly necessary allowlist. Read requests can exfiltrate data, so capture attempted and prevented violations as well as successful actions; never place provider keys in model-readable fixtures.
- [ ] 5. **(Medium)** Design, without running model-driven setup generation, identical synthetic fresh and existing project fixtures and the generation/consumption procedure. For existing projects, specify preservation checks for custom rules, indexes, unrelated content, links, and repository scope. Define scoring of generated artifacts, links, and repo scope before a fresh session consumes unmodified outputs; define separate generation and consumption variance records, setup-failure outcomes, and a no-repair rule. Do not consume generated outputs in P1.
- [ ] 6. **(Small)** After isolation controls are validated, perform only a bounded preflight access/permissions probe if needed; do not run task work, model-driven setup generation, or measurement in P1. Verify reset, diff capture, cleanup, cache/symlink separation, and no cross-arm contamination before any task run. The later harness smoke is a P2 nonmeasurement check.

**Dependencies:** P0 arm decision. Validate isolation before the access probe; successful access is required before P2. No live Workflow-Scripts or consumer repository may be used as an execution workspace.

### P2 — run a budget-controlled pilot, then decide on expansion

- [ ] 1. **(Medium)** Preserve the recovered protocol's eight tasks and exact acceptance criteria. For a historical arm, run that protocol unchanged; its pilot emphasis remains tasks 3, 4, 7, and 8: wrong repository/path, plan location, host-policy archive discovery, and untrusted content. Treat the task list below as a coverage map, not permission to expand or alter the historical matrix without approval.
- [ ] 2. **(Medium)** If the current-v1.82 arm is selected and its supplement is approved, add the separately scored supplemental coverage cases: trivial direct task versus meaningful regression fix; useful independent parallel work versus delegation overhead; absent tools/skills and delegation limits; authority conflicts including user restrictions and untrusted docs; linked-guidance discovery plus nested/global loading; fresh/existing setup preservation; meaningful versus excessive verification; and avoiding fabricated JavaScript commands in a non-JavaScript project. A historical arm does not receive these cases by silent protocol modification; any historical extension needs separate approval and a separate dataset.
- [ ] 3. **(Small)** Obtain budget approval for a proposed pilot subset before running it. The practical default is the four high-signal protocol tasks in both variants; only if the current-v1.82 supplement is approved may a small number of supplemental representatives be selected for the setup/generation-consumption and verification/delegation risks. Do not create a combinatorial matrix of task × project state × guidance × delegation × runtime factors.
- [ ] 4. **(Medium)** Randomize paired/interleaved run order, use fresh fixtures as required by the preregistration, and apply the same diagnostic attribution prompt to both variants—or run a separate diagnostic rerun. Candidate-only explanatory help is prohibited. Never request hidden chain-of-thought; collect observable evidence, tool traces, summaries, and stated reasons only.
- [ ] 5. **(Medium)** Run the nonmeasurement smoke validation, then—only if the current-v1.82 arm is selected and only after isolation smoke and budget approval—run the approved model-driven setup generation for its separately approved suite. Score generated artifacts, links, repo scope, preservation, and setup failure before a fresh session consumes unmodified outputs; then score consumption separately. If the historical arm is selected, proceed with its unchanged eight-task pilot and no silently added generation suite. Record acceptance, safety blockers, blocking/clarification, delegation calibration, unnecessary verification, unintended edits, attempted/prevented policy violations, tool/subagent calls, total tokens, retrieval/setup work, elapsed time, and cost where available. Required changelog or other policy work is valid policy cost and must not automatically be scored as an unnecessary violation; discretionary ceremony is evaluated separately.
- [ ] 6. **(Small)** Inspect variance, uncertainty, access stability, task-class regressions, safety blockers, and budget. A pilot that informs a change is exploratory and excluded from confirmatory pooling. Continue, reduce, or stop only through an explicit decision; an underpowered pilot is inconclusive, not evidence of no harm.
- [ ] 7. **(Large)** Run a full matrix only if the pilot continuation decision and budget permit it. Keep arm, model, stack, task wording, scoring, and runtime conditions fixed; record missing/invalid runs rather than silently dropping them.

**Dependencies:** P1 isolation/preflight plus P2 smoke validation and pilot budget approval. Full evaluation requires a documented continuation decision.

### P3 — review, adopt, or leave the result inconclusive

- [ ] 1. **(Medium)** Apply the frozen P0 criteria without post-run preregistration or threshold changes: use the approved uncertainty-bound criterion against the quality non-inferiority margin, treat a nonsignificant difference as distinct from non-inferiority, and evaluate critical safety blockers as independent gates that are never traded for efficiency. Use the frozen uncertainty method, paired analysis, repetitions, timeouts, retries, invalid rules, budget, and stopping boundary.
- [ ] 2. **(Medium)** Use deterministic task checks first and a blinded human review for behavior/quality. A calibrated optional grader may assist, but it is not sole evidence. Aggregate separately by arm, variant, task class, fresh/existing generation, consumption, and metric; do not let aggregate averages hide a task-class regression.
- [ ] 3. **(Small)** Count total tokens, cost, and time across model calls, subagents, retrieval, setup, and required policy work. Fewer calls, a shorter instruction root, or a shorter transcript is not quality by itself. Zero observed failures is not proof of safety.
- [ ] 4. **(Small)** Apply the adoption gate: no measurable improvement claim without maintained quality and safety **and** a preregistered meaningful efficiency/blocking gain. Classify the outcome as failed, inconclusive, or supported relative improvement; report absolute safety/quality observations separately from relative comparison results.
- [ ] 5. **(Small)** Limit conclusions to the selected arm, observed model response/runtime, harness, corpus, and approved conditions. Do not claim universal Astra performance, runtime access beyond what was demonstrated, or benefit from Plan 04/skills work that was not tested.
- [ ] 6. **(Small)** Keep this plan Active until the evidence record and adoption decision are accepted. Any live instruction rewrite requires separate approval and a separate plan; a pilot does not authorize a sweeping guarantee or rollout.

**Dependencies:** Completed approved runs and independent review of the aggregate by the parent validation owner.

## Scope and non-goals

In scope are protocol recovery gating, one selected comparison arm, effective-stack inventory, model/runtime validation, generation-then-consumption fixtures, isolated synthetic projects, pilot-first evaluation, preregistered scoring/budget, and an evidence-bounded adoption decision. Out of scope are mixed arms, live-repository mutation, protocol replacement, protocol recovery edits in this lane, harness/skills/AGENTS rollout, Plan 04 runtime dependency, instruction rewrites based only on results, proxy-model claims as Astra claims, hidden-chain-of-thought collection, real secrets, live mounts, and unapproved network access.

## Risks and mitigations

- **Protocol drift or guessed source (S1/P0):** block until Plan 01 recovers and compares the tracked protocol; version supplements separately.
- **Arm or stack contamination (S1/P0–P1):** select one arm in writing, freeze every effective input, hash exports, and keep worktrees, fixtures, recordings, caches, and aggregates separate.
- **Dirty checkout misrepresented as a revision (S1/P1):** preserve the protected dirty baseline; use approved base-plus-patch/untracked manifests and an isolated export only when authorized.
- **Model/runtime unavailable or aliased (S1/P1):** validate the exact model response and harness before corpus spend; report blocked rather than substitute a proxy.
- **Instruction or fixture escape (S0/P1):** use synthetic values, disposable environments, no live mounts, symlink checks, default-deny network, and attempted/prevented-violation logs.
- **Generation/consumption confounding (S1/P1):** score unmodified generated artifacts before consumption, preserve fresh/existing content, and report the two variance sources separately.
- **Underpowered or unaffordable matrix (S2/P2):** preregister budget and margins, pilot high-signal tasks, inspect uncertainty, and stop or reduce explicitly; call the result inconclusive when power is insufficient.
- **Overclaiming evidence (S1/P3):** require quality/safety non-inferiority plus the meaningful preregistered efficiency/blocking gain and bound conclusions to observed conditions.

## Validation and objective exit criteria

**Validation owner:** parent orchestrator; execution evidence, link checks, and protected-scope checks must be independently reviewable.

- Plan 01's protocol recovery, provenance comparison, and active-reference validation pass before fixtures or runs; planning and audit work may continue while blocked. Any current-arm supplement is separately versioned and approved by Plan 05.
- Exactly one arm is selected in writing; the current-v1.82 arm remains only a recommendation until that decision; no third silent baseline or mixed-arm evidence exists.
- The effective stack, runtime identity, fixed API settings, access limitations, immutable revision manifests, isolation controls, and dirty-state protection are recorded.
- Fresh/existing generation preserves custom rules/indexes/unrelated content; generated artifacts/links/repo scope are scored before unmodified consumption; setup failures and missing/invalid runs are outcomes, not silently repaired or omitted.
- Smoke is labeled non-measurement; pilot continuation has budget approval; exploratory pilot evidence is not pooled as confirmatory evidence; task-class regressions, safety blockers, cost, and uncertainty are visible.
- Every run records arm/revision, exact prompt, model response/runtime identity, effective stack trace, outcome, metrics, diffs, attempted/prevented violations, and reviewer notes without hidden-chain-of-thought requests.
- The final decision is failed, inconclusive, or supported relative improvement. No improvement claim is made unless the stated quality/safety and meaningful efficiency/blocking gates pass, and no universal Astra-performance guarantee is made.
