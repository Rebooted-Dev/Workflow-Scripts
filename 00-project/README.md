# Workflow-Scripts Project Meta (`00-project`)

This directory is the **project meta workspace** for the [Workflow-Scripts](https://github.com/Rebooted-Dev/Workflow-Scripts) repository. It is exclusive to this repo — not shared with consumer projects that clone Workflow-Scripts into their own trees.

## Layout

```text
00-project/
├── AGENTS.md              # Slim agent guidelines for Workflow-Scripts meta work
├── README.md              # This file
├── changelog/             # Change entries (type folders + plans archive + index)
├── docs/                  # Project documentation (agents/ for agent-facing guides)
├── plans/                 # Active plans, README map, TODO
├── plans-completed/       # Filed completed plans by category
├── troubleshooting/       # Troubleshooting entries by category
├── KIV/                   # Keep in view / backlog
├── research/              # Research and discovery
└── build/                 # Build artifacts; active plans may also live here
```

Workflow instruction files live in the parent repo (`00-project-setup/`, `01-Planning & Organizing/`, etc.). **Operational records** for Workflow-Scripts itself (changelog, plans, troubleshooting, docs) live directly under `00-project/`.

## Git operations

Run git commands from the **Workflow-Scripts repository root** (`Workflow-Scripts/`), not from `00-project/` alone. Paths in indexes and agent files are relative to `00-project/` unless noted otherwise.

## Setup

Initial structure created per [`00-project-setup/01-setup-project.md`](../00-project-setup/01-setup-project.md). Meta directories sit at the `00-project/` root (not nested under an extra `project/` wrapper).