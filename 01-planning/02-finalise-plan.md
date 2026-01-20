# Workflow: Implementation Plan

## Purpose
Generate a consolidated, improved plan from the supplied plan and feedback, with clear phases, dependencies, and verification steps.

## Inputs
- Primary plan document path (user-supplied).
- Any feedback or review addenda attached to the plan.

## Prioritization Rule
- Organize the implementation plan by priority, descending urgency/importance: P0, P1, P2, P3.
- If you use phases, phase numbering must follow priority order (Phase 1 = P0 work).
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

## Steps
1. Read the plan and all feedback sections; extract goals, constraints, and unresolved issues.
2. Use parallel agents to scan the codebase for context. Each agent should read files in parallel batches (read multiple files concurrently, not sequentially):
   - Agent 1: Identify existing implementations or similar patterns (read relevant files in parallel)
   - Agent 2: Map dependencies and constraints in the codebase (read dependency files in parallel)
   - Agent 3: Find related code that might be affected by the plan (read related files in parallel)
   Consolidate ideas into a single coherent plan that removes duplicates and contradictions.
3. Use parallel agents to validate dependencies and ordering constraints. Each agent should read required files in parallel:
   - Agent 1: Verify dependency claims against actual code structure (read dependency files in parallel)
   - Agent 2: Check for potential conflicts or circular dependencies (read conflicting files in parallel)
   - Agent 3: Validate ordering constraints are technically sound (read constraint-related files in parallel)
   Define dependencies and ordering constraints (what must happen before what).
4. Use parallel agents to cross-check technical feasibility of each priority bucket. Each agent should read feasibility-related files in parallel:
   - Agent 1: Validate P0/P1 items are technically feasible (read implementation files in parallel)
   - Agent 2: Check for existing solutions or patterns that could be reused (read pattern files in parallel)
   - Agent 3: Identify potential blockers or risks for each priority level (read risk-related files in parallel)
   Convert scope into a priority-ordered roadmap:
   - P0: blockers, active incidents, security-critical, release-stoppers
   - P1: urgent, high user impact, likely failures
   - P2: important improvements, tech debt paydown with near-term value
   - P3: backlog, nice-to-have, long-term refactors
5. For each priority bucket (or phase), include:
   - scope and objectives
   - key tasks (ordered)
   - dependencies
   - risks and mitigations
   - validation/verification steps and exit criteria
6. Add effort level labels per task (Small/Medium/Large).
7. Write the new plan to the `plans/` directory (project root) with a dated filename.

## Output Requirements
- The new plan must begin with a timestamp header: `YYYY-MM-DD HH:MM`.
- Title should describe the plan scope.
- Include a concise summary and a priority-ordered roadmap.

## Acceptance Criteria
- Plan is ordered by priority (P0 to P3) with explicit rationale.
- Each phase/bucket has clear entry/exit criteria.
- Dependencies are explicit (e.g., backend proxy before client changes).
- Scope is intentionally bounded:
  - P0/P1 items are concrete, directly supported by evidence, and sized to ship.
  - Larger redesigns are explicitly deferred to P3 unless required for a P0/P1 fix.
  - Avoid branching architecture decisions without selecting a default path for the current phase.
- No unresolved ambiguity remains about scope or execution order.

## Notes
- Prefer the smallest viable change that satisfies the objective and verification step.
- Use parallel agents to cross-check feasibility or scan codebase references.
- Do not modify application code in this workflow; only produce the plan.
