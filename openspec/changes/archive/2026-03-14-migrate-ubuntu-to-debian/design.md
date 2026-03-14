## Context

The project currently has a production-ready Ubuntu VM template at `templates/ubuntu/` that provides an automated development environment using cloud-init and Incus/LXD. This design outlines creating a parallel Debian template with equivalent functionality.

**Current State:**
- `templates/ubuntu/` with cloud-init.yaml, Makefile, README.md
- Proven cloud-init provisioning approach
- Comprehensive development toolchain

**Constraints:**
- Match Ubuntu template's functionality and toolset
- Use Debian-appropriate package names and repositories
- Maintain same directory structure and Makefile interface
- Zero downtime - new template created independently

## Goals / Non-Goals

**Goals:**
- Create `templates/debian/` with equivalent functionality to Ubuntu template
- Mirror all development tools, shells, and configurations
- Provide same developer experience on Debian
- Document Debian-specific usage and differences

**Non-Goals:**
- Modify existing Ubuntu template
- Migration of existing Ubuntu VMs to Debian
- Adding new features not present in Ubuntu template

## Decisions

**Template Structure**
- **Decision**: Mirror Ubuntu template structure exactly
- **Rationale**: Consistency reduces cognitive load, same Makefile commands work for both
- **Alternatives Considered**: Shared base with overrides (over-engineering for this use case)

**Package Selection**
- **Decision**: Use Debian equivalents (same package names for most tools)
- **Rationale**: Most development tools have identical package names across Ubuntu/Debian
- **Alternatives Considered**: Different toolset (defeats purpose of equivalent experience)

**Base Image**
- **Decision**: Use `images:debian/13/cloud` (Debian 13 Trixie) with Debian 12 as fallback
- **Rationale**: Latest Debian testing with newer packages; if unstable, fall back to Debian 12 stable
- **Alternatives Considered**: Debian 12 stable only (older packages)
- **Fallback Criteria**: If Debian 13 cloud-init fails, Homebrew install fails, or core tools (Docker/K8s) don't work reliably

**Package Management**
- **Decision**: Use apt for all development tools; Homebrew available for dev user for future additions
- **Rationale**: apt provides faster, more reliable installation on Debian; Homebrew available for users who need newer versions
- **Reference**: https://brew.sh/
- **Implementation**: All dev tools installed via apt; Homebrew installed for dev user but no packages pre-installed
- **Alternatives Considered**: Homebrew for all packages (too slow during provisioning)

**Shell and Tooling**
- **Decision**: Identical shell configuration (zsh + Oh My Zsh) and tool installation scripts
- **Rationale**: User experience should be identical regardless of base OS
- **Alternatives Considered**: Debian-specific customization (unnecessary divergence)

## Risks / Trade-offs

## Risks / Trade-offs

[Package Availability] → Mitigation: Most development tools available in Debian repos; Homebrew available as fallback

[Cloud-init Compatibility] → Mitigation: Debian cloud images tested with cloud-init, same syntax as Ubuntu

[Incus Agent] → Mitigation: README confirms Debian VMs work reliably with Incus agent

[Homebrew on Debian] → Mitigation: Linuxbrew officially supports Debian per https://brew.sh/; installed but not pre-populated for speed

[Docker in VM/Container] → Mitigation: Tested and confirmed working on Debian VMs

[Kubernetes Cluster Creation] → Mitigation: kubectl works; k3d/k8s creation may require nested virtualization - documented as external clusters only

[Documentation Drift] → Mitigation: Keep both READMEs in sync, note any Debian-specific differences

[Network Timeouts] → Mitigation: Some optional downloads (OpenAgents Control) may timeout - core tools install successfully
