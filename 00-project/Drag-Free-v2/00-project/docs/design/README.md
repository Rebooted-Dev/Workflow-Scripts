# Design

## Current State

Workflow-Scripts has **no user interface layer**. It is a Markdown-and-shell instruction library consumed by AI agents and developers through:

- IDE / agent chat (workflow execution)
- Terminal (shell scripts)
- Git (sync and version control)

## Intended Location / Patterns

If a UI were added (e.g. workflow picker, plan dashboard), it would likely live in a **consumer host project**, not in Workflow-Scripts itself. Workflow-Scripts would remain the source of workflow definitions.

Consumer UI patterns referenced in bundled guides:

| Pattern | Reference |
|---------|-----------|
| Electron desktop apps | `07-deployment/01a-MACOS_ELECTRON_GUIDE.md` |
| Electron + Vite | `07-deployment/01b-electron-vite.md` |
| Web deployment | `08-API-Integration/10-firebase-setup.md` |

## Visual Assets

| Asset | Path | Use |
|-------|------|-----|
| Hero banner | `media/dragfree-hero-banner.png` | Root README.md |

## Accessibility

Not applicable — no interactive UI in this repository.