# TikTok Shop Go SDK

This repository contains the generated Go SDK downloaded from TikTok Shop
Partner Center. Application repositories consume a tagged version of this
module instead of copying the SDK into their own `third_party` directory.

## Source and update policy

- Source package: TikTok Shop Partner Center Go SDK
- Go module: `github.com/liftajp/third-party-tts-go`
- Generated API schema: [`api/openapi.yaml`](api/openapi.yaml)
- Upstream changelog: [`changelog.txt`](changelog.txt)
- Generated code lives under `apis/`, `models/`, and `utils/`.

The generated source is kept as a standalone Go module. The service's TikTok
adapter owns the token request transport because the downloaded
`apis/access_token.go` helper does not expose request context, an injectable
HTTP client, or the complete refresh response. The SDK source itself should
not be hand-edited.

When TikTok publishes a new SDK, replace the generated directories and module
metadata as a single reviewable change, keep this module path unchanged, update
this file with the download date/version, run the repository test suite, and
review the generated diff. The downloaded example and test files are
intentionally excluded because they contain live-looking credentials and
network-oriented examples.
