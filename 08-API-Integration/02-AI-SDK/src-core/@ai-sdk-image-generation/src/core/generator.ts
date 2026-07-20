/**
 * Main image generator class
 */

import { generateImage } from 'ai';
import type {
  ImageGenerationRequest,
  ImageGenerationResult,
  ImageGeneratorConfig
} from './types.js';
import { ImageGenerationError } from './types.js';
import { registry } from './registry.js';
import { validateAndNormalizeRequest, validateConfig } from '../utils/validation.js';
import { withRetryAndTimeout, createRateLimitRetryPolicy } from '../utils/retry.js';
import { createProviderManager } from '../providers/factory.js';

/**
 * Main image generator class
 */
export class ImageGenerator {
  private config: ImageGeneratorConfig;
  private providerManager: any;

  constructor(config: ImageGeneratorConfig) {
    const validation = validateConfig(config);
    if (!validation.success) {
      throw new Error(`Invalid configuration: ${validation.errors.join(', ')}`);
    }

    this.config = config;
    // Create a dedicated provider manager for this generator instance
    // to avoid issues with the global singleton
    this.providerManager = createProviderManager(config.apiKeys);
  }

  /**
   * Generate images based on a request
   */
  async generate(request: ImageGenerationRequest): Promise<ImageGenerationResult> {
    const startTime = Date.now();

    try {
      // Validate and normalize the request
      const validation = validateAndNormalizeRequest(request);
      if (!validation.success) {
        throw new ImageGenerationError(
          `Invalid request: ${validation.errors.join(', ')}`,
          'INVALID_REQUEST',
          { retryable: false, context: { errors: validation.errors } }
        );
      }

      const normalizedRequest = validation.data;


      // Check if provider is configured
      if (!this.providerManager.isProviderConfigured(normalizedRequest.provider!)) {
        throw new ImageGenerationError(
          `Provider ${normalizedRequest.provider} is not configured`,
          'PROVIDER_NOT_CONFIGURED',
          { provider: normalizedRequest.provider, retryable: false }
        );
      }

      // Validate provider parameters
      this.providerManager.validateProviderParameters(
        normalizedRequest.provider!,
        normalizedRequest
      );

      this.logInfo(`Starting image generation`, {
        provider: normalizedRequest.provider,
        model: normalizedRequest.modelId,
        promptLength: normalizedRequest.prompt.length,
        imageCount: normalizedRequest.n
      });

      // Generate images with retry logic
      const result = await this.performGeneration(normalizedRequest);

      const duration = Date.now() - startTime;
      this.logInfo(`Image generation completed`, {
        provider: result.provider,
        model: result.model,
        imageCount: result.images.length,
        durationMs: duration,
        retryCount: result.retryCount || 0
      });

      return {
        ...result,
        durationMs: duration
      };

    } catch (error) {
      const duration = Date.now() - startTime;

      if (error instanceof ImageGenerationError) {
        throw error;
      }

      // Wrap unknown errors
      const wrappedError = new ImageGenerationError(
        'Image generation failed',
        'GENERATION_FAILED',
        {
          cause: error,
          retryable: this.isRetryableError(error),
          context: { durationMs: duration }
        }
      );

      this.logError('Image generation failed', wrappedError, { durationMs: duration });
      throw wrappedError;
    }
  }

  /**
   * Perform the actual image generation with retry logic
   */
  private async performGeneration(
    request: ImageGenerationRequest
  ): Promise<ImageGenerationResult> {
    const retryPolicy = createRateLimitRetryPolicy({
      maxRetries: this.config.maxRetries ?? 3,
      initialDelay: 1000,
      maxDelay: 30000
    });

    try {
      const result = await withRetryAndTimeout(
        async () => await this.generateSingleAttempt(request),
        retryPolicy,
        this.config.timeout ?? 60000,
        (error, attempt, delay) => {
          this.logWarn(`Generation attempt ${attempt} failed, retrying in ${delay}ms`, {
            error: error instanceof Error ? error.message : String(error),
            attempt,
            delay
          });
        }
      );

      return {
        ...result.result,
        retryCount: result.attempts - 1 // Don't count the successful attempt
      };
    } catch (error) {
      // All retries exhausted, try fallback providers
      return await this.tryFallbackProviders(request, error);
    }
  }

