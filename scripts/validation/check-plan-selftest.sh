#!/usr/bin/env bash
# Self-test for check-plan.sh using isolated plan fixtures.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-plan.sh"
FIXTURES="$ROOT_DIR/scripts/validation/fixtures/check-plan"

expect() {
  local expected="$1" fixture="$2" message="$3" out code
  set +e
  out="$(bash "$CHECK" "$FIXTURES/$fixture" 2>&1)"
  code=$?
  set -e

  if [ "$expected" = pass ] && [ "$code" -ne 0 ]; then
    echo "FAIL: $fixture should pass: $out" >&2
    exit 1
  fi
  if [ "$expected" = fail ] && [ "$code" -eq 0 ]; then
    echo "FAIL: $fixture should fail" >&2
    exit 1
  fi
  if [ -n "$message" ] && ! printf '%s\n' "$out" | grep -Fq "$message"; then
    echo "FAIL: $fixture output lacks '$message': $out" >&2
    exit 1
  fi
}

expect pass t1-pass.md "OK (T1)"
expect pass t2-pass.md "OK (T2)"
expect fail missing-verify.md "task 1 is missing Verify:"
expect fail single-decision-option.md "at least two Option lines"
expect pass legacy-no-tier.md "warning: no **Tier:** header"
expect pass success-criteria-checkboxes.md "OK (T1)"
expect fail missing-files.md "task 1 is missing Files:"
expect fail malformed-tier.md "malformed Tier header"
expect fail child-verify-does-not-satisfy-parent.md "task 1 is missing Verify:"
expect fail phase-preamble-verify-does-not-satisfy-task.md "task 1 is missing Verify:"
expect pass phase-headings-group-tasks.md "OK (T1)"
expect pass parent-fields-after-child.md "OK (T1)"
expect fail nested-child-verify-does-not-satisfy-parent.md "task 1 is missing Verify:"
expect fail all-indented-sibling-missing-verify.md "task 2 is missing Verify:"
expect fail mixed-indent-sibling-missing-verify.md "task 2 is missing Verify:"
expect fail ambiguous-low-indent-child.md "ambiguous 0-3-space nesting"
expect fail orphan-four-space-task.md "without an active parent task"
expect fail tab-indented-task.md "uses tab indentation"
expect fail grandchild-verify-does-not-satisfy-parent.md "task 1 is missing Verify:"
expect pass parent-verify-after-grandchild.md "OK (T1)"

echo "check-plan self-test OK"
