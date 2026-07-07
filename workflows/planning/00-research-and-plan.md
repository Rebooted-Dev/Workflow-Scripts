---
id: research-and-plan
version: 2.0
category: planning
kind: workflow
triggers:
  - "research and plan"
  - "create implementation plan"
inputs: [goal, repository-root]
outputs: [research-findings, implementation-plan]
requires: [metadata-root, parallel-agents, code-design, error-handling, observability, security-baseline]
agents: [architecture-reviewer, test-strategist, docs-writer]
prev: []
next: [plan-review]
skills:
  primary: workflow-plan-review-finalize
  required:
    - workflow-intake-and-routing
    - engineering-quality-gates
    - repo-records-and-filing
  conditional:
    - skill: delegated-agent-orchestration
      when: "parallel agents, multi-model review, or role fan-out is used"
---

# Workflow: Research and Create Implementation Plan

## Skill Hooks

- Use primary skill `workflow-plan-review-finalize` for plan shape, evidence discipline, and tracker updates.
- Load required skills `workflow-intake-and-routing`, `engineering-quality-gates`, and `repo-records-and-filing` before creating or updating durable artifacts.
- Load conditional skill `delegated-agent-orchestration` when research is split across helper agents or providers.

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

- **Research findings document** - Analysis of current state, external options, trade-offs
- **Initial implementation plan** in `project/plans/` by default, or another active-plan location only when the project's `plans/README.md` explicitly says so. Use `project/build/` for build artifacts or active plans only when the project map names it. Optionally add a task to `plans/TODO.md`.
- The plan includes: research summary, recommended approach, phases, tasks, risks

## Prioritization Rule

- Organize the implementation plan by priority: P0, P1, P2, P3
- Research findings should identify which items are P0 vs P3
- Use the shared rubric: `../../core/meta/severity-priority-rubric.md`

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
- What is the primary user problem being solved?
- Are there existing solutions to reference?
- What are the must-haves vs nice-to-haves?
- What are the success metrics?

### 1.2 Codebase Context Gathering

Use **multiple parallel agents** to deeply understand the current codebase. Suggested agent roles (spawn additional agents as needed):

- **Architecture agent:** Map the overall system architecture, identify where changes would fit
- **Code patterns agent:** Find existing implementations of similar features or patterns
- **Dependencies agent:** Map current dependencies and identify potential conflicts
- **Data flow agent:** Trace data flow through the system for relevant features
- **Tech stack agent:** Document current technologies, versions, and conventions

**When to spawn additional agents:**
- Spawn 1 API analysis agent if integrating with external services
- Spawn 1 database agent if data model changes are likely
- Spawn 1 UI/UX agent if user interface changes are involved
- Spawn 1 testing agent to understand current test coverage and patterns
- Spawn 1 performance agent if latency/throughput are concerns

**Agents should batch-read files concurrently** to maximize research speed.

### 1.3 External Research

Use **librarian agents** to research external options in parallel:

- **Library research agent:** Find and evaluate relevant libraries/packages
- **Pattern research agent:** Research industry best practices and patterns
- **Documentation agent:** Review official documentation for technologies involved
- **Community agent:** Research common pitfalls and solutions from community sources

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
- Open debt entries in touched areas from `<metadata-root>/debt/`, with paydown or acceptance implications from `../../core/debt-ledger.md`

**External Options Analysis:**
- Library options with pros/cons
- Pattern options with trade-offs
- Recommended approach with rationale

**Risk Assessment:**
- Technical risks
- Integration risks
- Performance risks
- Maintenance risks

---

## Phase 2: Plan Development

### 2.1 Define Approach

Based on research, define the recommended approach:

**Decision Record:**
- What approach are you recommending?
- Why is this the best option? (cite research)
- What alternatives did you consider and reject?
- What are the trade-offs?

### 2.2 Break Down Into Phases

Organize work into logical phases:

**Phase Guidelines:**
- Phase 1 = P0 work (critical path, blockers)
- Phase 2 = P1 work (urgent, high impact)
- Phase 3 = P2 work (important improvements)
- Phase 4 = P3 work (backlog, nice-to-have)

**Each phase should include:**
- Scope and objectives
- Key tasks with effort estimates (Small/Medium/Large)
- Dependencies (what must happen first)
- Risks and mitigations
- Exit criteria (how to verify phase is complete)

### 2.3 Define Tasks and Sub-Tasks

