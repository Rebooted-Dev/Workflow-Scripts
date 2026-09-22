# Workflow: Mark Completed and Verify Implementation

## Purpose
Inspect the codebase and verify that all reported completed tasks were actually implemented. Mark truly completed tasks and sub-tasks with green check marks (✅). Flag instances of false reporting (incomplete or not done) so the developer can decide what to do. Reconcile and update related documentation, changelog, and troubleshooting logs at locations resolved from the host repository's metadata policy.

> **Sole terminal authority.** This is the **only** workflow in the chain that may apply terminal `✅` task marks, create a completion marker, reconcile changelog/troubleshooting/docs, and archive a plan. `01-execution` and `02-confirm-execution` report verification and may **downgrade** false claims; they must **not** independently finalize or archive. The combined workflow reaches this gate only on a `Verified Complete` outcome (see [`../02-code-build/03-execute-and-confirm.md`](../02-code-build/03-execute-and-confirm.md)). Archive routing is resolved from the **host repository's** policy, not a global default (Phase 4 below).

## When to Use This Workflow

**Use this workflow when:**
- A plan or implementation report claims tasks are "complete" and you need to confirm they were actually done
- Before closing a milestone or marking a plan as finished
- After a code review or refactor to ensure checklist items match reality
- When reconciling active plans under the host-resolved `<metadata-root>` with its changelog, troubleshooting, and documentation locations

**Use [`02-sync-documentation.md`](./02-sync-documentation.md) instead when:**
- Documentation is outdated but there is no "completed task" verification focus
- You are syncing docs to code without auditing completion claims

