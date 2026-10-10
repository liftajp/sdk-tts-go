# TikTok Shop Go SDK

This repository contains the generated Go SDK downloaded from TikTok Shop
Partner Center. Application repositories consume a tagged version of this
module instead of copying the SDK into their own `third_party` directory.

## Source and update policy

- Source package: TikTok Shop Partner Center Go SDK
- Go module: `github.com/liftajp/sdk-tts-go`
- Generated API schema: [`api/openapi.yaml`](api/openapi.yaml)
- Upstream changelog: [`changelog.txt`](changelog.txt)
- Generated code lives under `apis/`, `models/`, and `utils/`.

The generated source is kept as a standalone Go module. The service's TikTok
adapter owns the token request transport because the downloaded
`apis/access_token.go` helper does not expose request context, an injectable
HTTP client, or the complete refresh response. The SDK source itself should
not be hand-edited.

## Updating the generated SDK

When TikTok publishes a new SDK:

1. Download and extract the complete package from Partner Center.
2. Replace the generated `api/`, `apis/`, `models/`, and `utils/` directories
   and `changelog.txt`.
3. Keep the module path as `github.com/liftajp/sdk-tts-go` and update generated
   imports if the package still uses `tiktokshop/open/sdk_golang`.
4. Update `SDK_VERSION` with the immutable tag to publish, for example:
   `v1.0.0-tts.20261010034538621`.
5. Run `go test ./...` and commit the complete SDK replacement to `main`.

The GitHub Actions release workflow then creates `release/<SDK_VERSION>` from
that commit and adds the same version as an annotated Git tag. A tag points to
the commit; it is not nested inside a branch. The workflow rejects an existing
version or release branch so a published SDK cannot be overwritten.

Generated examples and network tests are not part of the consumable module.
Keep them outside the module if they are needed for upstream reference, and do
not commit credentials from generated examples.
