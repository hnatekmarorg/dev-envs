# Dev Environments

Debian development environment configurations for rapid provisioning of isolated Docker containers and Incus VMs.

## Overview

This repository provides pre-configured templates for setting up comprehensive Debian development environments in two modalities:

- **Docker Container** - Lightweight, portable container environment
- **Incus VM** - Full virtualized environment with cloud-init provisioning

## Templates

### Debian Template (`templates/debian/`)

Supports both Docker and Incus VM deployment.

**Best for:**
- Full development environment with all tools pre-installed
- Kernel-level testing (VM mode)
- Complete system isolation
- Consistent development environments across teams

**Quick Start:**

```bash
# Docker Container
just docker-build
just docker-run

# Incus VM
just debian-create
incus launch --vm images:debian/13/cloud my-dev-environment -p default -p debian-dev
```

See [templates/debian/README.md](templates/debian/README.md) for full documentation.

## Requirements

### For Docker
- Docker or Podman installed
- At least 2GB RAM and 10GB disk space

### For Incus VM
- [Incus/LXD](https://linuxcontainers.org/incus/) installed and configured
- KVM support for VMs
- At least 4GB RAM and 20GB disk space per VM

## Common Tasks

### Using Just (Recommended)

Install [just](https://github.com/casey/just):
```bash
# Ubuntu/Debian
sudo apt install just

# macOS
brew install just

# Arch
sudo pacman -S just
```

Available commands:
```bash
just --list
```

## Project Structure

```
.
├── README.md              # This file
├── AGENTS.md              # AI agent guidelines
├── Justfile               # Task runner recipes
├── .gitignore             # Git ignore patterns
├── .github/
│   └── ISSUE_TEMPLATE/    # Issue templates
└── templates/
    └── debian/            # Debian template (Docker + Incus VM)
        ├── README.md      # Template documentation
        ├── Dockerfile     # Docker image definition
        ├── entrypoint.sh  # Container entrypoint script
        ├── cloud-init.yaml # VM provisioning configuration
        └── justfile       # Template-local commands
```

## Contributing

See [AGENTS.md](AGENTS.md) for guidelines on working with this repository.

## License

This repository is provided as-is for development purposes.
