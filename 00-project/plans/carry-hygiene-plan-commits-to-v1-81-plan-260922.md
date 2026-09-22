# Carry Update-AI-Tools Hygiene-Plan Commits to v1.81 — Implementation Plan

**2026-09-22 13:08**  
**Status:** Active (ready to execute)  
**Target branch:** `v1.81` (`origin/v1.81`) — Workflow-Scripts companion repo, canonical checkout `Shared-Links/Workflow-Scripts`  
**Filed in:** Core-Learning `Tech-notes/Workflow-Scripts/plans/` (deliberately outside Workflow-Scripts' own `00-project/plans/` so the active line's plan directory stays clean of self-referential meta-work)  
**Priority:** P1 / S2 (completion record of executed work stranded on a frozen branch; discoverability gap on the active line, no workflow-behavior risk)

## Goal

Carry the two stranded commits `f5fd73a` (plan filing) and `694add5` (plan completion + archive) from the frozen `v1.72` branch onto the active `v1.81` branch, so the completion record of the 2026-09-18 Update-AI-Tools repo-sync/hygiene plan lives on the active line. No workflow behavior changes; the net tree change on `v1.81` is one archived plan file plus one row in each of two index files.

## Current evidence (verified 2026-09-22)

- `origin/v1.72` tip = `694add5` (parent `f5fd73a`, parent `af9860b`). `git rev-list --count origin/v1.81..origin/v1.72` = 2: **exactly these two commits** are the delta; merge-base of `v1.72` and `v1.81` is `af9860b`.
- Neither commit is on `origin/v1.81` or `origin/main` (`git merge-base --is-ancestor` fails for both).
- `694add5` content: R065 rename `00-project/plans/2026-09-18-update-ai-tools-repo-sync-and-hygiene-plan.md` → `00-project/plans-completed/implementation/…` (adds task marks, verification addendum, `✅ COMPLETED` marker), +1 row in `00-project/plans-completed/index.md`, +1 row in `00-project/changelog/index.md`.
- Both index rows insert immediately after the table header; `v1.81` has different rows at that anchor since `af9860b` (`2026-09-10 tooling` rows in `plans-completed/index.md`; `2026-09-22 docs` + `2026-09-10` rows in `changelog/index.md`) → **guaranteed same-anchor 3-way conflicts** in both files.
- The plan file contains **zero markdown links** (all paths backticked) → no `check-active-markdown-links.sh` exposure.
- `v1.81` carries the validation suite (`scripts/validation/`, CI `.github/workflows/validation.yml`) that `v1.72` never had; `check-completion-chain-policy.sh` enforces exactly the marker + archive + changelog-row convention the cherry-picked state satisfies.
- The plan content references companion branch `v1.72` (true at execution, 2026-09-18); superseded by the retarget to `v1.81` on 2026-09-22 (Update-AI-Tools main repo commit `d5b2849`).

## Bounded scope

**Touches (net, on `v1.81`):**
1. `00-project/plans-completed/implementation/2026-09-18-update-ai-tools-repo-sync-and-hygiene-plan.md` (new file, archived form)
2. `00-project/plans-completed/index.md` (+1 row)
3. `00-project/changelog/index.md` (+1 row)
4. One dated addendum line appended inside the archived plan (retarget note)

