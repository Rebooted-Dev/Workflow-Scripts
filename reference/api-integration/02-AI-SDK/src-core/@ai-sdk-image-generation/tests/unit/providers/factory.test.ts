/**
 * Unit tests for provider factory
 */

import { describe, it, expect, vi, beforeEach } from 'vitest';
import { createProviderManager, getProviderManager } from '../../../src/providers/factory.js';
import type { ImageProviderConfig } from '../../../src/core/types.js';

// Mock provider implementations
vi.mock('../../../src/providers/openai.js', () => ({
  OpenAIProviderFactory: class {
    create(config?: ImageProviderConfig) {
      return {
        id: 'openai',
        name: 'OpenAI',
        isConfigured: vi.fn(() => !!config?.openai),
        getModel: vi.fn(() => ({ model: 'openai-model' })),
        validateParameters: vi.fn(),
        getMetadata: vi.fn(() => ({ id: 'openai', configured: !!config?.openai }))
      };
    }
  }
}));

vi.mock('../../../src/providers/google.js', () => ({
  GoogleProviderFactory: class {
    create(config?: ImageProviderConfig) {
      return {
        id: 'google',
        name: 'Google',
        isConfigured: vi.fn(() => !!config?.google),
        getModel: vi.fn(() => ({ model: 'google-model' })),
        validateParameters: vi.fn(),
        getMetadata: vi.fn(() => ({ id: 'google', configured: !!config?.google }))
      };
    }
  }
}));

vi.mock('../../../src/providers/xai.js', () => ({
  XAIProviderFactory: class {
    create(config?: ImageProviderConfig) {
      return {
        id: 'xai',
        name: 'xAI',
        isConfigured: vi.fn(() => !!config?.xai),
        getModel: vi.fn(() => ({ model: 'xai-model' })),
        validateParameters: vi.fn(),
        getMetadata: vi.fn(() => ({ id: 'xai', configured: !!config?.xai }))
      };
    }
  }
}));

vi.mock('../../../src/providers/fal.js', () => ({
  FalProviderFactory: class {
    create(config?: ImageProviderConfig) {
      return {
        id: 'fal',
        name: 'Fal',
        isConfigured: vi.fn(() => !!config?.fal),
        getModel: vi.fn(() => ({ model: 'fal-model' })),
        validateParameters: vi.fn(),
        getMetadata: vi.fn(() => ({ id: 'fal', configured: !!config?.fal }))
      };
    }
  }
}));

// Mock provider factories
vi.mock('../../../src/providers/base.js', () => ({
  providerFactories: {
    register: vi.fn(),
    create: vi.fn((id, config) => {
      switch (id) {
        case 'openai':
          return {
            id: 'openai',
            name: 'OpenAI',
            isConfigured: vi.fn(() => !!config?.openai),
            getModel: vi.fn(() => ({ model: 'openai-model' })),
            validateParameters: vi.fn(),
            getMetadata: vi.fn(() => ({ id: 'openai', configured: !!config?.openai }))
          };
        case 'google':
          return {
            id: 'google',
            name: 'Google',
            isConfigured: vi.fn(() => !!config?.google),
            getModel: vi.fn(() => ({ model: 'google-model' })),
            validateParameters: vi.fn(),
            getMetadata: vi.fn(() => ({ id: 'google', configured: !!config?.google }))
          };
        case 'xai':
          return {
            id: 'xai',
            name: 'xAI',
            isConfigured: vi.fn(() => !!config?.xai),
            getModel: vi.fn(() => ({ model: 'xai-model' })),
            validateParameters: vi.fn(),
            getMetadata: vi.fn(() => ({ id: 'xai', configured: !!config?.xai }))
          };
        case 'fal':
          return {
            id: 'fal',
            name: 'Fal',
            isConfigured: vi.fn(() => !!config?.fal),
            getModel: vi.fn(() => ({ model: 'fal-model' })),
            validateParameters: vi.fn(),
            getMetadata: vi.fn(() => ({ id: 'fal', configured: !!config?.fal }))
          };
        default:
          return null;
      }
    })
  }
}));

