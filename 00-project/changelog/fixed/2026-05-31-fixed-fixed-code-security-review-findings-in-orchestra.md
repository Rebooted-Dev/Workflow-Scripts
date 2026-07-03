# Fixed code/security review findings in `orchestrator-review.sh` and the neste...
**Date:** 2026-05-31
**Type:** fixed

---

## Summary
- Fixed code/security review findings in `orchestrator-review.sh` and the nested image-generation package. Failed or timed-out orchestrated reviews now still write status JSON with the original exit code, the default plan-review workflow path resolves to the current `01-Planning & Organizing/01-plan-review.md`, unsupported OpenRouter image-generation config has been removed from the public contract, retry classification no longer treats every generic `Error` as retryable, and the OpenAI image request `response_format` rewrite is covered by focused tests.

## Scope
- Migrated from root `CHANGELOG.md` (legacy monolithic changelog).
