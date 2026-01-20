/**
 * Parameter validation utilities for image generation requests
 */

import { z } from 'zod';
import type { ImageGenerationRequest, ImageProviderId } from '../core/types.js';
import { registry } from '../core/registry.js';

/**
 * Zod schema for image generation requests
 */
export const imageGenerationRequestSchema = z.object({
  prompt: z.string().min(1, 'Prompt is required and cannot be empty'),
  provider: z.enum(['openai', 'google', 'xai', 'fal', 'openrouter']).optional(),
  modelId: z.string().optional(),
  n: z.number().int().positive().max(10).default(1),
  size: z.string().optional(),
  aspectRatio: z.string().optional(),
  providerOptions: z.record(z.unknown()).optional(),
  abortSignal: z.instanceof(AbortSignal).optional(),
  headers: z.record(z.string()).optional(),
  seed: z.number().int().optional()
});

/**
 * Zod schema for library configuration
 */
export const imageGeneratorConfigSchema = z.object({
  apiKeys: z.object({
    openai: z.string().optional(),
    google: z.string().optional(),
    xai: z.string().optional(),
    fal: z.string().optional(),
    openrouter: z.string().optional()
  }).optional(),
  defaultProvider: z.enum(['openai', 'google', 'xai', 'fal', 'openrouter']).optional(),
  defaultModel: z.string().optional(),
  defaultImageCount: z.number().int().positive().max(10).default(1),
  maxRetries: z.number().int().min(0).max(10).default(3),
  timeout: z.number().int().positive().default(60000), // 60 seconds
  debug: z.boolean().default(false)
});

/**
 * Validate an image generation request
 */
export function validateImageRequest(request: unknown): {
  success: true;
  data: ImageGenerationRequest;
} | {
  success: false;
  errors: string[];
} {
  try {
    const validated = imageGenerationRequestSchema.parse(request);
    return { success: true, data: validated };
  } catch (error) {
    if (error instanceof z.ZodError) {
      const errors = error.issues.map(issue => {
        const path = issue.path.join('.');
        return path ? `${path}: ${issue.message}` : issue.message;
      });
      return { success: false, errors };
    }
    const errorMessage = error instanceof Error ? error.message : 'Unknown validation error';
    return { success: false, errors: [errorMessage] };
  }
}

/**
 * Validate and normalize image generation parameters
 */
export function validateAndNormalizeRequest(
  request: ImageGenerationRequest
): {
  success: true;
  data: ImageGenerationRequest;
} | {
  success: false;
  errors: string[];
} {
  // First validate basic structure
  const basicValidation = validateImageRequest(request);
  if (!basicValidation.success) {
    return basicValidation;
  }

  const normalized = { ...basicValidation.data };
  const errors: string[] = [];

  // Determine provider
  let provider: ImageProviderId;
  if (normalized.provider) {
    provider = normalized.provider;
  } else {
    // Use default if available, otherwise first supported provider
    const providers = registry.getAllProviders();
    const configuredProviders = providers.filter(p => registry.isProviderSupported(p.id));
    if (configuredProviders.length === 0) {
      errors.push('No image providers are configured or supported');
      return { success: false, errors };
    }
    provider = configuredProviders[0].id;
  }
  normalized.provider = provider;

  // Validate provider support
  if (!registry.isProviderSupported(provider)) {
    errors.push(`Provider ${provider} is not supported for image generation`);
  }

  // Determine model
  let modelId: string;
  if (normalized.modelId) {
    modelId = normalized.modelId;
  } else {
    const defaultModel = registry.getDefaultModel(provider);
    if (!defaultModel) {
      errors.push(`No default model available for provider ${provider}`);
      return { success: false, errors };
    }
    modelId = defaultModel.id;
  }
  normalized.modelId = modelId;

  // Validate model exists
  const model = registry.getModel(provider, modelId);
  if (!model) {
    errors.push(`Model ${modelId} not found for provider ${provider}`);
  }

  // Validate model-specific parameters
  if (model) {
    const paramValidation = registry.validateModelParameters(provider, modelId, {
      size: normalized.size,
      aspectRatio: normalized.aspectRatio
    });

    if (!paramValidation.valid) {
      errors.push(...paramValidation.errors);
    }

    // Apply defaults if not specified
    if (!normalized.size && model.defaults?.size) {
      normalized.size = model.defaults.size;
    }
    if (!normalized.aspectRatio && model.defaults?.aspectRatio) {
      normalized.aspectRatio = model.defaults.aspectRatio;
    }
  }

  // Validate image count against model limits
  if (model?.maxImages && normalized.n && normalized.n > model.maxImages) {
    errors.push(`Model ${modelId} supports maximum ${model.maxImages} images per request, requested ${normalized.n}`);
  }

  // Clamp image count to reasonable limits
  if (normalized.n && normalized.n > 10) {
    normalized.n = 10;
  }
  if (normalized.n && normalized.n < 1) {
    normalized.n = 1;
  }

  if (errors.length > 0) {
    return { success: false, errors };
  }

  return { success: true, data: normalized };
}

/**
 * Validate library configuration
 */
export function validateConfig(config: unknown): {
  success: true;
  data: any;
} | {
  success: false;
  errors: string[];
} {
  try {
    const validated = imageGeneratorConfigSchema.parse(config);
    return { success: true, data: validated };
  } catch (error) {
    if (error instanceof z.ZodError) {
      const errors = error.issues.map(issue => {
        const path = issue.path.join('.');
        return path ? `${path}: ${issue.message}` : issue.message;
      });
      return { success: false, errors };
    }
    return { success: false, errors: ['Invalid configuration format'] };
  }
}

/**
 * Type guard to check if a provider ID is valid
 */
export function isValidProviderId(value: string): value is ImageProviderId {
  const validProviders: ImageProviderId[] = ['openai', 'google', 'xai', 'fal', 'openrouter'];
  return validProviders.includes(value as ImageProviderId);
}

/**
 * Validate API key format for a provider
 */
export function validateApiKey(provider: ImageProviderId, apiKey: string): boolean {
  if (!apiKey || apiKey.trim().length === 0) {
    return false;
  }

  // Basic format validation per provider
  switch (provider) {
    case 'openai':
      // OpenAI keys start with 'sk-'
      return apiKey.startsWith('sk-');
    case 'google':
      // Google API keys are typically longer and contain specific patterns
      return apiKey.length > 20;
    case 'xai':
      // xAI keys start with 'xai-' or 'sk-or-v1-'
      return apiKey.startsWith('xai-') || apiKey.startsWith('sk-or-v1-') || apiKey.startsWith('grok-');
    case 'fal':
      // Fal keys are typically prefixed
      return apiKey.length > 10;
    case 'openrouter':
      // OpenRouter keys start with 'sk-or-v1-'
      return apiKey.startsWith('sk-or-v1-');
    default:
      return true; // Allow custom providers
  }
}
