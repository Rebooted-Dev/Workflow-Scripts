# Workflow: Mark Completed and Verify Implementation

## Purpose
Inspect the codebase and verify that all reported completed tasks were actually implemented. Mark truly completed tasks and sub-tasks with green check marks (✅). Flag instances of false reporting (incomplete or not done) so the developer can decide what to do. Reconcile and update related documentation, changelog, and troubleshooting logs.

## When to Use This Workflow

**Use this workflow when:**
- A plan or implementation report claims tasks are "complete" and you need to confirm they were actually done
- Before closing a milestone or marking a plan as finished
- After a code review or refactor to ensure checklist items match reality
- When reconciling plans (e.g. `project/build/*.md`) with `project/changelog/`, `project/troubleshooting/`, and `docs/`

**Use [`02-sync-documentation.md`](./02-sync-documentation.md) instead when:**
- Documentation is outdated but there is no "completed task" verification focus
- You are syncing docs to code without auditing completion claims

## Inputs
- Repository root
- Plan or report files that declare completed tasks (e.g. `project/build/*.md`, `project/changelog/plans/*.md`)
- Changelog index and entries (`project/changelog/index.md`, `project/changelog/<type>/*.md`, `project/changelog/plans/` for completed plans)
- Troubleshooting index and entries (`project/troubleshooting/index.md`, `project/troubleshooting/<category>/*.md`)
- Relevant source files referenced in each task

## Prioritization and Ordering
- Use the shared rubric: `../00-Meta-Workflow/00-meta/severity-priority-rubric.md`
- Order work and **flagged issues** by descending urgency/importance: **P0 → P1 → P2 → P3**
- Within the same priority, order by severity: **S0 → S1 → S2 → S3**
- **Output:** Display all flagged issues in **descending order of importance or urgency** (most critical first)

## Steps

### Verification Workflow

```
         ┌─────────────────┐
         │  Identify plan  │
         │  files with     │
         │  "complete"     │
         └────────┬────────┘
                  │
                  ▼
┌───────────────────────────────────────────────┐
│         PARALLEL VERIFICATION AGENTS          │
├───────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ Agent A  │  │ Agent B  │  │ Agent C  │     │
│  │ (P0/S0)  │  │ (P1 sec) │  │ (P1 bug) │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │             │           │
│       │             │             │           │
│       ▼             ▼             ▼           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │ Agent D  │  │ Agent E  │  │ Agent F  │     │
│  │ (P1 UX)  │  │ (P2/3)   │  │ (docs)   │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │             │           │
│       └─────────────┼─────────────┘           │
│                     │                         │
│                     ▼                         │
│         ┌──────────────────┐                  │
│         │    Collect       │                  │
│         │    results       │                  │
│         └────────┬─────────┘                  │
└───────────────────────────────────────────────┘
                    │
                    ▼
       ┌────────────────────┐
       │  Mark ✅ vs Flag ⚠️ │
       │ (descending prior) │
       └──────────┬─────────┘
                  │
                  ▼
       ┌────────────────────┐
       │ Reconcile logs &   │
       │ docs (changelog,   │
       │ troubleshooting)   │
       └──────────┬─────────┘
                  │
                  ▼
       ┌────────────────────┐
       │ Output flagged     │
       │ issues (P0→P3)     │
       └────────────────────┘
```

### Phase 1: Identify Sources of "Completed" Claims
1. **Locate plan and report files** that declare completed tasks:
   - Scan `project/build/` and `project/changelog/plans/` for markdown files with checkboxes, "Complete", "✅" (green check mark), or "Implementation Verified"
   - Note file paths and section headings that list tasks and sub-tasks
2. **Extract claimed completions:** For each file, list every task/sub-task that is marked complete (e.g. `[✅]`, "COMPLETE", "Implementation Verified" with no "NOT COMPLETE" note). **Use only ✅ (green check mark) for marking completed items—not "x", ✓, or other symbols—for consistency.**

### Phase 2: Verify Implementation in Code (Parallel Agents)
Use **multiple parallel agents** to verify implementation. Each agent should read the **actual source files** referenced in the task (file paths, line numbers) and confirm that the described fix or feature exists.

**Suggested agent roles (spawn additional agents as needed). Each agent verifies a subset of tasks by reading code in parallel batches:**

