# Vercel AI SDK Integration Plan v2

> **Note:** This guide contains project-specific references to "rbc-bible-explorer" as an example. 
> Adapt the concepts, architecture patterns, and implementation steps to your own project structure.

## Executive Summary
The goal is to adopt the Vercel AI SDK to simplify model orchestration, improve security, and prepare for future AI features without destabilising the current DOM-driven UI. We will introduce a UI view adapter and a chat service abstraction so the existing interface keeps working while we move Gemini traffic behind a serverless boundary that uses the SDK for streaming. Advanced SDK capabilities (tool calling, multimodal blocks) can follow once transport parity is achieved.

## Objectives
- Preserve the current DOM/UI experience while modernising the networking and streaming stack.
- Re-home security and rate limiting to a trusted server-side environment.
- Enable incremental adoption of SDK capabilities with low regression risk.
- Document testing, rollout, and back-out plans for each phase.

## Current Architecture Snapshot
- `index.tsx` orchestrates UI events, streaming, Markdown rendering, keyword extraction, copy/export flows, and Gemini API calls (see `docs/system/DATA_FLOW.md`).
- DOM references are centralised in `uiElements.ts`; helper utilities, security filters, and keyword logic are tightly coupled to direct DOM manipulation.
- Google Gemini is called directly from the browser using the API key injected via `vite.config.ts`.

## Target Architecture Overview
```
[UI View Adapter] <--> [Chat Orchestrator (index.tsx)] <--> [Chat Service Interface]
                                                  |
                                        [Serverless Chat Handler]
                                                  |
                                          [Vercel AI SDK + Gemini]
```
- **UI view adapter:** Encapsulates DOM mutations (`showUserMessage`, `streamModelChunk`, `finalizeModelMessage`, `updateKeywords`, button wiring).
- **Chat service:** Provides `sendPrompt(prompt, options)` returning an async iterator of text chunks plus final metadata, hiding whether transport is direct Gemini, fetch to `/api/chat`, etc.
- **Serverless handler:** Runs on Vercel/Netlify (or another target), consumes SDK primitives (`streamText`, `StreamingTextResponse`), executes security checks, and streams responses to the client.

## Phase Plan
1. **Phase 0 – Preparation**
   - Extract the UI view adapter module and update `index.tsx` to rely on it.
   - Add unit/integration test scaffolding (or scripted manual test plans) to lock down critical UI behaviour (message rendering, keyword generation, copy/export, regenerate).
2. **Phase 1 – Chat service abstraction**
   - Introduce `chatService.ts` with the existing browser-based Gemini client as the initial implementation.
   - Ensure streaming continues to pipe through the adapter (no UI changes).
   - Add logging/metrics hooks needed by the future serverless layer.
3. **Phase 2 – Serverless transport swap**
   - Implement `/api/chat` (or equivalent) serverless function using the Vercel AI SDK.
   - Move `ChatbotSecurityFilter`, rate limiting, and output sanitation into the handler; retain lightweight client-side checks for UX.
   - Update `chatService` to call the serverless endpoint. Document dev (`vite` proxy to localhost function) and prod routing (Vercel Edge Function or Netlify Function) plus environment variable handling.
   - Validate streaming: the handler should use `streamText` (or `StreamingTextResponse`) and forward chunk payloads that `chatService` rebroadcasts to the adapter.
4. **Phase 3 – Optional UI modernisation**
   - Evaluate migrating selective UI pieces to React components powered by the SDK’s hooks.
   - Retire adapter methods incrementally as React equivalents land, ensuring parity with keyword extraction, copy/export, regenerate, and exploration buttons.
   - Consider adopting advanced SDK features (tool calling, generative UI) only after React components exist to render them.

## Technical Details
### UI View Adapter
- Consolidate DOM writes (message creation, Markdown application with `marked`, scroll behaviour) into a module, exporting minimal functions consumed by `index.tsx`.
- Ensure adapter emits lifecycle hooks (`onStreamStart`, `onStreamEnd`) so keyword extraction (`extractAndRankKeywords`) and button wiring happen after streaming completes.
- Keep adapter stateless where possible; allow dependency injection for utilities if needed (e.g., passing `marked` renderer).

