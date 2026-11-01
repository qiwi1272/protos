.PHONY: examples diff_iterator nats_asset_server nats_asset_client asset_compare protoc-nats pb buf all version check-version tag release

# Releases are manual: `make release NEW_VERSION=0.2.0` (or the Release workflow).
# The module path has no /vN suffix, so only v0/v1 versions are valid.
LATEST_TAG := $(shell git describe --tags --abbrev=0 --match 'v[01].*' 2>/dev/null || echo none)
RELEASE := $(patsubst v%,%,$(NEW_VERSION))

examples: diff_iterator nats_asset_server nats_asset_client asset_compare

asset_compare:
	go build -o bin/asset_compare examples/asset_compare/main.go

diff_iterator:
	go build -o bin/diff_iterator examples/diff_iterator/main.go

nats_asset_server:
	go build -o bin/nats_asset_server examples/nats_asset_server/main.go

nats_asset_client:
	go build -o bin/nats_asset_client examples/nats_asset_client/main.go


buf:
	buf dep update
	buf lint
	buf build

generate:
	buf generate

pb:
	go mod tidy
	go fmt ./...
	go vet ./...
	go test ./...
	go build ./...

protoc-nats:
#	latest version build command, but chucked streaming is currently unused and breaks imports on generation. 
# 	cd protoc-nats/extensions/proto && \ 
# 	buf generate --template buf.gen.yaml --path natsmicro/options.proto
	cd protoc-nats/ && \
	buf generate --template buf.gen.yaml --path extensions/proto/natsmicro/options.proto
	cp protoc-nats/gen/nats/micro/options.pb.go protoc-nats/tools/protoc-gen-nats-micro/nats/micro/options.pb.go
	cd protoc-nats && \
	go build -o tools/protoc-gen-nats-micro/protoc-gen-nats-micro ./tools/protoc-gen-nats-micro/

all: buf protoc-nats generate pb examples

push: buf
	buf push

version:
	@echo "Latest v0/v1 tag: $(LATEST_TAG)"

check-version:
	@echo "$(RELEASE)" | grep -Eq '^[01]\.[0-9]+\.[0-9]+$$' || \
		{ echo "NEW_VERSION must be 0.x.y or 1.x.y, e.g. make release NEW_VERSION=0.2.0"; exit 1; }
	@! git rev-parse -q --verify "refs/tags/v$(RELEASE)" >/dev/null || \
		{ echo "tag v$(RELEASE) already exists"; exit 1; }

tag:
	git tag -a v$(RELEASE) -m "Release v$(RELEASE)"
	git push origin v$(RELEASE)

release: check-version tag
	gh release create v$(RELEASE) \
		--latest \
		--title "v$(RELEASE)" \
		--notes "Release v$(RELEASE)"