#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

python3 - <<'PY'
import json
import re
import sys
from pathlib import Path, PurePosixPath

repo_root = Path.cwd()
active_root = repo_root / "workflows-drag-free"
moved_path = active_root / "MOVED.json"

try:
    moved = json.loads(moved_path.read_text(encoding="utf-8"))
except Exception as exc:
    print(f"MOVED.json is not valid JSON: {exc}", file=sys.stderr)
    sys.exit(1)

missing = []
self_stubbed = []
stub_mismatches = []
malformed = []
stub_re = re.compile(r"This file moved to `([^`]+)`\.")


def safe_repo_path(path: str) -> bool:
    posix = PurePosixPath(path)
    return bool(path) and not posix.is_absolute() and ".." not in posix.parts


def is_stub(path: Path) -> bool:
    if not path.is_file():
        return False
    first = path.read_text(encoding="utf-8").splitlines()[0:1]
    return bool(first and first[0].strip() == "# Moved")


for old_path, target in moved.items():
    if not safe_repo_path(old_path) or not safe_repo_path(target):
        malformed.append(f"{old_path} -> {target}")
        continue

    target_path = repo_root / target
    old_file = repo_root / old_path

    if not target_path.exists():
        missing.append(target)
    elif is_stub(target_path):
        self_stubbed.append(target)

    if not old_file.is_file():
        stub_mismatches.append(f"{old_path}: old-path stub is missing")
        continue

    text = old_file.read_text(encoding="utf-8")
    first_line = text.splitlines()[0].strip() if text.splitlines() else ""
    match = stub_re.search(text)
    if first_line != "# Moved":
        stub_mismatches.append(f"{old_path}: old path is not a # Moved stub")
    elif not match:
        stub_mismatches.append(f"{old_path}: stub target is not parseable")
    elif match.group(1) != target:
        stub_mismatches.append(
            f"{old_path}: stub points to {match.group(1)}, MOVED.json points to {target}"
        )

print(f"moved_rows={len(moved)}")
print(f"missing={len(missing)}")
print(f"self_stubbed={len(self_stubbed)}")
print(f"stub_mismatches={len(stub_mismatches)}")
print(f"malformed={len(malformed)}")

for label, items in (
    ("malformed", malformed),
    ("missing", missing),
    ("self_stubbed", self_stubbed),
    ("stub_mismatches", stub_mismatches),
):
    if items:
        print(f"\n{label}:", file=sys.stderr)
        for item in items:
            print(f"- {item}", file=sys.stderr)

if missing or self_stubbed or stub_mismatches or malformed:
    sys.exit(1)
PY
