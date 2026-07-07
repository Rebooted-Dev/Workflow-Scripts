/**
 * Unit tests for validation utilities
 */

import { describe, it, expect } from 'vitest';
import {
  validateImageRequest,
  validateAndNormalizeRequest,
  validateConfig,
  isValidProviderId
} from '../../../src/utils/validation.js';

describe('Validation Utilities', () => {
  describe('validateImageRequest', () => {
    it('should validate valid request', () => {
      const validRequest = {
        prompt: 'A beautiful landscape',
        provider: 'openai' as const,
        modelId: 'dall-e-3',
        size: '1024x1024',
        n: 2
      };

      const result = validateImageRequest(validRequest);

      expect(result.success).toBe(true);
      expect(result.data).toEqual(validRequest);
    });

    it('should validate minimal valid request', () => {
      const minimalRequest = {
        prompt: 'A cat'
      };

      const result = validateImageRequest(minimalRequest);

      expect(result.success).toBe(true);
      expect(result.data.prompt).toBe('A cat');
      expect(result.data.n).toBe(1); // Default value
    });

    it('should reject request without prompt', () => {
      const invalidRequest = {
        provider: 'openai' as const
      };

      const result = validateImageRequest(invalidRequest);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('prompt: Invalid input: expected string, received undefined');
    });

    it('should reject empty prompt', () => {
      const invalidRequest = {
        prompt: '',
        provider: 'openai' as const
      };

      const result = validateImageRequest(invalidRequest);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('prompt: Prompt is required and cannot be empty');
    });

    it('should reject invalid provider', () => {
      const invalidRequest = {
        prompt: 'Test',
        provider: 'invalid' as any
      };

      const result = validateImageRequest(invalidRequest);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('provider: Invalid option: expected one of "openai"|"google"|"xai"|"fal"');
    });

    it('should reject invalid image count', () => {
      const invalidRequest = {
        prompt: 'Test',
        n: -1
      };

      const result = validateImageRequest(invalidRequest);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('n: Too small: expected number to be >0');
    });

    it('should reject too many images', () => {
      const invalidRequest = {
        prompt: 'Test',
        n: 20 // Over the max of 10
      };

      const result = validateImageRequest(invalidRequest);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('n: Too big: expected number to be <=10');
    });
  });

  describe('validateAndNormalizeRequest', () => {
    it('should normalize valid request with defaults', () => {
      const request = {
        prompt: 'A sunset'
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(true);
      if (result.success) {
        expect(result.data.prompt).toBe('A sunset');
        expect(result.data.provider).toBe('openai'); // Default provider
        expect(result.data.modelId).toBe('gpt-image-1'); // Default OpenAI model
        expect(result.data.n).toBe(1);
      }
    });

    it('should preserve explicit provider and model', () => {
      const request = {
        prompt: 'A landscape',
        provider: 'google' as const,
        modelId: 'imagen-3.0-generate-002'
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(true);
      if (result.success) {
        expect(result.data.provider).toBe('google');
        expect(result.data.modelId).toBe('imagen-3.0-generate-002');
      }
    });

    it('should apply model-specific defaults', () => {
      const request = {
        prompt: 'A portrait',
        provider: 'openai' as const,
        modelId: 'dall-e-3'
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(true);
      if (result.success) {
        expect(result.data.size).toBe('1024x1024'); // Default for DALL-E 3
      }
    });

    it('should validate parameter compatibility', () => {
      const request = {
        prompt: 'Test',
        provider: 'openai' as const,
        modelId: 'dall-e-3',
        size: '1024x1024' // Valid size for DALL-E 3
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(true);
    });

    it('should reject incompatible parameters', () => {
      const request = {
        prompt: 'Test',
        provider: 'openai' as const,
        modelId: 'dall-e-3',
        size: 'invalid-size'
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('Size invalid-size not supported by model dall-e-3');
    });

    it('should reject unsupported provider', () => {
      const request = {
        prompt: 'Test',
        provider: 'unsupported' as any
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('provider: Invalid option: expected one of "openai"|"google"|"xai"|"fal"');
    });

    it('should reject OpenRouter for image generation', () => {
      const request = {
        prompt: 'Test',
        provider: 'openrouter' as any
      };

      const result = validateAndNormalizeRequest(request);

      expect(result.success).toBe(false);
      expect(result.errors).toContain('provider: Invalid option: expected one of "openai"|"google"|"xai"|"fal"');
    });
  });

  describe('validateConfig', () => {
    it('should validate valid config', async () => {
      const validConfig = {
        apiKeys: {
          openai: 'sk-test-key'
        },
        defaultProvider: 'openai' as const,
        maxRetries: 3,
        timeout: 60000
      };

      // Test through config builder which validates internally
      const { createImageGeneratorConfig } = await import('../../../src/config/builder.js');
      const result = createImageGeneratorConfig(validConfig);

      expect(result.apiKeys?.openai).toBe('sk-test-key');
      expect(result.defaultProvider).toBe('openai');
      expect(result.maxRetries).toBe(3);
      expect(result.timeout).toBe(60000);
      expect(result.debug).toBe(false); // Default value added
    });

    it('should apply defaults to minimal config', async () => {
      const { createImageGeneratorConfig } = await import('../../../src/config/builder.js');
      const result = createImageGeneratorConfig({});

      expect(result.maxRetries).toBe(3);
      expect(result.timeout).toBe(60000);
      expect(result.debug).toBe(false);
    });

    it('should reject invalid config', async () => {
      const { createImageGeneratorConfig } = await import('../../../src/config/builder.js');

      expect(() => {
        createImageGeneratorConfig({ maxRetries: -1 });
      }).toThrow();
    });
  });

  describe('isValidProviderId', () => {
    it('should return true for valid providers', () => {
      expect(isValidProviderId('openai')).toBe(true);
      expect(isValidProviderId('google')).toBe(true);
      expect(isValidProviderId('xai')).toBe(true);
      expect(isValidProviderId('fal')).toBe(true);
    });

    it('should return false for invalid providers', () => {
      expect(isValidProviderId('invalid')).toBe(false);
      expect(isValidProviderId('')).toBe(false);
      expect(isValidProviderId('openai-invalid')).toBe(false);
    });
  });
});
