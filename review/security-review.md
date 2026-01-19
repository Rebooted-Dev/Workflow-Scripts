# Workflow: Security Review

## Purpose
Perform a structured security review that identifies vulnerabilities, security risks, and compliance issues, then file a report in `../../plans/`.

## Inputs
- Repository root.
- Any user-specified focus areas (optional).
- Security requirements or compliance standards (optional).

## Prioritization Rule
- Score each finding with severity (S0–S3) and priority (P0–P3).
- Present the report ordered by priority (P0 to P3), then severity within each priority.
- Security issues typically map to S0/S1 severity and P0/P1 priority.
- Use the shared rubric: `../reference/severity-priority-rubric.md`.

## Steps
1. Scan the codebase using parallel agents focused on security. Each agent should read files in parallel batches (read multiple files concurrently, not sequentially):
   - Agent 1: Scan for authentication and authorization vulnerabilities (read auth files, middleware, route handlers in parallel)
   - Agent 2: Scan for input validation and injection risks (read API endpoints, form handlers, data processing files in parallel)
   - Agent 3: Scan for sensitive data exposure and secrets management (read config files, env handling, data storage files in parallel)
   - Agent 4: Scan for dependency vulnerabilities and outdated packages (read package.json, lock files, dependency files in parallel)
   - Agent 5: Scan for cryptographic issues and weak implementations (read encryption, hashing, token files in parallel)
   - Agent 6: Scan for security misconfigurations and exposed endpoints (read server config, API definitions, deployment files in parallel)
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.

2. For each security finding, capture:
   - file path and line reference
   - vulnerability type (OWASP Top 10 category, CWE, or custom classification)
   - observed behavior and security impact
   - attack vector and exploitability
   - affected users/data and potential damage
   - severity (S0–S3) and priority (P0–P3) with rationale
   - suggested fix or mitigation with security best practices
   - verification step (how to confirm the fix and test for regression)
   - references to security standards or guidelines (if applicable)

3. Group and order findings by priority, then severity. Security issues should be prioritized as:
   - P0: Critical vulnerabilities (S0) - active exploits, data breaches, authentication bypass
   - P1: High-risk vulnerabilities (S0-S1) - easily exploitable, wide impact
   - P2: Medium-risk issues (S1-S2) - requires specific conditions, limited impact
   - P3: Low-risk issues (S2-S3) - informational, best practice improvements

4. Add a summary with:
   - Top P0/P1 security risks and immediate action items
   - Overall security posture assessment
   - Compliance gaps (if applicable)
   - Recommended security hardening measures
   - Timeline for addressing critical issues

5. Save the report to `../../plans/` with a timestamped filename (e.g., `security-review-YYYY-MM-DD-HH-MM.md`).

## Output Requirements
- Report title, date/time, scope, and summary.
- Security findings with evidence and actionable fixes.
- No unverified claims or assumptions.
- Each finding should include:
  - Clear vulnerability description
  - Proof of concept or evidence of exploitability
  - Impact assessment (data, users, system)
  - Remediation steps with code examples when applicable
  - Testing/verification approach

## Security Focus Areas
- Authentication and session management
- Authorization and access control
- Input validation and sanitization
- Output encoding and XSS prevention
- SQL injection and NoSQL injection
- Command injection and code injection
- Insecure deserialization
- Sensitive data exposure (secrets, PII, credentials)
- Insecure dependencies and supply chain risks
- Security misconfigurations
- Insufficient logging and monitoring
- Cryptographic weaknesses
- API security and rate limiting
- CORS and CSRF protection
- File upload security

## Acceptance Criteria
- Every item includes a file/line reference, evidence, and rationale.
- Items are ordered by priority (P0 to P3) and severity within each priority.
- Severity and priority are consistent and justified per the rubric.
- Critical security issues (P0/S0) are clearly flagged and prioritized.
- The report is self-contained and reproducible.
- Findings are actionable with specific remediation guidance.

## Notes
- Use parallel agents to accelerate scanning, but verify findings directly.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Do not modify source code in this workflow; only produce the security review report.
- Consider both code-level vulnerabilities and architectural security issues.
- Reference OWASP Top 10, CWE, and relevant security frameworks when classifying issues.
- For critical findings, provide immediate mitigation steps even if full fix requires more time.
