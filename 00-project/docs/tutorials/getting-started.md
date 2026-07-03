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

1. Open `01-planning-and-organizing/00-research-and-plan.md`
2. Provide a goal (e.g. "Add user authentication")
3. Follow the workflow phases — **implementation plans** go to your host `project/plans/` directory; **review/audit reports** go to `project/research/`

See [naming-conventions.md](../../../00-Meta-Workflow/00-meta/naming-conventions.md) for metadata-root resolution.

## Step 6: Log changes (Workflow-Scripts maintainers)

When editing Workflow-Scripts itself:

1. Make your change
2. Create `00-project/changelog/<type>/<date>-<type>-<title>.md`
3. Add row to `00-project/changelog/index.md`
4. For bug fixes, also add `00-project/troubleshooting/<category>/...`
5. Run validation before push — see [Testing](../testing/README.md)

See [Agent conventions](../agents/changelog-and-troubleshooting.md).

## Step 7: Multi-project sync (optional, maintainers)

If you maintain multiple host projects:

```bash
./scripts/sync-workflow-scripts.sh --status
./scripts/sync-workflow-scripts.sh --auto
```

Configure via `00-project-setup/03-sync-workflow-scripts.md`.

## Next Steps

- [User Manual](../user-manual.md) — workflow selection guide
- [File Map](../architecture/file-map.md) — directory navigation
- [Skills setup](../../../00-project-setup/06-skills-setup.md) — install Codex skills
- [Migrate existing project](../../../00-project-setup/07-migrate-project-structure.md) — adopt `project/` layout in brownfield hosts