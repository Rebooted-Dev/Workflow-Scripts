#!/usr/bin/env tsx

/**
 * Test FAL integration with real API key
 */

import { ImageGenerator, getImageProviders, getImageModels, isImageProviderSupported } from './src/index.js';

// Load environment variables
import dotenv from 'dotenv';
dotenv.config({ path: '~/.env' });

async function testFalIntegration() {
  console.log('🎨 Testing FAL Integration with Real API Key\n');

  try {
    // Step 1: Check provider registry
    console.log('📋 Step 1: Provider Registry Check');
    const providers = getImageProviders();
    const falProvider = providers.find(p => p.id === 'fal');

    if (!falProvider) {
      console.error('❌ FAL provider not found in registry');
      return;
    }

    console.log(`✅ FAL provider found: ${falProvider.name}`);
    console.log(`   Supported: ${isImageProviderSupported('fal') ? '✅' : '❌'}`);

    const falModels = getImageModels('fal');
    console.log(`   Available models: ${falModels.map(m => m.name).join(', ')}`);

    // Step 2: Configuration test
    console.log('\n⚙️ Step 2: Configuration Test');

    const config = {
      apiKeys: {
        fal: process.env.FAL_API_KEY
      },
      defaultProvider: 'fal', // Explicitly set FAL as default
      maxRetries: 0 // Disable retries to see the actual FAL error
    };

    console.log(`   FAL API Key configured: ${config.apiKeys?.fal ? '✅' : '❌'}`);

    if (!config.apiKeys?.fal) {
      console.error('❌ FAL API key not found in environment');
      return;
    }

    // Step 3: Initialize generator
    console.log('\n🚀 Step 3: Initialize Image Generator');
    const generator = new ImageGenerator(config);
    console.log('✅ ImageGenerator created successfully');

    // Debug: Check provider configuration
    console.log('   Debug - Provider configuration:');
    console.log(`   FAL configured: ${generator.providerManager?.isProviderConfigured('fal')}`);
    console.log(`   OpenAI configured: ${generator.providerManager?.isProviderConfigured('openai')}`);
    console.log(`   Configured providers: ${generator.providerManager?.getConfiguredProviders()}`);

    // Step 4: Test simple generation
    console.log('\n🎨 Step 4: Test Image Generation');

    const testRequest = {
      prompt: 'A simple blue circle on a white background',
      provider: 'fal',
      modelId: 'fal-ai/flux/dev',
      aspectRatio: '1:1',
      n: 1
    };

    console.log('   Request:', {
      prompt: testRequest.prompt,
      provider: testRequest.provider,
      model: testRequest.modelId,
      aspectRatio: testRequest.aspectRatio,
      count: testRequest.n
    });

    // Test validation
    const { validateAndNormalizeRequest } = await import('./src/utils/validation.js');
    const validation = validateAndNormalizeRequest(testRequest);
    console.log('   Validation result:', validation.success ? '✅ Passed' : '❌ Failed');
    if (validation.success) {
      console.log('   Normalized provider:', validation.data.provider);
      console.log('   Normalized model:', validation.data.modelId);
    } else {
      console.log('   Validation errors:', validation.errors);
      return;
    }

    console.log('\n⏳ Generating image... (this may take a few seconds)');

    const startTime = Date.now();
    try {
      const result = await generator.generate(testRequest);

      const duration = Date.now() - startTime;

      console.log('\n✅ Generation completed!');
      console.log(`   Duration: ${duration}ms`);
      console.log(`   Provider used: ${result.provider}`);
      console.log(`   Model used: ${result.model}`);
      console.log(`   Images generated: ${result.images.length}`);

      if (result.images.length > 0) {
        console.log('   Image data sample:', result.images[0].substring(0, 50) + '...');
        console.log('   Image size:', result.images[0].length, 'characters');
      }

      if (result.warnings && result.warnings.length > 0) {
        console.log('   Warnings:', result.warnings);
      }

    } catch (error) {
      const duration = Date.now() - startTime;

      console.log('\n❌ Generation failed with error details:');
      console.log('Error type:', error.constructor.name);
      console.log('Error message:', error.message);
      if (error.code) console.log('Error code:', error.code);
      if (error.cause) {
        console.log('Error cause:', error.cause);
        if (error.cause.code) console.log('Cause code:', error.cause.code);
      }

      console.log('\n❌ FAL Integration Test: FAILED');
      console.log('\n🔧 Troubleshooting Tips:');
      console.log('   1. Check your FAL API key is valid and has credits');
      console.log('   2. Verify the API key format (should contain a colon)');
      console.log('   3. Check your internet connection');
      console.log('   4. Try a different model if this one is temporarily unavailable');
    }

  } catch (error) {
    console.error('\n❌ FAL Integration Test: FAILED');
    console.error('Error:', error.message);

    if (error.code) {
      console.error('Error code:', error.code);
    }

    if (error.response) {
      console.error('Response status:', error.response.status);
      console.error('Response data:', error.response.data);
    }

    // Provide helpful troubleshooting
    console.log('\n🔧 Troubleshooting Tips:');
    console.log('   1. Check your FAL API key is valid and has credits');
    console.log('   2. Verify the API key format (should contain a colon)');
    console.log('   3. Check your internet connection');
    console.log('   4. Try a different model if this one is temporarily unavailable');
  }
}

// Run the test
testFalIntegration();
