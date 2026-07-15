# System 2 TypeScript 7 + shadcn Stack Plan

**Created:** 2026-07-15  
**Status:** ACTIVE DECISION PLAN  
**Parent plan:** [System 2 Production and Assembly App Implementation Plan](2026-07-15-system-2-production-app-implementation-plan.plan.md)

## Decision

Build the System 2 browser application with React, Vite, TypeScript 7, Tailwind CSS 4, and shadcn/ui. Keep the existing Python Production 2.0 runner authoritative for project state, gates, ledgers, manifests, leases, and canonical artifact writes.

TypeScript 7 is suitable for this React/Vite application. It is now a stable native compiler with major build and editor performance improvements. It does not yet expose a stable compiler API, so tooling that imports the TypeScript API may need to run against the TypeScript 6 compatibility package alongside TypeScript 7.

## Proposed stack

### Browser application

- React with Vite
- TypeScript 7 in strict mode
- Tailwind CSS 4
- shadcn/ui components
- One shadcn primitive family: **Radix** (recorded in [design-language.md](design-language.md) §7); do not mix in Base UI without a deliberate boundary
- React Router for application views
- TanStack Query for API/server state
- React Hook Form and Zod for interactive forms
- Lucide React for icons

### Local application server

- Node 22
- Fastify
- JSON Schema and Ajv for request/response validation
- Same-origin loopback serving for the SPA and API
- Server-sent events for sanitized job progress events
- A controlled worker/subprocess layer for Python commands and media jobs

### Existing production boundary

- Python remains the canonical authority for `content/<project>/` state
- The Node server calls versioned Python JSON CLI commands
- Filesystem artifacts, `manifest.json`, `ledger.md`, leases, and transaction journals remain authoritative
- Do not introduce an application database in the first release
- FFmpeg and ffprobe remain the media inspection and assembly tools

### Provider and agent integrations

- Pin `@opencode-ai/sdk` to `1.3.15` and import only its `/v2` API
- Keep OpenCode execution behind the server-side permission, provenance, and budget boundary
- Treat Higgsfield, ElevenLabs, and Suno as paid media-provider routes
- Treat Grok as a reasoning, critique, prompt-refinement, and QC route—not as a media provider

### Quality and operations

- Vitest for unit and contract tests
- React Testing Library for component behavior
- Playwright for full browser workflows
- Type-checking and build checks in CI
- Structured logs with redacted prompts, provider payloads, credentials, and reasoning
- Local app password, signed HttpOnly/SameSite session cookie, CSRF protection, Origin/Host validation, throttling, sanitized Markdown, and allowlisted subprocess arguments

## TypeScript 7 compatibility rules

- Use `moduleResolution: "bundler"` for the Vite application.
- Set `rootDir` explicitly; TypeScript 7 no longer supports the old implicit `baseUrl` pattern.
- Prefer `package.json#imports` aliases, or configure aliases relative to the project root, rather than copying a `baseUrl`-based configuration unchanged.
- Make required global types explicit, such as `vite/client` and `node`.
- Run the TypeScript 7 compiler for application type-checking.
- If a lint or build tool requires the TypeScript compiler API, install `@typescript/typescript6` as a compatibility dependency and document which command uses which compiler.

## shadcn/ui setup rules

shadcn/ui distributes component source into the repository; it is not a complete application framework or data layer. The project must also configure:

- Tailwind CSS 4
- `components.json` if using the shadcn CLI
- Import aliases compatible with TypeScript 7
- `class-variance-authority`, `clsx`, `tailwind-merge`, `lucide-react`, and `tw-animate-css` as needed by the generated components
- A project-owned design-token layer for production stages, gate states, warnings, blocked jobs, paid confirmations, and QC status

## Design language and UI specifications

The app's visual identity is defined locally in two authoritative documents in this directory:

- [design-language.md](design-language.md) — the **SLATE** design language: cyan-biased graphite neutrals, waveform-cyan accent, SMPTE-derived semantic status hues with a dedicated `--paid` magenta for money actions, Instrument Sans + Spline Sans Mono typography, 4px grid, 2px radii, corner-bracket media framing, motion and voice rules, and the shadcn/Radix restyle defaults.
- [ui-specifications.md](ui-specifications.md) — screen-level specs for the app shell and gate spine, login, projects overview, project dashboard, active-job state, approval and paid-confirmation modals, artifact viewer, bounce filing, budget and ledger views, empty/blocked/error states, responsive breakpoints, accessibility, and the component inventory.

These documents seed `system-2-app/DESIGN.md` and the Tailwind 4 token layer when the workspace is created. The design dials below resolve as: `DESIGN_VARIANCE` restrained instrument-console structure, `MOTION_INTENSITY` low and purposeful, `VISUAL_DENSITY` dense data with generous section spacing.

## Design taste and agent skills

