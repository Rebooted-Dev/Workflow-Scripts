# Workflow: Code Review

## Purpose
Perform a structured code review that identifies defects, risks, and refactoring opportunities, then file a report in `project/build/` (or per the project's `plans/README.md`) and/or add a task to `plans/TODO.md` as needed.

## Inputs
- Repository root (determine using one of):
  - User-specified path
  - Git root: `git rev-parse --show-toplevel`
  - Current working directory if it contains `.git/`
  - Directory containing `config.json` or `package.json`
- Any user-specified focus areas (optional).

If ambiguous:
- Ask user to confirm root directory
- Default to current working directory with warning

## Pre-Flight Validation
Before scanning, verify:
- [ ] Repository root is identified and accessible
- [ ] Rubric file exists at `../00-meta/severity-priority-rubric.md`
- [ ] `project/build/` or `plans/` directory exists (create if needed) and is writable
- [ ] At least one implementation file exists in scope

**Abort conditions:**
- Rubric file missing → Abort with error: "Rubric not found at {path}. Cannot proceed with severity/priority scoring."
- No files in scope → Abort with: "No files found to scan in {scope}."

## Prioritization Rule
- Score each finding with severity (S0–S3) and priority (P0–P3).
- Present the report ordered by priority (P0 to P3), then severity within each priority.
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

**Evidence Requirements (from rubric):**
- **S0/S1 findings MUST include:**
  - Reproduction steps or test case
  - Logs, stack traces, or error messages
  - Affected surface (which users/features impacted)
  - Mitigation or rollback plan
- **S2 findings MUST include:**
  - Reproduction steps or test case
  - Affected module reference
- **S3 findings MUST include:**
  - Code pointer with line reference
  - Rationale for the suggested change

## Steps
1. **Scan the codebase using parallel agents.**

   **File Scope (define based on repository structure):**
   - **Primary targets:** Source code files (e.g., `lib/`, `src/`, `*.sh`, `*.py`, `*.js`)
   - **Secondary targets:** Configuration files (`config.json`, `package.json`)
   - **Exclude:** Test files, generated files, `node_modules/`, `docs/`, `plans/`

   Suggested agent roles (spawn additional agents as needed):
   - Scan for bugs and software faults (read implementation files in parallel batches)
   - Scan for security and safety issues (read security-critical files in parallel batches)
   - Scan for optimization, modularization, and refactoring opportunities (read code files in parallel batches)

   **Agent Spawning Thresholds:**
   - Base: 2-3 agents for standard scan
   - Add performance agent IF: >5 sequential operations found OR profiling data shows >100ms operations
   - Add accessibility agent IF: UI component files detected without ARIA attributes
   - Add test coverage agent IF: Critical paths identified with <80% test coverage
   - Add documentation agent IF: >3 public functions lack docstrings/comments
   - Maximum: 5 agents total; if more needed, split into multiple review sessions

   **When to spawn additional agents:**
   - Spawn 1 performance agent if bottlenecks/slow operations detected in profiling or code analysis
   - Spawn 1 accessibility agent if UI components found without ARIA labels or keyboard navigation
   - Spawn 1 test coverage agent if critical paths lack test coverage (check test files vs implementation)
   - Spawn 1 documentation agent if API endpoints or public functions lack documentation
   - Spawn 1 domain specialist per major subsystem (database, API, UI) if complex issues detected
   - Spawn 1 compliance agent if regulatory requirements (GDPR, HIPAA, SOC2) apply to the codebase

   **Maximum recommended:** 3-5 additional agents to avoid coordination overhead
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.

2. **For each finding, capture using the Finding Template:**

   **Finding Template:**

   | Field | Format | Example |
   |-------|--------|---------|
   | **ID** | `FINDING-{n}` | FINDING-001 |
   | **File** | `path/to/file.ext` (line N) | `lib/update-utils.sh` (line 42) |
   | **Behavior** | What the code does (1-2 sentences) | Function returns exit code 0 even when error occurs |
   | **Impact** | Who/what is affected | Callers cannot detect failures, leading to silent data loss |
   | **Severity** | S0-S3 with rationale | S1 - Major functionality broken, wide user impact |
   | **Priority** | P0-P3 with rationale | P1 - High impact + Possible occurrence = fix before release |
   | **Fix** | Concrete action | Change `return 0` to `return 1` in error handling branch |
   | **Verification** | Reproducible test steps | Run `./test.sh` and verify exit code is 1 on error |

   **Verification Step Quality Criteria:**
   - Must be concrete and reproducible
   - Must include actual command, test, or code to run
   - Must specify expected outcome (pass/fail criteria)
   - Should be automatable where possible

   **Examples:**
   - Bad: "Test the function"
   - Good: "Run `npm test -- auth.test.js` and verify all tests pass"
   - Bad: "Check it works"
   - Good: "Execute `./scripts/verify.sh` and confirm output contains 'OK: 5/5 checks passed'"

3. **Group, deduplicate, and order findings:**

   **Deduplication process:**
   - Group findings by file path and line number range (±5 lines)
   - If same issue found by multiple agents:
     - Keep the finding with HIGHEST severity
     - Merge evidence from all agents
     - Note: "Also detected by: [agent names]"
   - If conflicting severity/priority for same issue:
     - Use the higher severity
     - Document the rationale for the chosen score

   **Handling Cross-File Findings:**

   For issues spanning multiple files (e.g., architectural patterns, repeated bugs):

   1. **Create a primary finding** for the core issue:
      - File: Primary location or "N/A (cross-cutting)"
      - Include list of all affected files
      - Severity based on aggregate impact

   2. **Reference related locations:**
      - "Also affects: `lib/auth.js:23`, `lib/user.js:45`, `lib/api.js:67`"
      - Group under single finding ID

   **Ordering:**
   - Primary sort: Priority (P0 → P1 → P2 → P3)
   - Secondary sort: Severity (S0 → S1 → S2 → S3)
   - Tertiary sort: File path (alphabetical)

4. **Add executive summary:**

   **Summary must include:**
   - **Total findings:** N total (P0: n, P1: n, P2: n, P3: n)
   - **Top P0 risks (list up to 3):**
     - Brief description + file location
     - Immediate action required
   - **Top P1 risks (list up to 5):**
     - Brief description + file location
     - Recommended timeline
   - **Next steps:**
     - Immediate actions (this sprint)
     - Short-term actions (next 2 sprints)
     - Tracking items (backlog)

5. **Save the report to `plans/` (project root) with a dated filename.**

## Output Requirements
- Report title, date/time, scope, and summary.
- Findings with evidence and actionable fixes.
- No unverified claims or assumptions.
- **Refactor Recommendation Criteria:**

  **VALID refactor recommendations (include these):**
  - Fixes an identified defect (S0-S2)
  - Addresses measurable pain point (e.g., "function takes 10s, should take <100ms")
  - Materially reduces P0/P1 risk (with explanation)
  - Eliminates code duplication found in 3+ locations
  - Reduces cyclomatic complexity >15 to <10

  **INVALID "laundry list" items (exclude these):**
  - "Code style doesn't match preferences"
  - "Should use framework X instead of Y" (without demonstrated problem)
  - "Needs more comments" (without identifying what's unclear)
  - "Rename variable for clarity" (subjective, no functional impact)
  - "Add TypeScript types" (unless causing production issues)

## Acceptance Criteria
- Every item includes a file/line reference, evidence, and rationale.
- Items are ordered by priority (P0 to P3) and severity within each priority.
- Severity and priority are consistent and justified per the rubric.
- The report is self-contained and reproducible.
- S0/S1 findings include required evidence (repro steps, logs, affected surface, mitigation).

## Notes
- Use parallel agents to accelerate scanning, but verify findings directly.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Do not modify source code in this workflow.

## Related Workflows

- **[`02-code-optimization.md`](./02-code-optimization.md)** - Performance-focused analysis for bottlenecks and resource issues
- **[`03-code-refactoring.md`](./03-code-refactoring.md)** - Code quality and technical debt analysis
- **[`../06-security/01-security-review.md`](../06-security/01-security-review.md)** - Dedicated security audit

**When to use which workflow:**
- **Use Code Review** for routine pre-merge checks, general code quality, defects, and risks. This workflow includes basic security scanning but is not exhaustive for security.
- **Use Security Review** for dedicated security audits, quarterly security assessments, or when validating security-critical changes (authentication, authorization, data handling).

**Timing guidance:** Run Code Review before every merge. For security-critical changes (auth, data handling, API endpoints), follow this review with Security Review for comprehensive security validation.

- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create implementation plan for review findings
- **[`../00-meta/severity-priority-rubric.md`](../00-meta/severity-priority-rubric.md)** - Reference for severity and priority scoring
