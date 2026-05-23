---
name: provider-plumbing-auditor
description: Trace a user-facing AI generation setting or provider behavior end to end through UI, state, request schemas, API routes, factories, adapters, and tests. Use when the user says a control must work for all providers, asks to pass parameters to API calls, reports provider selection being ignored, or needs direct vs research generation routes compared.
---

# Provider Plumbing Auditor

Use this skill for end-to-end provider plumbing, especially when UI state must reach every relevant provider.

## Workflow

1. Define the contract.
   - Identify whether the setting is provider-agnostic, provider-specific, generation-only, edit/upscale-only, direct-only, or research-only.
   - Preserve explicit product wording and button semantics.

2. Trace the full path.
   - UI controls and labels.
   - Stores, defaults, and persistence.
   - Shared frontend/backend types.
   - Validation schemas and request builders.
   - API routes and controllers.
   - Provider factory/strategy selection.
   - Provider-specific adapters and boundary normalization.
   - Response parsing and UI render/state update.

3. Fix the narrow break.
   - Avoid UI-only changes when the parameter must reach adapters.
   - Avoid adapter-only changes when state/schema drops the field earlier.
   - Keep fallback behavior explicit and fail closed when the user selected a specific provider.

4. Verify by surface.
   - Add focused tests for request construction, schema acceptance, provider payloads, and persistence when relevant.
   - For rendered behavior, use runtime/browser checks when feasible.
   - Confirm non-target routes were not expanded accidentally.

## Guardrails

- Do not infer a shared setting from provider-specific config.
- Do not treat backend success as UI success if the returned asset is not displayed.
- Do not let one provider's naming or casing contract leak into shared UI labels.
