---
id: pre-deployment-security-check
version: 2.0
category: deployment
kind: workflow
triggers: ["pre deployment security check"]
requires: [verification-gates, security-baseline]
agents: [security-scanner, dependency-reviewer]
prev: [confirm-execution]
next: [deploy]
---

# Pre-deployment security check

A reusable, project-agnostic workflow to run before deploying an application. Adapt the steps and paths to your repo (monorepo packages, app directories, lockfiles).

---

## 1. Dependency vulnerabilities

**Goal:** Ensure known vulnerable dependencies are identified and addressed.

- From each directory that contains a `package.json` (root and/or each app/package):
  - Run: `npm audit`
  - If exit code is non-zero, review the report:
    - Note **severity** (critical, high, moderate, low) and **dependency chain** (which top-level package pulls in the vulnerability).
    - Prefer **safe fixes** first: `npm audit fix` (no `--force`). Re-run `npm audit` after.
    - If vulnerabilities remain and the fix requires `npm audit fix --force` or a major upgrade:
      - Prefer **upgrading the minimal set of packages** (e.g. the top-level package that brings in the vulnerable transitive dependency) so peer dependencies and breaking changes are manageable.
      - Re-run `npm install` and `npm audit` after changes.
  - Record outcome: **pass** (0 vulnerabilities or only accepted/low risk) or **fail** (unaddressed high/critical), and any deferred items.

**Notes:**

- Dev-only vulnerable dependencies do not affect production runtime but should still be fixed or documented for security hygiene.
- Lockfiles (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`) should be committed after dependency changes.

---

## 2. Outdated dependencies

**Goal:** Surface outdated packages so you can decide what to upgrade and when.

- From each directory that contains a `package.json`:
  - Run: `npm outdated` (or equivalent for your package manager).
  - Review output:
    - **Patch/minor** updates: usually safe to apply in a pre-deployment pass if CI and tests are green.
    - **Major** updates: plan separately; may require config or code changes and regression testing.
  - Optional: apply non-breaking updates (e.g. `npm update` or targeted `npm install <pkg>@latest` for minor/patch), then re-run tests and lint.
  - Record: list any outdated packages left intentionally for later (e.g. “ESLint 9 upgrade deferred”) so the next deploy or audit doesn’t re-open the same question.

**Notes:**

- Pinning major versions (e.g. `~x.y.0`) is reasonable; document why a major is deferred if it blocks vulnerability fixes.

---

## 3. Environment and secrets

**Goal:** Avoid deploying with default secrets, placeholders, or local-only env in production.

- Confirm **no production secrets** are hardcoded in source (API keys, passwords, tokens). Use env vars or a secure secret store.
- If the app uses `.env` or similar:
  - Ensure `.env` (and any `.env.local`, `.env.*.local`) are in `.gitignore` and never committed.
  - Keep a **template** (e.g. `.env.example`) with variable names and dummy/placeholder values only; no real secrets.
- For the **deployment target**, confirm how production env/secrets are supplied (platform env, vault, build-time injection) and that defaults are safe (e.g. no `NODE_ENV=development` in production).

**Notes:**

- One-time manual check plus a recurring “secrets audit” (e.g. grep for common patterns, or a scanner) is recommended.

---

## 4. Build and lint

**Goal:** Ensure the artifact you deploy is built from a clean, linted codebase.

- From the **root or each deployable app**:
  - Run the **production build** (e.g. `npm run build`). Fix any build errors; deployment should use this same command.
  - Run **lint** (e.g. `npm run lint`). Fix or explicitly waive any new or blocking rules before deploy.
- If you have **type checking** as a separate step (e.g. `tsc --noEmit` or `npm run typecheck`), run it and fix errors.

**Notes:**

- Pre-deployment should use the same Node/npm and env as CI and production where possible to avoid “works on my machine” issues.

---

## 5. Optional: static and runtime security

**Goal:** Catch common security issues before they reach production.

- **Static:** If the project uses ESLint security plugins (e.g. `eslint-plugin-security`) or SAST tools, run them and address or document findings.
- **Runtime:** If you run security-related tests (e.g. dependency checks in CI, OWASP-related checks), ensure they are green or explicitly waived with a ticket/comment.
- **Supply chain:** For high-sensitivity deployments, consider lockfile integrity (e.g. `npm ci` in CI) and whether to use audit or allowlist for dependencies.

**Notes:**

- This section is optional and can be expanded per project (e.g. container image scanning, CSP checks).

---

## Checklist summary

Before each deployment, complete at least:

| Step | Action | Pass/Fail / Deferred |
|------|--------|----------------------|
| 1 | Run `npm audit` (per package root); fix or document vulnerabilities | |
| 2 | Run `npm outdated`; apply or document updates | |
| 3 | Confirm no hardcoded production secrets; .env in .gitignore; prod env source known | |
| 4 | Production build and lint (and typecheck if applicable) succeed | |
| 5 | (Optional) Static/runtime security checks run and findings addressed or waived | |

**Sign-off:** Only deploy when steps 1–4 pass (and 5 if adopted). Record any deferred items (e.g. “ESLint 9 upgrade in backlog”) in your changelog or runbook so the next pre-deployment pass can revisit them.
