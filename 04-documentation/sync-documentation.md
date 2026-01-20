# Workflow: Sync Documentation

## Purpose
Review code and update `docs/` so documentation accurately matches the codebase and is organized for clarity.

## Inputs
- Repository root.
- Existing `docs/` directory contents.

## Prioritization Rule
- Organize doc work by priority, descending urgency/importance: P0, P1, P2, P3.
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

## Suggested Priority Buckets (docs)
- P0: incorrect docs that could cause wrong usage, broken setup, or unsafe behavior.
- P1: missing docs for critical flows (setup, run, build, key architecture decisions).
- P2: re-organization, consolidation, cross-links, and reference completeness.
- P3: nice-to-have diagrams, polish, and deep examples.

## Steps
1. Scan the codebase using parallel agents. Each agent should read code files in parallel batches (read multiple files concurrently):
   - Agent 1: Scan codebase for current behavior (read implementation files in parallel)
   - Agent 2: Understand architecture and structure (read architecture files in parallel)
   - Agent 3: Identify documentation gaps (read code and compare with docs in parallel)
   Agents should batch read files concurrently to maximize scanning speed.
2. Inventory existing docs; tag issues as P0–P3.
3. Apply fixes in priority order:
   - correct contradictions and outdated instructions first
   - fill missing critical docs next
   - then reorganize and consolidate
   - then add diagrams/polish
4. Reorganize `docs/` into clear subdirectories by audience and purpose.
5. Add diagrams and file maps where they clarify complex systems.
6. Remove redundancy and cross-link related docs.

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

## Notes
- Keep updates minimal and accurate; avoid speculative content.
- Prefer surgical edits over large rewrites; only reorganize `docs/` when you can point to concrete navigation or duplication pain.
- Use parallel agents to cover different domains efficiently.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
