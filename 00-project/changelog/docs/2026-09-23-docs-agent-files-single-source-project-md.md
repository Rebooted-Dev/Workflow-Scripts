# Agent Files: Single Source of Truth with PROJECT.md
**Date:** 2026-09-23
**Type:** docs

---

## Summary
- New agent-file architecture (01 §1.1). Each rule or fact lives in exactly one file:
  - `AGENTS.md`: agent rules only; the same concise template (≤ 40 lines) in every project.
  - `PROJECT.md` (new): project facts, including the only repository map.
  - `CLAUDE.md` / `GEMINI.md`: thin; they `@import` both files and add harness-only instructions.
- Adds a placement test for new lines and a migration path for existing harness files (01 §2.10.3). Existing unique content is moved and fact-checked, not copied.
- Removes the old "identical repo map in AGENTS.md, CLAUDE.md, and GEMINI.md" requirement.

## Scope
- `00-project-setup/01-setup-project.md`: Step 1 rewritten (1.1 architecture, 1.2 AGENTS.md template, 1.3 bugs line in AGENTS.md only, 1.4 PROJECT.md template); Step 2.10 rewritten (thin harness templates, migration and check script); intro, purpose, update checklist, 2.9, 2.11, 3.6/3.7 verification, summary, and final checklist aligned
- `00-project-setup/04-track-repos-and-agent-map.md`: repo map written only to `PROJECT.md`; the files are checked, not kept in sync
- `00-project-setup/07-migrate-project-structure.md`: agent-file steps and path updates target `AGENTS.md`, `PROJECT.md`, and `docs/agents/`
- `00-project-setup/08-kaparthy-template.md`: placement note (harness-agnostic; install as `docs/agents/coding-discipline.md`)
- `00-project-setup/README.md`: summaries updated
- `03-debugging/02-bug-fix-workflow.md`: Bugs line required in `AGENTS.md` only
- `00-Meta-Workflow/00-docs/proj-organisation.md`: `PROJECT.md` added to root file lists

## Notes
- Reference implementation: Flash-UI-Idea-Generator (`AGENTS.md` 18 lines, `PROJECT.md` 23, `CLAUDE.md` 15, `GEMINI.md` 6).
- Historical plans and research that mention the old layout are unchanged as records.
