#!/usr/bin/env python3
"""Migrate root CHANGELOG.md entries into 00-project/changelog/ one-file-per-change."""

import re
import hashlib
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
CHANGELOG = REPO_ROOT / "CHANGELOG.md"
OUT_ROOT = REPO_ROOT / "00-project" / "changelog"

TYPE_MAP = {
    "added": "added",
    "changed": "changed",
    "fixed": "fixed",
    "removed": "changed",
    "deprecated": "changed",
    "security": "config",
    "refactor": "refactor",
    "improved": "improved",
    "docs": "docs",
    "config": "config",
}

ENTRY_RE = re.compile(r"^- (\d{4}-\d{2}-\d{2}):\s*(.+)$")


def slugify(text: str, max_len: int = 48) -> str:
    text = text.lower()
    text = re.sub(r"[`'\"]", "", text)
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-+", "-", text).strip("-")
    if len(text) > max_len:
        text = text[:max_len].rstrip("-")
    if not text:
        text = "entry"
    return text


def unique_slug(base: str, used: set[str]) -> str:
    if base not in used:
        used.add(base)
        return base
    suffix = 2
    while f"{base}-{suffix}" in used:
        suffix += 1
    slug = f"{base}-{suffix}"
    used.add(slug)
    return slug


def parse_changelog(content: str) -> list[tuple[str, str, str]]:
    """Return list of (date, type, description)."""
    entries: list[tuple[str, str, str]] = []
    current_type = "changed"

    for raw_line in content.splitlines():
        line = raw_line.strip()
        if line.startswith("### "):
            section = line[4:].strip().lower()
            current_type = TYPE_MAP.get(section, "changed")
            continue
        m = ENTRY_RE.match(line)
        if m:
            entries.append((m.group(1), current_type, m.group(2).strip()))
        elif line.startswith("- ") and not ENTRY_RE.match(line):
            # Continuation or undated bullet — attach to last entry if present
            if entries:
                d, t, desc = entries[-1]
                entries[-1] = (d, t, f"{desc} {line[2:].strip()}")

    return entries


def main() -> None:
    content = CHANGELOG.read_text(encoding="utf-8")
    entries = parse_changelog(content)
    used_slugs: set[str] = set()
    index_rows: list[str] = []

    for date, entry_type, description in reversed(entries):
        slug_base = slugify(description)
        slug = unique_slug(slug_base, used_slugs)
        filename = f"{date}-{entry_type}-{slug}.md"
        folder = OUT_ROOT / entry_type
        folder.mkdir(parents=True, exist_ok=True)
        path = folder / filename

        title = description.split("—")[0].split(" - ")[0].strip()
        if len(title) > 80:
            title = title[:77] + "..."

        body = f"""# {title}
**Date:** {date}
**Type:** {entry_type}

---

## Summary
- {description}

## Scope
- Migrated from root `CHANGELOG.md` (legacy monolithic changelog).
"""
        path.write_text(body, encoding="utf-8")
        rel = f"{entry_type}/{filename}"
        short_title = title.replace("|", "\\|")
        index_rows.append(
            f"| {date} | {entry_type} | {short_title} | {rel} | Migrated from CHANGELOG.md |"
        )

    index_path = OUT_ROOT / "index.md"
    existing = index_path.read_text(encoding="utf-8") if index_path.exists() else ""
    header = """# Changelog Index

Chronological index of changelog entries and completed plans.
**Newest entries are listed first.** Type can be added, changed, fixed, improved, docs, refactor, config, or plan.

| Date | Type | Title | File | Notes |
|------|------|-------|------|-------|
"""

    # Preserve pre-migration rows (config entries from 2026-07-03)
    preserved = []
    if existing:
        for line in existing.splitlines():
            if line.startswith("| 2026-07-03"):
                preserved.append(line)

    all_rows = preserved + index_rows
    index_path.write_text(header + "\n".join(all_rows) + "\n", encoding="utf-8")
    print(f"Migrated {len(entries)} entries into {OUT_ROOT}")


if __name__ == "__main__":
    main()