Use [Taste Skill](https://github.com/Leonxlnx/taste-skill) as an optional design-direction skill for Codex/OpenCode-assisted frontend work. It provides portable `SKILL.md` instructions for typography, layout, spacing, motion, visual density, and anti-generic interface decisions. It complements shadcn/ui; it does not replace the component system, design tokens, accessibility review, or browser testing.

### Recommended use

- Install the default skill when beginning the frontend design pass:

  ```bash
  npx skills add https://github.com/Leonxlnx/taste-skill
  ```

- Use the stricter `gpt-taste` variant for Codex/OpenCode work when the design needs stronger layout variance, motion direction, and anti-slop enforcement:

  ```bash
  npx skills add https://github.com/Leonxlnx/taste-skill --skill "gpt-taste"
  ```

- Treat the skill as agent-development tooling, not an application runtime dependency. Review the installed `SKILL.md`, keep the selected variant explicit, and record any project-specific overrides in the design brief or `DESIGN.md`.
- Tune the three design dials deliberately for this product:
  - `DESIGN_VARIANCE`: restrained dashboard structure versus more editorial/asymmetric layouts
  - `MOTION_INTENSITY`: static status UI versus purposeful transition and progress motion
  - `VISUAL_DENSITY`: spacious review surfaces versus dense production/QC dashboards
- Start with the default taste skill for the dashboard and use `gpt-taste` only if the initial output remains generic or under-directed.

### Optional taste-profile tools

- [buildwithtaste.com](https://buildwithtaste.com) can be evaluated as an optional source of a personal taste profile. Its advertised workflow extracts design language from saved UIs and syncs a `SKILL.md`/MCP profile across Codex, Cursor, and Claude Code.
- [Aura](https://aura.build) may be explored as an alternative design-agent workflow, but neither tool is required for the System 2 application to build or run.
- Do not make the app dependent on a remote taste service, remote MCP, or live profile sync. Preserve a local, reviewable design brief and token map so the UI remains reproducible if those services change or are unavailable.

### Design acceptance gate

The required concepts exist: [design-language.md](design-language.md) and [ui-specifications.md](ui-specifications.md) cover the project dashboard, active-job state, approval/paid-confirmation modal, artifact viewer, and responsive layout. Before implementation, review these documents against the stabilized API contracts and approve them as the baseline; Taste Skill may be used to critique hierarchy, typography, density, motion, and generic patterns, with accepted revisions landed back into those documents. Extract the tokens into the app's `DESIGN.md` and Tailwind theme. Verify the implemented UI with Playwright screenshots (both themes) and accessibility checks against [ui-specifications.md](ui-specifications.md) §14 and the design-language acceptance rule (§8).

## Implementation order

1. Create the `production-v2/system-2-app/` npm workspace with Node 22, React, Vite, and TypeScript 7.
2. Establish the TypeScript 7-compatible module and import-alias configuration before running the shadcn CLI.
3. Review and approve [design-language.md](design-language.md) and [ui-specifications.md](ui-specifications.md) as the design baseline (optionally critiqued via the selected Taste Skill variant); land any revisions in those documents.
4. Configure Tailwind 4, shadcn/ui, the Radix primitive family, Lucide icons, self-hosted Instrument Sans + Spline Sans Mono, and the SLATE design tokens from [design-language.md](design-language.md).
5. Add the Fastify server and versioned JSON API contract.
6. Build the read-only project dashboard and artifact viewer first.
7. Add TanStack Query, SSE job updates, dry-run actions, approval flows, bounce filing, and G6 acceptance.
8. Add OpenCode and paid-provider execution only after the API, lease, approval, budget, and provenance contracts are tested.

## Acceptance criteria

- The app type-checks and builds with TypeScript 7.
- shadcn components can be added without reintroducing unsupported TypeScript 7 `baseUrl` configuration.
- [design-language.md](design-language.md) and [ui-specifications.md](ui-specifications.md) are the recorded, reviewed local design baseline; any Taste Skill variant used is explicitly recorded and its accepted output landed back into those documents.
- Core screens pass the design acceptance gate for hierarchy, typography, density, motion, accessibility, and responsive behavior as specified in [ui-specifications.md](ui-specifications.md) and the [design-language.md](design-language.md) §8 acceptance rule.
- A G3 fixture can complete the dry-run G4–G6 workflow through the browser.
- Concurrent or interrupted requests cannot corrupt the Python-owned ledger, manifest, or artifact state.
- Paid-provider submission requires one explicit, hash-bound confirmation and produces complete provenance and settlement records.
- Browser tests cover desktop and mobile layouts, interruption/resume, stale revisions, duplicate idempotency keys, and mocked paid-provider flows.

## References

- [TypeScript 7 announcement](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/)
- [shadcn/ui introduction](https://ui.shadcn.com/docs)
- [shadcn/ui Vite installation](https://ui.shadcn.com/docs/installation/vite)
- [shadcn/ui manual installation](https://ui.shadcn.com/docs/installation/manual)
- [Taste Skill repository](https://github.com/Leonxlnx/taste-skill)
- [Taste personal profiles](https://buildwithtaste.com)
- [Aura](https://aura.build)
