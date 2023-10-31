mkPath := $(abspath $(lastword $(MAKEFILE_LIST)))
mkDir := $(dir $(mkPath))

OS := linux
ARCH := amd64

gitCommit := $(shell git rev-parse HEAD)
gitCommitShort := $(shell git rev-parse --short HEAD)
gitBranch := $(shell git rev-parse --abbrev-ref HEAD)
date := $(shell date "+%Y%m%dT%H%M%S")

ROOT_PACKAGE=git.csautodriver.com/ibms/spp

.DEFAULT_GOAL := all

include script/make-rules/common.mk
include script/make-rules/golang.mk

.PHONY: all
all: replace fmt
#all: tidy fmt

.PHONY: env
env:
	@$(GO) install mvdan.cc/sh/v3/cmd/shfmt@latest
	@GOPROXY=https://goproxy.cn,direct GO111MODULE=on $(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.43.0

.PHONY: tidy
tidy:
	@$(GO) mod tidy

.PHONY: run
run:
#	todo

.PHONY: build
build:
	@echo "go build starting... $(date)"
	@CGO_ENABLED=0 GOOS=$(OS) GOARCH=$(ARCH) $(GO) build -o build/bin/$(service) -ldflags "-s -w -X main.BuildDate=$(d)" service/$(service)server/cmd/*.go
	@echo "go build success, build/bin/$(service)"
	@echo "docker build starting..."
	@echo "registry.cn-shenzhen.aliyuncs.com/spps/$(service):${gitBranch}-${gitCommitShort}-${date}"
	@docker build -t registry.cn-shenzhen.aliyuncs.com/spps/$(service):${gitBranch}-${gitCommitShort}-${date} -f service/$(service)server/Dockerfile .
	@docker push registry.cn-shenzhen.aliyuncs.com/spps/$(service):${gitBranch}-${gitCommitShort}-${date}

.PHONY: fmt
fmt:
	@$(GO) fmt ./...
	@shfmt -l -w ./script/*.sh

.PHONY: replace
replace:
	#todo

.PHONY: noreplace
noreplace:
	#todo

