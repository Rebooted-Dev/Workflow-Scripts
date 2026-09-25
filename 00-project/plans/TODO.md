# Current Tasks

Keep this file up to date as tasks involving the `00-project/` directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Reference — filing completed plans

When a plan is finished and should be archived, follow **`plans-completed/README.md`**:

1. Move the plan file from `plans/` or `build/` to **`plans-completed/<category>/`** (pick category: `implementation`, `investigation`, `migration`, `review`, or `tooling`).
2. Add a row at the top of **`plans-completed/index.md`** (Date, Category, Title, File, Notes).
3. Add a row at the top of **`changelog/index.md`** with Type=`plan` and File **`../plans-completed/<category>/<filename>`**.

**Alternate:** If you explicitly want the plan under **`changelog/plans/`** only, file there and use File `plans/...` in the changelog index.

## Active

- [ ] [Drag-Free-v2 engineering-quality and lifecycle proposal](Drag-Free-v2/2026-07-06-engineering-quality-and-lifecycle-proposal.md): decide the remaining open KIs recorded in its 2026-09-26 review addendum. Only KI-13 code-design/error-handling and KI-14 tiered plan sections are superseded; observability, architecture/ADR, greenfield, deployment, full debt ledger/budget, and registry work remain open.
- [ ] Flash-UI forward plan-template pilot — deferred to the Flash-UI owner. Named follow-up: owner selects and explicitly authorizes the next non-trivial Flash-UI plan; then run the host-side `check-plan.sh` and post-build Change Surface searches in that host. No host edits before approval.
- [ ] [Planning and code-build workflow quality plan](2026-09-25-planning-and-build-workflow-quality-implementation-plan.md): Phase 0 and A–D are locally implemented; Phase E tasks 1–2 are locally evidenced. **Active — Not Eligible:** Plan 01 owns the four known broken links (see the existing v1.82-fixes row below); remote CI requires those repairs and separate push authorization. The Flash-UI pilot remains deferred (see its existing item above). Optional S3 follow-up: after Plan 01 repairs the links, consider a separately authorized expansion of `scripts/hooks/pre-commit` to run completion-chain/planning-build validators and `check-plan.sh` for staged Tier plans; no hook change is made now. Parent's independent `02-confirm-execution.md` and `03-mark-completed.md` Reconcile-only terminal gate remains pending.
- [ ] [v1.82-fixes plan set](v1.82-fixes/00-meta-v1-82-fixes-roadmap.md): Plan 02 completion-chain audit filed Verified Complete; reconcile source integrity first; continue harness discovery; keep Astra evaluation blocked until protocol/arm gates pass; behavior-rule work remains approval-gated; skills adoption is KIV/deferred by user and not active without a new explicit request.
- [ ] Execute `2026-09-10-astra-instruction-evaluation-plan.md` (Phase 5 split from the instruction remediation plan): build the corpus/harness, fix the baseline pin to `64acb75`, smoke-test, then run the pilot before the full matrix. No Astra improvement claim until the adoption gate passes.
- [ ] Tidy `00-Meta-Workflow/00-meta/agent-flexibility-review.md`: it is still `Status: Active` while carrying `02-build-code/...` references (lines 211, 390, 407). Mark historical like `parallel-agents-review.md` or correct the refs.
- [ ] Review `2026-07-06-workflow-system-v2-redesign-proposal.md` (full-autonomy v2 redesign: frontmatter+catalog, core partials, `wf` CLI, harness compiler, CI enforcement; drafted 2026-07-06). Run `01-plan-review.md` with a different model, then finalise.
- [ ] Execute `2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md` (multi-model plan-review fan-out + reconciler; finalised 2026-07-03 from the 2026-06-03 research proposal + its review addendum). Start with Phase 1 (schema/conventions spec).
- [ ] Migrate legacy meta content from `00-Meta-Workflow/` into `00-project/` (optional follow-up)
- [ ] Battle-test the deep-review workflow set (`2026-07-03-deep-review-00-overview.md`, `-01-review-pass.md`, `-02-verification-pass.md`) on a consumer repo, then promote it to a numbered workflow (e.g. `05-review/05-deep-review.md`) and index it in `05-review/README.md`
- [ ] Measure `scripts/sync-workflow-scripts.sh --status` across at least 5 configured projects before considering parallel fetch optimization; if implemented later, keep fetch parallelism separate from status rendering and preserve `scripts/validation/check-sync-workflow-scripts.sh` behavior.
