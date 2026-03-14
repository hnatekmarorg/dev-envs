# Fedora Template - DEPRECATED

This template has been migrated to Debian. Please use the Debian template instead.

## Migration

The Debian template (`../debian/`) now includes all features from this Fedora template:
- K3D Kubernetes clusters
- k9s terminal UI
- Carvel ytt YAML templating
- Full k8s-ops helper script
- All development tools (Docker, kubectl, Bun, NVM, UV, etc.)

## Usage

```bash
cd ../debian
make create
incus launch --vm images:debian/13/cloud <vm-name> -p default -p debian-base-<tag>
```

## Existing Fedora VMs

Running Fedora VMs will continue to work. This deprecation only affects new VM creations.

## Files

Original files archived at: `../archive/fedora/`
