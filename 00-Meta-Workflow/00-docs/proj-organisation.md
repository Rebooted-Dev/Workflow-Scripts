# Project Root Organisation Runbook

> **Historical status (2026-07-19):** Archived generic runbook retained for reference. It is not a current Workflow-Scripts entry point; use the repository README and `00-project-setup/` workflows for active guidance.

Use this when a project root has accumulated application source code, build files, tests, generated app artifacts, docs, and project tracking at the top level, and you want to move only the runnable app/code workspace into a dedicated subdirectory while leaving repository governance, documentation, and project-management files at the root.

## Goal

Organise the repository so the root contains project-level control surfaces, agent instructions, the main README, documentation, and project tracking, while application source code and app-local tooling live in one subdirectory.

Example final shape:

```text
repo-root/
├── .git/
├── .gitignore
├── AGENTS.md
├── CLAUDE.md                  # main-level Claude instruction file
├── GEMINI.md                  # main-level Gemini instruction file
├── README.md                  # main project README
├── docs/                      # project documentation
├── project/                   # changelog, plans, troubleshooting, tracking
├── Workflow-Scripts/          # optional separate workflow repo or meta dir
├── Project-App/               # app/source workspace
└── project-organisation.md    # optional root runbook
```

Application workspace example:

```text
repo-root/Project-App/
├── package.json
├── package-lock.json
├── src/
├── components/
├── lib/
├── tests/
├── scripts/
├── config/
├── node_modules/              # optional local dependency tree
└── build config files
```

## Root vs App Workspace

Keep at the root:

- Git control files and folders: `.git/`, `.gitignore`, `.gitattributes`.
- Agent instruction files at the main repository level: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and similar agent-specific root files.
- The main project README: `README.md`.
- Project documentation: `docs/`.
- Project tracking and operational records: `project/`, including changelog, plans, troubleshooting, results, research, and archives.
- Independent nested repositories or shared workflow systems: for example `Workflow-Scripts/`.
- Repo-level metadata that intentionally describes the full repository rather than one app.
- Small root-level runbooks that explain the new layout.

Move into the app subdirectory:

- Application source: `src/`, `app/`, `components/`, `hooks/`, `lib/`, `utils/`, `types/`, `schemas/`, `quality/`.
- App entrypoints: `index.html`, `index.tsx`, `main.ts`, framework route folders.
- Package and build files: `package.json`, lockfiles, `vite.config.ts`, `next.config.*`, `tsconfig.json`, `electron-builder.config.*`, bundler configs.
- App assets and build resources: `public/`, `assets/`, `styles/`, `build-resources/`, `prompts/`, `skills/`.
- App tests: `tests/`, `__tests__/`, `*.test.*` folders when they import app code.
- Dependency tree if present and intended for the app: `node_modules/`.

Do not move:

- `.git/`.
- Separate nested repositories unless the user explicitly asks.
- Root workflow directories that are not part of the app.
- Main-level agent instruction files: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and equivalents.
- The main root README: `README.md`.
- Root documentation and project-management directories: `docs/`, `project/`.
- Files whose purpose is to describe the whole monorepo or repository shell.
- User-generated or unrelated artifacts unless they are part of the app workspace.

## Procedure

1. Choose the app directory name.

   Use a name that describes the actual app, for example `App/`, `Frontend/`, `Web/`, `Project-App/`, or the product name. Avoid ambiguous names like `new/` or `code/`.

2. Inventory the root before moving.

   Run a shallow listing and classify every top-level item:

   ```bash
   find . -maxdepth 1 -mindepth 1 -print | sort
   git status --short
   ```

   Note any existing dirty changes before moving files. Do not overwrite or discard user changes.

3. Create the app directory.

   ```bash
   mkdir -p Project-App
   ```

