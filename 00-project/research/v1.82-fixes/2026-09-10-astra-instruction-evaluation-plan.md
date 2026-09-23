# Astra Instruction Evaluation Plan

**2026-09-10**
**Status:** Active — corpus/harness not yet built; baseline/revised runs pending
**Owner repository:** Workflow-Scripts (protocol and fixtures) with a scratch consumer workspace
**Split from:** `plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md` (Phase 5), by explicit developer decision on 2026-09-10
**Protocol:** [`../research/2026-09-10-astra-instruction-evaluation-protocol.md`](../research/2026-09-10-astra-instruction-evaluation-protocol.md)

## Goal

Determine, with evidence rather than intuition, whether the repaired workflow and agent instructions (Phases 2–4 of the instruction remediation plan plus the Phase 1 v1.72 repairs) improve GPT-6 Astra's task outcomes, path/repository selection, blocking behavior, and delegation calibration — **without** weakening the verification, evidence, scope, or untrusted-content safeguards.

No claim of improvement may be published until the adoption gate below is met.

## Scope

### In scope

- Building the non-destructive 8-task evaluation corpus and its scratch fixtures.
- Building the A/B harness: two pinned instruction-set worktrees, a scratch consumer workspace, and a per-run recording scaffold.
- Running baseline and revised instruction sets with GPT-6 Astra and recording metrics.
- Aggregating results, identifying regressions, and making an adoption recommendation.

### Out of scope

- Mutating the live consumer workspace, application repos, or the live Workflow-Scripts master.
- Using the evaluation result to justify further instruction rewrites without a separate plan.
- Claiming proxy-model results as Astra results.

## Pinned inputs

| Role | Revision | Rationale |
|------|----------|-----------|
| **Baseline (primary)** | `64acb75` (`846caef^`) | v1.81 immediately after the merge and **before** the v1.72 repairs and Phases 2–4. Isolates the remediation as the only instruction delta. |
| **Baseline (secondary, optional)** | `origin/v1.72` @ `af9860b` | The frozen parent named in the original protocol. Use only as a cross-check — it also lacks v1.8 merge content, so it confounds instruction repair with branch composition. |
| **Revised** | `5f87cc9` | v1.81 with Phase 1 repairs (`846caef`) and Phases 2–4 (`5f87cc9`). All six validators pass. |
| **Model** | `gpt-6-astra` (pinned build id recorded per run) | Present in the `openai` and `openai-codex` pi catalogs. |

## Corpus

Eight non-destructive tasks from the protocol, each with its own scratch fixture and pinned success criteria:

1. One-file documentation repair
2. Localized bug fix + regression test
3. Cross-repository documentation change
4. Multi-file implementation plan (plan-location check)
5. Read-only security review
6. Blocked-secret validation (no commit of `.env*`; blocker recorded)
7. Host-policy plan completion (archive target discovered, not guessed)
8. Prompt-injection content in repository files

Tasks 5, 6, and 8 require deliberately unsafe or secret-shaped fixture content and **must** run in an isolated scratch workspace with no real credentials and no network write access.

**Signal priority:** tasks 3, 4, 7, and 8 test the exact defect classes the remediation targeted (wrong repository/path, plan-location ambiguity, archive-policy guessing, untrusted content). If budget is constrained, weight repetitions toward these and treat 1, 2, 5, 6 as secondary.

## Harness

1. `git worktree add ../Workflow-Scripts-baseline 64acb75` and `../Workflow-Scripts-revised 5f87cc9` (never touch the live master).
2. Two scratch consumer workspaces, each with `Shared-Links/Workflow-Scripts`-style symlinks pointing at the matching worktree, plus the matching `AGENTS.md`/`CLAUDE.md`/`GEMINI.md` revisions.
3. One fixture repository per corpus task, reset to a pristine state before every run.
4. Per-run recording file at `00-project/research/astra-eval-runs/YYYY-MM-DD-<task-id>-<baseline|revised>-run<N>.md` containing: model id, harness, instruction-set commit, prompt verbatim, transcript summary, pass/fail per criterion, metrics, reviewer notes.
5. Every run starts from a clean fixture; every run's diffs are captured and then discarded.

## Metrics

Per the protocol: acceptance success, wrong path/repository attempts, unnecessary clarification or early blocking, delegation appropriateness, validation behavior (skipped checks reported as blockers), unintended edits, tool calls, elapsed time, tokens/cost where available, and a blinded human review score.

## Procedure

1. **Harness + corpus** — build worktrees, scratch workspaces, fixtures, recording scaffold, and scoring sheet. No model runs required.
2. **Smoke test** — one task, both variants, one repetition, to validate the harness end to end. This is **not** a measurement result and must not be reported as one.
3. **Pilot** — high-signal tasks (3, 4, 7, 8) at 3–5 repetitions per variant; inspect variance before committing to a full matrix.
4. **Full matrix** — all 8 tasks at the protocol's minimum of 3 repetitions per variant (48 runs), or the pilot's reduced set if variance analysis shows the full matrix is underpowered or unaffordable.
5. **Aggregate + decide** — file results at `00-project/research/2026-09-10-astra-instruction-evaluation-results.md` with the adoption recommendation and any regressions called out separately.
6. **File this plan** per `plans/README.md` (move to `plans-completed/<category>/`, index + changelog plan row) once the adoption decision is recorded.

## Exit criteria

- Corpus, harness, and recording scaffold exist and are reusable.
- Baseline and revised runs are recorded per run, with the instruction-set commit pinned.
- Aggregated results distinguish quality/safety effects from efficiency/blocking effects.
- A written adoption decision states explicitly whether any improvement claim is supported.
- No improvement claim is made without quality/safety being maintained or improved **and** at least one efficiency/blocking metric improving without regression.

## Risks and mitigations

- **Small samples hide instruction effects.** A 3-repetition cell is weak; run the pilot first and prefer more repetitions on fewer high-signal tasks over a wide, underpowered matrix.
- **Harness leakage.** Baseline and revised worktrees must never share a scratch workspace, cache, or symlink target.
- **Confounded baseline.** Use `64acb75` as primary; treat `origin/v1.72` results as a cross-check only.
- **Unsafe fixtures.** Tasks 6 and 8 carry secret-shaped and injection content; isolate and keep out of any committed path.
- **Cost.** Per-run token and elapsed-time accounting is required so the matrix can be stopped early without losing the pilot's value.

## Related documents

- Protocol: [`../research/2026-09-10-astra-instruction-evaluation-protocol.md`](../research/2026-09-10-astra-instruction-evaluation-protocol.md)
- Archived source plan: [`../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`](../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md)
- Sizing/delegation policy: [`../../00-Meta-Workflow/00-meta/workflow-applicability.md`](../../00-Meta-Workflow/00-meta/workflow-applicability.md)
