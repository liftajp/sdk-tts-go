#!/usr/bin/env bash

set -euo pipefail

version_file="${1:-SDK_VERSION}"

error_message() {
  if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
    echo "::error::$1"
  else
    echo "$1" >&2
  fi
}

if [[ ! -f "$version_file" ]]; then
  error_message "バージョンファイルが見つかりません: $version_file"
  exit 1
fi

current="$(tr -d '[:space:]' < "$version_file")"
if [[ ! "$current" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
  error_message "SDK_VERSION が不正です: $current"
  exit 1
fi

previous=""
if git rev-parse --verify HEAD^ >/dev/null 2>&1; then
  previous="$(git show "HEAD^:$version_file" 2>/dev/null | tr -d '[:space:]' || true)"
fi

if [[ -z "$previous" ]]; then
  echo "SDK_VERSION=$current (initial version)"
elif [[ "$current" == "$previous" ]]; then
  if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
    echo "::warning::SDK_VERSION did not change ($current). The SDK check passed, but a release will not be created until the version is updated."
  else
    echo "WARNING: SDK_VERSION did not change ($current)."
  fi
else
  echo "SDK_VERSION changed: $previous -> $current"
fi
