#!/usr/bin/env bash
# Phase A invariants for the active planning and code-build workflow families.
# Keep each phase's checks in separate functions/sections so later phases can
# add their own invariants without enforcing rules before their docs are live.
set -euo pipefail

if [ "$#" -gt 1 ]; then
  echo "usage: check-planning-build-policy.sh [workflow-scripts-root]" >&2
  exit 2
fi

ROOT_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
if [ ! -d "$ROOT_DIR" ]; then
  echo "check-planning-build-policy: not a directory: $ROOT_DIR" >&2
  exit 2
fi

PLANNING_DIR="$ROOT_DIR/01-planning-and-organizing"
CODE_BUILD_DIR="$ROOT_DIR/02-code-build"
WORKFLOW_DIRS=( "$PLANNING_DIR" "$CODE_BUILD_DIR" )

fail() { echo "check-planning-build-policy: $*" >&2; exit 1; }

# --- Phase A: remove overly prescriptive planning/build agent wording ---------
check_phase_a_wording() {
  local token dir matches
  for token in aggressively 'librarian agents'; do
    for dir in "${WORKFLOW_DIRS[@]}"; do
      [ -d "$dir" ] || continue
      if matches="$(grep -RInFi "$token" "$dir" || true)" && [ -n "$matches" ]; then
        printf '%s\n' "$matches" >&2
        fail "planning/build workflows must not contain '$token'"
      fi
    done
  done
}

# --- Phase A: parallel-agent instructions cite the sizing/applicability policy -
check_phase_a_parallel_applicability() {
  local dir files file
  for dir in "${WORKFLOW_DIRS[@]}"; do
    [ -d "$dir" ] || continue
    files="$(grep -RilE 'parallel agents?' "$dir" || true)"
    while IFS= read -r file; do
      [ -n "$file" ] || continue
      grep -qiE ']\([^)]*workflow-applicability\.md[^)]*\)' "$file" \
        || fail "parallel-agent instruction lacks workflow-applicability.md: $file"
    done <<< "$files"
  done
}

check_phase_a_wording
check_phase_a_parallel_applicability

# Future Phase B/C invariants belong in phase-specific checks above/below only
# when those phases' workflow changes land. Do not pre-enforce deferred rules.
echo "planning/build policy checks OK"
