/**
 * Unit tests for OpenAI provider request adaptation
 */

import { describe, it, expect } from 'vitest';
import { stripOpenAIImageResponseFormat } from '../../../src/providers/openai.js';

describe('OpenAI Provider', () => {
  describe('stripOpenAIImageResponseFormat', () => {
    it('should strip response_format from OpenAI image generation JSON requests', () => {
      const init = {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          model: 'gpt-image-1',
          prompt: 'A cat',
          response_format: 'b64_json',
        }),
      };

      const rewritten = stripOpenAIImageResponseFormat('https://api.openai.com/v1/images/generations', init);

      expect(rewritten).not.toBe(init);
      expect(JSON.parse(rewritten!.body as string)).toEqual({
        model: 'gpt-image-1',
        prompt: 'A cat',
      });
    });

    it('should leave non-image requests unchanged', () => {
      const init = {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ response_format: 'json_object' }),
      };

      const rewritten = stripOpenAIImageResponseFormat('https://api.openai.com/v1/chat/completions', init);

      expect(rewritten).toBe(init);
    });

    it('should leave non-JSON image requests unchanged', () => {
      const init = {
        method: 'POST',
        headers: { 'content-type': 'text/plain' },
        body: 'response_format=b64_json',
      };

      const rewritten = stripOpenAIImageResponseFormat('https://api.openai.com/v1/images/generations', init);

      expect(rewritten).toBe(init);
    });
  });
});
