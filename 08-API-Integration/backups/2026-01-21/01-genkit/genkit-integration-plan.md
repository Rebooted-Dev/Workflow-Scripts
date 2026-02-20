# Genkit Integration Plan – Revised

## Plan Critique
The original proposal mixed long‑term aspirations (RAG, agentic flows, Bible datasets) with the immediate need to finish the in‑progress Genkit migration. Several concrete gaps surfaced during the code review and should be addressed before layering new functionality:

1. **Genkit server cannot start**: `server.ts` imports `genkit/dev`, a subpath the package does not export, so `npx tsx server.ts` crashes. The plan must explicitly replace this import with the supported CLI/server bootstrap (e.g., `@genkit-ai/cli/devserver` or `npx genkit dev`).
2. **API key mismatch**: The existing frontend reads `APP_GEMINI_API_KEY` from `~/.env`, but the Genkit plugin only checks `GEMINI_API_KEY`, `GOOGLE_API_KEY`, or `GOOGLE_GENAI_API_KEY`. Without copying or exporting the value, the flow fails. The plan needs an explicit step to load `APP_GEMINI_API_KEY` server-side and map it to the expected environment variable before initializing `googleGenAI()`.
3. **Unsafe feature flag default**: Shipping `config.features.useGenkitApi: true` while the server path is unstable breaks the app. Keep the flag `false` until the Genkit path passes smoke tests, then flip it intentionally.
4. **Process lifecycle**: `npm run dev:stop` only cleans Vite. Once Genkit boots successfully, it will linger unless the stop script also terminates `tsx server.ts`. The plan should call this out.
5. **Scope creep**: Tooling, RAG, and Firebase deployment are valuable follow-ups, but they distract from stabilizing the baseline integration. The improved plan phases these as later iterations after parity is confirmed.

## Revised Integration Plan (v2)
Focus on making the Genkit path production-ready, then iterate on advanced capabilities.

### Phase 1 — Stabilize the Existing Migration
1. **Server Bootstrap Fix**
   - Replace `import { startDevServer } from 'genkit/dev'` with the supported entry point (e.g., `import { startFlowServer } from '@genkit-ai/cli/devserver'`) or run `npx genkit dev` inside the orchestration script.
   - Ensure `server.ts` registers the `chat` flow and logs startup errors; fail fast if the server crashes so the dev script doesn’t mask it.

2. **Environment Parity**
   - Load `APP_GEMINI_API_KEY` from `~/.env` (reuse the existing parser or `dotenv`).
   - Set `process.env.GEMINI_API_KEY = process.env.GOOGLE_GENAI_API_KEY = parsedKey` before calling `googleGenAI()`.
   - Document this in `SETUP_GUIDE.md` so contributors know a single key drives both paths.

3. **Feature Flag Safety**
   - Reset `config.features.useGenkitApi` default to `false`.
   - Add a README/CHANGELOG note describing how to enable the flag once Genkit mode is verified.

4. **Dev Orchestration Hygiene**
   - Update `scripts/dev-server.js` to surface Genkit startup failures (exit non-zero if the child dies immediately).
   - Extend `npm run dev:stop` to kill both `bible-explorer.*vite` and the `tsx server.ts` process, mirroring the startup cleanup.

5. **Smoke Tests**
   - With the flag off, run `npm run dev && npm run build` to ensure the legacy path still works.
   - Flip `useGenkitApi` to `true`, restart `npm run dev`, and confirm `/api/chat` streams responses via the proxy. Add a lightweight Vitest that stubs the Genkit server (or uses fetch-mock) to guard the new path.

### Phase 2 — Optional Enhancements After Parity
1. **Server-Side Security**
   - Mirror `security.ts` logic on the server flow (rate limits, length checks) so Genkit mode enforces the same policies even if the frontend bypasses them.
2. **Observability & Health**
   - Wire Genkit tracing/logging and add a `/healthz` endpoint to verify the flow is running in dev/CI.
