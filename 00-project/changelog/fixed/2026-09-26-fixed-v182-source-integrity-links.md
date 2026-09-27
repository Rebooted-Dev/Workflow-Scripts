# Restore v1.82 source-integrity links and navigation

**Date:** 2026-09-26
**Type:** fixed

## Summary

Corrected the four active outbound references in the relocated Astra evaluation plan, marked the old harness draft superseded by its linked final plan, and updated the existing TODO route to approval-gated Plan 05. The protocol was recovered from historical source and navigation-adjusted; corpus and baseline/revised pins were unchanged.

**Troubleshooting:** [v1.82 source-integrity links and navigation were stale](../../troubleshooting/workflow/2026-09-26-workflow-v182-source-integrity-links.md)

## Verification

- Parent reports the active Markdown-link checker and all non-link validators pass locally. The four source targets now resolve; the extra Astra setup audit was preserved.
- Protocol provenance recorded by the companion report: historical source commit/blob `58689d8` / `7c6fd01`, SHA-256 prefix `0e6b69…`; final navigation-adjusted blob `7e7dc747`, SHA-256 prefix `7a8dcf…`.
- No corpus, pin, experiment, host-project file, or Plan 05 arm selection changed. Committed on `v1.82` as `9714c15` after validators and staged meta-log checks passed. Remote CI remains pending until push.
