/**
 * Google image provider implementation
 */

import type { ImageProviderConfig } from '../core/types.js';
import { BaseImageProvider, ProviderFactory, providerFactories } from './base.js';

/**
 * Google image provider
 */
export class GoogleProvider extends BaseImageProvider {
  private client: any = null;

  constructor(apiKey?: string) {
    super('google', 'Google', apiKey);
  }

  async getModel(modelId: string): Promise<any> {
    this.validateApiKey();

    if (!this.client) {
      // Lazy import to avoid bundling unused providers
      const { google, createGoogleGenerativeAI } = await import('@ai-sdk/google');

      this.client = createGoogleGenerativeAI({
        apiKey: this.apiKey,
      });
    }

    return this.client.image(modelId);
  }

  validateParameters(params: Record<string, unknown>): void {
    // Google supports aspectRatio parameter
    if (params.aspectRatio && typeof params.aspectRatio === 'string') {
      const validAspectRatios = ['1:1', '9:16', '16:9', '4:3', '3:4'];
      if (!validAspectRatios.includes(params.aspectRatio)) {
        throw new Error(`Invalid aspect ratio for Google: ${params.aspectRatio}. Valid ratios: ${validAspectRatios.join(', ')}`);
      }
    }

    // Google doesn't use size, it uses aspectRatio
    if (params.size) {
      console.warn('Google provider does not support size parameter, use aspectRatio instead');
    }
  }

  getMetadata(): Record<string, unknown> {
    return {
      ...super.getMetadata(),
      supportedParameters: ['aspectRatio'],
      supportedAspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4']
    };
  }
}

/**
 * Factory for creating Google providers
 */
export class GoogleProviderFactory implements ProviderFactory {
  create(config?: ImageProviderConfig): GoogleProvider {
    return new GoogleProvider(config?.google);
  }
}

// Register the factory
providerFactories.register('google', new GoogleProviderFactory());
