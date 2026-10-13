#!/usr/bin/env bash
# Structural check for an agent learnings log (scheme: 00-project-setup/11-agent-learnings.md).
#
# Checks: README.md and index.md exist; the index has one header row; rows are
# newest first; each row's category is valid and matches its folder; each row's
# file exists; each entry has exactly one row and matching Status and Category
# fields; required sections exist; file names follow the pattern; ACTIVE rows
# carry rule text; each entry names a Source (developer message, command, file,
# or unverified); each ACTIVE entry has a verified Source and an Approved date.
#
# Usage:
#   check-learnings.sh [DIR]     # DIR defaults to 00-project/learnings
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIR="${1:-$ROOT_DIR/00-project/learnings}"
CATEGORIES='workflow code tooling facts communication'
SOURCE_RE='^(developer message|command|file|unverified)([: ]|$)'
APPROVED_RE='^\*\*Approved:\*\* [0-9]{4}-[0-9]{2}-[0-9]{2}'

errors=0
fail() { errors=$((errors + 1)); echo "check-learnings: $DIR: $*" >&2; }
trim() { local s="$*"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }

[ -f "$DIR/README.md" ] || fail "README.md missing"
if [ ! -f "$DIR/index.md" ]; then fail "index.md missing"; exit 1; fi
for c in $CATEGORIES; do [ -d "$DIR/$c" ] || fail "category folder $c/ missing"; done

header_rows=$(grep -c -E '^\| Date +\| Category +\| Title +\| File +\| Status +\|$' "$DIR/index.md" || true)
[ "$header_rows" -eq 1 ] || fail "index.md has $header_rows header rows (expected 1)"

rows_file=$(mktemp)
trap 'rm -f "$rows_file"' EXIT
grep '^| 20' "$DIR/index.md" > "$rows_file" || true
prev=""; n=0
while IFS='|' read -r _ date cat title file status _; do
  n=$((n + 1))
  date=$(trim "$date"); cat=$(trim "$cat"); file=$(trim "$file"); status=$(trim "$status")
  [[ "$date" =~ ^20[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]] || fail "row $n: bad date '$date'"
  if [ -n "$prev" ] && [[ "$date" > "$prev" ]]; then
    fail "row $n: $date is newer than the row above ($prev); newest must be first"
  fi
  prev="$date"
  case " $CATEGORIES " in *" $cat "*) ;; *) fail "row $n: category '$cat' is not one of: $CATEGORIES" ;; esac
  if [ ! -f "$DIR/$file" ]; then fail "row $n: file '$file' does not exist"; continue; fi
  [ "${file%%/*}" = "$cat" ] || fail "row $n: category '$cat' but file is in '${file%%/*}/'"
  st=$(trim "${status%%;*}")
  case "$st" in
    ACTIVE|NOTED|PROMOTED|SUPERSEDED) ;;
    *) fail "row $n: status '$st' is not ACTIVE, NOTED, PROMOTED, or SUPERSEDED" ;;
  esac
  if [ "$st" = ACTIVE ] && [ -z "$(trim "${status#*;}")" ]; then
    fail "row $n: ACTIVE row has no rule text after 'ACTIVE;'"
  fi
  entry_status=$(sed -n 's/^\*\*Status:\*\* //p' "$DIR/$file" | head -1)
  [ "$entry_status" = "$st" ] || fail "$file: index says '$st', entry says '$entry_status'"
  entry_cat=$(sed -n 's/^\*\*Category:\*\* //p' "$DIR/$file" | head -1)
  [ "$entry_cat" = "$cat" ] || fail "$file: index says '$cat', entry says '$entry_cat'"
  entry_source=$(sed -n 's/^\*\*Source:\*\* //p' "$DIR/$file" | head -1)
  [[ "$entry_source" =~ $SOURCE_RE ]] \
    || fail "$file: Source must start with developer message, command, file, or unverified"
  if [ "$st" = ACTIVE ]; then
    [[ "$entry_source" == unverified* ]] && fail "$file: ACTIVE needs a verified Source, not unverified"
    grep -qE "$APPROVED_RE" "$DIR/$file" || fail "$file: ACTIVE needs an **Approved:** <yyyy-mm-dd> line"
  fi
  for h in Situation "Pattern to avoid" "Better approach" Verification Notes; do
    grep -q "^## $h\$" "$DIR/$file" || fail "$file: missing section '## $h'"
  done
  base=$(basename "$file")
  [[ "$base" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}-$cat-[a-z0-9-]+\.md$ ]] \
    || fail "$base: name must be <yyyy-mm-dd>-$cat-<short-title>.md"
done < "$rows_file"

entries=0
for f in "$DIR"/*/*.md; do
  [ -e "$f" ] || continue
  entries=$((entries + 1)); rel=${f#"$DIR"/}
  grep -qF "| $rel |" "$DIR/index.md" || fail "orphan entry: $rel has no index row"
done
[ "$n" -eq "$entries" ] || fail "index has $n rows but $entries entries exist"

if [ "$errors" -gt 0 ]; then echo "check-learnings: $errors problem(s)" >&2; exit 1; fi
echo "check-learnings: OK ($n rows, $entries entries)"
