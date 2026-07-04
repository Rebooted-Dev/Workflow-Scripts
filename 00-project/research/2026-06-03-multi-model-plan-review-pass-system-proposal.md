# Multi-Model Plan Review Pass System Proposal

**Date:** 2026-06-03
**Status:** Proposal (for study — not yet adopted)
**Author:** claude-opus-4-8
**Scope:** A system for running a single plan through multiple independent model/agent review passes, then deterministically reconciling their findings into one finalized plan.
**Motivation:** During the 2026-06-03 review of `project/plans/2026-05-14-multi-speaker-podcast-audio-generation-implementation-plan.md`, the `01-plan-review.md` workflow's "Concurrency & Multi-Model Usage" section was referenced but never exercised. This proposal turns that section's sketch into a concrete, testable design.

## Goal

Take one plan document and produce a **higher-confidence, finalized plan** by:

1. Running **N independent review passes** (different models, and/or different reviewer *roles*) that cannot see each other's output.
2. Collecting each pass as its own immutable artifact (no concurrent writes to the plan).
3. **Reconciling** the passes with explicit, deterministic rules for agreement, divergence, and contradiction.
4. Emitting one consolidated addendum (or one next-version plan) plus a small audit trail explaining *why* each finding survived, merged, or was dropped.

The success test: a finding that one model misses but another catches should reliably reach the final plan, and a finding two models *disagree* on should be surfaced as a flagged conflict rather than silently resolved by whichever pass wrote last.

## Why This Is Worth Building (and when it is not)

Single-model review has two failure modes this system targets:

- **Blind spots.** The 2026-06-03 single-model review caught a stale-path bug (`116cd56` moved the prompt dir) that the plan's own earlier reassessment asserted didn't exist. A second independent pass with a different model is the cheapest known defense against a confident-but-wrong reviewer.
- **Score inflation / deflation.** One model's "S2/P1" is another's "S3/P2." Multiple passes let us treat severity as a *distribution* and flag wide disagreement for human judgment.

**Do not use this system for:** small/low-risk plans, plans already mid-execution, or anything where the review cost (N model runs + reconciliation overhead) exceeds the blast radius of a missed finding. This is for high-impact, pre-execution plans only. (The existing `multi-agent-plan-orchestration` skill already states this guardrail; this proposal inherits it.)

## What Already Exists (do not reinvent)

This system is a **synthesis layer**, not green-field. The building blocks are present but disconnected:

| Existing asset | What it already provides | Gap this proposal fills |
|---|---|---|
| `01-plan-review.md` → "Concurrency & Multi-Model Usage" | The single-writer rule and the `PLAN.reviews/` naming convention | No reconciliation algorithm; no divergence handling |
| `00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md` | `opencode run -m <model> --prompt ...` delegation, background PIDs, exit codes, status JSON | Only runs *one* delegated review; no fan-out or merge |
| `02-finalise-plan.md` | Turns a reviewed plan into a next-version plan | Assumes a *single* review input, not a set of competing ones |
| `11-Skills/multi-agent-plan-orchestration` | "Split independent passes → critique → synthesize" mental model + guardrails | Conceptual; no file conventions, no scoring math |
| `11-Skills/workflow-plan-review-finalize` | Evidence discipline, dated addenda, tracker updates | Single-reviewer assumption |

The contribution of this proposal is the **glue**: a fan-out launcher spec, a strict artifact schema, and a deterministic reconciliation pass.

## Architecture

