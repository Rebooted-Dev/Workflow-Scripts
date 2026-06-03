# API Integration Workflows

This directory contains workflows and guides for integrating various AI APIs and services into your projects.

## Quick Start

**Which guide should I use?**

- **Integrating Google Genkit?** → Start with [`01-genkit/genkit-integration-guide.md`](./01-genkit/genkit-integration-guide.md)
- **Using Vercel AI SDK?** → See [`02-AI-SDK/ai-sdk-integration-v2.md`](./02-AI-SDK/ai-sdk-integration-v2.md)
- **Higgsfield MCP connect / auth / reconnect?** → Use [`03-higgsfield-mcp/higgsfield-mcp-connect-auth-reconnect.md`](./03-higgsfield-mcp/higgsfield-mcp-connect-auth-reconnect.md)
- **Need provider reference docs?** → Check [`02-AI-SDK/service-providers/`](./02-AI-SDK/service-providers/)
- **Evaluating token caching?** → Read [`gemini-token-caching-analysis.md`](./gemini-token-caching-analysis.md)

## Directory Structure

```
08-API-Integration/
├── README.md (this file)
├── 01-genkit/
│   └── genkit-integration-guide.md - Complete Genkit integration guide
├── 02-AI-SDK/
│   ├── ai-sdk-integration-v2.md - Vercel AI SDK integration plan
│   └── service-providers/ - Reference documentation for AI SDK providers
│       ├── README.md - Provider documentation overview
│       ├── fal.md - Fal AI provider
│       ├── google.md - Google Generative AI provider
│       ├── openai.md - OpenAI provider
│       ├── openrouter.md - OpenRouter provider
│       └── xai.md - xAI Grok provider
├── 03-higgsfield-mcp/
│   ├── README.md - Higgsfield MCP workflow index
│   └── higgsfield-mcp-connect-auth-reconnect.md - Connect, auth, reconnect diagnostics
└── gemini-token-caching-analysis.md - Token caching feasibility analysis
```

## Guides Overview

### Genkit Integration

**File:** [`01-genkit/genkit-integration-guide.md`](./01-genkit/genkit-integration-guide.md)

A comprehensive guide covering:
- Planning and critique of integration approach
- Step-by-step implementation instructions
- Environment configuration
- Feature flag setup for gradual rollout
- Completion status and troubleshooting

**When to use:** When migrating from direct SDK usage to Genkit for AI model orchestration.

### AI SDK Integration

**File:** [`02-AI-SDK/ai-sdk-integration-v2.md`](./02-AI-SDK/ai-sdk-integration-v2.md)

Integration plan for adopting the Vercel AI SDK:
- Architecture overview
- Phase-by-phase implementation plan
- UI adapter patterns
- Serverless handler setup
- Testing and rollout strategies

**When to use:** When modernizing AI integration with Vercel AI SDK for better streaming, security, and tool support.

**Note:** This guide contains project-specific references to "rbc-bible-explorer" as an example. Adapt the concepts to your own project structure.

### Service Provider Reference

**Directory:** [`02-AI-SDK/service-providers/`](./02-AI-SDK/service-providers/)

Reference documentation for various AI SDK providers. These files are copied from the official AI SDK documentation for offline reference and workflow context.

**When to use:** When you need quick reference for provider-specific configuration, options, or capabilities.

**Note:** For the latest information, see the [official AI SDK documentation](https://sdk.vercel.ai/docs).

### Higgsfield MCP Connect, Auth, and Reconnect

**File:** [`03-higgsfield-mcp/higgsfield-mcp-connect-auth-reconnect.md`](./03-higgsfield-mcp/higgsfield-mcp-connect-auth-reconnect.md)

Structured workflow for diagnosing and recovering Higgsfield MCP failures:

- Separates discovery auth (`tools/list`) from execution auth (`generate_image` / `get_cost`)
- CLI `--auth-check` probe and app `/api/higgsfield-mcp/status` + `/reconnect`
- Stale `~/.mcp-auth/` recovery and post-reconnect triage (including Gemini dunning red herrings)

**When to use:** When MCP image generation fails with expired tokens, list-only probe false confidence, or reconnect does not restore images.

**Canonical host reference:** `project/research/2026-06-03-higgsfield-mcp-connect-auth-reconnect-technical-note.md` in Podcast Creative Studio AI.

### Token Caching Analysis

**File:** [`gemini-token-caching-analysis.md`](./gemini-token-caching-analysis.md)

A cost-benefit analysis of implementing token caching for Gemini API calls. This is a decision-making document, not a workflow guide.

**When to use:** When evaluating whether to implement caching for AI API responses to reduce costs and improve performance.

## Decision Tree

```
Need to integrate an AI API?
│
├─ Using Google Genkit?
│  └─→ 01-genkit/genkit-integration-guide.md
│
├─ Using Vercel AI SDK?
│  ├─ Need integration plan?
│  │  └─→ 02-AI-SDK/ai-sdk-integration-v2.md
│  │
│  └─ Need provider reference?
│     └─→ 02-AI-SDK/service-providers/
│
├─ Higgsfield MCP auth or reconnect issues?
│  └─→ 03-higgsfield-mcp/higgsfield-mcp-connect-auth-reconnect.md
│
├─ Evaluating caching strategy?
│  └─→ gemini-token-caching-analysis.md
│
└─ Need general guidance?
   └─→ Start with this README and explore based on your needs
```

## Best Practices

1. **Start with Planning**: Review the integration plan and critique sections before implementation
2. **Use Feature Flags**: Always implement new API integrations behind feature flags for safe rollout
3. **Maintain Backward Compatibility**: Keep existing implementations working while adding new paths
4. **Test Thoroughly**: Verify both old and new paths work before enabling new integrations
5. **Document Changes**: Update changelogs and documentation when enabling new features

## Related Workflows

- [Project Setup](../00-project-setup/) - Initial project configuration
- [Deployment](../07-deployment/) - Deployment workflows
- [Code Review](../05-review-audit/) - Code quality review

## Maintenance

This directory was optimized on 2026-01-20. For optimization history and details, see `OPTIMIZATION_HISTORY.md`.

---

*Last updated: 2026-06-03*
