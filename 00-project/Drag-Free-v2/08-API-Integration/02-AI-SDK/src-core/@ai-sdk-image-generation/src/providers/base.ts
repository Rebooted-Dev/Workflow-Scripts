/**
 * Base provider interface and utilities
 */

import type { ImageProviderId, ImageProviderConfig } from '../core/types.js';

/**
 * Base interface for image generation providers
 */
export interface ImageProvider {
  /** Unique identifier for the provider */
  readonly id: ImageProviderId;

  /** Human-readable name */
  readonly name: string;

  /** Check if the provider is configured with valid API keys */
  isConfigured(): boolean;

  /** Get an AI SDK model instance for the given model ID */
  getModel(modelId: string): Promise<any>;

  /** Validate provider-specific parameters */
  validateParameters(params: Record<string, unknown>): void;

  /** Get provider-specific metadata */
  getMetadata(): Record<string, unknown>;
}

/**
 * Base implementation with common functionality
 */
export abstract class BaseImageProvider implements ImageProvider {
  public readonly id: ImageProviderId;
  public readonly name: string;
  protected apiKey?: string;

  constructor(id: ImageProviderId, name: string, apiKey?: string) {
    this.id = id;
    this.name = name;
    this.apiKey = apiKey;
  }

  abstract getModel(modelId: string): Promise<any>;

  isConfigured(): boolean {
    return !!this.apiKey;
  }

  validateParameters(params: Record<string, unknown>): void {
    // Base implementation - override in subclasses for provider-specific validation
    void params;
  }

  getMetadata(): Record<string, unknown> {
    return {
      id: this.id,
      name: this.name,
      configured: this.isConfigured()
    };
  }

  protected validateApiKey(): void {
    if (!this.isConfigured()) {
      throw new Error(`Provider ${this.id} is not configured with an API key`);
    }
  }
}

/**
 * Factory for creating provider instances
 */
export interface ProviderFactory {
  create(config?: ImageProviderConfig): ImageProvider;
}

/**
 * Registry of provider factories
 */
class ProviderFactoryRegistry {
  private factories: Map<ImageProviderId, ProviderFactory> = new Map();

  register(id: ImageProviderId, factory: ProviderFactory): void {
    this.factories.set(id, factory);
  }

  create(id: ImageProviderId, config?: ImageProviderConfig): ImageProvider | null {
    const factory = this.factories.get(id);
    return factory ? factory.create(config) : null;
  }

  getAvailableProviders(): ImageProviderId[] {
    return Array.from(this.factories.keys());
  }
}

export const providerFactories = new ProviderFactoryRegistry();
