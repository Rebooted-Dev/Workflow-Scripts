#!/usr/bin/env bash
# Completion-chain policy validator.
#
# Asserts the Workflow-Scripts completion chain is unambiguous:
#   - 03-mark-completed.md is the SOLE positive terminal owner (✅ marks,
#     completion marker, archive). 01/02 confirm/execute report verification
#     and may downgrade false claims, but never finalize or archive.
#   - The combined 01 -> 02 -> 03-mark-completed handoff is mandatory, with
#     explicit "Verified Complete" / "Not Eligible" outcomes.
#   - No generic hardcoded archive destination in the code-build chain.
#   - The terminal gate resolves archive routing from host policy, fails
#     closed on unresolved policy, and uses deterministic active-plan
#     discovery (named target first; never scans archives by default).
#   - Navigation links the terminal gate from the root README, the
#     code-build README, the documentation README, and the skill.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CB="$ROOT_DIR/02-code-build"
DOC="$ROOT_DIR/04-documentation"
SKILL="$ROOT_DIR/11-Skills/execute-and-confirm-plan/SKILL.md"

fail() { echo "check-completion-chain-policy: $*" >&2; exit 1; }

# --- 1. 01/02 must not independently archive a plan ----------------------------
if grep -RInE 'If plan is fully completed, file it in|File the completed plan in `project/plans-completed' \
  "$CB/01-execution.md" "$CB/02-confirm-execution.md"; then
  fail "01/02 still independently archive a plan (only the terminal gate may archive)"
fi

# 02 must not add a completion marker; only the gate owns that.
if grep -RIn 'If a completion marker is not already present, add one' "$CB/02-confirm-execution.md"; then
  fail "02 still adds a completion marker (only the terminal gate may do so)"
fi

# --- 2. Mandatory combined handoff with explicit terminal outcomes -------------
for token in "Verified Complete" "Not Eligible"; do
  grep -q "$token" "$CB/03-execute-and-confirm.md" \
    || fail "03-execute-and-confirm.md missing required terminal outcome: $token"
done

grep -qi 'mandatory' "$CB/03-execute-and-confirm.md" \
  || fail "03-execute-and-confirm.md does not mark the terminal gate as mandatory"

# The skill must route to the terminal gate and not bypass it.
grep -q 'terminal gate' "$SKILL" \
  || fail "execute-and-confirm-plan skill does not route to the terminal gate"

# --- 3. No generic hardcoded archive destination in the code-build chain -------
if grep -RInE 'Archive the plan into `project/changelog/plans/`' \
  "$CB/01-execution.md" "$CB/02-confirm-execution.md" "$CB/03-execute-and-confirm.md"; then
  fail "Generic hardcoded archive path remains in code-build chain"
fi

# --- 4. Terminal gate resolves archive routing from host policy ----------------
grep -q "host repository" "$DOC/03-mark-completed.md" \
  || fail "Terminal gate does not resolve archive routing from host policy"
grep -q "policy unresolved" "$DOC/03-mark-completed.md" \
  || fail "Terminal gate lacks Not-Eligible/policy-unresolved outcome for missing host policy"

# --- 5. Deterministic active-plan discovery (named target first) ---------------
grep -q "Named target first" "$DOC/03-mark-completed.md" \
  || fail "Terminal gate lacks named-target-first discovery"
if grep -RInE 'Scan `project/build/` and `project/changelog/plans/`' "$DOC/03-mark-completed.md"; then
  fail "Terminal gate still scans archived plans for active claims"
fi

# --- 6. Navigation links the terminal gate ------------------------------------
grep -q '04-documentation/03-mark-completed.md' "$ROOT_DIR/README.md" \
  || fail "Root README does not link the terminal gate"
grep -q '03-mark-completed.md' "$DOC/README.md" \
  || fail "04-documentation README does not reference the terminal gate"
grep -q '03-mark-completed' "$CB/README.md" \
  || fail "02-code-build README does not reference the terminal gate"

echo "completion chain policy checks OK"
