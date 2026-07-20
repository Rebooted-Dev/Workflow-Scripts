/**
 * OpenAI image provider implementation
 */

import type { ImageProviderConfig } from '../core/types.js';
import { BaseImageProvider, ProviderFactory, providerFactories } from './base.js';

/**
 * OpenAI image provider
 */
export class OpenAIProvider extends BaseImageProvider {
  private client: any = null;

  constructor(apiKey?: string) {
    super('openai', 'OpenAI', apiKey);
  }

  async getModel(modelId: string): Promise<any> {
    this.validateApiKey();

    if (!this.client) {
      // Lazy import to avoid bundling unused providers
      const { createOpenAI } = await import('@ai-sdk/openai');

      this.client = createOpenAI({
        apiKey: this.apiKey,
      });
    }

    return this.client.image(modelId);
  }

  validateParameters(params: Record<string, unknown>): void {
    // OpenAI supports size parameter
    if (params.size && typeof params.size === 'string') {
      const validSizes = ['256x256', '512x512', '1024x1024', '1792x1024', '1024x1792'];
      if (!validSizes.includes(params.size)) {
        throw new Error(`Invalid size for OpenAI: ${params.size}. Valid sizes: ${validSizes.join(', ')}`);
      }
    }

    // OpenAI doesn't use aspectRatio, it uses size
    if (params.aspectRatio) {
      console.warn('OpenAI provider does not support aspectRatio parameter, use size instead');
    }
  }

  getMetadata(): Record<string, unknown> {
    return {
      ...super.getMetadata(),
      supportedParameters: ['size'],
      supportedSizes: ['256x256', '512x512', '1024x1024', '1792x1024', '1024x1792']
    };
  }
}

/**
 * Factory for creating OpenAI providers
 */
export class OpenAIProviderFactory implements ProviderFactory {
  create(config?: ImageProviderConfig): OpenAIProvider {
    return new OpenAIProvider(config?.openai);
  }
}

// Register the factory
providerFactories.register('openai', new OpenAIProviderFactory());
