---
name: provider-capability-verification
description: Verify current AI provider model names, capabilities, API contracts, and routing claims against live provider catalogs, official docs, or the current adapter code. Use when the user asks for a complete accurate provider/model list, whether a provider supports a capability, whether a model name is correct, or whether docs/plans/constants match current provider reality.
---

# Provider Capability Verification

Use this skill when provider facts may be stale or when a plan depends on external model/API capabilities.

## Workflow

1. Identify the claim.
   - Extract the exact provider, model, capability, endpoint, button/mode, and app path under discussion.
   - Separate runtime provider integration from MCP/operator tooling unless the user explicitly links them.

2. Verify current truth.
   - Prefer live provider catalogs or official docs for model names and capability support.
   - Inspect local adapter code, defaults, env precedence, request payloads, and fallback chains.
   - If browsing or network access is blocked, state that the result is code-only and may need live verification.

3. Reconcile product semantics.
   - Preserve explicit user choices such as selected provider, direct `Generate`, or `Research & Generate`.
   - Do not let attachments, fallback logs, or generic capability assumptions silently change the selected route.
   - Distinguish account/billing/capability errors from local code defects.

4. Update artifacts when requested.
   - Update app constants, docs, plans, and research files only after verification.
   - Save durable provider/model catalogs in `project/research` when the user asks for a complete accurate list.
   - Include source links or command evidence for time-sensitive facts.

## Guardrails

- Do not trust stale checked-in model IDs when the user asks for current names.
- Do not infer provider support from a successful fallback path.
- Do not merge provider-native file/routing paths unless current code and product semantics require it.
