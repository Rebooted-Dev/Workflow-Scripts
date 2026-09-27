# Current Tasks

Keep this file up to date as tasks involving the `00-project/` directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Reference — filing completed plans

When a plan is finished and should be archived, follow **`plans-completed/README.md`**:

1. Move the plan file from `plans/` or `build/` to **`plans-completed/<category>/`** (pick category: `implementation`, `investigation`, `migration`, `review`, or `tooling`).
2. Add a row at the top of **`plans-completed/index.md`** (Date, Category, Title, File, Notes).
3. Add a row at the top of **`changelog/index.md`** with Type=`plan` and File **`../plans-completed/<category>/<filename>`**.

**Alternate:** If you explicitly want the plan under **`changelog/plans/`** only, file there and use File `plans/...` in the changelog index.

## Active

- [ ] [Drag-Free-v2 engineering-quality and lifecycle proposal](Drag-Free-v2/2026-07-06-engineering-quality-and-lifecycle-proposal.md): decide the remaining open KIs recorded in its 2026-09-26 review addendum. Only KI-13 code-design/error-handling and KI-14 tiered plan sections are superseded; observability, architecture/ADR, greenfield, deployment, full debt ledger/budget, and registry work remain open. **Open KI-12 debt:** standalone ADRs in `<metadata-root>/decisions/`, location policy in `00-Meta-Workflow/00-meta/naming-conventions.md`; trigger: first T3 plan or first one-way decision; severity S3.
- [ ] Flash-UI forward plan-template pilot — deferred to the Flash-UI owner. Named follow-up: owner selects and explicitly authorizes the next non-trivial Flash-UI plan; then run the host-side `check-plan.sh` and post-build Change Surface searches in that host. No host edits before approval.
- [ ] **Quality-plan Deferred & Debt** (from archived [`../plans-completed/implementation/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md`](../plans-completed/implementation/2026-09-25-planning-and-build-workflow-quality-implementation-plan.md); triggers unchanged):
  - Behavioral evidence — v1.82 Plan 03 harness; trigger: concept test passes; S2.
  - Superseded-plan lint — `scripts/validation/check-plan.sh`; trigger: first observed stale-TODO case; S3.
  - Research filename convention — `00-project/research/`; trigger: next meta-hygiene plan; S3.
  - Host-project verify gates — `00-project-setup/`; trigger: next project setup; S3.
  - Flash-UI forward plan-template pilot — host owner authorization; S3.
  - Standalone ADRs — `<metadata-root>/decisions/`; trigger: first T3 plan or one-way decision; S3.
- [ ] [v1.82-fixes plan set](v1.82-fixes/00-meta-v1-82-fixes-roadmap.md): Plan 01 source integrity Verified Complete (`9714c15`); Plan 02 audit filed Verified Complete; continue harness discovery (Plan 03); keep Astra evaluation blocked until arm gates pass (Plan 05); behavior-rule work remains approval-gated (Plan 04); skills adoption is KIV/deferred by user.
- [ ] Execute the [Astra Instruction Evaluation Plan](../research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md) only after required Plan 05 gates pass (protocol filed on `9714c15`; arm selection still pending). Route execution through [Plan 05](v1.82-fixes/05-run-astra-instruction-evaluation.md). Baseline pinned to `64acb75`. No experiment or arm selection is authorized now.
- [ ] Review `2026-07-06-workflow-system-v2-redesign-proposal.md` (full-autonomy v2 redesign: frontmatter+catalog, core partials, `wf` CLI, harness compiler, CI enforcement; drafted 2026-07-06). Run `01-plan-review.md` with a different model, then finalise.
- [ ] Execute `2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md` (multi-model plan-review fan-out + reconciler; finalised 2026-07-03 from the 2026-06-03 research proposal + its review addendum). Start with Phase 1 (schema/conventions spec).
- [ ] Migrate legacy meta content from `00-Meta-Workflow/` into `00-project/` (optional follow-up)
- [ ] Battle-test the deep-review workflow set (`2026-07-03-deep-review-00-overview.md`, `-01-review-pass.md`, `-02-verification-pass.md`) on a consumer repo, then promote it to a numbered workflow (e.g. `05-review/05-deep-review.md`) and index it in `05-review/README.md`
- [ ] Measure `scripts/sync-workflow-scripts.sh --status` across at least 5 configured projects before considering parallel fetch optimization; if implemented later, keep fetch parallelism separate from status rendering and preserve `scripts/validation/check-sync-workflow-scripts.sh` behavior.
