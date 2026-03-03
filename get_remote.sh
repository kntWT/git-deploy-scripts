#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG="$(cat "${SCRIPT_DIR}/org.txt")"
REPO="$(cat "${SCRIPT_DIR}/repo.txt")"
TOKEN_SCRIPT="${SCRIPT_DIR}/get_installation_token.sh"

get_remote() {
  TOKEN="$($TOKEN_SCRIPT)"
  echo "https://x-access-token:$TOKEN@github.com/$ORG/$REPO.git"
}

get_remote