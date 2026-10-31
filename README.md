# Protobuf implementations for DEXs

[![Go Reference](https://pkg.go.dev/badge/github.com/qiwi1272/protos.svg)](https://pkg.go.dev/github.com/qiwi1272/protos)

## Getting started

- Requires Go 1.25+.
- Install from GitHub: `go get github.com/qiwi1272/protos`

## Example Usage

```
package main

import (
	"fmt"

	pb "github.com/qiwi1272/protos/gen/dex/base/v1"
)

func main() {
	diff := pb.NewBookDiff()
	diff.Bids = append(diff.Bids, pb.NewBookLevel("102", "2"))
	diff.Bids = append(diff.Bids, pb.NewBookLevel("101", "3"))

	for p, s := range diff.BidLevels() {
		fmt.Printf("BID | Price: %s Size: %s\n", p, s)
	}
}
```

For more complete usage examples see the [examples/](./examples/) folder in this repository.

## CI/CD

This repo is set up for Buff Schema Registry:

- `Buf CI` action validates and registers proto changes on pull requests and pushes.


`.proto` consumers can depend directly on the [Buf-generated modues](https://buf.build/round-internet-money/dex/sdks/main:protobuf)

Contributing
-------------
Contributions are welcome! Please open issues or pull requests as needed.
## Releasing

Releases are manual. Pushing or merging to `main` does not publish anything.

1. Go to **Actions → Release → Run workflow**.
2. Enter the version (for example `0.2.0`) and run it.

The workflow tags `v<version>` and publishes the GitHub release marked as **Latest**. Locally, `make release NEW_VERSION=0.2.0` does the same. Only `0.x.y` / `1.x.y` versions that aren't already tagged are accepted: Go ignores non-semver tags such as `v0.1.2.1`, and the module path has no `/vN` suffix.
