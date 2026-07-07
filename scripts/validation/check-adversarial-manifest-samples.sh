#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SAMPLES_DIR="$ROOT/00-project/build/adversarial-multi-model-workflow/samples"

python3 - "$SAMPLES_DIR" <<'PY'
import json
import sys
from pathlib import Path

samples_dir = Path(sys.argv[1])
root = samples_dir.parent
profile_dir = root / "profile-drafts"
dry_run_dir = root / "synthetic-dry-runs"
required_top = {
    "schema_version",
    "run_id",
    "profile",
    "source_path",
    "source_hashes",
    "launched_at",
    "default_timeout_minutes",
    "quorum",
    "passes",
    "protected_paths",
    "synthesized_at",
    "reconciled_at",
    "cleanup",
}
required_pass = {
    "id",
    "model",
    "harness",
    "role",
    "status",
    "exit",
    "artifact",
    "started_at",
    "finished_at",
    "claims_or_findings",
    "notes",
}
allowed_profiles = {"research", "planning", "review"}
allowed_statuses = {"pending", "running", "completed", "failed", "timeout", "dropped"}

paths = sorted(samples_dir.glob("*-manifest.sample.json"))
if not paths:
    raise SystemExit("no manifest samples found")

for path in paths:
    data = json.loads(path.read_text())
    missing = sorted(required_top - data.keys())
    if missing:
        raise SystemExit(f"{path}: missing top-level fields: {', '.join(missing)}")
    if data["profile"] not in allowed_profiles:
        raise SystemExit(f"{path}: invalid profile {data['profile']!r}")
    if not isinstance(data["passes"], list) or not data["passes"]:
        raise SystemExit(f"{path}: passes must be a non-empty list")
    for idx, item in enumerate(data["passes"]):
        missing_pass = sorted(required_pass - item.keys())
        if missing_pass:
            raise SystemExit(f"{path}: pass {idx} missing fields: {', '.join(missing_pass)}")
        if item["status"] not in allowed_statuses:
            raise SystemExit(f"{path}: pass {idx} invalid status {item['status']!r}")
    cleanup = data["cleanup"]
    if cleanup.get("decision") not in {"keep", "delete", "archive"}:
        raise SystemExit(f"{path}: invalid cleanup decision {cleanup.get('decision')!r}")

print(f"validated {len(paths)} adversarial manifest samples")

profile_paths = {
    "research": profile_dir / "adversarial-research-profile.md",
    "planning": profile_dir / "adversarial-planning-profile.md",
    "review": profile_dir / "adversarial-plan-review-profile.md",
}
for profile, path in profile_paths.items():
    if not path.exists():
        raise SystemExit(f"missing profile draft: {path}")
    text = path.read_text()
    for required in ("## Roles", "## Merge Rules", "## Model/Harness Appendix"):
        if required not in text:
            raise SystemExit(f"{path}: missing {required}")
    if profile == "review" and "## Finding Schema" not in text:
        raise SystemExit(f"{path}: missing finding schema")
    if profile in {"research", "planning"} and "Schema" not in text:
        raise SystemExit(f"{path}: missing schema section")

expected_dry_runs = [
    dry_run_dir / "research" / "_synthesis.md",
    dry_run_dir / "planning" / "_synthesis.md",
    dry_run_dir / "review" / "_reconciliation.md",
]
for path in expected_dry_runs:
    if not path.exists():
        raise SystemExit(f"missing synthetic dry-run output: {path}")
    text = path.read_text()
    for required in ("Manifest:", "## Cleanup Decision", "## Canonical Output"):
        if required not in text:
            raise SystemExit(f"{path}: missing {required}")

shared_synthesis = root / "draft-workflows" / "multi-agent-synthesis.md"
if not shared_synthesis.exists():
    raise SystemExit(f"missing shared synthesis contract: {shared_synthesis}")

print("validated adversarial profile drafts and synthetic dry-runs")
PY
