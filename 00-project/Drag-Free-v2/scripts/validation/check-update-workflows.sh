#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/update-workflows.sh"

temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

repo="$temp_dir/Workflow-Scripts"
mkdir -p "$repo/scripts"
cp "$SCRIPT" "$repo/scripts/update-workflows.sh"
git init -q "$repo"
git -C "$repo" config user.email "test@example.com"
git -C "$repo" config user.name "Test User"
printf 'base\n' > "$repo/README.md"
git -C "$repo" add README.md scripts/update-workflows.sh
git -C "$repo" commit -q -m init

printf 'loose\n' > "$repo/untracked.txt"
set +e
output="$(bash "$repo/scripts/update-workflows.sh" "docs: test" 2>&1)"
exit_code=$?
set -e
if [ "$exit_code" -eq 0 ]; then
  echo "Expected untracked file to fail" >&2
  exit 1
fi
printf '%s\n' "$output" | grep -q 'untracked.txt' || {
  echo "Expected output to name untracked.txt" >&2
  exit 1
}
rm "$repo/untracked.txt"

printf 'dirty\n' >> "$repo/README.md"
set +e
output="$(bash "$repo/scripts/update-workflows.sh" "docs: test" 2>&1)"
exit_code=$?
set -e
if [ "$exit_code" -eq 0 ]; then
  echo "Expected modified tracked file to fail" >&2
  exit 1
fi
printf '%s\n' "$output" | grep -q 'README.md' || {
  echo "Expected output to name README.md" >&2
  exit 1
}
git -C "$repo" checkout -- README.md

printf 'staged\n' >> "$repo/README.md"
git -C "$repo" add README.md

bin_dir="$temp_dir/bin"
mkdir -p "$bin_dir"
cat > "$bin_dir/git" <<'EOF'
#!/usr/bin/env bash
if [ "$1" = "push" ]; then
  echo "mock git push"
  exit 0
fi
exec /usr/bin/git "$@"
EOF
chmod +x "$bin_dir/git"

PATH="$bin_dir:$PATH" bash "$repo/scripts/update-workflows.sh" "docs: staged check" >/tmp/check-update-workflows.out
git -C "$repo" log --oneline -1 | grep -q 'docs: staged check' || {
  echo "Expected staged-only changes to reach commit step" >&2
  exit 1
}
grep -q 'mock git push' /tmp/check-update-workflows.out || {
  echo "Expected staged-only changes to reach mocked push" >&2
  exit 1
}

if grep -q 'git diff --name-only' "$SCRIPT"; then
  echo "scripts/update-workflows.sh must use git status --porcelain, not git diff --name-only" >&2
  exit 1
fi

echo "update-workflows checks OK"