```text
                         ┌────────────────────────┐
                         │   ORCHESTRATOR (you)    │
                         │  reads PLAN.md once     │
                         └───────────┬────────────┘
                                     │ fan-out (parallel, isolated)
        ┌──────────────┬────────────┼────────────┬──────────────┐
        ▼              ▼             ▼            ▼              ▼
   Pass A          Pass B        Pass C       Pass D         Pass E
 model: opus    model: gpt    model: gemini  role: security  role: scope
 role: general  role: general role: general  (any model)     (any model)
        │              │             │            │              │
        ▼              ▼             ▼            ▼              ▼
   each writes ONE artifact into  PLAN.reviews/  (no shared writes)
        └──────────────┴─────────────┬────────────┴──────────────┘
                                      ▼
                         ┌────────────────────────┐
                         │   RECONCILER pass       │
                         │ (single writer)         │
                         │ - cluster findings      │
                         │ - merge / flag conflict │
                         │ - recompute consensus   │
                         └───────────┬────────────┘
                                     ▼
              ┌──────────────────────┴───────────────────────┐
              ▼                                               ▼
   Consolidated addendum                          PLAN.reviews/_reconciliation.md
   appended to PLAN.md                            (audit trail: who said what)
                                     │
                                     ▼ (optional)
                         02-finalise-plan.md → next-version plan in project/plans/
```

Two key invariants, both inherited from `01-plan-review.md`:

- **No pass ever edits `PLAN.md`.** Passes only write their own files under `PLAN.reviews/`.
- **Exactly one reconciler writes the consolidated output.** This eliminates concurrent-write corruption by construction.

## Artifact Layout & Naming

For a plan at `project/plans/<name>.md`, create a sibling directory:

```text
project/plans/<name>.reviews/
  <name>.review.opus-4-8.2026-06-03-2335.md          # Pass A (general)
  <name>.review.gpt-5.1.2026-06-03-2336.md           # Pass B (general)
  <name>.review.gemini-2.5-pro.2026-06-03-2337.md    # Pass C (general)
  <name>.review.security.opus-4-8.2026-06-03-2338.md # Pass D (role-specialized)
  _manifest.json                                     # what was launched + status
  _reconciliation.md                                 # the merge audit trail
```

Per-pass filename pattern (extends the existing `01-plan-review.md` convention with an optional role segment):

```text
<plan-name>.review[.<role>].<short-model-name>.YYYY-MM-DD-HHMM.md
```

`_manifest.json` (written by the orchestrator at launch, updated on completion) makes the run reproducible and auditable:

```json
{
  "plan": "project/plans/2026-05-14-multi-speaker-podcast-audio-generation-implementation-plan.md",
  "launched_at": "2026-06-03T23:35:00+08:00",
  "passes": [
    { "id": "A", "model": "opus-4-8", "role": "general", "status": "complete", "exit": 0, "findings": 9 },
    { "id": "B", "model": "gpt-5.1", "role": "general", "status": "complete", "exit": 0, "findings": 7 },
    { "id": "C", "model": "gemini-2.5-pro", "role": "general", "status": "timeout", "exit": 124, "findings": 0 }
  ],
  "reconciled_at": "2026-06-03T23:45:00+08:00",
  "quorum": "2_of_3_completed"
}
```

## Required Per-Finding Schema (the contract that makes merging possible)

Free-text reviews cannot be merged deterministically. Each pass **must** emit findings in a structured, machine-clusterable form (Markdown table or fenced JSON). The reconciler depends on this schema:

| Field | Purpose | Required |
|---|---|---|
| `id` | Pass-local id, e.g. `A1` | yes |
| `title` | One-line claim | yes |
| `severity` | S0–S3 | yes |
| `priority` | P0–P3 | yes |
| `evidence` | `file:line` or commit hash — **a finding with no evidence is dropped at reconcile** | yes |
| `claim_type` | `fact` \| `risk` \| `opinion` — drives the divergence rule below | yes |
| `fix` | Concrete, measurable correction | yes |
| `fingerprint` | Normalized key for clustering (see below) | derived |

**Fingerprint** = lowercased, stop-word-stripped join of the primary `file:line` (or commit) + the head noun of the title. Two findings with the same fingerprint are treated as the *same underlying issue* across passes. This is deliberately simple and deterministic; fuzzy semantic clustering is a non-goal for v1 (see Open Questions).

## Reconciliation Algorithm (the heart of the system)

The reconciler reads every pass artifact and produces the consolidated output via these ordered rules:

