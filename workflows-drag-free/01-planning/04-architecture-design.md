---
id: architecture-design
version: 2.0
category: planning
kind: workflow
triggers:
  - "architecture design"
  - "design brief"
  - "adr"
inputs: [goal, repository-root]
outputs: [design-brief, architecture-decision-records]
requires: [metadata-root, code-design, error-handling, observability, security-baseline]
agents: [architecture-reviewer, security-scanner, test-strategist]
prev: [research-and-plan]
next: [plan-review]
skills:
  primary: workflow-plan-review-finalize
  required:
    - workflow-intake-and-routing
    - engineering-quality-gates
    - repo-records-and-filing
  conditional:
    - skill: delegated-agent-orchestration
      when: "design review is split across architecture, security, and test agents"
---

# Workflow: Architecture Design

## Purpose

Design system boundaries, interfaces, data ownership, failure modes, and hard-to-reverse decisions before T2/T3 implementation work begins.

## Skill Hooks

- Use `workflow-intake-and-routing` to confirm the design scope and repository boundaries.
- Use `engineering-quality-gates` to apply code-design, error-handling, observability, and security standards.
- Use `repo-records-and-filing` to file the design brief and ADR references in the project metadata root.
- Use `delegated-agent-orchestration` when architecture, security, and test review should run as separate review lenses.

## When To Use

Use this workflow for:

- T3 greenfield or multi-system work;
- T2 work that introduces a new boundary, integration, storage model, deployment path, or security-sensitive flow;
- any plan where implementation would otherwise choose architecture implicitly.

For small T1 changes, record `N/A` in the plan quality sections instead of running this workflow.

## Outputs

- Design brief under `<metadata-root>/research/` or `<metadata-root>/plans/` as directed by the project map.
- One or more ADRs under `<metadata-root>/decisions/`.
- Review notes or open risks copied into the implementation plan before build starts.

## Steps

1. Define the decision scope: user goal, non-goals, changed boundaries, owners, interfaces, data stores, external dependencies, and deployment target.
2. Read the relevant code, docs, and project map. For greenfield work, read the product brief and target deployment constraints instead.
3. Apply the standards:
   - `../../00-core/standards/code-design.md`
   - `../../00-core/standards/error-handling.md`
   - `../../00-core/standards/observability.md`
   - `../../00-core/standards/security-baseline.md`
4. Draft the design brief:
   - context and constraints;
   - proposed architecture;
   - module/service boundaries;
   - interface contracts;
   - data ownership and migration notes;
   - failure modes and recovery behavior;
   - observability and operational signals;
   - rollout, rollback, and debt budget.
5. File ADRs for hard-to-reverse choices. Each ADR must include status, context, decision, alternatives considered, consequences, and review date.
6. Review the design before implementation. Use `01-plan-review.md` or `06-adversarial-plan-review.md` when the adversarial workflow has been promoted and explicitly selected.
7. Copy accepted design constraints into the implementation plan's T2/T3 quality sections.

## Acceptance Criteria

- A design brief exists or the implementation plan explains why the workflow is not applicable.
- New or changed boundaries have explicit contracts.
- Hard-to-reverse choices have ADRs under `<metadata-root>/decisions/`.
- Error handling, observability, security, rollout/rollback, and debt budget are addressed before build begins.
- Open design risks are either resolved, scheduled, or accepted in the plan.
