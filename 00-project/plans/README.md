# Plans – Map to Project Directory

This directory holds the **map** to the `00-project/` structure and is the place for **active plan documents** for Workflow-Scripts meta work. Completed plans are filed under **`plans-completed/<category>/`** (default) or **`changelog/plans/`** when explicitly requested — not here.

## Project directory map

- **KIV/** – Keep in view / backlog
- **research/** – Research and discovery artifacts
- **build/** – Build artifacts (optional; active plans can live here or in this directory)
- **plans/** – **Active plan documents** (this directory). Put implementation plans, proposals, and in-progress plan docs here (e.g. `plans/yyyy-mm-dd-plan-name.md`). Also holds `README.md` (this file) and `TODO.md` (current task list).
- **plans-completed/** – **Default** completed-plan archive: category folders + `index.md` (see `plans-completed/README.md`)
- **changelog/** – Change entries (type folders) and optional **`changelog/plans/`** archive. One index: `changelog/index.md` (Type includes `plan` for any filed plan, including `../plans-completed/...` paths)
- **troubleshooting/** – Troubleshooting entries by category and index
- **docs/** – Project documentation; **`docs/agents/`** holds agent-facing detailed guides

## Where to put things

- **Active plan or report** → **`plans/`** (this directory), e.g. `plans/2026-03-07-my-implementation-plan.md`. Or add a task to `plans/TODO.md`. Do **not** keep active plans under `plans-completed/` or `changelog/plans/`.
- **Change entry** → `changelog/<type>/` + row in `changelog/index.md`
- **Completed plan ("file as completed")** → **move** from `plans/` or `build/` to **`plans-completed/<category>/`**, update **`plans-completed/index.md`**, add a row at the top of **`changelog/index.md`** with Type=plan and File `../plans-completed/<category>/<file>`. **Alternate:** archive under **`changelog/plans/`** if requested.
- **Troubleshooting entry** → `troubleshooting/<category>/` + row in `troubleshooting/index.md`
- **Agent documentation** → `docs/agents/`

## Current tasks

See **plans/TODO.md** for the current task list. Keep it updated as tasks involving the project dir are completed.