1. **Cluster** all findings by `fingerprint`.

2. **Per cluster, classify by agreement:**
   - **Consensus (≥ quorum passes agree):** keep the finding. Set severity/priority to the **mode**; if no mode, the **median rounded toward higher severity** (per rubric note: "if uncertain, default to higher likelihood"). Record the spread, e.g. `S2/P1 (3 passes: S2,S2,S3)`.
   - **Singleton (1 pass only):** keep it, but tag `⚠ single-source` so the human knows it was not independently corroborated. Singletons are *not* dropped — catching the blind spot is the whole point — but they are visually marked.

3. **Contradiction handling, keyed on `claim_type`:**
   - **`fact` vs `fact` conflict** (e.g. Pass A: "file exists at X"; Pass B: "file moved to Y"): the reconciler **must verify against the live repo itself** and record the resolution with evidence. Facts are not voted on — they are checked. This is exactly the failure the system exists to catch.
   - **`risk`/`opinion` conflict** (e.g. different severity, or "over-engineered" vs "appropriately scoped"): do **not** auto-resolve. Emit both positions under a `### Conflicts requiring human judgment` heading with each pass's rationale. Surfacing beats silently averaging.

4. **Drop** any finding lacking `evidence` (schema violation) and log the drop in `_reconciliation.md` so nothing disappears silently.

5. **Quorum & degraded runs:** define quorum up front (e.g. "≥2 of 3 passes completed"). If a pass times out or errors (non-zero exit), proceed with survivors, record `quorum` in the manifest, and add a banner to the consolidated addendum: *"Reconciled from 2 of 3 passes; pass C (gemini) timed out — single-source findings are less corroborated than usual."*

6. **Order** the surviving findings P0→P3, then S0→S3 within priority (the shared rubric ordering rule).

7. **Write** the consolidated addendum to `PLAN.md` (single writer) **and** `_reconciliation.md` (the audit trail showing every cluster, its members, and the decision).

### Why facts and opinions are handled differently

This split is the core design decision. Voting on facts is how you get a confidently-wrong consensus (three models can all parrot a stale assumption). Voting on opinions is how you get bland averages that bury a sharp dissent. So: **facts get verified, opinions get surfaced, only severities get voted.**

## Reviewer Roles (orthogonal to models)

Two independent axes multiply coverage:

- **Model axis:** opus / gpt / gemini — different training, different blind spots.
- **Role axis:** general, security, scope/over-engineering, test-strategy, migration-order, API-plumbing. Each role gets a task-local prompt addendum steering it (e.g. the security role is told to ignore style and hunt trust boundaries).

A practical default for a high-impact plan: 3 general passes (different models) + 1 security role + 1 scope role. Roles can reuse any model; they are prompt specializations, not separate infrastructure.

## Launch Mechanics (build on `orchestrator-plan-review.md`)

The orchestrator already knows how to delegate one review non-interactively:

```bash
opencode run \
  -m openai/gpt-5.1 \
  --prompt "Review the plan at <PLAN> following Workflow-Scripts/01-planning-and-organizing/01-plan-review.md. \
            Emit findings in the structured schema. Write ONLY to <PLAN>.reviews/<name>.review.gpt-5.1.<ts>.md. \
            Do not edit the plan file." \
  > "<PLAN>.reviews/<name>.review.gpt-5.1.<ts>.log" 2>&1 &
```

Fan-out = launch one such background process per pass, capture each PID into `_manifest.json`, `wait` on all (with a per-pass timeout), then run the reconciler. The orchestrator-plan-review workflow's exit-code and status-file handling is reused verbatim; this proposal only adds the *fan-out loop* and the *reconciler step* around it.

In-session Claude alternative (no OpenCode): the same fan-out maps to parallel `Agent` spawns in read-only mode, each returning its artifact, with the main session acting as reconciler. The OpenCode path is preferred when true cross-vendor model diversity is the goal.

## Worked Example (using the multi-speaker plan)

