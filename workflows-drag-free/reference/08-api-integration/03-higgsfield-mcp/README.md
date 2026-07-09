# Higgsfield MCP Workflows

Workflows for the Higgsfield MCP image provider (`mcp-remote`, OAuth, readiness probes, and in-app reconnect).

## Workflows

| File | Purpose | When to use |
|------|---------|-------------|
| [`higgsfield-mcp-connect-auth-reconnect.md`](./higgsfield-mcp-connect-auth-reconnect.md) | Diagnose and recover MCP connect/auth/reconnect failures | Stale OAuth, false-positive list probe, post-reconnect failures, image 401s |

## Canonical reference (Podcast Studio host)

Distilled technical note (lessons, issue catalog, sources):

`project/research/2026-06-03-higgsfield-mcp-connect-auth-reconnect-technical-note.md`

Operator runbook: `docs/configuration/README.md` — “Higgsfield MCP Auth Preflight and Stale Cache Recovery”.

## Quick start

1. Identify failing endpoint (`/api/higgsfield-mcp/status`, `/api/image`, `/api/generate/plan`, etc.).
2. Run `npm run probe:higgsfield-mcp -- --auth-check` from `Podcast Creative Studio AI 1.1.3b/frontend`.
3. If stale auth: app reconnect or manual cache move + OAuth (see workflow §4).
4. Confirm status 200 / preflight pass before image batches.

## Related

- Parent: [`../README.md`](../README.md)
- Debugging: [`../../../03-debugging/02-bug-fix-workflow.md`](../../../03-debugging/02-bug-fix-workflow.md)