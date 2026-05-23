---
name: webhook-bot-hardening-reviewer
description: Review and harden public webhook or chat-bot systems before launch. Use when the user says a bot is going public, asks to lock things down, mentions denial of service, prompt injection, rapid-fire input, file attachments, NSFW/out-of-scope content, failure recovery, retry queues, dead letters, or operator controls.
---

# Webhook Bot Hardening Reviewer

Use this skill for public-facing webhook/model/send pipelines.

## Workflow

1. Map the pipeline.
   - Incoming webhook verification and raw body handling.
   - Body size, JSON parsing, idempotency, and acknowledgement timing.
   - Classification, prompt assembly, model call, output filtering, send path, and state persistence.
   - Operator controls such as pause/resume, recovery listing, manual resend, and handoff.

2. Threat model the real system.
   - Rate limits, spam, DoS, replay, invalid JSON, oversized payloads, unsupported media, unsafe content, prompt injection, scope escape, and data leakage.
   - Treat buffer overflow language as a signal to inspect request limits and parsing, not generic native-code risk unless native code exists.

3. Review recovery.
   - Durable statuses for received, classified, reply generated, send pending, sent, retryable failure, terminal failure, and handoff.
   - Retry queue, dead letter, startup recovery, corrupt state handling, backups, and metrics.
   - Avoid acknowledging away failures with no durable record.

4. Implement or plan by priority.
   - Land local P0/P1 hardening before larger hosting/runtime migrations unless the user changes priority.
   - Add tests for signature handling, invalid payloads, limits, rate limits, safety gates, and recovery state.
   - Redact sensitive sender/message data in helper logs by default.

## Guardrails

- Do not jump to Cloudflare/runtime architecture before local blockers are handled.
- Do not rely on happy-path live sends as evidence of public-launch readiness.
- Do not expose raw webhook payloads or sender data in durable logs unless explicitly required and safe.
