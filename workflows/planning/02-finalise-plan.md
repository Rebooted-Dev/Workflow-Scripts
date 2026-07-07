# Workflow: Implementation Plan

## Purpose
Generate a consolidated, improved plan from the supplied plan and feedback, with clear phases, dependencies, and verification steps.

## Inputs
- Primary plan document path (user-supplied).
- Any feedback or review addenda attached to the plan.
- Optional per-agent review reports stored in a sibling review subdirectory:
  - For a plan at `path/to/PLAN.md`, per-agent reports live in `path/to/PLAN.reviews/`
  - Expected file naming pattern: `PLAN.review.<short-model-name>.YYYY-MM-DD-HH-MM.md`

## Prioritization Rule
- Organize the implementation plan by priority, descending urgency/importance: P0, P1, P2, P3.
- If you use phases, phase numbering must follow priority order (Phase 1 = P0 work).
- Use the shared rubric: `../../core/meta/severity-priority-rubric.md`.

## Steps
1. Read the plan and all feedback sections; extract goals, constraints, and unresolved issues.
   - If a `PLAN.reviews/` subdirectory exists for the supplied plan:
     - Read all `PLAN.review.*.md` files under that directory.
     - Treat these as additional, parallel review inputs from different agents/models.
2. Use parallel agents to scan the codebase for context. Suggested agent roles (spawn additional agents as needed):
   - Identify existing implementations or similar patterns (read relevant files in parallel batches)
   - Map dependencies and constraints in the codebase (read dependency files in parallel batches)
   - Find related code that might be affected by the plan (read related files in parallel batches)
   - [Spawn additional agents if you discover other areas that need investigation, such as:
     - Performance implications
     - Security considerations
     - Testing requirements
     - Documentation needs
     - Integration points]
   Consolidate ideas into a single coherent plan that removes duplicates and contradictions.
3. Use parallel agents to validate dependencies and ordering constraints. Suggested agent roles (spawn additional agents as needed):
   - Verify dependency claims against actual code structure (read dependency files in parallel batches)
   - Check for potential conflicts or circular dependencies (read conflicting files in parallel batches)
   - Validate ordering constraints are technically sound (read constraint-related files in parallel batches)
   - [Spawn additional agents if you discover other dependency concerns, such as:
     - Runtime dependencies
     - Build-time dependencies
     - Data flow dependencies
     - External service dependencies]
   Define dependencies and ordering constraints (what must happen before what).
4. Use parallel agents to cross-check technical feasibility of each priority bucket. Suggested agent roles (spawn additional agents as needed):
   - Validate P0/P1 items are technically feasible (read implementation files in parallel batches)
   - Check for existing solutions or patterns that could be reused (read pattern files in parallel batches)
   - Identify potential blockers or risks for each priority level (read risk-related files in parallel batches)
   - [Spawn additional agents if you discover other feasibility concerns, such as:
     - Resource constraints
     - Timeline constraints
     - Skill/team constraints
     - External dependencies]
   Convert scope into a priority-ordered roadmap:
   - P0: blockers, active incidents, security-critical, release-stoppers
   - P1: urgent, high user impact, likely failures
   - P2: important improvements, tech debt paydown with near-term value
   - P3: backlog, nice-to-have, long-term refactors
   Apply the debt budget rule from `../../core/debt-ledger.md`: for T2/T3 plans, open S1 debt in touched areas must be scheduled for paydown or explicitly accepted with rationale.
5. For each priority bucket (or phase), include:
   - scope and objectives
   - key tasks (ordered)
   - dependencies
   - risks and mitigations
   - validation/verification steps and exit criteria
6. Add effort level labels per task (Small/Medium/Large).
7. Write the new plan to the `plans/` directory (project root) with a dated filename.
   - Clearly indicate in the new plan’s header that it was consolidated from:
     - The original plan
     - Any inline addenda in the original file
     - Any reports in `PLAN.reviews/` (if present)
8. Perform post-finalisation cleanup of temporary review artifacts:
   - If a `PLAN.reviews/` subdirectory exists:
     - Decide whether the raw per-agent reports are still needed as an audit trail.
     - If they are **not** needed:
       - Delete the `PLAN.reviews/` directory after confirming the new plan has been saved and, if applicable, logged in `project/changelog/`.
     - If they **are** needed:
       - Optionally archive them (for example, compress or move to an archive directory) and record that location in the new plan or changelog entry.

## Output Requirements
- The new plan must begin with a timestamp header: `YYYY-MM-DD HH:MM`.
- Title should describe the plan scope.
- Include a concise summary and a priority-ordered roadmap.
- If per-agent review reports were found under `PLAN.reviews/`, briefly list:
  - Which models/agents contributed (derived from filenames and/or contents)
  - The review directory path used for consolidation.
- If `PLAN.reviews/` is deleted or archived as part of cleanup, that decision and (if archived) destination should be mentioned in either:
  - The new plan’s header/notes, or
  - The corresponding changelog entry in `project/changelog/`.

## Related Workflows

- **[`01-plan-review.md`](./01-plan-review.md)** - Review plans for correctness before finalizing
- **[`../build/01-execution.md`](../build/01-execution.md)** - Execute the finalized plan
- **[`../build/02-confirm-execution.md`](../build/02-confirm-execution.md)** - Verify plan completion after execution
- **[`../../core/meta/severity-priority-rubric.md`](../../core/meta/severity-priority-rubric.md)** - Reference for priority ordering

## Acceptance Criteria
- Plan is ordered by priority (P0 to P3) with explicit rationale.
- Each phase/bucket has clear entry/exit criteria.
- Dependencies are explicit (e.g., backend proxy before client changes).
- Scope is intentionally bounded:
  - P0/P1 items are concrete, directly supported by evidence, and sized to ship.
  - Larger redesigns are explicitly deferred to P3 unless required for a P0/P1 fix.
  - Avoid branching architecture decisions without selecting a default path for the current phase.
- T2/T3 plans touching areas with open S1 debt either schedule paydown or record explicit risk acceptance per `../../core/debt-ledger.md`.
- No unresolved ambiguity remains about scope or execution order.
- When a `PLAN.reviews/` subdirectory exists, its contents have been considered in the consolidation, and this is mentioned in the new plan’s header or summary.
- A clear decision has been made about the fate of `PLAN.reviews/`:
  - Either it is removed after consolidation, or
  - It is archived and the archive location is recorded for future reference.

## Notes
- Prefer the smallest viable change that satisfies the objective and verification step.
- Use parallel agents to cross-check feasibility or scan codebase references. Spawn additional agents as needed when you discover new concerns or areas that need investigation.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Do not modify application code in this workflow; only produce the plan.
