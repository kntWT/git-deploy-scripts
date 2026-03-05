#!/usr/bin/env bash
set -euo pipefail


usage() {
  cat <<EOF
Usage:
  $0 [--github-app-name=<name>] [--project-name=<name>] <operation> [args...]

Options:
  -h, --help    Show this help message
  --github-app-name=<name>   GitHub App関連の設定ファイル群を読む際のプレフィックスを指定します（ex: writable_app_id.txt）
  --project-name=<name>      プロジェクト関連の設定ファイル群を読む際のプレフィックスを指定します（ex: myapp_org.txt）

Arguments:
  operation     必須引数 (pull, push, clone のいずれか)
  args...       任意引数 (gitコマンドにそのまま渡されます)
EOF
}

# --- option parsing ---
GITHUB_APP_NAME=""
PROJECT_NAME=""
GIT_ARGS=()
OPERATION=""

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      usage
      exit 0
      ;;
    -g=*|--github-app-name=*)
      GITHUB_APP_NAME="${arg#*=}"
      ;;
    -p=*|--project-name=*)
      PROJECT_NAME="${arg#*=}"
      ;;
    *)
      if [[ -z "$OPERATION" ]]; then
        OPERATION="$arg"
      else
        GIT_ARGS+=("$arg")
      fi
      ;;
  esac
done

export GITHUB_APP_NAME
export PROJECT_NAME

# --- 引数チェック ---
if [[ -z "$OPERATION" ]]; then
  echo "Error: required_arg operation is missing." >&2
  usage
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
GET_REMOTE_SCRIPT="${SCRIPT_DIR}/get_remote.sh"

remote="$($GET_REMOTE_SCRIPT)"

case "${OPERATION}" in
  "pull")
    git pull "$remote" ${GIT_ARGS[@]+"${GIT_ARGS[@]}"}
    ;;
  "push")
    git push "$remote" ${GIT_ARGS[@]+"${GIT_ARGS[@]}"}
    ;;
  "clone")
    git clone "$remote" ${GIT_ARGS[@]+"${GIT_ARGS[@]}"}
    ;;
  *)
    echo "Invalid operation: $OPERATION"
    exit 1
    ;;
esac
