# Workflow: Plan Review and Finalisation

## Purpose
Run a complete planning pass by first reviewing a supplied plan, then finalising it into an implementation-ready plan.

Use this workflow when you would otherwise ask for both:
1. [`01-plan-review.md`](./01-plan-review.md)
2. [`02-finalise-plan.md`](./02-finalise-plan.md)

## Inputs
- Primary plan document path, supplied by the user.
- Any context, constraints, or prior feedback supplied by the user.

## Steps
1. Execute [`01-plan-review.md`](./01-plan-review.md) against the supplied plan.
2. Verify that the review output has been written or captured according to [`01-plan-review.md`](./01-plan-review.md).
3. Execute [`02-finalise-plan.md`](./02-finalise-plan.md) using the original plan plus all review output.
4. Verify that the finalised implementation plan satisfies the acceptance criteria in [`02-finalise-plan.md`](./02-finalise-plan.md).

## Output
- Review feedback produced according to [`01-plan-review.md`](./01-plan-review.md).
- A finalised implementation plan produced according to [`02-finalise-plan.md`](./02-finalise-plan.md).

## Notes
- Do not skip the review phase unless the user explicitly says review feedback already exists and should be reused.
- Do not duplicate review or finalisation rules in this file; defer to the linked workflows as the source of truth.
- Preserve the single-writer rule and any review-artifact handling described in the linked workflows.
