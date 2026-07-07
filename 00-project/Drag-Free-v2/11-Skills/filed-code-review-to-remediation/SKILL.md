---
name: filed-code-review-to-remediation
description: Run or consume a workflow-driven code review and turn verified findings into a filed remediation plan. Use when the user asks for a code review report in project/research, asks to convert a review into a detailed implementation plan, or wants verified review findings prioritized before implementation.
---

# Filed Code Review To Remediation

Use this skill when review output must become a durable repo artifact and then a concrete plan.

## Workflow

1. Read the review instructions.
   - Use the exact workflow path the user named, usually under `Workflow-Scripts/workflows/review/`.
   - Read the severity/priority rubric when the workflow references one.
   - Honor the user's explicit output directory even if the workflow default differs.

2. Gather review evidence.
   - Inspect current source, tests, configs, scripts, and runtime boundaries relevant to the review scope.
   - Use parallel subagents for broad review areas when available, such as security, performance, correctness, and test coverage.
   - Treat subagent findings as candidates until independently verified.

3. Verify accepted findings.
   - Confirm each finding with file/line evidence, targeted repro commands, failing tests, logs, or code-path reasoning.
   - Downgrade or drop speculative issues.
   - Lead with bugs, risks, regressions, and missing tests.

4. File the review report.
   - Put the report in `project/research/` or the user-specified destination.
   - Include severity, impact, evidence, affected files, and recommended fix direction.
   - Keep summaries secondary to findings.

5. Create the remediation plan when asked.
   - Keep planning separate from implementation until the user authorizes edits.
   - Convert verified findings into phases ordered by severity, dependency, and risk.
   - Include exact files, tests, verification commands, expected docs/logs, and acceptance criteria.
   - Update `project/plans/README.md` and `project/plans/TODO.md` when filing an active plan.

## Guardrails

- Do not let workflow defaults override an explicit user filing path.
- Do not patch code during a plan-only request.
- Do not overstate confidence from static inspection; mark uncertain findings as follow-up research.
