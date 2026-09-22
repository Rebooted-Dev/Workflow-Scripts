# Size completion verification and route metadata

**Date:** 2026-09-22  
**Type:** changed

## Summary

Updated the completion-verification workflow to size verification by plan scope: localized plans use one primary verifier, bounded plans use 2–3 focused roles when justified, and broad/high-risk plans may use parallel evidence-justified domain roles under the shared policy. Coverage and evidence requirements remain explicit.

Updated artifact reconciliation to resolve changelog, troubleshooting, and TODO locations through `<metadata-root>`, authoritative naming conventions, and host policy, including documented single-file fallbacks and existing troubleshooting categories.

## Scope

- Changed `04-documentation/03-mark-completed.md` only; no meta-policy files were changed.
- Archive authority remains unchanged: this workflow is the sole terminal authority, and completed-plan destinations continue to be resolved from the host repository's documented policy without inventing a global default.