4. Move the app workspace as a coherent unit.

   Move directories and files that belong to the app together. Prefer one controlled move operation after classification.

   Example:

   ```bash
   mv package.json package-lock.json tsconfig.json vite.config.ts index.html src components lib tests Project-App/
   ```

   Adjust the list for the project. Include app-local config files and assets. Do not include root `AGENTS.md` files, `README.md`, `docs/`, or `project/`.

5. Move app-local dependencies if present.

   If `node_modules/` exists at the root and belongs to the moved app, move it into the app directory:

   ```bash
   mv node_modules Project-App/
   ```

   If the destination already has a tiny generated cache directory, inspect it before replacing it. Do not remove a populated dependency tree without checking.

6. Update root-level guidance.

   Update root `AGENTS.md`, root `README.md`, root `docs/`, and root `project/` references as needed so they say:

   - Git commands still run from the repository root.
   - App commands run from the app subdirectory.
   - Changelog/troubleshooting/project tracking remains at the repository root unless the project explicitly uses app-local tracking.
   - Nested repositories or workflow directories remain independent.

7. Update ignore rules.

   Rewrite ignore rules that assumed app files were at the root.

   Before:

   ```gitignore
   desktop/*.cjs
   dist/
   design/*.zip
   project/results/archive/*.log
   ```

   After:

   ```gitignore
   Project-App/desktop/*.cjs
   Project-App/dist/
   Project-App/design/*.zip
   project/results/archive/*.log
   ```

   Keep root project-management ignore patterns rooted at `project/` when `project/` remains at the repository root. Keep generic rules like `*.log`, `.DS_Store`, `node_modules`, and `coverage/` if they are meant to apply anywhere.

8. Update root setup docs.

   Search live docs for old working-directory instructions:

   ```bash
   rg -n "cd .*ProjectName|npm run|yarn|pnpm|bun|project/changelog|docs/agents" README.md docs project Project-App/*.md
   ```

   Change setup instructions so developers `cd` into the app directory before running app commands. Keep links to `docs/` and `project/` rooted at the repository root.

9. Review source references.

   Most relative imports inside the moved app should continue to work if the app was moved as a whole. Still scan for root-anchored assumptions:

   ```bash
   rg -n "from ['\"]\\.\\.?/|import\\(['\"]\\.\\.?/|public/|assets/|scripts/|prompts/|build-resources/|project/" Project-App
   ```

   Focus on config files, scripts, root docs, and runtime file reads. Historical archive docs may keep old paths if they are evidence records, but live setup/build docs should be updated.

10. Update the root changelog if the repo uses one.

   For projects with a changelog system, add a refactor entry in the root `project/changelog/` directory. Include:

   - App workspace moved into the new subdirectory.
   - Root guidance and ignore paths updated.
   - Verification commands run from the new app directory.

11. Verify from the new app directory.

   Run the strongest available checks from inside the app workspace:

   ```bash
   cd Project-App
   npm run typecheck
   npm run build
   npm run test:run
   ```

   Substitute the project’s package manager and scripts. If the app has desktop, server, or generated-artifact builds, run those too when relevant.

12. Audit final root layout.

   Confirm no app/source files remain at the root:

   ```bash
   cd ..
   find . -maxdepth 1 -mindepth 1 -print | sort
   ```

   The root should contain repo-level files, agent instruction files, the main README, `docs/`, `project/`, meta/workflow directories, and the app subdirectory.

13. Inspect git status.

   ```bash
   git status --short
   ```

   Expect many deletions at old root paths and additions under the app directory unless Git detects renames. Check that unrelated dirty changes are preserved and not reverted.