**Explicitly out of scope / prohibited:**
- `git merge v1.72` into `v1.81` (welds the frozen parent into the active line's history; contradicts the published frozen-parent topology of the 2026-09-10 v1.81 publication)
- Any push to `origin/main` (main is deliberately behind `v1.81`; its sync cadence belongs to the publication process)
- Rewriting the frozen `v1.72` branch or its commits
- Any change to workflow files, validation scripts, `plans/README.md`, or `TODO.md`
- The Update-AI-Tools main repo (its side of the 2026-09-18 work is already committed at `bf882b7` and retargeted at `d5b2849`)

## Phase 1 — P1: Preflight (read-only)

**Tasks:**
1. Confirm checkout state: `git -C Shared-Links/Workflow-Scripts status -sb` → on `v1.81`, clean, in sync with `origin/v1.81`; if behind, `git pull --ff-only`.
2. Re-confirm the two commits and merge-base unchanged: `git rev-parse origin/v1.72` = `694add5…`, merge-base with `origin/v1.81` = `af9860b…`.
3. Record rollback anchor: `git rev-parse HEAD`.

**Exit criteria:** All three checks pass and are recorded in the execution notes; working tree clean.

## Phase 2 — P1: Cherry-pick the pair with `-x` traceability

**Tasks:**
1. `git cherry-pick -x f5fd73a` — expect clean apply (new file at unique path `00-project/plans/…`). On unexpected conflict: `git cherry-pick --abort` and investigate; do not force.
2. `git cherry-pick -x 694add5` — expect the rename+modification to apply cleanly, then **two conflicts** (`plans-completed/index.md`, `changelog/index.md`).
3. Resolve both conflicts by **union, newest-first by row date**:
   - `changelog/index.md`: `2026-09-22` relocate row → **new `2026-09-18` plan row** → existing `2026-09-10` rows onward.
   - `plans-completed/index.md`: **new `2026-09-18` implementation row** above the existing `2026-09-10 tooling` rows.
   - Change nothing else in either file; no reformatting.
4. Append the dated retarget note to the archived plan's Verification Addendum (the plan body otherwise stays verbatim — no rewriting of history): 
   > **2026-09-22 addendum:** Companion retargeted from frozen `v1.72` to active `v1.81` on 2026-09-22 (Update-AI-Tools `d5b2849`). Branch references above describe execution-time state. This record was carried to `v1.81` via `cherry-pick -x`; see the commit trailer for the original `v1.72` hashes.
5. Amend the second pick (`git commit --amend --no-edit`) to fold the addendum line into it; keep the `-x` trailer.

**Exit criteria:** `git status` clean; `git log --oneline -3` shows the two picks with `(cherry picked from commit …)` trailers; `git diff af9860b..HEAD --stat` nets exactly the 3 files + addendum line.

## Phase 3 — P1: Validation gates (v1.81 suite)

**Tasks:**
1. `bash scripts/validation/check-completion-chain-policy.sh` — must pass (this is the audit of the pick itself).
2. `bash scripts/validation/check-active-markdown-links.sh` — must pass (zero links in the new content).
3. Run the remaining validators if trivially runnable (`check-sync-workflow-scripts.sh`, `check-update-workflows.sh`); record any pre-existing failures separately — do not fix unrelated issues in this plan.

**Exit criteria:** Validators 1–2 pass with output recorded. Any unrelated pre-existing failure is documented as out-of-scope, not a blocker for this plan.

## Phase 4 — P1: Push and verify

**Tasks:**
1. `git push origin v1.81` — **only** this ref.
2. Verify: `git status -sb` clean and 0/0; archived plan present at `plans-completed/implementation/`; both index rows present in correct date order; `origin/main` intentionally untouched (still 1 behind `v1.81` plus this work).
3. Record the new commit hashes beside the originals (`f5fd73a`/`694add5` → new SHAs) in the execution notes of this plan.

**Exit criteria:** Push succeeded; all verifications pass; execution notes updated with hashes and validator output; this plan's Status updated (see Completion).

## Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Unexpected conflict shape in the picks | Low | Medium | Pre-push everything is local: `git cherry-pick --abort` or `git reset --hard <Phase-1 anchor>`; frozen `v1.72` originals are untouched |
| Validator flags the archived plan | Low | Medium | Convention-conformant state (marker + archive + rows); if it still fails, record blocker and do not push (Not Eligible path) |
| Row-order mistake in index resolution | Low | Low | Newest-first rule stated per file; verify with `sed -n` read-back before committing |
| Accidental push to `origin/main` | Low | Medium | Single explicit ref in the push command; verify with `git status -sb` after |
| Post-push discovery of an error | Low | Low | `git revert <new SHAs>` on `v1.81`; originals remain reachable on `origin/v1.72` |

## Rollback

- **Pre-push:** `git reset --hard <Phase-1 anchor>` (recorded in Phase 1) — branch returns to `origin/v1.81` exactly; no trace remains.
- **Post-push:** `git revert --no-edit <new-SHA-2> <new-SHA-1>` and push; `origin/v1.72` keeps the originals either way.

## Acceptance criteria

- [ ] Both commits carried to `v1.81` with `-x` trailers; net diff = archived plan + 2 index rows + 1 addendum line, nothing else
- [ ] Index rows in correct newest-first position in both files; no other rows altered
- [ ] `check-completion-chain-policy.sh` and `check-active-markdown-links.sh` pass, output recorded
- [ ] Pushed to `origin/v1.81` only; `origin/main` untouched; `v1.72` untouched
- [ ] Execution notes (hashes, validator output, verification) appended to this plan and Status updated

## Completion

On success, update this plan's **Status** to `Executed 2026-09-22 (v1.81 commits <new-SHA-1>, <new-SHA-2>)` and append the execution notes. This plan stays filed in Core-Learning (it documents work on another repository); no Workflow-Scripts `plans-completed/` archive is created for it — the cherry-picked rows in Workflow-Scripts' own indexes are the durable record there.
