#!/usr/bin/env bash
# Self-test for check-artifact-lifecycle-policy.sh.
#
# Copies the live maintained contract files into a throwaway fixture root
# (mktemp; no writes to this repository, no mutation of real plans or
# archives), first requires the unmutated copy to pass, then applies one
# small mutation per case and requires the policy check to fail with the
# expected message. This proves omissions and policy conflicts are caught,
# not just keyword presence.
#
# Until the artifact-lifecycle documentation lane lands, the baseline case
# fails with an explicit message; that temporary red state is expected and
# resolves when the docs merge.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CHECK="$ROOT_DIR/scripts/validation/check-artifact-lifecycle-policy.sh"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
pristine="$tmp/pristine"

mkdir -p "$pristine/00-Meta-Workflow/00-meta" "$pristine/04-documentation" \
  "$pristine/02-code-build" "$pristine/01-planning-and-organizing" \
  "$pristine/00-project/plans-completed" "$pristine/00-project/docs/agents"
cp "$ROOT_DIR/00-Meta-Workflow/00-meta/plan-template.md" "$pristine/00-Meta-Workflow/00-meta/"
cp "$ROOT_DIR/04-documentation/03-mark-completed.md" "$pristine/04-documentation/"
for f in 01-execution.md 02-confirm-execution.md 03-execute-and-confirm.md \
  04-review-finalise-commit-execute.md; do
  cp "$ROOT_DIR/02-code-build/$f" "$pristine/02-code-build/"
done
for f in 00-research-and-plan.md 01-plan-review.md 02-finalise-plan.md; do
  cp "$ROOT_DIR/01-planning-and-organizing/$f" "$pristine/01-planning-and-organizing/"
done
cp "$ROOT_DIR/00-project/plans-completed/README.md" "$pristine/00-project/plans-completed/"
cp "$ROOT_DIR/00-project/docs/agents/changelog-and-troubleshooting.md" \
  "$pristine/00-project/docs/agents/"

TPL_REL="00-Meta-Workflow/00-meta/plan-template.md"
GATE_REL="04-documentation/03-mark-completed.md"

expect() { # expect <pass|fail> <fixture-root> <description> <required-message-ERE>
  local want="$1" root="$2" desc="$3" pattern="$4" out code
  set +e
  out="$(bash "$CHECK" --root "$root" 2>&1)"
  code=$?
  set -e
  if [ "$want" = pass ] && [ "$code" -ne 0 ]; then
    echo "FAIL: $desc should pass: $out" >&2
    exit 1
  fi
  if [ "$want" = fail ] && [ "$code" -eq 0 ]; then
    echo "FAIL: $desc should fail (exit 0)" >&2
    exit 1
  fi
  if [ -n "$pattern" ] && ! printf '%s\n' "$out" | grep -qE -- "$pattern"; then
    echo "FAIL: $desc output lacks /$pattern/: $out" >&2
    exit 1
  fi
}

mutate() { # mutate <case-name> — fresh copy of pristine into tmp/<case-name>; echoes its root
  local case_root="$tmp/$1"
  rm -rf "$case_root"
  cp -R "$pristine" "$case_root"
  printf '%s' "$case_root"
}

# --- 0. Baseline: the unmutated live copy must pass ---------------------------
baseline="$(mutate baseline)"
if ! out="$(bash "$CHECK" --root "$baseline" 2>&1)"; then
  echo "FAIL: baseline live-copy does not pass (artifact-lifecycle docs lane still pending?): $out" >&2
  exit 1
fi
printf '%s\n' "$out" | grep -qF 'artifact lifecycle policy checks OK' \
  || { echo "FAIL: baseline passed without the OK line: $out" >&2; exit 1; }

# --- 1. Template: missing canonical lifecycle section -------------------------
root="$(mutate missing-inventory-section)"
sed -E '/^## Artifact Lifecycle and Terminal Filing/d' \
  "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "missing canonical Artifact Lifecycle section" \
  "lacks a canonical 'Artifact Lifecycle' section"

# --- 2. Template: missing inventory column ------------------------------------
root="$(mutate missing-relationship-column)"
sed -E 's/[Rr]elationship/kind/g' "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "inventory loses the relationship column" "lacks the 'relationship' column"

# --- 3. Template: eligibility exception broadened beyond filing ---------------
root="$(mutate broad-exception)"
awk 'ins == 0 && /^## Artifact Lifecycle and Terminal Filing/ {
  print; print ""; print "Ordinary tests, docs and acceptance obligations may also be excluded when convenient."; ins = 1; next
} { print }' "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "eligibility exception broadened beyond filing" "broader than terminal filing"

# --- 4. Template: pairing with the filing criterion removed -------------------
# Scoped to the canonical section only, so the skeleton seed stays intact and
# the canonical pairing check is the one that fires.
root="$(mutate missing-paired-criterion)"
sed -E '/^## Artifact Lifecycle and Terminal Filing/,/^## Marking Contract/s/[Cc]riterion/measurable/g' \
  "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "paired filing criterion removed" "paired with its filing Success Criterion"

