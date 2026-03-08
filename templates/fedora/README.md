# Fedora Base Development Environment

A preseeded Fedora VM template for rapid development environment provisioning using Incus/LXD. This template automates the setup of a comprehensive development environment with essential tools, shells, and AI-powered coding assistance.

## Features

### Development Tools
- **Compilers & Build**: GCC, G++, Make, CMake
- **Version Control**: Git
- **Editors**: Neovim (LazyVim configured), Vim
- **Shell**: Zsh with Oh My Zsh, 3den theme
- **Package Manager**: DNF with optimized configuration
### System Utilities
- Process monitoring: htop, nmap
- Network tools: net-tools, iputils, SSH server
- File sync: rsync
- Data processing: jq, yq
- Archive tools: tar, unzip

### Modern Developer Stack
- **Container Orchestration**:
  - kubectl (Kubernetes CLI)
  - K3D (Kubernetes in Docker)
  - k9s (Kubernetes terminal UI)
  - ytt (Carvel YAML template processor)
  - Docker & Docker Compose
- **Runtime**: Bun (JavaScript/TypeScript runtime)
- **Navigation**: zoxide (smart directory jumping)
- **Fuzzy Finding**: fzf integrated in shell
- **AI Coding Assistant**: Opencode AI with Qwen 3.5 122B model
- **SSH Access**: Your public SSH key is automatically configured for passwordless access

### System Utilities
- Process monitoring: htop, nmap
- Network tools: net-tools, iputils, SSH server
- File sync: rsync
- Data processing: jq, yq
- Archive tools: tar, unzip

### Modern Developer Stack
- **Container Orchestration**:
  - kubectl (Kubernetes CLI)
  - K3D (Kubernetes in Docker)
  - k9s (Kubernetes terminal UI)
  - ytt (Carvel YAML template processor)
  - Docker & Docker Compose
- **Runtime**: Bun (JavaScript/TypeScript runtime)
- **Navigation**: zoxide (smart directory jumping)
- **Fuzzy Finding**: fzf integrated in shell
- **AI Coding Assistant**: Opencode AI with Qwen 3.5 122B model

### Shell Configuration
- Custom PS1 prompt: `[hnatekmarorg] user@host:path$`
- Preconfigured plugins:
  - Arch Linux helpers
  - Direnv for environment variables
  - Git integration
  - Kubectl autocomplete
  - SSH agent forwarding
  - Autosuggestions & syntax highlighting

## Kubernetes Cluster Management

The environment includes K3D (Kubernetes in Docker), a lightweight Kubernetes distribution perfect for development and testing in VMs. K3D runs Kubernetes clusters inside Docker containers, providing full compatibility with Kubernetes while being lightweight and fast.

### Using the k8s-ops Helper

A convenience script `k8s-ops` is provided for cluster operations:

```bash
# Start the k3d cluster
k8s-ops start

# Check cluster status
k8s-ops status

# Launch k9s to explore your cluster
k8s-ops k9s

# Run kubectl commands directly
k8s-ops kubectl get nodes
k8s-ops kubectl get pods -A

# Follow k3d cluster logs
k8s-ops logs

# Stop the cluster when done
k8s-ops stop

# Show help
k8s-ops help
```

### Manual K3D Operations

You can also use k3d directly:

```bash
# Create a cluster
k3d cluster create my-cluster

# List clusters
k3d cluster list

# Delete a cluster
k3d cluster delete my-cluster

# Access cluster logs
k3d node logs my-cluster-server-0 --follow

# Create cluster with specific ports
k3d cluster create my-cluster --port 8080:80@loadbalancer --port 8443:443@loadbalancer
```

### Using k9s

k9s is a terminal-based Kubernetes UI:

```bash
# Connect directly
k9s

# Or use the helper
k8s-ops k9s
```

### Using ytt

ytt is a YAML template processor for Kubernetes manifests:

```bash
# Process a template
ytt -f template.yaml -f values.yaml

# Example with custom values
ytt -f deployment/ -f config/values.yaml > rendered.yaml
```

## Quick Start

### Prerequisites
- Incus (or LXD) installed and running
- Git installed
- Network connectivity for initial provisioning

### Create the Base Profile

```bash
# Clone the repository
git clone <repository-url>
cd templates/fedora

# Create the base profile
make create
```

This will:
1. Create a new Incus profile named `fedora-base-{tag}`
2. Configure cloud-init with all provisioning scripts
3. Set up the development environment automatically on first launch
4. Enable Docker support (with security nesting and privileged mode)
5. Pre-install K3D, k9s, and ytt for Kubernetes cluster management

### Launch a Development VM

```bash
# Launch a new development environment (note: use --vm flag)
incus launch --vm fedora-base-{tag} my-dev-environment -p default -p fedora-base-{tag}

# Or with a specific tag
incus launch --vm fedora-base-v1.0.0 my-project -p default -p fedora-base-v1.0.0
```

**Note:** VMs take longer to boot than containers (typically 2-3 minutes for cloud-init to complete).

