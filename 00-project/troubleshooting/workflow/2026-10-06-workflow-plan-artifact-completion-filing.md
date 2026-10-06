# Plan packages had no artifact handoff; state check ran after archive; marker preceded filing; archive links unverifiable

**Date:** 2026-10-06
**Category:** workflow
**Status:** RESOLVED (verified complete — plan package filed at `plans-completed/implementation/2026-10-06-plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md`; final gate check passed 2026-10-06)

---

## Symptom

- **Missing artifact handoff:** `02-code-build/01-execution.md`, `02-confirm-execution.md` and `03-execute-and-confirm.md` handed execution results to the terminal gate with no associated-artifact inventory. Research, review archives and evidence stayed as unlinked siblings of the plan, and `04-documentation/03-mark-completed.md` archived only the plan file itself.
- **Late state check:** Phase 4 of the gate archived the plan in step 3, while step 7 still required `check-plan.sh --state` to pass "before the plan is archived" — an order contradiction. The Reconcile-only mode row listed steps 1, 2, 4, 5, 6 and omitted step 7 even though both modes were required to run it.
- **Unresolved-policy completion marker:** when the host archive policy was unresolved, the move was blocked but the completion marker was still applied, so a plan whose package was not filed could read COMPLETED. There was no report separating "implementation verified" from "filing pending/blocked".
- **Scoped archive exclusion:** `scripts/validation/check-active-markdown-links.sh` unconditionally skipped `00-project/plans-completed/`, so a filed package's links could not be verified deliberately; passing the default scan could never certify an archived bundle.
- The repository-wide active-link gate could not pass on two known problems: an inbound changelog link to the proposal the user had moved from `research/` to `plans/`, and a pre-existing escaped-root hyperlink at `00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15`.

## Root Cause

The terminal gate predated a package/filing concept: it filed the plan file alone, ordered the state lint after the archive move, applied the completion marker before filing effects were verified, and had no two-fact report. Planning workflows generated plans with no artifact inventory, so nothing carried associated artifacts through execution into filing, and the eligibility rules would have deadlocked a completed plan on its own unticked bookkeeping had one existed. The link checker offered only the default skip behavior — no explicit scope — and two historical changelog links had been left as known failures, masking the true state of the repository-wide link gate.

## Fix

Adopted the T3 plan-artifact completion filing lifecycle (full file list in [`changelog/fixed/2026-10-06-fixed-plan-artifact-completion-filing.md`](../../changelog/fixed/2026-10-06-fixed-plan-artifact-completion-filing.md)):

- Canonical contract in `00-Meta-Workflow/00-meta/plan-template.md`, seeded/maintained/checked by the planning and build handoffs: proportional artifact inventory (source locator, owner repository, relationship, disposition/retained reason, verification) plus exactly one gate-owned terminal filing task and its paired filing Success Criterion, excluded only from implementation-entry eligibility and ticked only by the gate after verified filing effects.
- Gate (`04-documentation/03-mark-completed.md`) reordered so steps 1, 2, 4, 5, 6, 7 run before the deferred filing step 3; the Reconcile-only table now includes step 7; the final report states `Implementation verification: VERIFIED/NOT VERIFIED` and `Package filing: PENDING/BLOCKED/PARTIAL/VERIFIED`, and never labels blocked/partial filing COMPLETED. Source→destination mappings are recorded before moves and resumable without overwrite or duplicate index rows. No automatic move engine and no new closure-with-deferred mode were added.
- Scoped archive-aware link checking: `--root`/repeatable `--scope` modes with fail-closed missing/unreadable/escaping-scope and symlink-escape handling; default scan and archived-directory skips unchanged; escaped-root allowlist still empty. Guarded by the checker's `--self-test` fixture plus a new 24-case CLI selftest (7 expected-pass, 17 expected-fail) and the new `check-artifact-lifecycle-policy.sh` + selftest.
- Link hygiene repairs enabling the repository-wide gate: inbound changelog link to the moved proposal repaired to its `plans/` location (historical research outcome preserved; owner re-updates on archive), and the escaped-root hyperlink converted to an explicitly external code-form locator preserving its Update-AI-Tools provenance — no allowlist weakening.

## Verification

Exact commands, actual results:

- `bash scripts/validation/check-active-markdown-links.sh` — before the repairs: exit 1 with exactly `- 00-project/changelog/docs/2026-10-03-docs-setup-subagent-limit.md:15 -> ../../../../../Personal/Update-AI-Tools/project/changelog/docs/2026-10-03-docs-agents-gpt6-luna-policy.md (escapes repository root)` and `- 00-project/changelog/docs/2026-10-06-docs-plan-artifact-completion-filing-proposal.md:8 -> ../../research/plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md`. After the repairs: see final result below.
- `bash scripts/validation/check-active-markdown-links.sh --self-test` — escaped-root fixture detection.
- `bash scripts/validation/check-active-markdown-links-selftest.sh` — 24 scoped-link cases.
- `bash scripts/validation/check-artifact-lifecycle-policy.sh` and `bash scripts/validation/check-artifact-lifecycle-policy-selftest.sh`.
- `git diff --check`.
- Meta-log pairing verified by construction: `changelog/fixed/` entry + `changelog/index.md` row + `troubleshooting/workflow/` entry + `troubleshooting/index.md` row all added together (`check-meta-logs.sh --staged` not run: nothing is staged; no staging was authorized).

