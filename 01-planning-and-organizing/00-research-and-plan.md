# Workflow: Research and Create Implementation Plan

## Purpose
Conduct deep research and analysis to create a comprehensive initial implementation plan from a goal, problem statement, or feature request. This is the **starting point** for any significant work - use this before other planning workflows.

## When to Use This Workflow

**Use this workflow when:**
- You have a goal or problem statement but no detailed plan yet
- You need to research approaches before committing to a solution
- You're starting a new feature, refactor, or significant change
- You need to understand the current codebase state and how it relates to your goal
- You need to research external libraries, APIs, or patterns

**Use [`01-plan-review.md`](./01-plan-review.md) instead when:**
- You already have a draft plan document that needs review

**Use [`02-finalise-plan.md`](./02-finalise-plan.md) instead when:**
- You have an existing plan + review feedback to consolidate

## Inputs

- **Goal or problem statement** (user-supplied) - What you want to achieve or solve
- **Repository root** - The codebase to analyze
- **Context** (optional) - Constraints, requirements, relevant history
- **External resources** (optional) - Links to libraries, documentation, examples

## Output

- **Research findings document** under `<metadata-root>/research/` using `{report-type}-YYMMDD-HHMM-{model}.md` (see [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md))
- **Initial implementation plan** under `<metadata-root>/plans/YYYY-MM-DD-{plan-name}.md` (or the host's documented filename convention); optionally add a task to `<metadata-root>/plans/TODO.md`. Use `<metadata-root>/build/` only when the host policy explicitly permits it.
- The plan includes: research summary, recommended approach, phases, tasks, risks, and a proportional `## Artifact lifecycle` inventory with the gate-owned terminal filing pair

## Prioritization Rule

- Order plan phases by dependency, then risk; label and order tasks within each phase by priority, P0 to P3.
- Order research findings by priority, P0 to P3, with severity breaking ties.
- Use the shared rubric: [`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)

---

## Phase 1: Deep Research and Discovery

### 1.1 Intake and Goal Clarification

**Understand the objective:**
- Read the goal/problem statement thoroughly
- Identify success criteria: what does "done" look like?
- Note constraints: timeline, budget, technical limitations
- Identify stakeholders and their requirements
- Define scope boundaries: what's in-scope vs out-of-scope?

**Ask clarifying questions if needed:**
- Ask only when an ambiguity could materially change scope, risk, correctness, outcome, or an approval decision.
- Otherwise, record a reasonable assumption in the plan's `## Assumptions` with a confirmation path and continue; revisit it if evidence contradicts it.
- Request explicit approval whenever the action or decision requires it.

### 1.2 Codebase Context Gathering

Size research and any delegation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md). Select only roles that address an identified evidence gap; options include architecture/patterns, dependencies/integrations, tests/verification, and documentation. When roles are used, give them non-overlapping scopes and batch related file reads where practical.

### 1.3 External Research

Use external research when it could change the decision. Size any delegation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md); relevant roles may include library/API comparison, official documentation, or community pitfalls. Do not require parallel roles for routine or local research.

**Research areas:**
- Available libraries/packages that could help
- Industry best practices for this type of feature
- Common pitfalls and how to avoid them
- Alternative approaches with trade-offs

### 1.4 Synthesize Research Findings

Consolidate all research into a structured analysis:

**Current State Summary:**
- Architecture overview
- Existing patterns that could be reused
- Technical constraints or limitations
- Areas that would be affected by the change

