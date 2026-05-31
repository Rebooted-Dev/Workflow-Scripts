/**
 * Provider registry for managing image generation providers and models
 */

import type { ImageProviderId, ImageProviderInfo, ImageModelOption } from './types.js';

/**
 * Built-in image provider configurations
 * Sourced from AI SDK documentation and current implementation
 */
const BUILT_IN_PROVIDERS: ImageProviderInfo[] = [
  {
    id: 'openai',
    name: 'OpenAI',
    models: [
      {
        id: 'gpt-image-1',
        name: 'GPT Image 1',
        provider: 'openai',
        supports: {
          size: ['256x256', '512x512', '1024x1024', '1792x1024', '1024x1792']
        },
        maxImages: 1,
        defaults: {
          size: '1024x1024'
        }
      },
      {
        id: 'gpt-image-1-mini',
        name: 'GPT Image 1 Mini',
        provider: 'openai',
        supports: {
          size: ['256x256', '512x512', '1024x1024', '1792x1024', '1024x1792']
        },
        maxImages: 1,
        defaults: {
          size: '1024x1024'
        }
      },
      {
        id: 'dall-e-3',
        name: 'DALL-E 3',
        provider: 'openai',
        supports: {
          size: ['1024x1024', '1792x1024', '1024x1792']
        },
        maxImages: 1,
        defaults: {
          size: '1024x1024'
        }
      },
      {
        id: 'dall-e-2',
        name: 'DALL-E 2',
        provider: 'openai',
        supports: {
          size: ['256x256', '512x512', '1024x1024']
        },
        maxImages: 1,
        defaults: {
          size: '1024x1024'
        }
      }
    ]
  },
  {
    id: 'google',
    name: 'Google',
    models: [
      {
        id: 'imagen-3.0-generate-002',
        name: 'Imagen 3.0',
        provider: 'google',
        supports: {
          aspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4']
        },
        defaults: {
          aspectRatio: '1:1'
        }
      },
      {
        id: 'gemini-2.5-flash-image-preview',
        name: 'Gemini 2.5 Flash Image Preview',
        provider: 'google',
        supports: {
          aspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4']
        },
        defaults: {
          aspectRatio: '1:1'
        }
      }
    ]
  },
  {
    id: 'xai',
    name: 'xAI',
    models: [
      {
        id: 'grok-2-image',
        name: 'Grok-2-Image',
        provider: 'xai',
        supports: {},
        maxImages: 2,
        defaults: {
          // xAI uses default 1024x768, no size/aspect controls
        }
      }
    ]
  },
  {
    id: 'fal',
    name: 'Fal',
    models: [
      {
        id: 'fal-ai/flux/dev',
        name: 'FLUX.1-dev',
        provider: 'fal',
        supports: {
          aspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4', '2:3', '3:2', '5:4', '4:5']
        },
        defaults: {
          aspectRatio: '1:1'
        }
      },
      {
        id: 'fal-ai/flux-pro/v1.1-ultra',
        name: 'FLUX.1.1-pro Ultra',
        provider: 'fal',
        supports: {
          aspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4', '2:3', '3:2', '5:4', '4:5']
        },
        defaults: {
          aspectRatio: '1:1'
        }
      },
      {
        id: 'fal-ai/fast-sdxl',
        name: 'Fast SDXL',
        provider: 'fal',
        supports: {
          aspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4']
        },
        defaults: {
          aspectRatio: '1:1'
        }
      },
      {
        id: 'fal-ai/flux-krea-lora/stream',
        name: 'FLUX.1 Krea LoRA Streaming',
        provider: 'fal',
        supports: {
          aspectRatios: ['1:1', '9:16', '16:9', '4:3', '3:4']
        },
        defaults: {
          aspectRatio: '1:1'
        }
      }
    ]
  }
];

/**
 * Registry for managing image generation providers and models
 */
export class ImageProviderRegistry {
  private providers: Map<ImageProviderId, ImageProviderInfo> = new Map();

  constructor() {
    // Initialize with built-in providers
    BUILT_IN_PROVIDERS.forEach(provider => {
      this.providers.set(provider.id, provider);
    });
  }

  /**
   * Get all registered providers
   */
  getAllProviders(): ImageProviderInfo[] {
    return Array.from(this.providers.values());
  }

