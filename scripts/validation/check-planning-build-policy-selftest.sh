#!/usr/bin/env bash
# Exercise Phase A planning/build policy checks against isolated fixture roots.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-planning-build-policy.sh"
FIXTURES="$ROOT_DIR/scripts/validation/fixtures/planning-build-policy"

expect() {
  local expected="$1" fixture="$2" message="$3" out code
  set +e
  out="$(bash "$CHECK" "$FIXTURES/$fixture" 2>&1)"
  code=$?
  set -e

  if [ "$expected" = pass ] && [ "$code" -ne 0 ]; then
    echo "FAIL: $message should pass: $out" >&2
    exit 1
  fi
  if [ "$expected" = fail ] && [ "$code" -eq 0 ]; then
    echo "FAIL: $message should fail" >&2
    exit 1
  fi
  if [ -n "$message" ] && ! printf '%s\n' "$out" | grep -Fq "$message"; then
    echo "FAIL: $message missing from output: $out" >&2
    exit 1
  fi
}

expect pass pass "planning/build policy checks OK"
expect fail fail-aggressively "must not contain 'aggressively'"
expect fail fail-librarian-agents "must not contain 'librarian agents'"
expect fail fail-parallel-without-applicability "workflow-applicability.md"
expect fail fail-parallel-bare-reference "workflow-applicability.md"

echo "check-planning-build-policy self-test OK"
