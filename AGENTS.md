# AI Agent Guidelines

This document provides guidelines for AI agents working on this repository.

## Project Overview

This repository provides Debian development environment configurations for Docker containers and Incus VMs.

## Technology Stack

- **Infrastructure**: Incus/LXD for VMs, Docker/Podman for containers
- **Task Runner**: Just (preferred over Makefile)
- **Base Image**: Debian 13 (Trixie)

## Conventions

### Commit Messages
- Use conventional commits (feat, fix, refactor, chore, etc.)
- Include emoji prefixes where appropriate
- Keep subject line under 72 characters

### File Structure
- Templates live in `templates/debian/`
- Each template includes:
  - `README.md` - Usage instructions
  - `Dockerfile` - Container provisioning
  - `cloud-init.yaml` - VM provisioning
  - `justfile` - Build/management commands

### Documentation
- Root-level docs for user-facing information (README.md, AGENTS.md)
- Keep documentation concise and actionable

## Guidelines for AI Agents

### When Modifying Templates
1. Test changes in isolated environment first
2. Document all commands and their purpose
3. Ensure Docker and VM configurations stay in sync

### When Working with Dockerfile
- Use multi-stage builds when appropriate
- Keep images lean by cleaning up apt caches
- Use non-root user for security

### When Working with Cloud-Init
- Use `#cloud-config` header
- Keep packages section organized with comments
- Test runcmd sequences carefully
- Handle failures gracefully with `|| echo "..."` patterns

### When Writing Scripts
- Use bash shebang: `#!/usr/bin/env bash`
- Include error handling where appropriate
- Comment non-obvious logic
- Make scripts idempotent when possible

## Testing

### Docker Template
```bash
cd templates/debian
just build
just run
```

### VM Template
```bash
cd templates/debian
just create
just test-profile
```

## Common Tasks

### Create New Development Environment
```bash
# Docker
docker run -it --rm debian-dev

# VM
incus launch --vm images:debian/13/cloud <vm-name> -p default -p debian-dev
```

**Note**: The Debian Docker image uses an entrypoint script that keeps the container running. When testing commands:

```bash
# Override entrypoint for one-off commands
docker run --rm --entrypoint bash debian-dev -c "your-command-here"

# Or run interactively (container stays running)
docker run -it --rm --entrypoint bash debian-dev
```

### Manage Profiles
```bash
# List all profiles
incus profile list

# Delete old profile
incus profile delete <profile-name>
```

## Troubleshooting

### VM Agent Not Running
- Wait 5-10 minutes after launch
- Check: `incus exec <vm-name> -- cloud-init status`
- Restart: `incus restart <vm-name> --force`

### Package Installation Failures
- Check network connectivity
- Verify package names for Debian
- Use official installation scripts as fallback

### Docker Build Fails on sudo Package
- **Problem**: Installing `sudo` triggers interactive dpkg conffile prompt
- **Cause**: Modifying `/etc/sudoers` before sudo is installed causes dpkg to prompt for conffile conflict resolution
- **Solution**:
  1. Use `DEBIAN_FRONTEND=noninteractive` with apt-get to suppress prompts
  2. Configure sudoers **after** sudo package installation
  3. Use `/etc/sudoers.d/` directory instead of appending to main sudoers file

```dockerfile
# Install packages with noninteractive frontend
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y sudo ...

# Configure sudo AFTER installation
RUN echo 'devuser ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/devuser && \
    chmod 0440 /etc/sudoers.d/devuser && \
    usermod -aG sudo devuser
```

## Security

- Never commit SSH private keys
- Use cloud-init for SSH key configuration
- Run containers as non-root when possible
- Keep base images updated

## Resources

- [Incus Documentation](https://linuxcontainers.org/incus/docs/main/)
- [Cloud-init Documentation](https://cloudinit.readthedocs.io/)
- [Just Command Runner](https://github.com/casey/just)
