# Preserve verified-task and open-debt TODO reconciliation

**Date:** 2026-09-26
**Type:** fixed

## Summary

Corrected the Phase C completion-gate change so a Deferred & Debt trigger prompts reassessment rather than closing the debt, while existing verified plan tasks continue to reconcile to the host TODO. The correction shipped in Phase C commit `9aad15cf8ab96f16a6af6b9ea2bb795fa44e6ef1` after review caught the defect before commit. This follow-up records the existing fix; it makes no new workflow-code change.

**Troubleshooting:** [Debt trigger and verified-task TODO reconciliation](../../troubleshooting/workflow/2026-09-26-workflow-debt-todo-reconciliation.md)

## Verification

- Gate 3 Oracle: PASS (attempt 2).
- `bash scripts/validation/check-completion-chain-policy.sh` passed.
- The active-link checker still reports exactly the four known Plan 01 failures in `00-project/research/v1.82-fixes/2026-09-10-astra-instruction-evaluation-plan.md` at lines 7, 95, 96, and 97; Plan 01 owns them. This is not a link-check pass.
