# Plan-Artifact Completion Filing Proposal (Research)

**Date:** 2026-10-06 15:04 (+08, Asia/Singapore)
**Model:** openai/gpt-6.1-sol
**Status:** PROPOSAL — not adopted. This document changes no workflow, template, script, or README; every change below is a recommendation pending adoption.
**Baseline:** Workflow-Scripts branch `v1.82`, HEAD `0adbe2d7913b622d0858f362a83ba57a8c75be16`, clean tree before this work.
**Evidence:** all existing-state claims were verified read-only against that baseline; proposed-state claims are labeled **proposed**.

## 1. Question and recommendation

Question: study all instruction files in `01-planning-and-organizing/` and `02-code-build/` and recommend where the lifecycle **generate plans → execute → package all associated docs/research/plans → file completed** belongs.

Recommendation (**proposed**): add no competing workflow. The existing terminal gate, [`04-documentation/03-mark-completed.md`](../../04-documentation/03-mark-completed.md), already declares itself the **only** workflow applying plan-level terminal actions — the completion marker and the archive move — with archive routing resolved from the host repository's policy ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:6`), and it is mandatory for every execution outcome ([`02-code-build/README.md`](../../02-code-build/README.md) `:37`). Extend that gate, mainly Phase 4 step 3 ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:154-160`), to carry an **associated-artifact inventory** and to verify the filed package before its own filing task is ticked.

Two placement roles, and only two (**proposed**):

1. **Seed role — inside plans.** Generated and finalised plans contain the inventory and one gate-owned terminal filing task, added through the shared template (§3, §4).
2. **Execute role — the terminal gate.** Only the gate performs the actual moves, links, verification, and the final tick of the filing task (§5).

The gate sits downstream of **both** directories the question names — not only the compound wrapper. [`02-code-build/04-review-finalise-commit-execute.md`](../../02-code-build/04-review-finalise-commit-execute.md) reaches it after planning (steps 1 and 3, `:22-36`), but the direct paths run it with no wrapper at all: [`01-execution.md`](../../02-code-build/01-execution.md) `:93` (gate always at finalization), [`02-confirm-execution.md`](../../02-code-build/02-confirm-execution.md) `:96-98` (hand-off for both outcomes), and [`03-execute-and-confirm.md`](../../02-code-build/03-execute-and-confirm.md) `:38-42` ("no path around the gate"). Anchoring filing in `04` alone would miss every direct execution and confirmation path.

## 2. Existing state (cited)

- **Completion ownership.** Gate modes: Full completion runs Phases 1–5; Reconcile only omits the marker and Phase 4 step 3 ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:12-17`). Task-level ticks are not gate-reserved: execution ticks as its Verification Bar passes, confirmation corrects both directions (`:6`; [`01-execution.md`](../../02-code-build/01-execution.md) `:22`).
- **Plan contract.** The shared template requires checkbox tasks with `Files:`/`Verify:` lines, priority and effort labels, and the Marking Contract's two-state ticking ([`plan-template.md`](../../00-Meta-Workflow/00-meta/plan-template.md) `:101-118`). It has no artifact-inventory or terminal filing concept today; `check-plan.sh` enforces structure and open-box hygiene only ([`plan-template.md`](../../00-Meta-Workflow/00-meta/plan-template.md) `:128-131`).
- **Associated artifacts today.** Research output and plan output are siblings with no lifecycle link between them ([`00-research-and-plan.md`](../../01-planning-and-organizing/00-research-and-plan.md) `:30-31`, `:170-205`). Review artifacts live in `PLAN.reviews/` ([`01-plan-review.md`](../../01-planning-and-organizing/01-plan-review.md) `:44-51`); finalisation marks the source plan superseded and moves `PLAN.reviews/` to `PLAN.reviews-archive/` ([`02-finalise-plan.md`](../../01-planning-and-organizing/02-finalise-plan.md) `:44-48`) — that archival of temporary reviews is **not** completion filing. Execution and confirmation hand off without moving anything ([`01-execution.md`](../../02-code-build/01-execution.md) `:89-94`; [`02-confirm-execution.md`](../../02-code-build/02-confirm-execution.md) `:96-98`). The gate archives the plan file alone, plus index rows ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:154-160`).

## 3. Plan-template artifact lifecycle contract (proposed)

