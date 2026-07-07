---
name: export-render-parity-debugger
description: Debug and verify exported/rendered output parity across app view, HTML, Markdown, PDF, ZIP, and preview surfaces. Use when thumbnails, image links, rendered PDF, full export ZIPs, markdown previews, blog exports, or generated document styling differ from the app view or fail during export.
---

# Export Render Parity Debugger

Use this skill when export bugs span more than one output surface.

## Workflow

1. Enumerate surfaces.
   - App view.
   - HTML export.
   - Markdown export.
   - PDF export.
   - ZIP/full export.
   - Preview or re-import view.

2. Reproduce from evidence.
   - Read saved execution artifacts first when provided.
   - Identify the exact export stack, renderer, asset copier, URL/path resolver, and binary conversion step.
   - Compare working and broken surfaces before patching.

3. Preserve source-of-truth rendering.
   - Reuse the app's rendered view/style when the user asks for accurate visual capture.
   - Avoid building a separate approximate export renderer unless the architecture requires it.
   - Keep thumbnails, image URLs, and generated assets consistent across surfaces.

4. Fix and verify parity.
   - Add tests for path resolution, asset inclusion, markdown/html output, and PDF/ZIP assembly where practical.
   - Manually inspect or programmatically verify each affected surface.
   - Confirm one fix did not regress another export target.

## Guardrails

- Do not assume HTML, Markdown, PDF, ZIP, and preview share the same renderer.
- Do not call export fixed after verifying only one surface.
- Do not treat binary signature errors as content-rendering bugs until the asset pipeline is checked.
