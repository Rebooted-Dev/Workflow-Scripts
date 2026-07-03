# Current Tasks

Keep this file up to date as tasks involving the `00-project/` directory are completed (check off items, add changelog row or troubleshooting entry as needed).

## Reference — filing completed plans

When a plan is finished and should be archived, follow **`plans-completed/README.md`**:

1. Move the plan file from `plans/` or `build/` to **`plans-completed/<category>/`** (pick category: `implementation`, `investigation`, `migration`, `review`, or `tooling`).
2. Add a row at the top of **`plans-completed/index.md`** (Date, Category, Title, File, Notes).
3. Add a row at the top of **`changelog/index.md`** with Type=`plan` and File **`../plans-completed/<category>/<filename>`**.

**Alternate:** If you explicitly want the plan under **`changelog/plans/`** only, file there and use File `plans/...` in the changelog index.

## Active

- [ ] Migrate legacy meta content from `00-Meta-Workflow/` into `00-project/` (optional follow-up)
- [ ] Battle-test the deep-review workflow set (`2026-07-03-deep-review-00-overview.md`, `-01-review-pass.md`, `-02-verification-pass.md`) on a consumer repo, then promote it to a numbered workflow (e.g. `05-review/05-deep-review.md`) and index it in `05-review/README.md`
- [ ] Measure `scripts/sync-workflow-scripts.sh --status` across at least 5 configured projects before considering parallel fetch optimization; if implemented later, keep fetch parallelism separate from status rendering and preserve `scripts/validation/check-sync-workflow-scripts.sh` behavior.
