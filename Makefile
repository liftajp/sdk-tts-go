SHELL := /usr/bin/env bash

SDK_DIR ?= sdk
SDK_VERSION_FILE ?= SDK_VERSION
TRIVY_SEVERITY ?= HIGH,CRITICAL

.DEFAULT_GOAL := help

.PHONY: help check-sdk validate-version security-scan check ci prepare-release

help: ## 利用可能なコマンドを表示します
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ {printf "%-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-sdk: ## SDK の Go パッケージをコンパイル確認します
	./scripts/check-sdk.sh "$(SDK_DIR)"

validate-version: ## SDK_VERSION の形式と前回からの変更を確認します
	./scripts/check-version.sh "$(SDK_VERSION_FILE)"

security-scan: ## Trivy で秘密情報と設定をスキャンします
	@command -v trivy >/dev/null 2>&1 || { echo "trivy が必要です: https://trivy.dev/" >&2; exit 1; }
	trivy fs --scanners secret,misconfig --severity "$(TRIVY_SEVERITY)" --exit-code 1 .

check: check-sdk validate-version ## SDK とバージョンを確認します

ci: check security-scan ## CI と同じローカル検証を実行します

prepare-release: ## リリース用に SDK の不要ファイルを整理します
	./scripts/prepare-sdk-release.sh "$(SDK_DIR)"
