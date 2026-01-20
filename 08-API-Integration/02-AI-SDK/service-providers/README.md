# AI SDK Service Provider Reference Documentation

This directory contains reference documentation for various AI SDK providers. These files are copied from the [official Vercel AI SDK documentation](https://sdk.vercel.ai/docs) for offline reference and workflow context.

## Purpose

These files serve as:
- **Quick reference** for provider-specific configuration and options
- **Offline documentation** when working without internet access
- **Workflow context** when planning integrations

## Important Notes

> ⚠️ **For the latest information**, always refer to the [official AI SDK documentation](https://sdk.vercel.ai/docs).  
> These files may become outdated as the SDK evolves.

> 📝 **These are reference docs, not workflow guides.** For integration workflows, see:
> - [`../ai-sdk-integration-v2.md`](../ai-sdk-integration-v2.md) - Integration planning guide
> - [`../../01-genkit/genkit-integration-guide.md`](../../01-genkit/genkit-integration-guide.md) - Genkit integration guide

## Available Providers

- **[OpenAI](./openai.md)** - OpenAI models (GPT-4, GPT-5, etc.)
- **[Google](./google.md)** - Google Generative AI (Gemini models)
- **[Fal](./fal.md)** - Fal AI (image generation, transcription, speech)
- **[OpenRouter](./openrouter.md)** - OpenRouter (unified API for multiple providers)
- **[xAI](./xai.md)** - xAI Grok models

## Usage

Each provider file includes:
- Setup and installation instructions
- Provider instance configuration
- Model capabilities and options
- Code examples
- Provider-specific features

## When to Use

- **Quick lookup** for provider options and configuration
- **Understanding capabilities** of a specific provider
- **Offline reference** during development
- **Comparing providers** for feature support

## Contributing

If you notice these files are outdated:
1. Check the [official AI SDK docs](https://sdk.vercel.ai/docs) for updates
2. Update the relevant provider file
3. Add a note about when it was last updated

---

*Last updated: 2026-01-20*