### Chat Service Interface
- Define interface returning `{ stream: AsyncIterable<ChatChunk>, abort(): void, metadata?: CompletionMeta }`.
- Provide initial implementation using the existing `@google/genai` browser client so refactor can be verified quickly.
- Once the serverless handler is ready, swap implementation to `fetch('/api/chat')` consuming server-sent events or fetch streaming body.

### Serverless Handler Using Vercel AI SDK
- Platform: target Vercel Edge Functions for production; consider Netlify/AWS Lambda fallback depending on deployment constraints.
- Local dev: configure Vite proxy (e.g., `/api/chat` -> `http://localhost:8787/api/chat`) and document start commands for both dev server and function emulator.
- Secrets: load Gemini key and other configuration via platform secrets; remove API key exposure from `vite.config.ts`.
- Handler flow:
  1. Parse request JSON (prompt, conversation context, client metadata).
  2. Run `ChatbotSecurityFilter.validateInput` and server-side rate limiter using `userId` from headers/session.
  3. Call `streamText` from the Vercel AI SDK with `@ai-sdk/google` provider.
  4. Stream chunks back as SSE/ReadableStream; include control messages for final metadata.
  5. Sanitize output via `ChatbotSecurityFilter.sanitizeOutput` before forwarding.

### Maintaining Existing Features
- **Streaming pipeline:** `chatService` converts streamed chunks into adapter callbacks so Markdown updates and scroll behaviour mirror the current UX.
- **Keyword extraction:** Trigger `extractAndRankKeywords` in the adapter’s `finalizeModelMessage` to ensure we still derive keyword lists once streaming completes.
- **Regenerate/copy/export buttons:** Adapter controls addition of buttons after `finalizeModelMessage`; these functions continue to inspect DOM nodes as they do today.
- **Security telemetry:** Ensure serverless handler logs security events (using the existing `SecurityLogger`, adapted for server context) and expose necessary client hooks for analytics.

## Testing & Rollout
- **Phase-level smoke tests:** Document manual validation scripts covering prompt submission, streaming continuity, keyword list updates, copy/export, regenerate, theme/font toggles.
- **Automated regression targets:** Where feasible, add Jest/Vitest tests for adapter methods and chat service behaviour (mocked streaming).
- **Staged rollout:** Deploy serverless handler in shadow mode first (fire requests but ignore responses) to compare latency and output quality. Gradually enable for a subset of users or behind a feature flag.
- **Back-out plan:** Maintain the direct Gemini implementation in `chatService` as a fallback flag until serverless integration proves stable.

## Risks & Mitigations
- **UI regressions during adapter extraction:** Mitigate with incremental commits, visual/manual checks, and temporary logging to ensure adapter receives expected callbacks.
- **Streaming mismatch between SDK and current renderer:** Prototype the chunk translation early; ensure Markdown conversion can handle partial fragments (buffer as needed before rendering).
- **Serverless deployment complexity:** Choose a target platform early, document infrastructure steps, and create environment setup automation (e.g., scripts to sync env vars).
- **Security filter divergence:** Keep a shared module for validation logic consumed by both client (for immediate feedback) and server (authoritative enforcement) to avoid drift.

## Open Questions
1. Which hosting provider (Vercel, Netlify, Fly.io, etc.) best fits existing deployment workflows?
2. Do we need persistence of chat history across sessions? If yes, plan storage (e.g., KV store) alongside the serverless migration.
3. Should we introduce feature flags/configuration management to toggle between transport modes in production?
4. What level of automated testing investment is acceptable before Phase 2 rollout?

## Next Actions
1. Draft adapter interface and `chatService` TypeScript definitions; review with stakeholders.
2. Spike a minimal serverless handler using Vercel AI SDK locally to validate streaming contract.
3. Update project documentation (`README`/runbooks) with dev/prod setup for the new serverless layer.
4. Create task breakdown tickets for each phase to track progress in the planning tool of choice.
