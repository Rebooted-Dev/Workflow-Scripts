/**
 * Core type definitions for the AI SDK Image Generation library
 */

/**
 * Supported image provider identifiers
 */
export type ImageProviderId = 'openai' | 'google' | 'xai' | 'fal';

/**
 * Image model capabilities and configuration
 */
export interface ImageModelOption {
  /** Unique model identifier */
  id: string;
  /** Human-readable model name */
  name: string;
  /** Provider this model belongs to */
  provider: ImageProviderId;
  /** Supported parameters for this model */
  supports: {
    /** Supported sizes (width x height format) - OpenAI style */
    size?: string[];
    /** Supported aspect ratios (width:height format) - Google/Fal style */
    aspectRatios?: string[];
  };
  /** Default parameter values */
  defaults?: {
    /** Default size for OpenAI models */
    size?: string;
    /** Default aspect ratio for Google/Fal models */
    aspectRatio?: string;
  };
  /** Maximum number of images per request (if known) */
  maxImages?: number;
}

/**
 * Provider information including available models
 */
export interface ImageProviderInfo {
  /** Provider identifier */
  id: ImageProviderId;
  /** Human-readable provider name */
  name: string;
  /** Available models for this provider */
  models: ImageModelOption[];
}

/**
 * Configuration for API keys and provider settings
 */
export interface ImageProviderConfig {
  /** OpenAI API key */
  openai?: string;
  /** Google/Gemini API key */
  google?: string;
  /** xAI API key */
  xai?: string;
  /** Fal API key */
  fal?: string;
}

/**
 * Library configuration options
 */
export interface ImageGeneratorConfig {
  /** API keys for providers */
  apiKeys?: ImageProviderConfig;
  /** Default provider to use */
  defaultProvider?: ImageProviderId;
  /** Default model to use */
  defaultModel?: string;
  /** Default number of images to generate */
  defaultImageCount?: number;
  /** Maximum retry attempts */
  maxRetries?: number;
  /** Request timeout in milliseconds */
  timeout?: number;
  /** Enable debug logging */
  debug?: boolean;
}

/**
 * Parameters for an image generation request
 */
export interface ImageGenerationRequest {
  /** Text prompt for image generation */
  prompt: string;
  /** Provider to use (optional, uses default if not specified) */
  provider?: ImageProviderId;
  /** Model ID to use (optional, uses provider default if not specified) */
  modelId?: string;
  /** Number of images to generate */
  n?: number;
  /** Image size (OpenAI format: "widthxheight") */
  size?: string;
  /** Aspect ratio (Google/Fal format: "width:height") */
  aspectRatio?: string;
  /** Provider-specific options */
  providerOptions?: Record<string, unknown>;
  /** Abort signal for cancellation */
  abortSignal?: AbortSignal;
  /** Custom headers */
  headers?: Record<string, string>;
  /** Seed for reproducible generation */
  seed?: number;
}

/**
 * Result of an image generation request
 */
export interface ImageGenerationResult {
  /** Generated images as base64-encoded strings */
  images: string[];
  /** Warnings from the provider (if any) */
  warnings?: string[];
  /** Provider-specific metadata */
  providerMetadata?: unknown;
  /** Provider that was used */
  provider?: string;
  /** Model that was used */
  model?: string;
  /** Generation duration in milliseconds */
  durationMs?: number;
  /** Number of retry attempts made */
  retryCount?: number;
}

/**
 * Custom error class for image generation failures
 */
export class ImageGenerationError extends Error {
  /** Error code for categorization */
  code: string;
  /** Provider that caused the error */
  provider?: string;
  /** Model that caused the error */
  model?: string;
  /** Whether this error is retryable */
  retryable: boolean;
  /** Original cause of the error */
  cause?: unknown;
  /** Additional context */
  context?: Record<string, unknown>;

  constructor(
    message: string,
    code: string,
    options: {
      provider?: string;
      model?: string;
      retryable?: boolean;
      cause?: unknown;
      context?: Record<string, unknown>;
    } = {}
  ) {
    super(message);
    this.name = 'ImageGenerationError';
    this.code = code;
    this.provider = options.provider;
    this.model = options.model;
    this.retryable = options.retryable ?? false;
    this.cause = options.cause;
    this.context = options.context;
  }

  /**
   * Check if an error is an ImageGenerationError
   */
  static isInstance(error: unknown): error is ImageGenerationError {
    return error instanceof ImageGenerationError;
  }
}

/**
 * Streaming result for progressive image generation
 */
export interface StreamingImageResult {
  /** Current status of the generation */
  status: 'generating' | 'completed' | 'failed';
  /** Images generated so far (may be partial) */
  images: string[];
  /** Progress percentage (0-100) */
  progress?: number;
  /** Current step description */
  step?: string;
  /** Error if status is 'failed' */
  error?: string;
}

/**
 * Callback for streaming image generation
 */
export type StreamingCallback = (result: StreamingImageResult) => void;

/**
 * Statistics for image generation operations
 */
export interface ImageGenerationStats {
  /** Total requests made */
  totalRequests: number;
  /** Successful generations */
  successfulGenerations: number;
  /** Failed generations */
  failedGenerations: number;
  /** Average generation time in milliseconds */
  averageGenerationTime: number;
  /** Total retry attempts */
  totalRetries: number;
  /** Provider usage statistics */
  providerUsage: Record<string, number>;
}