describe('Provider Factory', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe('createProviderManager', () => {
    it('should create a provider manager', () => {
      const config = { openai: 'test-key' };
      const manager = createProviderManager(config);

      expect(manager).toBeDefined();
      expect(typeof manager.getProvider).toBe('function');
      expect(typeof manager.isProviderConfigured).toBe('function');
    });

    it('should initialize with provided config', () => {
      const config = { openai: 'sk-test', google: 'gemini-test' };
      const manager = createProviderManager(config);

      expect(manager.isProviderConfigured('openai')).toBe(true);
      expect(manager.isProviderConfigured('google')).toBe(true);
      expect(manager.isProviderConfigured('xai')).toBe(false);
    });
  });

  describe('getProviderManager', () => {
    it('should return global instance', () => {
      const manager1 = getProviderManager();
      const manager2 = getProviderManager();

      expect(manager1).toBe(manager2);
    });

    it('should create new instance with config', () => {
      const config = { openai: 'test-key' };
      const manager = getProviderManager(config);

      expect(manager.isProviderConfigured('openai')).toBe(true);
    });
  });

  describe('Provider Manager', () => {
    let manager: any;

    beforeEach(() => {
      manager = createProviderManager({ openai: 'sk-test', google: 'gemini-test' });
    });

    describe('getProvider', () => {
      it('should return configured provider', () => {
        const provider = manager.getProvider('openai');

        expect(provider).toBeDefined();
        expect(provider.id).toBe('openai');
        expect(provider.name).toBe('OpenAI');
      });

      it('should cache provider instances', () => {
        const provider1 = manager.getProvider('openai');
        const provider2 = manager.getProvider('openai');

        expect(provider1).toBe(provider2);
      });

      it('should throw for unknown provider', () => {
        expect(() => manager.getProvider('unknown')).toThrow();
      });
    });

    describe('isProviderConfigured', () => {
      it('should return true for configured providers', () => {
        expect(manager.isProviderConfigured('openai')).toBe(true);
        expect(manager.isProviderConfigured('google')).toBe(true);
      });

      it('should return false for unconfigured providers', () => {
        expect(manager.isProviderConfigured('xai')).toBe(false);
        expect(manager.isProviderConfigured('fal')).toBe(false);
      });
    });

    describe('getConfiguredProviders', () => {
      it('should return list of configured providers', () => {
        const configured = manager.getConfiguredProviders();

        expect(configured).toContain('openai');
        expect(configured).toContain('google');
        expect(configured).not.toContain('xai');
        expect(configured).not.toContain('fal');
      });
    });

    describe('getProviderMetadata', () => {
      it('should return metadata for configured provider', () => {
        const metadata = manager.getProviderMetadata('openai');

        expect(metadata).toEqual({
          id: 'openai',
          configured: true
        });
      });

      it('should return null for unknown provider', () => {
        const metadata = manager.getProviderMetadata('unknown');

        expect(metadata).toBeNull();
      });
    });

    describe('getAllProviderMetadata', () => {
      it('should return metadata for all providers', () => {
        const metadata = manager.getAllProviderMetadata();

        expect(metadata.openai).toEqual({ id: 'openai', configured: true });
        expect(metadata.google).toEqual({ id: 'google', configured: true });
        expect(metadata.xai).toEqual({ id: 'xai', configured: false });
        expect(metadata.fal).toEqual({ id: 'fal', configured: false });
        expect(metadata).not.toHaveProperty('openrouter');
      });
    });

    describe('validateProviderParameters', () => {
      it('should delegate to provider validation', () => {
        const mockValidate = vi.fn();
        const provider = manager.getProvider('openai');
        provider.validateParameters = mockValidate;

        manager.validateProviderParameters('openai', { size: '1024x1024' });

        expect(mockValidate).toHaveBeenCalledWith({ size: '1024x1024' });
      });
    });

    describe('updateConfig', () => {
      it('should update configuration and clear cache', () => {
        // Get provider with current config
        const provider1 = manager.getProvider('openai');

        // Update config - remove openai, add xai
        manager.updateConfig({ xai: 'xai-key' });

        // Provider cache should be cleared
        const provider2 = manager.getProvider('openai');
        expect(provider1).not.toBe(provider2);

        // New config should be applied
        expect(manager.isProviderConfigured('xai')).toBe(true);
        expect(manager.isProviderConfigured('openai')).toBe(false);
      });
    });
  });
});
