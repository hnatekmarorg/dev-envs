.PHONY: create destroy test-profile help

SHELL := /bin/zsh

IMAGE_NAME := ubuntu-base-$(shell git rev-parse --short HEAD 2>/dev/null || echo "dirty")
IMAGE := images:ubuntu/22.04/cloud

help:
	@echo "Ubuntu Base VM Template"
	@echo ""
	@echo "Usage:"
	@echo "  make create       - Create the Ubuntu base profile"
	@echo "  make destroy      - Destroy the Ubuntu base profile"
	@echo "  make test-profile - Test the profile by creating a test VM"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo "To launch a VM:"
	@echo "  incus launch --vm $(IMAGE) <vm-name> -p default -p $(IMAGE_NAME)"

create:
	@echo "==> Creating Ubuntu base profile: $(IMAGE_NAME)"
	@incus profile create $(IMAGE_NAME) || true
	@incus profile set $(IMAGE_NAME) cloud-init.user-data="$$(cat ./cloud-init.yaml)"
	@echo "==> Profile $(IMAGE_NAME) created"
	@echo "==> Done! Use \'incus launch --vm $(IMAGE) <vm-name> -p default -p $(IMAGE_NAME)\' to create dev envs"

destroy:
	@echo "==> Destroying Ubuntu base profile: $(IMAGE_NAME)"
	@incus profile delete $(IMAGE_NAME) 2>/dev/null || echo "Profile not found"
	@echo "==> Done"

test-profile:
	@echo "==> Testing profile by creating test VM..."
	@incus launch --vm $(IMAGE) test-ubuntu -p default -p $(IMAGE_NAME) || true
	@echo "==> Test VM created. Wait 3-5 minutes for cloud-init to complete."
	@echo "==> Check status with: incus exec test-ubuntu -- hostname"
	@echo "==> Delete test VM with: incus delete test-ubuntu --force"
