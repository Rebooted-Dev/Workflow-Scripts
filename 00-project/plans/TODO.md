# Current Tasks

Keep this file up to date as tasks involving the `00-project/` directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Reference — filing completed plans

When a plan is finished and should be archived, follow **`plans-completed/README.md`**:

1. Move the plan file from `plans/` or `build/` to **`plans-completed/<category>/`** (pick category: `implementation`, `investigation`, `migration`, `review`, or `tooling`).
2. Add a row at the top of **`plans-completed/index.md`** (Date, Category, Title, File, Notes).
3. Add a row at the top of **`changelog/index.md`** with Type=`plan` and File **`../plans-completed/<category>/<filename>`**.

**Alternate:** If you explicitly want the plan under **`changelog/plans/`** only, file there and use File `plans/...` in the changelog index.

## Active

- [✅] Review promoted Workflow-Scripts files at `Drag-Free-v2/` and merged metadata under `Drag-Free-v2/00-project/`, then promote into the live Workflow-Scripts repo
  - 2026-07-06 update: mechanical promotion into `Workflow-Scripts/` completed, excluding `.git/`, `.DS_Store`, and `Workflow-Scripts-consolidated/`. Recreated missing `tools/wf`, regenerated `catalog.json`, `ROUTER.md`, and `dist/skills/`, and verified the live repo with `bash scripts/validation/check-wf-cli.sh` plus fallback validators. The remaining 55 `wf validate` warnings stay tracked in the separate cleanup items below.
- [✅] Address remaining `tools/wf validate` warnings (55) documented in `Workflow-Scripts-consolidated/logs/README.md`: broken markdown links (35), stale path references (16), and ambiguous artifact defaults (4)
  - 2026-07-06 update: `tools/wf validate` now passes with 0 warnings: `Workflow-Scripts/` validates 258 frontmatter records and `Drag-Free-v2/` validates 260 frontmatter records.
- [✅] Fix broken link hotspots before re-running validation: `workflows/setup/01-setup-project.md`, `workflows/planning/`, `workflows/deployment/02-ai-studio-to-desktop.md`, and `reference/api-integration/03-higgsfield-mcp/`
  - 2026-07-06 update: `bash scripts/validation/check-active-markdown-links.sh` and `tools/wf validate` both pass.
- [✅] Update stale post-rationalization path references in `core/meta/` and `reference/meta-workflow/docs/` from legacy paths such as `02-build-code`, `03-debug/`, and `05-review-audit/` to canonical `workflows/...` paths
  - 2026-07-06 update: stale path warnings are cleared from `tools/wf validate`.
- [✅] Resolve ambiguous artifact defaults in setup and planning workflow frontmatter, especially `project/build/` and `changelog/plans/`
  - 2026-07-06 update: planning/setup/docs now state `project/plans/` as the default active-plan location, `project/build/` as an explicit project-map override/build-artifact location, `project/plans-completed/<category>/` as the default completed-plan archive, and `project/changelog/plans/` as an explicit alternate archive only.
- [✅] Add Workflow-Scripts GitHub Actions CI gate (`wf validate` + `wf build --check` + shellcheck)
  - 2026-07-06 update: added `.github/workflows/workflow-scripts-ci.yml`; local shellcheck and validation commands pass.
- [ ] Run real `tools/wf run plan-review` with a non-stub provider
  - 2026-07-06 update: command path was exercised against `00-project/plans/Drag-Free-v2/research/2026-07-06-workflow-system-v2-redesign-proposal.md` and produced a failed manifest under the plan's `.reviews/` directory. The sandboxed run reached OpenCode but failed opening `/Users/jesse/.local/share/opencode/log/opencode.log`; the escalated rerun was rejected because it would send repository plan content through an external provider path without explicit approval. Tracked in `00-project/troubleshooting/environment/2026-07-06-environment-opencode-plan-review-external-provider-approval.md`. **2026-07-10:** that proposal now lives at `workflows-drag-free/00-project/research/2026-07-06-workflow-system-v2-redesign-proposal.md`.
- [✅] Engineering-quality follow-up: `templates/walking-skeleton-checklist.md`, full review-workflow standards wiring, debt-budget rule, T3 pilot, survey re-run
  - 2026-07-06 update: added `core/standards/` partials, `core/debt-ledger.md`, `templates/walking-skeleton-checklist.md`, active `workflows/setup/08-greenfield-mvp.md`, active `workflows/deployment/00-deploy.md`, review standards wiring for optimization/refactoring, execution debt recording, planning debt consultation, finalise-plan debt-budget rule, restored missing rationalized planning targets (`workflows/planning/04-architecture-design.md`, `README.md`, `fable-like.md`), filed the survey rerun at `00-project/plans/Drag-Free-v2/research/workflow-engineering-quality-survey-rerun-260706-gpt5.md` (**2026-07-10:** now `workflows-drag-free/00-project/research/workflow-engineering-quality-survey-rerun-260706-gpt5.md`), and completed a real local T3 pilot at `00-project/build/t3-greenfield-pilot/hello-health/` with evidence in `00-project/build/t3-greenfield-pilot/2026-07-06-t3-greenfield-pilot-report.md`.

## Archive cleanup

These are cleanup tasks for `Drag-Free-v2/Workflow-Scripts-consolidated/` after the `working-tree-files/00-project` merge.

- [✅] Delete remaining `.DS_Store` files under `Workflow-Scripts-consolidated/`
  - 2026-07-06 update: removed the two remaining `.DS_Store` files from `Drag-Free-v2/Workflow-Scripts-consolidated/`.