- **Agent A (P0 / critical):** Verify all P0 and S0/S1 tasks — read the cited files, confirm the described code (e.g. `structuredClone`, ErrorBoundary usage, API key handling) is present and matches the claim
- **Agent B (P1 security / Electron):** Verify security and Electron-related tasks — read `desktop/main.ts`, `desktop/preload.ts`, `vite.config.ts`, and any IPC/context-bridge usage; confirm removal or presence of handlers as claimed
- **Agent C (P1 bugs / hooks):** Verify hook and concurrency fixes — read `hooks/useSessions.ts`, `hooks/useHistory.ts`, `hooks/usePersistence.ts`, `hooks/useGeminiClient.ts` at cited lines; confirm functional updates, batched reads, clone behavior
- **Agent D (P1 UX / components):** Verify component-level fixes — read `components/ErrorBoundary.tsx`, `ArtifactCard.tsx`, `SideDrawer.tsx`, `SessionHistory.tsx`, `CodeEditor.tsx` at cited lines; confirm scroll logic, keyboard handlers, error boundaries
- **Agent E (P2 / refactors):** Verify P2 and P3 items — read any files cited for "extract logic", "schema validation", "useMemo", regex consolidation; confirm implementation or document absence
- **Agent F (Docs / logs):** Verify documentation and log claims — check `project/changelog/`, `project/troubleshooting/`, `docs/` for entries that the plan says were updated; confirm they exist and match the described changes

Agents should **batch-read files concurrently** (e.g. read all files for their task subset in parallel) to maximize speed. Output per agent:
- **Task ID / heading** and **Claim** (what the plan says is done)
- **Files read** (paths and line ranges)
- **Verified?** Yes / No / Partial
- **Evidence** (exact code or doc snippet that confirms or contradicts)
- **Flag** (if not done: "False completion", "Incomplete", "Not implemented", or "Docs not updated")

### Phase 3: Mark Completed vs Flag False Reporting
1. **For each task/sub-task:**
   - If verification shows the implementation **is present and correct**: mark with **✅** (green check mark) in the plan/report. Ensure checkboxes are `[✅]` and any "Implementation Verified" or "Verification" section reflects reality.
   - If verification shows the implementation **is missing, partial, or incorrect**: do **not** add a green check mark. Instead **flag** the item for the developer.
2. **Flagging convention:**
   - **False completion:** Plan says complete but code/docs show no implementation
   - **Incomplete:** Only part of the task was done (e.g. proxy handlers added but IPC key handler still exposed)
   - **Not implemented:** Task marked done but cited file/line does not contain the described change
   - **Docs not updated:** Plan says "documentation updated" but changelog/troubleshooting/docs have no corresponding entry or the entry is wrong
3. **Collect all flagged issues** and list them in **descending order of importance/urgency** (see Output Requirements).

### Phase 4: Reconcile and Update Documentation and Logs

