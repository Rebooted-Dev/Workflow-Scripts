# Bound sub-agent concurrency at 12 in the root agent rules

**Date:** 2026-10-07
**Type:** docs

---

## Summary

Recorded an execution ceiling of **12 concurrent sub-agents per task** (including nested sub-agents) in the Workflow-Scripts agent rules, so the limit that host projects already inherit from the setup workflow is explicit when working in this repository too. Added a short `## Execution` section to the root `AGENTS.md` and the matching cap to the `## Execution` section in `00-project/AGENTS.md`.

## Scope

- `AGENTS.md` (repository root) — new `## Execution` section with the parallel-use guidance and the 12-sub-agent ceiling.
- `00-project/AGENTS.md` — same ceiling added to the existing Execution bullet list.
- No workflow steps, scripts, or host-project behavior changed; this documents an existing convention rather than altering execution logic.

## Related

- Host-project setup template already states the same ceiling: `00-project-setup/01-setup-project.md` § 1.2.
