## Context

The Fedora template (`templates/fedora/`) currently provides a preseeded development VM with cloud-init provisioning. The Debian template (`templates/debian/`) exists but lacks some of Fedora's features. This design consolidates to Debian as the single base image.

**Important**: Docker and k3d do not work reliably in LXC containers without privileged/nested settings. Since we're targeting LXC-compatible deployments, we'll exclude Docker/k3d and focus on kubectl-based Kubernetes management.

Current state:
- Fedora: Full development environment with Docker, K3D, kubectl, k9s, ytt, Bun, NVM, UV, OpenSpec, LazyVim, Oh My Zsh
- Debian: Basic provisioning with some tools, but missing k9s, ytt

## Goals / Non-Goals

**Goals:**
- Migrate Fedora provisioning features to Debian cloud-init.yaml (excluding Docker/k3d)
- Update Debian Makefile to match Fedora's workflow
- Ensure feature parity for LXC-compatible tools (kubectl, k9s, ytt)
- Remove Fedora template files after migration

**Non-Goals:**
- Migration of existing running Fedora VMs (they continue to work)
- Changes to Incus/Proxmox infrastructure
- Docker/k3d support in LXC containers (not reliable)
- Modifying the k8s-ops helper script logic (only removing K3D commands)

## Decisions

1. **Debian 13 (bookworm) as base image**
   - Why: Already configured in `templates/debian/Makefile`, stable LTS release
   - Alternative: Ubuntu (already exists as separate template, would create redundancy)

2. **Exclude Docker and k3d**
   - Why: Don't work reliably in LXC containers without privileged/nested settings
   - Alternative: Use security.nesting=true and security.privileged=true (adds security risk)
   - Decision: Focus on kubectl-based Kubernetes management instead

3. **Package manager differences**
   - Fedora uses `dnf`, Debian uses `apt`
   - Most packages have equivalents: `kubectl` available in both
   - Some packages need name changes: `openssh-server` (same), `build-essential` (Debian-specific)

4. **Shell configuration approach**
   - Keep Oh My Zsh + custom plugins (already working in Debian)
   - Preserve existing Debian .zshrc structure with Fedora additions integrated

5. **User accounts**
   - Debian already has `root` + `dev` user setup
   - Keep this dual-user approach (Fedora only had root)

## Risks / Trade-offs

- **Package availability**: Some Fedora packages may not exist in Debian repos
  → Mitigation: Use official installation scripts (k3d, k9s, Bun, NVM) as fallback
  
- **Service names**: systemd service names may differ (sshd vs sshd.service)
  → Mitigation: Test `systemctl enable/start` commands on Debian 13

- **Breaking change for new VM creators**: Anyone referencing Fedora template docs
  → Mitigation: Clear deprecation notice, update all documentation

## Migration Plan

1. **Phase 1**: Enhance Debian cloud-init.yaml with missing Fedora features
   - Add k9s installation
   - Add ytt installation
   - Update k8s-ops script to kubectl-only version

2. **Phase 2**: Update Debian Makefile
   - Add `test-profile` target with tool verification (kubectl, k9s, ytt)
   - Add version tagging like Fedora's `REPO_TAG`
   - Match Fedora's output messages

3. **Phase 3**: Deprecate Fedora
   - Move Fedora files to archive or remove
   - Update any documentation referencing Fedora

4. **Phase 4**: Validation
   - Run `make test-profile` on Debian
   - Verify all tools install correctly
   - Confirm k8s-ops functionality
