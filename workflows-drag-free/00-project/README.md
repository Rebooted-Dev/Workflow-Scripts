# workflows-drag-free Project Meta (`00-project`)

This directory is the **project meta workspace** for **workflows-drag-free** (Drag-Free workflow tree) under `Workflow-Scripts/workflows-drag-free/`. It tracks operational records (changelog, plans, troubleshooting, docs) for this tree — separate from the live Workflow-Scripts meta at `Workflow-Scripts/00-project/`.

## Layout

```text
00-project/
├── AGENTS.md              # Slim agent guidelines for this meta workspace
├── CLAUDE.md              # Slim Claude/Cursor guidelines
├── GEMINI.md              # Slim Gemini guidelines
├── README.md              # This file
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

Meta directories sit at the `00-project/` root (**flattened layout**, not nested under an extra `project/` wrapper). Paths in indexes and agent files are relative to `00-project/` unless noted.

## Sibling tree

| Path | Role |
|------|------|
| `../00-setup/` | Setup workflows (01–08) used to create this meta |
| `../00-core/` | Core partials and standards |
| `../01-planning/` … `../12-seo-geo/` | Domain workflows |
| `../ROUTER.md`, `../catalog.json` | Routing and catalog |
| `../tools/` | CLI / tooling for this tree |

## Documentation

- Agent conventions: **[`docs/agents/changelog-and-troubleshooting.md`](./docs/agents/changelog-and-troubleshooting.md)**
- Repository map: **[`docs/agents/repository-map.md`](./docs/agents/repository-map.md)**

## Git operations

This folder is **not** its own git repository. It is tracked inside **Workflow-Scripts**. Run git commands from:

```bash
cd /Users/jesse/Development/Personal/Update-AI-Tools/Workflow-Scripts
```

## Setup

Initial structure created per [`../00-setup/01-setup-project.md`](../00-setup/01-setup-project.md) (flattened `00-project/` meta variant).
