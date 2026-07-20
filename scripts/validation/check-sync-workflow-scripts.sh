#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/sync-workflow-scripts.sh"

fail() {
  echo "sync-workflow-scripts check failed: $*" >&2
  exit 1
}

if grep -q 'mapfile' "$SCRIPT"; then
  fail "mapfile is not bash 3.2 compatible"
fi

if grep -Eq '\(\([A-Za-z_][A-Za-z0-9_]*\+\+\)\)' "$SCRIPT"; then
  fail "post-increment counters can exit under set -e"
fi

if grep -q 'cd "$workflows_path"' "$SCRIPT"; then
  fail "main loops must use git -C instead of cd into Workflow-Scripts"
fi

if ! grep -q 'git@github.com:Rebooted-Dev/Workflow-Scripts' "$SCRIPT"; then
  fail "SSH Workflow-Scripts remote is not accepted"
fi

temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

empty_base="$temp_dir/empty"
mkdir -p "$empty_base"
WORKFLOW_SYNC_BASE_DIR="$empty_base" bash "$SCRIPT" --auto --status >/tmp/check-sync-empty.out
grep -q 'No projects found' /tmp/check-sync-empty.out || fail "empty auto-discovery did not exit cleanly"

project="$temp_dir/project"
mkdir -p "$project"
git init -q "$project/Workflow-Scripts"
git -C "$project/Workflow-Scripts" config user.email "test@example.com"
git -C "$project/Workflow-Scripts" config user.name "Test User"
printf 'x\n' > "$project/Workflow-Scripts/README.md"
git -C "$project/Workflow-Scripts" add README.md
git -C "$project/Workflow-Scripts" commit -q -m init
git -C "$project/Workflow-Scripts" remote add origin git@github.com:Rebooted-Dev/Workflow-Scripts.git

WORKFLOW_SYNC_PROJECTS="$project" bash "$SCRIPT" --status >/tmp/check-sync-status.out
grep -q 'Fetch failed' /tmp/check-sync-status.out || fail "relative WORKFLOW_SYNC_PROJECTS or SSH remote handling failed"

echo "sync-workflow-scripts checks OK"
