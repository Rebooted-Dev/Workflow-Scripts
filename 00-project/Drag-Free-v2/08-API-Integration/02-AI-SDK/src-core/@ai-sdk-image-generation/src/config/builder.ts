/**
 * Configuration builder for the image generation library
 */

import type { ImageGeneratorConfig, ImageProviderConfig } from '../core/types.js';
import { validateConfig } from '../utils/validation.js';

const primaryEnvironmentKeys = [
  'OPENAI_API_KEY',
  'GEMINI_API_KEY',
  'XAI_API_KEY',
  'FAL_API_KEY'
] as const;

const defaultEnvironmentMapping: Record<string, keyof ImageProviderConfig> = {
  // Primary keys (preferred)
  OPENAI_API_KEY: 'openai',
  GEMINI_API_KEY: 'google',
  XAI_API_KEY: 'xai',
  FAL_API_KEY: 'fal',
  // Fallback keys
  APP_OPENAI_API_KEY: 'openai',
  GOOGLE_API_KEY: 'google',
  GROK_API_KEY: 'xai'
};

/**
 * Builder class for creating image generator configurations
 */
export class ImageGeneratorConfigBuilder {
  private config: Partial<ImageGeneratorConfig> = {};

  /**
   * Set API keys for providers
   */
  withApiKeys(apiKeys: ImageProviderConfig): this {
    this.config.apiKeys = { ...this.config.apiKeys, ...apiKeys };
    return this;
  }

  /**
   * Set API key for a specific provider
   */
  withApiKey(provider: keyof ImageProviderConfig, apiKey: string): this {
    if (!this.config.apiKeys) {
      this.config.apiKeys = {};
    }
    this.config.apiKeys[provider] = apiKey;
    return this;
  }

  /**
   * Load API keys from environment variables
   */
  withEnvironmentKeys(mapping?: Record<string, keyof ImageProviderConfig>): this {
    const finalMapping: Record<string, keyof ImageProviderConfig> = {
      ...defaultEnvironmentMapping,
      ...mapping
    };

    // Process primary keys first, then fallbacks (so fallbacks don't override primaries)
    const processedProviders = new Set<keyof ImageProviderConfig>();

    // First pass: primary keys
    primaryEnvironmentKeys.forEach(envVar => {
      const provider = finalMapping[envVar];
      if (provider && process.env[envVar] && !processedProviders.has(provider)) {
        this.withApiKey(provider, process.env[envVar]!);
        processedProviders.add(provider);
      }
    });

    // Second pass: fallback keys (only if primary not set)
    Object.entries(finalMapping).forEach(([envVar, provider]) => {
      if (!primaryEnvironmentKeys.includes(envVar as typeof primaryEnvironmentKeys[number]) && process.env[envVar] && !processedProviders.has(provider)) {
        this.withApiKey(provider, process.env[envVar]!);
        processedProviders.add(provider);
      }
    });

    return this;
  }

  /**
   * Set the default provider
   */
  withDefaultProvider(provider: ImageGeneratorConfig['defaultProvider']): this {
    this.config.defaultProvider = provider;
    return this;
  }

  /**
   * Set the default model
   */
  withDefaultModel(model: string): this {
    this.config.defaultModel = model;
    return this;
  }

  /**
   * Set the default number of images
   */
  withDefaultImageCount(count: number): this {
    this.config.defaultImageCount = count;
    return this;
  }

  /**
   * Set maximum retry attempts
   */
  withMaxRetries(retries: number): this {
    this.config.maxRetries = retries;
    return this;
  }

  /**
   * Set request timeout
   */
  withTimeout(timeoutMs: number): this {
    this.config.timeout = timeoutMs;
    return this;
  }

  /**
   * Enable debug logging
   */
  withDebug(enabled: boolean = true): this {
    this.config.debug = enabled;
    return this;
  }

  /**
   * Merge with existing configuration
   */
  withConfig(config: Partial<ImageGeneratorConfig>): this {
    this.config = {
      ...this.config,
      ...config,
      apiKeys: {
        ...this.config.apiKeys,
        ...config.apiKeys
      }
    };
    return this;
  }

  /**
   * Build the final configuration
   */
  build(): ImageGeneratorConfig {
    const finalConfig: ImageGeneratorConfig = {
      apiKeys: {},
      defaultImageCount: 1,
      maxRetries: 3,
      timeout: 60000,
      debug: false,
      ...this.config
    };

    // Validate the configuration
    const validation = validateConfig(finalConfig);
    if (!validation.success) {
      throw new Error(`Invalid configuration: ${validation.errors.join(', ')}`);
    }

    return finalConfig;
  }
}

/**
 * Create a configuration builder
 */
export function createConfigBuilder(): ImageGeneratorConfigBuilder {
  return new ImageGeneratorConfigBuilder();
}

/**
 * Create a default configuration with environment variables
 */
export function createImageGeneratorConfig(
  options: Partial<ImageGeneratorConfig> = {}
): ImageGeneratorConfig {
  return createConfigBuilder()
    .withConfig(options)
    .withEnvironmentKeys()
    .build();
}

/**
 * Create a configuration from environment variables only
 */
export function createConfigFromEnvironment(): ImageGeneratorConfig {
  return createConfigBuilder()
    .withEnvironmentKeys()
    .build();
}

/**
 * Create a minimal configuration for testing
 */
export function createTestConfig(
  apiKeys: ImageProviderConfig = {},
  options: Partial<ImageGeneratorConfig> = {}
): ImageGeneratorConfig {
  return createConfigBuilder()
    .withApiKeys(apiKeys)
    .withConfig({ debug: true, maxRetries: 0, ...options })
    .build();
}
