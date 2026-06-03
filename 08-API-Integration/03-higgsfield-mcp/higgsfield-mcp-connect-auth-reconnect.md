# Workflow: Higgsfield MCP Connect, Auth, and Reconnect

## Purpose

Diagnose and recover Higgsfield MCP image-provider connection and authentication failures in Podcast Creative Studio AI (and similar `mcp-remote` + OAuth integrations). This workflow separates **discovery auth** (`initialize`, `tools/list`) from **execution auth** (`generate_image`), applies no-spend readiness checks, runs app or CLI recovery, and avoids misattributing post-reconnect failures to Higgsfield when another provider (e.g. Gemini plan) is the blocker.

## Canonical reference (host project)

Full distilled lessons, issue catalog, and source index:

- **Host repo path:** `project/research/2026-06-03-higgsfield-mcp-connect-auth-reconnect-technical-note.md`
- **Operator runbook:** `docs/configuration/README.md` — section “Higgsfield MCP Auth Preflight and Stale Cache Recovery”
- **App frontend root:** `Podcast Creative Studio AI 1.1.3b/frontend`

Read the technical note when you need historical context, code touchpoints, or the complete source document list.

## When to use

| Situation | Use this workflow |
|-----------|-------------------|
| Higgsfield MCP images fail with `Invalid or expired token` or `/api/image 401` | Yes |
| `npm run probe:higgsfield-mcp` passes but generation fails | Yes |
| User reconnected Higgsfield but generation still fails | Yes — triage failing endpoint first |
| Implementing or reviewing Higgsfield MCP auth recovery | Yes |
| General Higgsfield SDK (non-MCP) image errors | No — use provider-specific docs |
| Gemini/OpenAI plan or text failures only | No — unless ruling out Higgsfield as red herring |

## Inputs

- Symptom description (errors, HTTP status, request IDs).
- Host project repository root.
- Optional: `project/execution/terminal.md`, `project/execution/console.md`, server logs.
- Image model setting: `higgsfield-mcp` vs other providers.
- Environment: local dev (`localhost:3051`), packaged macOS app, or CI.

## Prioritization

- **P1** when image batch is blocked or repeated `/api/image 401` after reconnect.
- Use shared rubric: `../../00-Meta-Workflow/00-meta/severity-priority-rubric.md`.
- Pair with **[`../../../03-debugging/02-bug-fix-workflow.md`](../../../03-debugging/02-bug-fix-workflow.md)** when the root cause is a code defect, not stale OAuth.

---

## Steps

### 1. Triage — identify the failing hop

Before changing auth state, determine **which endpoint and upstream host** failed.

| Log signal | Likely layer | Next step |
|------------|--------------|-----------|
| `/api/higgsfield-mcp/status` 401 or `needs_auth` | Higgsfield execution auth | §3–§5 |
| `/api/higgsfield-mcp/status` 503 | Bridge misconfig / unavailable | §6 |
| `/api/higgsfield-mcp/reconnect` 200 then still image 401 | OAuth incomplete or cache still stale | §4–§5 |
| `/api/generate/plan` 403 + Gemini dunning / `PERMISSION_DENIED` | **Not** Higgsfield image auth | §7 |
| `/api/image` 401 + `Invalid or expired token` | Higgsfield execution auth | §3–§5 |
| `tools/list` OK, `generate_image` fails | Stale `~/.mcp-auth/` (classic) | §4–§5 |

**Rule:** Reconnect HTTP 200 means reconnect **started**, not generation-ready. Status 200 or `--auth-check` pass is required before batch images.

### 2. Verify discovery vs execution (no-spend)

From host frontend directory:

```bash
cd "<host>/Podcast Creative Studio AI 1.1.3b/frontend"

# Discovery only — NOT sufficient for generation
npm run probe:higgsfield-mcp

# Execution boundary — required before image batches
npm run probe:higgsfield-mcp -- --auth-check
# or: HIGGSFIELD_MCP_PROBE_AUTH_CHECK=1 npm run probe:higgsfield-mcp
```

