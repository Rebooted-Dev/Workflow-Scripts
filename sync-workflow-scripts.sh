#!/usr/bin/env bash
# Wrapper — see scripts.sync-workflow-scripts.sh
set -euo pipefail
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/sync-workflow-scripts.sh" "$@"