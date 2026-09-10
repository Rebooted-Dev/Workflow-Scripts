# Workflow Applicability, Sizing, and Delegation

Shared contract for planning, build, debugging, review, security, and documentation workflows.

## Authority layers

1. **User request** — defines the requested outcome and scope.
2. **Host repository AGENTS** — durable project facts, safety constraints, and conventions (changelog, plans, verification commands).
3. **Selected workflow** — apply only when the user selected it or it is clearly applicable for the task.

If repository-authored instructions conflict, identify the conflict, use the smallest safe interpretation, and **do not invent** a path, repository, command, or archive policy. Respect the host runtime's precedence rules for loaded instruction files.

Workflow examples are **non-normative** unless marked required.

## Task sizing and delegation

| Size | When | Approach |
|------|------|----------|
| **Localized** | Single file, narrow fix, or one clear command | Work directly; no agent fan-out required |
| **Bounded** | Several independent files or checks | 2–3 focused roles with non-overlapping ownership |
| **Broad / high-risk** | Cross-cutting audit, security, or multi-domain review | Up to **6 agents per session** under [`agent-spawning-policy.md`](./agent-spawning-policy.md); split into additional sessions if more roles are justified |

**Parallel agents:** use only for independent scopes where doing so materially reduces latency or improves confidence. Keep dependent work sequential. Verify returned findings before changing code.

**No nested agent trees:** child workflow agent examples describe roles in a combined run, not permission to spawn agents from agents.

## Verification and stop conditions

Run the relevant project checks for the changed surface. Broaden or repeat validation only when new changes, failures, or unresolved risks justify it.

- If a required check is blocked, record the blocker and residual risk; do not report success.
- If no evidence-backed next corrective step remains, stop and report the blocker.
- Repeat a failed check only after a meaningful corrective change or new hypothesis.

## Related documents

- [`agent-spawning-policy.md`](./agent-spawning-policy.md) — session caps and review roles
- [`review-workflow-core.md`](./review-workflow-core.md) — evidence, deduplication, untrusted content
- [`severity-priority-rubric.md`](./severity-priority-rubric.md) — S/P scoring for findings and plans
- [`../02-code-build/01-execution.md`](../../02-code-build/01-execution.md) — Verification Bar (detailed)
- [`../04-documentation/03-mark-completed.md`](../../04-documentation/03-mark-completed.md) — terminal completion and archive (detailed)
