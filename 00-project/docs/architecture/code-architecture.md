# Code Architecture

Workflow-Scripts is primarily a **Markdown instruction library**. Executable code is limited to shell sync/validation scripts and one embedded TypeScript package.

## Entry Points

| Entry | Path | Role |
|-------|------|------|
| Repository hub | `README.md` | Category index, quick-start, conventions |
| Sync model | `SHARING_AND_SYNC.md` | Multi-repo clone documentation |
| Pull updates | `scripts/pull-workflows.sh` | Consumer pull helper |
| Maintainer push | `scripts/update-workflows.sh` | Commit + push staged changes |
| Multi-project sync | `scripts/sync-workflow-scripts.sh` | Batch pull across host projects |
| Orchestrator | `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh` | Delegated plan review |
| Image generation lib | `08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/` | Multi-provider image API |

## High-Level Layout

```
Workflow-Scripts/
├── *.md workflows (by category)     ← primary "source code"
├── scripts/                         ← bash maintenance + validation
├── 00-Meta-Workflow/                ← orchestrator, meta templates, reports
├── 00-project/                      ← meta changelog, plans, docs, troubleshooting
├── 11-Skills/*/SKILL.md             ← skill trigger documents
└── 08-API-Integration/.../src/      ← TypeScript (only substantive code package)
```

## Layers and Boundaries

### Layer 1: Workflow instructions

Markdown files define agent-executable processes. They are **not compiled** — correctness is enforced by review, link validation, and convention.

Conventions:
- Numbered prefixes (`01-`, `02-`) indicate sequence within a category
- Outputs go to host `plans/` with dated filenames per `00-meta/naming-conventions.md`
- Flexible agent spawning ("suggested roles, spawn additional as needed")

### Layer 2: Shell automation

All scripts use `set -euo pipefail` (or equivalent strict mode). Scripts resolve repo root via `REPO_ROOT` rather than assuming cwd.

| Script | Pattern |
|--------|---------|
| `pull-workflows.sh` | Safety gates → `git pull --ff-only` |
| `update-workflows.sh` | Stage → commit → push (maintainer) |
| `sync-workflow-scripts.sh` | Iterate `PROJECTS[]` with `--status`, `--dry-run`, `--auto` |

Environment variables: `WORKFLOW_SYNC_BASE_DIR`, `WORKFLOWS_BRANCH`, `NON_INTERACTIVE`, `WORKFLOW_SYNC_PROJECTS`.

### Layer 3: Validation

| Script | Checks |
|--------|--------|
| `check-active-markdown-links.sh` | Active Markdown link integrity (skips archives) |
| `check-orchestrator-review.sh` | Orchestrator review workflow consistency |

### Layer 4: Skills

Each skill bundle:

```
11-Skills/<skill-name>/
├── SKILL.md          ← trigger + workflow pointer
└── agents/openai.yaml ← agent config stub
```

Skills are **thin** — they route to full workflows, not duplicate them.

### Layer 5: `@ai-sdk/image-generation`

TypeScript package with provider abstraction:

```
src/
├── index.ts           ← public exports
├── core/              ← generator, registry
├── providers/         ← openai, google, xai, fal
├── config/            ← configuration
└── utils/             ← helpers
```

Tested with vitest under `tests/unit/`.

## Conventions

- **Priority ordering**: P0 → P3 across all workflows
- **Severity ordering**: S0 → S3 within same priority
- **Task marking**: `- [✅]` complete, `- [ ]` pending (see `04-documentation/03-mark-completed.md`)
- **Changelog**: One file per change in `00-project/changelog/<type>/`
- **No secrets in docs**: Document env var names only

## Key Abstractions

| Abstraction | Implementation |
|-------------|----------------|
| Workflow category | Top-level numbered directory + README |
| Rubric | `00-Meta-Workflow/00-meta/severity-priority-rubric.md` |
| Report naming | `{type}-YYMMDD-HHMM-{model}.md` |
| Meta vs consumer paths | `00-project/` ↔ host `project/` |

## Extension Points

- Add workflow: new `.md` in appropriate category + update category README
- Add skill: new directory under `11-Skills/` with `SKILL.md`
- Add validation: new script under `scripts/validation/`
- Add provider: extend `providers/` in image-generation package