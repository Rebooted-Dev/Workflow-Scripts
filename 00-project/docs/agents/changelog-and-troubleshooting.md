# Changelog & Troubleshooting (Agent Conventions)

Full conventions for `changelog/`, `troubleshooting/`, **`plans-completed/`** (categorized filed plans), "update the logs", and active plans (README + TODO). **`changelog/index.md`** lists change entries and Type=`plan` rows for plans stored under `../plans-completed/...` or `plans/...`.

Paths below are relative to `00-project/` unless noted.

---

## Changelog System (`changelog/` directory)

- **When to create changelog entries**: For any change to Workflow-Scripts workflows, scripts, or `00-project/` meta (features, fixes, refactors, docs, config). One file per change. For **completed plans**, default is **`plans-completed/<category>/`** plus a Type=`plan` row in **`changelog/index.md`**; alternate is **`changelog/plans/`** when explicitly requested.
- **Location**: Use the `changelog/` directory. Do NOT use a single `CHANGELOG.md` at repo root for new entries (legacy root `CHANGELOG.md` may remain until migrated).
- **Structure**:
  - Type folders: `added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/` for short change entries.
  - Optional **`plans/`** subdir for plans archived next to the changelog (date-prefixed filenames).
  - **Single index**: `changelog/index.md` — columns Date | Type | Title | File | Notes. Types include the above plus `plan` for any filed plan path.
  - File naming for changes: `<yyyy-mm-dd>-<type>-<short-title>.md`; for plans in `changelog/plans/`: `yyyy-mm-dd-<plan-name>.md`.
- **Index maintenance**: Always update `changelog/index.md` when adding a change entry or filing a plan (add row at the top of the table).
- **Template**: See `changelog/README.md` for the entry template and full conventions.

## Troubleshooting System (`troubleshooting/` directory)

- **When to create troubleshooting entries**: Document bugs, issues, or non-trivial problems that required investigation and resolution.
  - **Bugs**: Any defect that causes incorrect behavior or crashes
  - **Issues**: Problems that required debugging, investigation, or workarounds
  - **Non-trivial problems**: Issues that took significant time to resolve, involved multiple steps, or have lessons worth preserving
- **When NOT to create troubleshooting entries**: Simple doc or workflow updates, routine refactors, or straightforward additions. Changelog only for those.
- **Location**: Use the `troubleshooting/` directory.
- **Structure**:
  - Create individual files in the appropriate category folder (`build/`, `runtime/`, `data/`, `environment/`, `security/`)
  - File naming: `<yyyy-mm-dd>-<category>-<short-title>.md`
  - Each entry must include: Date, Category, Status, Symptom, Root Cause, Fix, Verification, Notes/Lessons
- **Index maintenance**: Always update `troubleshooting/index.md` when adding a new entry (add row at the top of the table).
- **Template**: See `troubleshooting/README.md` for the entry template and full conventions.

## Interpreting "Update the Logs"

When instructed to "update the logs" or "update the log files", this refers to:

1. **Changelog** – Create a new entry in `changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and add a row at the top of `changelog/index.md`. Use the appropriate type folder. For a **completed plan**, follow § **Plans completed** below unless the user specifies **`changelog/plans/`**.
2. **Troubleshooting entries** – Add entries to `troubleshooting/` **only when** the work involved fixing a bug, resolving an issue that required debugging/workarounds, or solving a non-trivial problem. **Do not** add troubleshooting entries for simple doc or workflow updates — use the changelog only for those.
3. **Both** – When a bug/issue/non-trivial fix requires both a troubleshooting entry **and** a changelog entry.

**Note**: "Logs" refer to `changelog/` and `troubleshooting/`, not application `.log` files.

## Plans completed (`plans-completed/`) — default for "file as completed"

Same pattern as **`troubleshooting/`**: **category subfolders** + **`plans-completed/index.md`** (columns **Date | Category | Title | File | Notes**), **newest first**.

**Categories:** `implementation/`, `investigation/`, `migration/`, `review/`, `tooling/` — see `plans-completed/README.md` for definitions.

**When** a plan is completed, or the user asks to **"file … as completed"**:

1. **Move** the plan from `plans/` or `build/` to **`plans-completed/<category>/`**. Prepend `yyyy-mm-dd-` to the filename if missing.
2. **Update `plans-completed/index.md`** — new row at the top.
3. **Update `changelog/index.md`** — new row at the top with Type=`plan`, **File** relative to `changelog/`, e.g. `../plans-completed/tooling/2026-04-02-my-plan.md`.

## Changelog plans archive (`changelog/plans/`)

Use when the user **explicitly** asks to file under **`changelog/plans`**, or for historical bundles already there. See `changelog/plans/README.md`.

---

## Documentation, Plans & Project Directories

- **Changelog**: `changelog/` — one index for change entries and Type=`plan` rows.
- **Troubleshooting**: `troubleshooting/` — category folders + `index.md`.
- **Plans completed**: `plans-completed/` — category folders + `index.md`; default target for "file as completed".
- **Docs**: `docs/` holds project documentation; `docs/agents/` holds agent-facing detailed guides. Slim `00-project/AGENTS.md` links to `docs/agents/`.
- **Plans**: `plans/README.md` maps the project dir. `plans/TODO.md` holds current tasks. Active plan documents live in `plans/` or `build/`.