Final result of the commands above (recorded after all edits): see the "Final verification run" line appended below by the executing lane.

Pending, owned by the plan orchestrator: full CI-equivalent Test Strategy suite, final `check-plan.sh --require-tier --state` on current and archived paths, and the gate-owned terminal filing of the plan package. Those are not claimed passed here.

## Notes / Lessons

- Terminal bookkeeping (the filing task and its criterion) must be excluded from implementation eligibility, or a plan with verified implementation deadlocks on its own unticked filing boxes. Only the gate ticks them, only after filing effects verify.
- A passing default link check never certifies an archived bundle: archived directories are skipped by default and must be verified with an explicit `--scope`.
- External historical references belong in code form (or a fully qualified external URL), never as a relative hyperlink that escapes the repository root; provenance can be preserved without weakening the checker or growing an allowlist.
- Report implementation verification and package filing as two separate facts; a blocked move with an applied completion marker is a false pass.

## Final verification run (executing lane, 2026-10-06)

- `bash scripts/validation/check-active-markdown-links.sh` → `Active markdown links OK` (exit 0), including the two repaired files and both new log entries.
- `bash scripts/validation/check-active-markdown-links.sh --self-test` → `Escaped-root fixture detection OK` (exit 0).
- `bash scripts/validation/check-active-markdown-links-selftest.sh` → `check-active-markdown-links self-test OK` (exit 0; 24 cases).
- `bash scripts/validation/check-artifact-lifecycle-policy.sh` → `artifact lifecycle policy checks OK` (exit 0).
- `bash scripts/validation/check-artifact-lifecycle-policy-selftest.sh` → exit 1 at the time (**historical, superseded**): the negative fixture `paired filing criterion removed` expected the output substring `paired with its filing Success Criterion` but its skeleton fixture tripped the earlier check at `check-artifact-lifecycle-policy.sh:112` (`plan skeleton lacks the paired filing criterion`). Root cause was transient interlane fixture churn while the validation lane updated the new selftests in parallel; it was routed to the plan owner and is no longer present in the current files (27-case policy/mutation selftest green in the parent's full-suite run below).
- `git diff --check` → clean (exit 0).

Earlier interim parent run (2026-10-06; counts of that point, kept for provenance and superseded by the final merged suite below): suite green — active-links selftest (then 27 cases), artifact-lifecycle policy + mutation (then 27 cases), artifact-filing selftest (S1–S5), all existing policy/selftests, current T3 plan lint, `git diff --check`. Terminal filing (task 7): **pending** (plan owner).

## Post-adoption validation update (2026-10-06, final merged suite)

- Final merged CI-equivalent suite (parent-run after the last gate-order fix and new mutations): **all exit 0** — active scoped-links selftest (31 CLI cases plus the legacy built-in invocation), artifact-lifecycle policy selftest (29 negative mutations + passing baseline), artifact-filing rehearsal (S1–S5 + S2b; a fixture-state model driving the real lint/link CLIs, not prose execution), all existing policy/selftests, both active-link and escaped-root self-tests, the current T3 plan lint, and `git diff --check`.
- Independent-oracle findings: all resolved, including the gate status-ordering correction at `04-documentation/03-mark-completed.md:167` — the effects lint runs pre-mark while the filing pair is still pending, then VERIFIED/tick/marker, then the post-edit lint as final proof; now green. Independent explorer source coverage for plan tasks 2/3/4 + SCA-E: VERIFIED.
- Key fixes proven by the adopted docs and guards: legacy plans get a minimal inventory/filing pair upfront (no tier bump); the final lint targets the **actual current plan path**, including partial-attempt paths; a failed final verification rolls back the `✅ COMPLETED` marker and resets only the filing pair while preserving every non-filing mark, and revalidation never blindly resets recorded `VERIFIED`/`BLOCKED`/`PARTIAL` reasons; external debt keeps scoped eligibility; premature local ticks of the gate-owned filing pair are guarded; the CLI fails closed on empty scopes and scope cycles.
- Filing rehearsal limitations: the S1–S5 + S2b fixtures prove the contracts and the CLI's fail-closed behavior, not universal agent compliance; the real terminal filing (task 7) is the live exercise. **Filing update (2026-10-06):** the parent (sole plan writer) moved the plan to `00-project/plans-completed/implementation/2026-10-06-plan-artifact-completion-filing-proposal-261006-1504-gpt6sol.md` (70 outgoing links rebased; archived scoped link check and T3 lint pass), and this lane completed the package effects — every inbound changelog/troubleshooting/navigation link retargeted to the archived path, `plans-completed/index.md` row and changelog Type=plan row added newest-first with no duplicates. **Final gate record (2026-10-06): passed** — the parent applied `**Status:** ✅ COMPLETED` with `Implementation verification: VERIFIED` and `Package filing: VERIFIED`, ticked all 7 tasks and all 6 Success Criteria, verified the actual mappings/inventory/index/inbound references, and the final combined `--require-tier --state` post-edit lint passed on the archived plan, with the archived scoped check, the full active link check, and `git diff --check` green. Earlier same-day "final filing check pending" statements above remain as clearly dated interim history.
