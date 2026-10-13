#!/usr/bin/env bash
# Canary check: do a repo's agent rules load in a session started below the root?
#
# Checks that the repo's CLAUDE.md is a symlink to AGENTS.md, then builds a
# throwaway copy of that layout (AGENTS.md with a canary line, CLAUDE.md linked
# to it, and a sub/deep folder). A headless Claude Code session started in
# sub/deep/ must list the canary. The real repo files are never modified.
#
# Costs one small headless model call. Needs the claude CLI and a login.
#
# Usage:
#   check-agent-rules-load.sh [REPO_ROOT]   # REPO_ROOT defaults to this repo
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REPO="${1:-$ROOT_DIR}"
errors=0
fail() { errors=$((errors + 1)); echo "check-agent-rules-load: $*" >&2; }

if [ -L "$REPO/CLAUDE.md" ] && [ "$(readlink "$REPO/CLAUDE.md")" = AGENTS.md ]; then
  echo "✓ CLAUDE.md is a symlink to AGENTS.md"
else
  fail "$REPO/CLAUDE.md must be a symlink to AGENTS.md (ln -sf AGENTS.md CLAUDE.md)"
fi

[ -f "$REPO/AGENTS.md" ] || { fail "$REPO/AGENTS.md is missing"; exit 1; }
command -v claude >/dev/null 2>&1 || { fail "claude CLI not found; the canary test cannot run"; exit 1; }

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
canary="CANARY-$$-$(date +%s)"
cp "$REPO/AGENTS.md" "$scratch/AGENTS.md"
printf '\nThe canary for this check is %s.\n' "$canary" >> "$scratch/AGENTS.md"
# cp -P keeps a symlink as a symlink and copies an @ import as text, so the test
# uses the repo's real CLAUDE.md layout, not one built here.
if [ -e "$REPO/CLAUDE.md" ] || [ -L "$REPO/CLAUDE.md" ]; then
  cp -P "$REPO/CLAUDE.md" "$scratch/CLAUDE.md"
fi
mkdir -p "$scratch/sub/deep"

# ANTHROPIC_API_KEY is unset for this command only: a key with no credit blocks headless runs.
set +e
out="$(cd "$scratch/sub/deep" && env -u ANTHROPIC_API_KEY claude -p "Do not use any tools. List every token of the form CANARY-<something> that appears anywhere in your loaded instructions or context. Output only the tokens, one per line, or NONE." --model haiku --output-format text </dev/null 2>&1)"
code=$?
set -e

if [ "$code" -ne 0 ]; then
  fail "headless claude exited $code: $out"
elif printf '%s\n' "$out" | grep -qF "$canary"; then
  echo "✓ rules load from a session started in a subfolder"
else
  fail "canary not seen from a subfolder session; the rules did not load (output: $out)"
fi

if [ "$errors" -gt 0 ]; then echo "check-agent-rules-load: $errors problem(s)" >&2; exit 1; fi
echo "check-agent-rules-load: OK"