**Evidence quality:**
- Use the shared labels in [`review-workflow-core.md` §Evidence Quality](../00-Meta-Workflow/00-meta/review-workflow-core.md#evidence-quality): `observed` (direct local verification), `sourced` (primary source with access date/version), or `hypothesis` (unverified, with the evidence that would verify it).
- Follow that shared contract for evidence freshness. If local research uses a dirty working tree, record `HEAD`, relevant dirty paths including `??` untracked files, and a reproducible content/diff fingerprint; do not identify that observation by the commit SHA alone.
- State what was not checked. For labels at `00-project/plans/v1.82-fixes/05-run-astra-instruction-evaluation.md:15`, map Astra fact → `sourced`; harness-specific → `observed` when directly measured, otherwise `sourced` or `hypothesis`; local observation → `observed`; hypothesis → `hypothesis`; experiment result → `observed` with run evidence. This is a vocabulary mapping only and does not change Plan 05 or authorize agent-file adoption/rollout.

**Change Surface:**
- List each site that implements, restates, guards, or historically records the target behavior.
- Include `file:line`, the search command, and a classification for every hit (`implements`, `restates`, `guards`, or `historical`). Classify examples and archived text rather than treating every match as an active rule.
- Reviewers re-run these searches; confirmation re-runs them after the build. Unexplained stale hits leave the affected task incomplete.

**External Options Analysis:**
- Library options with pros/cons
- Pattern options with trade-offs
- Recommended approach with rationale

**Risk Assessment:**
- Technical risks
- Integration risks
- Performance risks
- Maintenance risks

Use the shared plan contract for tier-specific sections, task fields, and decision structure: [`plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md).

### 1.5 Carry Relevant Open Debt into the Plan

When continuing or replacing an existing plan, read its open **Deferred & Debt** entries during Phase 1. Compare each entry's behavior, location, and trigger with the new plan's Change Surface. Carry forward entries that intersect the Change Surface into the scope, dependencies, or new Deferred & Debt section; identify unrelated open entries as out of scope. A trigger prompts reassessment and scheduling; it does not close debt. Close an entry only after remediation and its acceptance criteria are verified, or an explicit decision to retire it is recorded in the plan (and host tracker when available). Otherwise preserve it as open in the plan and, when one exists, the documented host task tracker.

---

## Phase 2: Plan Development

### 2.1 Define Approach

Based on research, define the recommended approach:

**Decision Record:**
- What approach are you recommending?
- Why is this the best option? (cite research)
- What alternatives did you consider and reject?
- What are the trade-offs?

Follow the options and reversibility requirements in [`plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md).

### 2.2 Break Down Into Phases

Organize work into logical phases:

**Phase Guidelines:**
- Order phases by dependency, then risk; do not use phase numbers as priority labels.
- Label and order tasks within each phase by priority (P0, P1, P2, P3), using the shared rubric.

**Each phase should include:**
- Scope and objectives
- Key tasks with effort estimates (Small/Medium/Large)
- Dependencies (what must happen first)
- Risks and mitigations
- Exit criteria (how to verify phase is complete)

### 2.3 Define Tasks and Sub-Tasks

Use [`plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md) for tiered task syntax, priority labels, and required `Files:` and `Verify:` lines.

### 2.4 Identify Dependencies and Ordering

**Map dependencies:**
- Technical dependencies (e.g., database migration before API changes)
- Logical dependencies (e.g., design before implementation)
- External dependencies (e.g., waiting for API access)

**Create dependency graph:**
- What can be done in parallel?
- What must be done sequentially?
- What's the critical path?

### 2.5 Risk Analysis and Mitigation

**For each identified risk, use the shared [`severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md) scales and mapping:**
- Risk description
- Likelihood (Rare/Possible/Likely)
- Impact (Low/Medium/High)
- Priority, where applicable, from the rubric's Impact × Likelihood mapping
- Mitigation strategy
- Contingency plan

---

## Phase 3: Documentation and Output

### 3.1 Write Research Findings

Create a research document summarizing:

```markdown
# Research Findings: [Goal/Feature Name]

**Date:** YYYY-MM-DD HH:MM

## Executive Summary
- One-paragraph summary of the goal and recommended approach

## Current State Analysis
- Architecture overview
- Existing relevant patterns
- Technical constraints

## External Research
- Libraries/packages evaluated
- Patterns considered
- Community best practices

## Recommended Approach
- What we're doing
- Why this approach
- Trade-offs accepted

## Risk Assessment
- Key risks and mitigations
```

### 3.2 Write Implementation Plan

Create the implementation plan under `<metadata-root>/plans/` per [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md):

**Filename format:** `<metadata-root>/plans/YYYY-MM-DD-{goal-name}-implementation-plan.md` (or the host's explicit convention)

Use the tiered section requirements and scaffold in [`plan-template.md`](../00-Meta-Workflow/00-meta/plan-template.md); do not maintain a separate inline plan template here.

**Initialize the artifact lifecycle.** Give the plan a proportional `## Artifact lifecycle` inventory and exactly one gate-owned terminal filing task with its paired filing Success Criterion, per the shared [Artifact Lifecycle and Terminal Filing](../00-Meta-Workflow/00-meta/plan-template.md#artifact-lifecycle-and-terminal-filing) contract. List the Phase 3.1 research document as the first inventory row; give live/shared records a retained reason. Do not raise the plan's tier or add a manifest file for filing.

**Lint the plan before reporting it.** Run `bash <workflow-scripts>/scripts/validation/check-plan.sh --require-tier <plan>` (path per [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#workflow-scripts-checkout)) and fix every reported line until it prints `OK`. Every task and Success Criteria item must be a checkbox ([Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract)).

### 3.3 Add Planning Complete Marker

When the plan is fully written and ready for review:

```markdown
**Status:** DRAFT - Ready for Review
```

Use the shared [plan-template contract](../00-Meta-Workflow/00-meta/plan-template.md) for the declared tier and required sections.

Or if you want to indicate research is complete but plan is still being written:

```markdown
**Status:** Research Complete ✅ - Plan in Progress
```

---

## Output Requirements

1. **Research Findings Document:**
   - Comprehensive analysis of current state
   - External options evaluated with trade-offs
   - Clear recommended approach with rationale

2. **Implementation Plan in `<metadata-root>/plans/`:**
   - Dated filename per naming conventions
   - Phases ordered by dependency, then risk; tasks within each phase labeled and ordered P0 → P3
   - Tasks with effort estimates
   - Dependencies mapped
   - Risks identified with mitigations
   - Clear acceptance criteria

3. **Both documents must:**
   - Cite actual file paths and references
   - Include no unlabeled claims
   - Be ready for review using `01-plan-review.md`
   - Resolve destinations through [`../00-Meta-Workflow/00-meta/naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md)

---

## Acceptance Criteria

- [ ] Research covers current codebase state thoroughly
- [ ] External options have been evaluated
- [ ] Recommended approach is justified with evidence
- [ ] Plan phases are ordered by dependency, then risk; tasks within each phase carry P0–P3 priority labels and are priority-ordered
- [ ] Each phase has clear scope and exit criteria
- [ ] Tasks have effort estimates (S/M/L)
- [ ] Dependencies are explicitly mapped
- [ ] Risks are identified with mitigations
- [ ] Plan is written to `<metadata-root>/plans/` with dated filename
- [ ] Plan carries a proportional `## Artifact lifecycle` inventory (research document listed) and exactly one gate-owned terminal filing task with its paired criterion
- [ ] `check-plan.sh --require-tier <plan>` was run and prints `OK`; every task and criterion is a checkbox
- [ ] Research findings are documented under `<metadata-root>/research/`
- [ ] No source code was modified (planning only)

---

## Related Workflows

- **[`01-plan-review.md`](./01-plan-review.md)** - Review this plan for correctness and risks
- **[`02-finalise-plan.md`](./02-finalise-plan.md)** - Refine the plan after review feedback
- **[`../02-code-build/01-execution.md`](../02-code-build/01-execution.md)** - Execute the finalized plan
- **[`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)** - Reference for priority scoring

## Notes

- This workflow is the **entry point** for any significant work
- Spend adequate time in Phase 1 (research) - good research prevents bad plans
- Right-size research and any delegation using [`workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md); choose roles from the evidence needs rather than a default roster.
- Don't commit to an approach until research is complete
- The output should be detailed enough that someone else could execute it
- Plans can (and should) be revised as you learn more during implementation
- When in doubt, prefer smaller, verifiable phases over large monolithic phases