**For each task:**
- Clear description
- Acceptance criteria
- Effort estimate
- Dependencies
- Assigned priority (P0-P3)

**Task structure:**
```markdown
- [ ] Task name (Priority: P0, Effort: Medium)
  - Sub-task 1
  - Sub-task 2
```

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

**For each identified risk:**
- Risk description
- Likelihood (High/Medium/Low)
- Impact (High/Medium/Low)
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

Create the implementation plan in `plans/` directory:

**Filename format:** `plans/YYYY-MM-DD-[goal-name]-implementation-plan.md`

**Plan structure:**

```markdown
# Implementation Plan: [Goal/Feature Name]

**Created:** YYYY-MM-DD HH:MM  
**Status:** DRAFT  
**Goal:** [Brief restatement of goal]

## Research Summary
[Link to or embed research findings]

## Recommended Approach
[High-level description of the solution]

## Implementation Phases

### Phase 1: [Name] (P0 - Critical)
**Scope:** [What's included]  
**Exit Criteria:** [How to verify complete]

- [ ] Task 1 (Effort: Small)
- [ ] Task 2 (Effort: Medium)
  - [ ] Sub-task 2a
  - [ ] Sub-task 2b

### Phase 2: [Name] (P1 - Urgent)
...

### Phase 3: [Name] (P2 - Soon)
...

### Phase 4: [Name] (P3 - Backlog)
...

## Dependencies
- Dependency 1 must complete before Task X
- External API access needed by Phase 2

## Design & Interfaces
[T2/T3: link design brief and ADRs; list new or changed boundaries and contracts. T1: N/A is acceptable.]

## Error-Handling Strategy
[T2/T3: expected failure modes, taxonomy decisions, fallback/retry choices. T1: N/A is acceptable.]

## Test Strategy
[What proves each phase; unit/integration/e2e split; how it runs in CI or local verification.]

## Observability Plan
[What gets logged/measured; how operators know it works and how they see failure.]

## Rollout & Rollback
[How this reaches users; how it comes back out; migration reversibility.]

## Debt Budget
[For T2/T3: if touched areas have open S1 debt, schedule paydown or explicitly accept the risk per `../../core/debt-ledger.md`.]

## Risks and Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Risk 1 | High | High | Mitigation strategy |

## Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```

### 3.3 Add Planning Complete Marker

When the plan is fully written and ready for review:

```markdown
**Status:** DRAFT - Ready for Review ✅
```

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

2. **Implementation Plan in `plans/`:**
   - Timestamped filename
   - Priority-ordered phases (P0 → P3)
   - Tasks with effort estimates
   - Dependencies mapped
   - Risks identified with mitigations
   - Clear acceptance criteria

3. **Both documents must:**
   - Cite actual file paths and references
   - Include no unverified claims
   - Be ready for review using `01-plan-review.md`

---

## Acceptance Criteria

- [ ] Research covers current codebase state thoroughly
- [ ] External options have been evaluated
- [ ] Recommended approach is justified with evidence
- [ ] Plan is organized by priority (P0 to P3)
- [ ] Each phase has clear scope and exit criteria
- [ ] Tasks have effort estimates (S/M/L)
- [ ] Dependencies are explicitly mapped
- [ ] T2/T3 plans include Design & Interfaces, Error-Handling Strategy, Test Strategy, Observability Plan, Rollout & Rollback, and Debt Budget sections
- [ ] Risks are identified with mitigations
- [ ] Plan is written to `plans/` with dated filename
- [ ] Research findings are documented
- [ ] No source code was modified (planning only)

---

## Related Workflows

- **[`01-plan-review.md`](./01-plan-review.md)** - Review this plan for correctness and risks
- **[`02-finalise-plan.md`](./02-finalise-plan.md)** - Refine the plan after review feedback
- **[`../build/01-execution.md`](../build/01-execution.md)** - Execute the finalized plan
- **[`../../core/meta/severity-priority-rubric.md`](../../core/meta/severity-priority-rubric.md)** - Reference for priority scoring

## Notes

- This workflow is the **entry point** for any significant work
- Spend adequate time in Phase 1 (research) - good research prevents bad plans
- Use parallel agents aggressively during research phases
- Don't commit to an approach until research is complete
- The output should be detailed enough that someone else could execute it
- Plans can (and should) be revised as you learn more during implementation
- When in doubt, prefer smaller, verifiable phases over large monolithic phases
