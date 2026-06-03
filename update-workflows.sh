#!/usr/bin/env bash
# Wrapper — see scripts.update-workflows.sh
set -euo pipefail
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/update-workflows.sh" "$@"