# 2026-09-22 16:37

# Reconcile v1.82-Fixes Research and Source Integrity

**Status:** Active — first executable lane; source recovery and reference repair pending

**Summary:** Safely reconcile the externally reorganized v1.82-fixes research set into a seven-source inventory. Recover the missing Astra protocol from tracked history, compare content and provenance before filing it in the new source location, map old paths to new paths, repair active inbound and outbound references, and preserve review addenda and supersession relationships. Commit only after validation and authorization.

## Source and review provenance

- Current source inputs: the six files in [`research/v1.82-fixes/`](../../research/v1.82-fixes/).
- Historical source needed to complete the inventory: `00-project/research/2026-09-10-astra-instruction-evaluation-protocol.md`, recoverable from tracked history with `git show`; do not recreate it from memory or from the Astra plan.
- Related archived record: [`Workflow-Scripts instruction remediation`](../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md).
- Advisory review inputs: the two independent read-only reviews and Oracle graph review supplied for this task. Their corrections are reflected in protected-dirty-state handling, history-based protocol recovery, explicit path/reference reconciliation, preserved addenda, and validation-before-commit. The inline harness review addendum in the finalized source plan remains advisory source material, not a second writer.

## P0–P3 priority roadmap

### P0 — preserve the external work and recover authoritative content

- [ ] 1. **(Small)** Record the repository root, branch, `HEAD`, upstream, and complete dirty-state inventory from the Workflow-Scripts repository. The observed baseline is branch `v1.82`, `HEAD` `6a25c36`, with deleted tracked legacy paths and an untracked `research/v1.82-fixes/` set; re-capture these facts at execution time.
- [ ] 2. **(Small)** Mark all pre-existing deletions, untracked reorganization files, and unrelated dirty paths as protected. Do not reset, clean, checkout, switch branches, rewrite history, or modify consumer repositories.
- [ ] 3. **(Small)** Inventory exactly seven source records: the six current source files plus the missing Astra protocol recovered from tracked history. Record old path, current/proposed path, source status, author/date metadata, and review/supersession relationship.
- [ ] 4. **(Medium)** Recover the protocol by inspecting tracked history, beginning with the commit that last recorded it (currently discoverable as `58689d8`), using `git show <commit>:<path>` or equivalent read-only history inspection. Compare the recovered bytes, headings, links, pin values, and provenance with the Astra plan and any historical protocol record before writing a new copy.

**Dependencies:** P0 safety baseline from [the meta roadmap](./00-meta-v1-82-fixes-roadmap.md). No source or reference write occurs until the protected baseline is captured.

### P1 — reconcile paths, references, and review state

- [ ] 1. **(Medium)** Build and review the old-to-new path map:
   - `00-project/research/2026-07-04-workflow-auto-trigger-skills-proposal.md` → `00-project/research/v1.82-fixes/2026-07-04-workflow-auto-trigger-skills-proposal.md`
   - `00-project/research/2026-08-08-workflow-completion-chain-remediation.md` → `00-project/research/v1.82-fixes/2026-08-08-workflow-completion-chain-remediation.md`
   - `00-project/research/2026-09-10-astra-instruction-evaluation-plan.md` → `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`
   - `00-project/research/2026-09-10-astra-instruction-evaluation-protocol.md` → `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-protocol.md`
   - `00-project/plans/2026-07-04-parallel-agent-harness-concept-test-plan.md` → `00-project/research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-plan.md`
   - `00-project/plans/2026-07-04-parallel-agent-harness-concept-test-implementation-plan.md` → `00-project/research/v1.82-fixes/2026-07-04-parallel-agent-harness-concept-test-implementation-plan.md`
   - `00-project/plans/workflow-enhancements/update-agents-files.md` → `00-project/research/v1.82-fixes/update-agents-files.md`.
- [ ] 2. **(Medium)** Search active Workflow-Scripts documentation, plans, indexes, and navigation for old paths and repair only active inbound/outbound references to the reconciled locations. Classify historical archived mentions separately; do not rewrite history merely to make an archived citation look current.
- [ ] 3. **(Medium)** Preserve the harness draft and finalized implementation plan as separate source records. Mark the finalized implementation plan as the sole authoritative successor, retain the draft as superseded review provenance, and preserve its inline review addendum rather than merging away evidence.
- [ ] 4. **(Small)** Preserve the Astra protocol's original provenance and its relationship to the Astra plan; do not claim that a reconstructed or inferred protocol is equivalent to the tracked source.

**Dependencies:** Tasks 1–4 require the P0 inventory and read-only comparison. Active-link repair must follow the path map and precede validation.

### P2 — validate the reconciliation and prepare the authorized commit

- [ ] 1. **(Medium)** Validate that all seven source records exist at their reconciled locations, content comparison is documented, internal links resolve or are explicitly historical, and no review addendum or supersession marker was lost.
- [ ] 2. **(Medium)** Re-run repository-wide searches for each old path and classify every remaining hit as an intentional historical record, a source/provenance statement, or an unresolved active reference. Resolve all active-reference hits before proceeding.
- [ ] 3. **(Small)** Compare the post-reconciliation dirty state with the protected baseline and prove that only explicitly authorized source/reference changes were added; treat unexpected changes as a blocker.

**Dependencies:** All P0/P1 tasks. Validation must pass before any commit proposal.

### P3 — commit only after approval

- [ ] 1. **(Small)** Obtain explicit authorization for the reconciled source/reference change set.
- [ ] 2. **(Small)** Stage only the validated reconciliation paths and commit only after the link, content, provenance, and dirty-state checks pass. Do not include this plan set, unrelated dirty work, consumer files, or untracked reorganization files outside the approved set.
- [ ] 3. **(Small)** Record the commit identifier and validation evidence for downstream Plan 05; if validation fails, leave the worktree untouched and return a blocker rather than guessing.

**Dependencies:** P2 validation and parent authorization. Plan 05 remains blocked until the protocol and its provenance are resolved.

## Scope and non-goals

In scope are the seven-source inventory, history-based protocol recovery, content/provenance comparison, path mapping, active reference repair, review-state preservation, and a tightly scoped authorized commit. Out of scope are research reinterpretation, source rewriting for style, production workflow/code changes, consumer repositories, branch operations, destructive cleanup, and Astra execution.

## Risks and mitigations

- **Protected dirty work is lost (S0/P0):** capture status and hashes before writes; never reset, clean, checkout, or switch branch.
- **Protocol is silently recreated (S1/P0):** use `git show` from tracked history, compare bytes and metadata, and retain the original path/commit provenance.
- **Review evidence is erased (S1/P1):** preserve both harness source files and explicitly record draft supersession and inline addenda.
- **A historical reference is incorrectly rewritten (S2/P2):** classify hits before editing; change only active inbound/outbound references.
- **Unvalidated files enter the commit (S1/P2):** stage only after link, provenance, and protected-scope validation; parent authorization is mandatory.

## Validation and objective exit criteria

**Validation owner:** parent orchestrator, with the Plan 01 lane executor producing evidence.

- The seven-source inventory names six current files plus the protocol recovered from a specific tracked revision.
- A content/provenance comparison shows what was recovered and why it matches the tracked source; no inferred substitute is accepted.
- The old-to-new path map is complete, active references resolve, and remaining old-path hits are classified as intentional history or eliminated.
- Draft/final harness supersession and all review addenda remain discoverable.
- Protected pre-existing dirty paths are unchanged; only authorized reconciliation paths are staged.
- A commit is made only after all checks pass and explicit authorization is recorded; otherwise the lane exits with a blocker and no commit.
