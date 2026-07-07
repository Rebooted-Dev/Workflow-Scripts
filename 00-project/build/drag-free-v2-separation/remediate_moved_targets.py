#!/usr/bin/env python3
"""Repair v2.0a MOVED.json targets and write an audit manifest."""

from __future__ import annotations

import csv
import json
import subprocess
from pathlib import Path, PurePosixPath


ROOT = Path(__file__).resolve().parents[3]
OUT_DIR = ROOT / "00-project/build/drag-free-v2-separation"
MANIFEST = OUT_DIR / "moved-target-audit.csv"
SUMMARY = OUT_DIR / "README.md"
V1_MISSING_ALLOWED = {
    "00-project-setup/08-greenfield-mvp.md",
    "01-planning-and-organizing/04-architecture-design.md",
    "07-deployment/00-deploy.md",
}


def is_safe_repo_path(path: str) -> bool:
    posix = PurePosixPath(path)
    return bool(path) and not posix.is_absolute() and ".." not in posix.parts


def is_stub_text(text: str) -> bool:
    first = text.splitlines()[0].strip() if text.splitlines() else ""
    return first == "# Moved"


def file_state(path: Path) -> str:
    if not path.exists():
        return "missing"
    if path.is_file() and is_stub_text(path.read_text(encoding="utf-8")):
        return "stub"
    return "real"


def staged_source(paths: list[str]) -> tuple[str, bytes] | None:
    for rel in paths:
        candidate = ROOT / "00-project/Drag-Free-v2" / rel
        if candidate.is_file():
            text = candidate.read_text(encoding="utf-8")
            if not is_stub_text(text):
                return (f"staged:{rel}", candidate.read_bytes())
    return None


def v17_source(old_path: str) -> tuple[str, bytes] | None:
    try:
        data = subprocess.check_output(
            ["git", "show", f"v1.7:{old_path}"],
            cwd=ROOT,
            stderr=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError:
        return None
    text = data.decode("utf-8", errors="replace")
    if is_stub_text(text):
        return None
    return ("v1.7", data)


def stub_for(target: str) -> str:
    return (
        "# Moved\n\n"
        f"This file moved to `{target}`. See `MOVED.md` at the repository root "
        "for the full redirect map.\n"
    )


def main() -> int:
    moved = json.loads((ROOT / "MOVED.json").read_text(encoding="utf-8"))
    rows: list[dict[str, str]] = []
    errors: list[str] = []

    for old_path, target in moved.items():
        if not is_safe_repo_path(old_path) or not is_safe_repo_path(target):
            rows.append(
                {
                    "old_path": old_path,
                    "canonical_target": target,
                    "initial_target_state": "malformed",
                    "chosen_source": "none",
                    "final_action": "error: malformed path",
                    "final_target_state": "malformed",
                }
            )
            errors.append(f"malformed path: {old_path} -> {target}")
            continue

        target_path = ROOT / target
        old_file = ROOT / old_path
        initial_state = file_state(target_path)
        chosen_source = "existing v2 target"
        action = "kept existing canonical target"

        if initial_state != "real":
            source = staged_source([target, old_path])
            if source is None and old_path not in V1_MISSING_ALLOWED:
                source = v17_source(old_path)
            if source is None:
                chosen_source = "none"
                action = "error: no real source available"
                errors.append(f"no source for {old_path} -> {target}")
            else:
                chosen_source, data = source
                target_path.parent.mkdir(parents=True, exist_ok=True)
                target_path.write_bytes(data)
                action = f"restored canonical target from {chosen_source}"

        if file_state(target_path) == "real":
            old_file.parent.mkdir(parents=True, exist_ok=True)
            old_file.write_text(stub_for(target), encoding="utf-8")
            if action == "kept existing canonical target":
                action = "kept canonical target; refreshed old-path stub"
            else:
                action = f"{action}; refreshed old-path stub"

        rows.append(
            {
                "old_path": old_path,
                "canonical_target": target,
                "initial_target_state": initial_state,
                "chosen_source": chosen_source,
                "final_action": action,
                "final_target_state": file_state(target_path),
            }
        )

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with MANIFEST.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "old_path",
                "canonical_target",
                "initial_target_state",
                "chosen_source",
                "final_action",
                "final_target_state",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)

    counts: dict[str, int] = {}
    source_counts: dict[str, int] = {}
    for row in rows:
        counts[row["final_target_state"]] = counts.get(row["final_target_state"], 0) + 1
        source_counts[row["chosen_source"]] = source_counts.get(row["chosen_source"], 0) + 1

    SUMMARY.write_text(
        "# Drag-Free v2 Separation Repair Evidence\n\n"
        "This directory records the v2.0a redirect-target repair performed after the "
        "Drag-Free v2 promotion. Root `workflows/`, `core/`, `reference/`, `tools/`, "
        "`MOVED.json`, `MOVED.md`, `catalog.json`, and `ROUTER.md` are the active "
        "v2.0a topology. `00-project/Drag-Free-v2/` is retained as archived promotion "
        "evidence, not a second live workflow tree.\n\n"
        "## Audit Files\n\n"
        "- `moved-target-audit.csv` lists every `MOVED.json` row, its initial target "
        "state, chosen source, action, and final state.\n"
        "- `remediate_moved_targets.py` is the one-off repair utility used to produce "
        "the manifest and repairs.\n\n"
        "## Result Summary\n\n"
        f"- Rows audited: {len(rows)}\n"
        + "".join(f"- Final `{key}` targets: {value}\n" for key, value in sorted(counts.items()))
        + "\n## Source Summary\n\n"
        + "".join(f"- `{key}`: {value}\n" for key, value in sorted(source_counts.items()))
        + "\n## Errors\n\n"
        + ("- None\n" if not errors else "".join(f"- {error}\n" for error in errors)),
        encoding="utf-8",
    )

    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
