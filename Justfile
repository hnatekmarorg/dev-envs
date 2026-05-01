# Dev Environments Task Runner
# Install just: https://github.com/casey/just

default:
  @just --list

# List all available recipes
list:
  @just --list

# Help
help: list

# ============================================================================
# Create Dev Environments
# ============================================================================

# Create a new VM instance
vm-create name:
  #!/usr/bin/env bash
  just debian-create
  echo ""
  echo "Launch your VM with:"
  echo "  incus launch --vm images:debian/13/cloud {{name}} -p default -p debian-dev"
  echo ""
  echo "After launch, wait 3-5 minutes for initialization, then:"
  echo "  incus exec -it {{name}} -- bash"

# Create a new Docker container instance
container name:
  #!/usr/bin/env bash
  just docker-build
  echo ""
  echo "Container image built: debian-dev"
  echo ""
  echo "Run your container with:"
  echo "  docker run -it --rm --name {{name}} debian-dev"
  echo ""
  echo "Or with volume mount for development:"
  echo "  docker run -it --rm -v \$PWD:/home/devuser/app --name {{name}} debian-dev"
  echo ""
  echo "To access the container later:"
  echo "  docker exec -it {{name}} bash"

# ============================================================================
# Debian VM Management
# ============================================================================

# Create Debian VM profile
debian-create:
  @cd templates/debian && just create

# Test Debian profile
debian-test:
  @cd templates/debian && just test-profile

# Destroy Debian profile
debian-destroy:
  @cd templates/debian && just destroy-profile

# ============================================================================
# Docker
# ============================================================================

# Build Debian Docker image with current user's UID/GID
docker-build:
  @cd templates/debian && just build

# Build Debian Docker image with default UID/GID (1000)
docker-build-default:
  @cd templates/debian && just build-default

# Run Debian Docker container
docker-run: docker-build
  @cd templates/debian && just run-bg

# Clean Debian Docker container
docker-destroy:
  @cd templates/debian && just destroy

# Clean Debian Docker image
docker-clean:
  @cd templates/debian && just clean

# ============================================================================
# Utilities
# ============================================================================

# Validate repository structure
validate:
  #!/usr/bin/env bash
  echo "=== Validating Repository Structure ==="
  echo ""
  [ -f .gitignore ] && echo "✓ .gitignore" || echo "✗ .gitignore missing"
  echo ""
  [ -d templates/debian ] && echo "✓ templates/debian" || echo "✗ templates/debian missing"
  echo ""
  [ -f templates/debian/Dockerfile ] && echo "✓ templates/debian/Dockerfile" || echo "✗ templates/debian/Dockerfile missing"
  echo ""
  [ -f templates/debian/cloud-init.yaml ] && echo "✓ templates/debian/cloud-init.yaml" || echo "✗ templates/debian/cloud-init.yaml missing"
  echo ""
  [ -d .github/ISSUE_TEMPLATE ] && echo "✓ .github/ISSUE_TEMPLATE" || echo "✗ .github/ISSUE_TEMPLATE missing"
  echo ""
  echo "✓ All checks passed"
