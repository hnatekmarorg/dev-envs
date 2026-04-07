# Dev Environments

Distribution-specific development environment configurations for rapid provisioning of isolated development VMs and containers.

## Overview

This repository provides pre-configured templates for setting up comprehensive development environments using Incus/LXD VMs with cloud-init provisioning.
## Templates

### Debian VM Template (`templates/debian/`)

Incus/LXD VM-based development environment with cloud-init provisioning.

**Best for:**
- Full virtualized environments
- Kernel-level testing
- Complete system isolation

**Quick Start:**
```bash
cd templates/debian
make create
incus launch --vm images:debian/13/cloud my-dev-environment -p default -p debian-base-<hash>
```

See [templates/debian/README.md](templates/debian/README.md) for full documentation.

## Requirements

### For VM Templates
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


## Project Structure

```
.
├── AGENTS.md              # AI agent guidelines
├── README.md              # This file
├── Justfile               # Task runner recipes
├── templates/             # Environment templates
│   └── debian/            # Incus/LXD VM template
└── .github/
    └── ISSUE_TEMPLATE/    # Issue templates
```

## Contributing

See [AGENTS.md](AGENTS.md) for guidelines on working with this repository.

## License

This repository is provided as-is for development purposes.
