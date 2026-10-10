# TikTok Shop Go SDK

このディレクトリには、TikTok Shop Partner Center から生成された Go SDK が含まれています。リポジトリ全体の更新手順と公開ルールは、ルートの [README.md](../README.md) を参照してください。

## 前提条件

- Go 1.18 以降
- TikTok Shop のテスト用 Seller アカウント
- TikTok Shop API を呼び出すための App Key、App Secret、Access Token、必要な場合は Shop Cipher

## 利用例

利用側の `go.mod` から、このリポジトリの module を参照します。

```go
require github.com/liftajp/sdk-tts-go/sdk v1.0.0-tts.20261010034538621
```

SDK の API client は次のように初期化できます。

```go
import (
    "context"

    "github.com/liftajp/sdk-tts-go/sdk/apis"
    product_v202502 "github.com/liftajp/sdk-tts-go/sdk/models/product/v202502"
)

configuration := apis.NewConfiguration()
configuration.AddAppInfo(appKey, appSecret)
apiClient := apis.NewAPIClient(configuration)

request := apiClient.ProductV202502API.Product202502ProductsSearchPost(context.Background())
request = request.ContentType("application/json")
request = request.XTtsAccessToken(accessToken)
request = request.ShopCipher(shopCipher)
request = request.Product202502SearchProductsRequestBody(
    product_v202502.Product202502SearchProductsRequestBody{},
)

response, httpResponse, err := request.Execute()
```

認証情報をソースコード、ログ、テスト結果に直接記録しないでください。API の仕様、利用可能な scope、認証方法は TikTok Shop Partner Center の最新ドキュメントを確認してください。

この SDK は自動生成コードです。API や model の実装を手動で変更せず、SDK の更新時はルート README の手順に従ってパッケージ全体を入れ替えてください。