- [✅] Remove now-empty `Workflow-Scripts-consolidated/working-tree-files/` after confirming it contains only filesystem metadata
  - 2026-07-06 update: confirmed the directory contained only `.DS_Store`, removed that file, then removed the empty directory.
- [✅] Decide whether to keep or delete `Workflow-Scripts-consolidated/ignored-generated/skills/`; it is generated output and can be regenerated from `11-Skills`
  - 2026-07-06 update: deleted `ignored-generated/skills/` as stale generated output; canonical sources remain `11-Skills/` and regenerated `dist/skills/`.
- [✅] Keep `Workflow-Scripts-consolidated/logs/` and `workflow-scripts-*.patch` / `workflow-scripts-*.txt` until the live Workflow-Scripts promotion/audit is complete, then archive or delete them
  - 2026-07-06 update: archived retained logs, patch files, status snapshots, and copied/untracked inventories under `00-project/build/archive/workflow-scripts-consolidated-2026-07-06/`; `Workflow-Scripts-consolidated/` now only retains `README.json` pointing to the archived evidence.

## Imported Workflow-Scripts tasks

These tasks came from the retained Workflow-Scripts `00-project` archive and should be handled against the live Workflow-Scripts repository when still relevant.

- [ ] Review `2026-07-06-workflow-system-v2-redesign-proposal.md` with a different model, then finalise.
- [✅] Execute `2026-07-03-multi-model-plan-review-pass-system-implementation-plan.md`, starting with Phase 1 schema/conventions.
  - 2026-07-06 update: Phases 1-5 completed. Phase 1 added shared artifact, manifest, cleanup, and source-resolution contracts plus sample manifests. Phase 2 added research/planning/review profile drafts, shared synthesis/reconciliation rules, synthetic dry-run outputs, and validator coverage. Phase 3 added local/manual research, planning, and review pilots under `00-project/build/adversarial-multi-model-workflow/runs/20260706-231500-phase3-manual-pilot/` plus `scripts/validation/check-adversarial-phase3-pilots.sh`. Phase 4 added staged launcher prototype `00-project/build/adversarial-multi-model-workflow/prototypes/fan-out-adversarial.sh`, local/manual research and review smoke configs/runs, protected-source hash negative coverage, and `scripts/validation/check-adversarial-launcher.sh`. Phase 5 filed the separate promotion plan at `00-project/plans/2026-07-06-adversarial-workflow-promotion-implementation-plan.md`; executing that promotion remains a separate approval-gated follow-up.
- [ ] Execute `2026-07-06-adversarial-workflow-promotion-implementation-plan.md` after explicit approval, promoting validated adversarial workflow drafts into active shared workflow surfaces.
- [✅] Migrate legacy meta content from `00-Meta-Workflow/` into `00-project/` if still needed.
  - 2026-07-06 update: audited all `00-Meta-Workflow/` rows in `MOVED.md`; migrated the 16 missing canonical targets into `reference/meta-workflow/`, `core/meta/`, and `tools/orchestrator/`; filed the decision at `00-project/research/2026-07-06-legacy-meta-workflow-migration-decision.md`. `00-project/` remains the metadata root, not the canonical home for reusable meta content.
- [✅] Battle-test the deep-review workflow set on a consumer repo, then promote it to a numbered workflow and index it in `05-review/README.md`.
  - 2026-07-06 update: battle-tested on the parent Update-AI-Tools repository with report filed at `project/research/deep-review-260706-2321-gpt5.md`; promoted to `workflows/review/06-deep-review.md`; indexed through `workflows/review/README.md` and the generated legacy `05-review/README.md` table.
- [✅] Measure `scripts/sync-workflow-scripts.sh --status` across at least 5 configured projects before considering parallel fetch optimization.
  - 2026-07-06 update: measured five explicit projects with `WORKFLOW_SYNC_PROJECTS`; filed results in `00-project/build/sync-status-measurements/2026-07-06-five-project-status.md`. Result: 1 up to date, 4 behind by 3 commits, 0 ahead/diverged/missing.
- [ ] Remove root redirect stubs from `README.md` and `SHARING_AND_SYNC.md` after the next release cycle following archive remediation.

## Completed

- [✅] Add active Drag-Free-v2 plans under `plans/Drag-Free-v2/` (research proposals + unified implementation plan in consolidated archive)
- [✅] Sync implementation checkboxes in `plans/Drag-Free-v2/research/` proposal and survey files (2026-07-06)
- [✅] Merge former `Workflow-Scripts-consolidated/working-tree-files/00-project` metadata into `Drag-Free-v2/00-project/` and delete the archived source directory (2026-07-06)
- [✅] Update current Drag-Free-v2 docs to stop pointing at the deleted archived `working-tree-files/00-project` path (2026-07-06)
- [✅] **2026-07-10:** Relocate Drag-Free-v2 plan package out of live ops meta — moved from `00-project/plans/Drag-Free-v2/` to `workflows-drag-free/00-project/` (`plans/` for implementation plans; `research/` for proposals, surveys, and review artifacts). `plans/Drag-Free-v2/` no longer exists under live `00-project/`.
- [✅] **2026-07-10:** Retire second tree `00-project/Drag-Free-v2/` — salvage nested consolidated logs, create `build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz`, delete directory; inventory at `build/archive/2026-07-10-drag-free-v2-salvage-inventory.md`. Master remains `workflows-drag-free/`.
