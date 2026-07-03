# Workflow: Bug Fix

## Purpose
Systematically identify, diagnose, and fix bugs using a structured debugging process that prioritizes root cause analysis, verification, and documentation.

## Inputs
- Bug report or issue description (user-supplied).
- Repository root.
- Additional context: error logs, stack traces, screenshots, reproduction steps, affected users/systems.

## Prioritization Rule
- Address bugs in priority order: P0 → P1 → P2 → P3.
- Critical bugs (P0/S0) that cause data loss, security issues, or service outages must be fixed immediately.
- Use the shared rubric: `../00-Meta-Workflow/00-meta/severity-priority-rubric.md`.

## Steps

### 1. Intake and Analysis
- Read the bug report or issue description thoroughly.
- Understand the observed behavior, expected behavior, and reproduction steps.
- Identify affected components, features, and user impact.
- If information is vague or incomplete, ask for clarifying details:
  - Reproduction steps
  - Error messages or logs
  - Screenshots or screen recordings
  - Environment details (browser, OS, version)
  - Frequency of occurrence
- Formulate initial hypotheses about potential root causes.

### 2. Investigation
Use multiple parallel agents to investigate the bug. Suggested agent roles (spawn additional agents as needed):
- Trace the bug through the codebase (read affected files, entry points, and related code in parallel batches)
- Analyze error logs and stack traces (read logging files, error handlers, and exception handling code in parallel batches)
- Check for similar bugs or related issues in the codebase (read similar patterns/files in parallel batches)
- Review recent changes that might have introduced the bug (read git history, recent commits, and related files in parallel batches)
  - Review `plans-completed/` directory for similar past issues and their resolutions
- Examine data flow and state management around the bug (read data processing, state files, and API handlers in parallel batches)


**When to spawn additional agents:**
- Spawn 1 performance agent if bug causes slow operations, memory leaks, or resource exhaustion
- Spawn 1 security agent if bug exposes sensitive data, bypasses authentication, or creates vulnerabilities
- Spawn 1 pattern analysis agent if similar code patterns found in 5+ files that may have the same bug
- Spawn 1 integration agent per external service/API affected by the bug (database, third-party services)
- Spawn 1 test coverage agent if bug reveals untested critical paths or missing edge case tests

**Maximum recommended:** 3-5 additional agents to avoid coordination overhead
Agents should batch read files concurrently to maximize investigation speed.

### 3. Root Cause Identification
- Determine the exact cause of the bug.
- Identify why the bug occurs (logic error, race condition, data issue, etc.).
- Document the reproduction path and conditions that trigger the bug.
- Assess the full scope of impact (affected users, data, features, systems).
- Classify the bug using severity (S0–S3) and priority (P0–P3) per the rubric.

### 4. Fix Planning
Create a detailed fix plan:
- Root cause explanation
- Proposed fix approach with rationale
- Testing strategy to verify the fix
- Regression testing to ensure no new bugs are introduced
- Rollback plan if the fix causes issues
- Consider edge cases and similar code that might need updates

### 5. Implementation
Use multiple parallel agents to implement the fix. Suggested agent roles (spawn additional agents as needed):
- Implement the primary bug fix
- **Add a regression test when it fits** – Add or update tests to verify the fix and prevent regression
- Review for unintended side effects or new bugs introduced
- Check for similar issues in related code that should be fixed
- Update related documentation if the fix changes behavior


**When to spawn additional agents:**
- Spawn 1 optimization agent if bug fix reveals performance issues or inefficient algorithms
- Spawn 1 test agent if fix requires 5+ new test cases or complex test scenarios
- Spawn 1 documentation agent if bug fix changes API behavior or user-facing functionality
- Spawn 1 cleanup agent if fixing bug requires refactoring 3+ related files or removing dead code
- Spawn 1 security agent if bug fix involves authentication, authorization, or data validation

**Maximum recommended:** 3-5 additional agents to avoid coordination overhead
Each agent should read related files in parallel batches during implementation.

### 6. Verification
Use parallel agents to verify the fix. Suggested agent roles (spawn additional agents as needed):
- Run the reproduction steps to confirm the bug is fixed
- Run existing tests and check for regressions
- Test edge cases and similar scenarios
- Verify the fix doesn't break other functionality
- Review code changes for quality and adherence to project conventions


**When to spawn additional agents:**
- Spawn 1 performance testing agent if bug fix may impact latency, throughput, or resource usage
- Spawn 1 security validation agent if bug involved authentication, data exposure, or input handling
- Spawn 1 integration testing agent per external system affected (database, API, third-party service)
- Spawn 1 documentation review agent if bug fix changes documented behavior or requires user communication