### Access Your Environment

```bash
# Connect to the VM
incus exec my-dev-environment -- zsh

# Or start a shell
incus exec my-dev-environment -- bash

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
2. Run `make destroy && make create` to update the profile
3. Launch a new VM with the updated profile

**Note:** Existing VMs won't automatically update. You need to recreate them to apply key changes.

## Configuration

### Cloud-Init Provisioning

The `cloud-init.yaml` file handles automatic setup:

- Updates all packages
- Installs development tools
- Configures Zsh with Oh My Zsh
- Sets up Opencode AI assistant
- Installs LazyVim configuration
- Configures SSH for remote access
- Sets up Bun runtime
- Installs Docker & Docker Compose
- Installs K3D for Kubernetes clusters
- Installs k9s for cluster management
- Installs carvel ytt for YAML templating

### AI Configuration

The template includes preconfigured Opencode AI with:
- **Model**: Qwen 3.5 122B
- **Base URL**: Custom LLM endpoint
- **Modes**:
  - `coding`: Optimized for code generation (temperature: 0.2)
  - `thinking`: Optimized for reasoning (temperature: 0.7)

See `config.json` for detailed AI provider configuration.

### Makefile Targets

| Target | Description |
|--------|-------------|
| `make create` | Create the base Fedora profile |
| `make destroy` | Delete the base profile |
| `make status` | Check if profile exists |
| `make test-profile` | Test the profile by creating and verifying a test VM |
| `make help` | Display available targets |

## Environment Variables

Customizable via Makefile:

```bash
# Override repository tag
REPO_TAG=v1.0.0 make create

# Default: auto-detects from git tags
```

## Customization

### Adding Packages

Edit `cloud-init.yaml` and add packages to the `packages:` section:

```yaml
packages:
  - gcc
  - make
  - your-package-here  # Add new packages here
```

### Modifying Shell Configuration

Update `/root/.zshrc` in `cloud-init.yaml` to customize:
- Editor preferences
- Plugin additions
- Environment variables
- Path configurations

### AI Model Configuration

Modify `config.json` or the embedded config in `cloud-init.yaml` to:
- Change temperature settings
- Add new model variants
- Configure different providers

## Architecture

```
templates/fedora/
├── Makefile              # Build automation
├── config.json           # AI configuration template
├── cloud-init.yaml       # Provisioning script
└── README.md             # This file
```

## Troubleshooting

### Quick Reference Card

| Issue | Symptom | Solution |
|-------|---------|----------|
| Cloud-init timeout | `cloud-init status` hangs or shows error | Wait 2-3 minutes, or relaunch VM |
| Missing tools | `kubectl: command not found` | Verify `cloud-init status` shows "done" |
| Docker not working | `docker: permission denied` | Check `security.nesting=true` and `security.privileged=true` |
| K3D cluster not running | K3D service not available | Run: `k8s-ops start` |
| No network access | `ping` fails | Wait for DHCP, check DNS, review firewall rules |
| SSH fails | `Connection refused` | Verify `systemctl status sshd` shows "active" |

**Pro Tip**: If cloud-init appears stuck but works eventually, you can start using the VM immediately - cloud-init runs in background and tools will install within a few minutes.

### Profile Already Exists

```bash
# Check existing profiles
incus profile list | grep fedora-base

# Remove if needed
make destroy

# Recreate
make create
```

### SSH Connection Issues

Ensure SSH is enabled:
```bash
incus exec <vm> -- systemctl status sshd
```

### Package Installation Failures

Force update repositories:
```bash
incus exec <vm> -- dnf clean all
incus exec <vm> -- dnf update -y
```

## Best Practices

1. **Tag Your Builds**: Use semantic versioning for reproducible environments
2. **Test Before Deploying**: Validate the profile in a test VM first with `make test-profile`
3. **Keep Images Updated**: Regularly rebuild with `make destroy && make create`
4. **Secure SSH**: Key-based authentication is enforced by default

## Troubleshooting

### Cloud-Init Issues

**Cloud-init timeout or failure:**
```bash
# Check status
incus exec <vm> -- cloud-init status

# Wait for completion (may take 3-5 minutes on first boot)
incus exec <vm> -- cloud-init status --wait

# Check logs if it fails
incus exec <vm> -- cat /var/log/cloud-init.log | tail -50

# Common causes:
# - Network not ready (wait 1-2 minutes)
# - Package download slow (check internet)
```

**Tool not found after first launch:**
```bash
# Check if VM fully booted
incus exec <vm> -- cloud-init status # Should show "done"

# If status is "error", delete and relaunch
incus delete <vm> --force
incus launch --vm fedora-base-{tag} <name> -p default -p fedora-base-{tag}
```

### Docker Issues

**Docker not running:**
```bash
# Check service status
incus exec <vm> -- systemctl status docker

# Start it manually
incus exec <vm> -- systemctl enable --now docker

