# 2026-09-22 16:37

# v1.82 Fixes Roadmap

**Status:** Active roadmap — Plan 02 filed Verified Complete; remaining lanes are active or KIV. P0 safety-baseline tasks 1–2 verified done via archived Plan 01 (`03-mark-completed` pass, 2026-09-27)

**Summary:** Coordinate the v1.82-fixes lanes without duplicating their procedures. Plan 01 source recovery and active-reference repair are Verified Complete on `9714c15`; Plan 05 remains blocked until an explicit comparison-arm decision. Plan 02 is independent, validation-only audit work. Plan 03 is independent after its own discovery and safety gates. Plan 04 is approval-gated. Plan 06 is KIV/deferred by user and is not actionable without a new explicit user request.

> **Cross-reference (2026-09-25):** the archived [planning and build workflow quality plan](../../plans-completed/implementation/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md) reused this roadmap's protected-baseline, single-owner and objective-exit patterns (its Phase 0). Plan 01 repaired the four Astra-plan links on `9714c15`. It adds no lane here and changes no lane's tasks.

## Source and review provenance

- Source set: [`research/v1.82-fixes/`](../../research/v1.82-fixes/), including the completion-chain research, skills proposal, raw agent-rule material, Astra plan, and both harness documents.
- Historical Astra protocol: recovered from `58689d8` and filed at `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md` on commit `9714c15` (Plan 01 Verified Complete).
- Advisory review inputs: the two independent read-only reviews and Oracle graph review supplied for this lane. Their corrections are incorporated as safety baselines, explicit gates, single-writer rules, non-overlapping ownership, and evidence-bounded conclusions; they are not treated as implementation evidence.

## P0–P3 priority roadmap

### P0 — protect the worktree and authorize the graph

- [✅] 1. **(Small)** Re-capture the Workflow-Scripts repository root, current branch, `HEAD`, upstream, and dirty-state inventory before any lane writes. *(Verified: archived Plan 01 P0.1 recorded the baseline — `v1.82`, `HEAD 6a25c36`, full dirty-state inventory — at execution time on `9714c15`.)*
- [✅] 2. **(Small)** Treat the externally made uncommitted reorganization as protected; prohibit reset, clean, checkout, branch switching, history rewriting, or consumer-repository changes. *(Verified: archived Plan 01 P0.2; no destructive operation in any lane record.)*
- [ ] 3. **(Small)** Confirm lane owners and approval authority before any approval-gated or cross-repository action. *(Owners are recorded in the dependency table below; no approval-gated or cross-repository action has occurred yet, so this precondition has not been exercised.)*

**Dependencies:** None. This baseline precedes every executable lane.

### P1 — execute the evidence and validation lanes

- [✅] 1. **(Small)** Execute [Plan 01](../../plans-completed/review/2026-09-22-reconcile-research-and-source-integrity.md) first; it owns source recovery and active-reference integrity (Verified Complete on `9714c15`).
- [✅] 2. **(Small)** Run [Plan 02 audit — filed Verified Complete](../../plans-completed/review/2026-09-22-validate-completion-chain-current-state.md) independently as a read-only validation lane; parent accepted the static evidence, and the prior completion-chain remediation was not re-executed.
  - **Post-audit defect (2026-09-25):** the static audit passed, but consumer use showed verified tasks were never ticked: the gate skipped `Not Eligible` plans, and `02` could only untick. The fix was made on direct developer request as commit `d4407bd`, outside this roadmap's lanes. See [troubleshooting](../../troubleshooting/workflow/2026-09-25-workflow-verified-tasks-never-ticked.md) and [changelog](../../changelog/fixed/2026-09-25-fixed-completion-chain-task-ticking.md).
- [ ] 3. **(Small)** After its own discovery and safety gates, run [Plan 03](./03-run-parallel-agent-harness-concept-test.md) independently.

**Dependencies:** Plan 01 is a prerequisite only for Plan 05, not for Plans 02 or 03.

### P2 — make bounded decisions

