## ADDED Requirements

### Requirement: Debian VM template provisioning
The system SHALL provide cloud-init configuration for Debian VM provisioning with automated development environment setup.

#### Scenario: Package installation completes
- **WHEN** cloud-init runs on Debian VM
- **THEN** all development packages are installed successfully

#### Scenario: User environment configured
- **WHEN** VM provisioning completes
- **THEN** root user has zsh shell with SSH key configured

### Requirement: Development toolchain installation
The system SHALL install the same development tools as the Ubuntu template.

#### Scenario: Core development tools installed
- **WHEN** package installation completes
- **THEN** cmake, gcc, g++, make, git, git-lfs are available

#### Scenario: Language runtimes installed
- **WHEN** provisioning completes
- **THEN** Go, Node.js (via nvm), Python (via uv), and Bun are installed

#### Scenario: Container tools configured
- **WHEN** setup completes
- **THEN** Docker and Docker Compose are installed and running

### Requirement: Productivity tools setup
The system SHALL install productivity utilities matching the Ubuntu template.

#### Scenario: Shell enhancements installed
- **WHEN** provisioning completes
- **THEN** fzf, zoxide, direnv, htop, jq are available

#### Scenario: Terminal and editor configured
- **WHEN** setup completes
- **THEN** neovim, kitty-terminfo, and zsh with Oh My Zsh are installed

### Requirement: Kubernetes tooling
The system SHALL provide Kubernetes CLI tools for external cluster management.

#### Scenario: Kubectl installed
- **WHEN** package installation completes
- **THEN** kubectl is available and functional

#### Scenario: K8s utilities installed
- **WHEN** provisioning completes
- **THEN** k9s, yq, ytt, and k8s-ops helper are installed

### Requirement: AI assistant integration
The system SHALL configure OpenCode AI assistant with local model provider.

#### Scenario: OpenCode installed
- **WHEN** runcmd executes
- **THEN** opencode is installed via official installer

#### Scenario: Provider configured
- **WHEN** configuration completes
- **THEN** local Qwen model provider is configured in config.json

### Requirement: System services configuration
The system SHALL configure and enable required system services.

#### Scenario: Incus agent running
- **WHEN** VM boots
- **THEN** incus-agent service is enabled and running

#### Scenario: Docker service running
- **WHEN** VM boots
- **THEN** Docker service is enabled and running

#### Scenario: SSH accessible
- **WHEN** VM boots
- **THEN** SSH service is enabled with key-based authentication

### Requirement: Template management
The system SHALL provide Makefile for profile creation and testing.

#### Scenario: Profile creation works
- **WHEN** running `make create`
- **THEN** Incus profile is created with cloud-init configuration

#### Scenario: Profile testing works
- **WHEN** running `make test-profile`
- **THEN** Test VM is launched for validation

#### Scenario: Profile cleanup works
- **WHEN** running `make destroy`
- **THEN** Incus profile is deleted

### Requirement: Documentation
The system SHALL provide documentation for template usage.

#### Scenario: README available
- **WHEN** user reads README.md
- **THEN** Quick start guide and troubleshooting info are available

#### Scenario: Usage examples provided
- **WHEN** user needs to launch VM
- **THEN** README shows exact incus launch command
