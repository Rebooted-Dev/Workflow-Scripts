/**
 * xAI image provider implementation
 */

import type { ImageProviderConfig } from '../core/types.js';
import { BaseImageProvider, ProviderFactory, providerFactories } from './base.js';

/**
 * xAI image provider
 */
export class XAIProvider extends BaseImageProvider {
  private client: any = null;

  constructor(apiKey?: string) {
    super('xai', 'xAI', apiKey);
  }

  async getModel(modelId: string): Promise<any> {
    this.validateApiKey();

    if (!this.client) {
      // Lazy import to avoid bundling unused providers
      const { createXai } = await import('@ai-sdk/xai');

      this.client = createXai({
        apiKey: this.apiKey,
      });
    }

    return this.client.image(modelId);
  }

  validateParameters(params: Record<string, unknown>): void {
    // xAI doesn't support size or aspectRatio parameters
    // It uses default 1024x768 resolution
    if (params.size) {
      console.warn('xAI provider does not support size parameter, uses default 1024x768');
    }

    if (params.aspectRatio) {
      console.warn('xAI provider does not support aspectRatio parameter, uses default 1024x768');
    }
  }

  getMetadata(): Record<string, unknown> {
    return {
      ...super.getMetadata(),
      supportedParameters: [],
      defaultResolution: '1024x768',
      maxImages: 2
    };
  }
}

/**
 * Factory for creating xAI providers
 */
export class XAIProviderFactory implements ProviderFactory {
  create(config?: ImageProviderConfig): XAIProvider {
    return new XAIProvider(config?.xai);
  }
}

// Register the factory
providerFactories.register('xai', new XAIProviderFactory());
