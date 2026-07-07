#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT_DIR/tools/orchestrator/orchestrator-review.sh"
TEMP_DIR=""

assert_json_field() {
  local file="$1"
  local key="$2"
  local expected="$3"

  # shellcheck disable=SC2016
  node -e '
const fs = require("fs");
const data = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
const actual = String(data[process.argv[2]]);
if (actual !== process.argv[3]) {
  console.error(`${process.argv[2]} expected ${process.argv[3]} but got ${actual}`);
  process.exit(1);
}
' "$file" "$key" "$expected"
}

run_case() {
  local fake_exit="$1"
  local expected_status="$2"
  local temp_dir="$3"
  local bin_dir="$temp_dir/bin-$fake_exit"
  local plan_file="$temp_dir/plan-$fake_exit.md"
  local output_file="$temp_dir/review-$fake_exit.md"
  local status_file="$temp_dir/review-$fake_exit.json"

  mkdir -p "$bin_dir"
  printf '# Test Plan\n\nBody\n' > "$plan_file"

  cat > "$bin_dir/opencode" <<'EOF'
#!/usr/bin/env bash
echo "fake opencode invoked"
exit "${FAKE_OPENCODE_EXIT:-0}"
EOF
  chmod +x "$bin_dir/opencode"

  cat > "$bin_dir/timeout" <<'EOF'
#!/usr/bin/env bash
shift
exec "$@"
EOF
  chmod +x "$bin_dir/timeout"

  set +e
  FAKE_OPENCODE_EXIT="$fake_exit" PATH="$bin_dir:$PATH" bash "$SCRIPT" "$plan_file" --output "$output_file" --timeout 1 >/dev/null 2>&1
  local actual_exit=$?
  set -e

  if [ "$actual_exit" -ne "$fake_exit" ]; then
    echo "Expected exit $fake_exit but got $actual_exit" >&2
    return 1
  fi
  if [ ! -f "$status_file" ]; then
    echo "Expected status file to exist: $status_file" >&2
    return 1
  fi

  assert_json_field "$status_file" "status" "$expected_status"
  assert_json_field "$status_file" "exit_code" "$fake_exit"

  # shellcheck disable=SC2016
  node -e '
const fs = require("fs");
const data = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
if (!data.workflow_file || !fs.existsSync(data.workflow_file)) {
  console.error(`workflow_file does not exist: ${data.workflow_file}`);
  process.exit(1);
}
' "$status_file"
}

run_default_output_case() {
  local temp_dir="$1"
  local bin_dir="$temp_dir/bin-default"
  local plan_dir="$temp_dir/plans"
  local plan_file="$plan_dir/implementation-plan.md"

  mkdir -p "$bin_dir" "$plan_dir"
  printf '# Test Plan\n\nBody\n' > "$plan_file"

  cat > "$bin_dir/opencode" <<'EOF'
#!/usr/bin/env bash
for arg in "$@"; do
  if [ "$arg" = "--prompt" ]; then
    echo "--prompt should not be used" >&2
    exit 64
  fi
done
echo "fake opencode invoked"
exit 0
EOF
  chmod +x "$bin_dir/opencode"

  cat > "$bin_dir/timeout" <<'EOF'
#!/usr/bin/env bash
shift
exec "$@"
EOF
  chmod +x "$bin_dir/timeout"

  PATH="$bin_dir:$PATH" bash "$SCRIPT" "$plan_file" --timeout 1 >/dev/null 2>&1

  if [ ! -d "$plan_dir/implementation-plan.reviews" ]; then
    echo "Expected default output directory beside plan" >&2
    return 1
  fi
  find "$plan_dir/implementation-plan.reviews" -name '*-general-review.md' -type f | grep -q . || {
    echo "Expected default review output file in sibling .reviews directory" >&2
    return 1
  }
}

main() {
  TEMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TEMP_DIR"' EXIT

  run_case 42 failed "$TEMP_DIR"
  run_case 124 timeout "$TEMP_DIR"
  run_default_output_case "$TEMP_DIR"

  echo "Orchestrator review checks OK"
}

main "$@"
