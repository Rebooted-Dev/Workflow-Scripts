---
date: 2026-07-10
type: fixed
title: wf validate fenced-link warnings
---

# wf validate fenced-link warnings

Made Markdown-link validation ignore well-formed backtick and tilde fenced examples, including variable-length fences, while retaining the original document when a fence is unterminated.

Aligned the active-link validator to the same semantics and added regression coverage for genuine prose links, consumer templates, literal grep patterns, inline contract paths, retired path tokens, and malformed fences. Live validation now reports zero warnings instead of 24 false positives.
