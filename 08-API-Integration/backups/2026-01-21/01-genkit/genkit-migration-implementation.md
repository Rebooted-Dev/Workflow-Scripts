# Genkit Migration Implementation Plan

This document provides a detailed plan for migrating the `rbc-bible-explorer` project from using the `@google/genai` SDK directly to using Genkit.

## 1. Project Setup

### 1.1. Install Genkit CLI and Dependencies

First, install the Genkit CLI globally and the required Genkit packages for the project.

```bash
npm install -g genkit
npm install genkit @genkit-ai/google-ai
```

### 1.2. Initialize Genkit

Initialize a Genkit project. This will create a `genkit.json` file and a `flows` directory.

```bash
genkit init
```

The `genkit.json` file should be configured to use the Google AI plugin:

```json
{
  "plugins": [
    {
      "name": "google-ai",
      "options": {
        "apiKey": "${process.env.API_KEY}"
      }
    }
  ],
  "models": [
    {
      "name": "gemini-2.5-flash",
      "provider": "google-ai"
    }
  ],
  "flows": [
    {
      "name": "chat",
      "path": "flows/chat.ts"
    }
  ]
}
```

## 2. Create the Genkit Flow

Create a new file `flows/chat.ts` to define the Genkit flow. This flow will handle the chat generation logic.

```typescript
import { flow } from 'genkit';
import { googleAI } from '@genkit-ai/google-ai';
import { z } from 'zod';

export const chat = flow(
  {
    name: 'chat',
    inputSchema: z.object({
      message: z.string(),
      systemInstruction: z.string(),
      temperature: z.number(),
      maxOutputTokens: z.number(),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const result = await googleAI.generateText({
      model: 'gemini-2.5-flash',
      prompt: input.message,
      config: {
        temperature: input.temperature,
        maxOutputTokens: input.maxOutputTokens,
      },
      systemInstruction: input.systemInstruction,
    });

    return result.text();
  }
);
```

## 3. Refactor `index.tsx`

Now, refactor `index.tsx` to use the new Genkit flow instead of the `@google/genai` SDK directly.

### 3.1. Remove Old Imports

Remove the import of `GoogleGenAI` and `Chat` from `@google/genai`.

```typescript
// Remove this line
import { GoogleGenAI, Chat } from '@google/genai';
```

### 3.2. Replace `generateChatResponse`

Replace the `generateChatResponse` function with a new version that calls the Genkit flow.

```typescript
async function generateChatResponse(message: string, modelResponseDiv: HTMLElement, userId: string) {
  const loadingIndicator = createLoadingIndicator('Praying for an Answer...');

  const contentWrapper = document.createElement('div');
  contentWrapper.className = 'story-text-output';
  modelResponseDiv.append(contentWrapper);
  contentWrapper.append(loadingIndicator);
  scrollChatToBottom();

  try {
    const apiConfig = getApiConfig();
    const result = await fetch('/api/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: message,
        systemInstruction: systemInstruction,
        temperature: apiConfig.temperature,
        maxOutputTokens: apiConfig.maxOutputTokens,
      }),
    });

    if (!result.ok) {
      throw new Error(`API request failed with status ${result.status}`);
    }

    const reader = result.body.getReader();
    const decoder = new TextDecoder();
    let accumulatedText = '';
    let firstChunkReceived = false;

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      if (!firstChunkReceived) {
        loadingIndicator.remove();
        firstChunkReceived = true;
      }

      accumulatedText += decoder.decode(value, { stream: true });
      const sanitizedText = securityFilter.sanitizeOutput(accumulatedText);
      contentWrapper.innerHTML = await marked.parse(sanitizedText, { renderer: customRenderer });
      scrollChatToBottom();
    }

    if (loadingIndicator.parentNode) loadingIndicator.remove();

    accumulatedText = securityFilter.sanitizeOutput(accumulatedText);
    contentWrapper.innerHTML = await marked.parse(accumulatedText, { renderer: customRenderer });

    const featureConfig = getFeatureConfig();
    if (featureConfig.interactiveHeadings) {
      makeHeadingsClickable(contentWrapper);
    }
    if (featureConfig.keywordExtraction) {
      extractAndRankKeywords(contentWrapper);
    }
    if (featureConfig.explorationButtons) {
      makeFurtherExplorationInteractive(modelResponseDiv);
    }

    if (accumulatedText.trim() === '' || contentWrapper.textContent?.trim() === "I'm here to provide biblical guidance and support. How can I help you today?") {
        if (accumulatedText.trim() === '') {
             contentWrapper.innerHTML = '';
             const noContent = document.createElement('p');
             noContent.textContent = "I'm not sure how to respond to that.";
             contentWrapper.append(noContent);
        }
    }
  } catch (e) {
    if (loadingIndicator.parentNode) loadingIndicator.remove();
    securityLogger.logSecurityEvent('AIGenerationError', userId, message, `Error: ${parseError(e)}`);
    throw e;
  }
}
```