**Healthy auth-check:** prints `Higgsfield MCP auth preflight passed` and a no-spend cost estimate (`generate_image` with `get_cost: true`).

**Optional schema check (no spend):**

```bash
npm run probe:higgsfield-mcp -- --auth-check --aspect-ratio 3:4
```

Confirm `params.aspect_ratio` appears in probe output when diagnosing aspect-ratio issues.

### 3. App-owned readiness (in running dev app)

When the app is running:

1. `POST /api/higgsfield-mcp/status` — same no-spend preflight as `--auth-check`.
2. Interpret status:
   - `ready` → 200 — proceed to image phase (if no other blocker).
   - `needs_auth` → 401 — §4 reconnect.
   - `billing_or_credits_issue` → 402 — Higgsfield account/credits.
   - `unavailable` / `misconfigured` → 503 — §6 bridge/runtime.

Settings UI: selecting `higgsfield-mcp` should surface Connect/Reconnect when not ready.

### 4. Recover stale OAuth cache

**Preferred (in-app):**

1. `POST /api/higgsfield-mcp/reconnect` — moves stale cache to `~/.mcp-auth-backups/`, starts OAuth bridge.
2. Complete **browser OAuth** when prompted.
3. `POST /api/higgsfield-mcp/status` again until 200 / `ready`.
4. Re-run `npm run probe:higgsfield-mcp -- --auth-check` if validating outside the app.

**Manual fallback (CLI / no app API):**

```bash
mv ~/.mcp-auth/mcp-remote-0.1.37 /private/tmp/mcp-remote-0.1.37-stale-$(date +%Y%m%d-%H%M%S)
cd "<host>/Podcast Creative Studio AI 1.1.3b/frontend"
npm run probe:higgsfield-mcp -- --auth-check
```

Complete browser authorization; confirm preflight passes before image smoke tests.

**Common stale-cache causes:** token rotation/revocation, long idle time, sleep/resume, provider auth policy changes.

### 5. Verify image path (after auth ready)

1. Confirm `settings.imageModel` is `higgsfield-mcp` if testing MCP images.
2. Run a **single** low-risk image or no-spend `get_cost` again — do not queue a full batch until preflight passes.
3. If batch was blocked earlier, use app **retry missing images** (reuses stored prompts after reconnect).
4. Image batch guard should block repeated 401s once when status is not ready — if guard fails, treat as code bug (bug-fix workflow).

**Regression tests (host project):**

```bash
cd "<host>/Podcast Creative Studio AI 1.1.3b/frontend"
npx vitest run lib/server/image-providers/__tests__/higgsfieldMcpProvider.test.ts \
  lib/server/higgsfield-mcp/__tests__/authRecovery.test.ts \
  app/api/higgsfield-mcp/status/__tests__/route.test.ts \
  app/api/higgsfield-mcp/reconnect/__tests__/route.test.ts
```

### 6. Bridge / runtime failures (not token stale)

If discovery fails or bridge exits with code 1:

| Check | Action |
|-------|--------|
| MCP URL | Must be `https://mcp.higgsfield.ai/mcp` (not root `/`) |
| stderr | Capture bridge child stderr — exit code alone is useless |
| macOS standalone | Verify `mcp-remote` shipped with full hoisted dependency closure |
| Env | `HIGGSFIELD_MCP_URL`, `HIGGSFIELD_MCP_COMMAND`, `HIGGSFIELD_MCP_ARGS` |

See host troubleshooting: `project/troubleshooting/runtime/2026-05-22-runtime-higgsfield-mcp-bridge-endpoint.md`, `2026-05-23-runtime-macos-higgsfield-mcp-standalone-runtime.md`.

### 7. Rule out Gemini (and other) red herrings

If logs show **after** Higgsfield status 200:

- `/api/generate/plan` → Google 403 `PERMISSION_DENIED` / “Lightning dunning decision is deny”

Then the blocker is **Gemini project billing/access**, not Higgsfield MCP tokens. No amount of Higgsfield reconnect fixes planning until `APP_GEMINI_API_KEY` / project billing is resolved.