**Agent Spawning Policy:** Follow `../00-Meta-Workflow/00-meta/agent-spawning-policy.md`: use 3-6 total agents, start with 2-3 core roles, add triggered specialist roles only when evidence justifies them, and split into sessions if more roles are needed.
Run the project verification command from `AGENTS.md`, package scripts, Makefile, or local test docs plus relevant tests. If no command exists, state that explicitly. If failures occur, fix and re-run.

### 7. Documentation
**Update logs (only for completed tasks that change or affect project code). For every completed bug fix, update BOTH changelog and troubleshooting (skip troubleshooting only for truly trivial mechanical fixes with no investigation).**

- **Changelog** (required for every bug fix):
  - Create a new file in `changelog/fixed/` named `YYYY-MM-DD-fixed-<short-title>.md` (see project `changelog/README.md` for template).
  - Add a row at the top of `changelog/index.md` with Date, Type, Title, File.
  - If the project uses a single-file changelog instead of `changelog/`, use that: e.g. `docs/CHANGELOG.md` or `CHANGELOG.md` with a dated line `- YYYY-MM-DD: Bug fix: [bug description]`.
  - Cross-reference relevant entries in `plans-completed/` if the bug relates to a completed plan.
- **Troubleshooting** (required for every bug fix unless truly trivial):
  - Create a new file under `troubleshooting/<category>/` named `YYYY-MM-DD-<category>-<short-title>.md`.
  - Update `troubleshooting/index.md` (add the new entry at the top).
  - Include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons (see project `troubleshooting/README.md`).
  - Reference related entries in `plans-completed/` for historical context if applicable.
- **Update the implementation plan (if applicable):** For task marking, completion markers, and archiving completed plans, follow the single source of truth: **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)**.

### 8. Final Verification
- Run the final project verification command from `AGENTS.md`, package scripts, Makefile, or local test docs to confirm the repo is shippable; if none exists, state that explicitly.
- Perform a smoke test to ensure the fix works in the actual environment.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- Verify the fix addresses the root cause and doesn't introduce new issues.

## Bug Fix Best Practices

### Root Cause Analysis
- Don't just fix symptoms; identify and fix the underlying cause
- Trace the bug through the entire execution path
- Consider edge cases and boundary conditions
- Look for similar patterns that might have the same issue

### Testing
- Write tests that reproduce the bug before fixing it
- **Add a regression test when it fits** – Add regression tests to prevent the bug from recurring
- Test edge cases and similar scenarios
- Verify the fix doesn't break existing functionality
- **Agent file instruction:** Ensure the project's agent files (AGENTS.md, and optionally CLAUDE.md, GEMINI.md) include the line **Bugs: add regression test when it fits.** so that all coding agents (Codex, Cursor, Claude, etc.) add regression tests when fixing bugs. If the line is missing, add it to AGENTS.md (and optionally to CLAUDE.md, GEMINI.md) as part of the fix or in a follow-up. See [00-project-setup/01-setup-project.md](../00-project-setup/01-setup-project.md) Step 1.3 for setup instructions.

### Code Quality
- Make minimal, focused changes that address the root cause
- Follow existing code patterns and conventions
- Add comments explaining why the fix is necessary if it's not obvious
- Consider if the fix should be applied to similar code

### Communication
- If the bug is critical, communicate the fix plan before implementation
- Document the fix clearly for future reference
- Update relevant documentation if behavior changes

## Output Requirements
- Fixed code with bug resolved
- Tests added or updated to verify the fix and prevent regression
- Documentation updated (changelog and troubleshooting entry)
- Verification that fix doesn't introduce new bugs
- Confirmation that functionality works correctly

## Acceptance Criteria
- Bug is completely fixed and verified
- Root cause is identified and addressed
- Tests verify the fix and prevent regression
- No new bugs introduced
- Code builds and passes all tests
- Documentation is updated
- Fix is ready for review and deployment

## Related Workflows

- **[`01-bug-description.md`](./01-bug-description.md)** - Create comprehensive bug reports for complex or persistent bugs
- **[`../02-code-build/01-execution.md`](../02-code-build/01-execution.md)** - Implement bug fixes using execution workflow
- **[`../05-review/01-code-review.md`](../05-review/01-code-review.md)** - Review bug fixes before merging
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** - Create implementation plan for complex bug fixes
- **[`../06-security/02-security-fix.md`](../06-security/02-security-fix.md)** - Fix security-related bugs

## Notes
- Critical bugs (P0/S0) should be fixed immediately; consider temporary mitigation if full fix requires more time.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- If a bug cannot be reproduced, document the investigation steps and ask for more information.
- For intermittent bugs, add logging or monitoring to help diagnose when they occur.
- Consider if the bug indicates a broader architectural issue that should be addressed separately.
- If the fix is complex, break it into smaller, verifiable steps.
