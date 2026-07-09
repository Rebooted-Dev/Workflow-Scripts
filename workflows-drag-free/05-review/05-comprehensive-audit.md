---
id: comprehensive-audit
version: 2.0
category: review
kind: workflow
triggers:
  - "comprehensive audit"
  - "audit this repo"
  - "full repository audit"
inputs: [repository-root, audit-scope]
outputs: [comprehensive-audit-report]
requires: [metadata-root, review-workflow-core, severity-priority-rubric, agent-spawning-policy]
agents: [bug-hunter, security-scanner, performance-reviewer, docs-writer]
prev: [code-review]
next: [finalise-plan]
skills:
  primary: filed-code-review-to-remediation
  required:
    - workflow-intake-and-routing
    - engineering-quality-gates
    - delegated-agent-orchestration
    - repo-records-and-filing
  conditional: []
---

# Workflow: Comprehensive Audit

## Purpose
Run a broad repository audit that covers runtime behavior, security posture, maintainability, documentation, workflow hygiene, and verification gaps.

Use `../../00-core/meta/review-workflow-core.md` for the shared review contract and `../../00-core/meta/severity-priority-rubric.md` for scoring.

## Skill Hooks

- Use `workflow-intake-and-routing` to establish repo boundaries, scope, and exclusions.
- Use `engineering-quality-gates` to apply code-design, error-handling, observability, and security criteria.
- Use `delegated-agent-orchestration` when splitting review work across code, security, performance, and docs lenses.
- Use `repo-records-and-filing` to file the audit report and any follow-up plan in the correct metadata root.

## Inputs
- Repository root.
- Audit scope and exclusions.
- Any release, migration, or operational context that changes priority.

## Steps
1. Establish repo boundaries, metadata root, branch state, and ignored/generated directories.
2. Split review work across bug, security, performance, documentation, and process lenses.
3. Verify high-severity findings directly against source behavior before filing.
4. Deduplicate findings and separate confirmed issues from hypotheses.
5. File a report with prioritized findings, evidence, recommended fixes, and validation commands.

## Output
File the audit report in `<metadata-root>/research/` unless the user requests another path. Include:
- Scope and exclusions.
- Findings ordered by severity and priority.
- Verification evidence for each actionable item.
- Residual risk and follow-up checklist.
