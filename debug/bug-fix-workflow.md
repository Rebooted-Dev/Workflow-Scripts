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
- Use the shared rubric: `../meta/severity-priority-rubric.md`.

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
Use multiple parallel agents to investigate the bug. Each agent should read relevant files in parallel batches (read multiple files concurrently, not sequentially):
- Agent 1: Trace the bug through the codebase (read affected files, entry points, and related code in parallel)
- Agent 2: Analyze error logs and stack traces (read logging files, error handlers, and exception handling code in parallel)
- Agent 3: Check for similar bugs or related issues in the codebase (read similar patterns/files in parallel)
- Agent 4: Review recent changes that might have introduced the bug (read git history, recent commits, and related files in parallel)
- Agent 5: Examine data flow and state management around the bug (read data processing, state files, and API handlers in parallel)
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
Use multiple parallel agents to implement the fix:
- Agent 1: Implement the primary bug fix
- Agent 2: Add or update tests to verify the fix and prevent regression
- Agent 3: Review for unintended side effects or new bugs introduced
- Agent 4: Check for similar issues in related code that should be fixed
- Agent 5: Update related documentation if the fix changes behavior
Each agent should read related files in parallel batches during implementation.

### 6. Verification
Use parallel agents to verify the fix:
- Agent 1: Run the reproduction steps to confirm the bug is fixed
- Agent 2: Run existing tests and check for regressions
- Agent 3: Test edge cases and similar scenarios
- Agent 4: Verify the fix doesn't break other functionality
- Agent 5: Review code changes for quality and adherence to project conventions
Run `npm run build` and relevant tests. If failures occur, fix and re-run.

### 7. Documentation
- Update `../../CHANGELOG.md` with a timestamped entry: `YYYY-MM-DD HH:MM - Bug fix: [bug description]`.
- Update `../../TROUBLESHOOTING.md` with a timestamped entry using:
  - Problem definition (what the bug was, symptoms)
  - Observation (how it was discovered, reproduction steps)
  - Detection method (user report, automated test, code review, etc.)
  - Precise fix (what was changed and why)
  - Prevention (how to avoid similar bugs in the future)

### 8. Final Verification
- Run final `npm run build` to confirm the repo is shippable.
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
- Add regression tests to prevent the bug from recurring
- Test edge cases and similar scenarios
- Verify the fix doesn't break existing functionality

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
- Documentation updated (CHANGELOG, TROUBLESHOOTING)
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

## Notes
- Critical bugs (P0/S0) should be fixed immediately; consider temporary mitigation if full fix requires more time.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- If a bug cannot be reproduced, document the investigation steps and ask for more information.
- For intermittent bugs, add logging or monitoring to help diagnose when they occur.
- Consider if the bug indicates a broader architectural issue that should be addressed separately.
- If the fix is complex, break it into smaller, verifiable steps.
