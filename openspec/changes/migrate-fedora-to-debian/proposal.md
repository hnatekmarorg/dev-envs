## Why

Fedora template is no longer needed as the primary development environment - consolidating to Debian ensures consistency across all development VMs and reduces maintenance overhead from supporting multiple base images.

## What Changes

- Replace Fedora cloud-init.yaml with Debian-equivalent provisioning
- Update Makefile to use Debian base image and simplified workflow
- Remove Fedora-specific package names and installation methods
- Migrate development tools to Debian (kubectl, k9s, ytt - excluding Docker/k3d for LXC compatibility)
- **BREAKING**: Fedora template files will be removed after migration
- **Note**: Docker and k3d excluded due to LXC container limitations

## Capabilities

### New Capabilities

### Modified Capabilities

## Impact

- `templates/fedora/` directory will be deprecated/removed
- `templates/debian/` will receive all Fedora provisioning features
- Makefile commands remain compatible with existing workflows
- No impact on running Fedora VMs - only new creations affected