Add one concise section to [`plan-template.md`](../../00-Meta-Workflow/00-meta/plan-template.md) beside the Task and Decision Requirements (`:101-118`), making it the source of truth other workflows reference (**proposed**):

- **Artifact inventory.** Each generated/finalised plan carries an inventory whose fields are, at minimum: artifact path, owning repository, relationship (e.g., research, source plan superseded, review archive, evidence), and disposition/destination or a retained-in-place reason. A finalised plan retains rows for its superseded source, review archives, and research/evidence. An optional summary or manifest link is permitted where useful — not required.
- **Terminal filing task.** Each plan ends with one gate-owned terminal task with the normal `Files:`/`Verify:` fields, a priority, an effort label, and a filing criterion (see §7). It is bookkeeping owned by the gate, never an implementation task.
- **Eligibility separation.** Committed implementation and acceptance eligibility exclude the unperformed gate-owned filing task **and its corresponding filing Success Criterion**, so a plan whose implementation is verified complete is not self-gated by its own unticked bookkeeping boxes. This exception applies only to terminal filing, not ordinary tests/docs/acceptance obligations; only the gate ticks those filing boxes, after verified filing (§5).
- **Proportionality.** A small T1 plan may use a single-row inventory and a short filing task. No elaborate manifest file, and no tier bump solely for filing.

## 4. Upstream insertion points (proposed)

