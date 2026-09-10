# Code Build Workflows

This directory contains workflows for implementing code changes with verification.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-execution.md`](./01-execution.md) | Execute implementation in phases with verification | Implementing features from a plan |
| [`02-confirm-execution.md`](./02-confirm-execution.md) | Validate that implementation matches the plan | After completing implementation |
| [`03-execute-and-confirm.md`](./03-execute-and-confirm.md) | Run 01 then 02 in one workflow | Execute plan and confirm completion in one go |
| [`04-review-finalise-commit-execute.md`](./04-review-finalise-commit-execute.md) | Review + finalise a plan, commit the planning artifacts, then run 03 | Full plan-to-code pipeline in one workflow |

## Workflow Sequence

```
┌─────────────────────┐      ┌──────────────────────────┐
│  01-execution.md    │ ───▶ │  02-confirm-execution.md │
│  (Implement + verify)│     │  (Audit vs code/evidence)│
└─────────────────────┘      └─────────────┬────────────┘
         │                                  │
         └──▶ 03-execute-and-confirm ───────┘  (01 then 02 in one)
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │ 04-documentation/            │
                    │ 03-mark-completed.md         │
                    │ (TERMINAL GATE — sole        │
                    │  ✅ / marker / archive owner) │
                    └──────────────┬───────────────┘
                  Verified Complete │ Not Eligible
                  (archive via host │ (plan stays active,
                   policy)          no marker / archive)
```

**The terminal gate is mandatory.** Only [`03-mark-completed`](../04-documentation/03-mark-completed.md) applies terminal `✅` task marks, the completion marker, and archive routing (resolved from the host repository's policy). `01` and `02` report verification and may downgrade false claims; they never finalize or archive independently. A `Verified Complete` plan must invoke the gate; a `Not Eligible` plan must not.

## Quick Decision Guide

**Are you implementing changes from a plan?**
- Yes → Use [`01-execution.md`](./01-execution.md)

**Have you finished implementing and need to verify completeness?**
- Yes → Use [`02-confirm-execution.md`](./02-confirm-execution.md)

**Do you want to execute the plan and then confirm in a single workflow?**
- Yes → Use [`03-execute-and-confirm.md`](./03-execute-and-confirm.md)

**Do you want to review and finalise a plan, commit it, then execute and confirm — all in one workflow?**
- Yes → Use [`04-review-finalise-commit-execute.md`](./04-review-finalise-commit-execute.md) (starts from [`../01-planning-and-organizing/03-plan-review-and-finalise.md`](../01-planning-and-organizing/03-plan-review-and-finalise.md))

## Key Concepts

### Task Marking Convention

To keep completion rules consistent across workflows, use the single source of truth:

- **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** — task checkbox conventions (`- [✅]` vs `- [ ]`), completion markers, and how to archive completed plans into the project changelog system.
- **[`../04-documentation/02-sync-documentation.md`](../04-documentation/02-sync-documentation.md)** — broader docs/log sync when behavior or operational knowledge changed.

### Phase-Based Implementation

Both workflows emphasize breaking work into phases:
1. Define scope and exit criteria for each phase (include **how** success will be verified)
2. Implement the smallest change that satisfies scope
3. Meet the **Verification Bar** before proceeding
4. Update changelog and troubleshooting as needed

### Verification Bar (shared)

A phase or plan is **not complete** because code was written or a single build passed. **Done** requires evidence that the change works against acceptance criteria.

| Priority | Check | When |
|----------|--------|------|
| Required | Project verify command (build/lint/typecheck as defined by the project) | Always when a command exists in `AGENTS.md`, package scripts, Makefile, or test docs |
| Required | Automated tests for the change | When a test suite/script exists; for bugs, add a regression test when practical |
| Required | Acceptance / smoke of affected flows | When the change is user-facing or runtime-dependent (dev server, CLI, IPC, providers, export/render, etc.) |
| Required | Static hygiene + `git diff` review | TypeScript/ESLint when configured; no secrets/unintended files |
| Rule | **Skipped or blocked ≠ success** | Document residual risk; do not mark `- [✅]` as if verification passed |

- Prefer the plan's named verify/test commands and acceptance criteria over a generic `npm run build` alone.
- Name commands run and pass/fail in phase reports and in the **02** verification addendum.
- Full wording lives in **[`01-execution.md`](./01-execution.md)** and **[`02-confirm-execution.md`](./02-confirm-execution.md)**; **[`03-execute-and-confirm.md`](./03-execute-and-confirm.md)** requires both.

## Related Workflows

- [Implementation Plan](../01-planning-and-organizing/02-finalise-plan.md) - Create the plan to execute
- [Code Review](../05-review/01-code-review.md) - Review after implementation
- [Bug Description](../03-debugging/01-bug-description.md) - Structure bug reports before fixing
- [Bug Fix](../03-debugging/02-bug-fix-workflow.md) - Systematic debugging workflow