# --- 4b. Template: skeleton loses its lifecycle seed ---------------------------
root="$(mutate skeleton-loses-seed)"
sed -E '/^## Artifact lifecycle$/d' "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "plan skeleton loses the lifecycle placeholder" \
  "plan skeleton lacks the '## Artifact lifecycle' section placeholder"

# --- 5. Gate: order phrase loses step 7 ---------------------------------------
root="$(mutate order-loses-step-7)"
sed -E 's/1, 2, 4, 5, 6, and 7/1, 2, 4, 5, and 6/g' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "order phrase loses step 7" "steps 1, 2, 4, 5, 6, and 7 before deferred step 3"

# --- 6. Gate: combined precheck flags split ------------------------------------
root="$(mutate split-combined-precheck)"
sed -E 's/--require-tier --state/--state/g' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "combined precheck flags split" "combine check-plan.sh --require-tier --state"

# --- 7. Gate: filing step no longer defers to the precheck --------------------
# Scoped to the Phase 4 step 3 block only: the global order phrase and the
# step 7 precheck line survive, so the step-3-specific deferral check fires.
root="$(mutate missing-precheck-reference)"
sed -E '/^3\. \*\*Plans-Completed/,/^4\. /{
  s/steps 1, 2, 4, 5, 6, and 7 have run/the earlier steps have run/
  s/[Bb]efore any move/prior to all changes/
  s/before moving/prior to relocating/
  s/--require-tier --state/--state/
  s/[Pp]re-?[Cc]heck/prework/g
  s/step 7/step seven/g
}' "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "filing step drops its precheck reference" "after the step 7 precheck"

# --- 8. Gate: post-edit combined re-check removed -----------------------------
# Neuters only the "After final marking" re-run clause of the marking bullet;
# the pre-marking lint survives, so the post-edit re-check assertion fires.
root="$(mutate missing-final-path-postcheck)"
sed 's|\*\*After final marking:\*\* re-run the same combined check on the actual current plan path to validate the status/tick edits|**After final marking:** the file is already final|' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "post-edit combined re-check removed" "the same combined check must be re-run"

# --- 9. Gate: status value dropped ---------------------------------------------
root="$(mutate status-value-dropped)"
sed -E 's/NOT VERIFIED/UNVERIFIED/g' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "NOT VERIFIED status dropped" "lacks the 'NOT VERIFIED' status value"

# --- 10. Gate: COMPLETED no longer requires both verified ---------------------
root="$(mutate completed-without-both)"
sed -E 's/[Bb]oth/pair/g' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "COMPLETED rule loses the both-verified requirement" \
  "must require both implementation and filing verified"

# --- 11. Gate: early marker on unresolved policy -------------------------------
root="$(mutate early-marker)"
printf '\nIf the host policy is unresolved: still apply the completion marker, as before.\n' \
  >> "$root/$GATE_REL"
expect fail "$root" "marker applied despite unresolved filing" "must not still apply the completion marker"

# --- 12. Gate: resumable filing rule removed ----------------------------------
root="$(mutate missing-resume-rule)"
sed -E 's/[Rr]esum(e|ed|able|ption)/restart/g' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "resumable filing rule removed" "resumable"

# --- 13. Gate: privacy review removed -----------------------------------------
root="$(mutate missing-privacy-review)"
awk '!(tolower($0) ~ /(privacy|sensitive|sanitiz)/)' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "privacy review removed" "privacy/sensitive evidence|cannot locate Phase 4 step 3"

# --- 14. Execution handoff loses the artifact inventory -----------------------
root="$(mutate missing-execution-handoff)"
sed -E -e 's/[Aa]rtifact/gadgetry/g' -e 's/[Ii]nventory/stuff/g' -e 's/[Ll]ifecycle/flow/g' \
  "$root/02-code-build/01-execution.md" > "$root/02-code-build/01-execution.md.tmp" \
  && mv "$root/02-code-build/01-execution.md.tmp" "$root/02-code-build/01-execution.md"
expect fail "$root" "execution loses the artifact handoff" "does not hand off the artifact inventory/evidence"

# --- 15. Filing guide stops routing through the gate --------------------------
root="$(mutate routing-bypasses-gate)"
sed 's/03-mark-completed/legacy-filing/g' \
  "$root/00-project/plans-completed/README.md" > "$root/00-project/plans-completed/README.md.tmp" \
  && mv "$root/00-project/plans-completed/README.md.tmp" "$root/00-project/plans-completed/README.md"
expect fail "$root" "filing guide bypasses the gate" "does not route completion filing through the terminal gate"

# --- 16. Gate: Phase 1 intake step removed ------------------------------------
root="$(mutate missing-intake-step)"
sed -E '/^3\. \*\*Establish or validate the artifact lifecycle intake/,/^### Phase 2:/{/^### Phase 2:/!d;}' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "Phase 1 intake step removed" "lacks the artifact lifecycle intake step"

