# Tech Stack and Dependency Report Generation Instructions

## Purpose

Provide a reusable, documentation-only workflow an agent can follow inside any project to:

1. create a root `tech-stack.md` that describes the effective technology stack and package dependencies; and
2. create a package dependency update report that identifies current, wanted/in-range, latest, outdated, incompatible, and risky dependencies with a staged upgrade plan.

## Scope

- Inspect project files, manifests, lockfiles, configuration, scripts, and source usage.
- Use safe read-only commands where possible.
- Record verified evidence, assumptions, risks, and follow-up questions.
- Produce documentation and research reports only.

## Non-goals

- Do not install packages.
- Do not modify source code, dependency manifests, lockfiles, environment files, build outputs, or generated files unless separately authorized.
- Do not run live API/provider calls, live sends, deployments, migrations, or destructive commands.
- Do not blindly recommend latest major versions without compatibility research.

## Inputs

- Project root path.
- Existing manifests, lockfiles, package-manager files, runtime/tooling config, deployment config, and source code.
- Existing project docs, plans, changelog, troubleshooting notes, and guardrails when present.
- Optional user-provided constraints: runtime target, deployment target, preferred package manager, upgrade window, risk tolerance.

## Outputs

1. Root `tech-stack.md`.
2. Dependency update report at `Project/Research/YYYY-MM-DD-package-dependency-update-report.md` by default.
   - If the project uses a different local documentation convention, choose the nearest project-local research location, such as `project/Research/`, `docs/research/`, `research/`, or `Project/Plans/Research/`.
   - State the chosen path in the report.
3. Optional verification evidence file/path if the project convention requires one. Otherwise include evidence directly in the reports.

## Assumptions

- The agent has read-only access to the project workspace.
- Package metadata and release notes may require web access. If unavailable, record the limitation and separate local findings from unverified recommendations.
- Lockfiles are the best local evidence for resolved dependency versions.
- Declared manifest ranges and lock-resolved versions can differ; report both.

## Discovery Procedure

### 1. Establish project boundaries

- Identify repository root and nested repositories.
- Identify ignored external workflow/tool directories that should not be included as app dependencies.
- Record monorepo/package workspace layout if present.
- Note package manager indicators:
  - `package-lock.json`, `npm-shrinkwrap.json`
  - `yarn.lock`, `.yarnrc.yml`
  - `pnpm-lock.yaml`, `pnpm-workspace.yaml`
  - `bun.lock`, `bun.lockb`
  - language-specific files such as `requirements*.txt`, `pyproject.toml`, `poetry.lock`, `Pipfile.lock`, `Gemfile.lock`, `go.mod`, `go.sum`, `Cargo.toml`, `Cargo.lock`, `composer.lock`, `mix.exs`, `gradle.lockfile`, `pom.xml`.

### 2. Inspect manifests, lockfiles, and configs

Review all relevant files, including when present:

- Dependency manifests and lockfiles.
- Runtime version files: `.nvmrc`, `.node-version`, `.tool-versions`, `mise.toml`, `.python-version`, `.ruby-version`, `go.mod`, `rust-toolchain*`.
- Package-manager config: `.npmrc`, `.yarnrc*`, `.pnpmfile.cjs`, `packageManager` field.
- Build and runtime config: `tsconfig*.json`, `vite.config.*`, `next.config.*`, `webpack.config.*`, `rollup.config.*`, `babel.config.*`, `eslint.config.*`, `.eslintrc*`, `prettier.config.*`, `jest.config.*`, `vitest.config.*`, `playwright.config.*`, `cypress.config.*`, `tailwind.config.*`, `postcss.config.*`.
- Container/deploy config: `Dockerfile*`, `docker-compose*.yml`, `Procfile`, `vercel.json`, `netlify.toml`, `render.yaml`, GitHub Actions, other CI/CD files.
- Database/persistence config: migrations, ORM config, schema files, local data directories, cache/session stores.
- Environment examples: `.env.example`, sample config files, secret names only. Do not read or expose real secret values.

