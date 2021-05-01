SIDERO_IMAGE ?= ghcr.io/talos-systems/metal-controller-manager:v0.2.0

REGISTRY ?= ghcr.io
USERNAME ?= timjones
NAME ?= metal-controller-manager
SHA ?= $(shell git describe --match=none --always --abbrev=8 --dirty)
TAG ?= $(shell git describe --tag --always --dirty)
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

REGISTRY_AND_USERNAME := $(REGISTRY)/$(USERNAME)
IMAGE := $(REGISTRY_AND_USERNAME)/$(NAME)

.PHONY: help
help: ## Display this help message.
	@grep -E '^[a-zA-Z0-9%_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: image
image: ## Build customised Sidero
ifeq ($(SIDERO_IP),)
	$(error You must define SIDERO_IP to build the image (i.e. run make image SIDERO_IP=192.168.1.30))
else
	@docker build \
		--tag $(IMAGE):$(TAG) \
		--build-arg SIDERO_IMAGE=$(SIDERO_IMAGE) \
		--build-arg SIDERO_IP=$(SIDERO_IP) \
		.
endif

.PHONY: push
push: ## Push image to registry
	@docker push $(IMAGE):$(TAG)

.PHONY: patch
patch: ## Patch the Sidero metal-controller-manager Deployment running in Kubernetes
	@kubectl patch deploy -n sidero-system sidero-controller-manager --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/1/image", "value": "$(IMAGE):$(TAG)"}]'
