# Engineering Standards

Shared build-to and judge-against questions for implementation and review. Apply them in proportion to scope; they guide sound decisions rather than mandate invasive cleanup. If a standard is not pragmatic for a change, is the exception and its tradeoff recorded?

## §1 Boundaries and abstraction

- Can you state each module or component's responsibility in one sentence?
- What can change inside the boundary without requiring caller changes? If the answer is “nothing,” should the boundary move?
- Does domain and decision logic stay independent of I/O, UI, and provider SDKs, with adapters depending inward?
- Where is each invariant enforced once? Can callers rely on it without re-validating it?
- Can invalid states be made unrepresentable with the language's available types?
- In a function- or hook-based codebase, can modules, closures, typed interfaces, and a functional core / imperative shell express the same boundaries? Is composition preferred over inheritance, without requiring class hierarchies?

## §2 Reuse and a single source of truth

- Before adding a helper, type, prompt fragment, constant, or validation, did you search for an existing one and record the search?
- Is a second copy of the same behavior extracted, or is there a recorded reason not to extract it?
- Does each fact—such as configuration, defaults, limits, or policy—have one authoritative definition?
- Do parallel paths share a core and differ only where transport or platform requires it? If not, is the duplication justified?

## §3 Errors/fallbacks/fault prevention

- At each boundary, is an error classified as recoverable, user-visible and unrecoverable, or a bug that should fail fast?
- Does every catch handle the error meaningfully, add context and rethrow, or log with context? Is any empty catch or default-return justified?
- Is each fallback deliberate and visible when activated, rather than masking a primary-path failure silently?
- Are retries limited to transient faults, bounded, and backed off?
- Do user-facing errors explain what happened and what to do next without exposing internals or secrets?
- Are network calls timed out, queues and buffers bounded, and acquired resources released deterministically?

## §4 Tests that prevent regressions

- For a bug fix, is there a failing automated regression test that reproduces the bug before the fix when feasible? If not feasible, is the concrete reason documented with reproducible manual regression steps and evidence?
- For a new or changed boundary, do contract tests exercise its public interface rather than its internals?
- Do tests assert behavior rather than wiring alone, and does verification exercise the runtime path when the acceptance criteria require it?

## §5 Recovery

- Does each verified phase have a checkpoint: one commit only when authorized, or otherwise a recorded `git stash create` reference or diff hash in the phase report?
- For a risky runtime change, is a flag or reversible configuration switch used when the codebase has one?
- Is a data/storage migration reversible, or, if one-way, does it include a backup step and explicit sign-off?

## Appendix

| Language | Check question |
|---|---|
| TypeScript | Are strict checks enabled, including `noUncheckedIndexedAccess` where supported? Is each use of `any` accompanied by a recorded reason? |
| Python | Are types annotated and checked with the project's mypy/pyright path, and are resources managed with context managers? |
| Shell | Are scripts using `set -euo pipefail`, quoting expansions, and passing `shellcheck` when configured? |
