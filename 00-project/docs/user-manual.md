# User Manual

## Who This Is For

- **Host project developers** using Workflow-Scripts inside a consumer repo (e.g. Update-AI-Tools)
- **Workflow-Scripts maintainers** editing workflows and publishing updates
- **AI agents** executing structured development processes

Workflow-Scripts is **not an application** — it is a library of Markdown workflow instructions, shell sync helpers, optional Codex skills, and reference guides.

## What You Can Do

| Goal | Where to start |
|------|----------------|
| Set up workflows in a new project | `00-project-setup/01-setup-project.md` |
| Research and plan new work | `01-planning-and-organizing/00-research-and-plan.md` |
| Review or finalize a plan | `01-planning-and-organizing/01-plan-review.md` |
| Implement from a plan | `02-code-build/01-execution.md` |
| Fix a bug | `03-debugging/02-bug-fix-workflow.md` |
| Update documentation | `04-documentation/02-sync-documentation.md` |
| Code/security review | `05-review/01-code-review.md` |
| Website data refactoring | `05-review/04-website-data-refactoring.md` |
| Comprehensive repo audit | `05-review/05-comprehensive-audit.md` |
| Security audit | `06-security/01-security-review.md` |
| Pull latest workflows | `scripts/pull-workflows.sh` |
| Delegate review to another model | `00-Meta-Workflow/00-orchestrator/orchestrator-review.sh` |

## Common Workflows

### 1. Clone into a host project

```bash
cd /path/to/your-project
git clone https://github.com/Rebooted-Dev/Workflow-Scripts Workflow-Scripts
```

Add `Workflow-Scripts/` to the host project's `.gitignore`. See [SHARING_AND_SYNC.md](../../SHARING_AND_SYNC.md).

### 2. Pull workflow updates

```bash
# From host project root
./Workflow-Scripts/scripts/pull-workflows.sh
```

The script refuses to pull on a dirty tree or detached HEAD.

### 3. Typical feature sequence

```
Research & Plan → Plan Review → Finalise Plan → Execution → Code Review → Sync Documentation
```

Workflow files live under numbered category directories. Each workflow defines inputs, outputs, priority ordering (P0→P3), and verification steps.

### 4. Meta work on Workflow-Scripts itself

When editing **this repository**, log changes under `00-project/changelog/` and bug fixes under `00-project/troubleshooting/`. Consumer projects use their own `project/` directory with the same layout.

| Consumer path | Workflow-Scripts meta path |
|---------------|---------------------------|
| `project/changelog/` | `00-project/changelog/` |
| `project/troubleshooting/` | `00-project/troubleshooting/` |
| `project/plans/` | `00-project/plans/` |
| `project/research/` | `00-project/research/` |
| `project/plans-completed/` | `00-project/plans-completed/` |
| `docs/` | `00-project/docs/` |

### 5. Skills vs full workflows

**Full workflows** (`01-planning-and-organizing/`, `02-code-build/`, etc.) are detailed multi-phase instructions.

**Skills** (`11-Skills/*/SKILL.md`) are thin Codex triggers that point agents at the right workflow. Install per `00-project-setup/06-skills-setup.md`.

### 6. Orchestrator (delegated review)

```bash
./00-Meta-Workflow/00-orchestrator/orchestrator-review.sh path/to/plan.md -m <model>
```

Requires OpenCode CLI. Captures review output beside the plan in `<plan-dir>/<plan-name>.reviews/<timestamp>-<focus>-review.md`.

## Troubleshooting

| Problem | Check |
|---------|-------|
| `pull-workflows.sh` refuses to pull | Uncommitted changes in Workflow-Scripts — commit, stash, or discard |
| Detached HEAD after fetch | `git checkout main` (or `v1.7`) before pulling |
| Broken workflow cross-links | Some legacy links reference `09-11 Misc/` — files moved to `08-API-Integration/` |
| Empty `PROJECTS` in sync script | Configure via `PROJECTS[]`, `--auto`, `WORKFLOW_SYNC_PROJECTS`, or `WORKFLOW_SYNC_BASE_DIR` in `scripts/sync-workflow-scripts.sh` |
| Workflow output path confusion | **Plans** → `<metadata-root>/plans/`; **review/audit/research reports** → `<metadata-root>/research/`. See [naming-conventions.md](../../00-Meta-Workflow/00-meta/naming-conventions.md) |

For resolved bugs filed in this repo, see `00-project/troubleshooting/index.md`.

## FAQ

**Which workflow do I start with?**  
New work: `00-research-and-plan.md`. Bug: `02-bug-fix-workflow.md`. Docs drift: `02-sync-documentation.md`.

**Does Workflow-Scripts have a build step?**  
No repo-wide build. The embedded `@ai-sdk/image-generation` package under `08-API-Integration/` has its own npm/vitest toolchain.

**Where do reports go?**  
Filename format: `{type}-YYMMDD-HHMM-{model}.md` per [naming-conventions.md](../../00-Meta-Workflow/00-meta/naming-conventions.md). **Implementation plans** go to `<metadata-root>/plans/`. **Review, audit, and research reports** go to `<metadata-root>/research/`. In this repo the metadata root is `00-project/`; consumer host projects use `project/`.

**How many parallel agents should I spawn?**
Review and audit workflows follow [agent-spawning-policy.md](../../00-Meta-Workflow/00-meta/agent-spawning-policy.md): 3–6 total agents per session, with a hard cap of 6.
