# Workflow: Mark Completed and Verify Implementation

## Purpose
Inspect the codebase and verify every task in the plan, whether it is already ticked or not. Mark truly completed tasks and sub-tasks with green check marks (✅). Flag instances of false reporting (incomplete or not done) so the developer can decide what to do. Reconcile and update related documentation, changelog, and troubleshooting logs at locations resolved from the host repository's metadata policy, and — in Full completion mode — file the completed plan package (plan plus its task-exclusive artifacts).

> **Terminal authority (plan level).** This is the **only** workflow that applies **plan-level** terminal actions: the plan completion marker, the archive moves for the completed **package** — the plan plus its task-exclusive historical artifacts listed in the plan's `## Artifact lifecycle` inventory — and the tick of the plan's designated gate-owned terminal filing pair ([Artifact Lifecycle and Terminal Filing](../00-Meta-Workflow/00-meta/plan-template.md#artifact-lifecycle-and-terminal-filing)). **Task-level** `[✅]` marks are not reserved to this gate. `01-execution` ticks each task as its Verification Bar passes, and `02-confirm-execution` corrects ticks in both directions. This gate makes every task mark match verified reality: it adds `✅` to verified tasks that are still `[ ]` and removes `✅` from unverified ones. Archive routing is resolved from the **host repository's** policy, not a global default (Phase 4 below).

## Modes

The execute-and-confirm chain ([`../02-code-build/03-execute-and-confirm.md`](../02-code-build/03-execute-and-confirm.md)) runs this gate at the end of **every** execution, whatever the outcome. The outcome only chooses the mode:

| Mode | When | Runs | Does not run |
|------|------|------|--------------|
| **Full completion** | `Verified Complete`: every applicable Verification Bar item passed, evidence present, no blocker — every committed in-scope task and criterion verified **except** the designated terminal filing pair (separately documented external/non-goal debt stays open and routed without blocking) | Phases 1–5 in full, with Phase 4 executed in order **1, 2, 4, 5, 6, 7, then the deferred step 3** (package filing) | — |
| **Reconcile only** | `Not Eligible`: any check blocked, skipped, failed, partial, or under-evidenced | Phases 1–3; Phase 4 steps 1, 2, 4, 5, 6, 7; Phase 5 | Plan completion marker; Phase 4 step 3 (package filing). The plan stays active. |

In **Reconcile only** mode, individually verified tasks still get `✅`. A blocked sibling task or a blocked plan-level check is **never** a reason to leave a verified task unticked. The designated terminal filing pair stays `[ ]` with its `Open: pending` in both modes until step 3 verifies the filing.

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
- A host-maintained TODO file or other host-documented follow-up task location, when present, resolved through the same metadata-root and host-policy rules
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
2. **Extract the full task list:** For each file, list **every** in-scope task/sub-task and its current state: ticked (`[✅]`, `[x]`, `[✓]`), unticked (`[ ]`), or claimed complete in prose ("COMPLETE", "Implementation Verified", a phase report, or an execution addendum). Recognise checkbox syntax in both bulleted (`- [ ]`) and numbered (`1. [ ]`) lists. **Unticked tasks are in scope:** execution often lands and verifies work without ticking the box, so a `[ ]` task whose implementation and evidence are present must be verified and ticked, not skipped. **Use only ✅ (green check mark) for marking completed items—not "x", ✓, or other symbols—for consistency.** Normalise existing `[x]`/`[✓]` ticks to `[✅]` when they verify, and reset them to `[ ]` when they do not. **`## Success Criteria` checkboxes are in scope** and are verified and marked like tasks. **A plan without checkboxes** (prose steps, or YAML `todos:` from another tool) is converted first, per the [Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract): add a `## Tasks` list with one checkbox per step and the `**Tier:**` header, leave the original text in place, then verify that list.
3. **Establish or validate the artifact lifecycle intake (before any task-coverage, eligibility, or lint decision):**
   - If the plan has no `## Artifact lifecycle` inventory, add a proportional one now (at minimum a row for the plan itself) per the [Artifact Lifecycle and Terminal Filing](../00-Meta-Workflow/00-meta/plan-template.md#artifact-lifecycle-and-terminal-filing) contract — even when the plan already has `## Tasks` and a Tier header. No tier upgrade, no history rewrite.
   - Validate that the plan contains **exactly one** explicitly designated gate-owned terminal filing task and **exactly one** paired filing criterion. A missing task or criterion is an independent repair: add the missing half of the pair now. Duplicate or ambiguous pairs **block**: ask for explicit intake clarification of the designated pair — do not guess or silently collapse them; filing stays blocked until resolved.
   - This intake runs here, up front — never deferred into Phase 4 step 3.

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
   - If verification shows the implementation **is present and correct**: mark with **✅** (green check mark) in the plan/report, whether the task was previously `[ ]` or already ticked. Ensure checkboxes are `[✅]` and any "Implementation Verified" or "Verification" section reflects reality. Parent tasks get `[✅]` only when all their sub-tasks are `[✅]`.
   - If the task is **not complete for a known reason** (not started, blocked, deferred, or retired by the owner): leave it `[ ]` and write its `Open:` reason. A retired task is never ticked and never deleted.
    - If verification shows the implementation **is missing, partial, or incorrect**: do **not** add a green check mark. Instead **flag** the item for the developer.
   - **Terminal filing pair exception:** the designated gate-owned terminal filing task and its paired criterion are assessed here for identity and prerequisites only (exactly one designated pair, `Files:`/`Verify:` present, prerequisites understood). Their filing **effects** are verified and ticked only in Phase 4 step 3. A task that implements filing behavior for other plans is an ordinary implementation task and does not complete this plan's own filing.
2. **Flagging convention:**
   - **False completion:** Plan says complete but code/docs show no implementation
   - **Incomplete:** Only part of the task was done (for example, implementation evidence covers only part of the claimed task)
   - **Not implemented:** Task marked done but cited file/line does not contain the described change
   - **Docs not updated:** Plan says "documentation updated" but changelog/troubleshooting/docs have no corresponding entry or the entry is wrong
3. **Collect all flagged issues** and list them in **descending order of importance/urgency** (see Output Requirements).

### Phase 4: Reconcile and Update Documentation and Logs

> **Execution order:** perform steps 1, 2, 4, 5, 6, and 7 **first**; the deferred step 3 (package filing) runs **last**, only in Full completion mode, and only after step 7 passes on the plan's current path. Step numbering is unchanged.

1. **Changelog:** For each verified completion that is not yet reflected in the host-resolved changelog, add or update an entry using `<metadata-root>/changelog/<type>/<yyyy-mm-dd>-<type>-<short-title>.md` and its index, unless the host documents a single-file changelog fallback. Resolve the location through [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy. For false completions, do not add a changelog entry claiming the fix; optionally add an entry only when the developer actually implements the fix.
2. **Troubleshooting:** If a task was about a bug or incident, ensure the host-resolved troubleshooting location has an entry that matches the fix (or a note that it is still open). Resolve the location through [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy. Update or add entries only for **verified** fixes. Honor host-existing troubleshooting categories, or a host-documented single-file troubleshooting fallback, and add a row at the **top** of the applicable index.
3. **Plans-Completed package filing (host-policy archive routing) — Full completion mode only; deferred until steps 1, 2, 4, 5, 6, and 7 have run:** This workflow is the **only** one that files a completed plan or its package. Skip this step entirely in Reconcile only mode. Resolve everything from the host repository's policy — do **not** impose a global default destination or bundle layout:
    - Read the host repository's `AGENTS.md` and relevant project docs for the documented completed-plan destination. Host policies may use a metadata-root location or another explicitly documented location; do not infer or create a new archive default. Apply the host's documented default, and honor an explicit alternate request **only** when the host policy documents/allows that override.
    - Work from the plan's `## Artifact lifecycle` inventory ([contract](../00-Meta-Workflow/00-meta/plan-template.md#artifact-lifecycle-and-terminal-filing)); if the plan has none, add a minimal one first (at minimum the plan itself) without upgrading its tier or rewriting history. Before any move, decide ownership, active consumers, and privacy per row: **retain** live product docs, changelog/troubleshooting entries, shared or active research, and other repositories' records in their owner's canonical location, and link each retained row with its reason — never move another repository's records or duplicate/delete active shared research. Exclude or sanitize sensitive evidence per the host privacy policy **before** it enters the archive; record safe metadata (what was excluded and why), never secret values.
    - **If the host policy is absent, unreadable, or contradictory: block the filing.** Report **archive blocked: policy unresolved** (or the specific conflict), name the conflicting sources (file and line), tick every verified non-filing task, leave the filing pair `[ ]` with `Open: blocked`, record `Package filing: BLOCKED`, apply **no** moves and **no** `✅ COMPLETED` marker, and list the conflict first in the Phase 5 flagged issues. Do not guess, migrate records, or invent a destination.
    - Move the task-exclusive historical artifacts — the plan, superseded source plans, review archives, research, and evidence — to the host-policy destination (into the appropriate category subfolder where the host uses them: `implementation/`, `investigation/`, `migration/`, `review/`, `tooling/`, or a descriptive kebab-case folder), moving the main plan file last where practical. Record source→destination mappings before moving, and move with **no overwrites**. On resume: a mapping with only the source present may move; only the destination present must match the recorded artifact exactly before proceeding; both or neither present → stop and investigate. Do not create duplicate index rows.
    - After the moves: rebase the package's outgoing links and every identified inbound reference to the new paths, and add a row at the **top** of the host's completed-plans index (Date, Category, Title, File path, Notes) plus a Type=`plan` row at the **top** of the host's changelog index referencing the final plan path. Verify the inventory against disk and report any missing artifact; route open Deferred & Debt per step 5. Run the scoped link helper for the moved paths and affected incoming files: `bash <workflow-scripts>/scripts/validation/check-active-markdown-links.sh --root <owning-repository-root> --scope <archived-plan-or-dir> --scope <affected-incoming-file>` (repeat `--scope` per path; read-only; anchors are not checked). A scoped outgoing pass is **not** coverage proof: separately verify the inventory, the indexes, and all identified inbound references.
    - **Before final marking:** after these filing effects verify, run `check-plan.sh --require-tier --state` on the **actual current plan path**, with the filing pair still unchecked and explained; it must print `OK` there. Only after that check passes, record `Package filing: VERIFIED`, tick the terminal filing task and its paired filing criterion, and apply the completion marker (`**Status:** ✅ COMPLETED`) when implementation verification is also VERIFIED. **After final marking:** re-run the same combined check on the actual current plan path to validate the status/tick edits. Publish a successful filing report only after this post-edit check passes; otherwise apply the failure rule below.
    - **If the final-path lint, link, or index verification fails:** remove the `✅ COMPLETED` marker, reset the affected filing pair to `[ ]` (`Open: blocked` when nothing moved; `Open: pending` with `Package filing: PARTIAL` and the moved paths when some artifacts moved), report the actual current path, preserve every non-filing mark, re-run the state check to reconcile, and make **no further moves** this run.
    - **Already-filed plans and revalidation:** never blindly reset a previously verified filing pair or a recorded `BLOCKED`/`PARTIAL` reason to `pending`. When revalidating an already-filed plan, preserve its existing verified filing proof and locations until contrary evidence; skip the actual moves when the recorded source→destination mappings already match disk exactly and all effects verify without creating duplicate index rows.
    - **Partial attempts and resume:** an interrupted or failed Full-completion filing may leave some artifacts already moved; record exactly what moved — no automatic rollback is promised, and do not pretend a failed attempt left everything unmoved. If the outcome becomes `Not Eligible` after a partial attempt, make **no further moves** (finish the remaining steps in their Reconcile-only form), leave the filing pair `[ ]` reporting `Package filing: PARTIAL` with the named partial paths, and resume later from the recorded mappings — by naming the target explicitly, since active-plan discovery never scans archive locations by default — without overwriting or duplicating index rows.
4. **Related docs:** Update `docs/` (e.g. ARCHITECTURE, USER_MANUAL, OVERVIEW, TROUBLESHOOTING) so they do not contradict the verified state. Remove or correct any doc text that claims something is done when it is flagged as not done.
5. **Reconcile host task tracking and open Deferred & Debt (both modes):** Resolve the host-maintained TODO or other host-documented task location through [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md) and host policy.
   - **Verified plan tasks:** Reconcile existing TODO/task entries for each task whose implementation and acceptance evidence are verified; mark those entries completed. Leave entries for blocked or otherwise unverified tasks open.
   - **Open Deferred & Debt:** Transfer every open plan entry into the resolved host task location unless it is already represented there; preserve its location, trigger, and severity. Keep each debt item open in both the plan and tracker while remediation remains outstanding.
   - **Trigger and closure:** A trigger prompts reassessment and scheduling; it does not close the debt. Close an entry only after the remediation and its acceptance criteria are verified, or an explicit decision to retire it is recorded in the plan (and host tracker when available). Otherwise preserve it as open in the plan and host task tracker.
   - **No documented location:** Do not invent a TODO or task-tracker destination. Report the routing as unresolved and preserve each open debt item in the plan; do not claim it was transferred.
   - This reconciliation runs in both Full completion and Reconcile only modes and belongs to this terminal gate; execution and confirmation do not perform a competing task-tracker or debt-to-TODO reconciliation.
6. **Plan/report file:** Write back into the plan/report file:
    - **✅** on tasks and sub-tasks that were verified complete, including tasks that were `[ ]` when this workflow started. The designated terminal filing pair stays `[ ]` until step 3 verifies the filing; it remains unchecked this run in Reconcile only mode, and a previously verified pair or a recorded `blocked`/`partial` reason is never reset to `pending` without contrary evidence.
    - **Status evidence, no final marker here:** write two distinct lines — `Implementation verification: VERIFIED` (or `NOT VERIFIED`) and `Package filing: PENDING` (or a previously recorded `BLOCKED`/`PARTIAL`, preserved unless contrary evidence; `VERIFIED` is set only by step 3). The final `**Status:** ✅ COMPLETED` marker is applied **only** in step 3, only when both lines read VERIFIED; a blocked or partial filing never carries it.
    - **Remove** or **replace** completion markers from tasks that were flagged (leave as unchecked `[ ]` or add a "⚠ False completion" / "⚠ Incomplete" note). Do not use "x" or ✓ for completed; use **✅ (green check mark)** only for consistency.
    - **`Open:` reason** on every task and criterion left `[ ]` ([Marking Contract](../00-Meta-Workflow/00-meta/plan-template.md#marking-contract)).
7. **State check (both modes, before any filing move):** run `bash <workflow-scripts>/scripts/validation/check-plan.sh --require-tier --state <plan>` (path per [`naming-conventions.md`](../00-Meta-Workflow/00-meta/naming-conventions.md#workflow-scripts-checkout)) — the gate's `check-plan.sh --state` run, combined with `--require-tier` so a tier-less plan cannot pass. It must print `OK (…, state)` on the plan's **current path before anything moves**; resolve each reported line by ticking a verified box or writing its `Open:` reason, and include the output line in the report. This step precedes the deferred step 3; step 3 rechecks the final archived path after the moves.

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
- **TODO/task location:** Verified task completions and open Deferred & Debt entries are reconciled in the host-maintained TODO or other host-documented follow-up location without duplicates. If routing is unresolved, that limitation is reported and open debt remains in the plan rather than being claimed as transferred.
- **Plans-Completed:** The completed **package** is filed in appropriate category subdirectories (`implementation/`, `investigation/`, `migration/`, `review/`, `tooling/` or custom) per host policy and the plan's `## Artifact lifecycle` inventory: task-exclusive historical artifacts moved, retained rows left in place and linked with their reason; indexes updated with entries at top; inbound references rebased.
- **Docs:** No claims that contradict verification (e.g. remove "API key is never sent to renderer" if P1-1 is still incomplete).

### Filing status and final path
The gate report always states, as two distinct facts:

- **Implementation verification:** `VERIFIED` or `NOT VERIFIED`.
- **Package filing:** `PENDING` (not attempted), `BLOCKED` (policy unresolved, or a required move/link/index check failed; nothing further may move), `PARTIAL` (a Full-completion attempt moved some artifacts but did not finish; the named partial paths are recorded for resume), or `VERIFIED` (step 3 completed and the final path passed the combined check).
- The **actual current path of the plan file** after the gate ran — the archived path once it has moved (even if other artifacts have not), the active path while it has not; after a partial filing, report each moved artifact's actual location. Every final check runs on this actual current path, never an assumed one. The final `✅ COMPLETED` marker is applied only when both facts are `VERIFIED`.

## Acceptance Criteria
- Every task/sub-task in scope has been verified against the codebase (and docs where relevant), including tasks that were unticked when this workflow started. No verified task or criterion is left `[ ]`, and every box that stays `[ ]` has an `Open:` reason.
- `check-plan.sh --state <plan>` passes in both modes (combined with `--require-tier`), its output line is in the report, and in Full completion mode the plan's **actual current path after the moves** passes the same combined check.
- The mode matches the outcome: Full completion requires `Implementation verification: VERIFIED` **and** `Package filing: VERIFIED` before the `✅ COMPLETED` marker; a pending, blocked, or partial filing never carries the marker. Reconcile only applies neither marker nor filing, and the plan stays active.
- Implementation-entry eligibility covers committed in-scope Tasks and Success Criteria, excluding only the designated terminal filing pair: deferred work committed inside the plan's scope keeps the plan `Not Eligible`, while separately documented external or non-goal debt stays open and routed without blocking.
- A previously verified filing pair or a recorded `BLOCKED`/`PARTIAL` filing reason is preserved across re-runs unless contrary evidence; an already-filed plan revalidates without duplicate moves or index rows when its mappings still match disk.
- The plan's `## Artifact lifecycle` inventory matches disk after the gate ran: task-exclusive historical artifacts moved per host policy with no overwrites or duplicate index rows; retained rows (live docs, changelog/troubleshooting, shared or cross-repo records) left in their owner's canonical location and linked with their reason; sensitive artifacts excluded or sanitized with safe metadata only; outgoing and identified inbound references rebased.
- Verified completions are marked with ✅ (and `[✅]` where applicable); false or incomplete claims are flagged and not marked complete.
- All flagged issues are listed in **descending order of importance or urgency** (P0→P3, S0→S3).
- Changelog, troubleshooting, the host TODO/task location, and related docs are reconciled with the verified state (no false claims in docs); unresolved task-location routing is reported and does not claim open debt was transferred.
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
