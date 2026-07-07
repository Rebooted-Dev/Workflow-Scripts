#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROTO="$ROOT/00-project/build/adversarial-multi-model-workflow/prototypes"
LAUNCHER="$PROTO/fan-out-adversarial.sh"
FIXTURE="$PROTO/fixtures/hash-guard-source.md"

fail() {
  echo "adversarial launcher check failed: $*" >&2
  exit 1
}

bash "$LAUNCHER" --config "$PROTO/configs/research-two-pass.json" >/tmp/adversarial-launcher-research.out
grep -q "wrote 2 pass artifact" /tmp/adversarial-launcher-research.out || fail "research smoke did not write two artifacts"
test -f "$ROOT/00-project/build/adversarial-multi-model-workflow/runs/20260706-234000-research-launcher-smoke/_manifest.json" || fail "research manifest missing"

bash "$LAUNCHER" --config "$PROTO/configs/review-two-pass.json" >/tmp/adversarial-launcher-review.out
grep -q "wrote 2 pass artifact" /tmp/adversarial-launcher-review.out || fail "review smoke did not write two artifacts"
test -f "$ROOT/00-project/build/adversarial-multi-model-workflow/runs/20260706-234500-review-launcher-smoke/_manifest.json" || fail "review manifest missing"

fixture_before="$(cat "$FIXTURE")"
set +e
bash "$LAUNCHER" --config "$PROTO/configs/hash-guard-negative.json" >/tmp/adversarial-launcher-negative.out 2>/tmp/adversarial-launcher-negative.err
negative_status=$?
set -e
printf '%s\n' "$fixture_before" > "$FIXTURE"

if [ "$negative_status" -eq 0 ]; then
  fail "hash guard negative run unexpectedly succeeded"
fi
grep -q "protected path changed during run" /tmp/adversarial-launcher-negative.err || fail "negative run did not report protected hash failure"

echo "adversarial launcher checks OK"
