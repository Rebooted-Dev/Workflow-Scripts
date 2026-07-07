---
name: live-bot-launch-verification
description: Launch or restart a local chat bot and verify real webhook health, auth, tunnel routing, and inbound/outbound delivery. Use when the user says launch my chatbot, restart after changes, verify health, run a real WhatsApp/Kapso/ngrok test, check what model/auth path is in use, or ensure home-env credentials are loaded.
---

# Live Bot Launch Verification

Use this skill for operational bot launch and real delivery checks.

## Workflow

1. Identify runtime truth.
   - Read repo run docs, scripts, env loading code, and current process state.
   - Load or verify expected credentials from the configured source, including `~/.env` when the repo expects it.
   - Identify current model, endpoint, auth mode, webhook secret, port, and tunnel URL from runtime/config, not assumptions.

2. Start or restart intentionally.
   - Stop stale processes only when needed and safe.
   - Start the local bot with the repo's script.
   - After config or behavior changes, restart before claiming verification.

3. Verify local and public paths.
   - Check local health/readiness endpoints.
   - Verify tunnel target and public URL routing before blaming webhook code or the provider.
   - Confirm webhook signature behavior when a secret is configured.

4. Run live delivery checks when requested.
   - Send or receive the smallest safe test message.
   - Confirm both inbound receipt and outbound response through the real service.
   - Document current model/auth/runtime behavior in repo docs when asked or when it changed.

## Guardrails

- Do not describe commands instead of launching when the user asks to launch.
- Do not assume `XAI_API_KEY` or similar model credentials are enough for delivery through a messaging provider.
- Do not trust a reserved tunnel URL until the local tunnel API or equivalent confirms its target port.
