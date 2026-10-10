# TikTok Shop Go SDK

このリポジトリは、TikTok Shop Partner Center からダウンロードした Go SDK を保存し、確認済みのリリースを管理します。`sdk/` の中身は Partner Center の生成パッケージをそのまま保存します。生成コードや生成パッケージの module、import、README は手動で変更しません。

## 構成

```text
sdk-tts-go/
├── .github/workflows/
│   ├── check-sdk.yml       # main push 時の自動チェック
│   └── release-sdk.yml     # 手動実行するリリース処理
├── scripts/
│   ├── check-sdk.sh        # SDK のコンパイル確認
│   └── prepare-sdk-release.sh # release ブランチ用の整理
├── SDK_VERSION             # Partner Center の版と Build ID を記録
├── README.md               # リポジトリの運用手順
└── sdk/                    # Partner Center から取得した SDK 本体
    ├── api/
    ├── apis/
    ├── models/
    ├── utils/
    └── go.mod
```

SDK の module 宣言は、ダウンロード元の値 `tiktokshop/open/sdk_golang` を維持します。これは生成パッケージをそのまま保つためです。利用側のプロジェクトで参照方法を決める場合も、SDK 本体の module 宣言を書き換えません。

## SDK の更新

1. Partner Center から完全な Go SDK をダウンロードして展開します。
2. リポジトリの `sdk/` だけを入れ替えます。ルートの `.github/`、`scripts/`、`SDK_VERSION`、`README.md` は削除しません。
3. SDK 本体のファイルは編集せず、Partner Center に表示された version と Build ID をルートの `SDK_VERSION` に記録します。例:

   ```text
   v1.0.0-tts.20261010034538621
   ```

4. ローカルで確認します。

   ```bash
   ./scripts/check-sdk.sh sdk
   ```

5. `sdk/` と `SDK_VERSION` を `main` に commit、push します。

   ```bash
   git add sdk SDK_VERSION
   git commit -m "chore: update TikTok Shop Go SDK"
   git push origin main
   ```

`sdk/` の入れ替えでは、古い API を使っていなくても削除しません。SDK の完全な生成パッケージを保存し、必要な API の選択は利用側のサービスで行います。

## main push 後の自動チェック

`main` への push で `SDK チェック` workflow が起動します。次の確認を自動で行います。

- SDK の生成パッケージと model がコンパイルできること
- `SDK_VERSION` が有効な形式であること
- 前回の commit と version が同じかどうか

version が変わっていない場合も workflow は失敗させず、GitHub Actions に warning を表示します。SDK の確認とリリース作業は分離しています。main push だけでは release ブランチや tag は作成しません。

## 手動リリース

自動チェックが成功した後、GitHub Actions の `SDK リリース` workflow で **Run workflow** を押します。通常は入力欄を空にして `SDK_VERSION` を使用します。

リリース workflow は次の順序で処理します。

1. `release/<SDK_VERSION>` ブランチを `main` から作成します。
2. release ブランチ上で `scripts/prepare-sdk-release.sh` を実行します。
3. 公開物に不要な生成用ファイル、ネットワーク接続のサンプルテスト、`test/` ディレクトリだけを削除します。API、model、schema、changelog、README は残します。
4. 整理後の SDK を再度コンパイル確認します。
5. 整理内容を release ブランチに commit、push します。
6. 同じ commit に `sdk/<SDK_VERSION>` の annotated tag を作成して push します。

例:

```text
SDK_VERSION: v1.0.0-tts.20261010034538621
ブランチ:    release/v1.0.0-tts.20261010034538621
タグ:        sdk/v1.0.0-tts.20261010034538621
```

同じ version の release ブランチや tag が既に存在する場合、上書きせずに workflow を停止します。認証情報や実際の API response を SDK リポジトリに保存しないでください。
