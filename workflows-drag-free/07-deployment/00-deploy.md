---
id: deploy
version: 2.0
category: deployment
kind: workflow
triggers:
  - "deploy"
  - "release"
inputs: [deployment-target]
outputs: [deployment-record]
requires: [metadata-root, security-baseline, observability]
agents: [security-scanner, docs-writer]
prev: [confirm-execution]
next: []
---

# Workflow: Deploy

## Purpose

Provide a generic deployment path that routes to project-specific scripts and stack-specific guides.

## Preconditions

- Implementation is verified and the repo is in a known state.
- CI or local equivalent passes.
- Required configuration and secrets exist in the target environment.
- Security baseline checks from `../../00-core/standards/security-baseline.md` are complete or explicitly deferred with a debt entry.
- Rollback command or procedure is written before deploy.

## Steps

1. Identify the target environment, deployment command, smoke-test command, log location, and rollback command.
2. Run the same scripted deployment command documented for the project.
3. Verify health/readiness or equivalent liveness signal.
4. Smoke the golden path.
5. Watch error logs for the agreed bake interval.
6. Record deployment notes in the changelog, run manifest, or project deployment log.

## Acceptance Criteria

- Deployed version or artifact is identifiable.
- Health/smoke verification passed.
- Rollback path is documented and has been tested at least once for the environment, or the gap is recorded as debt.
- Operators know where to find logs and error signals per `../../00-core/standards/observability.md`.