### 3. Inspect actual dependency usage

- Search imports/requires/usages for declared dependencies.
- Identify runtime dependencies used only in scripts, tests, tooling, or docs.
- Identify undeclared imports, unused declared dependencies, and transitive packages that are operationally important.
- Distinguish direct dependencies from transitive lockfile-only dependencies.

### 4. Capture runtime, tooling, and scripts

Prefer read-only commands. Examples:

```bash
node -v
npm -v
yarn -v
pnpm -v
bun -v
python --version
python3 --version
ruby -v
go version
rustc --version
cargo --version
```

Run only commands that are available and relevant. Record failures as evidence, not as blockers unless required by the project.

Inspect script definitions without executing scripts unless separately authorized:

```bash
npm pkg get scripts
npm pkg get engines
npm pkg get packageManager
```

Equivalent package-manager read-only inspection is acceptable.

### 5. Capture dependency status safely

Use package-manager status commands that do not install or modify files:

```bash
npm outdated --json
npm audit --json
npm ls --depth=0 --json
npm view <package> version engines peerDependencies dist-tags --json
```

Equivalent examples:

```bash
yarn outdated --json
pnpm outdated --format json
pnpm audit --json
bun outdated
```

Notes:

- `npm outdated` may exit non-zero when outdated packages exist; capture output and treat it as data.
- `npm audit` may contact the registry and can be noisy; use only when appropriate for the ecosystem and allowed by the environment.
- Do not run commands that update lockfiles, install packages, execute postinstall scripts, or alter dependency state.

### 6. Identify external services and safety boundaries

- Record integrations from code/config: APIs, messaging providers, databases, auth providers, analytics, storage, queues, email/SMS/WhatsApp, AI providers, payment providers.
- Record required secret names from examples/config only.
- Do not call live providers or send live messages.
- Include no-live-contact constraints for messaging, email, SMS, payment, and production systems.

## Required `tech-stack.md` Contents

Create `tech-stack.md` at the project root with these sections:

1. `# Tech Stack`
2. `Generated` date and agent/source note.
3. `Project Summary`
   - App purpose inferred from docs/source.
   - Repository layout and workspace/monorepo status.
4. `Runtime and Package Manager`
   - Runtime versions from version files and local command output.
   - Package manager and version evidence.
   - `engines` and `packageManager` constraints.
5. `Frameworks and Application Architecture`
   - Frameworks/libraries in use.
   - Entry points, scripts, build/test/lint/typecheck tooling.
6. `Dependencies`
   - Table with: package, declared version/range, lock-resolved version, direct/transitive, prod/dev/optional/peer, role, evidence file paths, usage notes.
7. `Runtime Compatibility`
   - Node/Python/Ruby/Go/Rust/etc compatibility constraints.
   - Peer dependency constraints and known mismatches.
8. `Scripts and Tooling`
   - Package scripts and what they appear to do.
   - CI/deploy commands if configured.
9. `Integrations and External Services`
   - Service/provider, purpose, config files, required secret names, no-live-call caveats.
10. `Persistence, UI, and Database Status`
    - Database/ORM/migrations status.
    - File/local storage/cache/session status.
    - UI/frontend framework status or `No UI detected`.
11. `Security and Secrets Caveats`
    - Secret boundaries, files intentionally not read, values not recorded.
    - Audit/security command results if run.
12. `Evidence`
    - File paths and commands used.
    - Separate verified facts from inferred findings.
13. `Open Questions`
    - Unknowns and recommended follow-up.

## Required Dependency Update Report Contents

Create `Project/Research/YYYY-MM-DD-package-dependency-update-report.md` unless a different local research path is more appropriate. Include:

1. `# Package Dependency Update Report`
2. Date, project root, package manager, lockfile, and report location.
3. `Research Rules and Limits`
   - State documentation/research only.
   - State no installs, source edits, live sends, provider calls, or deployments were performed.
   - Distinguish verified local facts from registry/release-note findings and unverified repo-specific impacts.
4. `Summary`
   - Counts of current, wanted/in-range, latest, outdated, incompatible, risky, vulnerable packages.
