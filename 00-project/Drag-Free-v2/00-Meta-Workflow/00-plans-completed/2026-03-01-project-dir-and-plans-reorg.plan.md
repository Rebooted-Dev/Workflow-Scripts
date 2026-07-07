---
name: Project dir and plans reorg
overview: Revise Workflow-Scripts setup and related docs so the project directory uses a new `project/` container (KIV, research, build, changelog, troubleshooting). Changelog and plans-completed are merged into a single `project/changelog/` system (one index; completed plans in changelog/plans/). Keep `plans/` as a thin layer with README map and TODO.md; update all workflow instructions for consistency.
todos: []
isProject: false
---

# Revise setup and workflows: project directory, plans README/TODO

## Target structure (at project root after setup)

- `**project/**` (new top-level container)
  - `**KIV/**` – keep in view / backlog
  - `**research/**` – research and discovery artifacts
  - `**build/**` – active plans and build artifacts
  - `**changelog/**` – **merged** changelog + plans-completed: one system, one index
    - Type subdirs: `added/`, `changed/`, `fixed/`, `improved/`, `docs/`, `refactor/`, `config/` (short change entries)
    - `**plans/`** – completed/archived full plan documents (date-prefixed filenames)
    - **Single index:** `project/changelog/index.md` — columns: Date | Type | Title | File | (optional) Notes. Types include the above + `plan` for archived plans.
  - `**troubleshooting/`** – moved from root; same internal layout (build, runtime, data, etc. + index)
- `**plans/`** (retained, reduced role)
  - `**README.md`** – map/navigation to items in `project/` (KIV, research, build, changelog, troubleshooting; changelog holds both change entries and completed plans)
  - `**TODO.md`** – current task list; kept up to date as tasks involving `project/` are completed
- `**docs/`** and `**docs/agents/`** – unchanged (remain at root)
- `**plans-completed/`** – removed; merged into `**project/changelog/`** (completed plans → `project/changelog/plans/` + row in changelog index)

---

## 1. Revise [workflows/setup/01-setup-project.md](../../workflows/setup/01-setup-project.md)

- **Quick Start (Step 4–9):**
  - Create `project/` and subdirs: `project/{KIV,research,build}`, then `project/changelog/{added,changed,fixed,improved,docs,refactor,config,plans}` and single `project/changelog/index.md`, then `project/troubleshooting/{build,runtime,data,environment,security}`.
  - Create `plans/` with `README.md` (map to project dir) and `TODO.md` (current tasks template).
  - Remove creation of root-level `changelog/`, `troubleshooting/`, `plans-completed/`; no separate plans-completed index.
- **Purpose / Step 2.0:**
  - Replace "plans, plans-completed" with "project (KIV, research, build, changelog, troubleshooting) and plans (README + TODO)".
- **Step 2.2 (troubleshooting):** Create `project/troubleshooting/{build,runtime,data,environment,security}` (and any backup paths in 2.3 to `project/troubleshooting/`).
- **Step 2.4 (troubleshooting README):** Paths in README template should reference `project/troubleshooting/` and `project/changelog/`; "update the logs" and index instructions should use `project/changelog/`, `project/troubleshooting/`.
- **Step 2.6.1 (changelog-and-troubleshooting.md):** Update all paths to `project/changelog/`, `project/troubleshooting/`; document **plans** as "plans/README.md (map to project), plans/TODO.md (current tasks)" and **changelog** as the single system (type folders + changelog/plans/ for completed plan docs; one index; Type includes plan) .
- **Step 2.6.2 (AGENTS.md slim Change Management):** Point to `project/changelog/` and `project/troubleshooting/`; mention plans README/TODO.
- **Step 2.7 (changelog):** All paths → `project/changelog/` Create type subdirs + `project/changelog/plans/`; one index (Date | Type | Title | File | Notes). Types: added, changed, fixed, improved, docs, refactor, config, plan.
- **Step 2.8 (plans directories):** Replace with:
  - **Create `project/` and subdirs** (KIV, research, build; changelog with type folders + plans subdir and single index; troubleshooting as in 2.2).
  - **Create `plans/README.md`** – short map: which project subdir holds what (KIV, research, build, changelog, troubleshooting); clarify that changelog holds both change entries and completed plans (in changelog/plans/).
  - **Create `plans/TODO.md`** – template for current tasks; instruct that it is updated when tasks involving `project/` are completed (e.g. move/check off items, update changelog index or troubleshooting as needed).
  - (Archived plans: move to `project/changelog/plans/` with date prefix, add row to `project/changelog/index.md` with Type=plan.)
