# Optional Documentation Additions (Checklist)

## Purpose
This file provides a checklist of optional documentation types that can improve project onboarding and maintainability. Use this as a reference when deciding what additional documentation to create beyond the core documentation set.

## When to Use This Checklist

**Use this checklist:**
- After running [`01-create-docs.md`](./01-create-docs.md) or [`02-sync-documentation.md`](./02-sync-documentation.md)
- When evaluating what additional documentation would be valuable
- During documentation planning to identify gaps
- When onboarding new team members and identifying documentation needs

**How to use:**
1. Review the recommended add-ons section first (high leverage items)
2. Consider nice-to-haves only if they match real operational needs
3. Default to the smallest set that removes real confusion/risk
4. Only create documentation you can write truthfully from the repo

**Important:** This is a reference checklist, not a workflow. Use it to inform decisions during documentation creation workflows.

---

Use this checklist after (or during) `./01-create-docs.md` or `./02-sync-documentation.md` to recommend extra docs that often improve onboarding and maintainability.

Guardrails (avoid over-documenting):
- Default to the smallest set that removes real confusion/risk. If you are unsure, ship 1-3 items max.
- Do not create a doc just because it is on a list; only create it if you can write it truthfully from the repo.
- Prefer a single, scoped page over a new directory tree.
- If your docs layout standardizes on certain folders, it is okay to create a short README that explicitly states "Not applicable".

## Recommended Add-Ons (high leverage)

### Contributing Guidelines
- Create: `CONTRIBUTING.md` or `docs/contributing.md`
- Use when: more than one developer, external contributors, or PRs are expected
- Minimum contents:
  - local dev setup (prereqs, install, run)
  - how to propose changes (branching/PR steps)
  - tests to run before opening a PR
  - secrets policy (what never to commit)
- Template: see `./00-doc-templates.md`

### Changelog
- Create: `CHANGELOG.md` or `docs/CHANGELOG.md`
- Use when: you release versions, deploy frequently, or need an audit trail of changes
- Minimum contents:
  - "Unreleased" section
  - dated entries (keep them short and scannable)
- Template: see `./00-doc-templates.md`

### Configuration Reference
- Create: `docs/configuration/README.md` (+ optional `environment-variables.md`, `config-files.md`)
- Use when: env vars/config files/flags exist and setup errors happen
- Minimum contents:
  - where configuration comes from (env/config/flags)
  - list of env var names (never document secret values)
  - defaults and examples that match the code
- Template: see `./00-doc-templates.md`

### Security Notes
- Create: `docs/security/README.md`
- Use when: authn/authz exists, secrets exist, or the app handles user/customer data
- Minimum contents:
  - how to report vulnerabilities (even if it's "contact <team>")
  - authn/authz overview (link to API docs as needed)
  - secrets handling rules
- Template: see `./00-doc-templates.md`

### Error Reference
- Create: `docs/errors/README.md`
- Use when: the system surfaces meaningful error codes/messages, or troubleshooting repeats
- Minimum contents:
  - error taxonomy (validation/auth/upstream/internal)
  - common errors with recovery steps
  - pointers to where errors are defined/raised (file paths)
- Template: see `./00-doc-templates.md`

### Migrations / Upgrades
- Create: `docs/migrations/README.md`
- Use when: breaking changes happen, data migrations exist, or version upgrades are non-trivial
- Minimum contents:
  - supported versions
  - upgrade steps (from X to Y)
  - rollback notes
- Template: see `./00-doc-templates.md`

## Nice-To-Haves (only when the project warrants it)

Choose these when they match real operational needs:
- Performance: `docs/performance/README.md` (benchmarks, tuning, resource needs)
- Monitoring / observability: `docs/monitoring/` (metrics, dashboards, alerting, health checks)
- Backup / recovery: `docs/backup-recovery/` (backup/restore steps, retention, DR)
- Integrations: `docs/integrations/` (webhooks, third-party services, extension points)
- Support matrix: `docs/support/` (OS/browser versions, system requirements)
- Dependency rationale: `docs/dependencies/` (major deps, update policy, license notes)
- Releases: `docs/releases/` (release notes, rollout notes)
- Roadmap: `docs/roadmap.md`
- FAQ: `docs/faq.md`
- Glossary: `docs/glossary.md`
- Known issues: `docs/known-issues.md`

## Conditional (only if applicable)
- Compliance: `docs/compliance/` (GDPR/HIPAA/SOC2 notes, audit trails)
- Localization/i18n: `docs/i18n/` (locale support, translation process)
- License: `LICENSE` (may be outside documentation workflows)

## How To Recommend Without Overdoing It

If you are writing a "doc plan" for a repo, include an "Optional" section that:
- names 1-3 add-ons you recommend
- states why they are relevant to this project
- links to the exact files you will create/update
