# Workflow: Generate Comprehensive Documentation

## Purpose
Perform a detailed review of a project's codebase and produce a cohesive documentation set (user + developer) that is accurate, non-duplicative, and clearly scoped.

## When to Use This Workflow

**Use this workflow when:**
- Starting documentation for a new project from scratch
- Creating comprehensive documentation for an undocumented codebase
- Generating a complete documentation set covering all aspects of the project
- You need to create documentation for multiple audiences (users, developers, contributors)

**Use [`02-sync-documentation.md`](./02-sync-documentation.md) instead when:**
- Documentation already exists but needs updating
- You need to fix incorrect or outdated documentation
- You want to reorganize existing documentation
- You need to add missing sections to existing docs

**This workflow is comprehensive and will:**
- Generate documentation from scratch
- Create a complete documentation structure
- Cover all major aspects of the project
- Use parallel agents for efficiency

## Inputs
- Repository root.
- Existing codebase (all source files, configuration files, tests).
- Any existing documentation (to understand what's already covered).

## Scope and Assumptions
- This workflow generates documentation for the repository root you are operating in.
- If the repo contains nested repositories (submodules, vendored repos, or sibling apps), treat them as external dependencies unless explicitly told to document them too.
- If a domain is not applicable (no API, no UI, no database, no CI/CD), document that explicitly rather than inventing content.

## Key Outputs (by Audience)
- End users: root `README.md`, quick start, common workflows, troubleshooting.
- Developers/maintainers: architecture, code organization, API/interface reference, data models, testing, deployment/ops.
- Contributors (if applicable): contribution process (`CONTRIBUTING.md` or `docs/contributing.md`), expectations, local dev setup.
- Maintainers (if applicable): changelog (`CHANGELOG.md` or `docs/CHANGELOG.md`), upgrade/migration notes.

**Completion status convention:**  
When this comprehensive documentation effort is fully finished, clearly mark the main summary or index document with a green check mark for quick visual scanning, for example:
- `**Status:** ✅ COMPLETED`
- A heading such as `## Documentation Overhaul ✅`

## Prioritization Rule
- Organize doc generation by priority, descending urgency/importance: P0, P1, P2, P3.
- Use the shared rubric: `../../00-core/meta/severity-priority-rubric.md`.

## Suggested Priority Buckets (docs)
- P0: Critical user-facing docs (README.md, setup instructions, quick start guide).
- P1: Core technical docs (architecture, API reference, data models, deployment).
- P2: Detailed technical docs (code modules, class design, file maps, testing system).
- P3: Enhanced docs (tutorials, code examples, UI/UX specifications, design language).

Optional additions (recommended when relevant):
- P0-P1: `CONTRIBUTING.md` / `docs/contributing.md` and `CHANGELOG.md` / `docs/CHANGELOG.md`.
- P1-P2: `docs/configuration/`, `docs/security/`, `docs/errors/`, `docs/migrations/`.

## Applicability Rules (avoid speculative docs)
- If the project has no UI layer, still create `docs/design/README.md` with a brief note describing the absence of UI and where UI would live if added.
- If the project has no external API (HTTP, RPC, events), create `docs/api/README.md` describing the public interfaces that do exist (library API, CLI commands, internal service interfaces) and explicitly state "No external API endpoints."
- If the project has no database, `docs/data/README.md` should describe persistence approach (in-memory, file-based, external service) or explicitly state "No persistent datastore."
- If the project has no deployment automation, `docs/deployment/README.md` should describe how it is run in practice (local only, manual runbook) or explicitly state "No deployment process." 

## Optional / Conditional Doc Types (recommend as applicable)
Use this as a checklist during discovery. Do not attempt to create everything; recommend and implement only the smallest set that reduces real confusion/risk (often 1-3 items). Create these only when they match the repo's reality; otherwise omit them (or create a short README that explicitly states "Not applicable" when the folder is part of a standardized docs layout).

Recommended add-ons (often valuable):
- Contributing guidelines: `CONTRIBUTING.md` or `docs/contributing.md`.
- Changelog: `CHANGELOG.md` or `docs/CHANGELOG.md`.
- Configuration reference: `docs/configuration/` (include environment variables, config files, defaults).
- Security docs: `docs/security/` (policies, vuln reporting, authn/authz notes, secrets handling).
- Error reference: `docs/errors/` (error taxonomy, codes/messages, recovery guidance).
- Migrations / upgrades: `docs/migrations/` (breaking changes, upgrade steps, data migrations).

Nice-to-haves (when the project warrants it):
- Performance notes: `docs/performance/` (benchmarks, tuning, resource requirements).
- Monitoring and observability: `docs/monitoring/` (metrics, dashboards, alerting, health checks).
- Backup and recovery: `docs/backup-recovery/` (backup/restore, retention, DR runbook).
- FAQ: `docs/faq.md`.
- Glossary: `docs/glossary.md`.
- Known issues: `docs/known-issues.md`.
- Integration guides: `docs/integrations/`.
- Support matrix: `docs/support/` (browsers/platforms, system requirements).
- Dependency rationale: `docs/dependencies/` (major deps, update policy, licenses).
- Roadmap: `docs/roadmap.md`.
- Release notes: `docs/releases/`.

## Document Templates (required)
Use the shared templates in `./00-doc-templates.md`.

Template rules:
- Keep headings stable; prefer adding content under existing headings over inventing new ones.
- If a section is not applicable, include it and state "Not applicable" with a brief reason.
- Prefer concrete, code-backed statements. Where useful, reference file paths.

## Steps

### Workflow Overview

```
Phase 1: Discovery          Phase 2: Core Docs (P0-P1)
┌─────────────────┐         ┌─────────────────┐
│ Scan codebase   │         │ README.md       │
│ with parallel   │────────▶│ User manual     │
│ agents          │         │ Core docs       │
└─────────────────┘         └────────┬────────┘
                                     │
Phase 3: Technical (P2-P3)           │
┌─────────────────┐                  │
│ Architecture    │◀─────────────────┘
│ API reference   │
│ Data models     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Cross-link &    │
│ Add diagrams    │
│ Verify          │
└────────┬────────┘
         │
         ▼
    [COMPLETE]
```

### Phase 1: Discovery and Analysis
1. **Scan the codebase using parallel agents.** Suggested agent roles (spawn additional agents as needed). Each agent should read code files in parallel batches (read multiple files concurrently) and produce a short, source-backed outline (include file paths for key claims):
   - Scan project structure and identify entry points (read package.json, main files, config files in parallel batches)
   - Understand application architecture and system design (read architecture files, service files in parallel batches)
   - Analyze code organization and module structure (read source directories in parallel batches)
   - Identify APIs and endpoints (read API routes, controllers, services in parallel batches)
   - Extract data models and schemas (read models, schemas, type definitions in parallel batches)
   - Review UI/UX components and design patterns (read component files, styles, design files in parallel batches)
   - Analyze testing structure and patterns (read test files in parallel batches)
   - Review deployment configuration and infrastructure (read deployment configs, Dockerfiles, CI/CD files in parallel batches)
   - [Spawn additional agents if you discover other documentation needs, such as:
     - Security documentation
     - Performance documentation
     - Troubleshooting guides
     - Migration guides
     - API documentation]
   Agents should batch read files concurrently to maximize scanning speed.

   Output from each agent (recommended format):
   - "What exists" (bullet list)
   - "Key files" (file paths)
   - "Gaps / unknowns" (what could not be confirmed)
   - "Doc sections impacted" (which docs they will help write)

2. **Inventory existing documentation:**
   - Check for existing `docs/` directory and its contents.
   - Identify what documentation already exists.
   - Tag gaps and missing documentation as P0–P3.
   - Optional checklist: also check for `CONTRIBUTING.md`, `CHANGELOG.md`, and any existing `docs/configuration/`, `docs/security/`, `docs/errors/`, `docs/migrations/`, `docs/performance/`.

3. **Create documentation structure plan:**
    - Map out required documentation files and their organization.
    - Determine which docs need to be split into multiple files for clarity.
    - Plan subdirectory structure within `docs/`.

4. **Create a parallel doc-writing assignment plan (required).**
   - Assign one writing agent per documentation area (see "Parallel Writing Map" below).
   - For each agent, list exact output file paths they own.
   - Define ownership boundaries to avoid duplicate explanations (e.g., file-map vs code-architecture vs modules).
   - Create a lightweight "source of truth" rule:
     - Architecture owns intent and diagrams.
     - File-map owns navigation and file purpose.
     - Modules/classes own interfaces, responsibilities, and relationships.
     - Deployment owns runbooks (step-by-step), not system diagrams.

### Parallel Writing Map (recommended)
Use parallel agents for writing, not just scanning.

- Agent A (P0): Root `README.md` + linkouts.
- Agent B (P0): `docs/user-manual.md` (or `docs/user-manual/` if it exceeds a reasonable length or has multiple distinct personas/workflows).
- Agent C (P1): `docs/architecture/README.md` + `docs/architecture/systems-architecture.md` + `docs/architecture/code-architecture.md`.
- Agent D (P1): `docs/architecture/file-map.md` (navigation-focused; do not restate architecture).
- Agent E (P1): `docs/api/README.md` + API/interface pages.
- Agent F (P1): `docs/data/README.md` + `docs/data/data-models.md`.
- Agent G (P1): `docs/deployment/README.md` + deployment guides.
- Agent H (P2): `docs/testing/README.md` + testing docs.
- Agent I (P2): `docs/code/README.md` + `docs/code/modules.md` + `docs/code/classes.md`.
- Agent J (P3): `docs/design/README.md` + `docs/design/ui-ux-specifications.md`.
- Agent K (P3): `docs/src-examples/`.
- Agent L (P3): `docs/tutorials/`.
- Agent M (Integration): cross-linking, dedupe pass, terminology consistency, `docs/README.md` navigation.

If you have fewer agents available, merge adjacent responsibilities (e.g., Agent C + D, or Agent K + L).

### Phase 2: Generate Core Documentation (P0) (parallel writing)
5. **Generate root `README.md` (Agent A):**
    - Project overview and purpose.
    - Quick start guide.
    - Installation and setup instructions.
    - Basic usage examples.
    - Links to detailed documentation.
    - Project structure overview.
   - Follow the Root README template in `./00-doc-templates.md`.

6. **Generate user manual (Agent B):**
    - Create `docs/user-manual.md` or `docs/user-manual/`.
    - Decision rule: use a directory when the manual contains multiple distinct workflows/personas OR would exceed a reasonable length as a single page.
    - Concise guide for end users.
    - Feature descriptions.
    - Common workflows and use cases.
    - Troubleshooting common issues.

### Phase 3: Generate Technical Documentation (P1) (parallel writing)
7. **Generate systems architecture documentation (Agent C):**
    - Create `docs/architecture/systems-architecture.md`.
    - High-level system design.
    - Component interactions.
    - Technology stack overview.
    - Infrastructure and deployment architecture (high-level only; link to `docs/deployment/README.md` for runbooks).
    - System boundaries and external dependencies.
   - Follow the Systems Architecture template in `./00-doc-templates.md`.

8. **Generate code architecture documentation (Agent C):**
    - Create `docs/architecture/code-architecture.md`.
    - Code organization principles.
    - Directory structure and conventions.
    - Design patterns used.
    - Module organization strategy.
   - Follow the Code Architecture template in `./00-doc-templates.md`.

9. **Generate file map of codebase (Agent D):**
    - Create `docs/architecture/file-map.md`.
    - Directory tree structure.
    - File purpose descriptions.
    - Navigation guide for developers.
    - Key files and their roles.
   Guardrail: keep it navigational; do not restate architecture rationale already covered in `docs/architecture/code-architecture.md`.

10. **Generate API/interface usage documentation (Agent E):**
    - Create `docs/api/README.md` (overview) and individual API docs as needed.
    - API endpoints and methods (if applicable).
    - Request/response formats.
    - Authentication and authorization.
    - Error handling.
    - Usage examples.
    - Rate limits and constraints (only if present).
   - Follow the API / Interfaces templates in `./00-doc-templates.md`.

11. **Generate data structures and data models documentation (Agent F):**
     - Create `docs/data/data-models.md` or split into multiple files if needed.
     - Database schemas (if applicable).
     - Data structures and types.
     - Entity relationships.
     - Data flow diagrams.
     - Validation rules and constraints.
    - Follow the Data templates in `./00-doc-templates.md`.

12. **Generate deployment information (Agent G):**
     - Create `docs/deployment/README.md` and related deployment guides.
     - Deployment prerequisites.
     - Step-by-step deployment instructions.
     - Environment configuration.
     - Infrastructure requirements.
     - CI/CD pipeline documentation.
     - Rollback procedures.
     - Monitoring and logging setup (only if present).
   - Follow the Deployment template in `./00-doc-templates.md`.

### Phase 4: Generate Detailed Technical Documentation (P2)
13. **Generate code modules and inter-relationship documentation (Agent I):**
     - Create `docs/code/modules.md` or split by module category.
     - Module descriptions and responsibilities.
     - Module dependencies and relationships.
     - Module interaction diagrams.
     - Import/export patterns.
     - Module boundaries and interfaces.
   Guardrail: avoid repeating file-by-file descriptions already covered in `docs/architecture/file-map.md`.

14. **Generate class design and architecture documentation (Agent I):**
     - Create `docs/code/classes.md` or split by class category.
     - Class hierarchy and inheritance.
     - Class responsibilities and methods.
     - Design patterns used in classes.
     - Class relationships (composition, aggregation, inheritance).
     - Interface definitions.
   Note: if the project is not class-based, replace this with "key abstractions" documentation (functions, hooks, services, modules).

15. **Generate testing system documentation (Agent H):**
     - Create `docs/testing/README.md` and related testing docs.
     - Testing strategy and approach.
     - Test structure and organization.
     - How to run tests.
     - Writing new tests.
     - Test coverage information.
     - Testing best practices.

### Phase 5: Generate Enhanced Documentation (P3)
16. **Generate UI/UX specifications and design language (Agent J):**
     - Create `docs/design/ui-ux-specifications.md` or split into multiple files.
     - Design principles and philosophy.
     - Component library documentation.
     - Style guide and design tokens.
     - Interaction patterns.
     - Accessibility guidelines.
     - Responsive design specifications.
     - User flow diagrams.
   Note: if no UI exists, document "current state" and "intended location/patterns" rather than fabricating a design system.

17. **Generate code examples (Agent K):**
     - Create `docs/src-examples/` directory.
     - Generate practical code examples for common use cases.
     - Examples for API usage.
     - Examples for data model usage.
     - Examples for component usage.
     - Examples for common patterns.
     - Each example should be self-contained, include minimal necessary comments, and state prerequisites (commands/env vars).

18. **Generate tutorials (Agent L):**
     - Create `docs/tutorials/` directory.
     - Step-by-step tutorials for common tasks.
     - Getting started tutorials.
     - Advanced usage tutorials.
     - Integration tutorials.
     - Best practices tutorials.
     - Each tutorial should be clear and progressive.

### Phase 6: Organization and Cross-Referencing
19. **Organize documentation into subdirectories:**
     - Ensure all documentation is properly organized.
     - Create subdirectories as needed:
       - `docs/architecture/` - Architecture documentation
       - `docs/api/` - API documentation
       - `docs/data/` - Data models and structures
       - `docs/code/` - Code documentation
       - `docs/deployment/` - Deployment guides
       - `docs/testing/` - Testing documentation
       - `docs/design/` - UI/UX and design documentation
       - `docs/src-examples/` - Code examples
       - `docs/tutorials/` - Tutorials

   Also create sub-indexes (brief READMEs) where useful:
   - `docs/architecture/README.md`, `docs/api/README.md`, `docs/data/README.md`, `docs/code/README.md`, `docs/deployment/README.md`, `docs/testing/README.md`, `docs/design/README.md`

20. **Create documentation index (Agent M):**
     - Create or update `docs/README.md` as the main navigation hub.
     - Provide clear navigation to all documentation.
     - Organize by audience (users, developers, contributors).
     - Include quick links to most common docs.

21. **Cross-reference related documentation (Agent M):**
     - Add links between related documents.
     - Ensure navigation flows logically.
     - Remove redundancy where appropriate.
     - Add "See also" sections where relevant.

22. **Add diagrams and visual aids (Agents C/D/E/F/I as applicable; Agent M validates):**
     - Create text-based diagrams where they clarify complex systems.
     - **ASCII art diagrams**: Use prompts from `./ascii-art-prompts.md` to generate ASCII art diagrams for:
       - Architecture diagrams (system overview, component relationships)
       - Flowcharts and process flows (workflows, data flows)
       - Hierarchy diagrams (file structure, class inheritance)
       - Network and integration diagrams (API relationships, microservices)
       - UI/UX flow diagrams (user journeys, state machines)
       - Documentation-specific diagrams (hub structure, learning paths)
     - Architecture diagrams.
     - Data flow diagrams.
     - Sequence diagrams for key workflows.
     - Component interaction diagrams.
     - Class diagrams.
     - **Reference**: See `./ascii-art-prompts.md` for:
       - Standardized prompt templates for different diagram types
       - Character reference for box-drawing and arrows
       - Best practices and formatting guidelines
       - Quality checklist for diagram generation

23. **Verification pass (required; Agent M):**
    - Spot-check every doc for non-speculative claims.
    - Ensure key claims cite the implementation via file paths (and optionally symbol names).
    - Run link checks manually by navigating `docs/README.md` and following links.
    - Confirm applicability rules were followed ("not applicable" sections are explicit).

## Output Requirements

### Documentation Structure
```
docs/
├── README.md                    # Main documentation index
├── user-manual.md               # Or user-manual/ directory
├── architecture/
│   ├── README.md
│   ├── systems-architecture.md
│   ├── code-architecture.md
│   └── file-map.md
├── api/
│   ├── README.md
│   └── [individual-api-docs].md
├── data/
│   ├── README.md
│   └── data-models.md
├── code/
│   ├── README.md
│   ├── modules.md
│   └── classes.md
├── deployment/
│   ├── README.md
│   └── [deployment-guides].md
├── testing/
│   ├── README.md
│   └── [testing-docs].md
├── design/
│   ├── README.md
│   └── ui-ux-specifications.md
├── src-examples/
│   └── [code-example-files]
└── tutorials/
    └── [tutorial-files]
```

Optional additions (only if applicable):
```
docs/
├── configuration/
├── security/
├── errors/
├── migrations/
├── performance/
├── monitoring/
├── backup-recovery/
├── integrations/
├── dependencies/
└── releases/
```

### Documentation Quality Standards
- All documentation should be clear, accurate, and up-to-date with the codebase.
- Use consistent formatting and style throughout.
- Include code examples where helpful.
- Add diagrams for complex concepts.
- Cross-reference related documentation.
- Split large documents into multiple files for clarity.
- Each document should have a clear purpose and audience.

### File Naming Conventions

#### Documentation Files
- Use kebab-case for file names (e.g., `user-manual.md`, `data-models.md`).
- Use descriptive names that indicate content.
- For split documents, use numbered prefixes or descriptive suffixes (e.g., `api-01-authentication.md`, `api-02-endpoints.md`).

#### Generated Reports
When workflows generate reports or analysis documents, follow the naming convention defined in [`../../00-core/meta/naming-conventions.md`](../../00-core/meta/naming-conventions.md).

**Format:** `{report-type}-YYMMDD-HHMM-{model}.md`

## Acceptance Criteria
- All P0 documentation is complete and accurate.
- All P1 documentation is complete and accurate.
- All P2 documentation is complete and accurate.
- All P3 documentation is outlined and internally consistent (tutorials/examples may be added incrementally).
- Documentation is organized into clear subdirectories.
- All documentation accurately reflects the current codebase.
- Cross-references between related docs are in place.
- Diagrams are included where they clarify complex systems.
- File maps aid navigation.
- Code examples are practical and working.
- Tutorials are clear and progressive.

## Related Workflows

- **[`02-sync-documentation.md`](./02-sync-documentation.md)** - Update existing documentation (use this instead if docs already exist)
- **[`00-doc-templates.md`](./00-doc-templates.md)** - Reference templates for consistent documentation structure
- **[`09-optional.md`](./09-optional.md)** - Checklist of optional documentation types to consider
- **[`ascii-art-prompts.md`](./ascii-art-prompts.md)** - Prompts for generating ASCII art diagrams
- **[`../02-build/01-execution.md`](../02-build/01-execution.md)** - Update documentation after code changes

## Notes
- Use parallel agents throughout to maximize efficiency.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially.
- Verify all documentation against the actual codebase before finalizing.
- Keep documentation focused and avoid speculative content.
- Split large documents into multiple files when they exceed reasonable length or cover multiple distinct topics.
- If repo conventions allow, update the main README.md in the project root to point to the comprehensive documentation in `docs/`.
- Never include secret values in docs. If secrets are required, document only the environment variable names and how to obtain them.
- Consider the audience for each document (end users, developers, contributors, maintainers).
- All code examples should be tested and verified to work with the current codebase.
- Tutorials should be tested by following them step-by-step.
