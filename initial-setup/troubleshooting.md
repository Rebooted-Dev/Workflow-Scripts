# Troubleshooting / Tech Notes Workflow Template

This file is a **recipe** for setting up and using a troubleshooting + tech-notes system, like the one in this project’s `troubleshooting/` directory.

You can reuse this workflow in other projects by copying this file and the basic folder structure.

---

## 1. Goals of the System

- **Capture knowledge** about issues we hit (symptoms, root cause, fix, verification).
- **Organize by category** so related problems are easy to find.
- **Keep a single chronological index** so you can quickly scan “what has gone wrong before”.
- **Make it low-friction** so you actually use it during real debugging.

---

## 2. Directory Structure Template

Create a `troubleshooting/` directory in your project root:

```text
troubleshooting/
  README.md          # High-level description & conventions
  index.md           # Chronological index of all entries
  build/             # Build & test issues
  runtime/           # In-browser/runtime UI or logic bugs
  data/              # Data, prompts, migrations, persistence issues
  environment/       # Local setup, Node, .env, permissions, OS quirks
  security/          # Security advisories & patches
```

You can add more category folders later if needed, but start small.

---

## 3. File Naming Convention

Each troubleshooting note is a **single Markdown file** inside one of the category folders.

Use this naming pattern:

```text
<yyyy-mm-dd>-<short-category>-<short-title>.md
```

Examples:

- `2025-01-17-prompts-loading-missing-entrypoint.md`
- `2026-01-19-build-css-unexpected-brace.md`
- `2025-12-03-security-react-rce-patch.md`

Guidelines:

- `short-category` is a hint (build, data, security, etc.) but **does not** have to match the folder name exactly.
- `short-title` should be a few words that describe the core issue.
- Keep everything lower-case and use `-` between words for readability.

---

## 4. Troubleshooting Entry Template

Each entry should follow the same basic shape:

```markdown
# <Short Title>
**Date:** <YYYY-MM-DD>  
**Category:** <build|runtime|data|environment|security|...>  
**Status:** <RESOLVED|OPEN|WORKAROUND>

---

## Symptom
- What you observed: errors, logs, screenshots, failing commands.

## Root Cause
- What was actually wrong, in plain language.

## Fix
- Steps you took to resolve it (commands, code changes, config changes).

## Verification
- How you proved the fix worked (tests, builds, manual checks).

## Notes / Lessons
- Takeaways for “future you”: patterns, gotchas, quick checks.
```

You can copy–paste this block when starting a new entry.

---

## 5. Maintaining the Chronological Index (`index.md`)

`troubleshooting/index.md` is the **single place** that lists all entries.

Recommended structure:

```markdown
# Troubleshooting Index

Chronological index of troubleshooting entries.  
**Newest entries are listed first.**

| Date       | Category | Title                                   | File                                            | Status   |
|-----------|----------|-----------------------------------------|-------------------------------------------------|----------|
| 2026-01-19 | build    | CSS Build Warning - Unexpected `}`     | `build/2026-01-19-build-css-unexpected-brace.md` | RESOLVED |
| 2025-12-03 | security | React / Next.js RCE Patch (CVE-2025-55182) | `security/2025-12-03-security-react-rce-patch.md` | RESOLVED |
| 2025-01-17 | data     | Prompts Not Loading (Missing Entry Script) | `data/2025-01-17-prompts-loading-missing-entrypoint.md` | RESOLVED |
```

**When adding a new troubleshooting entry:**

1. Choose the appropriate category folder.
2. Create the entry file using the naming convention and template.
3. Edit `index.md`:
   - Add a new row **at the top** of the table.
   - Fill in Date, Category, Title, File (relative path), and Status.

This makes the index a quick “bird’s-eye view” of all incidents.

---

## 6. Workflow: From Incident to Note

Here is a step-by-step workflow you can follow whenever you hit a non-trivial issue:

1. **Notice a problem**
   - Build fails, tests fail, app misbehaves, security advisory appears, etc.

2. **Create a draft entry early (optional but helpful)**
   - Pick a category folder (build/runtime/data/environment/security).
   - Create a new file with today’s date and a rough title.
   - Paste the template and fill out at least the **Symptom** section as you go.

3. **Debug normally**
   - Try things, run commands, inspect logs.
   - Jot down important steps or discoveries under **Root Cause** and **Fix**.

4. **Once resolved**
   - Complete the sections: Symptom, Root Cause, Fix, Verification, Notes / Lessons.
   - Set `Status:` to `RESOLVED` (or leave `OPEN` / `WORKAROUND` if not fully fixed).

5. **Update `index.md`**
   - Add a row at the top with date, category, title, file path, and status.

6. **(Optional) Cross-link from other docs**
   - In implementation logs, changelogs, or design docs, you can add a short line:
     - “For full troubleshooting details, see `troubleshooting/<category>/<file>.md`.”

Over time, this builds a **project-specific knowledge base** of “how we solved things before.”

---

## 7. Adapting This System to New Projects

To reuse this system in another repo:

1. Copy the entire `troubleshooting/` directory (or start with `README.md`, `workflow.md`, and `index.md`).
2. Adjust category folders if needed, but keep:
   - A **root `troubleshooting/`** directory.
   - A **single `index.md`** for all entries.
3. Encourage contributors to:
   - Write a troubleshooting note for any issue that took more than a few minutes to understand.
   - Prefer **clear, simple language** over dense technical jargon.

This keeps your debugging process teachable, repeatable, and easy to onboard others into.