- Remove or renumber old "2.8 plans/plans-completed" steps that create root `plans/`/`plans-completed/`; ensure no duplicate steps.
- **Step 2.10 (CLAUDE.md / GEMINI.md):** In templates, replace references to `changelog/`, `troubleshooting/`, `plans/`, `plans-completed/` with `project/changelog/`, `project/troubleshooting/`, `plans/` (README + TODO).
- **Step 3 (Verification):** Assert `project/` and its subdirs exist; assert `project/changelog/` and `project/troubleshooting/` structure; assert `plans/README.md` and `plans/TODO.md` exist; assert `project/changelog/` has type folders + plans/ + single index; remove checks for root `changelog/`, `troubleshooting/`, `plans-completed/`.
- **Step 4 (Migration):** When migrating existing repos, move existing `changelog/` and `troubleshooting/` into `project/`; move contents of `plans-completed/` into `project/changelog/`: plan docs to `project/changelog/plans/` (date prefix), rows to `project/changelog/index.md` with Type=plan; create `plans/README.md` and `plans/TODO.md`; update all path references and link scan (4.4) for new paths.
- **Complete Setup Checklist:** Replace every item that refers to root changelog, root troubleshooting, plans-completed with project-based paths, single changelog index, and plans README/TODO.
- **Repository Management (1.4):** In the AGENTS.md template block, update "update the changelog" / "update troubleshooting" paths to `project/changelog/` and `project/troubleshooting/`; mention plans README/TODO.

---

## 2. Add or update plans/README.md and plans/TODO.md content in the workflow

- **plans/README.md** (written by 01-setup-project): Short document that:
  - Describes `project/` and its subdirs: KIV, research, build, changelog, troubleshooting.
  - Maps "where do I put X?" to the right project subdir (e.g. active plans → project/build, change entries and completed plans → project/changelog/ (one index); completed plan docs in project/changelog/plans/; see plans/README for map).
  - Points to `plans/TODO.md` for current tasks.
- **plans/TODO.md** (written by 01-setup-project): Template with a short "Current tasks" section and instructions that this file is kept up to date as tasks involving `project/` are completed (e.g. check off items; add changelog row or troubleshooting entry as needed).

---

## 3. Update [workflows/setup/README.md](../../00-project-setup/README.md)

- Summary of 01-setup-project: replace "`plans/` and `plans-completed/`" and root "`troubleshooting/` and `changelog/`" with "`project/` (KIV, research, build, changelog, troubleshooting) and `plans/` (README map + TODO). Changelog merges change entries and completed plans (one index; completed plan docs in changelog/plans/)".
- Ensure the Quick Decision Guide and any other mentions use the new layout.

---

## 4. Update [00-plans/index.md](../00-plans/index.md) (Workflow-Scripts' own plans index)

- Clarify that this is the **Workflow-Scripts** plans index (within the workflow repo).
- Add a note that **project** repos using this workflow have: `project/` (KIV, research, build, changelog, troubleshooting) and `plans/` (README + TODO) at **project root**; changelog holds both change entries and completed plans (one index); active/archived plan locations are defined in `plans/README.md`.

---

## 5. Update workflows that reference plans, changelog, or troubleshooting paths

