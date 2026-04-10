# Dev Environments Task Runner
# Install just: https://github.com/casey/just

# List all available recipes
list:
	@echo "Dev Environments Task Runner"
	@echo ""
	@echo "Create Dev Environments:"
	@echo '  just vm-create <name>  - Create a new Debian VM'
	@echo "  just container <name> - Create a new Docker container"
	@echo ""
	@echo "Debian VM Management:"
	@echo "  just debian-create    - Create Debian VM profile"
	@echo "  just debian-test      - Test Debian profile"
	@echo "  just debian-destroy   - Destroy Debian profile"
	@echo ""
	@echo "Docker:"
	@echo "  just docker-build        - Build Debian Docker image with your UID/GID"
	@echo "  just docker-build-default - Build with default UID/GID (1000)"
	@echo "  just docker-run          - Run Debian Docker container"
	@echo "  just docker-clean        - Clean Debian Docker image"
	@echo "Utilities:"
	@echo "  just help             - Show this help message"
	@echo "  just validate         - Validate repository structure"

# Create a new VM instance
vm-create name:
	@just debian-create
	@echo ""
	@echo "Launch your VM with:"
	@echo "  incus launch --vm images:debian/13/cloud {{name}} -p default -p debian-base-$$(git rev-parse --short HEAD 2>/dev/null || echo 'dirty')"
	@echo ""
	@echo "After launch, wait 3-5 minutes for initialization, then:"
	@echo "  incus exec -it {{name}} -- bash"

# Create a new Docker container instance
container name:
	@just docker-build
	@echo ""
	@echo "Container image built: debian-dev"
	@echo ""
	@echo "Run your container with:"
	@echo "  docker run -it --rm --name {{name}} debian-dev"
	@echo ""
	@echo "Or with volume mount for development:"
	@echo "  docker run -it --rm -v \$PWD:/home/devuser/app --name {{name}} debian-dev"
	@echo ""
	@echo "To access the container later:"
	@echo "  docker exec -it {{name}} bash"
	@echo ""
	@echo ""
	@echo ""
	@echo "# Create Debian VM profile"
debian-create:
	@cd templates/debian && make create


# Test Debian profile
debian-test:
	@cd templates/debian && make test-profile


# Destroy Debian profile
docker-destroy:
  docker rm -f debian-dev

# Build Debian Docker image with current user's UID/GID
docker-build:
	@cd templates/debian && make docker-build

# Build Debian Docker image with default UID/GID (1000)
docker-build-default:
	@cd templates/debian && make docker-build-default

# Run Debian Docker container
docker-run: docker-build
  @just docker-destroy
  @cd templates/debian && docker run -v /data/documents/:/data/documents --name debian-dev -d debian-dev

# Clean Debian Docker image
docker-clean:
	@cd templates/debian && docker rmi debian-dev || true

# Validate repository structure
validate:
	@echo "=== Validating Repository Structure ==="
	@echo ""
	@test -f openspec/config.yaml && echo "✓ openspec/config.yaml" || echo "✗ openspec/config.yaml missing"
	@test -f .gitignore && echo "✓ .gitignore" || echo "✗ .gitignore missing"
	@echo ""
	@test -d templates/debian && echo "✓ templates/debian" || echo "✗ templates/debian missing"
	@echo ""
	@test -d .github/ISSUE_TEMPLATE && echo "✓ .github/ISSUE_TEMPLATE" || echo "✗ .github/ISSUE_TEMPLATE missing"
	@echo ""
	@echo "✓ All checks passed"

# Show help
help: list