  /**
   * Get a specific provider by ID
   */
  getProvider(id: ImageProviderId): ImageProviderInfo | undefined {
    return this.providers.get(id);
  }

  /**
   * Get models for a specific provider
   */
  getModels(providerId: ImageProviderId): ImageModelOption[] {
    const provider = this.providers.get(providerId);
    return provider?.models || [];
  }

  /**
   * Get a specific model by provider and model ID
   */
  getModel(providerId: ImageProviderId, modelId: string): ImageModelOption | undefined {
    const models = this.getModels(providerId);
    return models.find(model => model.id === modelId);
  }

  /**
   * Check if a provider is supported (has models available)
   */
  isProviderSupported(providerId: ImageProviderId): boolean {
    const models = this.getModels(providerId);
    return models.length > 0;
  }

  /**
   * Get the default model for a provider
   */
  getDefaultModel(providerId: ImageProviderId): ImageModelOption | undefined {
    const models = this.getModels(providerId);
    return models[0]; // First model is considered default
  }

  /**
   * Get the maximum number of images a model supports per request
   */
  getModelMaxImages(providerId: ImageProviderId, modelId: string): number | undefined {
    const model = this.getModel(providerId, modelId);
    return model?.maxImages;
  }

  /**
   * Register a custom provider
   * Allows extending the registry with custom providers
   */
  registerProvider(provider: ImageProviderInfo): void {
    this.providers.set(provider.id, provider);
  }

  /**
   * Unregister a provider
   */
  unregisterProvider(providerId: ImageProviderId): boolean {
    return this.providers.delete(providerId);
  }

  /**
   * Validate that a model supports the given parameters
   */
  validateModelParameters(
    providerId: ImageProviderId,
    modelId: string,
    params: { size?: string; aspectRatio?: string }
  ): { valid: boolean; errors: string[] } {
    const model = this.getModel(providerId, modelId);
    if (!model) {
      return { valid: false, errors: [`Model ${modelId} not found for provider ${providerId}`] };
    }

    const errors: string[] = [];

    if (params.size && model.supports.size) {
      if (!model.supports.size.includes(params.size)) {
        errors.push(`Size ${params.size} not supported by model ${modelId}`);
      }
    }

    if (params.aspectRatio && model.supports.aspectRatios) {
      if (!model.supports.aspectRatios.includes(params.aspectRatio)) {
        errors.push(`Aspect ratio ${params.aspectRatio} not supported by model ${modelId}`);
      }
    }

    return { valid: errors.length === 0, errors };
  }

  /**
   * Get supported parameters for a model
   */
  getModelCapabilities(providerId: ImageProviderId, modelId: string): {
    supportsSize: boolean;
    supportsAspectRatio: boolean;
    supportedSizes: string[];
    supportedAspectRatios: string[];
    defaults: { size?: string; aspectRatio?: string };
  } {
    const model = this.getModel(providerId, modelId);
    if (!model) {
      return {
        supportsSize: false,
        supportsAspectRatio: false,
        supportedSizes: [],
        supportedAspectRatios: [],
        defaults: {}
      };
    }

    return {
      supportsSize: !!model.supports.size,
      supportsAspectRatio: !!model.supports.aspectRatios,
      supportedSizes: model.supports.size || [],
      supportedAspectRatios: model.supports.aspectRatios || [],
      defaults: model.defaults || {}
    };
  }
}

/**
 * Global registry instance
 */
export const registry = new ImageProviderRegistry();

/**
 * Convenience functions for common registry operations
 */
export function getImageProviders(): ImageProviderInfo[] {
  return registry.getAllProviders();
}

export function getImageModels(providerId: ImageProviderId): ImageModelOption[] {
  return registry.getModels(providerId);
}

export function isImageProviderSupported(providerId: ImageProviderId): boolean {
  return registry.isProviderSupported(providerId);
}

export function getImageModel(providerId: ImageProviderId, modelId: string): ImageModelOption | undefined {
  return registry.getModel(providerId, modelId);
}

export function getDefaultImageModel(providerId: ImageProviderId): ImageModelOption | undefined {
  return registry.getDefaultModel(providerId);
}

export function getModelMaxImages(providerId: ImageProviderId, modelId: string): number | undefined {
  return registry.getModelMaxImages(providerId, modelId);
}
