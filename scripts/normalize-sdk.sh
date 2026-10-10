#!/usr/bin/env bash

set -euo pipefail

sdk_dir="${1:-sdk}"
old_module="tiktokshop/open/sdk_golang"
new_module="github.com/liftajp/sdk-tts-go/sdk"

if [[ ! -d "$sdk_dir" ]]; then
  echo "SDK ディレクトリが見つかりません: $sdk_dir" >&2
  exit 1
fi

python3 - "$sdk_dir" "$old_module" "$new_module" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
old = sys.argv[2]
new = sys.argv[3]
allowed = {".go", ".md"}
changed = 0

for path in root.rglob("*"):
    if not path.is_file() or (path.suffix not in allowed and path.name != "go.mod"):
        continue
    text = path.read_text()
    updated = text.replace(old, new)
    if updated != text:
        path.write_text(updated)
        changed += 1

print(f"SDK module path normalized in {changed} file(s)")
PY
