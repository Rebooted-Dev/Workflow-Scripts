---
id: website-data-refactoring
version: 2.0
category: review
kind: workflow
triggers:
  - "website data refactor"
  - "refactor website content data"
  - "content model review"
inputs: [repository-root, content-scope]
outputs: [website-data-refactor-plan]
requires: [metadata-root, review-workflow-core, severity-priority-rubric]
agents: [bug-hunter, performance-reviewer, docs-writer]
prev: [code-review]
next: [finalise-plan]
skills:
  primary: filed-code-review-to-remediation
  required:
    - workflow-intake-and-routing
    - engineering-quality-gates
    - repo-records-and-filing
  conditional: []
---

# Workflow: Website Data Refactoring

## Purpose
Review website content, configuration, and data-model files to identify duplication, stale structure, migration risk, and opportunities to move toward clearer source-of-truth boundaries.

Use `../00-core/meta/review-workflow-core.md` for report routing, evidence requirements, severity/priority scoring, and untrusted-content handling.

## Skill Hooks

- Use `workflow-intake-and-routing` to confirm content scope and repository boundaries.
- Use `engineering-quality-gates` to check migration risk, data ownership, and verification coverage.
- Use `repo-records-and-filing` to file the refactor report or plan in the correct metadata root.

## Inputs
- Repository root.
- Website/content scope, such as `src/content/`, CMS exports, JSON/YAML data files, page metadata, or routing configuration.
- Any target architecture or migration constraints supplied by the user.

## Steps
1. Identify content sources, generated outputs, and runtime consumers.
2. Map duplicate fields, conflicting metadata, stale routes, and manual synchronization points.
3. Check whether proposed refactors preserve URLs, SEO metadata, redirects, and content ownership.
4. File findings using source paths and concrete examples.
5. Recommend a staged migration path with verification commands and rollback notes.

## Output
File the report or plan in `<metadata-root>/research/` unless the user requests a specific path. Include:
- Current source-of-truth map.
- Findings with file/line evidence where possible.
- Migration plan with acceptance checks.
- Open questions that need owner confirmation.
