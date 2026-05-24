#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA="$ROOT/Formula/agent.rb"
TAP_NAME="${HOMEBREW_TAP_NAME:-calebcauthon/agent}"
FORMULA_REF="$TAP_NAME/agent"
VERBOSE=0

for arg in "$@"; do
  case "$arg" in
    --verbose|-v) VERBOSE=1 ;;
    --help|-h)
      cat <<'USAGE'
Usage: ./scripts/check.sh [--verbose]

Validates the local Homebrew tap with deterministic, AI-readable output.
Set HOMEBREW_TAP_NAME=user/tap to override the default tap name.
USAGE
      exit 0
      ;;
    *)
      echo "status=error step=parse_args message=unknown_argument arg=$arg" >&2
      exit 64
      ;;
  esac
done

log() { printf 'status=%s step=%s message=%q\n' "$1" "$2" "$3"; }
run() {
  local step="$1"; shift
  log running "$step" "$*"
  if (( VERBOSE )); then
    "$@"
  else
    "$@" >/dev/null
  fi
  log ok "$step" "completed"
}

if [[ ! -f "$FORMULA" ]]; then
  echo "status=error step=preflight message=formula_missing path=$FORMULA" >&2
  exit 66
fi

run ruby_syntax ruby -c "$FORMULA"

if command -v brew >/dev/null 2>&1; then
  if brew tap | grep -qx "$TAP_NAME"; then
    run brew_style brew style --formula "$FORMULA_REF"
  else
    log skip brew_style "tap_not_registered: run brew tap $TAP_NAME $ROOT"
  fi
else
  log skip brew_style "brew_not_found"
fi

log ok complete "tap_validation_passed"
