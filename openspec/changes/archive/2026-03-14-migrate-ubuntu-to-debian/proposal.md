## Why

The organization needs a Debian-based VM template to align with infrastructure standards and provide developers with a Debian development environment. Currently only Ubuntu templates exist. Creating a Debian equivalent will provide choice and consistency across the infrastructure stack.

## What Changes

- Create new `templates/debian/` directory with Debian-specific cloud-init configuration
- Mirror the Ubuntu template's toolchain and development environment
- Adapt package names and installation methods for Debian
- Add Debian template to the template catalog

## Capabilities

### New Capabilities

- `debian-vm-template`: Debian-based VM template providing equivalent development environment to Ubuntu template, including cloud-init provisioning, development toolchain, and AI assistant integration

### Modified Capabilities

- (None - this introduces a new parallel template, not a modification)

## Impact

- **New Template**: `templates/debian/` directory with cloud-init.yaml, Makefile, README.md
- **Package Changes**: Debian package names may differ from Ubuntu equivalents
- **Shell Configuration**: Adjust paths for Debian filesystem layout
- **Documentation**: README updates to document Debian template usage
- **No Downtime**: New template created alongside existing Ubuntu template
