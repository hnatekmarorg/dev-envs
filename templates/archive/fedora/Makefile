# Fedora Base Template Makefile
# Creates a preseeded Fedora base VM for development environments

SHELL := /bin/zsh
REPO_TAG ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
IMAGE_NAME := fedora-base-$(REPO_TAG)
VM_NAME := fedora-base-$(REPO_TAG)
FEDORA_CLOUD_IMAGE := images:fedora/42/cloud

.PHONY: create destroy status info clean help test-profile

# Create the base Fedora container with provisioning
create:
	@echo "==> Creating Fedora base profile: $(IMAGE_NAME)"
	@if incus profile list | grep -q "$(IMAGE_NAME)"; then \
		echo "==> Profile $(IMAGE_NAME) already exists, skipping creation"; \
		echo "==> Done! Use \'incus launch --vm <image> <instance-name> -p default -p $(IMAGE_NAME)"; \
	else \
		echo "==> Creating VM profile from $(FEDORA_CLOUD_IMAGE)..."; \
		incus profile create $(IMAGE_NAME); \
		incus profile set $(IMAGE_NAME) cloud-init.user-data="$$(cat ./cloud-init.yaml)"; \
		incus profile set $(IMAGE_NAME) security.nesting=true; \
		incus profile set $(IMAGE_NAME) security.privileged=true; \
	fi
	@echo "==> Done! Use \'incus launch --vm $(FEDORA_CLOUD_IMAGE) <instance-name> -p default -p $(IMAGE_NAME)\' to create dev envs"

# Destroy the base image
destroy:
	@echo "==> Destroying Fedora base image: $(IMAGE_NAME)"
	-incus profile delete $(IMAGE_NAME)
	@echo "==> Done"

# Show container/image status
status:
	@echo "==> Checking Fedora base image: $(IMAGE_NAME)"
	@incus profile list | grep $(IMAGE_NAME) || echo "Image not found"

# Test the profile by creating and verifying a test VM
test-profile:
	@echo "==> Testing Fedora profile: $(IMAGE_NAME)"
	@if ! incus profile list | grep -q "$(IMAGE_NAME)"; then \
		\techo "==> Error: Profile $(IMAGE_NAME) not found. Run \'make create\' first"; \
		\texit 1; \
	fi
	@echo "==> Launching test VM test-$(IMAGE_NAME)..."
	@incus launch --vm images:fedora/42/cloud test-$(IMAGE_NAME) -p default -p $(IMAGE_NAME) || \
		(incus delete test-$(IMAGE_NAME) --force; exit 1)
	@echo "==> Waiting for cloud-init to complete (this may take 2-3 minutes for VMs)..."
	@incus exec test-$(IMAGE_NAME) -- cloud-init status --wait || \
		(incus delete test-$(IMAGE_NAME) --force; exit 1)
	@echo "==> Verifying tools installation..."
	@echo "==> Checking Docker..." && \
		incus exec test-$(IMAGE_NAME) -- docker --version && \
		incus exec test-$(IMAGE_NAME) -- systemctl is-active docker
	@echo "==> Checking kubectl..." && \
		incus exec test-$(IMAGE_NAME) -- kubectl version --client
	@echo "==> Checking K3D installation..." && \
		incus exec test-$(IMAGE_NAME) -- k3d version
	@echo "==> Checking k9s..." && \
		incus exec test-$(IMAGE_NAME) -- k9s version
	@echo "==> Checking ytt..." && \
		incus exec test-$(IMAGE_NAME) -- ytt version
	@echo "==> Checking k8s-ops helper..." && \
		incus exec test-$(IMAGE_NAME) -- k8s-ops help > /dev/null && \
		echo "==> k8s-ops helper available"
	@echo ""
	@echo "==> All tools verified!"
	@echo "==> To use Kubernetes cluster, run: incus exec <vm> -- k8s-ops start"
	@echo "==> Cleaning up test VM..."
	@incus delete test-$(IMAGE_NAME) --force
	@echo "==> Test VM cleaned up successfully"

# Help
help:
	@echo "Fedora Base Template - Development Environment"
	@echo ""
	@echo "Targets:"
	@echo "  create       - Create preseeded Fedora base VM image ($(IMAGE_NAME))"
	@echo "  destroy      - Delete the base image"
	@echo "  status       - Show image status"
	@echo "  test-profile - Test the profile by creating and verifying a test VM"
	@echo "  help         - Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  REPO_TAG - Repository tag (default: auto-detected)"
	@echo ""
	@echo "After creating, launch dev envs with:"
	@echo "  incus launch --vm $(IMAGE_NAME) <your-env-name>"
