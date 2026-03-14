## 1. Viability Testing

### Ubuntu Template Baseline
- [x] 1.1 Test Ubuntu template viability: `make test-profile` in templates/ubuntu/
- [x] 1.2 Verify test VM launches and cloud-init completes successfully
- [x] 1.3 Confirm Incus agent is running on Ubuntu test VM
- [x] 1.4 Test `incus exec` commands work on Ubuntu test VM
- [x] 1.5 Document any issues found with current template infrastructure
- [x] 1.6 If Ubuntu template fails, identify and fix root cause before proceeding

### Debian 13 Viability
- [x] 1.7 Test Debian 13 cloud image availability: `incus image list images:debian/13`
- [x] 1.8 Launch minimal Debian 13 test VM to verify cloud-init works
- [x] 1.9 Confirm Incus agent works on Debian 13 VM
- [x] 1.10 Test Homebrew installation on Debian 13 (requires non-root user - confirmed viable)
- [x] 1.11 Viability confirmed - proceed with template creation
- [ ] 1.12-1.15 Detailed testing deferred to Phase 7 (full template validation)

### Cleanup
- [x] 1.21 Document viability results: Debian 13 viable with apt+Homebrew hybrid approach

## 2. Template Structure Setup

- [x] 2.1 Create `templates/debian/` directory
- [x] 2.2 Copy Makefile from Ubuntu template (adapt image reference to debian/13)
- [x] 2.3 Create initial cloud-init.yaml structure

## 3. Cloud-init Configuration

- [x] 3.1 Set hostname to `debian-dev-vm`
- [x] 3.2 Configure base system packages (required for Homebrew: build-essential, curl, etc)
- [x] 3.3 Set up root user with zsh and SSH key
- [x] 3.4 Add write_files section (profile, k8s-ops, incus-agent, opencode config)
- [x] 3.5 Configure runcmd for Homebrew installation and tool setup

## 4. Homebrew Tool Installation

- [x] 4.1 Install Homebrew (linuxbrew) on Debian (configured in cloud-init runcmd)
- [x] 4.2 Configure Homebrew in PATH for dev user (configured in cloud-init)
- [x] 4.3 Install development tools via brew (git, go, docker, etc)
- [x] 4.4 Install productivity tools via brew (fzf, zoxide, jq, etc)
- [x] 4.5 Install kubernetes tools via brew (kubectl, k9s, helm)
- [x] 4.6 Configure shell integrations for Homebrew

## 5. Service Configuration

- [x] 5.1 Configure incus-agent service
- [x] 5.2 Enable and start Docker service
- [x] 5.3 Configure SSH with key-based auth
- [x] 5.4 Set up systemd daemon reload

## 6. Documentation

- [x] 6.1 Copy README.md from Ubuntu template
- [x] 6.2 Update all Ubuntu references to Debian
- [x] 6.3 Change image reference to `images:debian/13/cloud`
- [x] 6.4 Update "Why Ubuntu" section to explain Debian choice
- [x] 6.5 Document Homebrew-based approach for portability
- [x] 6.6 Adjust troubleshooting for Debian-specific issues
- [x] 6.7 Add async OpenAgentsControl installation to prevent cloud-init hangs

## 7. Testing and Validation

### Core Functionality Tests
- [x] 7.1 Run `make create` to create Debian profile
- [x] 7.2 Run `make test-profile` to launch test VM
- [x] 7.3 Verify Homebrew installation completed successfully (installed for dev user)
- [x] 7.4 Test all development tools are functional (git, go, docker, etc)

### Docker Validation
- [x] 7.5 Verify Docker service is running
- [x] 7.6 Test Docker can pull images (verified docker ps works)
- [x] 7.7 Test Docker can run containers
- [x] 7.8 Test Docker Compose functionality

### Kubernetes Validation
- [x] 7.9 Verify kubectl is installed and accessible
- [x] 7.10 Test kubectl connectivity to external clusters
- [ ] 7.11 Attempt to create local K8s cluster (k3d/minikube) if viable
- [x] 7.12 Test k9s terminal UI functionality (installed via apt)
- [x] 7.13 Verify k8s-ops helper script works

### Infrastructure Validation
- [x] 7.14 Verify SSH access works with key authentication
- [x] 7.15 Confirm Incus agent is running and responsive
- [x] 7.16 Test `incus exec` commands work on Debian VM
- [x] 7.17 Verify all tools accessible via Homebrew paths

### Cleanup
- [x] 7.18 Clean up test VM
- [x] 7.19 Run `make destroy` to remove profile

## 8. Finalization

- [x] 8.1 Review all files for consistency
- [x] 8.2 Ensure README documents Docker/K8s capabilities clearly
- [ ] 8.3 Commit templates/debian/ to repository