Applying this system to `2026-05-14-multi-speaker-podcast-audio-generation-implementation-plan.md`:

- **Pass A (opus, general)** already ran on 2026-06-03 and produced 9 findings. Its #1 was the stale-path / false-"nothing-changed" finding (`fact`, evidence: commit `116cd56`).
- **Hypothetical Pass B (gpt, general)** might miss the stale path but independently flag the truncation/label-integrity risk (`risk`, evidence: `route.ts:38-39`).
- **Reconciler outcome:**
  - Stale-path finding: `fact`, single-source → reconciler **verifies against repo**, confirms the move, promotes it to consensus-confirmed (not just single-source) *because the repo agreed*, not because a second model did.
  - Truncation risk: if both passes raised it at different severities (A:S2/P1, B:S2/P2), consensus severity = S2, priority = mode/higher = P1, spread recorded.
  - If A says Phases 5–6 are "appropriately deferred" and B says "cut Phase 6 entirely" → `opinion` conflict → surfaced under "Conflicts requiring human judgment," not auto-resolved.

This is exactly the kind of plan the system is for: high-impact, pre-execution, with at least one confidently-wrong assumption already embedded.

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Cost/latency of N model runs | Likely | Medium | Gate on plan impact; cap N; allow `quick` role-subset runs |
| Passes drift from the required schema → unmergeable | Possible | High | Validate each artifact against the schema before reconcile; drop+log malformed findings |
| Fingerprint clustering misses semantically-identical findings worded differently | Possible | Medium | Keep v1 deterministic; list as Open Question; reconciler human-reviews near-duplicate singletons |
| A model fabricates a `file:line` that looks valid | Rare | High | Reconciler spot-checks evidence for any S0/S1 or any `fact`-type finding |
| Consensus masks a correct lone dissenter | Possible | High | Never drop singletons; verify all `fact` conflicts against the repo, don't vote them |
| Concurrent writes corrupt the plan | Rare | High | Structural guarantee: passes write only to `PLAN.reviews/`; one reconciler writes `PLAN.md` |

## Open Questions (for your study)

1. **Clustering fidelity.** Is deterministic fingerprint clustering good enough, or do we need an embedding-based similarity pass to catch the same finding worded three ways? (v1 says deterministic; revisit with data.)
2. **Quorum policy.** Fixed (`≥2 of 3`) vs severity-weighted (a single S0 from any pass blocks regardless of quorum)?
3. **Severity reconciliation math.** Mode, median-toward-higher, or max? The rubric leans conservative ("default to higher"); does that inflate priority across many passes?
4. **Reconciler trust.** Should the reconciler be a *fixed* model (reproducibility) or the strongest available (quality)? Should it ever be one of the passes, or always a separate neutral run?
5. **Where does the final artifact live?** Consolidated addendum appended to `PLAN.md` (audit-friendly) vs a fresh next-version plan via `02-finalise-plan.md` (clean handoff). Probably both, but which is canonical?
6. **Integration with the skills.** Should this become a new step inside `multi-agent-plan-orchestration`, or a standalone `multi-model-plan-review` skill that the orchestration skill calls?

## Proposed Phasing (if adopted later)

