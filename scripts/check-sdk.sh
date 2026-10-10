#!/usr/bin/env bash

set -euo pipefail

sdk_dir="${1:-sdk}"

if [[ ! -d "$sdk_dir" ]]; then
  echo "SDK ディレクトリが見つかりません: $sdk_dir" >&2
  exit 1
fi

expected_module="github.com/liftajp/sdk-tts-go/sdk"
actual_module="$(awk '$1 == "module" {print $2; exit}' "$sdk_dir/go.mod")"
if [[ "$actual_module" != "$expected_module" ]]; then
  echo "SDK module path が不正です: $actual_module (期待値: $expected_module)" >&2
  echo "ダウンロード後に make normalize-sdk を実行してください" >&2
  exit 1
fi

if rg -n --glob '*.go' --glob 'go.mod' 'tiktokshop/open/sdk_golang' "$sdk_dir" >/dev/null; then
  echo "SDK 内に旧 module path が残っています。make normalize-sdk を実行してください" >&2
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
