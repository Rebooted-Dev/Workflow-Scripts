# Agent Skills Stack (curated)

**Normal entry:** [../01-setup-project.md](../01-setup-project.md) — new project setup **or** “Updating an existing project…”. That workflow’s **Step 2.12** invokes this folder. Do not treat this README as a second front door for day-to-day setup.

This tree is the **detail playbook** for the curated engineering + design agent-skills stack (install commands, scan probes, stubs, clash rules). It ships with Workflow-Scripts; no host-repo plan file is required.

**Start state for Phase 1:** assume a **fresh machine** unless verification already passes.

## When to open this folder directly

- Machine-only reinstall / re-verify of global packs (Phase 1)
- Deep dive on precedence / stubs while executing Step 2.12 from `01-setup-project.md`

## Phases (detail for Step 2.12)

| Phase | Doc | Scope |
|-------|-----|--------|
| 0 Sync Workflow-Scripts | [../03-sync-workflow-scripts.md](../03-sync-workflow-scripts.md) or `git pull` in this repo | Once per machine / when pulling updates |
| 1 Global install | [01-global-install.md](./01-global-install.md) | Once per machine |
| 2 Scan this repo | [02-project-scan.md](./02-project-scan.md) | Once per **application** repo |
| 3 Fill gaps | [03-project-scaffold.md](./03-project-scaffold.md) (layout already done in 01 Steps 1–2.11) | As scan directs — Matt / Impeccable |
| 4 Verify | Checklists below + 01 Step 3.7.1 | After Phase 1 and after Phase 3 |

**Skip Phases 2–3** when the current working directory **is** the Workflow-Scripts repository itself.

Also see:

- [precedence.md](./precedence.md) — clash rules and Pocock ↔ pstack phase handoff
- [../06-skills-setup.md](../06-skills-setup.md) — discovery catalog / Top-N (not the curated stack)

## Agent procedure (when invoked from Step 2.12)

1. Run Phase 1 if `npx skills list -g` lacks the curated packs ([01-global-install.md](./01-global-install.md)).
2. In the **application** project root, run Phase 2 ([02-project-scan.md](./02-project-scan.md)): probe files **readonly first**.
3. Run only the Phase 3 actions the scan requires for **Matt / Impeccable / PRODUCT** (layout should already exist from 01). Prefer chat skills over hand-copying. Never wipe changelog/troubleshooting indexes or invent product truth.
4. Verify (below), then return to 01 Step 3.

## Verification

### After Phase 1 (machine)

- [ ] `npx skills list -g` shows Impeccable, official `shadcn`, `find-skills`, React Doctor, Matt Pocock skills (or equivalent paths under `~/.agents/skills` / agent skill dirs)
- [ ] Cursor marketplace shadcn is **disabled**; official shadcn skill is present
- [ ] Clash packs absent (Emil, Jakub, ui-ux-pro-max, Superpowers as default methodology)
- [ ] pstack Cursor plugin present; `~/.cursor/rules/pstack-models.mdc` exists (or `/setup-pstack` run)
- [ ] New Agent session started after plugin enable/disable changes

### After Phase 3 (application repo)

- [ ] If using Matt Pocock engineering chain: `docs/agents/issue-tracker.md`, `triage-labels.md`, `domain.md`, and `## Agent skills` in `CLAUDE.md`
- [ ] If the project has (or will have) UI/design work: `PRODUCT.md` from `/impeccable init` (interview-driven; do not fabricate)
- [ ] Changelog / troubleshooting indexes unchanged except intentional new rows
- [ ] Layout/harness already verified via 01 Step 3 (PROJECT.md, AGENTS.md, thin CLAUDE/GEMINI)

## Related

- Front door (layout + Step 2.12): [../01-setup-project.md](../01-setup-project.md)
- Repo map in `PROJECT.md`: [../04-track-repos-and-agent-map.md](../04-track-repos-and-agent-map.md)
- Stubs (fallback only): [stubs/](./stubs/)
