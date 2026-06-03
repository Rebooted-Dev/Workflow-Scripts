#!/usr/bin/env bash
# Wrapper — see scripts/pull-workflows.sh
set -euo pipefail
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/pull-workflows.sh" "$@"