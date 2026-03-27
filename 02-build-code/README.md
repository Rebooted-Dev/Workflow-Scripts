# Build/Code Workflows

This directory contains workflows for implementing code changes with verification.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-execution.md`](./01-execution.md) | Execute implementation in phases with verification | Implementing features from a plan |
| [`02-confirm-execution.md`](./02-confirm-execution.md) | Validate that implementation matches the plan | After completing implementation |
| [`03-execute-and-confirm.md`](./03-execute-and-confirm.md) | Run 01 then 02 in one workflow | Execute plan and confirm completion in one go |

## Workflow Sequence

```
┌─────────────────────┐      ┌──────────────────────────┐
│  01-execution.md    │ ───▶ │  02-confirm-execution.md │
│  (Implement code)   │      │  (Validate completion)   │
└─────────────────────┘      └──────────────────────────┘
         │                              ▲
         │    ┌─────────────────────────┴─────────────────────────┐
         └───▶│  03-execute-and-confirm.md (01 then 02 in one)    │
              └───────────────────────────────────────────────────┘
```

## Quick Decision Guide

**Are you implementing changes from a plan?**
- Yes → Use [`01-execution.md`](./01-execution.md)

**Have you finished implementing and need to verify completeness?**
- Yes → Use [`02-confirm-execution.md`](./02-confirm-execution.md)

**Do you want to execute the plan and then confirm in a single workflow?**
- Yes → Use [`03-execute-and-confirm.md`](./03-execute-and-confirm.md)

## Key Concepts

### Task Marking Convention

To keep completion rules consistent across workflows, use the single source of truth:

- **[`../04-documentation/03-mark-completed.md`](../04-documentation/03-mark-completed.md)** — task checkbox conventions (✅ vs `[ ]`), completion markers, and how to archive completed plans into the project changelog system.

### Phase-Based Implementation

Both workflows emphasize breaking work into phases:
1. Define scope and exit criteria for each phase
2. Implement the smallest change that satisfies scope
3. Verify with build/tests before proceeding
4. Update changelog and troubleshooting as needed

### Verification Steps

- Run `npm run build` (or project equivalent)
- Test in dev server when applicable
- Check git diff to confirm changes

## Related Workflows

- [Implementation Plan](../01-planning/02-finalise-plan.md) - Create the plan to execute
- [Code Review](../05-review-audit/01-code-review.md) - Review after implementation
- [Bug Fix](../03-debug/02-bug-fix-workflow.md) - If issues arise during implementation
