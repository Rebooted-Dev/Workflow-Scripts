/**
 * Unit tests for ImageGenerator class
 */

import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { ImageGenerator, ImageGenerationError } from '../../../src/core/generator.js';
import { registry } from '../../../src/core/registry.js';

// Mock the AI SDK
vi.mock('ai', () => ({
  generateImage: vi.fn()
}));

import { generateImage as mockGenerateImage } from 'ai';
import { createProviderManager as mockCreateProviderManager } from '../../../src/providers/factory.js';

// Mock providers
vi.mock('../../../src/providers/factory.js', () => ({
  getProviderManager: vi.fn(() => ({
    getProvider: vi.fn(() => ({
      isConfigured: vi.fn(() => true),
      validateParameters: vi.fn(),
      getModel: vi.fn(() => ({ model: 'mock-model' }))
    })),
    isProviderConfigured: vi.fn(() => true),
    validateProviderParameters: vi.fn(),
    getConfiguredProviders: vi.fn(() => ['openai'])
  })),
  createProviderManager: vi.fn(() => ({
    getProvider: vi.fn(() => ({
      isConfigured: vi.fn(() => true),
      validateParameters: vi.fn(),
      getModel: vi.fn(() => ({ model: 'mock-model' }))
    })),
    isProviderConfigured: vi.fn(() => true),
    validateProviderParameters: vi.fn(),
    getConfiguredProviders: vi.fn(() => ['openai'])
  }))
}));

describe('ImageGenerator', () => {
  let generator: ImageGenerator;

  beforeEach(() => {
    vi.clearAllMocks();
    generator = new ImageGenerator({
      apiKeys: { openai: 'test-key' },
      debug: false
    });
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  describe('constructor', () => {
    it('should create instance with valid config', () => {
      const config = { apiKeys: { openai: 'test' } };
      const gen = new ImageGenerator(config);
      expect(gen).toBeInstanceOf(ImageGenerator);
    });

    it('should throw on invalid config', () => {
      expect(() => {
        new ImageGenerator({ invalid: 'config' } as any);
      }).toThrow();
    });
  });

  describe('generate', () => {
    const validRequest = {
      prompt: 'A beautiful sunset',
      provider: 'openai' as const,
      modelId: 'dall-e-3'
    };

    beforeEach(() => {
      mockGenerateImage.mockResolvedValue({
        images: [{ base64: 'mock-base64-image' }],
        warnings: [],
        providerMetadata: {}
      });
    });

    it('should generate image successfully', async () => {
      const result = await generator.generate(validRequest);

      expect(result).toMatchObject({
        images: ['mock-base64-image'],
        warnings: [],
        provider: 'openai',
        model: 'dall-e-3'
      });

      expect(mockGenerateImage).toHaveBeenCalledWith({
        model: { model: 'mock-model' },
        prompt: 'A beautiful sunset',
        n: 1,
        size: '1024x1024'
      });
    });

    it('should handle provider-specific parameters', async () => {
      const requestWithSize = {
        ...validRequest,
        size: '1024x1024'
      };

      await generator.generate(requestWithSize);

      expect(mockGenerateImage).toHaveBeenCalledWith({
        model: { model: 'mock-model' },
        prompt: 'A beautiful sunset',
        n: 1,
        size: '1024x1024'
      });
    });

    it('should handle Google aspect ratio parameters', async () => {
      const googleRequest = {
        prompt: 'A landscape',
        provider: 'google' as const,
        modelId: 'imagen-3.0-generate-002',
        aspectRatio: '16:9'
      };

      await generator.generate(googleRequest);

      expect(mockGenerateImage).toHaveBeenCalledWith({
        model: { model: 'mock-model' },
        prompt: 'A landscape',
        n: 1,
        aspectRatio: '16:9'
      });
    });

    it('should apply default values', async () => {
      const minimalRequest = {
        prompt: 'A cat'
      };

      await generator.generate(minimalRequest);

      expect(mockGenerateImage).toHaveBeenCalledWith({
        model: { model: 'mock-model' },
        prompt: 'A cat',
        n: 1,
        size: '1024x1024'
      });
    });

    it('should clamp image count to maximum', async () => {
      const requestWithHighCount = {
        prompt: 'Multiple images',
        n: 10 // Should be clamped
      };

      await generator.generate(requestWithHighCount);

      expect(mockGenerateImage).toHaveBeenCalledWith({
        model: { model: 'mock-model' },
        prompt: 'Multiple images',
        n: 1, // Default max is 1 for most models
        size: '1024x1024'
      });
    });

    it('should handle provider not configured error', async () => {
      mockCreateProviderManager.mockReturnValueOnce({
        getProvider: vi.fn(() => ({
          isConfigured: vi.fn(() => false),
          validateParameters: vi.fn(),
          getModel: vi.fn()
        })),
        isProviderConfigured: vi.fn(() => false),
        validateProviderParameters: vi.fn()
      });

      const unconfiguredGenerator = new ImageGenerator({
        apiKeys: { openai: 'test-key' },
        debug: false
      });

      await expect(unconfiguredGenerator.generate(validRequest)).rejects.toThrow(ImageGenerationError);
      expect(mockGenerateImage).not.toHaveBeenCalled();
    });

    it('should handle unsupported provider', async () => {
      const requestWithInvalidProvider = {
        prompt: 'Test',
        provider: 'invalid' as any
      };

      await expect(generator.generate(requestWithInvalidProvider)).rejects.toThrow(ImageGenerationError);
    });

    it('should handle AI SDK errors', async () => {
      mockGenerateImage.mockRejectedValue(new Error('AI SDK Error'));

      const noRetryGenerator = new ImageGenerator({
        apiKeys: { openai: 'test-key' },
        debug: false,
        maxRetries: 0
      });

      await expect(noRetryGenerator.generate(validRequest)).rejects.toThrow(ImageGenerationError);
    });

    it('should include warnings in result', async () => {
      mockGenerateImage.mockResolvedValueOnce({
        images: [{ base64: 'image-data' }],
        warnings: ['Low quality image'],
        providerMetadata: { test: 'data' }
      });

      const result = await generator.generate(validRequest);

      expect(result.warnings).toEqual(['Low quality image']);
      expect(result.providerMetadata).toEqual({ test: 'data' });
    });

    it('should pass through abort signal', async () => {
      const abortController = new AbortController();
      const requestWithAbort = {
        ...validRequest,
        abortSignal: abortController.signal
      };

      await generator.generate(requestWithAbort);

      const callArgs = mockGenerateImage.mock.calls[0][0];
      expect(callArgs.abortSignal).toBe(abortController.signal);
    });

    it('should pass through custom headers', async () => {
      const requestWithHeaders = {
        ...validRequest,
        headers: { 'X-Custom': 'value' }
      };

      await generator.generate(requestWithHeaders);

      const callArgs = mockGenerateImage.mock.calls[0][0];
      expect(callArgs.headers).toEqual({ 'X-Custom': 'value' });
    });

    it('should pass through provider options', async () => {
      const requestWithOptions = {
        ...validRequest,
        providerOptions: { openai: { style: 'vivid' } }
      };

      await generator.generate(requestWithOptions);

      const callArgs = mockGenerateImage.mock.calls[0][0];
      expect(callArgs.providerOptions).toEqual({ openai: { style: 'vivid' } });
    });

    it('should handle seed parameter', async () => {
      const requestWithSeed = {
        ...validRequest,
        seed: 12345
      };

      await generator.generate(requestWithSeed);

      const callArgs = mockGenerateImage.mock.calls[0][0];
      expect(callArgs.seed).toBe(12345);
    });
  });
});
