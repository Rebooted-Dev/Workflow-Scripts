---
id: observability
kind: standard
status: active
---

# Observability Standard

Use this standard for deployable apps, long-running jobs, integrations, and production-facing workflows.

## Baseline

- Structured logs or a consistent logging framework with meaningful levels.
- Startup and shutdown logs include version/build, environment name, and major config choices with secrets redacted.
- Error logs include operation, error class/message, relevant identifiers, and correlation/request ID when available.
- Health or readiness signal exists for services; equivalent liveness signal exists for desktop, CLI, worker, or batch apps.
- External calls log enough context to distinguish provider, operation, status, latency, and retry/fallback behavior.
- Secrets, tokens, personal data, and payment data are not logged.
- A responder can answer: is it running, what version is running, what failed, who/what was affected, and where to look next.

## Triggered Additions

- Add metrics when capacity, throughput, latency, or success-rate questions matter.
- Add tracing when a user-facing path crosses multiple services, async queues, or providers.
- Add alerting when failures require timely human action.

## Verification

For T2/T3 deployable work, intentionally trigger one safe failure and confirm the resulting signal is visible in the documented location.
