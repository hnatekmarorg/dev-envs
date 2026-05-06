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
# VM Management
# ============================================================================

# VM commands (usage: just vm <create|test|destroy|run|create-custom>)
vm command="":
  #!/usr/bin/env bash
  if [ -z "{{command}}" ]; then
    echo "VM commands:"
    echo "  just vm create              Create VM profile"
    echo "  just vm test                Test VM profile"
    echo "  just vm destroy             Destroy VM profile"
    echo "  just vm run                 Run VM (creates profile + launches as 'debian-dev')"
    echo "  just vm create-custom       Create VM with custom CPU/memory (just vm create-custom <name> <cpu> <memory>)"
    echo ""
    echo "Default VM settings:"
    echo "  Name: debian-dev"
    echo "  CPU: 4"
    echo "  Memory: 8GiB"
    exit 1
  fi
  cd templates/debian && just $(if [ "{{command}}" = "run" ]; then echo "run-vm"; else echo "{{command}}"; fi)

# ============================================================================
# Docker
# ============================================================================

# Docker commands (usage: just docker <build|build-default|run|destroy|clean>)
docker command="":
  #!/usr/bin/env bash
  if [ -z "{{command}}" ]; then
    echo "Docker commands:"
    echo "  just docker build          Build Docker image with current UID/GID"
    echo "  just docker build-default  Build Docker image with default UID/GID (1000)"
    echo "  just docker run            Run Docker container"
    echo "  just docker destroy        Stop and remove Docker container"
    echo "  just docker clean          Remove Docker image"
    exit 1
  fi
  cd templates/debian && just {{command}}


