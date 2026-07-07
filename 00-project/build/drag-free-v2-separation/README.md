# Drag-Free v2 Separation Repair Evidence

This directory records the v2.0a redirect-target repair performed after the Drag-Free v2 promotion. Root `workflows/`, `core/`, `reference/`, `tools/`, `MOVED.json`, `MOVED.md`, `catalog.json`, and `ROUTER.md` are the active v2.0a topology. `00-project/Drag-Free-v2/` is retained as archived promotion evidence, not a second live workflow tree.

## Audit Files

- `moved-target-audit.csv` lists every `MOVED.json` row, its initial target state, chosen source, action, and final state.
- `remediate_moved_targets.py` is the one-off repair utility used to produce the manifest and repairs.

## Result Summary

- Rows audited: 146
- Final `real` targets: 146

## Source Summary

- `existing v2 target`: 38
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/demo.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/package-lock.json`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/package.json`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/config/builder.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/core/generator.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/core/registry.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/core/types.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/index.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/providers/base.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/providers/factory.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/providers/fal.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/providers/google.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/providers/openai.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/providers/xai.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/utils/retry.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/src/utils/validation.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/test-errors.js`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/test-fal.js`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/test-summary.js`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/config/builder.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/core/generator.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/core/registry.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/providers/factory.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/providers/openai.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/utils/retry.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tests/unit/utils/validation.test.ts`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/tsconfig.json`: 1
- `staged:08-API-Integration/02-AI-SDK/src-core/@ai-sdk-image-generation/vite.config.ts`: 1
- `staged:10-technical-docs/Gemini/Image Generation/image-understanding.md`: 1
- `staged:10-technical-docs/Gemini/Image Generation/media-resolution.md`: 1
- `staged:10-technical-docs/Gemini/Image Generation/nano-banana.md`: 1
- `v1.7`: 77

## Errors

- None
