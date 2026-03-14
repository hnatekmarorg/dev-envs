## 1. Update Debian Cloud-Init Configuration

- [x] 1.1 Remove Docker and k3d (won't work in LXC)
- [x] 1.2 Add k9s download and installation
- [x] 1.3 Add Carvel ytt installation
- [x] 1.4 Replace k8s-ops script with kubectl-only version
- [x] 1.5 Verify all package names are Debian-compatible

## 2. Update Debian Makefile

- [x] 2.1 Add REPO_TAG variable using git describe
- [x] 2.2 Update IMAGE_NAME to use REPO_TAG
- [x] 2.3 Add test-profile target with tool verification (kubectl, k9s, ytt)
- [x] 2.4 Add status target to check profile existence
- [x] 2.5 Update help target to show all available targets

## 3. Testing and Validation

- [x] 3.1 Run `make create` to create Debian profile
- [x] 3.2 Run `make test-profile` to verify all tools install correctly
- [x] 3.3 Test k8s-ops status/kubectl commands on test VM
- [x] 3.4 Verify kubectl, k9s, ytt are all functional
- [x] 3.5 Clean up test VM and confirm deletion

## 4. Deprecate Fedora Template

- [x] 4.1 Archive Fedora template files (move to archive/ or add deprecation notice)
- [x] 4.2 Update any documentation referencing Fedora template
- [x] 4.3 Add migration guide for users with existing Fedora VMs
