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
- [ ] [Planning and code-build workflow quality plan](2026-09-25-planning-and-build-workflow-quality-implementation-plan.md): Phase 0 and A–D are locally implemented; E1/E2 are evidenced; C6's fixed/troubleshooting pair is staged and parent `check-meta-logs.sh --staged` passed. E3 optional hook remains open/deferred; E4 parent ran `02-confirm-execution.md` and `03-mark-completed.md` in Reconcile only. The plan remains **Active — Not Eligible**: Plan 01 owns the four broken links (see nested mapping below); remote CI requires those repairs and separate push authorization. Flash-UI pilot remains deferred (see its existing item above). Optional hook: `scripts/hooks/pre-commit`; trigger after Plan 01 repairs the links and separate authorization; severity S3.
  - Plan 01 link handoff (targets relative to `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md`): `:7` and `:95` → the recovered protocol's filed location (planned `./2026-09-10-astra-instruction-evaluation-protocol.md`); `:96` → `../../plans-completed/tooling/2026-09-10-workflow-scripts-instruction-remediation-plan.md`; `:97` → `../../../00-Meta-Workflow/00-meta/workflow-applicability.md`. These are intended targets, not repaired links; Plan 01 owns source recovery and edits.
  - Open quality-plan Deferred & Debt (remain open in both plan and TODO):
    - Superseded-plan lint — location `scripts/validation/check-plan.sh`; trigger: first observed stale-TODO case; severity S3.
    - Research filename convention mixing — location `00-project/research/`; trigger: next meta-hygiene plan; severity S3.
    - Host-project verify gates — location `00-project-setup/`; trigger: next project setup; severity S3.
- [ ] [v1.82-fixes plan set](v1.82-fixes/00-meta-v1-82-fixes-roadmap.md): Plan 02 completion-chain audit filed Verified Complete; reconcile source integrity first; continue harness discovery; keep Astra evaluation blocked until protocol/arm gates pass; behavior-rule work remains approval-gated; skills adoption is KIV/deferred by user and not active without a new explicit request. **Open Deferred & Debt:** behavioral evidence, location `v1.82-fixes/03-run-parallel-agent-harness-concept-test.md`; trigger: harness concept test passes; severity S2.
- [ ] Execute `2026-09-10-astra-instruction-evaluation-plan.md` (Phase 5 split from the instruction remediation plan): build the corpus/harness, fix the baseline pin to `64acb75`, smoke-test, then run the pilot before the full matrix. No Astra improvement claim until the adoption gate passes.
- [ ] Tidy `00-Meta-Workflow/00-meta/agent-flexibility-review.md`: it is still `Status: Active` while carrying `02-build-code/...` references (lines 211, 390, 407). Mark historical like `parallel-agents-review.md` or correct the refs.
- [ ] Review `2026-07-06-workflow-system-v2-redesign-proposal.md` (full-autonomy v2 redesign: frontmatter+catalog, core partials, `wf` CLI, harness compiler, CI enforcement; drafted 2026-07-06). Run `01-plan-review.md` with a different model, then finalise.
- [ ] Execute `2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md` (multi-model plan-review fan-out + reconciler; finalised 2026-07-03 from the 2026-06-03 research proposal + its review addendum). Start with Phase 1 (schema/conventions spec).
- [ ] Migrate legacy meta content from `00-Meta-Workflow/` into `00-project/` (optional follow-up)
- [ ] Battle-test the deep-review workflow set (`2026-07-03-deep-review-00-overview.md`, `-01-review-pass.md`, `-02-verification-pass.md`) on a consumer repo, then promote it to a numbered workflow (e.g. `05-review/05-deep-review.md`) and index it in `05-review/README.md`
- [ ] Measure `scripts/sync-workflow-scripts.sh --status` across at least 5 configured projects before considering parallel fetch optimization; if implemented later, keep fetch parallelism separate from status rendering and preserve `scripts/validation/check-sync-workflow-scripts.sh` behavior.