# --- 17. Gate: intake no longer runs before coverage/eligibility/lint --------
# Neutralizes both ordering clauses (the before-parenthetical and "up front").
root="$(mutate intake-no-longer-first)"
sed -e 's/(before any task-coverage, eligibility, or lint decision)/(whenever convenient)/' \
  -e 's/up front/late in Phase 4/' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "intake loses its before-anything ordering" \
  "before any task-coverage, eligibility, or lint decision"

# --- 18. Gate: Reconcile-only mode table drops step 7 -------------------------
root="$(mutate reconcile-row-loses-step-7)"
sed 's/Phase 4 steps 1, 2, 4, 5, 6, 7/Phase 4 steps 1, 2, 4, 5, 6/' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "Reconcile-only mode table drops step 7" \
  "Reconcile-only mode must include Phase 4 step 7"

# --- 19. Gate: early filing-pair tick inserted into Phase 3 -------------------
# The correct identity-only sentence stays; the unsafe early tick must still
# be caught, proving later correct wording cannot mask an early insertion.
root="$(mutate phase3-early-tick)"
awk '/^### Phase 4:/ && ins == 0 { print "   - Tick the terminal filing pair now and correct it later after filing verifies."; print ""; ins = 1 } { print }' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "early filing-pair tick inserted into Phase 3" \
  "Phase 3 must not tick the filing pair"

# --- 20. Template: broad 'any other open box' eligibility re-added ------------
root="$(mutate broad-open-box-eligibility)"
awk 'ins == 0 && /^## Artifact Lifecycle and Terminal Filing/ {
  print; print ""; print "Any other open box of any kind keeps the plan Not Eligible."; ins = 1; next
} { print }' "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "broad any-other-open-box eligibility re-added" \
  "broader than committed in-scope work"

# --- 21. Template: in-scope qualifier dropped from 'committed' ----------------
root="$(mutate committed-loses-in-scope)"
sed 's/committed in-scope/declared/' "$root/$TPL_REL" > "$root/$TPL_REL.tmp" \
  && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "committed loses its in-scope qualifier" \
  "must be qualified as in-scope"

# --- 22. Template: external/non-goal debt carve-out removed -------------------
root="$(mutate external-debt-carveout-removed)"
sed 's/external or non-goal debt/other debt/' "$root/$TPL_REL" > "$root/$TPL_REL.tmp" \
  && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "external/non-goal debt carve-out removed" \
  "external/non-goal debt"

# --- 23. Gate: marker-rollback bullet removed ---------------------------------
root="$(mutate rollback-bullet-removed)"
sed '/If the final-path lint, link, or index verification fails/d' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "marker-rollback bullet removed" "final-check failure must remove"

# --- 24. Gate: already-filed revalidation guard removed -----------------------
root="$(mutate revalidation-guard-removed)"
sed '/never blindly reset/d' "$root/$GATE_REL" > "$root/$GATE_REL.tmp" \
  && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "revalidation guard removed" "must not blindly reset"

# --- 25. Gate: final postcheck regresses to a fixed archived path -------------
root="$(mutate actual-path-regression)"
sed 's/actual current plan path/final archived path/' "$root/$GATE_REL" > "$root/$GATE_REL.tmp" \
  && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "actual-current-path postcheck regresses" "actual current path"

# --- 26. Template: T1 tier-raise guard removed --------------------------------
root="$(mutate tier-raise-guard-removed)"
sed 's/never raise a tier for filing and never pull in unrelated T2\/T3 sections/keep it minimal/' \
  "$root/$TPL_REL" > "$root/$TPL_REL.tmp" && mv "$root/$TPL_REL.tmp" "$root/$TPL_REL"
expect fail "$root" "T1 tier-raise guard removed" "must never raise a plan's tier"

# --- 27. Gate: old status-after-marker ordering re-introduced (masking test) --
# Appends the forbidden order (tick+marker first, lint, only then record
# VERIFIED) INSIDE the marking bullet while every correct sentence stays, so a
# later correct clause cannot mask the unsafe ordering.
root="$(mutate status-after-marker-order)"
sed 's|otherwise apply the failure rule below\.|otherwise apply the failure rule below. Alternatively, tick the filing pair and apply the completion marker first, then run the final lint and only then record `Package filing: VERIFIED`.|' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "old status-after-marker ordering re-introduced alongside correct wording" \
  "must be recorded before the pair is ticked"

# --- 28. Gate: pre-marking lint no longer runs with the pair unchecked --------
root="$(mutate premarking-lint-ignores-pair)"
sed 's/with the filing pair still unchecked and explained/with the filing pair already ticked if convenient/' \
  "$root/$GATE_REL" > "$root/$GATE_REL.tmp" && mv "$root/$GATE_REL.tmp" "$root/$GATE_REL"
expect fail "$root" "pre-marking lint loses its pair-still-unchecked requirement" \
  "pair still unchecked"

echo "check-artifact-lifecycle-policy self-test OK"
