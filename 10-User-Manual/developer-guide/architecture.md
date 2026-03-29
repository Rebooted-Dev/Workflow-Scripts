# Architecture

## Context and Goals

Workflow-Scripts is a self-contained git repository of Markdown workflow instructions and shell helper scripts, designed to be cloned into any host project as a companion tool. It provides structured, repeatable processes for AI-assisted software development.

**Goals:**
- Standardize development workflows across projects
- Provide consistent priority and severity scoring (P0-P3, S0-S3)
- Support parallel AI agent execution patterns
- Work with any project stack (language/framework agnostic)

## System Overview

```
┌─────────────────────────────────────────────────────┐
│  Host Project (e.g., a web app)                     │
│                                                     │
│  ┌───────────────────────────────────────────┐      │
│  │  Workflow-Scripts/ (nested git repo)      │      │
│  │                                           │      │
│  │  00-orchestrator/   ── Non-interactive    │      │
│  │  00-project-setup/  ── Project init       │      │
│  │  00-meta/           ── Rubrics/templates  │      │
│  │  01-planning/       ── Research & plans   │      │
│  │  02-build-code/     ── Implementation     │      │
│  │  03-debug/          ── Bug fixing         │      │
│  │  04-documentation/  ── Doc sync           │      │
│  │  05-review-audit/   ── Code review        │      │
│  │  06-security/       ── Security review    │      │
│  │  07-deployment/     ── Deployment guides  │      │
│  │  08-API-Integration/── API guides         │      │
│  │  10-User-Manual/    ── This documentation│      │
│  │                                           │      │
│  │  Helper Scripts:                          │      │
│  │    pull-workflows.sh                      │      │
│  │    sync-workflow-scripts.sh               │      │
│  │    update-workflows.sh                    │      │
│  └───────────────────────────────────────────┘      │
│                                                     │
│  Host project files (ignored by Workflow-Scripts)   │
│  plans/  docs/  src/  ...                           │
└─────────────────────────────────────────────────────┘
```

## Components and Boundaries

### Workflow Documents (Markdown)

Each workflow is a self-contained Markdown file with:
- **Purpose** — What the workflow does
- **When to Use** — Decision criteria
- **How to Use** — Step-by-step instructions
- **Output** — What files are produced/modified

Workflows reference each other through explicit links. They are designed to be consumed by AI agents that interpret and execute the instructions.

### Helper Scripts (Bash)

Three shell scripts handle repository management:

| Script | Purpose | Audience |
|--------|---------|----------|
| `pull-workflows.sh` | Pull latest updates into a single project | End users |
| `sync-workflow-scripts.sh` | Sync updates across multiple projects | Multi-project users |
| `update-workflows.sh` | Commit and push workflow changes | Maintainers |

### Meta Documents

The `00-meta/` directory contains supporting documents (not workflows):
- `severity-priority-rubric.md` — Shared S0-S3 / P0-P3 scoring rubric
- `sync-summary-template.md` — Template for sync summaries
- Analysis documents about the workflows themselves

### Orchestrator

The `00-orchestrator/` directory provides:
- `orchestrator-plan-review.md` — Workflow for non-interactive plan reviews
- `orchestrator-review.sh` — Shell script to launch OpenCode with a different model

## Key Workflows

### Development Lifecycle

```
Research → Plan → Review → Implement → Review → Document
   │         │        │          │          │         │
   ▼         ▼        ▼          ▼          ▼         ▼
 00-      02-     01-plan-   01-execution  01-code-  02-sync-
research  finalise  review                  review    documentation
```

### Bug Fix Lifecycle

```
Bug Report → Investigate → Fix → Review → Document
    │            │           │       │         │
    ▼            ▼           ▼       ▼         ▼
 01-bug-     02-bug-fix-  (same)  01-code-  02-sync-
 description  workflow              review    documentation
```

### Security Lifecycle

```
Security Review → Fix Critical → Code Review → Document
      │                │              │            │
      ▼                ▼              ▼            ▼
 01-security-    02-security-    01-code-     02-sync-
 review           fix             review       documentation
```

## External Dependencies

- **Git** — Required for all repository operations
- **Bash** — Required for helper scripts (macOS/Linux)
- **AI Agent** — Workflows are designed to be executed by AI agents (e.g., Claude, GPT, Cursor)
- **OpenCode** (optional) — Required only for orchestrator workflows

## Deployment Topology (High-Level)

Workflow-Scripts is deployed by cloning into a host project. It is not installed globally or as a package. Each project gets its own clone, updated independently via `git pull` or the sync script.

```
Developer Machine
├── Project-A/
│   └── Workflow-Scripts/  ← clone from GitHub
├── Project-B/
│   └── Workflow-Scripts/  ← clone from GitHub
└── Project-C/
    └── workflows/         ← clone with custom name
```

## Notes / Open Questions

- The workspace root (`HyperPastaDev-Workflow-Shell`) has no `.git` at the project level — only `Workflow-Scripts/` is a git repo.
- Workflow files are Markdown, not executable scripts — they are interpreted by AI agents.
- The `10-User-Manual/` directory (this documentation) is generated and maintained separately from the workflow instructions.
