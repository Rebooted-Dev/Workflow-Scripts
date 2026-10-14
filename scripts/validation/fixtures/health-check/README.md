# Health-check fixture matrix

`health-check-selftest.sh` materializes each named case from `healthy/` in a temporary directory, applies only that case's documented mutation, and initializes disposable Git repositories there. It never runs repairs against these source fixtures.

| Case | Mutation / expected finding |
|---|---|
| `healthy` | Baseline: selected checks pass; H12 is not run |
| `no-project` | Remove `PROJECT.md`; H01/H02 fail |
| `no-agents` | Remove `AGENTS.md`; H04 fails |
| `bad-workflow-repo` | Replace the repo path with a non-Git directory; H02 fails |
| `symlink-workflow-parent` | Resolve the configured repo through an ignored parent symlink; H02/H03 pass |
| `bad-gitignore` | Remove the workflow ignore rule; H03 fails |
| `import-claude` | Keep `CLAUDE.md` as an import-only regular file; H05 is repairable |
| `custom-claude` | Put custom Claude instructions in a regular `CLAUDE.md`; H05 is not repairable |
| `no-project-import` | Remove `@PROJECT.md`; H06 warns and offers its anchored repair |
| `no-rules-dir` | Put a recognized Claude-only heading in regular `CLAUDE.md` without the rules file; H07 warns |
| `long-agents` | Extend `AGENTS.md` past 40 lines; H08 warns |
| `no-learnings` | Remove `project/learnings/`; H09 fails and H11 warns |
| `no-project-metadata` | Remove `project/`; H09 fails, and an accepted repair creates the backup hierarchy and first learnings directory |
| `missing-logs` | Remove required changelog/troubleshooting structure; H10 warns |
| `invalid-learnings` | Remove the learning entry's Source field; H11 warns |
| `skills-incomplete` | Add the Agent skills heading and remove one required doc; H13 warns |
| `legacy-agent-learnings` | Add root `AGENT_LEARNINGS.md`; H14 warns |
| `not-a-project` | Omit both root agent files; exit `2` |
| `workflow-root` | Add Workflow-Scripts scope markers; exit `2` |
