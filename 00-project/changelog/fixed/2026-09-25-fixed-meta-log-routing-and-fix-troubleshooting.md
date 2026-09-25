# Log Workflow-Scripts changes in 00-project and require troubleshooting for every fix
**Date:** 2026-09-25
**Type:** fixed

---

## Summary
- **Owning-repo routing:** metadata-root resolution now picks the repository that owns the changed files. Workflow-Scripts changes are always logged in `00-project/`, including from host-project sessions.
- **New root agent files:** `AGENTS.md` and `CLAUDE.md` (imports it) carry this rule to any agent editing the repo.
- **PROJECT.md template** and the Flash-UI `PROJECT.md` state the rule on the host side.
- **Every fix needs troubleshooting:** a `fixed/` entry needs a troubleshooting entry. The waiver is limited to typo or formatting fixes, and must be written into the entry as `**Troubleshooting:** not needed — <reason>`.
- **Fix workflows tightened:** `03-debugging/02-bug-fix-workflow.md`, `06-security/02-security-fix.md`, and the `workflow-bug-fix-plan-and-logs` skill dropped their "project code only" and "non-trivial" escape hatches. They now use `<metadata-root>` for the owning repo and have a blocking log gate before reporting done.
- **Enforcement:** `check-meta-logs.sh` runs as a pre-commit hook (`git config core.hooksPath scripts/hooks`) and in CI, with a 9-case self-test.

## Scope
- New: `AGENTS.md`, `CLAUDE.md`, `scripts/hooks/pre-commit`, `scripts/validation/check-meta-logs.sh`, `scripts/validation/check-meta-logs-selftest.sh`
- Changed: `00-Meta-Workflow/00-meta/naming-conventions.md`, `00-project-setup/01-setup-project.md`, `02-code-build/01-execution.md`, `03-debugging/02-bug-fix-workflow.md`, `06-security/02-security-fix.md`, `11-Skills/workflow-bug-fix-plan-and-logs/SKILL.md`, `.github/workflows/validation.yml`, `scripts/README.md`
- Meta: `00-project/AGENTS.md`, `00-project/docs/agents/changelog-and-troubleshooting.md`, `00-project/docs/testing/README.md`

## Verification
- `check-meta-logs-selftest.sh` OK; `check-meta-logs.sh --range HEAD~12..HEAD` OK; `check-completion-chain-policy.sh` OK; workflow YAML parses.

## Related
- Troubleshooting: [../../troubleshooting/workflow/2026-09-25-workflow-fixes-missing-troubleshooting-entries.md](../../troubleshooting/workflow/2026-09-25-workflow-fixes-missing-troubleshooting-entries.md)
- Host entry: Flash-UI-Idea-Generator `project/changelog/docs/2026-09-25-docs-workflow-scripts-log-routing.md`
