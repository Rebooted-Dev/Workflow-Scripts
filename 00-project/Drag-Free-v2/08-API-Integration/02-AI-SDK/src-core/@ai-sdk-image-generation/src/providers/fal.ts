/**
 * Fal image provider implementation
 */

import type { ImageProviderConfig } from '../core/types.js';
import { BaseImageProvider, ProviderFactory, providerFactories } from './base.js';

/**
 * Fal image provider
 */
export class FalProvider extends BaseImageProvider {
  private client: any = null;
  private falClient: any = null;

  constructor(apiKey?: string) {
    super('fal', 'Fal', apiKey);
  }

  async getModel(modelId: string): Promise<any> {
    this.validateApiKey();

    if (!this.client) {
      // Lazy import to avoid bundling unused providers
      const { createFal } = await import('@ai-sdk/fal');

      this.client = createFal({
        apiKey: this.apiKey,
      });
    }

    return this.client.image(modelId);
  }

  /**
   * Get the direct Fal client for streaming operations
   */
  async getFalClient() {
    if (!this.falClient) {
      // Lazy import of direct Fal client for streaming
      const { fal } = await import('@fal-ai/client');
      this.falClient = fal;
    }
    return this.falClient;
  }

  validateParameters(params: Record<string, unknown>): void {
    // Fal supports aspectRatio parameter
    if (params.aspectRatio && typeof params.aspectRatio === 'string') {
      const validAspectRatios = ['1:1', '9:16', '16:9', '4:3', '3:4', '2:3', '3:2', '5:4', '4:5'];
      if (!validAspectRatios.includes(params.aspectRatio)) {
        throw new Error(`Invalid aspect ratio for Fal: ${params.aspectRatio}. Valid ratios: ${validAspectRatios.join(', ')}`);
      }
    }

    // Fal doesn't use size, it uses aspectRatio
    if (params.size) {
      console.warn('Fal provider does not support size parameter, use aspectRatio instead');
    }
  }

  /**
   * Check if a model supports streaming
   */
  isStreamingModel(modelId: string): boolean {
    const streamingModels = ['fal-ai/flux-krea-lora/stream'];
    return streamingModels.includes(modelId);
  }

  /**
   * Perform streaming generation for supported models
   */
  async generateStreaming(modelId: string, prompt: string, options: {
    onProgress?: (data: any) => void;
    signal?: AbortSignal;
  } = {}) {
    if (!this.isStreamingModel(modelId)) {
      throw new Error(`Model ${modelId} does not support streaming`);
    }

    const fal = await this.getFalClient();

    return fal.subscribe(modelId, {
      input: { prompt },
      logs: true,
      onQueueUpdate: (update: any) => {
        if (update.status === "IN_PROGRESS" && options.onProgress) {
          options.onProgress(update);
        }
      },
      signal: options.signal
    });
  }

  getMetadata(): Record<string, unknown> {
    return {
      ...super.getMetadata(),
      supportedParameters: ['aspectRatio'],
      supportedAspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4', '2:3', '3:2', '5:4', '4:5'],
      streamingModels: ['fal-ai/flux-krea-lora/stream']
    };
  }
}

/**
 * Factory for creating Fal providers
 */
export class FalProviderFactory implements ProviderFactory {
  create(config?: ImageProviderConfig): FalProvider {
    return new FalProvider(config?.fal);
  }
}

// Register the factory
providerFactories.register('fal', new FalProviderFactory());
