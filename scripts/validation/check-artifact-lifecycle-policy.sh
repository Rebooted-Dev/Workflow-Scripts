#!/usr/bin/env bash
# Artifact-lifecycle policy validator (plan-artifact completion filing).
#
# Asserts the maintained instruction/contract layer of the artifact-filing
# lifecycle adopted by the plan-artifact completion filing plan:
#   - The shared plan template defines an "Artifact lifecycle" inventory
#     (owner, relationship, disposition, verification) and an implementation-
#     eligibility exception that is explicitly PAIRED (gate-owned filing task
#     + its filing Success Criterion) and limited to filing ONLY.
#   - The terminal gate (04-documentation/03-mark-completed.md) keeps both
#     modes, runs Phase 4 steps 1, 2, 4, 5, 6, and 7 before the deferred
#     filing step 3, prechecks the plan with check-plan.sh --require-tier
#     --state at the current path before any move, re-runs the state check
#     on the exact final archived path after moves, reports implementation
#     and filing as separate statuses (Implementation verification:
#     VERIFIED/NOT VERIFIED; Package filing: PENDING/BLOCKED/PARTIAL/
#     VERIFIED), applies the completion marker only after filing effects
#     verify, reviews privacy/retained/shared records before moving, and
#     files without overwriting, duplicating index rows, or losing resume.
#   - Execution/confirmation/wrapper workflows hand the inventory/evidence
#     to the gate instead of regaining competing archive authority, and the
#     wrapper explains the gate returns the final filed path.
#   - Planning workflows seed/maintain/check the inventory, and the filing
#     guides route through the gate.
#
# Legacy completion-chain invariants stay in check-completion-chain-policy.sh;
# this file owns only the new filing-lifecycle contract. It never parses
# plan inventories, requires a manifest format, or retrofits old plans.
#
# Usage: check-artifact-lifecycle-policy.sh [--root <workflow-scripts-root>]
set -euo pipefail

usage() {
  echo "usage: check-artifact-lifecycle-policy.sh [--root <workflow-scripts-root>]" >&2
}

ROOT_ARG=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --root)
      [ "$#" -ge 2 ] || { echo "check-artifact-lifecycle-policy: --root requires a value" >&2; exit 2; }
      [ -z "$ROOT_ARG" ] || { echo "check-artifact-lifecycle-policy: --root given twice" >&2; exit 2; }
      ROOT_ARG="$2"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *)
      echo "check-artifact-lifecycle-policy: unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

ROOT_DIR="${ROOT_ARG:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
[ -d "$ROOT_DIR" ] || { echo "check-artifact-lifecycle-policy: not a directory: $ROOT_DIR" >&2; exit 2; }

META="$ROOT_DIR/00-Meta-Workflow/00-meta"
PLAN="$ROOT_DIR/01-planning-and-organizing"
CB="$ROOT_DIR/02-code-build"
DOC="$ROOT_DIR/04-documentation"
TPL="$META/plan-template.md"
GATE="$DOC/03-mark-completed.md"

fail() { echo "check-artifact-lifecycle-policy: $*" >&2; exit 1; }
require_file() { [ -f "$1" ] || fail "$2 is missing"; }

for f in "$TPL" "$GATE" \
  "$CB/01-execution.md" "$CB/02-confirm-execution.md" \
  "$CB/03-execute-and-confirm.md" "$CB/04-review-finalise-commit-execute.md" \
  "$PLAN/00-research-and-plan.md" "$PLAN/01-plan-review.md" "$PLAN/02-finalise-plan.md" \
  "$ROOT_DIR/00-project/plans-completed/README.md" \
  "$ROOT_DIR/00-project/docs/agents/changelog-and-troubleshooting.md"; do
  require_file "$f" "${f#"$ROOT_DIR"/}"
done

