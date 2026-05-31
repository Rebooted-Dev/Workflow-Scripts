/**
 * Provider factory for creating and managing image generation providers
 */

import type { ImageProviderId, ImageProviderConfig } from '../core/types.js';
import { ImageGenerationError } from '../core/types.js';
import { providerFactories } from './base.js';
import type { ImageProvider } from './base.js';

// Import factories to register them
import './openai.js';
import './google.js';
import './xai.js';
import './fal.js';

/**
 * Provider manager for creating and caching provider instances
 */
export class ProviderManager {
  private providers: Map<ImageProviderId, ImageProvider> = new Map();
  private config?: ImageProviderConfig;

  constructor(config?: ImageProviderConfig) {
    this.config = config;
  }

  /**
   * Update the configuration
   */
  updateConfig(config: ImageProviderConfig): void {
    this.config = config;
    // Clear cached providers to force recreation with new config
    this.providers.clear();
  }

  /**
   * Get or create a provider instance
   */
  getProvider(id: ImageProviderId): ImageProvider {
    let provider: ImageProvider | null | undefined = this.providers.get(id);

    if (!provider) {
      provider = providerFactories.create(id, this.config);
      if (!provider) {
        throw new ImageGenerationError(
          `Provider ${id} is not supported`,
          'PROVIDER_NOT_SUPPORTED',
          { provider: id, retryable: false }
        );
      }
      this.providers.set(id, provider);
    }

    return provider;
  }

  /**
   * Check if a provider is configured
   */
  isProviderConfigured(id: ImageProviderId): boolean {
    try {
      const provider = this.getProvider(id);
      return provider.isConfigured();
    } catch {
      return false;
    }
  }

  /**
   * Get all configured providers
   */
  getConfiguredProviders(): ImageProviderId[] {
    const availableProviders: ImageProviderId[] = ['openai', 'google', 'xai', 'fal'];
    return availableProviders.filter(id => this.isProviderConfigured(id));
  }

  /**
   * Get provider metadata
   */
  getProviderMetadata(id: ImageProviderId): Record<string, unknown> | null {
    try {
      const provider = this.getProvider(id);
      return provider.getMetadata();
    } catch {
      return null;
    }
  }

  /**
   * Get all providers with their metadata
   */
  getAllProviderMetadata(): Record<string, unknown> {
    const availableProviders: ImageProviderId[] = ['openai', 'google', 'xai', 'fal'];
    const metadata: Record<string, unknown> = {};

    for (const id of availableProviders) {
      metadata[id] = this.getProviderMetadata(id);
    }

    return metadata;
  }

  /**
   * Validate provider parameters
   */
  validateProviderParameters(
    providerId: ImageProviderId,
    params: Record<string, unknown>
  ): void {
    const provider = this.getProvider(providerId);
    provider.validateParameters(params);
  }
}

/**
 * Global provider manager instance
 */
let globalProviderManager: ProviderManager | null = null;

/**
 * Get the global provider manager
 */
export function getProviderManager(config?: ImageProviderConfig): ProviderManager {
  if (!globalProviderManager || config) {
    globalProviderManager = new ProviderManager(config);
  }
  return globalProviderManager;
}

/**
 * Create a provider manager with specific configuration
 */
export function createProviderManager(config?: ImageProviderConfig): ProviderManager {
  return new ProviderManager(config);
}

/**
 * Check if a provider is configured globally
 */
export function isProviderConfigured(providerId: ImageProviderId): boolean {
  return getProviderManager().isProviderConfigured(providerId);
}

/**
 * Get configured providers globally
 */
export function getConfiguredProviders(): ImageProviderId[] {
  return getProviderManager().getConfiguredProviders();
}
