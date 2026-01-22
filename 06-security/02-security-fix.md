# Workflow: Security Fix

## Purpose
Systematically identify, fix, and verify security vulnerabilities using a security-focused debugging and remediation process.

## Inputs
- Security review report or specific vulnerability report (user-supplied).
- Repository root.
- Any additional context: logs, attack vectors, affected systems.

## Prioritization Rule
- Address security issues in priority order: P0 → P1 → P2 → P3.
- Critical security vulnerabilities (P0/S0) must be fixed immediately.
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

## Steps

### 1. Intake and Analysis
- Read the security review report or vulnerability description.
- Understand the vulnerability type, attack vector, and potential impact.
- Identify affected components, files, and user/data exposure.
- Formulate hypotheses about root cause and exploitation scenarios.

### 2. Investigation
Use multiple parallel agents to investigate the security issue. Each agent should read relevant files in parallel batches (read multiple files concurrently, not sequentially):
- Agent 1: Trace the vulnerability through the codebase (read affected files in parallel)
- Agent 2: Identify all entry points and attack surfaces (read API endpoints, routes, handlers in parallel)
- Agent 3: Check for similar vulnerabilities in related code (read similar patterns/files in parallel)
- Agent 4: Review security controls and existing mitigations (read security middleware, validators in parallel)
- Agent 5: Analyze data flow and sensitive data handling (read data processing files in parallel)
Agents should batch read files concurrently to maximize investigation speed.

### 3. Root Cause Identification
- Determine the exact cause of the vulnerability.
- Identify why existing security controls failed or were missing.
- Document the attack vector and exploitation method.
- Assess the full scope of impact (data, users, systems).

### 4. Remediation Planning
Create a detailed security fix plan:
- Immediate mitigation steps (if needed before full fix)
- Complete fix approach following security best practices
- Defense-in-depth measures to prevent similar issues
- Testing strategy including security testing
- Verification steps to confirm the fix
- Rollback plan if the fix causes issues

### 5. Implementation
Use multiple parallel agents to implement the fix:
- Agent 1: Implement the primary security fix
- Agent 2: Add defense-in-depth measures (input validation, output encoding, etc.)
- Agent 3: Update security tests and add regression tests
- Agent 4: Review for unintended side effects or new vulnerabilities
- Agent 5: Update security documentation and logging
Each agent should read related files in parallel batches during implementation.

### 6. Verification
Use parallel agents to verify the fix:
- Agent 1: Run security tests and verify the vulnerability is closed
- Agent 2: Test for regression (ensure functionality still works)
- Agent 3: Check for similar vulnerabilities in related code
- Agent 4: Verify security controls are properly implemented
- Agent 5: Review code changes for new security issues introduced
Run `npm run build` and relevant tests. If failures occur, fix and re-run.

### 7. Documentation
**Update logs (only for completed tasks that change or affect project code):**
- Update the changelog with a dated entry: `- YYYY-MM-DD: Security fix: [vulnerability description]`.
  - Preferred location: `docs/CHANGELOG.md`
  - Fallback location: `CHANGELOG.md`
- Add a troubleshooting entry (category `security`):
  - Create a new file under `troubleshooting/security/` named `YYYY-MM-DD-security-<short-title>.md`
  - Update `troubleshooting/index.md` (add the new entry at the top)
  - Include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons

### 8. Final Verification
- Run final `npm run build` to confirm the repo is shippable.
- Perform a security smoke test to ensure the fix works.
- Sanity-check for secrets/unintended files before committing (do not commit `.env*` or credentials).
- Verify no sensitive information is exposed in code or logs.

## Security Fix Best Practices

### Authentication & Authorization
- Use strong, industry-standard authentication mechanisms
- Implement proper session management
- Enforce least privilege access control
- Validate permissions on every request

### Input Validation
- Validate and sanitize all user inputs
- Use parameterized queries for database operations
- Implement output encoding to prevent XSS
- Reject invalid input rather than attempting to sanitize

### Secrets Management
- Never hardcode secrets or credentials
- Use secure environment variables or secret management services
- Rotate secrets regularly
- Use strong, unique secrets for each environment

### Dependencies
- Keep dependencies up to date
- Scan for known vulnerabilities
- Remove unused dependencies
- Use dependency pinning and lock files

### Defense in Depth
- Implement multiple layers of security controls
- Fail securely (default deny)
- Use security headers (CSP, HSTS, etc.)
- Implement proper error handling that doesn't leak information

## Output Requirements
- Fixed code with security vulnerability remediated
- Security tests added or updated
- Documentation updated (changelog and troubleshooting entry)
- Verification that fix doesn't introduce new vulnerabilities
- Confirmation that functionality still works correctly

## Acceptance Criteria
- Security vulnerability is completely remediated
- Fix follows security best practices
- Tests verify the fix and prevent regression
- No new security issues introduced
- Code builds and passes all tests
- Documentation is updated
- Fix is ready for review and deployment

## Related Workflows

- **[`01-security-review.md`](./01-security-review.md)** - Identify security vulnerabilities (run this first)
- **[`../03-debug/02-bug-fix-workflow.md`](../03-debug/02-bug-fix-workflow.md)** - Fix non-security bugs
- **[`../02-build-code/01-execution.md`](../02-build-code/01-execution.md)** - Execute security fixes using execution workflow
- **[`../05-review-audit/01-code-review.md`](../05-review-audit/01-code-review.md)** - Review security fixes before merging
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** - Create implementation plan for complex security fixes

## Notes
- Security fixes are time-sensitive; prioritize P0/S0 issues immediately.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Always consider the full attack surface, not just the immediate vulnerability.
- Test fixes thoroughly to ensure they don't break functionality or introduce new vulnerabilities.
- For critical vulnerabilities, consider immediate mitigation (e.g., disabling feature) while implementing full fix.
- Coordinate with security team if vulnerability is already exploited or publicly disclosed.
