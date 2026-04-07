---
name: Template Request
about: Request support for a new distribution template
title: '[Template] '
labels: template, enhancement
assignees: ''
---

## Requested Distribution

**Distribution**: (e.g., Fedora 39, Alpine 3.19, etc.)

**Version**: (specific version number)

## Use Case

Why do you need this distribution template?

> Examples:
> - Specific package availability
> - Compliance requirements
> - Testing on specific distro
> - Personal preference

## Required Features

What features from existing templates are essential?

- [ ] Development tools (build-essential, git, etc.)
- [ ] Container support (Docker/Podman)
- [ ] Kubernetes tools (kubectl, k9s, etc.)
- [ ] Language runtimes (Node.js, Go, Python, etc.)
- [ ] Shell customization (Zsh, Oh My Zsh, etc.)
- [ ] AI tooling (OpenCode, etc.)
- [ ] Other: ______

## Technical Considerations

### Package Manager
- **Name**: (e.g., dnf, apk, pacman)
- **Key packages**: List any distribution-specific packages needed

### Init System
- [ ] systemd
- [ ] Other: ______

### Cloud-init Support
- [ ] Yes, cloud-init available
- [ ] No, need alternative provisioning
- [ ] Not sure

### Virtualization
- [ ] Incus/LXD VM
- [ ] Docker container
- [ ] Both

## Challenges/Concerns

Are there any known challenges with this distribution?

> Examples:
> - Package availability
> - Incus/LXD compatibility
> - Container base image size
> - Security considerations

## Testing Environment

Do you have access to test this template?

- [ ] Yes, I can test and validate
- [ ] No, requesting community testing

## Additional Context

Any other information that would help in creating this template.
