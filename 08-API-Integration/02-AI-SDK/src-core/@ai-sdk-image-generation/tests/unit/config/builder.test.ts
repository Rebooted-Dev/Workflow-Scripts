/**
 * Unit tests for configuration builder
 */

import { describe, it, expect, beforeEach, vi } from 'vitest';
import { createConfigBuilder, createImageGeneratorConfig } from '../../../src/config/builder.js';

// Mock process.env for environment variable tests
const originalEnv = process.env;

beforeEach(() => {
  // Reset process.env before each test
  process.env = { ...originalEnv };
  vi.clearAllMocks();
});

afterEach(() => {
  process.env = originalEnv;
});

describe('Configuration Builder', () => {
  describe('createConfigBuilder', () => {
    it('should create a builder instance', () => {
      const builder = createConfigBuilder();
      expect(builder).toBeDefined();
      expect(typeof builder.withApiKeys).toBe('function');
      expect(typeof builder.build).toBe('function');
    });

    it('should build minimal valid config', () => {
      const config = createConfigBuilder().build();

      expect(config).toEqual({
        apiKeys: {},
        defaultImageCount: 1,
        maxRetries: 3,
        timeout: 60000,
        debug: false
      });
    });
  });

  describe('API Key Configuration', () => {
    it('should set API keys via withApiKeys', () => {
      const config = createConfigBuilder()
        .withApiKeys({
          openai: 'sk-test-openai',
          google: 'test-google-key'
        })
        .build();

      expect(config.apiKeys?.openai).toBe('sk-test-openai');
      expect(config.apiKeys?.google).toBe('test-google-key');
    });

    it('should set individual API keys via withApiKey', () => {
      const config = createConfigBuilder()
        .withApiKey('openai', 'sk-test-openai')
        .withApiKey('fal', 'fal-test-key')
        .build();

      expect(config.apiKeys?.openai).toBe('sk-test-openai');
      expect(config.apiKeys?.fal).toBe('fal-test-key');
    });

    it('should merge withApiKeys and withApiKey calls', () => {
      const config = createConfigBuilder()
        .withApiKeys({ openai: 'sk-test' })
        .withApiKey('google', 'google-test')
        .build();

      expect(config.apiKeys?.openai).toBe('sk-test');
      expect(config.apiKeys?.google).toBe('google-test');
    });
  });

  describe('Environment Variable Loading', () => {
    it('should load OpenAI key from environment', () => {
      process.env.OPENAI_API_KEY = 'sk-env-openai';
      process.env.APP_OPENAI_API_KEY = 'sk-app-openai';

      const config = createConfigBuilder()
        .withEnvironmentKeys()
        .build();

      expect(config.apiKeys?.openai).toBe('sk-env-openai');
    });

    it('should prefer OPENAI_API_KEY over APP_OPENAI_API_KEY', () => {
      process.env.OPENAI_API_KEY = 'sk-primary';
      process.env.APP_OPENAI_API_KEY = 'sk-fallback';

      const config = createConfigBuilder()
        .withEnvironmentKeys()
        .build();

      expect(config.apiKeys?.openai).toBe('sk-primary');
    });

    it('should load all provider keys from environment', () => {
      process.env.OPENAI_API_KEY = 'sk-test';
      process.env.GEMINI_API_KEY = 'gemini-test';
      process.env.XAI_API_KEY = 'xai-test';
      process.env.FAL_API_KEY = 'fal-test';
      process.env.OPENROUTER_API_KEY = 'openrouter-test';

      const config = createConfigBuilder()
        .withEnvironmentKeys()
        .build();

      expect(config.apiKeys?.openai).toBe('sk-test');
      expect(config.apiKeys?.google).toBe('gemini-test');
      expect(config.apiKeys?.xai).toBe('xai-test');
      expect(config.apiKeys?.fal).toBe('fal-test');
      expect(config.apiKeys?.openrouter).toBe('openrouter-test');
    });

    it('should handle missing environment variables', () => {
      // No environment variables set
      const config = createConfigBuilder()
        .withEnvironmentKeys()
        .build();

      expect(config.apiKeys).toEqual({});
    });

    it('should allow custom environment variable mapping', () => {
      process.env.CUSTOM_OPENAI_KEY = 'sk-custom';

      const config = createConfigBuilder()
        .withEnvironmentKeys({ CUSTOM_OPENAI_KEY: 'openai' })
        .build();

      expect(config.apiKeys?.openai).toBe('sk-custom');
    });
  });

  describe('Configuration Options', () => {
    it('should set default provider', () => {
      const config = createConfigBuilder()
        .withDefaultProvider('google')
        .build();

      expect(config.defaultProvider).toBe('google');
    });

    it('should set default model', () => {
      const config = createConfigBuilder()
        .withDefaultModel('dall-e-2')
        .build();

      expect(config.defaultModel).toBe('dall-e-2');
    });

    it('should set default image count', () => {
      const config = createConfigBuilder()
        .withDefaultImageCount(3)
        .build();

      expect(config.defaultImageCount).toBe(3);
    });

    it('should set max retries', () => {
      const config = createConfigBuilder()
        .withMaxRetries(5)
        .build();

      expect(config.maxRetries).toBe(5);
    });

    it('should set timeout', () => {
      const config = createConfigBuilder()
        .withTimeout(30000)
        .build();

      expect(config.timeout).toBe(30000);
    });

    it('should enable debug mode', () => {
      const config = createConfigBuilder()
        .withDebug(true)
        .build();

      expect(config.debug).toBe(true);
    });
  });

  describe('Configuration Merging', () => {
    it('should merge with existing config via withConfig', () => {
      const config = createConfigBuilder()
        .withConfig({
          maxRetries: 5,
          timeout: 30000,
          debug: true
        })
        .build();

      expect(config.maxRetries).toBe(5);
      expect(config.timeout).toBe(30000);
      expect(config.debug).toBe(true);
    });

    it('should allow method chaining to override config', () => {
      const config = createConfigBuilder()
        .withConfig({ maxRetries: 5 })
        .withMaxRetries(10)
        .build();

      expect(config.maxRetries).toBe(10);
    });
  });

  describe('Validation', () => {
    it('should throw on invalid provider', () => {
      expect(() => {
        createConfigBuilder()
          .withDefaultProvider('invalid' as any)
          .build();
      }).toThrow();
    });

    it('should throw on negative maxRetries', () => {
      expect(() => {
        createConfigBuilder()
          .withMaxRetries(-1)
          .build();
      }).toThrow();
    });

    it('should throw on zero timeout', () => {
      expect(() => {
        createConfigBuilder()
          .withTimeout(0)
          .build();
      }).toThrow();
    });
  });

  describe('createImageGeneratorConfig', () => {
    it('should create config with environment variables by default', () => {
      process.env.OPENAI_API_KEY = 'sk-env-test';

      const config = createImageGeneratorConfig();

      expect(config.apiKeys?.openai).toBe('sk-env-test');
    });

    it('should merge provided options with environment (env takes precedence)', () => {
      process.env.GEMINI_API_KEY = 'gemini-env';
      process.env.FAL_API_KEY = 'fal-env';

      const config = createImageGeneratorConfig({
        apiKeys: { openai: 'sk-provided' },
        maxRetries: 5
      });

      // Environment variables take precedence over provided options
      expect(config.apiKeys?.google).toBe('gemini-env');
      expect(config.apiKeys?.fal).toBe('fal-env');
      // Provided options that don't conflict are preserved
      expect(config.maxRetries).toBe(5);
    });
  });
});
