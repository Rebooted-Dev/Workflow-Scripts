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
├── RELEASE_NOTES_v1.0.0.md
├── proj-organisation.md               # App vs repo-root layout runbook
├── media/                             # Assets (hero banner)
│
├── scripts/
│   ├── pull-workflows.sh
│   ├── update-workflows.sh
│   ├── sync-workflow-scripts.sh
│   ├── migrate-changelog.py           # One-time CHANGELOG migration helper
│   └── validation/
│       ├── check-active-markdown-links.sh
│       └── check-orchestrator-review.sh
│
├── 00-Meta-Workflow/
│   ├── 00-orchestrator/               # Delegated review (shell + workflow)
│   ├── 00-meta/                       # Rubrics, glossary, naming, templates
│   ├── 00-docs/                       # Generated reports, archived reviews
│   ├── 00-plans/                      # Legacy active plans index
│   └── 00-plans-completed/            # Legacy completed plans index
│
├── 00-project/                        # Meta workspace (this repo's "project/")
│   ├── AGENTS.md
│   ├── changelog/                     # One file per change + index.md
│   ├── troubleshooting/               # Bug/issue knowledge base
│   ├── plans/                         # Active plans, TODO.md
│   ├── plans-completed/               # Filed completed plans
│   └── docs/                          # This documentation set
│
├── 00-project-setup/                  # Consumer project bootstrap (7 workflows)
├── 01-Planning & Organizing/          # Research, review, finalise
├── 02-code-build/                     # Execution, confirm
├── 03-debugging/                      # Bug description, bug fix
├── 04-documentation/                  # Create docs, sync docs, mark completed
├── 05-review/                         # Code review, optimization, refactoring
├── 06-security/                       # Security review, security fix
├── 07-deployment/                     # Electron, ports, pre-deploy, SEO plans
├── 08-API-Integration/                # Genkit, AI SDK, MCP, misc deploy guides
├── 10 Technical Docs/Gemini/          # Offline Gemini API reference (14 files)
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
| `00-Meta-Workflow/00-meta/naming-conventions.md` | Report filename standard |
| `00-project-setup/01-setup-project.md` | Multi-repo bootstrap for consumers |
| `00-project-setup/03-sync-workflow-scripts.md` | Multi-project sync guide |
| `00-project/AGENTS.md` | Agent rules for Workflow-Scripts meta work |
| `00-project/docs/agents/changelog-and-troubleshooting.md` | Logging conventions |

## Consumer Path Mapping

| Consumer (host project) | Workflow-Scripts (this repo) |
|-------------------------|------------------------------|
| `project/changelog/` | `00-project/changelog/` |
| `project/troubleshooting/` | `00-project/troubleshooting/` |
| `project/plans/` | `00-project/plans/` |
| `project/plans-completed/` | `00-project/plans-completed/` |
| `docs/` | `00-project/docs/` |
| `AGENTS.md` (host root) | `00-project/AGENTS.md` |

## Common Tasks Map

| Task | Go to |
|------|-------|
| Pull latest workflows | `scripts/pull-workflows.sh` |
| Publish workflow edits | `scripts/update-workflows.sh` |
| Sync all host projects | `scripts/sync-workflow-scripts.sh` |
| Log a change | `00-project/changelog/` + `index.md` |
| File a bug fix | `00-project/troubleshooting/` + changelog |
| Generate docs | `04-documentation/01-create-docs.md` |
| Validate links | `scripts/validation/check-active-markdown-links.sh` |