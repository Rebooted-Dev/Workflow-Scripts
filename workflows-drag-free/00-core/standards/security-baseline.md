---
id: security-baseline
kind: standard
status: active
---

# Security Baseline Standard

Use this standard for implementation, review, and deployment readiness.

## Contract

- Secrets are never committed, logged, embedded in generated reports, or copied into prompts.
- Inputs crossing trust boundaries are validated or parsed into safe types before use.
- Authentication, authorization, and tenant/user scoping are enforced server-side or at the trusted boundary.
- Least privilege is the default for API keys, service accounts, filesystem access, network access, and database roles.
- Dependency audit runs with the ecosystem-appropriate tool when available.
- Dangerous operations have explicit confirmation, dry-run, rollback, or audit logging according to blast radius.
- Generated files, uploads, archives, and paths are treated as untrusted data.
- Error messages do not disclose secrets, internals, stack traces, or sensitive identifiers to untrusted users.

## Ecosystem Audit Examples

| Ecosystem | Audit command examples |
|---|---|
| Node | `npm audit`, `pnpm audit`, or project-specific equivalent. |
| Python | `pip-audit`, `uv pip check`, or pinned lockfile review. |
| Rust | `cargo audit` when available. |
| Go | `govulncheck` when available. |