## Inputs
- Repository root
- Plan or report files that declare completed tasks (resolved via active-plan discovery in Phase 1: named target first, then `<metadata-root>/plans/**` and the host-permitted `<metadata-root>/build/**` location — never archived plans by default)
- Changelog index and entries under the host-resolved `<metadata-root>/changelog/`, using the authoritative [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy; honor a host-documented single-file changelog fallback
- Troubleshooting index and entries under the host-resolved `<metadata-root>/troubleshooting/`, honoring the host's existing troubleshooting categories and any documented single-file troubleshooting fallback
- A host-maintained TODO file, when present, resolved as `<metadata-root>/plans/TODO.md` through the same metadata-root and host-policy rules
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
│          SIZE VERIFICATION SCOPE               │
├───────────────────────────────────────────────┤
│ Localized: one primary verifier, no fan-out   │
│ Bounded: 2–3 focused, non-overlapping roles   │
│ Broad/high-risk: evidence-justified domain    │
│ roles in parallel under the shared policy     │
└────────────────────────┬──────────────────────┘
                         │
                         ▼
┌───────────────────────────────────────────────┐
│       DIRECT OR SIZED DOMAIN VERIFICATION      │
│ Batch reads are possible; concurrency is not   │
│ required. Domains converge on collected        │
│ evidence and the task coverage matrix.         │
└────────────────────────┬──────────────────────┘
                         │
                         ▼
               ┌──────────────────┐
               │ Collect results  │
               │ and reconcile    │
               └────────┬─────────┘
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
1. **Locate the plan/report file** that declares completed tasks, using deterministic active-plan discovery:
   - **Named target first** — if a plan path/name was supplied, use it.
   - Otherwise search **only** `<metadata-root>/plans/**`; search `<metadata-root>/build/**` only when the host policy or `plans/README.md` explicitly permits that location.
   - **Never scan host-policy archive locations by default**; archives are historical, not active claims.
   - Exclude `README.md`, `TODO.md`, review artifacts, and other navigation/report-only files unless explicitly named.
   - If multiple candidates remain, report them and ask for a named target rather than guessing.
2. **Extract claimed completions:** For each file, list every task/sub-task that is marked complete (e.g. `[✅]`, "COMPLETE", "Implementation Verified" with no "NOT COMPLETE" note). **Use only ✅ (green check mark) for marking completed items—not "x", ✓, or other symbols—for consistency.**

### Phase 2: Verify Implementation in Code (Sized Verification)
Size the named plan before assigning verification. Use the smallest approach that provides complete evidence:

- **Localized plans:** verify directly with one primary verifier; no fan-out is required.
- **Bounded plans:** use 2–3 focused, non-overlapping roles when the plan has independent evidence areas.
- **Broad/high-risk plans:** use parallel, evidence-justified domain roles under the [shared agent-spawning policy](../00-Meta-Workflow/00-meta/agent-spawning-policy.md).

Domains are coverage categories, not an agent-count mandate. For a localized plan, one verifier may cover several or all domains. Each verifier should read the **actual source files** referenced in the task (file paths, line numbers) and confirm that the described fix or feature exists.

**Suggested verification domains (select only those justified by the named plan; assign one responsible domain/verifier per task):**

- **Critical path and data integrity:** Verify P0/P1 claims affecting the primary execution path, persistence, migrations, or data correctness using the plan-derived files and line ranges.
- **Security and platform boundaries:** Verify authentication, authorization, secrets, permissions, deployment, runtime, or platform-integration claims using the plan-derived files and line ranges.
- **Bugs, state, and concurrency:** Verify behavioral fixes, state transitions, asynchronous work, error handling, and regression claims using the plan-derived files and line ranges.
- **UX and integration:** Verify user-facing behavior, accessibility, API contracts, and external-service integration claims using the plan-derived files and line ranges.
- **Maintainability and performance:** Verify lower-priority refactors, complexity, performance, testability, and cleanup claims using the plan-derived files and line ranges.
- **Documentation and logs:** Verify documentation, changelog, troubleshooting, plan, and archive claims against the plan-derived files and line ranges.

Role allocation is bounded by evidence and follows the [shared agent-spawning policy](../00-Meta-Workflow/00-meta/agent-spawning-policy.md). For every selected plan, create a task-to-verifier coverage matrix mapping every in-scope task/sub-task to one responsible domain/verifier, the plan-derived files and line ranges, and verification evidence or a flag. One verifier may own multiple rows; no in-scope task/sub-task may be left unmapped.

Verifiers may **batch-read files** (e.g. read all files for their task subset together) to maximize speed, but concurrency is not required. Output per verifier:
- **Task ID / heading** and **Claim** (what the plan says is done)
- **Files read** (paths and line ranges)
- **Verified?** Yes / No / Partial
- **Evidence** (exact code or doc snippet that confirms or contradicts)
- **Flag** (if not done: "False completion", "Incomplete", "Not implemented", or "Docs not updated")

Do not spawn unbounded agents; assign only bounded, plan-derived tasks and follow the [shared agent-spawning policy](../00-Meta-Workflow/00-meta/agent-spawning-policy.md) and its total-session cap.

### Phase 3: Mark Completed vs Flag False Reporting
1. **For each task/sub-task:**
   - If verification shows the implementation **is present and correct**: mark with **✅** (green check mark) in the plan/report. Ensure checkboxes are `[✅]` and any "Implementation Verified" or "Verification" section reflects reality.
   - If verification shows the implementation **is missing, partial, or incorrect**: do **not** add a green check mark. Instead **flag** the item for the developer.
2. **Flagging convention:**
   - **False completion:** Plan says complete but code/docs show no implementation
   - **Incomplete:** Only part of the task was done (for example, implementation evidence covers only part of the claimed task)
   - **Not implemented:** Task marked done but cited file/line does not contain the described change
   - **Docs not updated:** Plan says "documentation updated" but changelog/troubleshooting/docs have no corresponding entry or the entry is wrong
3. **Collect all flagged issues** and list them in **descending order of importance/urgency** (see Output Requirements).

### Phase 4: Reconcile and Update Documentation and Logs

1. **Changelog:** For each verified completion that is not yet reflected in the host-resolved changelog, add or update an entry using `<metadata-root>/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and its index, unless the host documents a single-file changelog fallback. Resolve the location through [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy. For false completions, do not add a changelog entry claiming the fix; optionally add an entry only when the developer actually implements the fix.
2. **Troubleshooting:** If a task was about a bug or incident, ensure the host-resolved troubleshooting location has an entry that matches the fix (or a note that it is still open). Resolve the location through [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy. Update or add entries only for **verified** fixes. Honor host-existing troubleshooting categories, or a host-documented single-file troubleshooting fallback, and add a row at the **top** of the applicable index.
3. **Plans-Completed (host-policy archive routing):** This workflow is the **only** one that archives a completed plan. Resolve the destination from the host repository's policy — do **not** impose a global default:
    - Read the host repository's `AGENTS.md` and relevant project docs for the documented completed-plan destination. Host policies may use a metadata-root location or another explicitly documented location; do not infer or create a new archive default.
    - Apply the host's documented default, and honor an explicit alternate request **only** when the host policy documents/allows that override.
    - Move the plan from its active location to the host-policy destination (into the appropriate category subfolder where the host uses them: `implementation/`, `investigation/`, `migration/`, `review/`, `tooling/`, or a descriptive kebab-case folder).
    - Add a row at the **top** of the host's completed-plans index with: Date, Category, Title, File path, Notes.
    - Add a Type=`plan` row at the **top** of the host's changelog index referencing the completed plan file.
    - **If the host policy is absent, unreadable, or contradictory:** report **`Not Eligible` / policy unresolved** and leave the plan active. Do not guess, migrate records, or invent a destination.
4. **Related docs:** Update `docs/` (e.g. ARCHITECTURE, USER_MANUAL, OVERVIEW, TROUBLESHOOTING) so they do not contradict the verified state. Remove or correct any doc text that claims something is done when it is flagged as not done.
5. **TODO:** When tasks are completed, update `<metadata-root>/plans/TODO.md` only if the host maintains that file; otherwise record any follow-up in the host-documented task location. Resolve the location through [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy.
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

Illustrative example only (hypothetical consumer project; do not treat paths or findings as required):

```markdown
## Flagged issues (descending order of importance/urgency)

1. **P1 / S2** — Task-1: Validate the primary flow — **Incomplete.** The claim is only partially supported by evidence in `src/entrypoint.ext:10-20`; record the missing verification and next step.
2. **P2 / S3** — Task-2: Update documentation — **Docs not updated.** No matching entry was found in the plan-derived documentation files.
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
- Verification is sized to the plan: one primary verifier for localized work, 2–3 focused non-overlapping roles for bounded work, or parallel evidence-justified domain roles for broad/high-risk work under the shared policy.
- The task-to-verifier coverage matrix maps every in-scope task/sub-task to a responsible domain/verifier and evidence or a flag; evidence citations support every Verified or Flagged conclusion.

## Related Workflows

- **[`01-create-docs.md`](./01-create-docs.md)** — Create documentation from scratch
- **[`02-sync-documentation.md`](./02-sync-documentation.md)** — Sync existing docs to code
- **[`../00-Meta-Workflow/00-meta/workflow-applicability.md`](../00-Meta-Workflow/00-meta/workflow-applicability.md)** — Size verification and delegation by scope
- **[`../00-Meta-Workflow/00-meta/severity-priority-rubric.md`](../00-Meta-Workflow/00-meta/severity-priority-rubric.md)** — Severity/priority for ordering flagged issues
- **[`../01-planning-and-organizing/02-finalise-plan.md`](../01-planning-and-organizing/02-finalise-plan.md)** — Finalise plans before marking completed

## Notes
- **Sizing:** Use the smallest verification approach that provides complete, evidence-backed coverage; parallel roles are for independent, evidence-justified scopes rather than a fixed count.
- **Evidence:** Every "Verified" or "Flagged" conclusion must cite the actual file path and, where useful, line number or snippet.
- **Developer decides:** Flagging an item does not mean you change the code; it means you surface it so the developer can decide to implement, defer, or re-scope.
- **One source of truth:** After this workflow, the plan/report and the changelog/troubleshooting/docs should agree on what is actually done.
