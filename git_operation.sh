#!/usr/bin/env bash
set -euo pipefail


usage() {
  cat <<EOF
Usage:
  $0 <operation> [branch or tag]

Options:
  -h, --help    Show this help message

Arguments:
  operation     必須引数
  branch or tag     任意引数（省略可）
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
# optional argument
branch="${2:-}"

remote="$($GET_REMOTE_SCRIPT)"
echo $remote

case "${operation}" in
  "pull")
    git pull $remote $branch
    ;;
  "push")
    git push $remote $branch
    ;;
  "clone")
    git clone $remote $branch
    ;;
  *)  
    echo "Invalid operation: $operation"
    exit 1
    ;;
esac
