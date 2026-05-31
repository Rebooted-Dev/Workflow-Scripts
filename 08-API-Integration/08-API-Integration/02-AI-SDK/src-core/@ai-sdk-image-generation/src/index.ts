/**
 * AI SDK Image Generation Library
 *
 * A comprehensive, multi-provider image generation library built on the AI SDK.
 * Supports OpenAI, Google, xAI, and Fal providers with automatic
 * fallback, retry logic, and provider-agnostic parameter handling.
 */

// Core types and interfaces
export type {
  ImageProviderId,
  ImageModelOption,
  ImageProviderInfo,
  ImageProviderConfig,
  ImageGeneratorConfig,
  ImageGenerationRequest,
  ImageGenerationResult,
  StreamingImageResult,
  StreamingCallback,
  ImageGenerationStats
} from './core/types.js';

// Provider registry
export {
  ImageProviderRegistry,
  registry,
  getImageProviders,
  getImageModels,
  isImageProviderSupported,
  getImageModel,
  getDefaultImageModel,
  getModelMaxImages
} from './core/registry.js';

// Main image generator class
export { ImageGenerator } from './core/generator.js';

// Convenience functions for quick usage
export { generateImages } from './core/generator.js';

// Error handling
export { ImageGenerationError } from './core/types.js';

// Utility functions
export { validateImageRequest, validateAndNormalizeRequest } from './utils/validation.js';
export { createRetryPolicy } from './utils/retry.js';

// Configuration builders
export { createImageGeneratorConfig } from './config/builder.js';
