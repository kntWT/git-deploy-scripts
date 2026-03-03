#!/usr/bin/env bash
set -euo pipefail


usage() {
  cat <<EOF
Usage:
  $0 <operation> [args...]

Options:
  -h, --help    Show this help message

Arguments:
  operation     必須引数 (pull, push, clone のいずれか)
  args...       任意引数 (gitコマンドにそのまま渡されます)
EOF
}

# --- option parsing ---
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

# --- 引数チェック ---
if [[ $# -lt 1 ]]; then
  echo "Error: required_arg is missing." >&2
  usage
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GET_REMOTE_SCRIPT="${SCRIPT_DIR}/get_remote.sh"

# required argument
operation="${1}"

remote="$($GET_REMOTE_SCRIPT)"

case "${operation}" in
  "pull")
    git pull "$remote" "${@:2}"
    ;;
  "push")
    git push "$remote" "${@:2}"
    ;;
  "clone")
    git clone "$remote" "${@:2}"
    ;;
  *)
    echo "Invalid operation: $operation"
    exit 1
    ;;
esac
