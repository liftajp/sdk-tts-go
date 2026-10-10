#!/usr/bin/env bash

set -euo pipefail

sdk_dir="${1:-sdk}"

if [[ ! -d "$sdk_dir" ]]; then
  echo "SDK ディレクトリが見つかりません: $sdk_dir" >&2
  exit 1
fi

cd "$sdk_dir"
packages=()
while IFS= read -r package; do
  [[ -n "$package" ]] && packages+=("$package")
done < <(go list ./... | grep -v '/test$')

if [[ "${#packages[@]}" -eq 0 ]]; then
  echo "検証対象の Go パッケージがありません" >&2
  exit 1
fi

# 生成された example_test.go は実際の TikTok API を呼び出すため、ここでは実行せずにコンパイルだけ確認します。
go test -run '^$' "${packages[@]}"
