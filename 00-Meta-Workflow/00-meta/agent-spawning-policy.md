# Agent Spawning Policy

Use this policy for review and audit workflows that delegate scans to parallel agents.

## Default Rule
- Use 3-6 total agents for a complete review session.
- Start with 2-3 core roles that match the workflow purpose.
- Add triggered specialist roles only when repository evidence justifies them.
- Keep the total session cap at 6 agents.
- If more than 6 roles are justified, split the work into multiple review sessions and reconcile the findings afterward.

## Core Roles
- General code review: correctness, security/safety, and maintainability.
- Optimization review: performance, resource use, and scalability.
- Refactoring review: maintainability, architecture, and testability.
- Security review: authentication/authorization, input handling, and sensitive data exposure.

## Triggered Roles
Add specialist roles for concrete evidence such as:
- UI accessibility or rendering code.
- Database, API, queue, or network-heavy paths.
- Dependency or supply-chain risk.
- Compliance or regulated data handling.
- Complex domain-specific subsystems.

Agents may batch-read files for speed, but the primary reviewer must verify findings directly before including them in the final report.