1. **Changelog:** For each verified completion that is not yet reflected in `project/changelog/`, add or update an entry per project conventions (e.g. `project/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and a row in `project/changelog/index.md`). For false completions, do not add a changelog entry claiming the fix; optionally add an entry only when the developer actually implements the fix.
2. **Troubleshooting:** If a task was about a bug or incident, ensure `project/troubleshooting/` has an entry that matches the fix (or a note that it is still open). Update or add entries only for **verified** fixes. File into the appropriate category subfolder (`build/`, `runtime/`, `data/`, `environment/`, `security/`) and add a row at the **top** of `project/troubleshooting/index.md`.
3. **Plans-Completed:** If a plan or implementation document is fully completed and should be archived:
   - Move the plan from `project/plans/` or `project/build/` to the appropriate category subfolder in `project/plans-completed/` (`implementation/`, `investigation/`, `migration/`, `review/`, `tooling/`)
   - If no appropriate subfolder exists, create one with a descriptive name (kebab-case)
   - Add a row at the **top** of `project/plans-completed/index.md` with: Date, Category, Title, File path, Notes
   - Add a Type=`plan` row at the **top** of `project/changelog/index.md` referencing the completed plan file
4. **Related docs:** Update `docs/` (e.g. ARCHITECTURE, USER_MANUAL, OVERVIEW, TROUBLESHOOTING) so they do not contradict the verified state. Remove or correct any doc text that claims something is done when it is flagged as not done.
5. **plans/TODO.md:** When tasks are completed, update `plans/TODO.md` (check off items or add follow-ups as needed).
6. **Plan/report file:** Write back into the plan/report file:
   - **✅** on tasks and sub-tasks that were verified complete
   - **Remove** or **replace** completion markers from tasks that were flagged (leave as unchecked `[ ]` or add a "⚠ False completion" / "⚠ Incomplete" note). Do not use "x" or ✓ for completed; use **✅ (green check mark)** only for consistency.

### Phase 5: Produce Flagged Issues Report
1. **Single ordered list:** "Flagged issues" in **descending order of importance or urgency.**
2. **Format each item:** Priority (P0/P1/P2/P3), Severity (S0–S3), Task ID/heading, Flag type (False completion / Incomplete / Not implemented / Docs not updated), one-line summary, and file/line or doc reference.
3. **Placement:** At the top of the workflow output or in a dedicated "Flagged issues" section so the developer sees the most critical items first.

## Output Requirements

### In the plan/report file
- **Completed tasks:** Mark with **✅** (green check mark) only. Use `[✅]` for checkboxes. Do not use "x", ✓, or other symbols for completed items—use ✅ consistently. Keep "Implementation Verified" and "Verification" sections accurate.
- **Flagged tasks:** Do not mark with ✅. Add a short note (e.g. "⚠ False completion" or "⚠ Incomplete — see verification") and leave checkboxes as `[ ]` or update status to "NOT COMPLETE" where applicable.

### Flagged issues list (descending order)
Display **all** flagged issues in **descending order of importance or urgency**, for example:

```markdown
## Flagged issues (descending order of importance/urgency)

1. **P0 / S1** — P1-1: Remove IPC API Key Exposure — **Incomplete.** Plan says "proxy handlers present" but `get-api-key` handler still exposed in `desktop/main.ts:292-294`. Renderer can still obtain raw key.
2. **P1 / S2** — Phase 2 Exit Criteria: "Documentation updated for web deployment" — **Docs not updated.** No changelog or docs entry found for web deployment requirements.
3. **P2 / S2** — P2-1: Schema Validation — **False completion.** Marked deferred but checklist item "Update docs" was checked; no doc change found.
…
```

### Reconciled artifacts
- **Changelog:** New or updated entries only for **verified** completions; index updated.
- **Troubleshooting:** Entries match verified fixes; open issues clearly marked; filed in appropriate subdirectories.
- **Plans-Completed:** Completed plans filed in appropriate category subdirectories (`implementation/`, `investigation/`, `migration/`, `review/`, `tooling/` or custom); index updated with entries at top.
- **Docs:** No claims that contradict verification (e.g. remove "API key is never sent to renderer" if P1-1 is still incomplete).

## Acceptance Criteria
- Every task/sub-task in scope that is marked "complete" in the plan has been verified against the codebase (and docs where relevant).
- Verified completions are marked with ✅ (and `[✅]` where applicable); false or incomplete claims are flagged and not marked complete.
- All flagged issues are listed in **descending order of importance or urgency** (P0→P3, S0→S3).
- Changelog, troubleshooting, and related docs are reconciled with the verified state (no false claims in docs).
- Parallel agents were used to verify implementation (multiple agents reading code in parallel batches).

## Related Workflows

- **[`01-create-docs.md`](./01-create-docs.md)** — Create documentation from scratch
- **[`02-sync-documentation.md`](./02-sync-documentation.md)** — Sync existing docs to code
- **[`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)** — Severity/priority for ordering flagged issues
- **[`../01-planning/02-finalise-plan.md`](../01-planning/02-finalise-plan.md)** — Finalise plans before marking completed

## Notes
- **Parallel agents:** Use as many agents as needed to cover P0–P3 and different areas (security, hooks, components, docs) so verification runs in parallel and finishes faster.
- **Evidence:** Every "Verified" or "Flagged" conclusion must cite the actual file path and, where useful, line number or snippet.
- **Developer decides:** Flagging an item does not mean you change the code; it means you surface it so the developer can decide to implement, defer, or re-scope.
- **One source of truth:** After this workflow, the plan/report and the changelog/troubleshooting/docs should agree on what is actually done.
