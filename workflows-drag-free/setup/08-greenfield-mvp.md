---
id: setup-greenfield-mvp
version: 2.0
category: setup
kind: workflow
triggers:
  - "start a new project"
  - "greenfield mvp"
  - "walking skeleton"
inputs: [product-brief, target-deployment]
outputs: [walking-skeleton, deployment-path, debt-ledger]
requires: [metadata-root, code-design, error-handling, observability, security-baseline]
agents: [architecture-reviewer, test-strategist, security-scanner, docs-writer]
prev: []
next: [research-and-plan, execution]
---

# Workflow: Greenfield MVP

## Purpose

Create a new project from idea to deployed walking skeleton before feature work begins.

## Steps

1. Product brief
   - Name the target user, problem, MVP capabilities, explicit non-goals, and target deployment environment.
   - Record hard-to-reverse stack choices as ADRs in `<metadata-root>/decisions/`.
2. Research and architecture
   - Use `../planning/00-research-and-plan.md` for research.
   - Produce a design brief and ADRs for system boundaries, interfaces, data ownership, and failure modes.
3. Walking skeleton
   - Use `../../templates/walking-skeleton-checklist.md` as the exit checklist.
   - Scaffold the repo with strict type/compile settings where available, lint/format, one real test, CI, secret hygiene, and baseline observability.
   - Deploy the near-empty app to the real target environment using `../deployment/00-deploy.md` when present or the project deployment guide.
4. Feature slices
   - Implement MVP capabilities as thin vertical T2 slices through planning, execution, review, and confirmation.
   - Keep the app deployable after each slice.
5. MVP gate
   - Run the security baseline, smoke golden paths, intentionally trigger one safe failure and confirm observability, update docs, and review `<metadata-root>/debt/`.

## Acceptance Criteria

- The checklist in `../../templates/walking-skeleton-checklist.md` is complete or every unchecked item is filed as debt.
- A trivial change can be tested, merged, deployed, observed, and rolled back.
- All shortcuts taken during setup are recorded in `<metadata-root>/debt/` using `../../core/debt-ledger.md`.