- [ ] 1. **(Medium)** After explicit approval, execute [Plan 04](./04-decide-and-roll-out-agent-behavior-rules.md) as a staged behavior-rule decision and pilot lane.
- [ ] 2. **(Medium)** After Plan 01 and an explicit arm decision, execute [Plan 05](./05-run-astra-instruction-evaluation.md); it remains independent of Plans 03, 04, and deferred Plan 06.

**Dependencies:** Plan 04 requires its own approval gate. Plan 06 is KIV and does not block any lane. Plan 05 requires Plan 01 and its arm decision, but not Plans 03, 04, or deferred Plan 06.

### P3 — closeout and separately authorized follow-up

- [ ] 1. **(Small)** Parent orchestrator records each lane's objective exit result, unresolved blocker, or separately approved delta plan.
- [ ] 2. **(Small)** Do not convert this roadmap into an implementation record or completion claim while any active lane remains open.

> **Cross-reference (2026-09-26):** The planning/build quality plan's local Phase A–D SHAs are recorded as Plan 05 arm boundaries only: A `79d6841d708938e126cbc28c207fd1cedbef6ba5`, B `ac53e01dc6db456f658b5814b13e916fb3692ad3`, C `9aad15cf8ab96f16a6af6b9ea2bb795fa44e6ef1`, D `2505cc10fbd053c730fe55091876357c9a4b2f65`. Recording these boundaries does not close any v1.82 roadmap lane; active lanes and their gates remain unchanged.

**Dependencies:** All lane validations and approval decisions must be recorded first.

## Dependency graph and ownership

| Lane | Owner | Gate/dependency | Boundary |
|---|---|---|---|
| Plan 01 | Research/source-integrity executor | P0 safety baseline; first executable lane | Only source recovery, provenance, and active reference repair |
| Plan 02 | Completion-chain validator | Independent after P0 | Read-only audit; defects require a separately approved delta plan |
| Plan 03 | Harness concept-test executor | Fresh tool and isolation discovery | Disposable test workspace; no reusable launcher/framework |
| Plan 04 | Behavior-rule decision owner | Explicit approval before adoption or rollout | Decision-first; no verbatim raw-source propagation |
| Plan 05 | Astra evaluation owner | Plan 01 plus explicit historical/current arm selection | Independent of Plans 03, 04, and 06; no mixed arms |
| Plan 06 | KIV — deferred by user | New explicit user request required for reactivation | No work authorized; reassess 11-Skills hold and runtime state first |
| Parent | Orchestrator | Owns cross-lane validation and final status | Does not duplicate lane implementation detail |

## Scope and non-goals

In scope is sequencing, authorization, protected-scope handling, and objective handoff between the seven linked plans. Out of scope are workflow/code changes, consumer-repository changes, research-input edits, unapproved pilots, commits, pushes, and any reusable framework not explicitly authorized by a lane.

## Risks and mitigations

- **Dirty-state loss (S0/P0):** preserve the observed baseline and fail closed on any unexpected path; never use destructive cleanup.
- **Concurrent ownership (S1/P1):** one owner per lane and explicit gates; parent resolves conflicts before execution.
- **Premature completion claims (S2/P1):** every lane must meet its objective exit criteria; active plans remain active until separately filed as complete.
- **Scope drift (S2/P2):** reject work outside the lane boundary and require a new approved delta plan.

## Validation and objective exit criteria

**Validation owner:** parent orchestrator.

- All seven links resolve from this directory and each linked plan has the required status, priority roadmap, dependencies, scope, risks, validation, and exit criteria.
- The dependency graph explicitly shows Plan 01 → Plan 05, Plan 02 as independent validation-only, Plan 03 as independent after discovery/safety gates, Plan 04 as approval-gated, Plan 06 as KIV/deferred and non-blocking, and Plan 05 independent of Plans 03/04/deferred Plan 06 after Plan 01.
- The baseline and protected-scope rules are acknowledged before any lane execution.
- No lane is reported complete merely because this meta plan is reviewed.