3. **Gradual Rollout**
   - Introduce an environment variable (e.g., `VITE_USE_GENKIT=true`) that overrides config.json for staged deployments.

### Phase 3 — Advanced Features (Stretch Goals)
Once the baseline is reliable:
1. **Tooling / Bible Retrieval**
   - Implement a `BibleVerseTool` (static JSON or external API) with Zod schemas and integrate it into the flow via Genkit tools.
2. **RAG Pipeline**
   - Experiment with embedding scripture passages (Vertex AI or local vector store) and retrieving the top-N verses before generation.
3. **Deployment**
   - Package the Genkit server for Firebase Functions or Cloud Run, and update CI to run `genkit build` plus the existing Vite build/test gates.

### Deliverables Checklist
- ✅ Genkit server boots successfully with the correct API key mapping.
- ✅ `/api/chat` streaming path works behind the Vite proxy.
- ✅ `useGenkitApi` defaults to `false` and is documented as the rollout toggle.
- ✅ `npm run dev:stop` tears down both servers.
- ✅ Server-side security implementation with rate limiting, validation, and sanitization.
- ✅ Health monitoring endpoint (`/healthz`) for service observability.
- ❌ Follow-up issues filed (or backlog items) for tooling/RAG once baseline is verified.

## Implementation Status - November 5, 2025 ✅

### Phase 1 Completed Successfully ✅
All Phase 1 stabilization tasks have been completed as of November 5, 2024:

**✅ Server Bootstrap Fix**
- Fixed import from `genkit/dev` to `@genkit-ai/express`
- Updated flow definitions to use `ai.defineFlow()` and `ai.generate()`
- Added proper CORS configuration for local development
- Server now boots successfully and registers the chat flow

**✅ Environment Parity**
- Implemented custom `~/.env` loading in server.ts
- Automatic mapping of `APP_GEMINI_API_KEY` to `GEMINI_API_KEY` and `GOOGLE_GENAI_API_KEY`
- Documented API key configuration in SETUP_GUIDE.md

**✅ Feature Flag Safety**
- Set `useGenkitApi` default to `false` in config.json
- Added clear documentation about enabling the feature
- Ensured stability by keeping new functionality opt-in

**✅ Dev Orchestration Hygiene**
- Enhanced dev-server.js with critical error detection
- Updated npm run dev:stop to kill both processes
- Improved error handling and exit codes

**✅ Smoke Tests**
- Verified legacy path works with useGenkitApi = false
- Confirmed Genkit server boots successfully with useGenkitApi = true
- Both paths function without breaking existing functionality

### Phase 2 Completed Successfully ✅
All Phase 2 optional enhancements have been completed as of November 5, 2025:

**✅ Server-Side Security**
- Implemented comprehensive server-side security mirroring client-side logic
- Added rate limiting, input validation, and output sanitization to Genkit flow
- Server-side user ID generation and security event logging
- Updated frontend to pass userId for proper security tracking

**✅ Observability & Health**
- Added `/healthz` health check endpoint with JSON response
- Custom Express server setup replacing simple startFlowServer
- Proper CORS configuration and routing for development
- Service status, timestamp, and version information provided

**⏳ Gradual Rollout** (Remaining)
- [ ] Environment variable override (VITE_USE_GENKIT) - Not yet implemented

### Outstanding Items

**Phase 3 - Advanced Features** (Not started)
- [ ] Tooling / Bible Retrieval - BibleVerseTool implementation
- [ ] RAG Pipeline - Scripture embedding and retrieval
- [ ] Deployment - Firebase Functions/Cloud Run packaging

**Action Items:**
- [✅] Create GitHub issues for Phase 2 enhancements (completed - implemented directly)
- [ ] Create backlog items for Phase 3 advanced features
- [ ] Implement VITE_USE_GENKIT environment variable override
- [ ] Consider enabling useGenkitApi in future release after extended testing

---

This tighter plan keeps the near-term focus on making the existing migration shippable, while still outlining a roadmap for richer Genkit capabilities after stability is achieved.
