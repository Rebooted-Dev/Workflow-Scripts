# Workflow: Finalise Plan

## Purpose
Generate a consolidated, improved plan from the supplied plan and feedback, with clear phases, dependencies, and verification steps.

## Inputs
- Primary plan document path (user-supplied).
- Any feedback or review addenda attached to the plan.
- Optional per-agent review reports stored in a sibling review subdirectory:
  - For a plan at `path/to/PLAN.md`, per-agent reports live in `path/to/PLAN.reviews/`
  - Expected file naming pattern: `PLAN.review.<short-model-name>.YYYY-MM-DD-HH-MM.md`

## Prioritization Rule
- Order phases by dependency, then risk; phase numbers do not represent priority.
- Within each phase, label and order tasks by priority, P0, P1, P2, P3.
- Use the shared rubric: `../00-Meta-Workflow/00-meta/severity-priority-rubric.md`.

## Steps
1. Read the plan and all feedback sections; extract goals, constraints, and unresolved issues.
   - If a `PLAN.reviews/` subdirectory exists for the supplied plan:
     - Read all `PLAN.review.*.md` files under that directory.
     - Treat these as additional, parallel review inputs from different agents/models.
2. Size any delegated codebase scan using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md). Relevant roles may include existing-patterns, dependencies/constraints, affected surfaces/integrations, or risk/security review; choose only those needed to resolve evidence gaps. Consolidate findings into a coherent plan that removes duplicates and contradictions.
3. Check dependency and ordering claims against repository evidence. If delegation would materially improve confidence, use focused roles from [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md), such as dependency/data-flow mapping or conflict analysis. Define what must happen before what.
4. Assess feasibility by task and convert scope into a roadmap with phases ordered by dependency, then risk, and tasks within each phase ordered by priority:
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
7. Write the new plan to `<metadata-root>/plans/` with a dated filename per [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md). Use `<metadata-root>/build/` only when the host policy explicitly permits it.
    - Clearly indicate in the new plan’s header that it was consolidated from:
      - The original plan
      - Any inline addenda in the original file
      - Any reports in `PLAN.reviews/` (if present)
    - Use the shared [`../00-Meta-Workflow/00-meta/plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md) for tier-specific sections, Decisions, task fields, and Change Surface requirements.
    - Reference `check-plan.sh` in acceptance criteria; the finalised plan must pass its structural checks.
8. Mark the source plan `**Status:** Superseded by <link>` to the new consolidated plan after that plan is saved.
9. Archive temporary review artifacts after finalisation by default:
   - If a `PLAN.reviews/` subdirectory exists, move it to the adjacent `PLAN.reviews-archive/` directory after confirming the new plan has been saved.
   - Record the archive location in the new plan or changelog entry.
   - Delete the reports only when the user or host policy explicitly directs deletion and the audit trail is no longer needed; if applicable, confirm logging before deletion.

## Output Requirements
- The new plan must begin with a timestamp header: `YYYY-MM-DD HH:MM`.
- Title should describe the plan scope.
- Include a concise summary, phases ordered by dependency then risk, and P0–P3-labeled tasks ordered by priority within each phase.
- If per-agent review reports were found under `PLAN.reviews/`, briefly list:
  - Which models/agents contributed (derived from filenames and/or contents)
  - The review directory path used for consolidation.
- If `PLAN.reviews/` is deleted or archived as part of cleanup, that decision and (if archived) destination should be mentioned in either:
  - The new plan’s header/notes, or
  - The corresponding changelog entry in `<metadata-root>/changelog/`.

## Related Workflows

- **[`01-plan-review.md`](./01-plan-review.md)** - Review plans for correctness before finalizing
- **[`03-plan-review-and-finalise.md`](./03-plan-review-and-finalise.md)** - One-pass orchestrated review followed by finalisation.
- **[`../02-code-build/01-execution.md`](../02-code-build/01-execution.md)** - Execute the finalized plan
- **[`../02-code-build/02-confirm-execution.md`](../02-code-build/02-confirm-execution.md)** - Verify plan completion after execution
- **[`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)** - Reference for priority ordering

## Acceptance Criteria
- Phases are ordered by dependency, then risk; tasks within each phase are labeled and ordered P0 to P3, with explicit rationale.
- Each phase/bucket has clear entry/exit criteria.
- The finalised plan follows [`../00-Meta-Workflow/00-meta/plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md) and passes `check-plan.sh`.
- The source plan is marked `**Status:** Superseded by <link>` to the new plan.
- Dependencies are explicit (e.g., backend proxy before client changes).
- Scope is intentionally bounded:
  - P0/P1 items are concrete, directly supported by evidence, and sized to ship.
  - Larger redesigns are explicitly deferred to P3 unless required for a P0/P1 fix.
  - An enabling refactor is in scope when required to make the planned fix correct and verifiable.
  - Avoid branching architecture decisions without selecting a default path for the current phase.
- No unresolved ambiguity remains about scope or execution order.
- When a `PLAN.reviews/` subdirectory exists, its contents have been considered in the consolidation, and this is mentioned in the new plan’s header or summary.
- A clear decision has been made about the fate of `PLAN.reviews/`:
  - Either it is removed after consolidation, or
  - It is archived and the archive location is recorded for future reference.

## Notes
- Prefer the smallest viable change that satisfies the objective and verification step.
- Size any codebase scanning or feasibility delegation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md); use focused roles only when they materially improve confidence.
- When agents are used, batch related file reads where practical.
- Do not modify application code in this workflow; only produce the plan.
