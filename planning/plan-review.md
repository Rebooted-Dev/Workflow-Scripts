# Workflow: Plan Review

## Purpose
Review a user-supplied plan for correctness, risk, feasibility, and completeness. Provide concrete, actionable feedback and append it to the plan document.

## Inputs
- Plan document path (user-supplied).
- Any prior feedback or context referenced by the plan.

## Prioritization Rule
- Order all findings and recommendations by priority, descending urgency/importance: P0, P1, P2, P3.
- Within the same priority, order by severity: S0, S1, S2, S3.
- Use the shared rubric: `../reference/severity-priority-rubric.md`.

## Steps
1. Read the plan end-to-end and list its explicit goals, scope, and assumptions.
2. Use parallel agents to validate each item for technical feasibility and correctness. Each agent should read validation files in parallel batches:
   - Agent 1: Validate API/interface compatibility and availability (read API/interface files in parallel)
   - Agent 2: Check file structure, module dependencies, and imports (read module files in parallel)
   - Agent 3: Verify configuration and environment assumptions (read config files in parallel)
   - Agent 4: Cross-reference with existing patterns and conventions (read pattern files in parallel)
   Consolidate validation results and flag any conflicts or issues.
3. Use parallel agents to identify issues across different domains. Each agent should read code files in parallel batches:
   - Agent 1: Scan for security and safety issues (read security-critical files in parallel)
   - Agent 2: Identify design flaws and architectural concerns (read architecture files in parallel)
   - Agent 3: Detect potential bugs and software faults (read implementation files in parallel)
   - Agent 4: Flag scope creep and over-engineering risks (read feature files in parallel)
   Consolidate findings and identify:
   - design flaws in the plan
   - potential bugs and software faults
   - security and safety issues
   - invalid or unverifiable items
   - scope creep / over-engineering risk (places where the plan proposes more than needed to meet goals)
   - optimization, modularization, and refactoring opportunities (only when evidence supports near-term value)
4. Score notable items with severity and priority (S0–S3, P0–P3) using the rubric.
5. Note missing steps, dependencies, and acceptance criteria.
6. Provide corrective guidance with concrete alternatives or code-level suggestions.
7. Append an addendum to the plan document with a timestamp and model name.

## Output Format (append to plan)
- Header: `YYYY-MM-DD HH:MM - Plan Review (Model: <model-name>)`
- Sections (priority-ordered): P0, P1, P2, P3
- Each item includes: severity, rationale, and an actionable fix.
- Cite file/line references when applicable.

## Acceptance Criteria
- Addendum appended to the same plan file, not a new file.
- Items are sorted by priority (P0 to P3) and severity within each priority.
- Every critique includes evidence or a rationale.
- All suggestions are actionable and measurable.
- Ambiguities and missing steps are explicitly called out.
- Over-engineering checks are explicit:
  - Identify any item whose scope exceeds the stated goal.
  - Recommend a smaller MVP approach when feasible.
  - Push speculative refactors/optimizations to P3 unless they unblock P0/P1 work.

## Notes
- Use parallel agents for scanning files or validating claims when helpful.
- Do not modify source code in this workflow; only update the plan document.