# --- 1. Template: Artifact lifecycle inventory --------------------------------
# Extract the CANONICAL section only: fenced code (the plan skeleton's
# `## Artifact lifecycle` placeholder) is skipped, and the extraction runs to
# the next `## ` heading so `###` subsections are captured.
lifecycle_section="$(awk '
  /^([[:space:]]*)(```|~~~)/ { in_fence = !in_fence; next }
  in_fence { next }
  /^#{2,3}[[:space:]]+[Aa]rtifact [Ll]ifecycle/ { flag = 1; next }
  flag && /^## / { exit }
  flag { print }
' "$TPL")"
[ -n "$lifecycle_section" ] \
  || fail "plan-template.md lacks a canonical 'Artifact Lifecycle' section (outside the fenced skeleton)"
for token in relationship disposition; do
  printf '%s\n' "$lifecycle_section" | grep -qi "$token" \
    || fail "Artifact lifecycle inventory lacks the '$token' column"
done
printf '%s\n' "$lifecycle_section" | grep -qiE 'owner|repositor' \
  || fail "Artifact lifecycle inventory lacks the owning-repository column"
printf '%s\n' "$lifecycle_section" | grep -qi 'verif' \
  || fail "Artifact lifecycle inventory lacks the verification column"

# The fenced plan skeleton is the seed role: generated plans must still carry
# the lifecycle section, the gate-owned terminal filing task, and the paired
# filing criterion.
skeleton="$(awk '
  /^([[:space:]]*)(```|~~~)/ { in_fence = !in_fence; next }
  !in_fence { next }
  { print }
' "$TPL")"
printf '%s\n' "$skeleton" | grep -qiE '^[[:space:]]*#+[[:space:]]*[Aa]rtifact [Ll]ifecycle' \
  || fail "plan skeleton lacks the '## Artifact lifecycle' section placeholder"
printf '%s\n' "$skeleton" | grep -qiE 'terminal gate|gate-owned' \
  || fail "plan skeleton lacks the gate-owned terminal filing task"
printf '%s\n' "$skeleton" | grep -qi 'filing criterion' \
  || fail "plan skeleton lacks the paired filing criterion"

