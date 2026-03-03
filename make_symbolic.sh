#!/usr/bin/env bash
set -euo pipefail

# 現在のディレクトリの絶対パスを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_SCRIPT="${SCRIPT_DIR}/git_operation.sh"

# コマンド名
COMMAND_NAME="$1"

# シンボリックリンクを作成する先（一般的にPATHが通っている場所）
BIN_DIR="/usr/local/bin"

echo "Setting up $COMMAND_NAME command..."

# /usr/local/bin への書き込みには管理者権限が必要なため sudo をつける
sudo ln -sf "$TARGET_SCRIPT" "${BIN_DIR}/${COMMAND_NAME}"

echo "✅ Installed successfully!"
echo "You can now use '${COMMAND_NAME}' (or 'git app') from anywhere."
