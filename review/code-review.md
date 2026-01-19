# Workflow: Code Review

## Purpose
Perform a structured code review that identifies defects, risks, and refactoring opportunities, then file a report in `../../plans/`.

## Inputs
- Repository root.
- Any user-specified focus areas (optional).

## Prioritization Rule
- Score each finding with severity (S0–S3) and priority (P0–P3).
- Present the report ordered by priority (P0 to P3), then severity within each priority.
- Use the shared rubric: `../reference/severity-priority-rubric.md`.

## Steps
1. Scan the codebase using parallel agents. Each agent should read files in parallel batches (read multiple files concurrently, not sequentially):
   - Agent 1: Scan for bugs and software faults (read implementation files in parallel)
   - Agent 2: Scan for security and safety issues (read security-critical files in parallel)
   - Agent 3: Scan for optimization, modularization, and refactoring opportunities (read code files in parallel)
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.
2. For each finding, capture:
   - file path and line reference
   - observed behavior and impact
   - severity (S0–S3) and priority (P0–P3) with rationale
   - suggested fix or mitigation
   - verification step (how to confirm the fix)
3. Group and order findings by priority, then severity.
4. Add a summary with the top P0/P1 risks and recommended next steps.
5. Save the report to `../../plans/` with a timestamped filename.

## Output Requirements
- Report title, date/time, scope, and summary.
- Findings with evidence and actionable fixes.
- No unverified claims or assumptions.
- Avoid "laundry list" refactors: only recommend refactors/optimizations when they are clearly tied to a defect, a measurable pain point, or they materially reduce P0/P1 risk.

## Acceptance Criteria
- Every item includes a file/line reference, evidence, and rationale.
- Items are ordered by priority (P0 to P3) and severity within each priority.
- Severity and priority are consistent and justified per the rubric.
- The report is self-contained and reproducible.

## Notes
- Use parallel agents to accelerate scanning, but verify findings directly.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Do not modify source code in this workflow.
