# Bound Sub-agent Use in the Project Setup Template
**Date:** 2026-10-03
**Type:** docs

---

## Summary
- Update the Step 1.2 `AGENTS.md` Execution template to allow at most 12 concurrent sub-agents per task, including nested sub-agents, subject to runtime capacity. The limit is a ceiling, not a target.
- Prefer GPT 6 Luna (`gpt-6-luna`) with `xhigh` reasoning effort when available.
- Include examples of useful independent scopes and retain sequential dependencies, coordinated write ownership, returned-finding verification, and direct handling of small tasks.
- Clarify that shared model preferences and concurrency limits belong in `AGENTS.md`; harness-specific choices remain in harness files. Align the complete setup checklist.

## Scope
- `00-project-setup/01-setup-project.md`
- Apply the updated Execution template to Update-AI-Tools `AGENTS.md` in its owning repository, preserving its custom-delegator rule and remaining project guidance. Companion change: [Update-AI-Tools changelog](../../../../../Personal/Update-AI-Tools/project/changelog/docs/2026-10-03-docs-agents-gpt6-luna-policy.md).

## Verification
- Review the generated template for the 12-agent ceiling, nested-agent accounting, runtime limit, optional model preference, and preserved coordination rules.
- Run `git diff --check` and the metadata-log validator in an isolated temporary repository containing only these three change files.
