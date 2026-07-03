# Testing

## Testing Strategy

Workflow-Scripts uses **three verification layers**:

1. **Shell validation scripts** — link integrity, orchestrator consistency
2. **Package unit tests** — `@ai-sdk/image-generation` vitest suite
3. **Workflow verification conventions** — build/test steps defined in consumer execution workflows

There is **no repo-wide test suite** for Markdown workflow content.

## Validation Scripts

Run from Workflow-Scripts root:

```bash
./scripts/validation/check-active-markdown-links.sh
./scripts/validation/check-orchestrator-review.sh
```

| Script | Scope |
|--------|-------|
| `check-active-markdown-links.sh` | Active Markdown links (skips `backups/`, `old-reviews/`) |
| `check-orchestrator-review.sh` | Orchestrator review workflow paths and behavior |

Recommended before maintainer push.

## Package Unit Tests

Location: `08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/`

```bash
cd 08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation
npm install
npm test        # vitest
npm run build   # if configured
```

Covers provider adapters, request rewriting, retry classification, and registry behavior.

## Workflow Verification (Consumer Projects)

Execution workflows (`02-code-build/01-execution.md`) assume consumer projects have:

- `npm run build` (or equivalent)
- `npm run dev` for manual verification
- Project-specific test commands

These steps apply to **host application code**, not Workflow-Scripts Markdown.

## Writing New Tests

| Change type | Add test when |
|-------------|---------------|
| Shell script behavior change | Manual verification + consider shellcheck |
| Image-generation package change | vitest unit test in `tests/unit/` |
| Workflow instruction change | Link validation pass; spot-check acceptance criteria |
| Bug fix in scripts | Regression note in `00-project/troubleshooting/` |

## Test Coverage

No aggregate coverage report for the repo. Image-generation package may report vitest coverage when enabled locally.

## Best Practices

- Run link validation after renaming directories or moving files
- Run orchestrator check after editing `00-orchestrator/` files
- For bug fixes, add troubleshooting entry per `00-project/AGENTS.md`
- Prefer `set -euo pipefail` in new shell scripts (matches existing convention)