Document separately; do not file Higgsfield auth troubleshooting for Gemini-only failures.

### 8. Implementation changes (only if preflight logic is wrong)

If stale auth is ruled out but status/preconnect behavior is incorrect:

1. Follow **[`../../../03-debugging/02-bug-fix-workflow.md`](../../../03-debugging/02-bug-fix-workflow.md)**.
2. Primary code: `lib/server/higgsfield-mcp/authRecovery.ts`, `higgsfieldMcpProvider.ts`, status/reconnect routes, `mediaGenerationController.ts`, `SettingsPanel.tsx`.
3. Preserve: default probe = list-only; auth boundary = opt-in `--auth-check` or status API.
4. Add regression tests when fixing auth classification or cache move behavior.

### 9. Documentation (host project)

When this workflow results in a **new** incident or code change in the host repo:

| Change type | Host action |
|-------------|-------------|
| Bug fix / recovery behavior | `project/changelog/fixed/` + `project/troubleshooting/runtime/` + index rows |
| Docs-only clarification | `project/changelog/docs/` if material |
| Research update | Update `project/research/2026-06-03-higgsfield-mcp-connect-auth-reconnect-technical-note.md` |

Do **not** duplicate long incident write-ups in Workflow-Scripts; link to host `project/troubleshooting/` entries.

---

## Decision flow

```
Report: Higgsfield / MCP / image auth issue
        │
        ▼
  Which endpoint failed?
        │
        ├─ /api/generate/plan + Gemini 403 ──► Fix Gemini billing/key (§7)
        │
        ├─ /api/image 401 or Invalid token ──► §2 auth-check
        │       │
        │       ├─ fail ──► §4 reconnect + OAuth ──► §2 re-check
        │       └─ pass ──► payload/credits/parallel timeout (technical note §3)
        │
        └─ probe list OK, auth-check fail ──► §4 stale cache
```

---

## Output requirements

- Identified failing hop (discovery vs execution vs other provider).
- Evidence: probe output, status HTTP code, or log excerpts (no secrets/tokens).
- Recovery actions taken (reconnect, cache move, OAuth completed).
- Confirmation: `--auth-check` or status 200 before batch images.
- Host project log updates if bug fix or new incident.

## Acceptance criteria

- [ ] Failing endpoint and upstream host are identified and documented.
- [ ] List-only probe is not used as sole proof of generation readiness.
- [ ] Auth-check or `/api/higgsfield-mcp/status` returns ready before image batch (when MCP images required).
- [ ] Gemini/plan failures are not misclassified as Higgsfield token failures when logs show plan 403 only.
- [ ] No token values written to logs, changelog, or workflow output.
- [ ] Host troubleshooting/changelog updated when code or novel incident warrants it.

## Related workflows

- **[`../../../03-debugging/02-bug-fix-workflow.md`](../../../03-debugging/02-bug-fix-workflow.md)** — code defects in preflight/reconnect/guards
- **[`../../../03-debugging/01-bug-description.md`](../../../03-debugging/01-bug-description.md)** — structured report for persistent auth issues
- **[`../../../01-Planning & Organizing/00-research-and-plan.md`](../../../01-Planning & Organizing/00-research-and-plan.md)** — auth recovery implementation planning
- **[`../../../04-documentation/02-sync-documentation.md`](../../../04-documentation/02-sync-documentation.md)** — sync `docs/configuration/README.md` after runbook changes

## Key principles (summary)

1. **Two auth boundaries** — `tools/list` ≠ `generate_image` readiness.
2. **No-spend execution probe** — `get_cost: true` before paid batches.
3. **Reconnect ≠ ready** — always re-check status or auth-check after OAuth.
4. **Timeline discipline** — auth provider A, failure on provider B → verify B before re-auth A.
5. **Fail closed** — explicit `higgsfield-mcp` selection must not silently fall back to Google.

---

*Workflow filed from host research `project/research/2026-06-03-higgsfield-mcp-connect-auth-reconnect-technical-note.md` (2026-06-03).*