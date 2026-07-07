#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RUN_ROOT="$ROOT/00-project/build/adversarial-multi-model-workflow/runs"

python3 - "$ROOT" "$RUN_ROOT" <<'PY'
import hashlib
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
run_root = Path(sys.argv[2])
run_dir = run_root / "20260706-231500-phase3-manual-pilot"
manifest_path = run_dir / "_manifest.json"
if not manifest_path.exists():
    raise SystemExit(f"missing manifest: {manifest_path}")

manifest = json.loads(manifest_path.read_text())
passes = manifest.get("passes", [])
if len(passes) < 6:
    raise SystemExit("phase3 pilot must include at least 6 pass artifacts")

profiles = {"research": 0, "planning": 0, "review": 0}
for item in passes:
    artifact = root / item["artifact"]
    if not artifact.exists():
        raise SystemExit(f"missing pass artifact: {artifact}")
    if item.get("status") != "completed" or item.get("exit") != 0:
        raise SystemExit(f"pass did not complete cleanly: {item.get('id')}")
    for profile in profiles:
        if f"/{profile}/" in item["artifact"]:
            profiles[profile] += 1

for profile, count in profiles.items():
    if count < 2:
        raise SystemExit(f"profile {profile} has fewer than 2 pass artifacts")

expected_outputs = [
    run_dir / "research" / "_synthesis.md",
    run_dir / "planning" / "_synthesis.md",
    run_dir / "review" / "_reconciliation.md",
    run_dir / "review" / "reviewed-todo-addendum.md",
    root / "00-project" / "research" / "2026-07-06-phase3-sync-status-research.md",
    root / "00-project" / "plans" / "2026-07-06-legacy-meta-compatibility-follow-up-implementation-plan.md",
]
for path in expected_outputs:
    if not path.exists():
        raise SystemExit(f"missing phase3 output: {path}")

for rel, expected in manifest.get("source_hashes", {}).items():
    if not expected.startswith("sha256:"):
        raise SystemExit(f"bad hash format for {rel}")
    path = root / rel
    if not path.exists():
        raise SystemExit(f"protected source missing: {path}")
    actual = "sha256:" + hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        raise SystemExit(f"protected source hash changed for {rel}: {actual} != {expected}")

print("adversarial phase3 pilot checks OK")
PY
