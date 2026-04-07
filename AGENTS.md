# AI Agent Guidelines

This document provides guidelines for AI agents working on this repository.

## Project Overview

This repository manages distribution-specific development environment configurations using the openspec workflow. It contains templates for:

- **Debian** - Docker-based development environment
- **Ubuntu** - Incus/LXD VM-based development environment

## Technology Stack

- **Package Manager**: Bun (not npm/yarn)
- **Workflow**: OpenSpec for change management
- **Infrastructure**: Incus/LXD for VMs, Docker for containers
- **Task Runner**: Just (preferred over Makefile)

## Conventions

### Commit Messages
- Use conventional commits (feat, fix, refactor, chore, etc.)
- Include emoji prefixes where appropriate (see existing commits)
- Keep subject line under 72 characters

### File Structure
- Templates live in `templates/<distro>/`
- Each template should have:
  - `README.md` - Usage instructions
  - `cloud-init.yaml` or `Dockerfile` - Provisioning configuration
  - `Makefile` or `Justfile` - Build/management commands
- OpenSpec changes in `openspec/changes/<change-name>/`

### Documentation
- Root-level docs for user-facing information (README.md, AGENTS.md)
- Technical docs in `docs/` directory
- Keep documentation concise and actionable

## OpenSpec Workflow

1. **Propose**: Create change proposal with design and tasks
2. **Apply**: Implement changes following the design
3. **Archive**: Mark change as complete when done

### Creating a New Change
```bash
just new <change-name>
```

### Checking Change Status
```bash
just status <change-name>
```

### Listing All Changes
```bash
just list
```

## Guidelines for AI Agents

### When Adding New Distro Templates
1. Study existing templates (debian/, ubuntu/) for patterns
2. Create change proposal first (design.md, tasks.md)
3. Test provisioning on actual VM/container
4. Document all commands and their purpose
5. Update root README with new template info

### When Modifying Existing Templates
1. Understand the impact on existing VMs/containers
2. Use openspec workflow for tracking changes
3. Test changes in isolated environment first
4. Document migration path if breaking changes exist

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

### VM Templates
```bash
cd templates/<distro>
make test-profile
```

### Docker Templates
```bash
cd templates/<distro>
make build && make run
```

## Common Tasks

### Create New Development Environment
```bash
# For VMs
incus launch --vm images:<distro>/<version> <vm-name> -p default -p <profile-name>

# For Docker
docker run -it --rm <image-name>
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
- Verify package names for specific distro
- Use official installation scripts as fallback

## Security

- Never commit SSH private keys
- Use cloud-init for SSH key configuration
- Run containers as non-root when possible
- Keep base images updated

## Resources

- [Incus Documentation](https://linuxcontainers.org/incus/docs/main/)
- [Cloud-init Documentation](https://cloudinit.readthedocs.io/)
- [OpenSpec Schema](https://github.com/fission-ai/openspec)
- [Just Command Runner](https://github.com/casey/just)
