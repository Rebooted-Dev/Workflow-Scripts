# Pre-deployment security check

A reusable, project-agnostic workflow to run before deploying an application. Adapt the steps and paths to your repo (monorepo packages, app directories, lockfiles).

---

## 1. Existing dependency findings

**Goal:** Confirm existing dependency findings are reviewed and no unresolved policy violation is released. Run the canonical [dependency review](../05-review/00-dependencies.md) before this gate; use its optional [dependency security scan brief](../05-review/briefs/dependency-security-scan.md) when applicable.

- Read the current dependency report/findings and record their disposition.
- Block release for unresolved findings that violate the project's security policy.
- Do not initiate a broad audit, dependency upgrade, lockfile change, or automatic remediation here.

**Notes:**

- Dev-only vulnerable dependencies do not affect production runtime but should still be fixed or documented for security hygiene.
- Lockfiles (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`) should be committed after dependency changes.

---

## 2. Bounded release-freshness check

**Goal:** Check release freshness only within the already identified dependency scope; this is not a new inventory or upgrade exercise.

- Compare the release's recorded dependency versions with the existing dependency findings or approved baseline.
- Record only release-blocking freshness issues and their disposition; defer broader outdated-package research to [Dependency Review](../05-review/00-dependencies.md).

**Notes:**

- No package updates or automatic remediation are performed by this check.

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
| 1 | Review existing dependency findings and block unresolved policy violations | |
| 2 | Run the bounded release-freshness check; document release-blocking issues | |
| 3 | Confirm no hardcoded production secrets; .env in .gitignore; prod env source known | |
| 4 | Production build and lint (and typecheck if applicable) succeed | |
| 5 | (Optional) Static/runtime security checks run and findings addressed or waived | |

**Sign-off:** Only deploy when steps 1–4 pass (and 5 if adopted). Record deferred items in the dependency review or release runbook. This gate does not perform automatic remediation.