# --- 2. Template: paired, filing-only eligibility exception -------------------
# The eligibility exception belongs to the artifact lifecycle contract; accept
# it in the lifecycle section or the Marking Contract (both template-owned
# contract contexts). Sentence wrapping may put the subject (filing task) and
# the verb (excluded) on different lines, so the pairing/limiter checks run on
# the whole combined region.
marking_section="$(awk '
  /^([[:space:]]*)(```|~~~)/ { in_fence = !in_fence; next }
  in_fence { next }
  /^## Marking Contract/ { flag = 1; next }
  flag && /^## / { exit }
  flag { print }
' "$TPL")"
eligibility_region="${lifecycle_section}
${marking_section}"
printf '%s\n' "$eligibility_region" | grep -qiE 'eligib|exclud|prerequis' \
  || fail "Artifact lifecycle section states no implementation-eligibility rule for the terminal filing task"
printf '%s\n' "$eligibility_region" | grep -qiE 'filing task|terminal( filing)? task|gate-owned' \
  || fail "eligibility exception must name the gate-owned filing task"
printf '%s\n' "$eligibility_region" | grep -qi 'criterion' \
  || fail "eligibility exception must be paired with its filing Success Criterion"
printf '%s\n' "$eligibility_region" | grep -qiE 'only|exclusively|solely' \
  || fail "eligibility exception must be limited to terminal filing only"
if printf '%s\n' "$eligibility_region" | grep -qiE \
  'may also be excluded|all (open )?(tasks|boxes|criteria)|any task|obligations may'; then
  fail "eligibility exception is broader than terminal filing"
fi
# The exclusion scope is committed in-scope work: a broad "any other open box"
# rule would let external non-goal debt block completion again.
if printf '%s\n' "$eligibility_region" | grep -qiE 'any (other )?open box'; then
  fail "eligibility is broader than committed in-scope work ('any other open box')"
fi

# --- 2b. Template: committed in-scope scope, external debt, T1 proportionality -
printf '%s\n' "$lifecycle_section" | grep -qi 'committed' \
  || fail "eligibility must scope to committed work"
printf '%s\n' "$lifecycle_section" | grep -i 'committed' | grep -qiE 'in-scope|in scope' \
  || fail "eligibility 'committed' must be qualified as in-scope"
printf '%s\n' "$lifecycle_section" | grep -qiE '(external|non-goal)' \
  || fail "external/non-goal debt must be named in the eligibility rule"
printf '%s\n' "$lifecycle_section" | grep -qiE \
  '(external|non-goal).*debt.*(open|routed).*(without blocking|not block)|(without blocking|not block).*(external|non-goal)' \
  || fail "external/non-goal debt stays open and routed without blocking"
printf '%s\n' "$lifecycle_section" | grep -qiE \
  'deferred.*(committed|in scope|inside).*(Not Eligible|block)|(committed|in scope).*deferred.*(Not Eligible|block)' \
  || fail "deferred work committed inside the plan's scope must keep the plan Not Eligible"
printf '%s\n' "$lifecycle_section" | grep -qi 'T1' \
  || fail "proportionality must address T1 plans"
printf '%s\n' "$lifecycle_section" | grep -qiE '(never raise|no tier upgrade|not raise).*tier|tier.*(never raise|no tier upgrade)' \
  || fail "filing must never raise a plan's tier"
printf '%s\n' "$lifecycle_section" | grep -qi 'unrelated' \
  || fail "filing must not pull in unrelated T2/T3 sections"
printf '%s\n' "$lifecycle_section" | grep -qiE 'no separate manifest|manifest.*(not required|optional)' \
  || fail "no separate manifest file may be required"

# --- 3. Gate: order, precheck, and final-path postcheck -----------------------
grep -qF '1, 2, 4, 5, 6, and 7' "$GATE" \
  || fail "gate does not run Phase 4 steps 1, 2, 4, 5, 6, and 7 before deferred step 3"
grep -qE -- '--require-tier --state' "$GATE" \
  || fail "gate precheck must combine check-plan.sh --require-tier --state before any move"

phase4="$(awk '
  /^### Phase 4:/ { flag = 1; next }
  flag && /^### Phase 5:/ { exit }
  flag { print }
' "$GATE")"
[ -n "$phase4" ] || fail "cannot locate Phase 4 in the terminal gate"
step3="$(printf '%s\n' "$phase4" | awk '
  /^[[:space:]]*(\*\*)?3\./ { flag = 1 }
  flag && /^[[:space:]]*(\*\*)?4\./ { exit }
  flag { print }
')"
[ -n "$step3" ] || fail "cannot locate Phase 4 step 3 (terminal filing) in the gate"
printf '%s\n' "$step3" | grep -qiE \
  'pre-?check|step 7|1, 2, 4, 5, 6, and 7|--require-tier --state|before (any move|moving|the move)' \
  || fail "filing step 3 must run only after the step 7 precheck"

state_total="$(printf '%s\n' "$phase4" | grep -cE -- '--state' || true)"
[ "$state_total" -ge 2 ] \
  || fail "gate must run the state check both before the move (precheck) and at the final path"
printf '%s\n' "$phase4" | grep -E -- '--state' | grep -qiE 'final|archiv|destination|filed' \
  || fail "gate must re-run the state check on the exact final archived path after moves"

# --- 3b. Gate: Reconcile-only mode independently includes Phase 4 step 7 ------
reconcile_row="$(grep -E '^\|[[:space:]]*\*\*Reconcile only\*\*' "$GATE" || true)"
[ -n "$reconcile_row" ] \
  || fail "gate mode table lacks the Reconcile only row"
printf '%s\n' "$reconcile_row" | grep -q '7' \
  || fail "Reconcile-only mode must include Phase 4 step 7 (mode table)"

# --- 3c. Gate: Phase 1 intake establishes the single inventory + pair first ---
phase1="$(awk '
  /^### Phase 1:/ { flag = 1; next }
  flag && /^### Phase 2:/ { exit }
  flag { print }
' "$GATE")"
intake_block="$(printf '%s\n' "$phase1" | awk 'tolower($0) ~ /intake/ { flag = 1 } flag { print }')"
[ -n "$intake_block" ] \
  || fail "gate Phase 1 lacks the artifact lifecycle intake step"
printf '%s\n' "$intake_block" | grep -qiE 'before any (task-coverage|coverage|eligibility|lint)|up front' \
  || fail "intake must run before any task-coverage, eligibility, or lint decision"
printf '%s\n' "$intake_block" | grep -qiE 'exactly one.*filing task|filing task.*exactly one' \
  || fail "intake must require exactly one designated filing task"
printf '%s\n' "$intake_block" | grep -qiE 'exactly one.*(paired )?filing criterion|criterion.*exactly one' \
  || fail "intake must require exactly one paired filing criterion"
printf '%s\n' "$intake_block" | grep -qiE 'missing.*(add|repair)|(add|repair).*missing' \
  || fail "intake must repair a missing task/criterion half"
printf '%s\n' "$intake_block" | grep -qiE 'uplicate.*(block|clarif|ask)|(block|clarif).*uplicate' \
  || fail "intake must block on duplicate or ambiguous pairs"
printf '%s\n' "$intake_block" | grep -qiE 'never deferred|up front' \
  || fail "intake must not be deferred into Phase 4 step 3"
printf '%s\n' "$intake_block" | grep -qiE 'even (when|for)|already has|Tier header|legacy|tier-less' \
  || fail "intake must apply even when the plan already has Tasks and a Tier header"

# --- 3d. Gate: Phase 3 audits filing identity only; no early tick ------------
phase3="$(awk '
  /^### Phase 3:/ { flag = 1; next }
  flag && /^### Phase 4:/ { exit }
  flag { print }
' "$GATE")"
printf '%s\n' "$phase3" | grep -qiE 'identity|presence and accuracy|prerequisites' \
  || fail "Phase 3 must audit the filing pair for identity/prerequisites only"
printf '%s\n' "$phase3" | grep -qiE 'Phase 4 step 3|deferred to step 3|only in.*step 3' \
  || fail "Phase 3 must defer filing-effect verification and ticks to step 3"
# A later "correct after filing" clause must not mask an early-tick insertion:
# a Phase 3 line that ticks/marks the filing pair without a deferral qualifier
# on the same line is an unsafe early tick.
early_tick="$(printf '%s\n' "$phase3" | awk '
  tolower($0) ~ /(tick|mark with)/ && tolower($0) ~ /filing (pair|task|criterion)|terminal filing/ \
    && tolower($0) !~ /only|never|not|defer|phase 4|step 3/')"
[ -z "$early_tick" ] \
  || fail "Phase 3 must not tick the filing pair (effects are deferred to step 3)"
grep -qiE 'filing.*never ticked|never ticked.*filing|filing pair.*(not|never) (ticked|tick)' \
  "$CB/02-confirm-execution.md" \
  || fail "02-confirm-execution must audit the filing pair without ever ticking it"

# --- 3e. Gate: final postcheck at the actual current path; PARTIAL names paths -
# Scoped to the tick/marker bullet so the rollback bullet's separate
# "report the actual current path" rule cannot satisfy this check.
tick_marker_lines="$(printf '%s\n' "$step3" | grep -iE 'tick the (terminal )?filing task|apply the completion marker' || true)"
[ -n "$tick_marker_lines" ] \
  || fail "step 3 must tick the filing pair and apply the completion marker"
printf '%s\n' "$tick_marker_lines" | grep -qiE 'actual (current )?(plan )?path' \
  || fail "the filing tick/marker bullet must re-check at the plan's actual current path"

# --- 3e2. Gate: final-marking order — record VERIFIED before tick/marker ------
marking_bullet="$(printf '%s\n' "$step3" | grep -F '**Before final marking:**' || true)"
[ -n "$marking_bullet" ] \
  || fail "step 3 lacks the 'Before final marking' ordering bullet"
printf '%s\n' "$marking_bullet" | grep -qiE 'Before final marking.*--require-tier --state' \
  || fail "the pre-marking check must be the combined --require-tier --state lint"
pre_marking="${marking_bullet%%"**After final marking:**"*}"
printf '%s\n' "$pre_marking" | grep -qiE 'actual (current )?(plan )?path' \
  || fail "the pre-marking lint must run on the plan's actual current path"
printf '%s\n' "$pre_marking" | grep -qi 'still unchecked' \
  || fail "the pre-marking lint must run with the filing pair still unchecked and explained"
printf '%s\n' "$marking_bullet" | grep -qF 'Only after that check passes' \
  || fail "Package filing: VERIFIED may be recorded only after the pre-marking check passes"
printf '%s\n' "$marking_bullet" | grep -qiE 'implementation verification is also VERIFIED' \
  || fail "the completion marker requires implementation verification to be VERIFIED too"
printf '%s\n' "$marking_bullet" | grep -qiE 'After final marking.*re-run the same combined check' \
  || fail "after final marking the same combined check must be re-run"
printf '%s\n' "$marking_bullet" | grep -qiE 'only after this post-edit check passes' \
  || fail "a successful filing report may be published only after the post-edit check passes"
# Negative ordering guard, sentence-scoped: any sentence in the marking bullet
# that prescribes a tick/marker/COMPLETED BEFORE recording
# `Package filing: VERIFIED` is the forbidden status-after-marker order — even
# when a correct ordering sentence exists elsewhere in the same bullet.
bad_order="$(printf '%s\n' "$marking_bullet" | awk '
  {
    n = split($0, s, "[.] ")
    for (i = 1; i <= n; i++) {
      if (s[i] ~ /Package filing: VERIFIED/ && (s[i] ~ /tick/ || s[i] ~ /marker/ || s[i] ~ /COMPLETED/)) {
        r = index(s[i], "record")
        m1 = index(s[i], "tick"); m2 = index(s[i], "marker"); m3 = index(s[i], "COMPLETED")
        mk = 0
        if (m1 > 0 && (mk == 0 || m1 < mk)) mk = m1
        if (m2 > 0 && (mk == 0 || m2 < mk)) mk = m2
        if (m3 > 0 && (mk == 0 || m3 < mk)) mk = m3
        if (r == 0 || (mk > 0 && mk < r)) print s[i]
      }
    }
  }')"
[ -z "$bad_order" ] \
  || fail "Package filing: VERIFIED must be recorded before the pair is ticked and the marker applied (status-after-marker ordering is forbidden)"
printf '%s\n' "$step3" | grep -qiE \
  'PARTIAL.*(named|partial paths|explicit)|(named|explicit).*PARTIAL' \
  || fail "PARTIAL filing must record the named partial paths for resume"

# --- 3f. Gate: final-check failure rolls the marker back safely ---------------
printf '%s\n' "$step3" | grep -qiE '(remove|strip).*(COMPLETED|marker)' \
  || fail "final-check failure must remove the ✅ COMPLETED marker"
printf '%s\n' "$step3" | grep -qiE 'reset.*filing pair|filing pair.*reset' \
  || fail "final-check failure must reset the affected filing pair"
printf '%s\n' "$step3" | grep -qiE 'preserve.*non-filing|non-filing.*preserve' \
  || fail "rollback must preserve every non-filing mark"
printf '%s\n' "$step3" | grep -qi 'no further moves' \
  || fail "rollback must make no further moves this run"

# --- 3g. Gate: already-filed plans revalidate without blind resets ------------
printf '%s\n' "$step3" | grep -qi 'never blindly reset' \
  || fail "revalidation must not blindly reset a verified filing pair or recorded reason"
printf '%s\n' "$step3" | grep -qiE 'already-filed|revalidat' \
  || fail "gate must define already-filed plan revalidation"

# --- 4. Gate: split report statuses -------------------------------------------
grep -qF 'Implementation verification:' "$GATE" \
  || fail "gate report lacks the 'Implementation verification:' field"
grep -qF 'Package filing:' "$GATE" \
  || fail "gate report lacks the 'Package filing:' field"
for token in 'VERIFIED' 'NOT VERIFIED' 'PENDING' 'BLOCKED' 'PARTIAL'; do
  grep -qF "$token" "$GATE" \
    || fail "gate report lacks the '$token' status value"
done
completed_window="$(grep -iE -A2 'COMPLETED' "$GATE" || true)"
printf '%s\n' "$completed_window" | grep -qi 'both' \
  || fail "final COMPLETED status must require both implementation and filing verified"
printf '%s\n' "$completed_window" | grep -qi 'verif' \
  || fail "final COMPLETED status must require verified statuses"

# --- 5. Gate: marker only after verified filing -------------------------------
if grep -qE 'still apply[^.]*completion marker' "$GATE"; then
  fail "unresolved or blocked filing must not still apply the completion marker"
fi
# The real gate words the marker as "`✅ COMPLETED` marker"; match any marker
# line tied to completion, then require the only-after-verified constraint.
marker_lines="$(grep -iE 'marker' "$GATE" | grep -iE 'complet' || true)"
printf '%s\n' "$marker_lines" | grep -qiE \
  'only (in|after|once|when)|only the gate|both .*verif|verif.*both|filing (is )?verif|verified filing' \
  || fail "completion marker may be applied only after filing effects verify"
printf '%s\n' "$step3" | grep -qiE 'only (after|once|when)|verif(y|ied|ication) (before|prior)' \
  || fail "filing boxes may be ticked only after filing effects verify"

# --- 6. Gate: privacy, retained/shared records, idempotent resume -------------
printf '%s\n' "$step3" | grep -qiE 'privacy|sensitive|sanitiz' \
  || fail "filing step must review privacy/sensitive evidence before moving"
printf '%s\n' "$step3" | grep -qiE 'retain|do not move|never move' \
  || fail "filing step must retain canonical/live/shared records with a reason"
printf '%s\n' "$step3" | grep -qiE 'shared|canonical|live' \
  || fail "filing step must name shared/canonical/live records it keeps in place"
printf '%s\n' "$step3" | grep -qi 'resum' \
  || fail "filing must be resumable (idempotent, no lost progress)"
printf '%s\n' "$step3" | grep -qiE 'overwrit' \
  || fail "filing must not overwrite existing destinations"
printf '%s\n' "$step3" | grep -qiE 'duplicat' \
  || fail "filing must not duplicate index rows on resume"

# --- 7. Execution/confirm/wrappers hand off; no competing archive authority ---
for f in "$CB/01-execution.md" "$CB/02-confirm-execution.md"; do
  grep -qiE 'artifact|inventory|lifecycle' "$f" \
    || fail "$(basename "$f") does not hand off the artifact inventory/evidence to the terminal gate"
  grep -q '03-mark-completed' "$f" \
    || fail "$(basename "$f") does not hand off to the terminal gate"
done
grep -qiE 'filing' "$CB/03-execute-and-confirm.md" \
  || fail "03-execute-and-confirm.md does not require the gate's filing result for Full completion"
grep -q '03-mark-completed' "$CB/04-review-finalise-commit-execute.md" \
  || fail "04-review-finalise-commit-execute.md does not route through the terminal gate"
grep -iE 'final' "$CB/04-review-finalise-commit-execute.md" | grep -qiE 'path|location|archiv|filed' \
  || fail "04-review-finalise-commit-execute.md must explain the gate returns the final filed path"
if grep -RInE 'archive[sd]? (the )?(research|review|evidence|inventory)' "$CB"; then
  fail "execution/confirmation must not archive planning artifacts (only the terminal gate files)"
fi

# --- 8. Planning lane seeds/maintains/checks the inventory --------------------
for f in "$PLAN/00-research-and-plan.md" "$PLAN/02-finalise-plan.md"; do
  grep -qiE 'artifact|inventory' "$f" \
    || fail "$(basename "$f") does not seed/maintain the artifact lifecycle inventory"
done
grep -qiE 'artifact|inventory' "$PLAN/01-plan-review.md" \
  || fail "01-plan-review.md does not check artifact coverage"

# --- 9. Filing guides route through the gate ----------------------------------
for f in "$ROOT_DIR/00-project/plans-completed/README.md" \
  "$ROOT_DIR/00-project/docs/agents/changelog-and-troubleshooting.md"; do
  grep -q '03-mark-completed' "$f" \
    || fail "${f#"$ROOT_DIR"/} does not route completion filing through the terminal gate"
done

echo "artifact lifecycle policy checks OK"
