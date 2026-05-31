/**
 * Retry logic and policies for image generation
 */

import { ImageGenerationError } from '../core/types.js';

/**
 * Retry policy configuration
 */
export interface RetryPolicy {
  /** Maximum number of retry attempts */
  maxRetries: number;
  /** Initial delay between retries in milliseconds */
  initialDelay: number;
  /** Maximum delay between retries in milliseconds */
  maxDelay: number;
  /** Backoff multiplier */
  backoffMultiplier: number;
  /** Jitter factor (0-1) to randomize delays */
  jitterFactor: number;
  /** Function to determine if an error is retryable */
  isRetryable: (error: unknown) => boolean;
}

/**
 * Default retry policy for image generation
 */
export const defaultRetryPolicy: RetryPolicy = {
  maxRetries: 3,
  initialDelay: 1000, // 1 second
  maxDelay: 30000, // 30 seconds
  backoffMultiplier: 2,
  jitterFactor: 0.1,
  isRetryable: (error: unknown): boolean => {
    if (error instanceof ImageGenerationError) {
      return error.retryable;
    }

    // Check for custom error with retryable flag
    if (error && typeof error === 'object' && 'retryable' in error) {
      return (error as any).retryable === true;
    }

    // Check for common retryable HTTP errors
    if (error && typeof error === 'object') {
      const anyError = error as any;
      const status = anyError.status || anyError.response?.status;
      if (status) {
        if (typeof status === 'number') {
          return status >= 500 || status === 429;
        }
        return status === 'ECONNRESET' || status === 'ETIMEDOUT';
      }

      const code = anyError.code;
      if (typeof code === 'string') {
        return ['ECONNRESET', 'ETIMEDOUT', 'ENOTFOUND', 'ECONNREFUSED', 'EAI_AGAIN'].includes(code);
      }
    }

    // Retry on network-related errors
    const message = error instanceof Error ? error.message : String(error);
    const retryableMessages = [
      'timeout',
      'network',
      'connection',
      'ECONNRESET',
      'ETIMEDOUT',
      'ENOTFOUND',
      'rate limit'
    ];

    return retryableMessages.some(msg => message.toLowerCase().includes(msg.toLowerCase()));
  }
};

/**
 * Create a custom retry policy
 */
export function createRetryPolicy(options: Partial<RetryPolicy>): RetryPolicy {
  return { ...defaultRetryPolicy, ...options };
}

/**
 * Calculate delay for a retry attempt with exponential backoff and jitter
 */
export function calculateRetryDelay(
  attempt: number,
  policy: RetryPolicy
): number {
  const exponentialDelay = policy.initialDelay * Math.pow(policy.backoffMultiplier, attempt - 1);
  const delayWithJitter = exponentialDelay * (1 + (Math.random() - 0.5) * policy.jitterFactor * 2);
  return Math.min(delayWithJitter, policy.maxDelay);
}

/**
 * Execute a function with retry logic
 */
export async function withRetry<T>(
  operation: () => Promise<T>,
  policy: RetryPolicy = defaultRetryPolicy,
  onRetry?: (error: unknown, attempt: number, delay: number) => void
): Promise<{ result: T; attempts: number }> {
  let lastError: unknown;

  for (let attempt = 1; attempt <= policy.maxRetries + 1; attempt++) {
    try {
      const result = await operation();
      return { result, attempts: attempt };
    } catch (error) {
      lastError = error;

      // Don't retry on the last attempt
      if (attempt > policy.maxRetries) {
        break;
      }

      // Check if error is retryable
      if (!policy.isRetryable(error)) {
        break;
      }

      // Calculate delay and wait
      const delay = calculateRetryDelay(attempt, policy);
      if (onRetry) {
        onRetry(error, attempt, delay);
      }

      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }

  // All retries exhausted
  throw lastError;
}

/**
 * Execute an operation with timeout
 */
export async function withTimeout<T>(
  operation: () => Promise<T>,
  timeoutMs: number,
  timeoutError: Error = new Error(`Operation timed out after ${timeoutMs}ms`)
): Promise<T> {
  return new Promise((resolve, reject) => {
    const timeoutId = setTimeout(() => {
      reject(timeoutError);
    }, timeoutMs);

    operation()
      .then(result => {
        clearTimeout(timeoutId);
        resolve(result);
      })
      .catch(error => {
        clearTimeout(timeoutId);
        reject(error);
      });
  });
}

/**
 * Combine retry and timeout logic
 */
export async function withRetryAndTimeout<T>(
  operation: () => Promise<T>,
  policy: RetryPolicy = defaultRetryPolicy,
  timeoutMs: number = 60000,
  onRetry?: (error: unknown, attempt: number, delay: number) => void
): Promise<{ result: T; attempts: number }> {
  return withRetry(
    () => withTimeout(operation, timeoutMs),
    policy,
    onRetry
  );
}

/**
 * Check if an error indicates a rate limit
 */
export function isRateLimitError(error: unknown): boolean {
  // Check for custom error with rate limit code
  if (error && typeof error === 'object' && 'code' in error) {
    return (error as any).code === 'RATE_LIMIT_EXCEEDED';
  }

  if (error && typeof error === 'object') {
    const anyError = error as any;
    const status = anyError.status || anyError.response?.status;
    if (status === 429) {
      return true;
    }
  }

  const message = error instanceof Error ? error.message : String(error);
  return message.toLowerCase().includes('rate limit') ||
         message.toLowerCase().includes('too many requests');
}

/**
 * Create a rate limit aware retry policy
 */
export function createRateLimitRetryPolicy(
  basePolicy: Partial<RetryPolicy> = {}
): RetryPolicy {
  return createRetryPolicy({
    ...basePolicy,
    // Longer initial delay for rate limits
    initialDelay: basePolicy.initialDelay || 2000,
    // Higher max delay for rate limits
    maxDelay: basePolicy.maxDelay || 60000,
    // Check for rate limit errors specifically
    isRetryable: (error: unknown): boolean => {
      return defaultRetryPolicy.isRetryable(error) || isRateLimitError(error);
    }
  });
}
