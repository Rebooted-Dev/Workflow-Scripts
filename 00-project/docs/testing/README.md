# Testing

## Testing Strategy

Workflow-Scripts uses **three verification layers**:

1. **Shell validation scripts** — link integrity, orchestrator consistency, sync/publish contracts, review workflow policy
2. **Package unit tests** — `@ai-sdk/image-generation` vitest suite
3. **Workflow verification conventions** — build/test steps defined in consumer execution workflows

There is **no repo-wide test suite** for Markdown workflow content.

## Validation Scripts

Run from Workflow-Scripts root:

```bash
./scripts/validation/check-active-markdown-links.sh
./scripts/validation/check-orchestrator-review.sh
./scripts/validation/check-sync-workflow-scripts.sh
./scripts/validation/check-update-workflows.sh
./scripts/validation/check-review-workflow-policy.sh
./scripts/validation/check-completion-chain-policy.sh
./scripts/validation/check-meta-logs-selftest.sh
./scripts/validation/check-meta-logs.sh --range origin/v1.82..HEAD   # new commits only
```

| Script | Scope |
|--------|-------|
| `check-active-markdown-links.sh` | Active Markdown links (skips `backups/`, `old-reviews/`) |
| `check-orchestrator-review.sh` | Orchestrator review workflow paths, exit codes, output routing |
| `check-sync-workflow-scripts.sh` | Sync script portability (bash 3.2, `git -C`, SSH remote, env vars) |
| `check-update-workflows.sh` | Staged-only commit contract; rejects unstaged/untracked files |
| `check-review-workflow-policy.sh` | Agent policy refs, research output routing, no stale agent caps |
| `check-completion-chain-policy.sh` | Plan-level terminal-gate ownership, gate runs for every outcome (Full completion / Reconcile only), task ticks applied as tasks verify (01 ticks, 02 corrects both ways, gate verifies unticked tasks), host-policy archive routing, completion-chain navigation |
| `check-meta-logs.sh` | Changes outside `00-project/` add a changelog entry + index row; `fixed/` entries need a troubleshooting entry (or `**Troubleshooting:** not needed — <reason>`); troubleshooting entries need an index row. `--staged` runs as the pre-commit hook (`git config core.hooksPath scripts/hooks`); `--range` runs in CI on new commits |
| `check-meta-logs-selftest.sh` | Nine pass/fail cases for `check-meta-logs.sh` in a throwaway repo |

Run all of these before maintainer push. GitHub Actions runs the same suite via `.github/workflows/validation.yml`.

## Package Unit Tests

Location: `08-API-Integration/02-AI-SDK/src-core/@ai-sdk/image-generation/`

```bash
cd 08-API-Integration/02-AI-SDK/src-core/@ai-sdk/image-generation
npm install
npm test        # vitest
npm run build   # if configured
```

Covers provider adapters, request rewriting, retry classification, and registry behavior.

## Workflow Verification (Consumer Projects)

Execution workflows (`02-code-build/01-execution.md`) assume consumer projects have project-specific verification commands (build, test, dev). These steps apply to **host application code**, not Workflow-Scripts Markdown. Discover the host project's verification commands rather than assuming a universal `npm run build`.

## Writing New Tests

| Change type | Add test when |
|-------------|---------------|
| Shell script behavior change | Manual verification + consider shellcheck; extend validation script if policy-critical |
| Image-generation package change | vitest unit test in `tests/unit/` |
| Workflow instruction change | Link validation pass; spot-check acceptance criteria |
| Bug fix in scripts | Regression note in `00-project/troubleshooting/` |

## Test Coverage

No aggregate coverage report for the repo. Image-generation package may report vitest coverage when enabled locally.

## Best Practices

- Run all five validation scripts after renaming directories or moving files
- Run orchestrator check after editing `00-orchestrator/` files
- Run sync/update checks after editing publish or sync scripts
- For bug fixes, add troubleshooting entry per `00-project/AGENTS.md`
- Prefer `set -euo pipefail` in new shell scripts (matches existing convention)