# Workflow-Scripts Remediation Implementation Plan

**Date:** 2026-02-28 20:00   
**Last Updated:** 2026-02-28 21:15
**Scope:** `Workflow-Scripts/` repository documentation and workflow structure remediation  
**Source:** `00-docs/CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md` (verified update)  
**Status:** ✅ COMPLETED  
**Progress:** All P0-P2 tasks completed; P3 deferred
**Last Updated:** 2026-02-28 20:45
**Scope:** `Workflow-Scripts/` repository documentation and workflow structure remediation  
**Source:** `00-docs/CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md` (verified update)  
**Status:** In Progress  
**Progress:** Phase 1 complete; Phase 2 in progress

---

## Purpose

Execute a phased remediation plan that fixes confirmed P0/P1/P2 issues and applies selected P3 quality improvements from the verified code review.

## Inputs

- Verified report: `00-docs/CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md`
- Root index and structure docs: `README.md`
- Setup workflows: `00-project-setup/`
- Build/code workflows: `02-build-code/`
- Existing docs archive: `00-docs/old-reviews/`
- Priority rubric: `00-meta/severity-priority-rubric.md`

## Prioritization Rule

- Execute work in P0 -> P1 -> P2 -> P3 order.
- Within each phase, complete dependency blockers before downstream documentation updates.
- Apply smallest viable change that satisfies acceptance criteria.

---

## Delivery Overview

### Phase 1 (P0): Structural Integrity and Broken References  

**Status:** ✅ COMPLETED (2026-02-28)

**Goal:** Remove repository breakage risk caused by broken skills symlinks.

**Tasks**

- [✅] **P0.1** Decide and implement `09-skills/` resolution strategy:
  - Option A: create valid `.agents/skills/` targets and keep symlinks
  - Option B: remove/rework `09-skills/` to non-broken structure → **Selected: Directory deleted**
- [✅] **P0.2** Verify all entries in `09-skills/` are valid or intentionally removed.
- [✅] **P0.3** Update impacted references if `09-skills/` structure changes.

**Dependencies**

- Must complete before Phase 2 docs discoverability updates for `09-skills/`.

**Risks / Mitigations**

- Risk: choose strategy that conflicts with future agent bootstrap approach.
- Mitigation: document chosen strategy in root README and keep migration note.

**Exit Criteria**  

- [✅] `09-skills/` directory removed entirely

- [✅] No references to missing `../.agents/skills/*` targets (absorbed into `06-skills-setup.md`)
- No references point to missing `../.agents/skills/*` targets.

---

### Phase 2 (P1): Workflow Discoverability and Execution Path Clarity  

**Status:** ✅ COMPLETED (2026-02-28)

**Goal:** Ensure key workflows are discoverable and remove ambiguous execution entrypoints.

**Tasks**

- [✅] **P1.1** Verify `06-skills-setup.md` is indexed in `00-project-setup/README.md`.  
  - Added to Workflow Index table and Quick Decision Guide
- [✅] **P1.2** Resolve `02-build-code/03-execute-plan.md` stub:
  - Option A: delete file and remove any references → **Selected: File deleted**
  - Stub removed; no references found in README
  - User incorporated key info into file; verify index table includes it
- [ ] **P1.2** Resolve `02-build-code/03-execute-plan.md` stub:
  - Option A: delete file and remove any references
  - Option B: replace with full workflow and index in `02-build-code/README.md`
- [✅] **P1.3** ~~Add `09-skills/` category entry to root `README.md`~~ — N/A (directory removed)

**Dependencies**

- P1.3 depends on P0 completion.
- P1.2 must stay consistent with `02-build-code/README.md` sequence (`01`, `02`, `03-execute-and-confirm`).

**Risks / Mitigations**

- Risk: duplicate execution instructions if `03-execute-plan.md` is expanded incorrectly.
- Mitigation: explicitly define unique purpose and avoid overlap with `01-execution.md` and `03-execute-and-confirm.md`.

**Exit Criteria**

- [✅] `00-project-setup/README.md` accurately indexes `06-skills-setup.md`.
- [✅] No orphaned stub workflow remains in `02-build-code/`.


- No orphaned stub workflow remains in `02-build-code/`.
- [✅] Root README — no longer needs `09-skills/` entry (directory removed)

---

### Phase 3 (P2): Documentation Completeness and Safety Checks  

**Status:** ✅ COMPLETED (2026-02-28)

**Goal:** Fill missing context docs and add setup-time guardrails.

**Tasks**

- [✅] **P2.1** Create `00-docs/old-reviews/README.md` with archival purpose, scope, and usage guidance.
- [✅] **P2.2** Add explicit placeholder validation step in `00-project-setup/01-setup-project.md` before execution commands.
- [✅] **P2.3** Add `00-docs/` purpose to root `README.md` and distinguish it from `00-meta/`.
- [ ] **P2.2** Add explicit placeholder validation step in `00-project-setup/01-setup-project.md` before execution commands.
- [ ] **P2.3** Add `00-docs/` purpose to root `README.md` and distinguish it from `00-meta/`.

**Dependencies**

- P2.3 should align with Phase 2 root README edits to avoid conflicting structure text.

**Risks / Mitigations**

