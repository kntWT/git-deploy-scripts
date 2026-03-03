#!/usr/bin/env bash
set -euo pipefail

# 第1引数が指定されていない場合のチェック
if [ -z "${1:-}" ]; then
  echo "Usage: $0 <command_name> [bin_dir]"
  exit 1
fi

# 現在のディレクトリの絶対パスを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_SCRIPT="${SCRIPT_DIR}/git_operation.sh"

# コマンド名
COMMAND_NAME="$1"

# シンボリックリンクを作成する先（第2引数で指定可能、デフォルトは /usr/local/bin）
BIN_DIR="${2:-/usr/local/bin}"

echo "Setting up $COMMAND_NAME command in $BIN_DIR..."

# BIN_DIR が存在しない場合は作成を試みる
if [ ! -d "$BIN_DIR" ]; then
  if mkdir -p "$BIN_DIR" 2>/dev/null; then
    echo "Created directory $BIN_DIR"
  else
    echo "Requires sudo privileges to create $BIN_DIR."
    sudo mkdir -p "$BIN_DIR"
  fi
fi

# BIN_DIR への書き込み権限があるか確認して、必要なら sudo をつける
if [ -w "$BIN_DIR" ]; then
  ln -sf "$TARGET_SCRIPT" "${BIN_DIR}/${COMMAND_NAME}"
else
  echo "$BIN_DIR requires sudo privileges."
  sudo ln -sf "$TARGET_SCRIPT" "${BIN_DIR}/${COMMAND_NAME}"
fi

echo "✅ Installed successfully!"

if [[ "$COMMAND_NAME" == git-* ]]; then
  SUBCOMMAND="${COMMAND_NAME#git-}"
  echo "You can now use '${COMMAND_NAME}' (or 'git ${SUBCOMMAND}') from anywhere."
else
  echo "You can now use '${COMMAND_NAME}' from anywhere."
fi
