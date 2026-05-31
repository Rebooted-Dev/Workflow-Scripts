/**
 * Unit tests for provider registry
 */

import { describe, it, expect, vi } from 'vitest';
import { registry, getImageProviders, getImageModels, isImageProviderSupported } from '../../../src/core/registry.js';

describe('Provider Registry', () => {
  describe('getImageProviders', () => {
    it('should return all built-in providers', () => {
      const providers = getImageProviders();

      expect(providers).toHaveLength(4);
      expect(providers.map(p => p.id)).toEqual(
        expect.arrayContaining(['openai', 'google', 'xai', 'fal'])
      );
      expect(providers.map(p => p.id)).not.toContain('openrouter');
    });

    it('should include complete provider information', () => {
      const providers = getImageProviders();
      const openai = providers.find(p => p.id === 'openai');

      expect(openai).toBeDefined();
      expect(openai!.name).toBe('OpenAI');
      expect(openai!.models).toBeDefined();
      expect(openai!.models.length).toBeGreaterThan(0);
    });
  });

  describe('getImageModels', () => {
    it('should return models for valid provider', () => {
      const models = getImageModels('openai');

      expect(models.length).toBeGreaterThan(0);
      expect(models[0]).toHaveProperty('id');
      expect(models[0]).toHaveProperty('name');
      expect(models[0]).toHaveProperty('provider', 'openai');
    });

    it('should return empty array for invalid provider', () => {
      const models = getImageModels('invalid' as any);
      expect(models).toHaveLength(0);
    });
  });

  describe('isImageProviderSupported', () => {
    it('should return true for providers with models', () => {
      expect(isImageProviderSupported('openai')).toBe(true);
      expect(isImageProviderSupported('google')).toBe(true);
      expect(isImageProviderSupported('xai')).toBe(true);
      expect(isImageProviderSupported('fal')).toBe(true);
    });

    it('should return false for invalid providers', () => {
      expect(isImageProviderSupported('invalid' as any)).toBe(false);
    });
  });

  describe('Model Capabilities', () => {
    it('should correctly identify OpenAI model capabilities', () => {
      const capabilities = registry.getModelCapabilities('openai', 'dall-e-3');

      expect(capabilities.supportsSize).toBe(true);
      expect(capabilities.supportsAspectRatio).toBe(false);
      expect(capabilities.supportedSizes).toContain('1024x1024');
      expect(capabilities.defaults.size).toBe('1024x1024');
    });

    it('should correctly identify Google model capabilities', () => {
      const capabilities = registry.getModelCapabilities('google', 'imagen-3.0-generate-002');

      expect(capabilities.supportsSize).toBe(false);
      expect(capabilities.supportsAspectRatio).toBe(true);
      expect(capabilities.supportedAspectRatios).toContain('16:9');
      expect(capabilities.defaults.aspectRatio).toBe('1:1');
    });

    it('should correctly identify xAI model capabilities', () => {
      const capabilities = registry.getModelCapabilities('xai', 'grok-2-image');

      expect(capabilities.supportsSize).toBe(false);
      expect(capabilities.supportsAspectRatio).toBe(false);
      expect(capabilities.supportedSizes).toHaveLength(0);
      expect(capabilities.supportedAspectRatios).toHaveLength(0);
    });
  });

  describe('Parameter Validation', () => {
    it('should validate OpenAI size parameters', () => {
      const result = registry.validateModelParameters('openai', 'dall-e-3', {
        size: '1024x1024'
      });

      expect(result.valid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('should reject invalid OpenAI size parameters', () => {
      const result = registry.validateModelParameters('openai', 'dall-e-3', {
        size: 'invalid-size'
      });

      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Size invalid-size not supported by model dall-e-3');
    });

    it('should validate Google aspect ratio parameters', () => {
      const result = registry.validateModelParameters('google', 'imagen-3.0-generate-002', {
        aspectRatio: '16:9'
      });

      expect(result.valid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('should reject invalid Google aspect ratio parameters', () => {
      const result = registry.validateModelParameters('google', 'imagen-3.0-generate-002', {
        aspectRatio: 'invalid-ratio'
      });

      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Aspect ratio invalid-ratio not supported by model imagen-3.0-generate-002');
    });
  });

  describe('Custom Provider Registration', () => {
    it('should allow registering custom providers', () => {
      const customProvider = {
        id: 'custom' as any,
        name: 'Custom Provider',
        models: [{
          id: 'custom-model',
          name: 'Custom Model',
          provider: 'custom' as any,
          supports: { size: ['512x512'] },
          defaults: { size: '512x512' }
        }]
      };

      registry.registerProvider(customProvider);

      expect(isImageProviderSupported('custom' as any)).toBe(true);
      const models = getImageModels('custom' as any);
      expect(models).toHaveLength(1);
      expect(models[0].id).toBe('custom-model');
    });

    it('should allow unregistering providers', () => {
      registry.unregisterProvider('custom' as any);
      expect(isImageProviderSupported('custom' as any)).toBe(false);
    });
  });
});
