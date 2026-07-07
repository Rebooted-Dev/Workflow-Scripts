---
name: delegated-agent-orchestration
description: Coordinate helper agents and provider harnesses with single-writer discipline, role IDs, isolated outputs, manifests, and honest blocked-state reporting.
---

# Delegated Agent Orchestration

Use this skill when a workflow uses parallel agents, multi-model review, role fan-out, or delegated provider runs.

## Rules

1. Keep one primary writer. Helper agents produce isolated notes, findings, or manifests; the main agent verifies and applies changes.
2. Use 3-6 helpers by default. Add specialists only when the evidence justifies them.
3. Load role IDs from `core/roles/` and coordination policy from `core/parallel-agents.md`.
4. Preserve protected-source hashes and run manifests when a harness produces them.
5. Verify helper findings against source files before acting.
6. If a provider or harness is stubbed, missing, or unauthenticated, say so and mark production verification blocked.

## Guardrails

- Do not present stub output as production review evidence.
- Do not let helpers mutate live repo state independently.
- Do not use parallelism to bypass repo-boundary or dirty-worktree checks.
