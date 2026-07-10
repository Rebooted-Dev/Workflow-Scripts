# Workflow-Scripts Project Meta (`00-project`)

This directory is the **project meta workspace** for the **Workflow-Scripts** repository itself (changelog, plans, troubleshooting, docs, build archives).

**Active v2 workflow library:** `../workflows-drag-free/`  
**Retired (2026-07-10):** the former nested tree `Drag-Free-v2/` under this meta — frozen as `build/archive/drag-free-v2-promotion-snapshot-2026-07-10.tar.gz` (see `build/archive/2026-07-10-drag-free-v2-salvage-inventory.md`).

## Layout

```text
00-project/
├── AGENTS.md              # Slim agent guidelines for consolidation meta work
├── README.md              # This file
├── 00-project-setup/      # Initial setup workflows (01–08)
├── changelog/             # Change entries (type folders + plans archive + index)
├── docs/                  # Project documentation
│   └── agents/            # Agent-facing detailed guides
├── plans/                 # Active plans, README map, TODO
├── plans-completed/       # Filed completed plans by category
├── troubleshooting/       # Troubleshooting entries by category
├── KIV/                   # Keep in view / backlog
├── research/              # Research and discovery
└── build/                 # Build artifacts; active plans may also live here
```

**Operational records** for Workflow-Scripts system work live directly under this `00-project/`. Workflow content for the consolidated v2 package lives under `../workflows-drag-free/`. Root-level numbered directories (if present) may still be compatibility stubs into `workflows-drag-free/`.

## Documentation

Agent conventions: **[`docs/agents/changelog-and-troubleshooting.md`](./docs/agents/changelog-and-troubleshooting.md)**

Repository map: **[`docs/agents/repository-map.md`](./docs/agents/repository-map.md)**

Imported Workflow-Scripts documentation: **[`docs/README.md`](./docs/README.md)**

## Git operations

Run git commands from the **Update-AI-Tools repository root** (`/Users/jesse/Development/Personal/Update-AI-Tools`), not from `00-project/` alone. Paths in indexes and agent files are relative to `00-project/` unless noted otherwise.

## Setup

Initial structure created per [`00-project-setup/01-setup-project.md`](./00-project-setup/01-setup-project.md). Setup workflows (01–08) live under [`00-project-setup/`](./00-project-setup/). Meta directories sit at the `00-project/` root (flattened layout, not nested under an extra `project/` wrapper).

The promoted archive path `Drag-Free-v2/00-project-setup/` held redirect stubs; full workflow content is merged into `00-project/00-project-setup/` from Workflow-Scripts. The former Workflow-Scripts metadata archive under `Workflow-Scripts-consolidated/working-tree-files/00-project` has been merged into this `00-project/` root and removed.
