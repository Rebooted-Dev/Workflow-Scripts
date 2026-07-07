---
id: error-handling
kind: standard
status: active
---

# Error Handling Standard

Use this standard when designing, implementing, or reviewing failure paths.

## Contract

- Classify boundary failures before implementation: expected recoverable, expected unrecoverable, or programmer error.
- No silent failures. A caught error must be handled meaningfully, wrapped with context and rethrown, or logged at the correct level with enough context to act.
- Fallbacks are designed, observable, and bounded. A fallback that hides primary-path failure without a signal is a defect.
- Retries are only for transient faults and need backoff, a cap, and idempotency consideration.
- Programmer errors fail fast. Environmental failures degrade only when the degraded mode is explicit and safe.
- User-facing errors explain what happened and what the user can do next without leaking secrets or internals.
- Cleanup runs on failure paths. Partially completed writes, locks, temp files, and subscriptions are released or reconciled.
- Cross-boundary errors preserve cause and correlation/request context.

## Review Questions

- What happens when each external call, parse, write, or async operation fails?
- Which failures are retried, which are surfaced, and which abort the operation?
- Where would an operator see fallback activation or repeated failure?
- Can corrupted state continue after an unrecoverable failure?
