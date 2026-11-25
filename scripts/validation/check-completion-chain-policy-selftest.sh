#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
# Materialize the committed policy corpus and overlay the validator under test.
git -C "${WORKFLOW_TEST_SOURCE:-$ROOT_DIR}" archive HEAD > "$fixture/repo.tar"
tar -xf "$fixture/repo.tar" -C "$fixture"
cp "$ROOT_DIR/scripts/validation/check-completion-chain-policy.sh" "$fixture/scripts/validation/check-completion-chain-policy.sh"
bash "$fixture/scripts/validation/check-completion-chain-policy.sh"
python3 - "$fixture/04-documentation/03-mark-completed.md" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1]); original = p.read_text()
assert original.count('**Verified plan tasks:**') == 1
p.write_text(original.replace('**Verified plan tasks:**', '**Confirmed work:**', 1))
PY
if bash "$fixture/scripts/validation/check-completion-chain-policy.sh" > "$fixture/out" 2>&1; then
  echo 'missing required phrase incorrectly passed' >&2
  exit 1
fi
grep -qF 'lacks required concept: verified plan tasks' "$fixture/out"
echo 'completion chain policy self-test OK'
