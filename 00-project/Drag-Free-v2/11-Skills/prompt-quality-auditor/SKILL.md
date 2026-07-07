---
name: prompt-quality-auditor
description: Audit prompt systems for enforceable product and UI quality. Use when the user asks for a deep prompt review, prompt quality audit, UI-generation prompt hardening, or review of prompts for layering, shadows, glow, animation, app chrome, accessibility, responsive behavior, state coverage, or consistency across prompt files.
---

# Prompt Quality Auditor

Use this skill to evaluate whether prompts reliably enforce high-quality output, not merely whether they mention good design words.

## Workflow

1. Inventory prompt sources.
   - Locate prompt files, schema/formatter code, allowed lists, templates, and runtime prompt assembly.
   - Identify which prompts control concept generation, style selection, variation, artifact generation, and critique.
   - Check for generated runtime copies when the app uses a prompt asset sync step.

2. Audit enforcement, not vocabulary.
   - Look for required baselines for layering, z-index, depth, shadows, glow, pseudo-elements, motion, reduced-motion behavior, app chrome, responsiveness, accessibility, and UI states.
   - Check whether requirements are explicit, repeated in the right prompt stages, and represented in schemas or formatters.
   - Flag contradictions, vague adjectives, invalid examples, and prompts that ask for generation when strict selection is required.

3. Compare prompt files against each other.
   - Identify uneven standards between artifact prompts, style prompts, design templates, variation prompts, and concept prompts.
   - Confirm that downstream prompts preserve quality requirements introduced upstream.
   - Verify that allowed lists and examples match the actual runtime options.

4. Produce findings.
   - Prioritize systemic gaps over wording preferences.
   - Include specific file references, observed weakness, likely output failure, and recommended prompt/schema change.
   - If app code must change to preserve prompt intent, state that separately from prompt-copy changes.

5. Recommend hardening order.
   - Start with the artifact/output prompt baseline.
   - Normalize strict selection prompts next.
   - Add shared requirements to variation and concept prompts.
   - Update schemas, formatters, tests, and prompt asset sync if they enforce the contract.

## Guardrails

- Do not count aesthetic terms as evidence of enforceable quality.
- Do not recommend UI prompt changes without checking how prompts are assembled at runtime.
- Do not make UI code changes unless the user explicitly asks for implementation.
