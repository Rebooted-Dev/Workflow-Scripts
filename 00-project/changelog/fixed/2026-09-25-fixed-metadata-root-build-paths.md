# Route planning and build paths through metadata-root policy
**Date:** 2026-09-25
**Type:** fixed

---

## Summary
- Replaced bare plan/build directory assumptions in active planning and code-build workflows with `<metadata-root>` routing and the Metadata Root Resolution reference.

## Verification
- Parent reports `rg 'project/build/' 02-code-build 01-planning-and-organizing` returned no matches and the completion-chain policy validator passed.

## Related
- Troubleshooting: [Metadata-root build paths](../../troubleshooting/workflow/2026-09-25-workflow-metadata-root-build-paths.md)
