# Plans Completed

This directory contains completed or archived plans for Workflow-Scripts meta work, organized by category.

## Directory Structure

```
plans-completed/
├── implementation/     # Feature implementation, code changes
├── investigation/      # Research, analysis, debugging
├── migration/        # Structural changes, migrations
├── review/           # Code reviews, audits
├── tooling/          # Tool setup, configuration
└── index.md          # Chronological index of all completed plans
```

## Categories

| Category | Description | Examples |
|----------|-------------|----------|
| `implementation/` | Plans that resulted in code or workflow changes | Feature additions, refactoring |
| `investigation/` | Research and analysis work | Bug investigations, workflow audits |
| `migration/` | Structural or organizational changes | Directory reorganization, migrations |
| `review/` | Review and audit work | Code reviews, documentation audits |
| `tooling/` | Tool and configuration work | CI/CD setup, agent/MCP configuration |

## File Naming Convention

Always use the `yyyy-mm-dd-` prefix for completed plans:

```
<yyyy-mm-dd>-<descriptive-name>.md
```

## Filing a Completed Plan

When filing a plan as completed:

1. **Choose the appropriate category** based on the plan's nature
2. **Move** the file from `plans/` or `build/` to `plans-completed/<category>/`
3. **Rename** with `yyyy-mm-dd-` prefix (if not already present)
4. **Update** `plans-completed/index.md` — new row at the **top**
5. **Update** `changelog/index.md` — Type=`plan` row at the top; File `../plans-completed/<category>/<filename>`

## Related Documentation

- `plans/README.md` - Active plans directory
- `plans/TODO.md` - Current tasks and filing checklist
- `docs/agents/changelog-and-troubleshooting.md` - Full conventions
- `changelog/index.md` - Changelog index (includes Type=plan entries)