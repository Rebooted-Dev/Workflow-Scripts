# Workflow: Code Refactoring

## Purpose
Perform a structured analysis to identify code quality issues, technical debt, and refactoring opportunities that improve maintainability, readability, and extensibility, then file a report in `plans/` (project root).

## Inputs
- Repository root.
- Any user-specified focus areas (optional).
- Code quality standards or conventions (optional).

## Prioritization Rule
- Score each finding with severity (S0–S3) and priority (P0–P3).
- Present the report ordered by priority (P0 to P3), then severity within each priority.
- Refactoring opportunities typically map to S2/S3 severity and P2/P3 priority unless they block features or cause defects.
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

## Steps
1. Scan the codebase using parallel agents. Suggested agent roles (spawn additional agents as needed):
   - Scan for code duplication and DRY violations (read implementation files in parallel batches)
   - Scan for architectural issues and design patterns (read module structure, component organization in parallel batches)
   - Scan for maintainability issues (read complex functions, long files, unclear naming in parallel batches)
   - Scan for testability concerns (read tightly coupled code, missing abstractions in parallel batches)
   - Scan for code smells and anti-patterns (read code files for common issues in parallel batches)
   
   **When to spawn additional agents:**
   - Spawn 1 type safety agent if TypeScript `any` types or missing interfaces found in >10 locations
   - Spawn 1 error handling agent if try-catch blocks missing or inconsistent error responses detected
   - Spawn 1 documentation agent if 20%+ of public functions lack JSDoc or inline comments
   - Spawn 1 code style agent if linter disabled or inconsistent formatting across 5+ files
   - Spawn 1 cleanup agent if unused imports/exports in 10+ files or dead code branches identified
   - Spawn 1 domain specialist for architecture-specific refactoring (microservices, event-driven, monolith)
   
   **Maximum recommended:** 3-5 additional agents to avoid coordination overhead
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.

2. For each refactoring finding, capture:
   - file path and line reference
   - current code structure and issue description
   - observed impact on maintainability, readability, or extensibility
   - severity (S0–S3) and priority (P0–P3) with rationale
   - suggested refactoring approach with rationale
   - verification step (how to confirm the refactoring improves code quality)
   - potential risks or breaking changes

3. Group and order findings by priority, then severity. Refactoring opportunities should be prioritized as:
   - P0: Critical refactoring needed to unblock features, fix defects, or prevent security issues
   - P1: High-impact refactoring that significantly improves maintainability or reduces risk
   - P2: Medium-impact refactoring that improves code quality and developer experience
   - P3: Low-impact refactoring or code cleanup that can be deferred

4. Add a summary with:
   - Top P0/P1 refactoring priorities and recommended approach
   - Overall code quality assessment
   - Technical debt summary
   - Recommended refactoring roadmap
   - Dependencies between refactoring items (if any)

5. Save the report to `plans/` (project root) with a dated filename (e.g., `code-refactoring-YYYY-MM-DD-HH-MM.md`).

## Output Requirements
- Report title, date/time, scope, and summary.
- Refactoring findings with evidence and actionable improvements.
- No unverified claims or assumptions.
- Each finding should include:
  - Clear code quality issue description
  - Evidence of the problem (code examples, complexity metrics, or analysis)
  - Impact assessment (maintainability, readability, extensibility, risk)
  - Refactoring approach with rationale and code examples when applicable
  - Testing/verification approach to ensure behavior is preserved
  - Risk assessment for the refactoring

## Refactoring Focus Areas
- Code duplication and DRY violations
- Long functions and files (complexity)
- Poor naming and unclear abstractions
- Tight coupling and low cohesion
- Missing or inappropriate design patterns
- Inconsistent code style and conventions
- Dead code and unused dependencies
- Complex conditional logic
- Error handling patterns
- Test coverage and testability
- Module boundaries and separation of concerns
- Type safety and type definitions

## Acceptance Criteria
- Every item includes a file/line reference, evidence, and rationale.
- Items are ordered by priority (P0 to P3) and severity within each priority.
- Severity and priority are consistent and justified per the rubric.
- Critical refactoring needs (P0/S0-S1) are clearly flagged and prioritized.
- The report is self-contained and reproducible.
- Findings are actionable with specific refactoring guidance.
- Refactoring approaches preserve existing behavior and functionality.

## Notes
- Use parallel agents to accelerate scanning, but verify findings directly.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Do not modify source code in this workflow; only produce the refactoring report.
- Focus on refactoring opportunities that provide clear value (maintainability, risk reduction, feature enablement).
- Avoid recommending refactoring for its own sake; tie recommendations to concrete benefits.
- Consider both local refactoring (within a file/function) and architectural refactoring (across modules).
- For critical findings, provide immediate refactoring steps even if full refactoring requires more time.