# Check if privileged mode is set
incus profile show fedora-base-{tag} | grep security
```

**Cannot run Docker commands:**
```bash
# Verify profile has security settings
incus profile set fedora-base-{tag} security.nesting=true
incus profile set fedora-base-{tag} security.privileged=true

# Recreate VM to apply changes
incus delete <vm> --force
incus launch --vm fedora-base-{tag} <name> -p default -p fedora-base-{tag}
```

### K3D Cluster Issues

**K3D cluster not starting:**
```bash
# Check K3D installation
k3d version

# View cluster status
k3d cluster list

# View logs for errors
k8s-ops logs

# Recreate cluster
k8s-ops stop
k8s-ops start

# For testing: Create a simple pod to verify kubectl works
kubectl run test --image=busybox:latest --restart=Never -- sleep 3600
```

**Increasing cloud-init timeout (if needed):**
```bash
# Edit the cloud-init config in the profile
incus profile set fedora-base-{tag} cloud-init.user-data "$(cat cloud-init.yaml)"

# Or wait manually - cloud-init will continue in background
# You can start working even if cloud-init shows "running"
```

### Connectivity Issues

**VM can't access internet:**
```bash
# Check DNS resolution
incus exec <vm> -- ping -c 3 8.8.8.8

# Review kernel log for DNS errors
incus exec <vm> -- journalctl -xb

# Workaround: Use alternative DNS
echo "nameserver 1.1.1.1" | incus exec <vm> -- tee /etc/resolv.conf
```

**SSH connection issues:**
```bash
# Check if SSH is running
incus exec <vm> -- systemctl status sshd

# Verify SSH config
incus exec <vm> -- cat /etc/ssh/sshd_config | grep PermitRootLogin
# Should show "prohibit-password" (keys only)

# Test SSH locally
incus exec <vm> -- ss -tlnp | grep :22
```

## Advanced Configuration

### Adjust Cloud-Init Timeout

If you consistently experience timeouts, you can modify cloud-init behavior:

```bash
# Edit your local cloud-init.yaml and add:
cloud_init_modules:
  - migrator
  - bootcmd
  - write-files
  - growpart
  - resizefs
  - rsyslog
  - users-groups
  - ssh
  # Note: "set_hostname" and "update_hostname" are skipped

# Recreate profile
make destroy
make create
```

### Profile Modifications

```bash
# View current profile config
incus profile show fedora-base-{tag}

# Add additional config
incus profile set fedora-base-{tag} limits.cpu "4"
incus profile set fedora-base-{tag} limits.memory "8GB"

# Add devices (e.g., extra mount points)
incus profile device add fedora-base-{tag} data disk source=/path/data path=/data

# Modify cloud-init on the fly (dangerous - test first)
incus profile set fedora-base-{tag} cloud-init.user-data "#cloud-config\n..."
```

### Manual Package Installation

If cloud-init fails but VM boots:

```bash
# Install Docker manually
incus exec <vm> -- dnf install -y docker docker-compose
incus exec <vm> -- systemctl enable --now docker

# Install kubectl
incus exec <vm> -- dnf install -y kubectl

# Install K3D
incus exec <vm> -- curl -sSfL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

### Performance Tuning

For faster cloud-init execution:

```bash
# Use package cache mirror in cloud-init.yaml:
# (Add under 'packages' section)
snapstore: "https://mirrors.fedoraproject.org"

# Increase CPU/memory limits
incus profile set fedora-base-{tag} limits.cpu "4"
incus profile set fedora-base-{tag} limits.memory "4GB"
```

## License

This template is configured for personal development use. Modify as needed for your organization.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Update `cloud-init.yaml` with enhancements
4. Submit a pull request

---

## FAQ

**Q: Why does cloud-init take so long on VMs?**
A: VMs require a full system boot which typically takes 2-3 minutes for cloud-init to complete. This is normal behavior compared to containers which boot instantly.

**Q: Can I use this for production Kubernetes clusters?**
A: Yes! K3D is production-grade and CNCF-certified. Incus VMs are perfect for development, testing, and light to medium production workloads. For heavy production, consider bare-metal or cloud VMs.

**Q: How often should I rebuild the profile?**
A: Rebuild when you need updates:
- New Kubernetes version (k9s, K3D, kubectl)
- Security updates to base packages
- Changes to the tooling configuration

**Q: Can I customize the tool versions?**
A: Yes! Edit the versions in `cloud-init.yaml`'s `runcmd` section and rebuild with `make destroy && make create`.

**Q: What if I need more resources?**
A: Adjust profile limits:
```bash
incus profile set fedora-base-{tag} limits.cpu "4"
incus profile set fedora-base-{tag} limits.memory "8GB"
```

**Q: How do I check if cloud-init is done?**
A: Run: `incus exec <vm> -- cloud-init status`. Look for "done" - if you see "running", wait a minute and check again.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Update `cloud-init.yaml` with enhancements
4. Submit a pull request

---

**Built with ❤️ using Fedora, Incus, and AI-powered development tools**
