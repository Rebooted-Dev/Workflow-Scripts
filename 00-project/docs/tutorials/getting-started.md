# Getting Started with Workflow-Scripts

## Prerequisites

- Git
- A host project where you want structured AI-assisted workflows
- (Optional) OpenCode CLI for orchestrator reviews
- (Optional) Node.js for validation scripts and image-generation package tests

## Step 1: Clone into your host project

```bash
cd /path/to/your-project
git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
```

## Step 2: Configure host `.gitignore`

Add to your host project's `.gitignore`:

```
Workflow-Scripts/
```

## Step 3: Document multi-repo in host AGENTS.md

State that your project has multiple repositories and that workflow changes are committed from `Workflow-Scripts/`, not the host root.

## Step 4: Pull updates (ongoing)

```bash
./Workflow-Scripts/scripts/pull-workflows.sh
```

## Step 5: Run your first workflow

1. Open `01-Planning & Organizing/00-research-and-plan.md`
2. Provide a goal (e.g. "Add user authentication")
3. Follow the workflow phases — output goes to your host `plans/` directory

## Step 6: Log changes (Workflow-Scripts maintainers)

When editing Workflow-Scripts itself:

1. Make your change
2. Create `00-project/changelog/<type>/<date>-<type>-<title>.md`
3. Add row to `00-project/changelog/index.md`
4. For bug fixes, also add `00-project/troubleshooting/<category>/...`

See [Agent conventions](../agents/changelog-and-troubleshooting.md).

## Next Steps

- [User Manual](../user-manual.md) — workflow selection guide
- [File Map](../architecture/file-map.md) — directory navigation
- [Skills setup](../../../00-project-setup/06-skills-setup.md) — install Codex skills