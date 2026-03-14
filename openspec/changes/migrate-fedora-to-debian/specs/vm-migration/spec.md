## ADDED Requirements

### Requirement: Debian template shall include k9s CLI
The Debian cloud-init provisioning SHALL install k9s terminal UI for Kubernetes management.

#### Scenario: k9s installation completes successfully
- **WHEN** Debian VM is provisioned with cloud-init
- **THEN** `k9s version` command returns installed version

### Requirement: Debian template shall include Carvel ytt
The Debian cloud-init provisioning SHALL install Carvel ytt for YAML templating.

#### Scenario: ytt installation completes successfully
- **WHEN** Debian VM is provisioned with cloud-init
- **THEN** `ytt --version` command returns installed version

### Requirement: Debian template shall include k8s-ops helper
The Debian cloud-init provisioning SHALL install the k8s-ops helper script for Kubernetes management.

#### Scenario: k8s-ops status shows cluster info
- **WHEN** user runs `k8s-ops status`
- **THEN** System displays Kubernetes cluster info and nodes

#### Scenario: k8s-ops k9s launches k9s UI
- **WHEN** user runs `k8s-ops k9s`
- **THEN** k9s terminal UI launches

### Requirement: Debian Makefile shall support profile testing
The Debian Makefile SHALL include a `test-profile` target that validates all installed tools.

#### Scenario: test-profile verifies Kubernetes tools
- **WHEN** user runs `make test-profile`
- **THEN** System verifies kubectl, k9s, ytt are installed

#### Scenario: test-profile cleans up after verification
- **WHEN** test-profile completes (success or failure)
- **THEN** Test VM is deleted with `incus delete test-<name> --force`

### Requirement: Debian Makefile shall support versioned image names
The Debian Makefile SHALL use git repository tags for image naming.

#### Scenario: Image name includes git tag
- **WHEN** `make create` is executed
- **THEN** Image name includes output of `git describe --tags --always --dirty`
