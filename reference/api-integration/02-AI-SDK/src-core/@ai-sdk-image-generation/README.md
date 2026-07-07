# AI SDK Image Generation Library

A comprehensive, multi-provider image generation library built on the [AI SDK](https://github.com/vercel/ai), designed for production use with robust error handling, automatic fallbacks, and provider-agnostic parameter handling.

## Features

- **Multi-Provider Support**: OpenAI, Google, xAI, and Fal
- **Automatic Fallbacks**: Seamlessly switch providers when one fails
- **Parameter Validation**: Provider-specific parameter validation and normalization
- **Retry Logic**: Exponential backoff with configurable retry policies
- **Streaming Support**: Special handling for streaming models (Fal)
- **TypeScript**: Full TypeScript support with comprehensive type definitions
- **Zero Dependencies**: Only peer dependencies on AI SDK packages

## Installation

```bash
npm install @ai-sdk/image-generation
```

### Peer Dependencies

This library requires the following peer dependencies:

```bash
npm install ai @ai-sdk/openai @ai-sdk/google @ai-sdk/xai @ai-sdk/fal @fal-ai/client zod
```

## Quick Start

### Basic Usage

```typescript
import { generateImage } from '@ai-sdk/image-generation';

// Simple image generation
const result = await generateImage({
  prompt: 'A sunset over mountains',
  provider: 'openai',
  model: 'dall-e-3'
});

console.log(result.images); // Array of base64-encoded images
```

### Advanced Usage with Custom Configuration

```typescript
import { ImageGenerator } from '@ai-sdk/image-generation';

const generator = new ImageGenerator({
  apiKeys: {
    openai: process.env.OPENAI_API_KEY,
    google: process.env.GOOGLE_API_KEY
  },
  defaultProvider: 'openai',
  maxRetries: 5,
  debug: true
});

const result = await generator.generate({
  prompt: 'A cat wearing a hat',
  provider: 'openai',
  size: '1024x1024',
  n: 2
});
```

### Configuration Builder Pattern

```typescript
import { createConfigBuilder } from '@ai-sdk/image-generation';

const config = createConfigBuilder()
  .withEnvironmentKeys() // Load from environment variables
  .withDefaultProvider('google')
  .withDefaultModel('imagen-3.0-generate-002')
  .withMaxRetries(3)
  .withDebug(true)
  .build();

const generator = new ImageGenerator(config);
```

## API Reference

### Core Classes

#### `ImageGenerator`

Main class for image generation with configuration and advanced features.

```typescript
class ImageGenerator {
  constructor(config: ImageGeneratorConfig);

  async generate(request: ImageGenerationRequest): Promise<ImageGenerationResult>;
}
```

#### Configuration Options

```typescript
interface ImageGeneratorConfig {
  apiKeys?: {
    openai?: string;
    google?: string;
    xai?: string;
    fal?: string;
  };
  defaultProvider?: ImageProviderId;
  defaultModel?: string;
  defaultImageCount?: number;
  maxRetries?: number;
  timeout?: number;
  debug?: boolean;
}
```

#### Generation Request

```typescript
interface ImageGenerationRequest {
  prompt: string;                    // Required: Text prompt for generation
  provider?: ImageProviderId;        // Optional: Provider override
  modelId?: string;                  // Optional: Model override
  n?: number;                        // Optional: Number of images (1-10)
  size?: string;                     // Optional: Size for OpenAI (e.g., "1024x1024")
  aspectRatio?: string;              // Optional: Aspect ratio for Google/Fal (e.g., "16:9")
  providerOptions?: Record<string, unknown>; // Optional: Provider-specific options
  abortSignal?: AbortSignal;         // Optional: Cancellation support
  headers?: Record<string, string>;  // Optional: Custom headers
  seed?: number;                     // Optional: Reproducible generation
}
```

#### Generation Result

```typescript
interface ImageGenerationResult {
  images: string[];                        // Base64-encoded images
  warnings?: string[];                     // Provider warnings
  providerMetadata?: unknown;              // Provider-specific metadata
  provider?: string;                       // Provider used
  model?: string;                          // Model used
  durationMs?: number;                     // Generation duration
  retryCount?: number;                     // Number of retries attempted
}
```

### Provider Support

#### OpenAI
- **Models**: `dall-e-3`, `dall-e-2`, `gpt-image-1`, `gpt-image-1-mini`
- **Parameters**: `size` (e.g., "1024x1024", "1792x1024")
- **Max Images**: 1 per model

#### Google
- **Models**: `imagen-3.0-generate-002`, `gemini-2.5-flash-image-preview`
- **Parameters**: `aspectRatio` (e.g., "16:9", "1:1")
- **Max Images**: Varies by model

#### xAI
- **Models**: `grok-2-image`
- **Parameters**: None (fixed 1024x768 resolution)
- **Max Images**: 2

#### Fal
- **Models**: `fal-ai/flux/dev`, `fal-ai/flux-pro/v1.1-ultra`, `fal-ai/fast-sdxl`, etc.
- **Parameters**: `aspectRatio` (e.g., "16:9", "1:1")
- **Streaming**: Special support for `fal-ai/flux-krea-lora/stream`

### Error Handling

The library provides comprehensive error handling with typed errors:

```typescript
import { ImageGenerationError } from '@ai-sdk/image-generation';

try {
  const result = await generateImage(request);
} catch (error) {
  if (ImageGenerationError.isInstance(error)) {
    console.log('Error code:', error.code);
    console.log('Provider:', error.provider);
    console.log('Retryable:', error.retryable);
    console.log('Cause:', error.cause);
  }
}
```

### Registry and Model Information

```typescript
import { getImageProviders, getImageModels, isImageProviderSupported } from '@ai-sdk/image-generation';

// Get all providers
const providers = getImageProviders();

// Get models for a provider
const openaiModels = getImageModels('openai');

// Check provider support
const isSupported = isImageProviderSupported('openai');
```

## Environment Variables

The library automatically loads API keys from environment variables:

- `OPENAI_API_KEY` or `APP_OPENAI_API_KEY` - OpenAI API key
- `GEMINI_API_KEY` or `GOOGLE_API_KEY` - Google API key
- `XAI_API_KEY` or `GROK_API_KEY` - xAI API key
- `FAL_API_KEY` - Fal API key

## Examples

### Basic Image Generation

```typescript
import { generateImage } from '@ai-sdk/image-generation';

const result = await generateImage({
  prompt: 'A futuristic city at night',
  provider: 'openai',
  model: 'dall-e-3',
  size: '1792x1024'
});

// Save or display the image
const imageData = result.images[0]; // base64 string
```

### Batch Generation with Error Handling

```typescript
import { ImageGenerator, ImageGenerationError } from '@ai-sdk/image-generation';

const generator = new ImageGenerator({
  apiKeys: { openai: process.env.OPENAI_API_KEY },
  maxRetries: 3
});

const prompts = [
  'A red sports car',
  'A blue ocean wave',
  'A green forest path'
];

for (const prompt of prompts) {
  try {
    const result = await generator.generate({
      prompt,
      n: 2
    });
    console.log(`Generated ${result.images.length} images for: ${prompt}`);
  } catch (error) {
    if (ImageGenerationError.isInstance(error)) {
      console.error(`Failed to generate images for "${prompt}": ${error.message}`);
    }
  }
}
```

### Streaming Generation (Fal Only)

```typescript
import { ImageGenerator } from '@ai-sdk/image-generation';

const generator = new ImageGenerator({
  apiKeys: { fal: process.env.FAL_API_KEY }
});

// Note: Only works with streaming-enabled Fal models
const result = await generator.generate({
  prompt: 'An abstract painting',
  provider: 'fal',
  model: 'fal-ai/flux-krea-lora/stream'
});
```

### Custom Provider Configuration

```typescript
import { ImageGenerator } from '@ai-sdk/image-generation';

const generator = new ImageGenerator({
  apiKeys: {
    openai: 'sk-...',
    google: 'AIza...'
  },
  defaultProvider: 'google',
  defaultModel: 'imagen-3.0-generate-002',
  providerOptions: {
    google: { safetySettings: [...] }
  }
});
```

## Advanced Features

### Automatic Provider Fallback

The library automatically falls back to alternative providers if the primary provider fails:

```typescript
// Will try OpenAI first, then fall back to Google if OpenAI fails
const generator = new ImageGenerator({
  apiKeys: {
    openai: process.env.OPENAI_API_KEY,
    google: process.env.GOOGLE_API_KEY
  },
  defaultProvider: 'openai'
});
```

### Custom Retry Policies

```typescript
import { createRetryPolicy } from '@ai-sdk/image-generation';

const customRetryPolicy = createRetryPolicy({
  maxRetries: 5,
  initialDelay: 2000,
  maxDelay: 60000,
  backoffMultiplier: 2
});
```

### Cancellation Support

```typescript
const abortController = new AbortController();

const generationPromise = generateImage({
  prompt: 'A landscape',
  abortSignal: abortController.signal
});

// Cancel after 5 seconds
setTimeout(() => abortController.abort(), 5000);
```

## Contributing

This library is extracted from a production codebase and includes battle-tested implementations. To contribute:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure TypeScript compilation passes
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history and breaking changes.
