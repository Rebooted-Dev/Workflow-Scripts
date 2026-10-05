#!/usr/bin/env bash
# Self-test for check-plan.sh using isolated plan fixtures.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-plan.sh"
FIXTURES="$ROOT_DIR/scripts/validation/fixtures/check-plan"

# expect <pass|fail> <fixture> <message> [check-plan flags...]
expect() {
  local expected="$1" fixture="$2" message="$3" out code
  shift 3
  set +e
  out="$(bash "$CHECK" "$@" "$FIXTURES/$fixture" 2>&1)"
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
  if [ -n "$message" ] && ! printf '%s\n' "$out" | grep -Fq -- "$message"; then
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

# Canonical ticks: [✅] is the only completion mark in a tiered plan.
expect fail noncanonical-x-tick.md "line 11: non-canonical tick [x]"
expect fail noncanonical-criterion-tick.md "line 16: non-canonical tick [✓]"

# --require-tier: authoring and intake steps reject tier-less plans.
expect fail legacy-no-tier.md "--require-tier needs exactly one" --require-tier
expect pass t1-pass.md "OK (T1)" --require-tier

# --state: no silently open box once execution has started.
expect pass state-silent-open-task.md "OK (T1)"
expect fail state-silent-open-task.md "line 14: unticked task has no Open: reason" --state
expect pass state-open-with-reason.md "OK (T1, state)" --state
expect pass state-phase-open.md "OK (T1, state)" --state
expect fail state-silent-open-criterion.md "line 17: unticked criterion has no Open: reason" --state
expect fail state-ticked-parent-open-child.md "unticked sub-task under a ticked parent" --state
expect pass state-child-inherits-parent-open.md "OK (T1, state)" --state
expect fail state-invalid-open-reason.md "Open: reason must start with" --state
expect fail t1-pass.md "unticked task has no Open: reason" --state

# Usage errors exit 2.
set +e
bash "$CHECK" --bogus "$FIXTURES/t1-pass.md" >/dev/null 2>&1
code=$?
set -e
[ "$code" -eq 2 ] || { echo "FAIL: unknown flag should exit 2, got $code" >&2; exit 1; }

echo "check-plan self-test OK"
