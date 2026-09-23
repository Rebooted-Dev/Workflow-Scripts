# 2026-09-22 16:37

# Decide Skills Adoption and Pilot

**Status:** KIV — deferred by user

**Summary:** Preserve the skills-adoption research as future context only. No inventory, evidence collection, adoption decision, pilot, installation, updater, or rollout work is currently authorized.

## Decision record

**2026-09-22 17:34 — User decision:** Plan 06 is KIV and must not be worked further without a new explicit user request. If reactivated, first reassess the `11-Skills` hold and the current runtime state; do not resume from assumptions in this plan.

## Source and review provenance

- Primary research: [`Workflow Auto-Trigger Skills Proposal`](../../research/v1.82-fixes/2026-07-04-workflow-auto-trigger-skills-proposal.md), including its review addendum and reduced verb-skill recommendation.
- Current skill inventory entry point: [`11-Skills/README.md`](../../../11-Skills/README.md).
- Existing setup context: [`00-project-setup/06-skills-setup.md`](../../../00-project-setup/06-skills-setup.md).
- Advisory review inputs: the two independent read-only reviews and Oracle graph review supplied for this task. Their corrections are incorporated by retaining the installation hold, requiring empirical runtime/ownership evidence, adding negative trigger checks, and bounding any pilot to one project without global or Update-AI-Tools writes.

## Deferred context and reactivation condition

- The existing `11-Skills` hold remains preserved as historical decision context.
- No inventory, runtime evidence collection, adoption decision, pilot, installation, updater, global target, or Update-AI-Tools work is authorized while this plan is KIV.
- Reactivation requires an explicit future user request, followed by a fresh reassessment of the `11-Skills` hold and current runtime state.

## P0–P3 priority roadmap

### P0 — KIV; no work authorized

- No P0 task is authorized while the plan is KIV.

**Dependencies:** An explicit future user request is required before any reactivation assessment. Plan 06 does not block Plans 01–05.

### P1 — deferred future reassessment

- No P1 research or evidence collection is authorized while the plan is KIV.
- If reactivated by an explicit future user request, reassess the current `11-Skills` hold and runtime state before defining any work.

**Dependencies:** The reactivation condition above; no current execution dependency is open.

### P2 — deferred future decision

- No P2 adoption decision or pilot is authorized while the plan is KIV.

**Dependencies:** None until an explicit future user request reactivates the plan.

### P3 — preserve future context

- **(Small)** Retain this research and risk record for a future reassessment; do not expand the verb layer, wrappers, router/framework, manifest, installer, updater, global installation, or Update-AI-Tools integration from this KIV plan.

**Dependencies:** Explicit future user request before any reactivation.

## Scope and non-goals

In scope are preserving the existing research, review provenance, risks, and the KIV decision. Out of scope while KIV are inventory, evidence collection, adoption decisions, pilots, global writes, symlink/copy assessment, Update-AI-Tools changes, installer/updater work, broad skill rollout, new verb wrappers, a reusable router/framework, and consumer-project production changes.

## Future-context risks and mitigations

- **Hold is bypassed by a “small” install (S1/P0):** if reactivated, require explicit approval and keep installation/updater actions blocked by default.
- **Runtime behavior is inferred incorrectly (S1/P1):** if reactivated, use current evidence or disposable probes for links, selection, prune, and uninstall; record unknowns.
- **Negative triggers are untested (S2/P1):** if reactivated, include adjacent-verb, unrelated-project, ambiguous, and missing-root prompts.
- **Pilot leaks into global state (S1/P2):** if reactivated and separately approved, use one named project, an exact write boundary, pre/post hashes, and rollback checks.
- **Proposal scope expands without evidence (S2/P3):** continue deferring wrappers, router, manifest, updater, and verb-layer expansion unless separately authorized.

## Validation and objective exit criteria

**Validation owner:** parent orchestrator.

- The plan status is `KIV — deferred by user`, with the dated decision record intact.
- No inventory, evidence collection, decision, pilot, installation, updater, global write, or Update-AI-Tools change is performed while KIV.
- Reactivation is permitted only after an explicit future user request, followed by reassessment of the `11-Skills` hold and current runtime state.
