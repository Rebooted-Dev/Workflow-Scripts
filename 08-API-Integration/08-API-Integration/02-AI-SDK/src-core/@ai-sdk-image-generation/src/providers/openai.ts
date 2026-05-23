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
      const { hasDefaultResponseFormat } = await import('@ai-sdk/openai/internal');

      // OpenAI's latest Images API rejects the legacy `response_format` flag. The AI SDK
      // (v2.0.42) still adds it for models not marked as having a default response format.
      // 1) Try to mark all OpenAI image models as default-response-format in the internal set
      //    (helps internal-only flows), and
      // 2) Add a fetch shim that strips `response_format` on /images/generations calls to
      //    cover the provider's public bundle as well.
      const imageModels = ['gpt-image-1', 'gpt-image-1-mini', 'dall-e-3', 'dall-e-2'];
      imageModels.forEach((modelId) => {
        hasDefaultResponseFormat.add(modelId);
      });

      const originalFetch = globalThis.fetch.bind(globalThis);
      const safeFetch: typeof fetch = async (input: any, init?: RequestInit) => {
        try {
          const url = typeof input === 'string' ? input : input instanceof URL ? input.toString() : input?.url;
          if (init?.method === 'POST' && url && url.includes('/images/generations')) {
            const headers = new Headers(init.headers as any);
            const contentType = headers.get('content-type') || headers.get('Content-Type');
            if (contentType && contentType.includes('application/json') && typeof init.body === 'string') {
              try {
                const body = JSON.parse(init.body as string);
                if (body && Object.prototype.hasOwnProperty.call(body, 'response_format')) {
                  delete (body as any).response_format;
                  init.body = JSON.stringify(body);
                }
              } catch {
                // ignore JSON parse errors and fall through
              }
            }
          }
        } catch {
          // ignore shim errors and fall through
        }
        return originalFetch(input as any, init as any);
      };

      this.client = createOpenAI({
        apiKey: this.apiKey,
        fetch: safeFetch,
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
