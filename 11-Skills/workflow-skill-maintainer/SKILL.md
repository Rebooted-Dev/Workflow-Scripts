---
name: workflow-skill-maintainer
description: Create, update, validate, and parity-check Workflow-Scripts skills and generated skill bundles.
---

# Workflow Skill Maintainer

Use this skill when editing `11-Skills/`, workflow `skills:` frontmatter, generated skill bundles, or skill validation behavior.

## Rules

1. Keep `SKILL.md` concise, imperative, and task-oriented.
2. Frontmatter `name` must match the folder name.
3. Every skill folder must include `agents/openai.yaml` with the same `name`.
4. Avoid copying long workflow prose into skills. Reference canonical workflows, `core/` standards, and role contracts instead.
5. Generated bundles must be diff-reviewed against `11-Skills/*` before replacing hand-authored sources.
6. Validation must fail for unknown workflow skill references and name/folder mismatches.

## Guardrails

- Do not delete existing task skills during the first skill-layer pass.
- Do not claim generated Codex, Claude, OpenCode, or Droid parity until the generator source and parity checks are present and run.
