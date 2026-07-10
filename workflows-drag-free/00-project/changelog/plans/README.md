# Changelog Plans Archive

Optional archive for completed plan documents filed **under `changelog/plans/`** when explicitly requested (alternate to the default `plans-completed/<category>/` filing).

## When to use

- User explicitly asks to file under `changelog/plans/`
- Historical bundles already stored here

## Default filing

Unless requested otherwise, completed plans go to **`plans-completed/<category>/`** with a Type=`plan` row in `changelog/index.md` (File `../plans-completed/<category>/...`). See `plans-completed/README.md`.

## File naming

```
<yyyy-mm-dd>-<plan-name>.md
```

Add a Type=`plan` row to `changelog/index.md` with File `plans/<filename>`.

## Contents (filed 2026-07-10)

Implemented Drag-Free-v2 design package (from former active `plans/` + `research/`):

| File | Role |
|------|------|
| `2026-07-06-drag-free-v2-unified-implementation-plan.md` | Master implementation plan (Phases 0–6 complete) |
| `2026-07-06-drag-free-v2-workflow-skill-layer-plan.md` | Skill layer plan (completed) |
| `2026-07-06-workflow-system-v2-redesign-proposal.md` | Redesign proposal (+ sibling `.reviews/`) |
| `2026-07-06-engineering-quality-and-lifecycle-proposal.md` | Engineering-quality companion proposal |
| `2026-07-06-workflow-*-survey*.md` | Baseline and re-run surveys |

2026-07-10 reconciliation/migration plans filed under `../plans-completed/migration/` (single-master, ops-meta final + source draft). `plans/` holds tracker files only (`README.md`, `TODO.md`).
