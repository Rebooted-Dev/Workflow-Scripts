/**
 * Unit tests for retry utilities
 */

import { describe, it, expect, vi } from 'vitest';
import {
  createRetryPolicy,
  withRetry,
  withTimeout,
  calculateRetryDelay,
  isRateLimitError,
  createRateLimitRetryPolicy
} from '../../../src/utils/retry.js';
import { ImageGenerationError } from '../../../src/core/types.js';

describe('Retry Utilities', () => {

  describe('calculateRetryDelay', () => {
    it('should calculate exponential backoff delay', () => {
      const policy = {
        initialDelay: 1000,
        backoffMultiplier: 2,
        maxDelay: 30000,
        jitterFactor: 0
      };

      expect(calculateRetryDelay(1, policy)).toBe(1000); // 1000 * 2^0 = 1000
      expect(calculateRetryDelay(2, policy)).toBe(2000); // 1000 * 2^1 = 2000
      expect(calculateRetryDelay(3, policy)).toBe(4000); // 1000 * 2^2 = 4000
    });

    it('should respect max delay', () => {
      const policy = {
        initialDelay: 1000,
        backoffMultiplier: 2,
        maxDelay: 5000,
        jitterFactor: 0
      };

      expect(calculateRetryDelay(10, policy)).toBe(5000); // Capped at maxDelay
    });

    it('should apply jitter', () => {
      const policy = {
        initialDelay: 1000,
        backoffMultiplier: 1,
        maxDelay: 10000,
        jitterFactor: 0.1
      };

      // With jitter, results should vary slightly
      const delays = Array.from({ length: 10 }, () => calculateRetryDelay(1, policy));
      const min = Math.min(...delays);
      const max = Math.max(...delays);

      expect(min).toBeGreaterThan(900); // 1000 * (1 - 0.1)
      expect(max).toBeLessThan(1100); // 1000 * (1 + 0.1)
    });
  });

  describe('withRetry', () => {
    it('should return result on first success', async () => {
      const operation = vi.fn().mockResolvedValue('success');

      const result = await withRetry(operation, createRetryPolicy({ maxRetries: 3 }));

      expect(result.result).toBe('success');
      expect(result.attempts).toBe(1);
      expect(operation).toHaveBeenCalledTimes(1);
    });

    it('should retry on failure and succeed', async () => {
      const operation = vi.fn()
        .mockRejectedValueOnce(new Error('Network timeout 1'))
        .mockRejectedValueOnce(new Error('Network timeout 2'))
        .mockResolvedValueOnce('success');

      const onRetry = vi.fn();
      const result = await withRetry(operation, createRetryPolicy({ maxRetries: 3 }), onRetry);

      expect(result.result).toBe('success');
      expect(result.attempts).toBe(3);
      expect(operation).toHaveBeenCalledTimes(3);
      expect(onRetry).toHaveBeenCalledTimes(2);
    });

    it('should stop after max retries', async () => {
      const operation = vi.fn().mockRejectedValue(new Error('Network timeout'));

      await expect(withRetry(operation, createRetryPolicy({ maxRetries: 2 }))).rejects.toThrow('Network timeout');
      expect(operation).toHaveBeenCalledTimes(3); // Initial + 2 retries
    });

    it('should not retry generic non-transient errors', async () => {
      const operation = vi.fn().mockRejectedValue(new Error('invalid api key'));

      await expect(withRetry(operation, createRetryPolicy({ maxRetries: 3 }))).rejects.toThrow('invalid api key');
      expect(operation).toHaveBeenCalledTimes(1);
    });

    it('should not retry if error is not retryable', async () => {
      const notRetryableError = new ImageGenerationError(
        'Not retryable',
        'INVALID_REQUEST',
        { retryable: false }
      );
      const operation = vi.fn().mockRejectedValue(notRetryableError);

      await expect(withRetry(operation, createRetryPolicy({ maxRetries: 3 }))).rejects.toThrow('Not retryable');
      expect(operation).toHaveBeenCalledTimes(1); // No retries
    });

    it('should call onRetry callback with correct parameters', async () => {
      const operation = vi.fn()
        .mockRejectedValueOnce(new Error('Network timeout'))
        .mockResolvedValueOnce('success');

      const onRetry = vi.fn();
      await withRetry(operation, createRetryPolicy({ maxRetries: 3 }), onRetry);

      expect(onRetry).toHaveBeenCalledWith(
        expect.any(Error),
        1, // attempt
        expect.any(Number) // delay
      );
    });
  });

  describe('withTimeout', () => {
    it('should return result if operation completes in time', async () => {
      const operation = vi.fn().mockResolvedValue('success');

      const result = await withTimeout(operation, 1000);

      expect(result).toBe('success');
    });

    it('should throw timeout error if operation takes too long', async () => {
      const operation = vi.fn(() => new Promise(resolve => setTimeout(resolve, 200)));

      await expect(withTimeout(operation, 100, new Error('Custom timeout')))
        .rejects.toThrow('Custom timeout');
    });
  });

  describe('createRetryPolicy', () => {
    it('should create policy with defaults', () => {
      const policy = createRetryPolicy({ maxRetries: 5 });

      expect(policy.maxRetries).toBe(5);
      expect(policy.initialDelay).toBe(1000);
      expect(policy.backoffMultiplier).toBe(2);
      expect(policy.jitterFactor).toBe(0.1);
      expect(typeof policy.isRetryable).toBe('function');
    });

    it('should override defaults', () => {
      const policy = createRetryPolicy({
        maxRetries: 10,
        initialDelay: 500,
        backoffMultiplier: 3,
        jitterFactor: 0.2
      });

      expect(policy.maxRetries).toBe(10);
      expect(policy.initialDelay).toBe(500);
      expect(policy.backoffMultiplier).toBe(3);
      expect(policy.jitterFactor).toBe(0.2);
    });
  });

  describe('isRateLimitError', () => {
    it('should identify rate limit errors', () => {
      const rateLimitError = new ImageGenerationError(
        'Rate limit exceeded',
        'RATE_LIMIT_EXCEEDED',
        { retryable: true }
      );

      expect(isRateLimitError(rateLimitError)).toBe(true);
    });

    it('should identify HTTP 429 errors', () => {
      const httpError = { status: 429 };

      expect(isRateLimitError(httpError)).toBe(true);
    });

    it('should identify rate limit in message', () => {
      const messageError = new Error('Rate limit exceeded, please try again later');

      expect(isRateLimitError(messageError)).toBe(true);
    });

    it('should return false for non-rate-limit errors', () => {
      const otherError = new Error('Network timeout');

      expect(isRateLimitError(otherError)).toBe(false);
    });
  });

  describe('createRateLimitRetryPolicy', () => {
    it('should create rate-limit-aware policy', () => {
      const policy = createRateLimitRetryPolicy({ maxRetries: 5 });

      expect(policy.maxRetries).toBe(5);
      expect(policy.initialDelay).toBe(2000); // Higher for rate limits
      expect(policy.maxDelay).toBe(60000); // Higher max delay

      // Should retry rate limit errors
      expect(policy.isRetryable(new Error('Rate limit exceeded'))).toBe(true);
    });

    it('should retry explicit transient status and code errors', () => {
      const policy = createRetryPolicy();

      expect(policy.isRetryable({ status: 429 })).toBe(true);
      expect(policy.isRetryable({ response: { status: 503 } })).toBe(true);
      expect(policy.isRetryable({ code: 'ECONNRESET' })).toBe(true);
      expect(policy.isRetryable({ code: 'EINVAL' })).toBe(false);
    });
  });

  describe('Integration with ImageGenerationError', () => {
    it('should handle ImageGenerationError retryable flag', async () => {
      const retryableError = new ImageGenerationError(
        'Server error',
        'SERVER_ERROR',
        { retryable: true }
      );

      const notRetryableError = new ImageGenerationError(
        'Invalid request',
        'INVALID_REQUEST',
        { retryable: false }
      );

      const policy = createRetryPolicy();

      expect(policy.isRetryable(retryableError)).toBe(true);
      expect(policy.isRetryable(notRetryableError)).toBe(false);
    });
  });
});