14. Run a full post-reorganisation reference review on the project directory.

   After the move, scan the **entire repository** (root, app subdirectory, `docs/`, `project/`, CI/editor config, and scripts)—not only the app workspace—to catch broken file and folder references. See [Post-reorganisation reference review](#post-reorganisation-reference-review-full-project-directory) below.

## Post-reorganisation reference review (full project directory)

Do this review **after** steps 6–13 and **before** declaring the reorganisation complete. The goal is to find any path, link, or command that still assumes app files live at the repository root (or at an old directory name).

Replace `Project-App` below with your actual app directory name (for example `Icon-Maker-codebase/`).

### 1. Define review scope

Include:

- Repository root: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `README.md`, `.gitignore`, `.github/`, `.vscode/`, root scripts, env examples.
- App workspace: `Project-App/` (configs, source, scripts, tests, assets).
- Live documentation: `docs/`, root `README.md`, and any `*.md` under `project/` that agents or developers use for setup (exclude pure archives unless they are linked from indexes).
- Build and tooling configs: `package.json` scripts, bundler configs, `tsconfig.json`, `electron-builder` configs, shell scripts, Makefile, Docker files.
- Nested repos: confirm `Workflow-Scripts/` (or similar) was **not** moved and still resolves independently.

Exclude from required fixes (unless used as current instructions):

- Historical plans, completed-plan archives, old changelog entries, and research notes that intentionally record pre-move paths.

### 2. Inventory stale root paths

Search for references to files and folders that **used to** live at the repo root but now live under the app directory:

```bash
# From repository root — adjust APP_DIR and stale path segments for your project
APP_DIR="Project-App"

rg -n --glob '!node_modules' --glob '!.git' \
  '(^|[^/])(components|desktop|services|scripts|prompts|build-resources|renderer|release|dist)/|(^|[^/])(App\.tsx|index\.tsx|index\.html|package\.json|vite\.config|tsconfig\.json|electron-builder)' \
  . --glob "!${APP_DIR}/**"
```

Also search for **old app-directory names** if you renamed during the move (for example `Icon-Maker-codebase` vs `Project-App`):

```bash
rg -n 'Project-App|Icon-Maker-codebase|/src/|npm run|npm install' \
  README.md AGENTS.md CLAUDE.md GEMINI.md docs project .github .vscode 2>/dev/null
```

Flag every hit: update the path, add `cd ${APP_DIR}` to command examples, or mark the doc as historical.

### 3. Verify live setup and command docs

Confirm all **current** setup instructions tell developers where to run commands:

```bash
rg -n 'npm (run|install|ci)|yarn |pnpm |bun |cd ' README.md docs AGENTS.md CLAUDE.md GEMINI.md
```

Each app command block should either:

- Run from `${APP_DIR}` (`cd ${APP_DIR}` then `npm run …`), or
- Use an explicit path (`npm run build --prefix ${APP_DIR}`).

Root-only operations (git, changelog, plans) should stay at the repository root without implying app files are co-located.

### 4. Check config and script path assumptions

Inside the app directory, scan for paths that escape to the old layout or point at the wrong tree:

```bash
cd "${APP_DIR}"

rg -n "from ['\"]\\.\\.?/\\.\\.?/|import\\(['\"]\\.\\.?/\\.\\.?/|__dirname|process\\.cwd\\(\\)|path\\.join\\(|readFileSync\\(|existsSync\\(|build-resources|prompts/|renderer/|release/|public/|assets/" \
  --glob '!node_modules' .

rg -n '\\.\\./project/|\\.\\./docs/|Workflow-Scripts/' . --glob '!node_modules'
```

In root configs, confirm ignores and CI paths use the new prefix:

```bash
cd ..
rg -n '^(dist|renderer|release|build|desktop|node_modules|vite)/|desktop/\*\.cjs' .gitignore .github .vscode 2>/dev/null
```

Update any rule that still targets root-level app artifacts without the `${APP_DIR}/` prefix.

### 5. Validate TypeScript and bundler resolution

From the app directory:

```bash
cd "${APP_DIR}"
npm run type-check   # or: npx tsc --noEmit
```

If `tsconfig.json` excluded sibling dirs at the old root (for example `Workflow-Scripts`), update excludes to parent-relative paths (for example `../Workflow-Scripts`).

Re-run the production build and any desktop/server build scripts referenced in `README.md`.

### 6. Check Markdown links and file references

Broken relative links are a common failure mode after a move:

```bash
# Markdown links to paths that may no longer exist at repo root
rg -n '\]\((\./|\.\./)[^)]+\)' README.md docs project AGENTS.md CLAUDE.md GEMINI.md

# Optional: list tracked paths still referenced from docs but missing on disk
while IFS= read -r path; do
  [ -e "$path" ] || echo "MISSING: $path"
done < <(rg -o '\]\((\./[^)]+)\)' README.md docs -r '$1' | sed 's|^\./||' | sort -u)
```

Fix links that point at moved app files; keep `docs/` and `project/` links rooted at the repository root unless the target moved into `${APP_DIR}/`.

### 7. Confirm no stray app files at the root

```bash
find . -maxdepth 1 -mindepth 1 \( -name '*.tsx' -o -name '*.ts' -o -name 'package.json' -o -name 'vite.config.*' \) -print
```

An empty result is expected. If anything appears, move it into `${APP_DIR}` or confirm it is intentional repo-level metadata.

### 8. Editor, CI, and environment hooks

Search tooling that hardcodes the old working directory:

```bash
rg -n 'working-directory|cwd|defaultWorkingDirectory|PROJECT_ROOT|SVG-App|Project-App' \
  .github .vscode .claude .cursor 2>/dev/null
```

Update task definitions, launch configs, and agent rules so app tasks use `${APP_DIR}` as the working directory.

### 9. Record review results

Summarise findings in the reorganisation changelog entry (or a short note in `project/`):

- Files updated and categories (docs, `.gitignore`, CI, scripts, configs).
- Searches run and whether any stale references remain in archives only.
- Verification commands executed and their outcome.

Re-run targeted searches after fixes until live docs and configs are clean.

## Completion Checklist

- The app directory exists and contains all app code, configs, tests, assets, scripts, package files, and app-local dependencies.
- The root contains repository/meta/workflow files and directories, main-level agent instruction files including `CLAUDE.md` and `GEMINI.md`, the main README, `docs/`, and `project/`.
- Root instructions explain where to run Git commands and where to run app commands.
- `.gitignore` patterns still ignore generated app artifacts in their new locations.
- Live setup docs point developers into the app directory before running app commands.
- Source imports and config file references resolve from the new app directory.
- Root changelog/troubleshooting bookkeeping is updated if the project requires it.
- Typecheck passes from the new app directory.
- Build passes from the new app directory.
- Tests pass from the new app directory, or any skipped/unavailable checks are clearly documented.
- A **full post-reorganisation reference review** was run across the project directory (root, app workspace, live docs, configs, CI/editor hooks); stale paths in current instructions were fixed or explicitly documented as historical.
- No app source files, `package.json`, or primary build configs remain at the repository root (unless intentionally repo-level).
- Markdown links and scripts used in setup/build docs resolve to existing paths after the move.

## Practical Notes

- Moving app source and app tooling as a coherent unit usually preserves relative imports. Broken references most often come from root docs, scripts, `.gitignore`, config file paths, and commands that assume the repository root is also the app root.
- Keep `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, the main `README.md`, `docs/`, and `project/` at the root for consistent agent and project governance across the repository.
- Do not rewrite historical archive documents unless they are used as current instructions. Old absolute paths in archived plans may be part of the record.
- Do not move nested repositories by accident. Check for nested `.git/` directories before bulk moves.
- Do not use destructive cleanup until you have inspected what will be removed.
- After the move, future agents and developers should treat the app subdirectory as the working directory for application commands.
- Broken references after a move rarely show up in TypeScript alone: run the [full project-directory review](#post-reorganisation-reference-review-full-project-directory) so root agent files, `docs/`, `.gitignore`, CI, and shell scripts are checked—not only `${APP_DIR}/` source imports.
