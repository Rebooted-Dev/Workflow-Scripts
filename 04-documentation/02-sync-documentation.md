# Workflow: Sync Documentation

## Purpose
Review code and update `docs/` so documentation accurately matches the codebase and is organized for clarity.

## Inputs
- Repository root.
- Existing `docs/` directory contents.

## Document Templates (required)
Use the shared templates in `./00-doc-templates.md` when:
- creating new documentation files
- reshaping an existing document that has no clear structure
- adding new sections to an existing doc

Template rules:
- Prefer the smallest change that brings the doc back into conformance.
- Keep headings stable; avoid churn unless it reduces real confusion.
- If a section is not applicable, include it and state "Not applicable" with a brief reason.
- Never include secret values; document only env var names and how to obtain them.

## Prioritization Rule
- Organize doc work by priority, descending urgency/importance: P0, P1, P2, P3.
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

## Suggested Priority Buckets (docs)
- P0: incorrect docs that could cause wrong usage, broken setup, or unsafe behavior.
- P1: missing docs for critical flows (setup, run, build, key architecture decisions).
- P2: re-organization, consolidation, cross-links, and reference completeness.
- P3: nice-to-have diagrams, polish, and deep examples.

## Optional Add-Ons
If you discover missing "supporting" documentation (contributing/changelog/config/security/errors/migrations/etc.), use `./09-optional.md` as a checklist to recommend a small, high-leverage set (usually 1-3 items).

## Steps
1. Scan the codebase using parallel agents. Suggested agent roles (spawn additional agents as needed):
   - Scan codebase for current behavior (read implementation files in parallel batches)
   - Understand architecture and structure (read architecture files in parallel batches)
   - Identify documentation gaps (read code and compare with docs in parallel batches)
   - [Spawn additional agents if you discover other documentation needs, such as:
     - API documentation gaps
     - Architecture diagram needs
     - Code example requirements
     - Migration guide needs
     - Configuration documentation
     - Troubleshooting guide updates]
   Agents should batch read files concurrently to maximize scanning speed.
2. Inventory existing docs; tag issues as P0–P3.
3. Apply fixes in priority order:
   - correct contradictions and outdated instructions first
   - fill missing critical docs next
   - then reorganize and consolidate
   - then add diagrams/polish
4. Reorganize `docs/` into clear subdirectories by audience and purpose.
5. Add diagrams and file maps where they clarify complex systems:
   - **ASCII art diagrams**: Use prompts from `./ascii-art-prompts.md` to generate ASCII art diagrams for architecture, flows, hierarchies, and other visual aids that benefit from plain text rendering.
   - **Mermaid diagrams**: Use Mermaid syntax for complex diagrams that benefit from automatic rendering.
   - Reference `./ascii-art-prompts.md` for standardized prompt templates, character reference, and best practices.
   - When adding diagrams, ensure they accurately reflect the current codebase structure and relationships.
6. Remove redundancy and cross-link related docs.
7. Normalize document structure:
   - For docs you touched, align their headings with `./00-doc-templates.md`.
   - If a doc is intentionally structured differently, add a short "How to read this" section at the top.

## Output Requirements
- `docs/` is organized into meaningful subdirectories.
- New files created only where coverage is missing.
- Diagrams are text-based and directly reflect actual structure.
- File maps are included to aid navigation (directory trees and/or module maps for key areas).

## Acceptance Criteria
- Doc changes are delivered in priority order (P0 to P3).
- No doc contradicts the current codebase.
- Each doc has a clear scope and audience.
- Overlapping content is consolidated or explicitly cross-referenced.

## Related Workflows

- **[`01-create-docs.md`](./01-create-docs.md)** - Create comprehensive documentation from scratch (use this for new projects)
- **[`00-doc-templates.md`](./00-doc-templates.md)** - Reference templates for consistent documentation structure
- **[`09-optional.md`](./09-optional.md)** - Checklist of optional documentation types to consider
- **[`ascii-art-prompts.md`](./ascii-art-prompts.md)** - Prompts for generating ASCII art diagrams
- **[`../02-build-code/01-execution.md`](../02-build-code/01-execution.md)** - Update documentation after code changes

## Notes
- Keep updates minimal and accurate; avoid speculative content.
- Prefer surgical edits over large rewrites; only reorganize `docs/` when you can point to concrete navigation or duplication pain.
- Use parallel agents to cover different domains efficiently.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