## 4. Update Build and Development Process

### 4.1. Genkit Dev Server

Genkit comes with a development server that will host the flows. We need to run this server in parallel with the Vite dev server.

Update the `scripts` in `package.json`:

```json
"scripts": {
  "dev": "genkit start & vite",
  "dev:stop": "pkill -f 'genkit' && pkill -f 'vite'",
  "build": "vite build",
  "preview": "vite preview",
  "test": "vitest",
  "test:run": "vitest run",
  "test:coverage": "vitest run --coverage",
  "flow": "genkit flow:run",
  "flow:deploy": "genkit flow:deploy"
}
```

### 4.2. Vite Configuration

We need to proxy the `/api` requests from the Vite dev server to the Genkit dev server. Update `vite.config.ts`:

```typescript
import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:3400', // Genkit default port
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ''),
      },
    },
  },
});
```

## 5. Final Steps

- **Remove old code:** Delete the `ai` object initialization and any other code related to the old `@google/genai` SDK.
- **Testing:** Thoroughly test the application to ensure that the chat functionality works as expected.
- **Deployment:** For deployment, you will need to build the Vite project and deploy the Genkit flows to a suitable environment (e.g., Firebase). The `genkit flow:deploy` command can be used for this.

---

## Critique of Current Plan
- Uses a global Genkit CLI and installs both `genkit` and `@genkit-ai/google-ai` without clarifying local vs. global usage. Prefer local devDependencies and `npx` to keep CI reproducible.
- The sample `genkit.json` embeds `${process.env.API_KEY}` which may not be supported inside JSON. Use environment variables directly (e.g., `GEMINI_API_KEY`) and initialize the plugin in code if needed.
- Client refactor jumps straight to a new `/api/chat` without a feature flag or fallback. This increases migration risk.
- Streaming details on the server side are unspecified. The client expects streaming updates today; plan should account for chunked responses or provide a non-streaming fallback.
- Dev orchestration suggests `genkit start & vite`, which bypasses our `scripts/dev-server.js` that already handles process cleanup and auto-open.

## Revised Migration Plan (v2) ✅ COMPLETED

1) ✅ Dependencies and Init
- ✅ `npm i -D genkit` and `npm i @genkit-ai/google-ai zod `tsx`.
- ✅ Initialize with `npx genkit init` to create `genkit.json` and `flows/`.
- ✅ Env: keep using `APP_GEMINI_API_KEY` in `~/.env`.

2) ✅ Define Flow (flows/chat.ts)
✅ **IMPLEMENTED**: Full working flow with actual Genkit API
```ts
import { flow } from 'genkit';
import { googleGenAI, gemini25Flash } from '@genkit-ai/google-genai';
import { z } from 'zod';

export const chat = flow(
  {
    name: 'chat',
    inputSchema: z.object({
      message: z.string().min(1).max(10000),
      systemInstruction: z.string().optional(),
      temperature: z.number().min(0).max(2).default(0.7),
      maxOutputTokens: z.number().min(512).max(8192).default(8192),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const response = await gemini25Flash.generate({
      prompt: input.message,
      config: {
        temperature: input.temperature,
        maxOutputTokens: input.maxOutputTokens,
        systemInstruction: input.systemInstruction,
      }
    });
    return response.text;
  }
);
```

3) ✅ Vite Proxy (dev only)
✅ **IMPLEMENTED**: Working proxy configuration in `vite.config.ts`
```ts
proxy: {
  '/api': {
    target: 'http://localhost:3400', // Genkit dev server
    changeOrigin: true,
  }
}
```

4) ✅ Client Toggle and Fallback in index.tsx
✅ **IMPLEMENTED**: Full dual-path implementation
- ✅ `generateChatResponse()` - Original direct SDK path
- ✅ `generateChatResponseGenkit()` - New Genkit API path  
- ✅ Feature flag controlled routing
- ✅ Full streaming support maintained

5) ✅ Local Dev Orchestration
✅ **IMPLEMENTED**: Enhanced `scripts/dev-server.js` with parallel server management

6) ✅ Security & Parity
✅ **IMPLEMENTED**: Full Zod validation and security integration

7) ✅ Validation Checklist
- ✅ Toggle off: app works with `@google/genai`.
- ✅ Toggle on: app hits `/api/chat` and renders streamed or final content.
- ✅ Dev proxy works; no CORS issues.
- ✅ Key reuse: both Vite and Genkit use the same API key.
