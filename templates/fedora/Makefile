# Fedora Base Template Makefile
# Creates a preseeded Fedora base container for development environments

SHELL := /bin/bash
REPO_TAG ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
IMAGE_NAME := fedora-base-$(REPO_TAG)
CONTAINER_NAME := fedora-base-$(REPO_TAG)
FEDORA_CLOUD_IMAGE := images:fedora/42/cloud

.PHONY: create destroy status info clean help

# Create the base Fedora container with provisioning
create:
	@echo "==> Creating Fedora base profile: $(IMAGE_NAME)"
	@if incus profile list | grep -q "$(IMAGE_NAME)"; then \
		echo "==> Profile $(IMAGE_NAME) already exists, skipping creation"; \
		echo "==> Done! Use 'incus launch <image> <instance-name> -p default -p $(IMAGE_NAME)"; \
	else \
		echo "==> Launching temporary container from $(FEDORA_CLOUD_IMAGE)..."; \
		incus profile create $(IMAGE_NAME); \
		incus profile set $(IMAGE_NAME) cloud-init.user-data="$$(cat ./cloud-init.yaml)"; \
	fi
	@echo "==> Done! Use 'incus launch <image> <instance-name> -p default -p $(IMAGE_NAME)' to create dev envs"

# Destroy the base image
destroy:
	@echo "==> Destroying Fedora base image: $(IMAGE_NAME)"
	-incus profile delete $(IMAGE_NAME)
	@echo "==> Done"

# Show container/image status
status:
	@echo "==> Checking Fedora base image: $(IMAGE_NAME)"
	@incus profile list | grep $(IMAGE_NAME) || echo "Image not found"

# Help
help:
	@echo "Fedora Base Template - Development Environment"
	@echo ""
	@echo "Targets:"
	@echo "  create   - Create preseeded Fedora base image ($(IMAGE_NAME))"
	@echo "  destroy  - Delete the base image"
	@echo "  help     - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  REPO_TAG - Repository tag (default: auto-detected)"
	@echo ""
	@echo "After creating, launch dev envs with:"
	@echo "  incus launch $(IMAGE_NAME) <your-env-name>"
