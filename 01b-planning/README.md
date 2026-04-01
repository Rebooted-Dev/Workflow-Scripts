# Planning Workflows

This directory contains workflows for creating and reviewing implementation plans.

## Workflow Index

| File | Purpose | When to Use |
|------|---------|-------------|
| [`00-research-and-plan.md`](./00-research-and-plan.md) | **START HERE** - Deep research and create initial implementation plan | When you have a goal but no plan yet |
| [`01-plan-review.md`](./01-plan-review.md) | Review and validate implementation plans | Before starting implementation |
| [`02-finalise-plan.md`](./02-finalise-plan.md) | Convert approved scope into detailed implementation plan | After plan review feedback |

## Workflow Sequence

```
START HERE
    │
    ▼
┌──────────────────────────┐
│  00-research-and-plan.md │
│  (Research & create      │
│   initial plan)          │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────┐      ┌──────────────────────────┐
│  01-plan-review.md   │ ───▶ │  02-finalise-plan.md     │
│  (Review & validate) │      │  (Create detailed plan)  │
└──────────────────────┘      └──────────┬───────────────┘
                                         │
                                         ▼
                               ┌──────────────────────┐
                               │  02-build-code/      │
                               │  01-execution.md     │
                               │  (Implement code)    │
                               └──────────────────────┘
```

## Quick Decision Guide

**Starting a new feature or have a goal but no plan yet?**
- Yes → **Use [`00-research-and-plan.md`](./00-research-and-plan.md)** ← START HERE

**Have a plan that needs review?**
- Yes → Use [`01-plan-review.md`](./01-plan-review.md)

**Need to create implementation plan from approved scope?**
- Yes → Use [`02-finalise-plan.md`](./02-finalise-plan.md)

**Ready to start implementing?**
- Yes → Use [`02-build-code/01-execution.md`](../02-build-code/01-execution.md)

## Key Concepts

### Priority Ordering

All plans use consistent priority ordering (P0 → P3):
- **P0 Blocker:** Critical path items, must complete before merge
- **P1 Urgent:** High impact, must complete before release
- **P2 Soon:** Medium impact, complete next sprint
- **P3 Backlog:** Low impact, defer unless blocking higher priorities

### Severity Scoring

Plans reference the shared rubric in [`00-meta/severity-priority-rubric.md`](../00-meta/severity-priority-rubric.md) for consistent severity assessment:
- **S0 Critical:** Security breach, data loss, total outage
- **S1 High:** Major functionality broken, wide user impact
- **S2 Medium:** Partial failure, workaround exists
- **S3 Low:** Minor UX, cosmetic, maintainability

### Phase-Based Planning

Plans break work into phases with:
1. Clear scope definition (what's included/excluded)
2. Exit criteria (how to verify phase is complete)
3. Effort estimation (Small/Medium/Large)
4. Dependency mapping (what must complete first)

### Plan Review Feedback

Review feedback is appended to the plan document with:
- Priority-ordered findings (P0 → P3)
- Rationale for each finding
- Actionable fixes or alternatives
- File/line references when applicable

## Related Workflows

- [Execution](../02-build-code/01-execution.md) - Implement the plan
- [Confirm Execution](../02-build-code/02-confirm-execution.md) - Verify implementation matches plan
- [Code Review](../05-review-audit/01-code-review.md) - Review code after implementation
- [Severity & Priority Rubric](../00-meta/severity-priority-rubric.md) - Shared scoring standard
