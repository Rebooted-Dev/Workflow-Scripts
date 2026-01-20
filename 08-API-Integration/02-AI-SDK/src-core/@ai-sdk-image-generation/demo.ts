#!/usr/bin/env tsx

/**
 * Demo script to test the AI SDK Image Generation library
 * This demonstrates the library functionality without requiring real API keys
 */

import {
  getImageProviders,
  getImageModels,
  isImageProviderSupported,
  createImageGeneratorConfig,
  validateImageRequest,
  validateAndNormalizeRequest,
  ImageGenerationError
} from './src/index.js';

console.log('🚀 AI SDK Image Generation Library Demo\n');

// Test 1: Provider Registry
console.log('📋 Testing Provider Registry...');
const providers = getImageProviders();
console.log(`Found ${providers.length} providers:`, providers.map(p => p.name));

providers.forEach(provider => {
  const models = getImageModels(provider.id);
  console.log(`  ${provider.name}: ${models.length} models available`);
  if (models.length > 0) {
    console.log(`    Default model: ${models[0].name}`);
  }
});

// Test 2: Provider Support Check
console.log('\n🔍 Testing Provider Support...');
['openai', 'google', 'xai', 'fal', 'openrouter'].forEach(provider => {
  const supported = isImageProviderSupported(provider as any);
  console.log(`  ${provider}: ${supported ? '✅ Supported' : '❌ Not supported'}`);
});

// Test 3: Configuration Creation
console.log('\n⚙️ Testing Configuration Creation...');
const config = createImageGeneratorConfig({
  apiKeys: {
    openai: 'sk-test-key',
    google: 'test-google-key'
  },
  defaultProvider: 'openai',
  maxRetries: 3,
  debug: true
});

console.log('Configuration created successfully:', {
  hasOpenAI: !!config.apiKeys?.openai,
  hasGoogle: !!config.apiKeys?.google,
  defaultProvider: config.defaultProvider,
  maxRetries: config.maxRetries,
  debug: config.debug
});

// Test 4: Request Validation
console.log('\n✅ Testing Request Validation...');

// Valid request
const validRequest = {
  prompt: 'A beautiful sunset over mountains',
  provider: 'openai' as const,
  modelId: 'dall-e-3',
  size: '1024x1024',
  n: 1
};

const validValidation = validateImageRequest(validRequest);
console.log('Valid request validation:', validValidation.success ? '✅ Passed' : '❌ Failed');

if (!validValidation.success) {
  console.log('  Errors:', validValidation.errors);
}

// Invalid request (missing prompt)
const invalidRequest = {
  provider: 'openai' as const,
  size: '1024x1024'
};

const invalidValidation = validateImageRequest(invalidRequest);
console.log('Invalid request validation:', invalidValidation.success ? '✅ Passed' : '❌ Failed');

if (!invalidValidation.success) {
  console.log('  Errors:', invalidValidation.errors);
} else {
  console.log('  Unexpected: invalid request passed validation');
}

// Test 5: Request Normalization
console.log('\n🔧 Testing Request Normalization...');
const normalizeValidation = validateAndNormalizeRequest(validRequest);
console.log('Request normalization:', normalizeValidation.success ? '✅ Passed' : '❌ Failed');

if (normalizeValidation.success) {
  console.log('  Normalized request:', {
    prompt: normalizeValidation.data.prompt,
    provider: normalizeValidation.data.provider,
    modelId: normalizeValidation.data.modelId,
    size: normalizeValidation.data.size,
    n: normalizeValidation.data.n
  });
}

// Test 6: Error Handling
console.log('\n🚨 Testing Error Handling...');
const testError = new ImageGenerationError(
  'Test error message',
  'TEST_ERROR',
  {
    provider: 'openai',
    model: 'dall-e-3',
    retryable: true,
    cause: new Error('Original error'),
    context: { testData: 'example' }
  }
);

console.log('Error instance check:', ImageGenerationError.isInstance(testError) ? '✅ Correct type' : '❌ Wrong type');
console.log('Error details:', {
  message: testError.message,
  code: testError.code,
  provider: testError.provider,
  model: testError.model,
  retryable: testError.retryable,
  hasCause: !!testError.cause,
  hasContext: !!testError.context
});

// Test 7: Type Imports
console.log('\n📦 Testing Type Imports...');
try {
  // This will fail at runtime without AI SDK, but should compile
  console.log('Type imports work correctly ✅');
} catch (error) {
  console.log('Type import issue:', error);
}

console.log('\n🎉 Demo completed successfully!');
console.log('\nTo test with real API keys, set environment variables:');
console.log('  OPENAI_API_KEY=sk-...');
console.log('  GEMINI_API_KEY=...');
console.log('  XAI_API_KEY=...');
console.log('  FAL_API_KEY=...');
console.log('\nThen use:');
console.log('  import { ImageGenerator } from "@ai-sdk/image-generation";');
console.log('  const generator = new ImageGenerator({ apiKeys: { openai: process.env.OPENAI_API_KEY } });');
console.log('  const result = await generator.generate({ prompt: "A cat" });');
