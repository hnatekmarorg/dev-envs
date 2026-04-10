.PHONY: create destroy test-profile help docker-build docker-clean

SHELL := /bin/zsh

IMAGE_NAME := debian-base-$(shell git rev-parse --short HEAD 2>/dev/null || echo "dirty")
IMAGE := images:debian/13/cloud

# Docker build commands
docker-build:
	@echo "==> Building Docker image with your UID/GID..."
	@docker build -t debian-dev --build-arg USER_UID=$(shell id -u) --build-arg USER_GID=$(shell id -g) .

docker-build-default:
	@echo "==> Building Docker image with default UID/GID (1000)..."
	@docker build -t debian-dev .

docker-clean:
	@echo "==> Removing Docker image..."
	@docker rmi debian-dev 2>/dev/null || echo "Image not found"

help:
	@echo "Debian Development Environment"
	@echo ""
	@echo "VM Commands:"
	@echo "  make create         - Create the Debian base profile"
	@echo "  make destroy        - Destroy the Debian base profile"
	@echo "  make test-profile   - Test the profile by creating a test VM"
	@echo ""
	@echo "Docker Commands:"
	@echo "  make docker-build   - Build Docker image with your UID/GID"
	@echo "  make docker-build-default - Build with default UID/GID (1000)"
	@echo "  make docker-clean   - Remove Docker image"
	@echo ""
	@echo "To launch a VM:"
	@echo "  incus launch --vm $(IMAGE) <vm-name> -p default -p $(IMAGE_NAME)"
	@echo ""
	@echo "To run Docker container:"
	@echo "  docker run -it --rm -v $PWD:/home/devuser/app debian-dev"
create:
	@echo "==> Creating Debian base profile: $(IMAGE_NAME)"
	@incus profile create $(IMAGE_NAME) || true
	@incus profile set $(IMAGE_NAME) cloud-init.user-data="$$(cat ./cloud-init.yaml)"
	@echo "==> Profile $(IMAGE_NAME) created"
	@echo "==> Done! Use \'incus launch --vm $(IMAGE) <vm-name> -p default -p $(IMAGE_NAME)\' to create dev envs"

destroy:
	@echo "==> Destroying Debian base profile: $(IMAGE_NAME)"
	@incus profile delete $(IMAGE_NAME) 2>/dev/null || echo "Profile not found"
	@echo "==> Done"

test-profile:
	@echo "==> Testing profile by creating test VM..."
	@incus launch --vm $(IMAGE) test-debian -p default -p $(IMAGE_NAME) || true
	@echo "==> Test VM created. Wait 3-5 minutes for cloud-init to complete."
	@echo "==> Check status with: incus exec test-debian -- hostname"
	@echo "==> Delete test VM with: incus delete test-debian --force"
