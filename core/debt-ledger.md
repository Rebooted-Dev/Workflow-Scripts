---
id: debt-ledger
kind: standard
status: active
---

# Debt Ledger

Use `<metadata-root>/debt/` for deliberate shortcuts, known gaps, deprecations, and accepted scope cuts.

## Entry Format

```markdown
---
date: YYYY-MM-DD
kind: shortcut
severity: S2
status: open
trigger: ">100 users OR auth provider added"
touched_areas:
  - src/auth
---

# Short title

What was borrowed and why.

Paydown: concrete remediation and rough effort.
```

Allowed `kind` values: `shortcut`, `known-gap`, `deprecation`, `scope-cut`.

Allowed `status` values: `open`, `scheduled`, `paid`, `accepted`.

## Rules

- Record debt when it is incurred, not only when a later review rediscovers it.
- Every open item needs a trigger, touched area, severity, and paydown note.
- T2/T3 plans touching an area with open S1 debt must schedule paydown or explicitly accept the risk in the plan.
- Refactoring reviews reconcile findings against existing debt entries instead of duplicating known debt.
