# Project Root Organisation Runbook

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

## Practical Notes

- Moving app source and app tooling as a coherent unit usually preserves relative imports. Broken references most often come from root docs, scripts, `.gitignore`, config file paths, and commands that assume the repository root is also the app root.
- Keep `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, the main `README.md`, `docs/`, and `project/` at the root for consistent agent and project governance across the repository.
- Do not rewrite historical archive documents unless they are used as current instructions. Old absolute paths in archived plans may be part of the record.
- Do not move nested repositories by accident. Check for nested `.git/` directories before bulk moves.
- Do not use destructive cleanup until you have inspected what will be removed.
- After the move, future agents and developers should treat the app subdirectory as the working directory for application commands.
