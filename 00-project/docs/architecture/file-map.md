# File Map

## How To Navigate

1. **Need a workflow?** → Root [README.md](../../../README.md) quick-start table
2. **Setting up a host project?** → `00-project-setup/`
3. **Editing Workflow-Scripts itself?** → `00-project/` (changelog, plans, docs)
4. **Syncing across machines?** → `scripts/` + [SHARING_AND_SYNC.md](../../../SHARING_AND_SYNC.md)
5. **API integration reference?** → `08-API-Integration/`

## Directory Tree

```
Workflow-Scripts/
├── README.md                          # Main hub
├── SHARING_AND_SYNC.md                # Multi-repo clone model
├── media/                             # Assets (hero banner)
│
├── scripts/
│   ├── pull-workflows.sh
│   ├── update-workflows.sh            # Staged-only commit + push
│   ├── sync-workflow-scripts.sh       # Multi-project batch sync
│   └── validation/
│       ├── check-active-markdown-links.sh
│       ├── check-orchestrator-review.sh
│       ├── check-sync-workflow-scripts.sh
│       ├── check-update-workflows.sh
│       └── check-review-workflow-policy.sh
│
├── 00-Meta-Workflow/
│   ├── 00-orchestrator/               # Delegated review (shell + workflow)
│   ├── 00-meta/                       # Rubrics, glossary, naming, agent policy
│   ├── 00-docs/                       # Generated reports and archived references
│   │   ├── RELEASE_NOTES_v1.0.0.md   # Historical release record
│   │   └── proj-organisation.md      # Historical generic runbook
│   ├── 00-plans/                      # Legacy active plans index
│   └── 00-plans-completed/            # Legacy completed plans index
│
├── 00-project/                        # Meta workspace (this repo's "project/")
│   ├── AGENTS.md
│   ├── changelog/                     # One file per change + index.md
│   ├── troubleshooting/               # Bug/issue knowledge base
│   ├── plans/                         # Active plans, TODO.md
│   ├── plans-completed/               # Filed completed plans
│   ├── research/                      # Review/audit/research reports
│   ├── KIV/                           # Keep-in-view items
│   ├── build/archive/                 # Retired tooling (e.g. migrate-changelog.py)
│   └── docs/                          # This documentation set
│
├── 00-project-setup/                  # Consumer project bootstrap (7 workflows)
├── 01-planning-and-organizing/          # Research, review, finalise
├── 02-code-build/                     # Execution, confirm
├── 03-debugging/                      # Bug description, bug fix
├── 04-documentation/                  # Create docs, sync docs, mark completed
├── 05-review/                         # Code review, optimization, refactoring, website data, comprehensive audit
├── 06-security/                       # Security review, security fix
├── 07-deployment/                     # Electron, ports, pre-deploy, SEO plans
├── 08-API-Integration/                # Genkit, AI SDK, MCP, misc deploy guides
├── 10-technical-docs/Gemini/          # Offline Gemini API reference (14 topic files)
├── 11-Skills/                         # 14 Codex skill bundles
└── 12-SEO-GEO-checklist/              # SEO automation tasks + dashboard plans
```

## Key Files

| File | Role |
|------|------|
| `04-documentation/01-create-docs.md` | Spec for generating `00-project/docs/` |
| `04-documentation/00-doc-templates.md` | Section templates for all doc types |
| `04-documentation/03-mark-completed.md` | Completion marking and plan archiving |
| `00-Meta-Workflow/00-meta/severity-priority-rubric.md` | Shared P0–P3 / S0–S3 scoring |
| `00-Meta-Workflow/00-meta/naming-conventions.md` | Report filename and metadata-root routing |
| `00-Meta-Workflow/00-meta/agent-spawning-policy.md` | Parallel agent caps for review workflows |
| `00-project-setup/01-setup-project.md` | Multi-repo bootstrap for consumers |
| `00-project-setup/03-sync-workflow-scripts.md` | Multi-project sync guide |
| `00-project/AGENTS.md` | Agent rules for Workflow-Scripts meta work |
| `00-project/docs/agents/changelog-and-troubleshooting.md` | Logging conventions |
| `00-project/docs/architecture/2026-07-19-repository-license-decision.md` | Current root-license decision and follow-up trigger |
| `00-project/docs/architecture/2026-07-19-embedded-image-library-maintenance.md` | Embedded package maintenance and compatibility decision |

## Consumer Path Mapping

| Consumer (host project) | Workflow-Scripts (this repo) |
|-------------------------|------------------------------|
| `project/changelog/` | `00-project/changelog/` |
| `project/troubleshooting/` | `00-project/troubleshooting/` |
| `project/plans/` | `00-project/plans/` |
| `project/research/` | `00-project/research/` |
| `project/plans-completed/` | `00-project/plans-completed/` |
| `docs/` | `00-project/docs/` |
| `AGENTS.md` (host root) | `00-project/AGENTS.md` |

## Common Tasks Map

| Task | Go to |
|------|-------|
| Pull latest workflows | `scripts/pull-workflows.sh` |
| Publish workflow edits | `scripts/update-workflows.sh` (stage first) |
| Sync all host projects | `scripts/sync-workflow-scripts.sh` |
| Log a change | `00-project/changelog/` + `index.md` |
| File a bug fix | `00-project/troubleshooting/` + changelog |
| File a review report | `00-project/research/` (or host `project/research/`) |
| Generate docs | `04-documentation/01-create-docs.md` |
| Pre-publish validation | All five scripts under `scripts/validation/` |
