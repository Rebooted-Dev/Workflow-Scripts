# Research Completed

Archive for finished research and discovery artifacts for **workflows-drag-free** work, organized by category.

## Directory Structure

```
research-completed/
├── migration/        # Migration analysis, problem statements, topology decisions
├── investigation/    # Measurements, pilots, sync/status research
├── review/           # Completed implementation and deep-review reports
├── history/          # Completed historical reports and operational records
└── index.md          # Chronological index of all filed research
```

## Categories

| Category | Description | Examples |
|----------|-------------|----------|
| `migration/` | Structural or path migration research | Dual-tree comparison, problem statements, meta-path decisions |
| `investigation/` | Measurement and pilot research | Sync status pilots, fleet health snapshots |
| `review/` | Completed reviews of implementation, contracts, and behavior | Deep review, implementation-vs-plan review |
| `history/` | Historical reports and completed operational records | Deployment workflow optimization report |

## File Naming Convention

Always use the `yyyy-mm-dd-` prefix:

```
<yyyy-mm-dd>-<descriptive-name>.md
```

## Filing Completed Research

When research is finished and should be archived:

1. **Choose the appropriate category** based on the artifact's nature
2. **Move** the file from `research/` to `research-completed/<category>/`
3. **Update** `research-completed/index.md` — new row at the **top**
4. **Update** `changelog/index.md` — Type=`research` row at the top; File `../research-completed/<category>/<filename>`
5. Set frontmatter `status: complete` (or `resolved` for problem statements) before filing

## Related Documentation

- `research/README.md` — Active research directory (tracker/map)
- `plans-completed/README.md` — Completed plans archive
- `changelog/index.md` — Changelog index (includes Type=research entries)
