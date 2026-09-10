# Debugging Workflows

This directory contains workflows for debugging and fixing bugs.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`01-bug-description.md`](./01-bug-description.md) | Comprehensive escalation and evidence handoff | When a bug persists, is non-straightforward, or needs team review |
| [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) | Systematically identify and fix bugs | First-time bug investigation and remediation |

## Workflow Sequence

```
┌──────────────────────────┐
│ Bug discovered           │
└────────────┬─────────────┘
             ▼
┌──────────────────────────┐
│ 02-bug-fix-workflow.md   │
│ (Investigate and fix)    │
└────────────┬─────────────┘
             │ persists / needs escalation
             ▼
┌──────────────────────────┐
│ 01-bug-description.md    │
│ (Document comprehensively)│
└────────────┬─────────────┘
             │ evidence handoff
             ▼
┌──────────────────────────┐
│ 02-bug-fix-workflow.md   │
│ (Re-enter with report)   │
└──────────────────────────┘

P0/S0: enter 02 immediately for containment/remediation;
01 may document or escalate in parallel and is never a gate.
```

## Quick Decision Guide

**First-time P0/S0 incident?**
- Enter [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) immediately for containment/remediation. Use [`01-bug-description.md`](./01-bug-description.md) in parallel only when comprehensive escalation or team review is needed.

**First-time, straightforward P1–P3 bug?**
- Use [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) for investigation and remediation.

**Persistent, non-straightforward, or escalation/team-review case?**
- Capture the available initial 02 evidence, then use [`01-bug-description.md`](./01-bug-description.md) and re-enter [`02-bug-fix-workflow.md`](./02-bug-fix-workflow.md) with the report.

Initial 02 work produces troubleshooting and changelog evidence that 01 consumes; P0/S0 containment must not wait for report generation.

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
- [Code Review](../05-review/01-code-review.md) - Review the fix
- [Sync Documentation](../04-documentation/02-sync-documentation.md) - Update docs with bug info
