> Survey rerun of Workflow-Scripts engineering-quality coverage on 2026-07-06 after Drag-Free-v2 implementation and follow-up fixes. This rerun checks the same Q1-Q8 probes from `workflow-engineering-quality-survey-260706-0137-gpt55.md` against the current rationalized `Workflow-Scripts/` tree.

# Workflow-Scripts Engineering-Quality Survey Rerun

## Summary

Q1-Q8 are now covered by active workflow or standards artifacts. The remaining unproven item is the end-to-end T3 pilot on a real new project, because that requires a real project, design brief, ADR, deployed walking skeleton, MVP gate, and deploy/rollback/observability evidence.

| Probe | Verdict | Current evidence |
|---|---|---|
| Q1 Systems design / architecture | COVERED | `workflows/planning/04-architecture-design.md` requires a design brief, ADRs under `<metadata-root>/decisions/`, explicit boundaries/contracts, failure modes, observability, rollout/rollback, and debt budget before T2/T3 implementation. |
| Q2 Code-design standards during build | COVERED | `core/standards/code-design.md` exists and `workflows/build/01-execution.md` plus `11-Skills/engineering-quality-gates/SKILL.md` route implementers through standards for code/architecture work. |
| Q3 Error handling / fallbacks / recovery | COVERED | `core/standards/error-handling.md` exists and is required by planning/build/debug/security flows through `requires` and the engineering-quality skill. |
| Q4 Observability | COVERED | `core/standards/observability.md`, `workflows/setup/08-greenfield-mvp.md`, and `workflows/deployment/00-deploy.md` require baseline observability, health/readiness or equivalent liveness signals, log locations, and safe-failure signal checks. |
| Q5 Generic deployment path | COVERED | `workflows/deployment/00-deploy.md` provides generic deploy preconditions, target/command/log/rollback capture, smoke checks, bake observation, and deployment notes. |
| Q6 Greenfield path | COVERED | `workflows/setup/08-greenfield-mvp.md` now covers product brief, architecture, walking skeleton, feature slices, and MVP gate. |
| Q7 Tech debt tracking / budgeting | COVERED | `core/debt-ledger.md` defines debt records, T2/T3 S1 debt handling, and debt acceptance/paydown rules; `tools/wf debt` supports ledger operations. |
| Q8 Plan quality sections | COVERED | `workflows/planning/00-research-and-plan.md` contains T2/T3 quality sections for design/interfaces, error-handling strategy, test strategy, observability, rollout/rollback, and debt budget; `workflows/planning/02-finalise-plan.md` enforces the debt budget rule. |

## Remaining Gap

The T3 pilot demonstration remains pending. The survey can verify that the workflow system now contains the required lane and standards, but it cannot prove a real greenfield project has passed the lane until there is filed evidence for:

- product brief;
- design brief;
- at least one ADR;
- walking skeleton checklist;
- deployed near-empty app in the target environment;
- smoke/health verification;
- rollback evidence or accepted debt;
- MVP gate notes.

## Follow-up

Keep the TODO row open until the T3 pilot is demonstrated end-to-end on a real new project. After that pilot, file the pilot report under `00-project/build/engineering-quality-t3-pilot/` or the consumer project's own metadata root, then update the TODO row and companion proposal.