- **Phase 1 (P1):** Formalize the per-finding schema + `PLAN.reviews/` layout + `_manifest.json`. Pure convention; no automation. Immediately usable by hand.
- **Phase 2 (P1):** Fan-out launcher around `orchestrator-plan-review.md` (loop + timeouts + manifest).
- **Phase 3 (P0 of the system's value):** The reconciler — clustering, fact-verification, conflict surfacing, consensus scoring.
- **Phase 4 (P2):** Role-specialized prompt addenda (security, scope, etc.).
- **Phase 5 (P3):** Optional embedding-based clustering if deterministic fingerprints prove too brittle.

## Out of Scope

- Implementing any of the above (this is a study artifact only).
- Automated CI gating on review exit codes (the orchestrator workflow already sketches this; defer).
- Cross-plan / portfolio-level review aggregation.

## References

- `Workflow-Scripts/01-planning-and-organizing/01-plan-review.md` — Concurrency & Multi-Model Usage section (source of the single-writer rule + naming convention)
- `Workflow-Scripts/01-planning-and-organizing/02-finalise-plan.md` — consolidation into next-version plan
- `Workflow-Scripts/00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md` — OpenCode delegation mechanics (`opencode run -m`)
- `Workflow-Scripts/11-Skills/multi-agent-plan-orchestration/SKILL.md` — split/critique/synthesize model + guardrails
- `Workflow-Scripts/11-Skills/workflow-plan-review-finalize/SKILL.md` — evidence discipline, dated addenda
- `Workflow-Scripts/00-Meta-Workflow/00-meta/severity-priority-rubric.md` — scoring + ordering rules used by reconciliation
- Live example: `project/plans/2026-05-14-multi-speaker-podcast-audio-generation-implementation-plan.md` (2026-06-03 single-model review addendum)

---

## 2026-07-03 23:27 - Plan Review (Model: claude-fable-5)

Reviewed per `Workflow-Scripts/01-planning-and-organizing/01-plan-review.md` (invoked via `03-plan-review-and-finalise.md`). Scope: correctness, feasibility, risk, and completeness of the proposal as a candidate for adoption. All referenced assets were verified against the live worktree on 2026-07-03. Rubric: `00-Meta-Workflow/00-meta/severity-priority-rubric.md`.

**Relevance assessment: still needed, ready to finalise.** The building blocks the proposal cites all exist and the gap analysis ("no reconciliation algorithm, no fan-out, single-review assumption") remains accurate. One adjacent asset has appeared since the proposal was written — the deep-review workflow set of 2026-07-03 (`00-project/plans/deep-review-plans/`) — which overlaps on fact-verification and should be integrated, not duplicated (see P2-4).

### P0

None. The proposal is a pre-adoption study artifact; no finding blocks anything currently shipping.

### P1

**P1-1. Launch snippet uses a nonexistent `--prompt` flag — S2/P1**
- **Rationale:** The "Launch Mechanics" section shows `opencode run -m openai/gpt-5.1 --prompt "..."`. Every working example in the asset it claims to reuse (`00-Meta-Workflow/00-orchestrator/orchestrator-plan-review.md:96-99` and `orchestrator-review.sh`) passes the prompt as a **positional argument** to `opencode run`, not via a `--prompt` flag. Copied as written, the fan-out loop fails at launch for every pass.
- **Actionable fix:** Change the snippet to positional-prompt form. Add a Phase 2 task: validate the exact CLI invocation against `opencode run --help` (installed: opencode 1.17.13) before writing the launcher, and shellcheck the launcher script.

**P1-2. "Reused verbatim" orchestrator prompt violates the proposal's own single-writer invariant — S2/P1**
- **Rationale:** The proposal states the orchestrator workflow's mechanics are "reused verbatim." But `orchestrator-plan-review.md` builds a `REVIEW_PROMPT` that instructs the delegated reviewer to *"Append the review addendum to the plan document"* (script section, step 3 of the prompt). That is precisely the concurrent-write pattern the proposal's key invariant ("No pass ever edits `PLAN.md`") exists to prevent. With N parallel passes, verbatim reuse produces N concurrent writers to `PLAN.md`.
- **Actionable fix:** Phase 2 must fork or parameterize the delegation prompt: each pass writes **only** its own artifact under `PLAN.reviews/` and is explicitly told not to touch the plan file. Add a post-run guard: after `wait`, diff `PLAN.md` against its pre-launch hash and fail the run if any pass modified it.

**P1-3. Motivating evidence is stale/unverifiable in this repo — S2/P1**
- **Rationale:** The worked example and References cite `project/plans/2026-05-14-multi-speaker-podcast-audio-generation-implementation-plan.md` and commit `116cd56`. Neither exists: `find` across the Update-AI-Tools worktree returns no matching file, and `git log --all` in both Update-AI-Tools and Workflow-Scripts contains no commit `116cd56` (verified 2026-07-03). The example presumably lived in a different consumer repo. A proposal whose thesis is "stale paths slip past confident reviewers" currently contains an unverifiable stale path as its own primary evidence.
- **Actionable fix:** In the finalised plan, mark the worked example as historical/external-repo and select a pilot plan that exists in this workspace (e.g., an active plan under `00-project/plans/` or the consumer repo's `project/plans/`). Do not carry the dead path forward as a normative reference.

### P2

**P2-1. Fingerprint clustering is not actually deterministic as specified — S2/P2**
- **Rationale:** The fingerprint is defined as "lowercased, stop-word-stripped join of the primary `file:line` + the **head noun of the title**." Head-noun extraction is a linguistic judgment call; two reconciler runs (or models) will disagree on titles like "Stale prompt directory path breaks Phase 2." The stop-word list is also unspecified. The claimed determinism — the property the whole merge rests on — does not hold.
- **Actionable fix:** Redefine v1 fingerprint to use only mechanically-derivable parts: normalized evidence locator (`<repo-relative-path>` + line number bucketed to a range, or bare commit hash), dropping the title entirely from the key. Title stays display-only. Specify the exact normalization steps (case-fold, path-separator normalization, line-bucket size) in the schema doc.

**P2-2. Four conflicting filename/timestamp conventions must be reconciled in Phase 1 — S3/P2**
- **Rationale:** (a) `01-plan-review.md:64` uses `PLAN.review.<model>.YYYY-MM-DD-HH-MM.md`; (b) the proposal uses `...YYYY-MM-DD-HHMM.md`; (c) `orchestrator-review.sh` generates `YYYYMMDD-HHMMSS-<plan>-review.md`; (d) `00-Meta-Workflow/00-meta/naming-conventions.md:12` prescribes `{report-type}-YYMMDD-HHMM-{model}.md` for reports. A reconciler and manifest that parse filenames cannot tolerate four formats.
- **Actionable fix:** Phase 1 picks one canonical pattern for review artifacts, records the decision in the schema doc, and updates `01-plan-review.md` (and the orchestrator script's default, when touched in Phase 2) to match. Recommendation: keep the dotted `01-plan-review.md` shape with the proposal's role segment and a `YYYY-MM-DD-HHMM` timestamp, since sibling `PLAN.reviews/` artifacts are plan-scoped, not `research/` reports.

**P2-3. Reconciliation math is undefined for the most common degraded case (N=2, no mode) — S2/P2**
- **Rationale:** Rule 2 says severity = mode, else "median rounded toward higher." With two passes disagreeing (S2 vs S3) there is no mode and the median falls between bands; the rule's output is ambiguous exactly when quorum has degraded to 2-of-3 — the scenario the proposal itself illustrates in `_manifest.json`. Schema validation ("validate each artifact before reconcile") also names no mechanism or owner.
- **Actionable fix:** Specify: for even splits, take the **higher** severity/priority and record the spread (consistent with the rubric's "default to higher likelihood," bounded by its "avoid inflation" note via mandatory spread recording). Add a human-adjudication trigger when spread ≥ 2 bands. Define schema validation as a required reconciler pre-step checklist (v1 is manual; no validator code).

**P2-4. No integration with the 2026-07-03 deep-review evidence tiers — S3/P2**
- **Rationale:** The deep-review workflow set (`00-project/plans/deep-review-plans/2026-07-03-deep-review-00-overview.md`), created after this proposal, already establishes **CONFIRMED / PLAUSIBLE** evidence tiers and an independent different-model verification pass — conceptually the same move as the reconciler's "facts get verified, not voted." Two parallel evidence-discipline vocabularies in one repo will drift.
- **Actionable fix:** Add an `evidence_tier` field (CONFIRMED | PLAUSIBLE) to the per-finding schema, with the deep-review definition. The reconciler's fact-verification step promotes PLAUSIBLE→CONFIRMED (or refutes). Cite the deep-review overview as the tier authority.

**P2-5. Hardcoded `project/plans/` path does not cover Workflow-Scripts' own plans — S3/P2**
- **Rationale:** Artifact layout and finalisation both assume `project/plans/`. Workflow-Scripts meta plans live in `00-project/plans/` (per its `plans/README.md`), and the deep-review overview already defines a resolution order (`project/` → `00-project/` → repo-root fallback) for exactly this reason.
- **Actionable fix:** Reference the same resolution order in the schema doc instead of a literal path.

### P3

**P3-1. Severity-inflation tension (Open Question 3) — S3/P3**
- **Rationale:** "Round toward higher" across many passes ratchets scores upward, in tension with the rubric's explicit anti-inflation note. Already acknowledged as an open question; P2-3's spread-recording + adjudication trigger is a sufficient v1 answer.
- **Actionable fix:** Adopt the P2-3 rule as the default; revisit only with data from pilot runs.

**P3-2. Scope/over-engineering check — S3/P3**
- **Rationale:** The proposal is appropriately self-guarded (high-impact plans only; deterministic v1; embeddings deferred). One sequencing improvement: the launcher (Phase 2) is automation convenience, while the proposal itself calls the reconciler "P0 of the system's value." Fan-out can be performed manually (two terminal invocations) before any launcher exists.
- **Actionable fix:** Reorder phasing so the schema + reconciler ship and get piloted manually first; build the launcher only after one manual pilot proves the schema merges cleanly. Keep Phases 4–5 (roles, embeddings) and CI gating deferred.

### Missing steps and dependencies (explicit)

- **Reconciler identity default (Open Question 4):** finalised plan must pick one — recommended: the orchestrating session acts as reconciler; it must not be one of the pass models when cross-vendor diversity was the goal.
- **Canonical output (Open Question 5):** recommended: consolidated addendum on `PLAN.md` is canonical; `02-finalise-plan.md` next-version plan is optional follow-on. `_reconciliation.md` is audit trail.
- **`PLAN.reviews/` fate:** `02-finalise-plan.md` (steps 7–8) requires an explicit keep/archive/delete decision after consolidation; the proposal never states one. Default: keep until the consolidated addendum is accepted, then archive per `plans-completed` conventions.
- **Timeout defaults:** inherit the orchestrator workflow's 30-minute per-pass default; state it in the manifest schema.
- **Draft-then-promote lifecycle:** per `00-project/plans/TODO.md` precedent (deep-review set), new workflow docs start as drafts under `00-project/plans/` and are promoted to numbered workflow directories after battle-testing.

### Acceptance-criteria check (per `01-plan-review.md`)

- Findings priority-ordered P1→P3, severity-ordered within priority: ✔
- Every finding has evidence (file:line or live-worktree verification) and an actionable, measurable fix: ✔
- Ambiguities/missing steps explicitly listed: ✔ (section above)
- Over-engineering check explicit, MVP alternative recommended: ✔ (P3-2)

#### 2026-07-03 23:42 — Correction to P1-1 (Model: claude-fable-5)

New evidence: `00-project/research/opencode-parameters.md` (extracted `opencode --help`, v1.17.13) plus a live `opencode run --help` check.

- `--prompt` **does exist** — but only as a top-level `opencode` option (TUI/serve entry point). It is **not listed** by `opencode run --help`; the `run` subcommand takes the message as the `[message..]` positional.
- **Conclusion of P1-1 unchanged** for the proposal's snippet, which uses `opencode run ... --prompt`: the launcher must pass the prompt positionally. Severity/priority unchanged (S2/P1).
- Bonus findings for the launcher (Phase 4 of the finalised plan): `opencode run` supports `--format json` (machine-parseable events for `_manifest.json` status capture), `--title` (session naming per pass), `--variant` (reasoning-effort control), and `-f/--file` (attach the plan file directly instead of relying on the pass to read it).