- **[01b-planning/00-research-and-plan.md](../../workflows/planning/00-research-and-plan.md):** Output "implementation plan in `plans/`" → e.g. "in `project/build/` (or as specified in project's `plans/README.md`)" and/or "add task to `plans/TODO.md`".
- **[01b-planning/01-plan-review.md](../../workflows/planning/01-plan-review.md):** If it writes to "plan document path", add a note that plan paths are typically under `project/build/` or per `plans/README.md`.
- **[workflows/documentation/03-mark-completed.md](../../workflows/documentation/03-mark-completed.md):** Replace all references to `plans/`, `plans-completed/`, `changelog/`, `troubleshooting/` with `project/build/`, `project/changelog/` (single index; completed plans in changelog/plans/), `project/troubleshooting/`; and "update plans/TODO.md when tasks are completed".
- **[workflows/review/01-code-review.md](../../workflows/review/01-code-review.md):** "file a report in `plans/`" → "file a report in `project/build/` (or per project's `plans/README.md`)" and/or add to `plans/TODO.md` as needed.
- **[workflows/build/02-confirm-execution.md](../../workflows/build/02-confirm-execution.md) and [03-execute-and-confirm.md](../../workflows/build/03-execute-and-confirm.md):** When either workflow is executed and a plan is **confirmed completed** (completed tasks marked with green check marks), add a final step: **file the plan in the changelog** — move (or copy) the plan document to `project/changelog/plans/` with a date prefix (e.g. `yyyy-mm-dd-<plan-name>.md`), then add a new row at the **top** of `project/changelog/index.md` with Date, Type=`plan`, Title, File path, and optional Notes. This ensures completed plans are archived in the single changelog system and the index stays up to date.
- **Any other Workflow-Scripts .md** that mentions `plans/`, `plans-completed/`, `changelog/`, or `troubleshooting/` at project root: switch to `project/...`, single `project/changelog/` index (and changelog/plans/ for completed plans), and `plans/README.md` / `plans/TODO.md`. Search under `Workflow-Scripts` and update consistently.

---

## 6. docs/agents and AGENTS.md convention (main project repo)

- **docs/agents/changelog-and-troubleshooting.md** (and any similar doc in the workflow or in project templates): Ensure path conventions use `project/changelog/` (one index; type folders + plans/ for completed plan docs), `project/troubleshooting/`, and plans (README + TODO). 01-setup-project injects this via Step 2.6.1; ensure the injected text describes the merged changelog (no separate plans-completed).

---

## 7. Workflow-Scripts 00-plans and 00-plans-completed (simpler system)

- `**00-plans/`** and `**00-plans-completed/**` in Workflow-Scripts apply **only** to ongoing work involving **Workflow-Scripts itself** (e.g. workflow revisions, docs, remediation). They use a **simpler system**: active plans in `00-plans/`, completed/archived in `00-plans-completed/` with date prefix and index — no adoption of the full `project/` (KIV, research, build, changelog, troubleshooting) structure inside the Workflow-Scripts repo.
- The full **project/** + merged **changelog** structure described in this plan applies to **projects that run the setup** (e.g. Info-Visualizer). Workflow-Scripts keeps its own lightweight `00-plans/` and `00-plans-completed/` for its own workflow-related work; no change required to that layout unless you choose to align it later.

---

## Summary of path changes


| Old (project root)    | New (project root)                                                                                                            |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `changelog/`          | `project/changelog/` (type folders + `plans/` subdir; **one index** for all)                                                  |
| `plans-completed/`    | merged into `project/changelog/` — completed plan docs in `project/changelog/plans/`, row in same changelog index (Type=plan) |
| `troubleshooting/`    | `project/troubleshooting/`                                                                                                    |
| `plans/` (plan files) | `project/build/` (active plans)                                                                                               |
| (none)                | `plans/README.md` (map to project dir)                                                                                        |
| (none)                | `plans/TODO.md` (current tasks)                                                                                               |
| `project/`            | `project/KIV/`, `project/research/`, `project/build/`, `project/changelog/`, `project/troubleshooting/`                       |


All workflow instructions that create, read, or link to these locations should be updated so that executing the plan produces and maintains this layout consistently.

---

## Implementation Status ✅

**Status:** ✅ COMPLETED

---

## Verification addendum (Mark Completed workflow)

**Date:** 2026-03-01  
**Workflow:** workflows/documentation/03-mark-completed.md

### Verification summary

- **Sections 1–7:** All plan items were verified against the Workflow-Scripts codebase. `01-setup-project.md` uses `project/`, `project/changelog/` (type folders + `plans/` subdir, single index), `project/troubleshooting/`, and `plans/README.md` / `plans/TODO.md`. `workflows/setup/README.md`, `00-plans/index.md`, and the workflows (01b-planning, 04-documentation, workflows/review, workflows/build) reference the new paths. Step 6 in `02-confirm-execution.md` and the confirm step in `03-execute-and-confirm.md` document filing completed plans in `project/changelog/plans/` with a row in the changelog index.
- **No flagged issues.** Implementation matches the plan; no false completions or missing updates found.
- **Filing:** This plan is a Workflow-Scripts plan (not a project-repo plan), so it is filed in `00-plans-completed/` with date prefix per the simpler system (plan item 7).
