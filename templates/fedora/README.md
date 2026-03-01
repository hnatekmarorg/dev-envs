# Fedora Base Development Environment

A preseeded Fedora container template for rapid development environment provisioning using Incus/LXD. This template automates the setup of a comprehensive development environment with essential tools, shells, and AI-powered coding assistance.

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
- **Container Orchestration**: kubectl
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

### Launch a Development Container

```bash
# Launch a new development environment
incus launch fedora-base-{tag} my-dev-environment -p default -p fedora-base-{tag}

# Or with a specific tag
incus launch fedora-base-v1.0.0 my-project -p default -p fedora-base-v1.0.0
```

### Access Your Environment

```bash
# Connect to the container
incus exec my-dev-environment -- zsh

# Or start a shell
incus exec my-dev-environment -- bash
```

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
incus exec <container> -- systemctl status sshd
```

### Package Installation Failures

Force update repositories:
```bash
incus exec <container> -- dnf clean all
incus exec <container> -- dnf update -y
```

## Best Practices

1. **Tag Your Builds**: Use semantic versioning for reproducible environments
2. **Test Before Deploying**: Validate the profile in a test container first
3. **Keep Images Updated**: Regularly rebuild with `make destroy && make create`
4. **Secure SSH**: Key-based authentication is enforced by default

## License

This template is configured for personal development use. Modify as needed for your organization.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Update `cloud-init.yaml` with enhancements
4. Submit a pull request

---

**Built with ❤️ using Fedora, Incus, and AI-powered development tools**