  /**
   * Single generation attempt
   */
  private async generateSingleAttempt(
    request: ImageGenerationRequest
  ): Promise<ImageGenerationResult> {
    const provider = this.providerManager.getProvider(request.provider!);
    const model = await provider.getModel(request.modelId!);

    // Prepare generation parameters
    const params: any = {
      model,
      prompt: request.prompt,
      n: request.n || this.config.defaultImageCount || 1
    };

    // Add provider-specific parameters
    if (request.provider === 'openai' && request.size) {
      params.size = request.size;
    }

    if ((request.provider === 'google' || request.provider === 'fal') && request.aspectRatio) {
      params.aspectRatio = request.aspectRatio;
    }

    if (request.providerOptions) {
      params.providerOptions = request.providerOptions;
    }

    if (request.seed) {
      params.seed = request.seed;
    }

    if (request.headers) {
      params.headers = request.headers;
    }

    if (request.abortSignal) {
      params.abortSignal = request.abortSignal;
    }

    // Handle special streaming models
    if (request.provider === 'fal' && request.modelId === 'fal-ai/flux-krea-lora/stream') {
      return this.generateStreaming(request);
    }

    // Standard AI SDK generation
    const result = await generateImage(params);

    // Extract base64 images
    const images = result.images.map((img: any) => img.base64);
    const warnings = (result.warnings || []).map((warning: unknown) =>
      typeof warning === 'string' ? warning : JSON.stringify(warning)
    );

    return {
      images,
      warnings,
      provider: request.provider,
      model: request.modelId,
      providerMetadata: result.providerMetadata
    };
  }

  /**
   * Handle streaming generation for Fal models
   */
  private async generateStreaming(request: ImageGenerationRequest): Promise<ImageGenerationResult> {
    const provider = this.providerManager.getProvider('fal');
    const falClient = await (provider as any).getFalClient();

    const result = await falClient.subscribe(request.modelId!, {
      input: {
        prompt: request.prompt
      },
      logs: true,
      onQueueUpdate: (update: any) => {
        if (this.config.debug && update.status === "IN_PROGRESS") {
          console.log('Fal streaming progress:', update);
        }
      },
      signal: request.abortSignal
    });

    // Convert to expected format
    const images = result.data.images?.[0]?.url || result.data.image?.url;
    if (!images) {
      throw new ImageGenerationError('No image URL in streaming response', 'STREAMING_NO_IMAGE');
    }

    return {
      images: [images],
      provider: request.provider,
      model: request.modelId,
      providerMetadata: { fal: result }
    };
  }

  /**
   * Try fallback providers if the primary one fails
   */
  private async tryFallbackProviders(
    originalRequest: ImageGenerationRequest,
    originalError: unknown
  ): Promise<ImageGenerationResult> {
    const configuredProviders = this.providerManager.getConfiguredProviders();
    const fallbackProviders = configuredProviders.filter(
      (p: ImageGenerationRequest['provider']) => p !== originalRequest.provider
    );

    for (const fallbackProvider of fallbackProviders) {
      try {
        this.logWarn(`Trying fallback provider: ${fallbackProvider}`, {
          originalProvider: originalRequest.provider,
          fallbackProvider
        });

        const fallbackRequest = {
          ...originalRequest,
          provider: fallbackProvider,
          modelId: registry.getDefaultModel(fallbackProvider)?.id
        };

        return await this.generateSingleAttempt(fallbackRequest);
      } catch (fallbackError) {
        this.logWarn(`Fallback provider ${fallbackProvider} also failed`, {
          error: fallbackError instanceof Error ? fallbackError.message : String(fallbackError)
        });
        continue;
      }
    }

    // All providers failed, throw the original error
    throw originalError;
  }

  /**
   * Check if an error is retryable
   */
  private isRetryableError(error: unknown): boolean {
    if (error instanceof ImageGenerationError) {
      return error.retryable;
    }

    const message = error instanceof Error ? error.message : String(error);
    const retryablePatterns = [
      'timeout',
      'rate limit',
      '429',
      '500',
      '502',
      '503',
      '504',
      'network',
      'connection'
    ];

    return retryablePatterns.some(pattern =>
      message.toLowerCase().includes(pattern.toLowerCase())
    );
  }

  /**
   * Logging helpers
   */
  private logInfo(message: string, data?: any): void {
    if (this.config.debug) {
      console.log(`[ImageGenerator] ${message}`, data || '');
    }
  }

  private logWarn(message: string, data?: any): void {
    if (this.config.debug) {
      console.warn(`[ImageGenerator] ${message}`, data || '');
    }
  }

  private logError(message: string, error?: any, data?: any): void {
    console.error(`[ImageGenerator] ${message}`, error, data || '');
  }
}

/**
 * Convenience function for simple image generation
 */
export async function generateImages(
  request: ImageGenerationRequest,
  config?: ImageGeneratorConfig
): Promise<ImageGenerationResult> {
  const generator = new ImageGenerator(config || createDefaultConfig());
  return generator.generate(request);
}

/**
 * Create a default configuration
 */
function createDefaultConfig(): ImageGeneratorConfig {
  return {
    apiKeys: {},
    defaultImageCount: 1,
    maxRetries: 3,
    timeout: 60000,
    debug: false
  };
}
