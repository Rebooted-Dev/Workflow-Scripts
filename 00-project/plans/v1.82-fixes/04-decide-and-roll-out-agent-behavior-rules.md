# 2026-09-22 16:37

# Decide and Roll Out Agent Behavior Rules

**Status:** Active — decision-first and approval-gated; no rollout authorized

**Summary:** Treat the raw `update-agents-files.md` material as input, not policy. Inventory target repositories and inheritance, map each rule to adopt/adapt/reject with evidence, and only then seek approval for a smallest representative pilot. The Visualize mandate is conditional on installation and material usefulness; approval, verification, untrusted-content safeguards, and consumer-project UI restrictions remain mandatory boundaries.

## Source and review provenance

- Raw source material: [`update-agents-files.md`](../../research/v1.82-fixes/update-agents-files.md).
- Related workflow context: [`Workflow-Scripts meta guidelines`](../../AGENTS.md) and [`repository map`](../../docs/agents/repository-map.md).
- Advisory review inputs: the two independent read-only reviews and Oracle graph review supplied for this task. Their corrections are incorporated through target/inheritance inventory, per-rule adopt/adapt/reject decisions, conditional Visualize handling, explicit approval, preserved safeguards, representative checks, and rollback.

## Approval gates

1. No rule is propagated from the raw source before the target/inheritance inventory and per-rule mapping are reviewed.
2. No broad rollout is allowed without explicit approval naming the targets, selected rules, and rollback authority.
3. Any consumer-project UI change remains prohibited unless that consumer project's own authorization permits it; the shared rule set cannot override consumer-project restrictions.

## P0–P3 priority roadmap

### P0 — establish decision authority and target scope

- [ ] 1. **(Small)** Confirm the repository/branch/dirty-state baseline and protected external reorganization from the meta roadmap.
- [ ] 2. **(Medium)** Inventory every proposed target, owner, inheritance source, current agent-file location, active branch, consumer-project policy, and collision/precedence concern before editing anything.
- [ ] 3. **(Small)** Record explicit approval authority, pilot boundary, prohibited targets, and rollback owner. Keep the lane blocked until the inventory is reviewable.

**Dependencies:** Meta safety baseline. No dependency on Plans 02, 03, 05, or 06 for the decision analysis itself.

### P1 — map and decide each raw rule

- [ ] 1. **(Medium)** Create a table for all ten raw rules with evidence, target scope, inheritance behavior, and one decision: adopt, adapt, or reject. Do not copy the source list verbatim into target files.
- [ ] 2. **(Medium)** For the Visualize rule, test whether the relevant skill is installed and materially useful for the task/runtime; adopt only a conditional instruction such as “use when installed and materially useful,” otherwise adapt or reject with evidence.
- [ ] 3. **(Medium)** Preserve approval/authorization boundaries, verification-before-claiming-completion, untrusted-content resistance, protected-dirty-work handling, and consumer-project UI restrictions in every adopted/adapted mapping.
- [ ] 4. **(Small)** Identify collisions with existing target instructions and choose a single inheritance/precedence result per target; unresolved collisions block rollout.

**Dependencies:** P0 inventory. Decisions must be recorded before any pilot write.

### P2 — representative checks and smallest approved pilot

- [ ] 1. **(Medium)** Define representative task checks for each adopted/adapted rule, including an approval-required task, a verification/blocked task, untrusted repository content, protected unrelated changes, and a consumer task where UI restrictions must hold.
- [ ] 2. **(Small)** Obtain explicit approval for a smallest project-scoped pilot. The approval must identify exact files/targets, test tasks, write boundary, and rollback trigger.
- [ ] 3. **(Medium)** If approved, run only that pilot and compare behavior against the pre-pilot baseline. Do not silently expand to sibling repositories or global configuration.
- [ ] 4. **(Small)** Roll back the pilot on unauthorized writes, false completion claims, safeguard regression, rule collision, or consumer UI-policy violation; preserve evidence for the decision record.

**Dependencies:** P1 mapping plus explicit pilot approval. A rejected or unapproved pilot is a valid decision outcome.

### P3 — broad rollout only after a separate decision

- [ ] 1. **(Medium)** Review pilot evidence and decide per rule whether to retain, revise, reject, or revert.
- [ ] 2. **(Medium)** Seek a second explicit approval for any broad rollout; approval must name target set, exact changes, validation, and rollback.
- [ ] 3. **(Small)** If broad approval is absent, leave the rules as a recommendation and do not edit target or consumer files.

**Dependencies:** Pilot evidence, or a documented reason the pilot was not approved. No automatic rollout follows from this plan.

## Scope and non-goals

In scope are inventory, inheritance/precedence analysis, per-rule decisions, conditional Visualize treatment, representative checks, an explicitly approved smallest pilot, and rollback criteria. Out of scope are verbatim propagation, broad rollout without approval, global behavior changes, consumer-project UI work, production code, installer changes, and treating raw research as authoritative policy.

## Risks and mitigations

- **Raw proposal becomes unreviewed global policy (S1/P0):** require per-rule adopt/adapt/reject mapping and explicit target approval.
- **Visualize triggers useless or unavailable behavior (S2/P1):** make it conditional on installation and material usefulness.
- **Safeguards are weakened by simplification (S0/P1):** retain approval, verification, untrusted-content, protected-work, and consumer UI restrictions as acceptance checks.
- **Inheritance collision causes inconsistent behavior (S1/P1):** inventory precedence and block unresolved collisions.
- **Pilot expands into rollout (S1/P2):** exact write boundary, named approval, representative checks, and rollback trigger.

## Validation and objective exit criteria

**Validation owner:** parent orchestrator; pilot evidence must be independently inspectable.

- Target and inheritance inventory covers every proposed target and identifies owners, precedence, and consumer restrictions.
- All ten raw rules have an evidence-backed adopt/adapt/reject decision; Visualize is conditional, not verbatim mandatory.
- Representative checks cover approval, verification, untrusted content, protected unrelated work, and consumer UI restrictions.
- No pilot runs without explicit approval; no broad rollout runs without a second explicit approval.
- A pilot either passes with rollback evidence available or is rejected/rolled back with the reason recorded; no unauthorized target or consumer file is changed.
