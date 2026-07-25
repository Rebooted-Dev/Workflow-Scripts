# Updated model IDs — suite impact audit

**Date:** 2026-07-24  
**Status:** Research / flags only (no code changes applied yet)  
**Source:** Vendor sample snippets (Google GenAI + xAI Responses API), filed below under [Source snippets](#source-snippets).

## Summary

Three model IDs appear in vendor samples and should be considered for adoption across RBC-Suite sub-projects:

| New / updated ID | Provider | Notes |
|------------------|----------|--------|
| `gemini-3.1-flash-lite` | Google | No `-preview` suffix in sample (suite currently uses `…-preview` in Batch Translator) |
| `gemini-3.5-flash-lite` | Google | New lite tier; suite has `gemini-3.5-flash` in Batch Translator but **not** this lite ID |
| `grok-4.5` | xAI | Suite still on `grok-4.3` (Nu-Meta, Batch Translator) |

**Before shipping renames:** confirm exact live API strings (Google list-models / xAI docs). Do not assume `-preview` can be dropped until verified.

---

## Mapping: research → current suite usage

| Research ID | Batch Translator | Nu-Meta | SRT Studio | yt-updater |
|-------------|------------------|---------|------------|------------|
| `gemini-3.1-flash-lite` | Has **`gemini-3.1-flash-lite-preview`** only | — (no Gemini) | — | — |
| `gemini-3.5-flash-lite` | Has **`gemini-3.5-flash`**, not lite | — | — | — |
| `grok-4.5` | Has **`grok-4.3`** only | Has **`grok-4.3`** only | — | — |

---

## Per-project audit

### 1. RBC SRT Batch Translator — highest impact

**Root:** `rbc-srt-batch-translator-(New UI)-0.5/rbc-srt-batch-translator-codebase/`

| Current ID | Status vs research |
|------------|--------------------|
| `gemini-3.1-flash-lite-preview` | **Rename candidate** → `gemini-3.1-flash-lite` (if GA without `-preview`) |
| `gemini-3.5-flash` | Present; research also adds **`gemini-3.5-flash-lite`** (not listed) |
| `gemini-3-flash-preview` | Unchanged by this note |
| `grok-4.3` | **Add / replace candidate** → `grok-4.5` |
| `gemini-2.0-flash` | Already disabled / deprecated in config |

**Key files:**

| File | Role |
|------|------|
| `src/config/app-config.json` | Defaults, model catalog, correction/translation selectors |
| `src/config/constants.ts` | `SUPPORTED_MODELS`, `DEFAULT_MODEL`, `CORRECTION_MODEL`, chunk helpers keyed to `gemini-3.1-flash-lite-preview` |
| `src/services/api-service.ts` | Exact-ID checks, fallbacks, max tokens |
| `src/services/provider-router.ts` | Concurrency limits by model family |
| `src/services/cache-manager.ts`, `explicit-cache-probe.ts` | Default model strings |
| Tests under `src/test/*` | Many hardcode `gemini-3.1-flash-lite-preview` / `grok-4.3` |

**Suggested actions:**

1. Confirm whether Google GA’d `gemini-3.1-flash-lite` (without `-preview`). If yes, rename defaults + catalog + exact-match helpers; keep a short alias for saved UI prefs if needed.
2. Add `gemini-3.5-flash-lite` to catalog + selectors (and chunk/rate-limit rules if it behaves like 3.1 lite).
3. Add `grok-4.5` (decide whether to keep or deprecate `grok-4.3`).
4. Sweep hardcoded defaults/tests so fallbacks don’t still point only at `-preview` / 4.3.

**Implementation note:** Prefer substring family checks (`includes('gemini-3.1-flash-lite')`) or a small alias map so exact `=== '…-preview'` checks do not miss the new slug.

---

### 2. Nu-Meta — xAI only for this note

**Root:** `Nu-Meta/Nu-Meta-codebase/`

| Location | Current | Action |
|----------|---------|--------|
| `src/config/ai-provider.ts` | `xai: ['grok-4.3']`, OpenRouter `x-ai/grok-4.3` | Add `grok-4.5` / `x-ai/grok-4.5` (confirm OpenRouter slug) |
| `src/config/__tests__/ai-provider.test.ts` | Asserts sole `grok-4.3` | Update expectations |
| `Nu-Meta/docs/configuration.md` | Documents `grok-4.3` as sole xAI model | Update after code |

No Gemini provider in Nu-Meta (Anthropic / xAI / OpenRouter). **`gemini-3.1-flash-lite` / `gemini-3.5-flash-lite` do not apply** unless a Google provider is added later.

---

### 3. SRT Studio — single hard-coded Gemini

**Root:** `SRT-Studio-New-UI/`

| Location | Current | Gap |
|----------|---------|-----|
| `constants.ts` → `MODEL_NAME` | `gemini-3-flash-preview` | Not on research list; opportunity to move to `gemini-3.1-flash-lite` or `gemini-3.5-flash-lite` |
| `api-service.ts` | Uses `MODEL_NAME` for all AI calls | No model picker |
| `docs/SYSTEM_ARCHITECTURE.md` | Still mentions `gemini-2.5-flash` | Docs drift |

**Suggested actions:** Update `MODEL_NAME` after choosing a production default; optionally add a small model list later. Align architecture docs with code.

---

### 4. YT Apps (yt-updater) — stale Gemini default

**Root:** `YT Apps/yt-updater/`

| Location | Current | Action |
|----------|---------|--------|
| `src/ai/genkit.ts` | `googleai/gemini-2.0-flash` | Point at a current ID (e.g. `googleai/gemini-3.1-flash-lite` or suite-standard Flash), then smoke-test Genkit flows |

No Grok unless xAI is added later.

---

### 5. Shared deps / image libs — out of scope

`dependencies/Rebooted-Core-Libraries/` (image-gen catalogs: Higgsfield, FAL, ZAI) has no Gemini/Grok chat model lists. **No change required** for these three IDs.

---

## Priority matrix

| Priority | Project | Action |
|----------|---------|--------|
| **P0** | Batch Translator | Rename/alias `gemini-3.1-flash-lite-preview` → `gemini-3.1-flash-lite` if GA; update defaults, selectors, exact-match logic, tests |
| **P0** | Batch Translator | Add `gemini-3.5-flash-lite` + `grok-4.5` to `app-config.json` / constants / routing |
| **P1** | Nu-Meta | Add `grok-4.5` (+ OpenRouter `x-ai/grok-4.5`); decide fate of `grok-4.3` |
| **P1** | SRT Studio | Replace or re-evaluate hard-coded `gemini-3-flash-preview` |
| **P2** | yt-updater | Replace `googleai/gemini-2.0-flash` with a current Gemini ID |
| **P3** | Docs | Per-project changelogs / config docs after code lands |

---

## Source snippets

Raw vendor samples that introduced the IDs (kept for reference).

### Google — `gemini-3.1-flash-lite`

```ts
// npm install @google/genai mime
// npm install -D @types/node

import {
  GoogleGenAI,
} from '@google/genai';

async function main() {
  const ai = new GoogleGenAI({
    apiKey: process.env['GEMINI_API_KEY'],
  });
  const config = {
    thinkingConfig: {
      thinkingLevel: ThinkingLevel.MINIMAL,
    },
  };
  const model = 'gemini-3.1-flash-lite';
  const contents = [
    {
      role: 'user',
      parts: [
        {
          text: `INSERT_INPUT_HERE`,
        },
      ],
    },
  ];

  const response = await ai.models.generateContentStream({
    model,
    config,
    contents,
  });
  let fileIndex = 0;
  for await (const chunk of response) {
    if (chunk.text) {
      console.log(chunk.text);
    }
  }
}

main();
```

### Google — `gemini-3.5-flash-lite`

```ts
// npm install @google/genai mime
// npm install -D @types/node

import {
  GoogleGenAI,
} from '@google/genai';

async function main() {
  const ai = new GoogleGenAI({
    apiKey: process.env['GEMINI_API_KEY'],
  });
  const config = {
    thinkingConfig: {
      thinkingLevel: ThinkingLevel.MINIMAL,
    },
  };
  const model = 'gemini-3.5-flash-lite';
  const contents = [
    {
      role: 'user',
      parts: [
        {
          text: `INSERT_INPUT_HERE`,
        },
      ],
    },
  ];

  const response = await ai.models.generateContentStream({
    model,
    config,
    contents,
  });
  let fileIndex = 0;
  for await (const chunk of response) {
    if (chunk.text) {
      console.log(chunk.text);
    }
  }
}

main();
```

### xAI — `grok-4.5`

```bash
curl https://api.x.ai/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XAI_API_KEY" \
  -d '{
  "model": "grok-4.5",
  "max_output_tokens": 500000,
  "reasoning": {
    "effort": "low"
  },
  "stream": true,
  "input": "Your message here"
}'
```
