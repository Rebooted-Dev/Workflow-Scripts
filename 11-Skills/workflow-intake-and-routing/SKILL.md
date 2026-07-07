---
name: workflow-intake-and-routing
description: Resolve user intent to the correct repository root, metadata root, workflow, and next artifact path. Use before Workflow-Scripts planning, execution, review, debugging, documentation, or maintenance workflows.
---

# Workflow Intake And Routing

Use this skill at the start of Workflow-Scripts work to choose the correct repo, workflow, metadata root, and next artifact.

## Routing Rules

1. Prefer exact user-supplied paths. If a path does not exist, search for the nearest moved or renamed path before deciding it is missing.
2. Resolve repo boundaries before editing. Workflow-Scripts system work uses `00-project/`; consumer-project work uses that project root's `project/`.
3. Read the selected workflow before acting. Use canonical `workflows/` paths when available; old top-level paths are compatibility redirects.
4. Resolve artifact defaults explicitly:
   - implementation plans: `<metadata-root>/build/` or the project-local plan path named by the workflow;
   - planning changelog entries: `<metadata-root>/changelog/plans/`;
   - research and reviews: `<metadata-root>/research/`;
   - completed plans: `<metadata-root>/plans-completed/<category>/`.
5. Surface ambiguity instead of silently choosing a different repo, metadata root, or workflow family.

## Guardrails

- Do not write Workflow-Scripts-system artifacts into a consumer repo's `project/` tree.
- Do not write consumer-project records into Workflow-Scripts `00-project/` unless the task is about Workflow-Scripts itself.
- Treat redirect stubs as navigation aids, not active workflow specifications.
