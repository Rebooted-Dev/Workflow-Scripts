---
name: engineering-quality-gates
description: Apply Workflow-Scripts engineering standards during planning, implementation, code review, security review, and confirmation. Use for T2/T3 plans or any work touching code, architecture, security, observability, or verification.
---

# Engineering Quality Gates

Use this skill to make implementation and review work meet the same engineering bar.

## Required Standards

Load the relevant standards before planning or reviewing implementation work:

- `core/standards/code-design.md`
- `core/standards/error-handling.md`
- `core/standards/observability.md`
- `core/standards/security-baseline.md`
- `core/verification-gates.md`

## Workflow

1. Classify the task tier.
   - T1: narrow and low-risk; keep checks focused.
   - T2: cross-file or user-facing; include explicit design, test, and rollback notes.
   - T3: architecture, security, data, release, or multi-system; include staged verification and reviewer roles.
2. In plans, add quality sections only where they change implementation behavior: design constraints, failure modes, observability, security, verification, and rollback.
3. During implementation, build against the same standards the review workflow will use.
4. During review, cite the standard that each defect or gap violates. Do not file style-only comments as quality-gate failures.
5. When a standard cannot be applied because the archive or repo is incomplete, record that limitation in the verification log.

## Guardrails

- Do not claim a gate passed without an actual command, code pointer, or reviewed artifact.
- Keep T1 workflows lightweight; do not force T3 ceremony onto small changes.
