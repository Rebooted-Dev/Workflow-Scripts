# Debugging Workflows

This directory contains workflows for debugging and fixing bugs.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-bug-description.md`](./01-bug-description.md) | Structure and document bug reports | When receiving or creating bug reports |
| [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) | Systematically identify and fix bugs | When debugging issues or fixing bugs |

## Workflow Sequence

```
┌─────────────────────┐      ┌──────────────────────────┐
│  01-bug-description │ ───▶ │  02-bug-fix-workflow.md  │
│  (Document the bug) │      │  (Fix the bug)           │
└─────────────────────┘      └──────────────────────────┘
```

## Quick Decision Guide

**Received or discovered a bug that needs documentation?**
- Yes → Use [`01-bug-description.md`](./01-bug-description.md)

**Need to systematically fix a bug?**
- Yes → Use [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md)

## Key Concepts

### Bug Description Structure

A good bug report includes:
1. **Observed behavior** - What actually happened
2. **Expected behavior** - What should have happened
3. **Reproduction steps** - How to trigger the bug
4. **Environment** - Context where bug occurs
5. **Impact assessment** - Severity and priority

### Systematic Debugging

The bug fix workflow uses a structured approach:
1. Reproduce the issue consistently
2. Isolate the root cause
3. Implement the minimal fix
4. Verify the fix works
5. Check for regressions
6. Document the fix

## Related Workflows

- [Code Build](../02-code-build/01-execution.md) - Implement the fix
- [Confirm Execution](../02-code-build/02-confirm-execution.md) - Verify the fix
- [Code Review](../05-code-review-audit/01-code-review.md) - Review the fix
- [Sync Documentation](../04-documentation/02-sync-documentation.md) - Update docs with bug info
