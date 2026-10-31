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