5. `Dependency Inventory`
   - Table columns: package, dependency group, current declared range, lock-resolved version, wanted/in-range target, latest version, package role, direct/transitive, evidence path.
6. `Outdated and Update Targets`
   - For each package: current, wanted, latest, recommended target, reason.
7. `Compatibility and Engine Constraints`
   - Runtime engines, peer dependencies, framework family constraints, package-manager constraints.
8. `Breaking Changes and Migration Notes`
   - Package, from/to version, changelog/release-note/migration-guide links, breaking changes, migration actions, deprecations/removals, intermediate compatibility versions if needed.
9. `Risk and Priority Matrix`
   - Use P0-P3 rubric:
     - P0: security fix, production breakage, data loss risk, or required compatibility blocker.
     - P1: high-value compatibility, important bug fix, near-term deprecation, or blocked workflow.
     - P2: routine minor/patch updates with moderate value and low/medium risk.
     - P3: optional, cosmetic, speculative, or low-value updates.
   - Include risk level, impact, likelihood, mitigation, rollback point.
10. `Effort Estimates and Dependencies`
    - Estimate XS/S/M/L/XL or hours/days.
    - Note prerequisite upgrades and package families that must move together.
11. `Staged Upgrade Plan`
    - Stage 0: Baseline only. Record current lockfile, scripts, versions, and verification commands.
    - Stage 1: In-range patch/minor updates allowed by current manifest ranges.
    - Stage 2: Low-risk direct dependency updates.
    - Stage 3: Framework/tooling major updates one family at a time.
    - Stage 4: Intermediate compatibility versions where major releases deprecate/remove APIs.
    - Stage 5: Lockfile review, peer dependency review, security review.
    - Stage 6: Final verification and release notes.
12. `Verification Commands`
    - List commands to run after authorization, such as install, lint, typecheck, test, build, audit, smoke tests.
    - Mark commands not run during research.
13. `Acceptance Criteria`
    - Reports created.
    - Versions and evidence recorded.
    - Risks prioritized.
    - No source/manifests changed.
    - No live contact/provider calls made.
14. `Sources`
    - Official package registry links.
    - Upstream release notes, changelogs, migration guides.
    - Local evidence file paths.
15. `Final Checklist`
    - `tech-stack.md` exists at root.
    - Dependency report exists in research location.
    - Declared and lock-resolved versions captured.
    - Current/wanted/latest captured where available.
    - Incompatible/risky dependencies identified.
    - Staged upgrade plan included.
    - No dependency/source changes made.
    - No installs/tests/live calls performed unless separately authorized.
    - Verification evidence path recorded.

## Research Rules

- Prefer official package registries and upstream release notes, changelogs, and migration guides.
- Record the research date and source URLs.
- Clearly label:
  - verified local facts,
  - verified upstream facts,
  - inferred repo-specific impact,
  - unverified assumptions.
- Do not recommend latest major versions solely because they exist.
- Check engines, peer dependencies, deprecations, removals, migration paths, and framework compatibility before recommending a target.
- Use package-family grouping for frameworks and tooling, such as React/Next, Vite/Vitest, TypeScript/ESLint, Jest/Babel, Prisma/database, Playwright/Cypress.

## No-Live-Contact Safety Constraints

- Do not send WhatsApp/SMS/email/push messages.
- Do not call production APIs, payment providers, messaging providers, AI providers, or deployment targets.
- Do not run migrations, queue workers, cron jobs, webhooks, or scripts that can mutate external systems.
- If a command may contact a package registry for metadata only, state that in the report.

## Final Verification Evidence

Record a final evidence section in the dependency report with:

- report paths created;
- commands run and outputs summarized;
- commands intentionally skipped;
- files inspected;
- live-contact safety confirmation;
- whether any source or dependency manifest files were modified.

This workflow is documentation/research only. Source code, dependency manifests, lockfiles, generated artifacts, deployments, and live provider state must remain unchanged unless a separate authorization explicitly requests implementation.
