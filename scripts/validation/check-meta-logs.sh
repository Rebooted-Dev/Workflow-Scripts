#!/usr/bin/env bash
# Meta-log validator: Workflow-Scripts changes must be logged in 00-project/.
#
# Rules, applied per change set (the staged tree, or each non-merge commit):
#   1. A change to any path outside 00-project/ must add or update a
#      00-project/changelog/<type>/*.md entry. An added entry must also
#      update 00-project/changelog/index.md.
#   2. Every added 00-project/changelog/fixed/*.md entry needs an added
#      00-project/troubleshooting/<category>/*.md entry in the same change
#      set, unless the fixed entry carries the waiver line
#      "**Troubleshooting:** not needed".
#   3. Every added troubleshooting entry must update
#      00-project/troubleshooting/index.md.
#
# Usage:
#   check-meta-logs.sh --staged          # pre-commit (scripts/hooks/pre-commit)
#   check-meta-logs.sh --range A..B      # CI or manual audit of new commits
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
META="00-project"
CL_TYPES='added|changed|fixed|improved|docs|refactor|config'
WAIVER='**Troubleshooting:** not needed'

errors=0
err() { echo "check-meta-logs: $*" >&2; errors=$((errors + 1)); }

# check_set <label> <content-ref-prefix> ; reads "STATUS<TAB>PATH" lines on stdin.
# <content-ref-prefix> is ":" for the index or "<sha>:" for a commit.
check_set() {
  local label="$1" ref="$2"
  local status path
  local outside=0 cl_touched=0 cl_added=0 cl_index=0 ts_added=0 ts_index=0
  local fixed_added=()

  while IFS=$'\t' read -r status path; do
    [ -n "$path" ] || continue
    case "$path" in
      "$META"/*) ;;
      .DS_Store|*/.DS_Store) continue ;;
      *) outside=1 ;;
    esac
    if [[ "$path" =~ ^$META/changelog/($CL_TYPES)/[^/]+\.md$ ]]; then
      cl_touched=1
      if [ "${status:0:1}" = "A" ]; then
        cl_added=1
        [[ "$path" == "$META"/changelog/fixed/* ]] && fixed_added+=("$path")
      fi
    fi
    [ "$path" = "$META/changelog/index.md" ] && cl_index=1
    if [[ "$path" =~ ^$META/troubleshooting/[^/]+/[^/]+\.md$ ]] && [ "${status:0:1}" = "A" ]; then
      ts_added=1
    fi
    [ "$path" = "$META/troubleshooting/index.md" ] && ts_index=1
  done

  if [ "$outside" -eq 1 ] && [ "$cl_touched" -eq 0 ]; then
    err "$label: changes outside $META/ but no $META/changelog/<type>/ entry was added or updated"
  fi
  if [ "$cl_added" -eq 1 ] && [ "$cl_index" -eq 0 ]; then
    err "$label: changelog entry added but $META/changelog/index.md not updated"
  fi
  local f
  for f in ${fixed_added[@]+"${fixed_added[@]}"}; do
    if [ "$ts_added" -eq 0 ] && ! git -C "$ROOT_DIR" show "$ref$f" 2>/dev/null | grep -qF "$WAIVER"; then
      err "$label: $f has no troubleshooting entry; add one under $META/troubleshooting/<category>/ or record '$WAIVER — <reason>' in the entry"
    fi
  done
  if [ "$ts_added" -eq 1 ] && [ "$ts_index" -eq 0 ]; then
    err "$label: troubleshooting entry added but $META/troubleshooting/index.md not updated"
  fi
}

case "${1:-}" in
  --staged)
    # A conflicted merge commit carries other commits' logs; skip it.
    if git -C "$ROOT_DIR" rev-parse -q --verify MERGE_HEAD >/dev/null; then exit 0; fi
    # Process substitution, not a pipe: check_set must run in this shell so
    # its error count survives.
    check_set "staged changes" ":" < <(git -C "$ROOT_DIR" diff --cached --name-status --no-renames)
    ;;
  --range)
    range="${2:?--range needs A..B}"
    while read -r sha; do
      [ -n "$sha" ] || continue
      check_set "commit ${sha:0:7}" "$sha:" \
        < <(git -C "$ROOT_DIR" diff-tree --no-commit-id --name-status -r --no-renames "$sha")
    done < <(git -C "$ROOT_DIR" rev-list --no-merges --reverse "$range")
    ;;
  *)
    echo "usage: $0 --staged | --range A..B" >&2
    exit 2
    ;;
esac

if [ "$errors" -gt 0 ]; then
  echo "check-meta-logs: $errors problem(s). Rules: AGENTS.md and $META/docs/agents/changelog-and-troubleshooting.md" >&2
  exit 1
fi
echo "meta log checks OK"
