# File Map

## How To Navigate

This map covers the Workflow-Scripts repository. Each directory has a `README.md` with navigation guidance specific to that directory.

## Directory Tree

```
Workflow-Scripts/
├── .git/                          # Git repository metadata
├── .gitignore                     # macOS/editor ignores
├── README.md                      # Master workflow index (START HERE)
├── CHANGELOG.md                   # Full version history
├── SHARING_AND_SYNC.md            # Multi-project sharing guide
├── sync-workflow-scripts.sh       # Cross-project sync script
├── pull-workflows.sh              # Single-project pull script
├── update-workflows.sh            # Maintainer commit/push script
│
├── 00-docs/                       # Internal reviews and reports
│   ├── README.md
│   ├── CODE-REVIEW-WORKFLOW-SCRIPTS-2026-02-28.md
│   ├── 2026-02-28-implementation-plan-workflow-scripts-remediation.md
│   ├── WORKFLOW_TO_SKILLS_MAPPING_REPORT.md
│   └── old-reviews/
│
├── 00-meta/                       # Templates, rubrics, analysis docs
│   ├── README.md                  # Index with active vs historical status
│   ├── severity-priority-rubric.md # P0-P3 / S0-S3 scoring rubric
│   ├── sync-summary-template.md   # Template for sync summaries
│   ├── agent-flexibility-review.md # Agent pattern analysis
│   ├── parallel-agents-review.md  # Historical parallel agent review
│   └── filename-review.md         # Filename convention analysis
│
├── 00-orchestrator/               # Non-interactive AI delegation
│   ├── README.md                  # Architecture and use cases
│   ├── orchestrator-plan-review.md # Delegated review workflow
│   └── orchestrator-review.sh     # Shell script for OpenCode
│
├── 00-project-setup/              # Project initialization
│   ├── README.md                  # Decision guide
│   ├── 01-setup-project.md        # Full project setup
│   ├── 02-optimize-workflow-scripts.md
│   ├── 03-sync-workflow-scripts.md
│   ├── 04-track-repos-and-agent-map.md
│   ├── 05-mcp-and-config-setup.md
│   └── 06-skills-setup.md
│
├── 01-planning/                   # Research and planning
│   ├── README.md
│   ├── 00-research-and-plan.md    # Entry point for new work
│   ├── 01-plan-review.md          # Plan correctness review
│   └── 02-finalise-plan.md        # Priority-ordered plan
│
├── 02-build-code/                 # Implementation execution
│   ├── README.md                  # Workflow sequence diagram
│   ├── 01-execution.md            # Phase-based implementation
│   ├── 02-confirm-execution.md    # Post-execution verification
│   ├── 03-execute-and-confirm.md  # Combined execute+confirm
│   └── 03-execute-plan.md         # Plan execution variant
│
├── 03-debug/                      # Bug identification and fixing
│   ├── README.md                  # File ordering note
│   ├── 01-bug-description.md      # Bug report intake
│   └── 02-bug-fix-workflow.md     # Hypothesis-driven fix
│
├── 04-documentation/              # Documentation maintenance
│   ├── README.md                  # Priority buckets
│   ├── 00-doc-templates.md        # Documentation templates
│   ├── 01-create-docs.md          # Create new documentation
│   ├── 02-sync-documentation.md   # Sync docs with codebase
│   ├── 03-mark-completed.md       # Verify completion claims
│   ├── 09-optional.md             # Optional doc tasks
│   └── ascii-art-prompts.md       # Diagram prompts
│
├── 05-review-audit/               # Code review and quality
│   ├── README.md                  # Decision guide
│   ├── 01-code-review.md          # Structured code review
│   ├── 02-code-optimization.md    # Performance analysis
│   └── 03-code-refactoring.md     # Code quality analysis
│
├── 06-security/                   # Security review and fixes
│   ├── README.md                  # Review→fix sequence
│   ├── 01-security-review.md      # Structured security audit
│   └── 02-security-fix.md         # Vulnerability remediation
│
├── 07-deployment/                 # Deployment guides
│   ├── README.md                  # Decision tree
│   ├── 01a-MACOS_ELECTRON_GUIDE.md
│   ├── 01b-electron-vite.md
│   ├── 02-ai-studio-to-desktop.md
│   ├── 08-port-relocation/
│   ├── 08-pre-deployment-security-check.md
│   ├── 09-react-bug.md
│   ├── 10-firebase-setup.md
│   └── 11-nginx.md
│
├── 08-API-Integration/            # API integration guides
│   ├── README.md                  # Navigation with decision tree
│   ├── 01-genkit/                 # Genkit integration
│   ├── 02-AI-SDK/                 # AI SDK integration
│   └── backups/                   # Archived older versions
│
└── 10-User-Manual/                # This documentation
    ├── README.md                  # Documentation index
    ├── user-manual/               # End-user guide
    ├── developer-guide/           # Developer guide
    ├── workflow-reference/        # All workflows
    ├── helper-scripts/            # Shell script reference
    └── contributing/              # Contributing guide
```

## Key Files

| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | Master workflow index with decision table | Everyone |
| `CHANGELOG.md` | Version history and release notes | Maintainers |
| `SHARING_AND_SYNC.md` | How to share workflows across projects | Multi-project users |
| `00-meta/severity-priority-rubric.md` | P0-P3 and S0-S3 scoring standards | All workflows |
| `01-planning/00-research-and-plan.md` | Entry point for new work | Developers |
| `02-build-code/01-execution.md` | Phase-based implementation | Developers |
| `04-documentation/00-doc-templates.md` | Templates for generated docs | Documentation |
| `sync-workflow-scripts.sh` | Cross-project sync automation | Multi-project users |
| `pull-workflows.sh` | Single-project update script | End users |
| `update-workflows.sh` | Maintainer commit/push script | Maintainers |

## Common Tasks Map

| Task | Start Here |
|------|-----------|
| New feature | `01-planning/00-research-and-plan.md` |
| Bug fix | `03-debug/02-bug-fix-workflow.md` |
| Code review | `05-review-audit/01-code-review.md` |
| Security audit | `06-security/01-security-review.md` |
| Performance optimization | `05-review-audit/02-code-optimization.md` |
| Update docs | `04-documentation/02-sync-documentation.md` |
| Project setup | `00-project-setup/01-setup-project.md` |
| Deploy | `07-deployment/README.md` |
| API integration | `08-API-Integration/README.md` |
| Non-interactive review | `00-orchestrator/orchestrator-review.sh` |
