# Genkit Integration Plan

This document outlines the steps to integrate Google Genkit into the existing `rbc-bible-explorer` project.

## 1. Install Genkit CLI

The Genkit CLI is required to initialize and manage the Genkit project.

```bash
npm install -g genkit
```

## 2. Initialize Genkit Project

A new Genkit project needs to be initialized in the project's root directory. This will create the necessary configuration files.

```bash
genkit init
```

This will create a `genkit.json` file and a `flows` directory.

## 3. Install Genkit Plugins

The existing project uses `@google/genai`. We will use the Genkit plugin for Google AI.

```bash
npm install @genkit-ai/google-ai
```

We will also need to install the `firebase` plugin to deploy the flows to Firebase.

```bash
npm install @genkit-ai/firebase
```

## 4. Refactor Existing Code

The existing code that uses `@google/genai` will need to be refactored to use Genkit's `generate` function. This will involve:

*   Creating a new flow in the `flows` directory.
*   Initializing the Google AI plugin in the flow.
*   Replacing the direct calls to `@google/genai` with calls to the Genkit flow.

## 5. Update Project Scripts

The `package.json` scripts will need to be updated to include scripts for running the Genkit flows.

```json
"scripts": {
  "dev": "node scripts/dev-server.js",
  "dev:stop": "pkill -f 'bible-explorer.*vite' || true",
  "build": "vite build",
  "preview": "vite preview",
  "test": "vitest",
  "test:run": "vitest run",
  "test:coverage": "vitest run --coverage",
  "flow": "genkit flow:run",
  "flow:deploy": "genkit flow:deploy"
}
```

## 6. Configure Firebase

The project will need to be configured to deploy the Genkit flows to Firebase. This will involve:

*   Creating a new Firebase project.
*   Adding the Firebase project configuration to the Genkit project.
*   Authenticating with Firebase.

---

## Critique of Current Plan
- Global CLI install (`npm install -g genkit`) is brittle for CI and new contributors; prefer local devDependency and `npx`.
- Env/key handling is unspecified. This repo uses `APP_GEMINI_API_KEY` via Vite; the plan should reuse that for Genkit to avoid drift.
- Running two dev servers concurrently is not addressed. We already use `scripts/dev-server.js` for process hygiene; plan should integrate Genkit there or provide a parallel script.
- Proxy config between Vite and Genkit is missing here (covered in the other doc but should be summarized).
- Firebase deployment is optional and out of scope for initial local integration; it can be a phase 2.

## Revised Integration Plan (v2) ✅ COMPLETED

1) ✅ Install and Initialize (local tooling)
- ✅ Add Genkit as a local dependency and use `npx` for commands:
  - ✅ `npm i -D genkit`
  - ✅ `npx genkit init` (creates `genkit.json`, `flows/`)
- ✅ Install Google AI plugin: `npm i @genkit-ai/google-ai`

2) ✅ Environment & Config
- ✅ Reuse `APP_GEMINI_API_KEY` from `~/.env` already wired in `vite.config.ts`.
- ✅ Ensure Genkit reads the same key

3) ✅ Flow Skeleton
- ✅ Create `flows/chat.ts` flow that accepts: `message`, `systemInstruction`, `temperature`, `maxOutputTokens` and returns text. Keep the model name aligned with `config.json` (`gemini-2.5-flash`).

4) ✅ Local Dev Orchestration
- ✅ Option B (integrated): extend `scripts/dev-server.js` to spawn Genkit server before Vite and handle cleanup on exit.

5) ✅ Vite Proxy
- ✅ Add a dev proxy to forward `/api/*` to Genkit (default `http://localhost:3400`) without rewriting paths.

6) ✅ Client Toggle & Rollout
- ✅ Add a feature flag in `config.json`: `features.useGenkitApi: false`.
- ✅ When true, the client calls `POST /api/chat` (streaming) instead of using `@google/genai` directly. Keep a fallback to the current path during rollout.

7) ✅ Security & Testing
- ✅ Mirror server-side validation (length limits) in flow with Zod to match `security.ts` intent.
- ✅ Ensure parity with current UI behavior (streaming and final content).