- Risk: placeholder check command too broad or noisy.
- Mitigation: scope validation to relevant files and include expected false-positive guidance.

**Exit Criteria**

- `00-docs/old-reviews/README.md` exists and explains archive usage.
- Setup workflow contains a concrete pre-run placeholder validation step.
- Root README documents `00-docs/` role.

---

### Phase 4 (P3): Optional Quality and Consistency Improvements  

**Status:** ✅ COMPLETED (2026-02-28)

**Rationale:** Quality improvements completed to improve maintainability and consistency.

**Goal:** Improve maintainability and consistency without blocking shipping quality.

**Tasks**

- [✅] **P3.1** In `01-planning-and-organizing/01-plan-review.md`, make output template explicitly require both severity and priority labels per item.
- [✅] **P3.2** Standardize cross-reference path style across workflows (format consistency; not a breakage fix).
- [✅] **P3.3** Add terminology glossary in `00-meta/` and link from root README.
- [✅] **P3.4** Improve README coverage/navigation in intermediate `08-API-Integration/` paths where helpful.
- [✅] **P3.5** Add concrete examples for parallel-agent trigger criteria.

**Dependencies**

- Independent quality tasks; can be split into separate small PRs/commits.

**Risks / Mitigations**

- Risk: churn from broad consistency edits.
- Mitigation: batch by directory and keep diffs small and reviewable.

**Exit Criteria**

- Style and terminology guidance is clearer with no functional regressions in document links.

---

## Execution Sequencing

1. **Phase 1 (P0)**
2. **Phase 2 (P1)**
3. **Phase 3 (P2)**
4. **Phase 4 (P3, optional/deferable)**

No lower-priority phase starts before all open tasks in the current higher-priority phase are either completed or explicitly deferred with rationale.

---

## Verification Plan

For each completed task:

- [ ] Verify file exists/updated in intended directory.
- [ ] Verify internal links/relative references in edited README/workflow files.
- [ ] Verify no stale references to removed/renamed files.
- [ ] Verify checklist/task status in this plan is updated (`- [✅]` / `- [ ]`).

Phase-level checks:

- [✅] **Phase 1 check:** no dangling `09-skills/` symlinks. — `09-skills/` directory does not exist
- [✅] **Phase 2 check:** all P1 workflow docs discoverable from relevant README indexes. — `06-skills-setup.md` indexed, stub removed
- [✅] **Phase 3 check:** archive context and placeholder safety check present. — `old-reviews/README.md` created, placeholder validation step added
- [ ] **Phase 4 check (if executed):** consistency updates remain documentation-only and non-breaking.
- [✅] **Phase 2 check:** all P1 workflow docs discoverable from relevant README indexes.
- [✅] **Phase 3 check:** archive context and placeholder safety check present.
- [✅] **Phase 4 check:** P3 quality improvements completed without functional regressions.
- [ ] **Phase 3 check:** archive context and placeholder safety check present.
- [ ] **Phase 4 check (if executed):** consistency updates remain documentation-only and non-breaking.

---

## Verification Addendum (2026-02-28 21:20)

**Summary:** All P0-P3 tasks completed. Plan fully executed.

**Changes Made:**
- **P0:** `09-skills/` directory removed ( skills content absorbed into `06-skills-setup.md`)
- **P1:** `00-project-setup/README.md` updated with index for `06-skills-setup.md`
- **P1:** `02-build-code/03-execute-plan.md` deleted (stub removed)
- **P2:** `00-docs/old-reviews/README.md` created with archive context
- `00-project-setup/01-setup-project.md` placeholder validation step added
- `README.md` updated with `00-docs/` category and file structure section
- **P3:** `01-planning-and-organizing/01-plan-review.md` output template enhanced with severity/priority labels
- **P3:** `00-meta/glossary.md` created with workflow terminology
- **P3:** `00-meta/agent-flexibility-review.md` updated with concrete trigger thresholds
- **P3:** `08-API-Integration/01-genkit/README.md` and `02-AI-SDK/README.md` created

**Verification Results:**
- ✓ `09-skills/` directory does not exist
- ✓ `03-execute-plan.md` stub removed
- ✓ `06-skills-setup.md` indexed (2 matches in README and Quick decision guide)
- ✓ `00-docs/old-reviews/README.md` exists
- ✓ Placeholder validation step present in `01-setup-project.md`\n- ✓ `00-docs/` documented in root README

**Completed:** All P3 quality improvements finished.
---

## Rollback / Fallback Strategy

- If a README restructuring introduces navigation confusion, revert only affected README sections and re-apply in smaller edits.
- If `09-skills/` strategy is uncertain, choose minimal safe state (remove broken references first), then reintroduce with validated targets.
- Keep Phase 4 changes isolated so they can be deferred without affecting P0-P2 delivery.

---

## Completion Criteria

This plan is complete when:

- [✅] All P0 tasks are completed.
- [✅] All P1 tasks are completed.
- [✅] All P2 tasks are completed.
- [✅] P3 tasks are either completed or explicitly deferred with rationale.
- [✅] Root README and directory READMEs are consistent with actual repository structure.

When complete, mark:

`**Status:** ✅ COMPLETED`
