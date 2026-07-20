import { afterAll } from 'vitest';

const apiKeyVariables = [
  'OPENAI_API_KEY',
  'APP_OPENAI_API_KEY',
  'GEMINI_API_KEY',
  'GOOGLE_API_KEY',
  'XAI_API_KEY',
  'GROK_API_KEY',
  'FAL_API_KEY',
] as const;

const originalValues = new Map(
  apiKeyVariables.map((name) => [name, process.env[name]]),
);

// Unit tests must never inherit developer credentials or print them in assertion diffs.
for (const name of apiKeyVariables) {
  delete process.env[name];
}

afterAll(() => {
  for (const [name, value] of originalValues) {
    if (value === undefined) {
      delete process.env[name];
    } else {
      process.env[name] = value;
    }
  }
});
