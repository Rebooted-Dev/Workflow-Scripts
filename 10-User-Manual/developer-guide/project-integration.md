# Project Integration

## Overview

Workflow-Scripts is designed as a **companion repository** cloned into any host project. This guide covers integration patterns, the multi-repo model, and workspace setup for the HyperPastaDev-Workflow-Shell project specifically.

## Multi-Repo Model

The host project uses a multi-repo setup:

```
HyperPastaDev-Workflow-Shell/         # Workspace root (no .git at this level)
├── .gitignore                         # Must list Workflow-Scripts/
├── README.md                          # Bootstrap instructions
├── AGENTS.md                          # Primary agent guidelines
├── CLAUDE.md                          # Claude-specific guidance
├── GEMINI.md                          # Gemini-specific guidance
├── Workflow-Scripts/                  # Separate git repo (cloned from GitHub)
│   ├── .git/                          # Own git history
│   ├── README.md
│   └── ...
└── project/                           # Project-specific state
    ├── docs/agents/                   # Detailed agent documentation
    ├── changelog/                     # Changelog entries (one file per change)
    ├── troubleshooting/               # Troubleshooting entries
    ├── plans/                         # Active implementation plans
    └── plans-completed/               # Archived plans
```

### Key Property

`Workflow-Scripts/` is **its own git repository**, not tracked by the workspace. The workspace `.gitignore` must contain:

```gitignore
Workflow-Scripts/
```

## Integration Steps

### Fresh Project Setup

1. **Clone the host project:**
   ```bash
   git clone https://github.com/Rebooted-Dev/HyperPastaDev-Shell-Project.git
   cd HyperPastaDev-Shell-Project
   ```

2. **Clone Workflow-Scripts:**
   ```bash
   git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
   ```

3. **Verify .gitignore:**
   ```bash
   grep "Workflow-Scripts/" .gitignore
   ```

4. **Run the setup workflow:**
   Open `Workflow-Scripts/00-project-setup/01-setup-project.md` and follow all steps.

### Adding to an Existing Project

1. **Navigate to your project root:**
   ```bash
   cd /path/to/your-project
   ```

2. **Clone Workflow-Scripts:**
   ```bash
   git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
   ```

3. **Add to .gitignore:**
   ```bash
   echo "Workflow-Scripts/" >> .gitignore
   ```

4. **Optionally create project structure:**
   ```bash
   mkdir -p project/docs/agents project/changelog project/troubleshooting project/plans project/plans-completed
   ```

## Agent File Architecture

The workspace uses a layered agent guidance system:

### Root Level (Slim)

| File | Role |
|------|------|
| `AGENTS.md` | Primary guidelines — execution principles, multi-repo management, change management, links to detailed docs |
| `CLAUDE.md` | Claude/Cursor-specific guidance — points to AGENTS.md |
| `GEMINI.md` | Gemini-specific guidance — points to AGENTS.md |

All root agent files are **slim** — they reference `project/docs/agents/` for details.

### Detailed Level (`project/docs/agents/`)

| File | Content |
|------|---------|
| `repository-map.md` | Table of tracked repos with paths, remotes, sync commands |
| `changelog-and-troubleshooting.md` | File naming conventions, index update rules, "update the logs" behavior |
| `project-structure.md` | Workspace layout overview |
| `development-workflow.md` | Work in correct repo, validate, keep docs current |
| `coding-standards.md` | Clear naming, small changes, consistent style |
| `testing-strategy.md` | Tests for behavior changes, regression tests for bugs |
| `commit-workflow.md` | Per-repo commits, imperative messages, separate concerns |
| `documentation-workflow.md` | Slim root guidance, update indexes, repo map |
| `security-guidelines.md` | No hardcoded secrets, env vars, review deps |

## Changelog System

Changelog entries are stored as individual files in `project/changelog/`:

```
project/changelog/
├── README.md              # System overview
├── index.md               # Chronological index (newest first)
├── added/                 # New features
├── changed/               # Changes
├── fixed/                 # Bug fixes
├── improved/              # Improvements
├── docs/                  # Documentation changes
├── refactor/              # Refactoring
└── config/                # Configuration changes
```

**File naming:** `<yyyy-mm-dd>-<type>-<short-title>.md`

**Entry template:**
```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>
**Type:** <added|changed|fixed|improved|docs|refactor|config>

## Summary
- Brief description of the change.
```

## Troubleshooting System

Troubleshooting entries are stored in `project/troubleshooting/`:

```
project/troubleshooting/
├── README.md              # System overview
├── index.md               # Chronological index (newest first)
├── build/                 # Build and test issues
├── runtime/               # Runtime behavior issues
├── data/                  # Data and persistence issues
├── environment/           # Setup/configuration issues
└── security/              # Security issues and patches
```

**File naming:** `<yyyy-mm-dd>-<category>-<short-title>.md`

## Plan Management

Active plans live in `project/plans/`. Completed plans are archived to `project/plans-completed/` with a `yyyy-mm-dd-` prefix.

## Keeping Workflows Updated

### Single Project
```bash
./Workflow-Scripts/pull-workflows.sh
```

### Multiple Projects
```bash
# Configure PROJECTS array in sync-workflow-scripts.sh, then:
./Workflow-Scripts/sync-workflow-scripts.sh --auto
```

### As a Maintainer
```bash
cd Workflow-Scripts
git add .
./update-workflows.sh "docs: your change description"
```

## Repository Map

| Repository | Directory | Remote | Purpose |
|------------|-----------|--------|---------|
| Workspace root | `.` | (no git at root) | Wrapper workspace |
| Workflow-Scripts | `Workflow-Scripts/` | `https://github.com/Rebooted-Dev/Workflow-Scripts` | Shared workflow instructions |

## See Also

- [Architecture](architecture.md) — System design and components
- [File Map](file-map.md) — Directory and file navigation
- [User Manual](../user-manual/README.md) — End-user quick start
- [SHARING_AND_SYNC](../../SHARING_AND_SYNC.md) — Multi-project sharing guide
