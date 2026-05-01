# Debian Base VM Template

A preseeded Debian VM template for rapid development environment provisioning using Incus/LXD. This template automates the setup of a comprehensive development environment with essential tools, shells, and AI-powered coding assistance.

## Features

- **Fully Isolated Development Environment**: Each VM is self-contained with all necessary tools
- **Incus Agent Support**: Full bidirectional communication between host and VM
- **Comprehensive Toolchain**: Docker, Kubernetes CLI, Git, Go, Python, Node.js support
- **Modern Shell**: Zsh with Oh My Zsh, fzf, zoxide, and custom prompt
- **AI Integration**: Pre-configured for OpenCode AI assistant with multiple model providers
  - **GLM 4.7**: Heavy reasoning tasks
  - **Qwen3.5 (reasoning)**: Planning and complex reasoning
  - **Qwen3.5 (coding)**: Primary coding and execution
  - **Minimax 2.5**: Alternative reasoning model
  - **Fast models**: Background tasks and commit summarization
- **Kubernetes Ready**: kubectl, k9s, and cluster management tools (for external clusters)
- **SSH Key Configuration**: Your public SSH key is automatically configured for passwordless access

## Requirements

- Incus/LXD installed and configured
- KVM support for VMs
- At least 4GB RAM and 20GB disk space per VM

## Quick Start

### 1. Create the Profile

```bash
cd templates/debian
just create
```

This creates a profile named `debian-base-{commit-hash}` with all the configuration.

### 2. Launch a Development VM

```bash
incus launch --vm images:debian/13/cloud my-dev-environment -p default -p debian-base-{commit-hash}


**Important**: Use `images:debian/13/cloud` (not `images:debian/13`) to ensure cloud-init is pre-installed.

Replace `{commit-hash}` with the actual hash shown after running `just create`.

### 3. Wait for Initialization

The VM will automatically:
- Update all packages
- Install development tools
- Configure SSH
- Start the Incus agent
- Set up the development environment

This typically takes 3-5 minutes.

### 4. Connect to Your VM

```bash
# Check if VM is ready
incus exec my-dev-environment -- hostname

# Connect via shell
incus exec -it my-dev-environment -- bash

# Or via SSH (your public key is pre-configured)
ssh root@<vm-ip>
```

### SSH Access

Your public SSH key is automatically configured during VM provisioning, allowing passwordless SSH access. The key is configured in the `cloud-init.yaml` file under the `users` section:

```yaml
users:
  - name: root
    shell: /usr/bin/zsh
    ssh_authorized_keys:
      - ssh-ed25519 YOUR_PUBLIC_KEY_HERE
```

**To change the SSH key:**
1. Edit `cloud-init.yaml` and update the `ssh_authorized_keys` section
2. Run `just destroy-profile && just create` to update the profile
3. Launch a new VM with the updated profile

**Note:** Existing VMs won't automatically update. You need to recreate them to apply key changes.

## Available Tools

### Development Essentials
- Git & Git LFS
- Go (Golang)
- Docker & Docker Compose
- Kubernetes CLI (kubectl)
- Make, CMake, GCC/G++
- Neovim
- Zsh with Oh My Zsh

### Productivity Tools
- fzf (fuzzy finder)
- zoxide (smart cd)
- jq (JSON processor)
- yq (YAML processor)
- htop, nmap, rsync
- direnv (directory-based environment variables)

### Kubernetes Tools
- kubectl - Kubernetes CLI
- k9s - Terminal UI for K8s
- k8s-ops - Cluster management helper
- ytt - YAML templating

**Note**: This template supports **external Kubernetes clusters only**. K3D/K3S don't work reliably in containerized environments. Connect to:
- Cloud K8s (GKE, EKS, AKS)
- Minikube on a separate VM
- On-premises clusters
- Any cluster with a kubeconfig

## Managing VMs

### List VMs
```bash
incus list
```

### Stop/Start VM
```bash
incus stop my-dev-environment
incus start my-dev-environment
```

### Delete VM
```bash
incus delete my-dev-environment --force
```

### View Logs
```bash
incus console my-dev-environment
```

## Profile Management

### Update Profile
```bash
just destroy-profile
# Edit cloud-init.yaml
just create
```

**Note**: Existing VMs won't automatically update. You need to recreate them with the new profile.

### Test Profile
```bash
just test-profile
```

Creates a test VM to verify the configuration before deploying to production.

## Troubleshooting

### VM Agent Not Running
If `incus exec` commands fail with "VM agent isn't currently running":

1. Wait 5-10 minutes after launch
2. Check VM console: `incus console <vm-name>`
3. Verify cloud-init completed: `incus exec <vm-name> -- cloud-init status`
4. Restart the VM: `incus restart <vm-name> --force`

### No Network Connectivity
1. Check if VM has IP: `incus list <vm-name>`
2. Verify network interface is up inside VM
3. Check Incus network configuration

### SSH Not Working
1. Ensure SSH service is running: `incus exec <vm-name> -- systemctl status ssh`
2. Check firewall rules
3. Verify SSH keys are configured

### Docker Not Starting
```bash
incus exec <vm-name> -- systemctl status docker
incus exec <vm-name> -- systemctl start docker
```

## Architecture

```
Host (Incus)
├── Profile: debian-base-{hash}
│   ├── cloud-init.yaml (provisioning)
│   └── Network config
└── VMs
    ├── my-dev-environment
    │   ├── /usr/local/bin/k8s-ops
    │   ├── /etc/systemd/system/incus-agent.service
    │   └── All development tools
    └── other-vm...
```

## Customization

### Add New Packages
Edit `packages:` section in `cloud-init.yaml`

### Add New Scripts
Add to `write_files:` section in `cloud-init.yaml`

### Modify runcmd
Edit `runcmd:` section in `cloud-init.yaml`

**Important**: After changes, run `just destroy-profile && just create` to update the profile.

## Why Debian?

After extensive testing:
- ✅ **Ubuntu VMs**: Incus agent works reliably
- ✅ **Debian VMs**: Incus agent works reliably  
- ❌ **Fedora VMs**: Incus agent fails to start
- ❌ **Containers**: K3D/K3S don't work due to kernel restrictions

Debian 13 (Trixie) provides:
- Recent packages
- Rolling release model
- Incus/LXD compatibility
- Large community support
- Stable base for development
- Long-term support (LTS)
- Incus/LXD compatibility
- Community support

## License

This template is provided as-is for development purposes.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Incus documentation: https://linuxcontainers.org/incus/docs/main/
3. Check cloud-init documentation: https://cloudinit.readthedocs.io/
