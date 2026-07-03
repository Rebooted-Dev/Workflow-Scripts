# Security Workflows

This directory contains workflows for security review and vulnerability remediation.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-security-review.md`](./01-security-review.md) | Identify vulnerabilities and security risks | Before releases, periodic audits |
| [`02-security-fix.md`](./02-security-fix.md) | Fix and verify security vulnerabilities | After security review identifies issues |

## Workflow Sequence

```
┌─────────────────────────┐      ┌────────────────────┐
│  01-security-review.md  │ ───▶ │  02-security-fix.md │
│  (Identify issues)      │      │  (Fix issues)       │
└─────────────────────────┘      └────────────────────┘
         │                                │
         ▼                                ▼
   <metadata-root>/research/security-review-*.md    Updated code + troubleshooting entry
```

## Quick Decision Guide

**Do you need to find security vulnerabilities?**
- Yes → Use [`01-security-review.md`](./01-security-review.md)

**Do you have a security review report with issues to fix?**
- Yes → Use [`02-security-fix.md`](./02-security-fix.md)

## Security Focus Areas

Both workflows cover OWASP Top 10 and common vulnerability categories:

- Authentication and session management
- Authorization and access control
- Input validation and injection risks (SQL, XSS, command injection)
- Sensitive data exposure
- Dependency vulnerabilities
- Cryptographic issues
- Security misconfigurations
- API security

## Severity Guidelines for Security Issues

| Severity | Description | Examples |
|----------|-------------|----------|
| **S0** | Critical - Active exploit risk | SQL injection, auth bypass, RCE |
| **S1** | High - Significant vulnerability | Stored XSS, privilege escalation |
| **S2** | Medium - Limited exploit potential | Reflected XSS, info disclosure |
| **S3** | Low - Hardening opportunity | Missing headers, verbose errors |

## Output Locations

- Security review reports: `<metadata-root>/research/security-review-YYMMDD-HHMM-{model}.md`
- Security fix documentation: `<metadata-root>/troubleshooting/security/` + `<metadata-root>/changelog/`
- If no metadata root exists, run `00-project-setup/01-setup-project.md` before filing security artifacts.

## Related Workflows

- [Code Review](../05-review/01-code-review.md) - General review (includes some security)
- [Bug Fix](../03-debugging/02-bug-fix-workflow.md) - For non-security bugs
- [Execution](../02-code-build/01-execution.md) - For implementing security fixes

## Additional Resources

- Security patch in deployment: [`../08-API-Integration/09-nextjs-react-update.md`](../08-API-Integration/09-nextjs-react-update.md) - React/Next.js RCE patch example
