# Phase 1: Global install (fresh machine)

Run once per machine after Workflow-Scripts is synced. Assumes packs are **not** yet installed. Skip individual steps when verification already shows them present.

Full roles and clash rules: [precedence.md](./precedence.md). Orchestrator: [README.md](./README.md).

## Prerequisites

- Network access for `npx` / skill installers
- Cursor (for pstack plugin + marketplace shadcn disable)
- Ability to start a **new** Agent session after plugin changes

## Install-now checklist (unchecked for a fresh machine)

1. [ ] **Disable Cursor marketplace shadcn**  
   Customize / Settings → Plugins → **shadcn** → toggle off (or uninstall). Plugin id is often `6948`. Cache under `~/.cursor/plugins/cache/` may remain; that does **not** mean the plugin is enabled. Confirm it is off in Settings, then **start a new Agent session**.

2. [ ] **Confirm clash packs are not installed**  
   Do not install Emil Kowalski design skills, Jakub “make interfaces feel better”, `ui-ux-pro-max`, or `12-principles-of-animation`. Leave Superpowers unused as a default methodology.

3. [ ] **Install Impeccable globally**

```bash
npx impeccable install -y --scope=global --providers=claude,codex,cursor,pi,grok
```

   Per-harness product interview (`/impeccable init`) is a **project** step—see [03-project-scaffold.md](./03-project-scaffold.md). Approve hooks when prompted (Grok may need `/hooks-trust`).

4. [ ] **Install find-skills**

```bash
npx skills add vercel-labs/skills --skill find-skills -g -y \
  -a claude-code -a cursor -a codex -a pi
```

5. [ ] **Install React Doctor** (prefer installer; skills.sh fallback)

```bash
npx react-doctor@latest install
# prefer global + detected agents; optional agent hooks when offered
# fallback:
# npx skills add millionco/react-doctor --skill react-doctor -g -y \
#   -a claude-code -a cursor -a codex -a pi
```

   If the installer offers to write CI/hooks into the **current** repo, decline unless this is intentionally a React app that wants them.

6. [ ] **Install official shadcn skill** (after marketplace shadcn is disabled)

```bash
npx skills add shadcn-ui/ui --skill shadcn -g -y \
  -a claude-code -a cursor -a codex -a pi
```

7. [ ] **Install / confirm Matt Pocock skills** (skills.sh path only—do not also `/plugin install mattpocock-skills`)

```bash
npx skills@latest add mattpocock/skills -g
# pick skills + setup-matt-pocock-skills
```

8. [ ] **Install / confirm pstack**  
   Cursor: `/add-plugin pstack` (official Cursor plugins tree). Do **not** stack `backnotprop/pstack` on top.  
   Then run once:

```text
/setup-pstack
```

   Confirm `~/.cursor/rules/pstack-models.mdc` exists. Re-run only when model routing goes stale.

9. [ ] **Verify**

```bash
npx skills list -g
```

   Expect: Impeccable, official shadcn, find-skills, React Doctor, Matt Pocock skills present; clashers absent. Reload CLIs / open a new Agent session.

## Optional already-present packs

These are **keep** when already installed; not required to chase on every fresh machine in this pass:

- Anthropic `frontend-design` (Impeccable wins on conflict)
- Vercel `web-design-guidelines` / `react-best-practices` ([vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills))

## After Phase 1

Open each **application** project and run [02-project-scan.md](./02-project-scan.md). Do not skip straight to scaffolding without scanning.
