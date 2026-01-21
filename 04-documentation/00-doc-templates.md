# Documentation Templates

Use these templates when generating or updating `README.md` and `docs/` content.

Guidelines:
- Keep headings consistent so docs are easy to scan.
- Include "not applicable" notes explicitly instead of guessing.
- Prefer source-backed statements; where useful, include file paths for key claims.

## Root README Template (`README.md`)

```markdown
# <Project Name>

## What This Is

## Quick Start

## Configuration

## Common Commands

## Project Structure

## Documentation
- See `docs/README.md`.

## Contributing

## License
```

## Documentation Index Template (`docs/README.md`)

```markdown
# Documentation

## Start Here

## For Users

## For Developers

## For Maintainers

## Glossary
```

## Subdirectory Index Template (`docs/<area>/README.md`)

```markdown
# <Area> Documentation

## What’s Here

## Key Documents

## See Also
```

## User Manual Template (`docs/user-manual.md`)

```markdown
# User Manual

## Who This Is For

## What You Can Do

## Common Workflows

## Troubleshooting

## FAQ
```

## Systems Architecture Template (`docs/architecture/systems-architecture.md`)

```markdown
# Systems Architecture

## Context and Goals

## System Overview

## Components and Boundaries

## Key Workflows

## External Dependencies

## Deployment Topology (High-Level)

## Notes / Open Questions
```

## Code Architecture Template (`docs/architecture/code-architecture.md`)

```markdown
# Code Architecture

## Entry Points

## High-Level Layout

## Layers and Boundaries

## Conventions

## Key Abstractions

## Extension Points
```

## File Map Template (`docs/architecture/file-map.md`)

```markdown
# File Map

## How To Navigate

## Directory Tree

## Key Files

## Common Tasks Map
```

## API / Interfaces Template (`docs/api/README.md`)

```markdown
# API / Interfaces

## What Interfaces Exist

## Authentication and Authorization

## Errors

## Examples

## Reference Index
```

## API Page Template (`docs/api/<interface-or-area>.md`)

```markdown
# <Interface Name>

## Purpose

## How To Call

## Inputs

## Outputs

## Errors

## Examples

## Related Code
```

## Data Template (`docs/data/README.md` + `docs/data/data-models.md`)

```markdown
# Data

## Overview

## Persistence

## Key Documents

## See Also
```

```markdown
# Data Models

## Overview

## Core Entities and Types

## Relationships

## Validation

## Data Flows

## Migrations
```

## Deployment Template (`docs/deployment/README.md`)

```markdown
# Deployment

## Environments

## Prerequisites

## Configuration

## Deploy Steps

## Rollback

## Operational Checks

## CI/CD

## Monitoring and Logging
```

## Testing Template (`docs/testing/README.md`)

```markdown
# Testing

## Strategy

## Test Layout

## Running Tests

## Writing Tests

## Coverage

## Common Failures
```

## Code Docs Template (`docs/code/README.md` + `docs/code/modules.md` + `docs/code/classes.md`)

```markdown
# Code

## Overview

## Key Documents

## See Also
```

```markdown
# Modules

## Overview

## Module Index

## Boundaries

## Dependency Notes
```

```markdown
# Classes / Key Abstractions

## Overview

## Core Abstractions

## Relationships

## Extension Points
```

## Design Template (`docs/design/README.md` + `docs/design/ui-ux-specifications.md`)

```markdown
# Design

## Overview

## Current State

## Key Documents

## See Also
```

```markdown
# UI/UX Specifications

## Principles

## Information Architecture

## Components

## Tokens / Styles

## Interaction Patterns

## Accessibility

## Responsive Behavior

## User Flows
```

## Examples Template (`docs/src-examples/README.md`)

```markdown
# Source Examples

## How To Run

## Examples Index
```

## Tutorial Template (`docs/tutorials/<tutorial>.md`)

```markdown
# Tutorial: <Task>

## Goal

## Prerequisites

## Steps

## Verification

## Troubleshooting

## Next Steps
```

## Optional Templates (recommended when applicable)

These are common "missing" docs that materially improve maintainability and onboarding.

## Contributing Template (`CONTRIBUTING.md` or `docs/contributing.md`)

```markdown
# Contributing

## Who This Is For

## Development Setup
- Prerequisites
- Install
- Configure
- Run locally

## How To Make Changes
- Branching
- Commit conventions
- Coding standards
- Tests to run

## Pull Request Process
- PR checklist
- Review expectations
- Definition of done

## Security and Secrets
- Never commit secrets
- How to handle env vars / credentials

## Getting Help
```

## Changelog Template (`CHANGELOG.md` or `docs/CHANGELOG.md`)

```markdown
# Changelog

## Unreleased

## <YYYY-MM-DD>
- <Change description>
```

## Configuration Templates (`docs/configuration/`)

`docs/configuration/README.md`

```markdown
# Configuration

## Overview

## Configuration Sources
- Environment variables
- Config files
- Command-line flags (if any)

## Key Documents
- `environment-variables.md`
- `config-files.md`

## See Also
```

`docs/configuration/environment-variables.md`

```markdown
# Environment Variables

## How To Set

## Variables

| Name | Required | Default | Description |
| ---- | -------- | ------- | ----------- |
| <ENV_VAR> | yes/no | <value> | <desc> |

## Notes
- Do not include secret values; only document names and how to obtain them.
```

## Security Template (`docs/security/README.md`)

```markdown
# Security

## Reporting Vulnerabilities

## Threat Model (High-Level)

## Authentication and Authorization

## Secrets Handling
- What should be in env vars
- What should never be committed

## Dependency / Supply Chain Notes

## Security Notes / Open Questions
```

## Errors Template (`docs/errors/README.md`)

```markdown
# Errors

## Overview

## Error Taxonomy
- Validation errors
- Authorization errors
- Network / upstream errors
- Internal errors

## Error Codes / Messages

| Code / Type | Meaning | Common Causes | Recovery |
| ----------- | ------- | ------------ | -------- |
| <CODE> | <meaning> | <causes> | <steps> |

## Client Handling Guidance

## Related Code
```

## Migrations Template (`docs/migrations/README.md`)

```markdown
# Migrations and Upgrades

## When You Need This

## Supported Versions

## Upgrade Guide
- From <vX> to <vY>

## Data Migrations (if applicable)

## Rollback

## Notes / Open Questions
```

## Performance Template (`docs/performance/README.md`)

```markdown
# Performance

## Performance Characteristics

## Benchmarks

## Tuning Guide

## Resource Requirements

## Known Bottlenecks

## Notes / Open Questions
```

## Diagrams and Visual Aids

When adding diagrams to documentation:

- **ASCII art diagrams**: Use standardized prompts from `./ascii-art-prompts.md` to generate consistent ASCII art diagrams. These work well for:
  - Architecture overviews and component relationships
  - Simple flowcharts and process flows
  - File system hierarchies and directory structures
  - Class inheritance diagrams
  - Network and API integration diagrams
  - User journey flows and state machines

- **Mermaid diagrams**: Use Mermaid syntax for more complex diagrams that benefit from automatic layout and rendering in markdown viewers that support it (sequence diagrams, complex flowcharts, entity-relationship diagrams).

- **When to use each**:
  - ASCII art: Simple, static diagrams that render well in plain text (terminals, plain markdown viewers, code reviews)
  - Mermaid: Complex diagrams requiring automatic layout, or when markdown viewer support is guaranteed

- **Reference**: See `./ascii-art-prompts.md` for:
  - Standardized prompt templates for different diagram types
  - Character reference for box-drawing and arrows
  - Best practices and formatting guidelines
  - Quality checklist for diagram generation
