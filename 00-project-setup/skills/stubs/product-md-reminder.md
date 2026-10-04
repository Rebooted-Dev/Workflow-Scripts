# PRODUCT.md reminder

Do **not** invent a `PRODUCT.md`. Impeccable expects an interview-driven product truth file.

## When to create

- The application has (or will have) a UI / design surface, **and**
- `PRODUCT.md` is missing at the project root (or the location Impeccable uses for this repo).

## How

In Agent chat (after Phase 1 Impeccable install):

```text
/impeccable init
```

Answer the product questions. Approve hooks if prompted (Claude / Cursor / Codex / Grok; Grok may need `/hooks-trust`).

## When to skip

- Pure CLI / backend / infra repo with **no** planned visual surface → skip until design work starts.
- `PRODUCT.md` already exists → do not overwrite unless the user explicitly re-runs init / redesign.

## Related

- Global install: [../01-global-install.md](../01-global-install.md)
- Scan decision: [../02-project-scan.md](../02-project-scan.md)
- Scaffold step: [../03-project-scaffold.md](../03-project-scaffold.md)
- Precedence (Impeccable owns design): [../precedence.md](../precedence.md)
