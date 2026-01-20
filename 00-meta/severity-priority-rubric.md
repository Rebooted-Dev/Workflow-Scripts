# Workflow: Severity & Priority Rubric

## Purpose
Provide a shared rubric for scoring issues across reviews and plans.

## Definitions
- Severity: impact on users, data, or system integrity if the issue ships.
- Priority: urgency to fix based on severity, likelihood, and exposure.

## Rubric
### Impact Levels
- Low: minor UX or maintainability issues.
- Medium: partial feature failure or workaround exists.
- High: security, data loss, or service-wide outage.

### Likelihood Levels
- Rare: edge case or hard-to-reach flow.
- Possible: normal usage path.
- Likely: common path or always-on.

### Priority Mapping
- High impact + Likely/Possible => P0 blocker (fix before merge).
- High impact + Rare => P1 urgent (fix before release or add guardrail).
- Medium impact + Likely => P1 urgent (fix before merge).
- Medium impact + Possible/Rare => P2 soon (fix next sprint).
- Low impact + Likely => P2 soon (fix when touching area).
- Low impact + Possible/Rare => P3 backlog (track and defer).

### Severity Labels
- S0 Critical: security breach, data loss, total outage.
- S1 High: major functionality broken, wide user impact.
- S2 Medium: partial failure, workaround exists.
- S3 Low: minor UX, cosmetic, or maintainability.

## Evidence Requirements
- S0/S1: repro steps, logs or stack trace, affected surface, mitigation or rollback.
- S2: repro steps or test case, affected module reference.
- S3: code pointer or screenshot, rationale for change.

## Ordering Rule (reports and plans)
- Present work items in descending urgency/importance: P0, P1, P2, P3.
- Within the same priority, order by severity: S0, S1, S2, S3.

## Workflow Steps
1. Intake: capture issue details, affected users, and reproduction evidence.
2. Classify: apply severity rubric with impact and likelihood.
3. Prioritize: map to priority using the matrix.
4. Validate: reviewer confirms scores or escalates.
5. Publish: record scores with scorer, date, and rationale.
6. Revisit: re-score on new evidence or milestone changes.
7. Close: confirm final severity/priority and archive rationale.

## Acceptance Criteria
- Definitions and thresholds are documented and consistently applied.
- Each item records severity, priority, scorer, date, and rationale.
- Disputes follow an escalation path with resolution SLA.
- Reports show score distribution and changes over time.

## Notes
- If uncertain, default to higher likelihood and justify.
- Include a one-line customer impact summary for S0–S2.
- Avoid inflation: do not upgrade severity/priority to "be safe" unless the exposure/likelihood is real and evidenced.
