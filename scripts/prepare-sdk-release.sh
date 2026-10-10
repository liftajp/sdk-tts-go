#!/usr/bin/env bash

set -euo pipefail

sdk_dir="${1:-sdk}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "$sdk_dir" ]]; then
  echo "SDK ディレクトリが見つかりません: $sdk_dir" >&2
  exit 1
fi

# main には Partner Center から取得した SDK をそのまま保存し、公開物を作る段階でだけ
# このリポジトリから参照できる module path と内部 import に統一します。
"$script_dir/normalize-sdk.sh" "$sdk_dir"

# Partner Center の生成パッケージから、公開物に不要な開発用ファイルだけを削除します。
# API、model、schema、changelog、README は残します。
rm -rf \
  "$sdk_dir/example_test.go" \
  "$sdk_dir/test" \
  "$sdk_dir/.openapi-generator" \
  "$sdk_dir/.openapi-generator-ignore" \
  "$sdk_dir/.travis.yml" \
  "$sdk_dir/git_push.sh"

find "$sdk_dir" -name '.DS_Store' -delete
