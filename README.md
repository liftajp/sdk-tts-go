# TikTok Shop Go SDK

このリポジトリは、TikTok Shop Partner Center から取得した公式 Go SDK の保存と公開を管理します。リポジトリ固有の管理ファイルはルートに置き、生成された SDK 本体は `sdk/` に分離します。SDK を更新するときは `sdk/` だけを入れ替えます。

## ディレクトリ構成

```text
sdk-tts-go/
├── .github/workflows/       # CI: テスト、release ブランチ、タグの作成
├── SDK_VERSION              # 公開対象の SDK バージョン
├── README.md                # このリポジトリの運用手順
└── sdk/                  # Partner Center から取得して整えた Go SDK
    ├── api/
    ├── apis/
    ├── models/
    ├── utils/
    └── go.mod
```

Go module のパスは次のとおりです。

```text
github.com/liftajp/sdk-tts-go/sdk
```

利用側のコードでは、SDK の `sdk/apis`、`sdk/models`、`sdk/utils` をこの module から import します。ルートには Go module を置かないため、SDK を入れ替えるときに workflow、バージョンファイル、運用ドキュメントを誤って削除しません。

## SDK の更新手順

1. TikTok Shop Partner Center から完全な Go SDK をダウンロードし、展開します。
2. リポジトリ内の `sdk/` だけを削除し、展開した SDK のディレクトリを `sdk/` に変更して配置します。ルートの `.github/`、`SDK_VERSION`、`README.md` は削除しません。
3. `sdk/go.mod` の module を次の値に変更します。

   ```text
   module github.com/liftajp/sdk-tts-go/sdk
   ```

4. 生成コード内に `tiktokshop/open/sdk_golang` が残っている場合は、`github.com/liftajp/sdk-tts-go/sdk` に置き換えます。
5. Partner Center に表示される SDK バージョンと Build ID を `SDK_VERSION` に記録します。例:

   ```text
   v1.0.0-tts.20261010034538621
   ```

6. ルートディレクトリでテストを実行し、変更を `main` に push します。

   ```bash
   (cd sdk && go test ./...)
   git add sdk SDK_VERSION
   git commit -m "chore: update TikTok Shop Go SDK"
   git push origin main
   ```

ダウンロードした SDK に含まれる `.DS_Store`、`.travis.yml`、`git_push.sh` はリポジトリ管理用のファイルではありません。ネットワークへ接続する生成サンプルテストも CI の対象外として削除します。認証情報をソースコードやテスト結果にコミットしないでください。

## CI による公開ルール

`main` に SDK 本体を push すると GitHub Actions がテストを実行します。`SDK_VERSION` が前回のコミットから変更された場合、またはそのバージョンがまだ公開されていない場合だけ、次の公開処理を行います。

1. `sdk/go.mod` から Go のバージョンを設定します。
2. `(cd sdk && go test ./...)` を実行します。
3. `release/<SDK_VERSION>` ブランチを作成します。
4. 同じコミットに `sdk/<SDK_VERSION>` の annotated tag を作成します。

例:

```text
SDK_VERSION: v1.0.0-tts.20261010034538621
ブランチ:    release/v1.0.0-tts.20261010034538621
タグ:        sdk/v1.0.0-tts.20261010034538621
```

Go module が `sdk/` のサブディレクトリにあるため、Go の module version として認識させるタグには `sdk/` プレフィックスを付けます。公開済みのバージョンや release ブランチは再利用しません。
