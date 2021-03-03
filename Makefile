GOFILES := $(shell find . -name "*.go" -type f -not -path "./vendor/*")
PACKAGES ?= $(shell go list ./... | grep -v /vendor/)


.PHONY: lint vet fmt deps run test

vet: ## run go vet.
	go vet $(PACKAGES)

lint: ## run golangci-lint.
	@hash golangci-lint > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		echo 'Please install "golangci-lint" tool: https://github.com/golangci/golangci-lint'; \
		exit 1; \
	fi
	golangci-lint run -v

fmt: ## format .go files.
	gofmt -l -s -w $(GOFILES)

deps: ## sync dependencies.
	go mod tidy

run: # run app locally.
	go run .

test: # run all unit tests.
	go test -race -v ./...