| File | Existing anchor | Proposed insertion |
|---|---|---|
| [`plan-template.md`](../../00-Meta-Workflow/00-meta/plan-template.md) | `:101-118` | Artifact lifecycle inventory + terminal filing task contract (§3); single source of truth |
| [`00-research-and-plan.md`](../../01-planning-and-organizing/00-research-and-plan.md) | Phase 3.2 `:201-209`; outputs `:30-31`, `:170-205` | Initialize the inventory and terminal task via the shared template; list the research document as the first artifact |
| [`01-plan-review.md`](../../01-planning-and-organizing/01-plan-review.md) | Steps `:31-33`; Output `:59-74` | Check artifact coverage, ownership/disposition, and terminal-task presence; reference the shared contract, do not restate it |
| [`02-finalise-plan.md`](../../01-planning-and-organizing/02-finalise-plan.md) | Steps `:37-48` | Maintain the inventory while writing the new plan; record the superseded source (`:44`) and `PLAN.reviews/` → `PLAN.reviews-archive/` (`:45-48`) as inventory rows; note that archival ≠ completion filing |
| [`03-plan-review-and-finalise.md`](../../01-planning-and-organizing/03-plan-review-and-finalise.md) | Steps `:15-18`; no-duplication rule `:26` | Inherits both checks via the linked workflows; add no local rules |
| [`01-execution.md`](../../02-code-build/01-execution.md) | Finalization `:89-94` | Hand the updated inventory plus evidence to the gate; execution does not independently archive planning artifacts |
| [`02-confirm-execution.md`](../../02-code-build/02-confirm-execution.md) | Steps `:96-98` | Audit inventory/evidence completeness and hand off; confirmation moves nothing |
| [`03-execute-and-confirm.md`](../../02-code-build/03-execute-and-confirm.md) | Completion Bar `:24-27`; Steps `:37-44` | Full completion requires the bundled filing result returned by the gate |
| [`04-review-finalise-commit-execute.md`](../../02-code-build/04-review-finalise-commit-execute.md) | Steps `:26-31`, `:33-36` | Planning commit (`:26-31`) stays an optional user-selected checkpoint, not authorization to commit/push at close; gate step returns the final archived location; no generator step needed — Related already says use research first when no plan exists (`:62`) |
| [`01-planning-and-organizing/README.md`](../../01-planning-and-organizing/README.md) | Shared-template note `:82` | One-line parity reference to the artifact lifecycle contract |
| [`02-code-build/README.md`](../../02-code-build/README.md) | Gate paragraph `:37` | One-line parity reference: gate files the package; concise, no duplicate policy |
| [`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) | Phase 4 step 3 `:154-160` | The execute role itself (§5) |

## 5. Terminal filing sequence (proposed)

The gate's Phase 4 step 3 extension, in order (**proposed**):

1. Reconcile actual evidence against the plan: verified-but-unticked tasks get ticked; blocked tasks stay `[ ]` with explained reasons (existing rule, [`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:107`, `:140-141`).
2. Identify completed-implementation eligibility, **excluding** the exclusively gate-owned pending filing task and its corresponding filing Success Criterion (§3), avoiding self-gate deadlock.
3. Run `check-plan.sh --require-tier --state` on the plan **before** any move (flag combination already parses; see §6.4).
4. Apply the owner host's archive-policy mappings ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:154-156`; [`naming-conventions.md`](../../00-Meta-Workflow/00-meta/naming-conventions.md) `:48-54` — owning repository first; Workflow-Scripts' own metadata root is `00-project/`, `:54`).
5. Before moving, review artifact ownership, active consumers and privacy. Retain canonical live product docs, changelog, troubleshooting and shared/active research; link each retained row with its reason. Sanitize or exclude sensitive evidence per host policy before it enters the archive; record the exclusion and safe evidence reference, never secret values. Do not move another repository's records or duplicate/delete active shared research.
6. Move eligible task-exclusive historical artifacts: the plan, superseded source plans, review archives, research, and evidence. No invented directory tree: the category describes the work's purpose, not a bundle ID — host policy may keep dated siblings, a per-task directory, or a logical linked package. Example path (illustrative only): `<metadata-root>/plans-completed/<category>/<plan>.md` ([`naming-conventions.md`](../../00-Meta-Workflow/00-meta/naming-conventions.md) `:65`).
7. Reconcile the recorded source→destination mappings against the actual moves; retain progress so partial filing is resumable.
8. After all moves: verify the inventory against disk, report missing artifacts, check outgoing and inbound links and index rows, and route open Deferred & Debt per the existing reconciliation step (`:162-167`).
9. Tick the filing task and its criterion **only after** the effects are verified; lint the final archived path.
10. Final output reports two distinct facts: implementation verification status, and package filed status.

Failure handling (**proposed**): implementation incomplete → Reconcile only mode, as today. Archive policy unresolved, a move blocked, a collision, or a link validation failure → report "implementation verified; filing pending/blocked" — **not** successfully packaged. Source→destination mapping is recorded before moves, progress staged, and the sequence resumable with no-overwrite and no-duplicate-index rules (idempotent resume).

## 6. Gaps and contracts that require adoption (existing state cited)

1. **Order conflict.** Phase 4 step 3 archives the plan (`:154-160`) before step 7 requires `--state` to pass "before the plan is archived" ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:173`). Adoption must reorder or re-anchor the check (§5.3).
2. **Mode-table omission.** The Reconcile-only row lists Phase 4 steps 1, 2, 4, 5, 6 and omits step 7 (`:15`) while `:173` says both modes run it.
3. **Marker vs archive.** Unresolved archive policy blocks only the move, yet still applies the completion marker (`:160`); acceptance says Full completion is marker **and** archive (`:208`). The gate report must separate implementation verified from filing success (§5.10).
4. **Lint coverage.** `check-plan.sh --state` checks checkbox hygiene only — open boxes need `Open:` reasons ([`plan-template.md`](../../00-Meta-Workflow/00-meta/plan-template.md) `:128-131`; [`check-plan.sh`](../../scripts/validation/check-plan.sh) `:145-166`) — and a tier-less legacy plan warns and exits 0 without `--require-tier` ([`check-plan.sh`](../../scripts/validation/check-plan.sh) `:79-86`). Proposed terminal run combines both flags — already parseable together ([`check-plan.sh`](../../scripts/validation/check-plan.sh) `:17-31`) — after legacy conversion at the gate ([`03-mark-completed.md`](../../04-documentation/03-mark-completed.md) `:107`). This is a rule change, not new tooling.
5. **Link validation.** The active-link checker excludes `00-project/plans-completed` ([`check-active-markdown-links.sh`](../../scripts/validation/check-active-markdown-links.sh) `:17-21`) and ignores anchors (`:62-67`), so passing today's tool cannot certify an archived bundle. A scoped archived-link/coverage regression extension is proposed **for** adoption; it does not exist yet.
6. **Guide divergence.** [`changelog-and-troubleshooting.md`](../docs/agents/changelog-and-troubleshooting.md) `:55-59` teaches direct filing, while [`plans-completed/README.md`](../plans-completed/README.md) `:37-44` makes gate reconciliation step 0. Adoption should link both to the canonical gate.
7. **Deferred work.** Incomplete/deferred scoped tasks remain unchecked and the plan active under the current Full-completion/Reconcile-only contract ([`03-execute-and-confirm.md`](../../02-code-build/03-execute-and-confirm.md) `:26`). An owner-approved "CLOSED WITH DEFERRED" archival disposition is separately governed and is deferred out of this MVP.
8. **Doc markers are not plan archival.** Live documentation workflows write `**Status:** ✅ COMPLETED` on documents ([`01-create-docs.md`](../../04-documentation/01-create-docs.md) `:44`; [`02-sync-documentation.md`](../../04-documentation/02-sync-documentation.md) `:88`); those markers mean document results, not plan completion or filing.

## 7. Illustrative wording (proposed; examples are illustrative, not required text)

Template inventory section (illustrative):

```markdown
## Artifact lifecycle
| Artifact | Owner repo | Relationship | Disposition |
|---|---|---|---|
| research/findings-YYMMDD-HHMM-model.md | this repo | research | move to archive with plan |
| plans/2026-10-06-source-plan.md | this repo | superseded source | move; link new → old |
| plans/PLAN.reviews-archive/ | this repo | review archive | move; retain |
| docs/guide.md | this repo | live product doc | retain in place; reason: canonical |
```

Terminal task exemplar (illustrative; ticked only by the gate after verified filing):

```markdown
1. [ ] File the completed plan package via the terminal gate (P2, Effort: S)
   - Open: pending — gate-owned terminal bookkeeping, excluded with its filing criterion from implementation eligibility
   - Files: this plan; Artifact lifecycle rows
   - Verify: gate verifies artifact coverage, archived/inbound links and indexes; `check-plan.sh --require-tier --state` passes at the final path → package filed (cost/prereqs: verified implementation, resolved owner archive policy, local file/link checks)

## Success Criteria
- [ ] Completed plan package filed and verified by the terminal gate — Open: pending — gate-owned filing criterion, not an implementation eligibility prerequisite
```

## 8. Adoption steps (ranked) and test matrix (proposed)

| Rank | Change | Where |
|---|---|---|
| 1 | Artifact lifecycle contract (inventory + terminal task + eligibility exclusion) | `plan-template.md` |
| 2 | Gate Phase 4 step 3 extension + step 7 reorder + split report | `03-mark-completed.md` |
| 3 | Seed at generation; maintain at finalisation; check at review | `00-research-and-plan.md`, `02-finalise-plan.md`, `01-plan-review.md` |
| 4 | Hand-off and bundled-result wording | `01-execution.md`, `02-confirm-execution.md`, `03-execute-and-confirm.md`, `04-review-finalise-commit-execute.md` |
| 5 | README parity lines | both directory READMEs |
| 6 | Archived-bundle link/coverage regression extension | `scripts/validation/` (new, scoped) |

| Scenario | Expected under proposal |
|---|---|
| Tiny T1 plan, no research | single-row inventory; short filing task; no manifest, no tier bump |
| Full draft/final with reviews archive and evidence | inventory carries source, reviews-archive, research rows; all moved or retained-with-reason |
| Direct finalisation (no review) | inventory still initialized; missing rows reported, not invented |
| Direct 01 → gate vs 03/04 wrapper | identical filing result (parity) |
| Missing/contradictory host archive policy | move blocked; "implementation verified; filing blocked" |
| Incomplete task | Reconcile only; plan stays active; no filing |
| Allowed external debt | stays open; routed per `:162-167`; not archived away |
| Cross-repo / shared docs | other repo's records untouched; shared docs retained + linked |
| Interruption / name collision | staged, resumable; no overwrite; no duplicate index rows |
| Broken inbound links after move | flagged in post-move verification; filing stays pending until fixed |
| Sensitive artifacts | sanitized/excluded per host privacy; retained reason recorded |
| Eligibility with pending filing task and criterion | eligible to enter Full completion after implementation proof; both terminal bookkeeping boxes stay unchecked until filing verifies |

## 9. Explicitly not proposed

No zip/bundle packaging default; no new archive policy or global destination; no forced commits or pushes (planning commit stays an optional user-selected checkpoint); no new top-level workflow; no change to live documentation marker semantics; no auto-archive once code is done — the filing task is ticked only after verified filing effects. No troubleshooting entry accompanies this research: it fixes no workflow defect.

## Sources

All ten instruction files in the two studied directories, plus the core contracts they reference:

- [`01-planning-and-organizing/README.md`](../../01-planning-and-organizing/README.md) — workflow index and sequence `:5-51`; shared-template note `:82`
- [`01-planning-and-organizing/00-research-and-plan.md`](../../01-planning-and-organizing/00-research-and-plan.md) — outputs `:28-32`; Phase 3 `:168-226`; Phase 3.2 `:201-209`
- [`01-planning-and-organizing/01-plan-review.md`](../../01-planning-and-organizing/01-plan-review.md) — steps `:16-33`; `PLAN.reviews/` `:42-51`; output `:59-74`
- [`01-planning-and-organizing/02-finalise-plan.md`](../../01-planning-and-organizing/02-finalise-plan.md) — steps `:18-48`; supersede/archive `:44-48`; acceptance `:69-84`
- [`01-planning-and-organizing/03-plan-review-and-finalise.md`](../../01-planning-and-organizing/03-plan-review-and-finalise.md) — steps `:14-18`; no-duplication `:24-27`
- [`02-code-build/README.md`](../../02-code-build/README.md) — gate diagram `:16-35`; mandatory gate `:37`; Verification Bar `:70-84`
- [`02-code-build/01-execution.md`](../../02-code-build/01-execution.md) — outputs `:15-22`; loop `:53-87`; Finalization `:89-94`
- [`02-code-build/02-confirm-execution.md`](../../02-code-build/02-confirm-execution.md) — marking `:57-70`; steps `:72-98`; no plan-level completion `:96`; hand-off `:98`
- [`02-code-build/03-execute-and-confirm.md`](../../02-code-build/03-execute-and-confirm.md) — Completion Bar `:18-29`; steps `:31-52`
- [`02-code-build/04-review-finalise-commit-execute.md`](../../02-code-build/04-review-finalise-commit-execute.md) — commit checkpoint `:26-31` and notes `:53`; execute `:33-36`; related `:58-62`
- [`04-documentation/03-mark-completed.md`](../../04-documentation/03-mark-completed.md) — terminal authority `:6-17`; phases `:100-178`; archive step `:154-160`; state check `:173`; acceptance `:205-213`
- [`00-Meta-Workflow/00-meta/plan-template.md`](../../00-Meta-Workflow/00-meta/plan-template.md) — task/decision requirements `:101-107`; Marking Contract `:109-118`; validation modes `:124-131`
- [`00-Meta-Workflow/00-meta/naming-conventions.md`](../../00-Meta-Workflow/00-meta/naming-conventions.md) — metadata-root resolution `:44-58`; storage `:60-69`; checkout `:71-73`
- [`scripts/validation/check-plan.sh`](../../scripts/validation/check-plan.sh) — flags `:17-31`; legacy path `:79-86`; state logic `:109-166`
- [`scripts/validation/check-active-markdown-links.sh`](../../scripts/validation/check-active-markdown-links.sh) — skip patterns `:16-21`; anchor handling `:60-67`
- [`00-project/plans-completed/README.md`](../plans-completed/README.md) — categories `:17-25`; filing steps `:35-44`
- [`00-project/docs/agents/changelog-and-troubleshooting.md`](../docs/agents/changelog-and-troubleshooting.md) — plans-completed conventions `:49-59`
- [`04-documentation/01-create-docs.md`](../../04-documentation/01-create-docs.md) `:44` and [`04-documentation/02-sync-documentation.md`](../../04-documentation/02-sync-documentation.md) `:88` — document-level completion markers
- Companion changelog entry: [`changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md`](../changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md)

## Proposal verification

- All ten planning/build Markdown files were studied, with a separate read-only review of the terminal gate and shared contracts. The proposal records source-backed recommendations, not adopted instructions or completed implementation.
- `git diff --check` passed. The only Workflow-Scripts changes are this research file, its documentation changelog entry and one new changelog-index row; no workflow, template, validator, application file or completed-plan archive was changed. Nothing was staged, committed or pushed.
- `bash scripts/validation/check-active-markdown-links.sh` found no broken target in those three files, but the repository-wide run **failed** on an existing escaped-root link at `00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15`. That file is tracked and unchanged from HEAD; the unrelated failure was not repaired by this proposal. Do not treat this result as a passing repository-wide link gate or as archived-bundle/anchor validation.
- `check-plan.sh` was not run on this document: it is a research proposal, not an implementation plan. The fenced terminal task is an illustrative recommendation, not work being executed now.
