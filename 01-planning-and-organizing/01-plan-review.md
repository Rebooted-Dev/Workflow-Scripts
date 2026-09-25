# Workflow: Plan Review

## Purpose
Review a user-supplied plan for correctness, risk, feasibility, and completeness. Provide concrete, actionable feedback and append it to the plan document.

## Inputs
- Plan document path (user-supplied). Plan paths are typically under `<metadata-root>/plans/` (or host-optional `<metadata-root>/build/` when the host policy permits it). Resolve via [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md).
- Any prior feedback or context referenced by the plan.

## Prioritization Rule
- Order all findings and recommendations by priority, descending urgency/importance: P0, P1, P2, P3.
- Within the same priority, order by severity: S0, S1, S2, S3.
- Use the shared rubric: [`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md).

## Steps
1. Read the plan end-to-end and list its explicit goals, scope, and assumptions.
2. Size any delegated validation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md). Select only the roles needed to check plan claims; options include API/interface compatibility, structure/dependencies, configuration/environment, existing patterns, and tests/integration. Give roles non-overlapping read-only scopes, then consolidate results and flag conflicts.
3. Apply the same sizing guidance to review concerns. Relevant lenses may include security/safety, architecture/design, defects, scope/over-engineering, performance, accessibility, domain constraints, and compliance; assess what applies without requiring a separate agent for every lens. Consolidate findings and identify:
   - design flaws in the plan
   - potential bugs and software faults
   - security and safety issues
   - invalid or unverifiable items
   - scope creep / over-engineering risk (places where the plan proposes more than needed to meet goals)
   - optimization, modularization, and refactoring opportunities (only when evidence supports near-term value)
4. Score notable items with severity and priority (S0–S3, P0–P3) using the rubric.
5. Note missing steps, dependencies, and acceptance criteria.
6. Provide corrective guidance with concrete alternatives or code-level suggestions.
7. Append an addendum to the plan document with a dated header and model name (see **Concurrency & Multi-Model Usage** when multiple agents/models are involved).

## Concurrency & Multi-Model Usage

- **Single writer per plan file (recommended for orchestrated runs):**
  - Use one orchestrator agent per plan file.
  - Helper agents (including different models) run in read-only mode and return findings to the orchestrator.
  - The orchestrator is the **only** agent that writes to the plan file, appending a single consolidated addendum.

- **Multiple independent agents/models (recommended pattern for safety):**
  - **Do not** have multiple agents all edit the same plan file concurrently.
  - For a plan at `path/to/PLAN.md`, create (if needed) a sibling review subdirectory:
    - `path/to/PLAN.reviews/`
  - Each agent writes its own report into that subdirectory, using this naming pattern:
    - `PLAN.review.<short-model-name>.YYYY-MM-DD-HH-MM.md`
    - Example: `2026-03-02-consolidated-refactoring-implementation-plan.review.gpt-5.1.2026-03-02-20-15.md`
  - Later, use `02-finalise-plan.md` (or a dedicated consolidation pass) to:
    - Read `PLAN.md` and all files under `PLAN.reviews/`
    - Produce the next-version plan in `<metadata-root>/plans/` (or as directed by host policy; see [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md)) that integrates all reviews.

- **Running multiple models via an orchestrator (mixed pattern):**
  - Orchestrator still uses the single-writer rule.
  - It may optionally:
    - Append a single consolidated addendum directly to `PLAN.md`, **and/or**
    - Save per-model sub-reports into `PLAN.reviews/` using the same naming pattern for traceability.

## Output Format (append to plan)
- Header (per addendum, at the top of the appended block):
  - `YYYY-MM-DD HH:MM (local time, 24h) - Plan Review (Model: <model-name>)`
- Recommended when grouping multiple models in one addendum:
  - Add sub-headings per model, for example: `### Model: <model-name>` under the main header.
- Sections (priority-ordered): P0, P1, P2, P3
- Each item must include:
  - **Severity** (S0–S3): Impact level if the issue ships
  - **Priority** (P0–P3): Urgency to fix based on severity × likelihood
  - **Rationale**: Evidence or reasoning for the score
  - **Actionable fix**: Concrete, measurable correction
- Include both severity AND priority labels for every finding (for example, "S2/P1").
- Cite file/line references when applicable.

## Acceptance Criteria
- Addendum appended to the same plan file, not a new file, **or** stored in per-model review files under a `PLAN.reviews/` subdirectory (following the documented naming pattern) and then merged back into the plan in a follow-up step.
- Items are sorted by priority (P0 to P3) and severity within each priority.
- Every critique includes evidence or a rationale.
- All suggestions are actionable and measurable.
- Ambiguities and missing steps are explicitly called out.
- Over-engineering checks are explicit:
  - Identify any item whose scope exceeds the stated goal.
  - Recommend a smaller MVP approach when feasible.
  - Push speculative refactors/optimizations to P3 unless they unblock P0/P1 work.

## Notes
- Size any scanning or validation delegation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md); use focused roles only when they materially improve coverage or speed.
- When agents are used, batch related file reads where practical.
- Do not modify source code in this workflow; only update the plan document.

## Related Workflows

- **[`02-finalise-plan.md`](./02-finalise-plan.md)** - Create or refine implementation plans after review
- **[`03-plan-review-and-finalise.md`](./03-plan-review-and-finalise.md)** - One-pass orchestrated review followed by finalisation.
- **[`../02-code-build/01-execution.md`](../02-code-build/01-execution.md)** - Execute plans after they've been reviewed
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review code after implementation
- **[`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)** - Reference for scoring issues
