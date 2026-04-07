## ADDED Requirements

### Requirement: Schema documentation
The openspec workflow SHALL be documented with:
- Explanation of the spec-driven schema
- Artifact types (proposal, design, specs, tasks)
- Dependency relationships between artifacts
- How to use `openspec` CLI commands

#### Scenario: User understands workflow
- **WHEN** a user reads the workflow documentation
- **THEN** they understand the artifact creation order and dependencies

### Requirement: Change lifecycle documentation
The workflow SHALL document:
- How to create a new change (`openspec new change`)
- How to check status (`openspec status`)
- How to get artifact instructions (`openspec instructions`)
- How to apply changes (`openspec apply` or `/opsx-apply`)
- How to archive completed changes (`openspec archive`)

#### Scenario: User creates a change
- **WHEN** a user runs `openspec new change <name>`
- **THEN** a scaffolded change directory is created

#### Scenario: User tracks progress
- **WHEN** a user runs `openspec status --change <name> --json`
- **THEN** they see which artifacts are ready, blocked, or done

### Requirement: Artifact templates
Each artifact type SHALL have a template:
- `proposal.md`: Why and what changes
- `design.md`: How to implement (when needed)
- `specs/<capability>/spec.md`: Detailed requirements
- `tasks.md`: Implementation tasks

#### Scenario: User creates proposal
- **WHEN** an AI creates a proposal artifact
- **THEN** it follows the proposal template structure

### Requirement: Spec format requirements
Spec files SHALL follow the format:
- Use `## ADDED Requirements`, `## MODIFIED Requirements`, `## REMOVED Requirements` sections
- Each requirement uses `### Requirement: <name>` header
- Each requirement has at least one `#### Scenario:` with WHEN/THEN format
- Use SHALL/MUST for normative language

#### Scenario: Spec is testable
- **WHEN** a spec file is created
- **THEN** each scenario can be converted to a test case

### Requirement: Change directory structure
Each change SHALL have:
- `.openspec.yaml` configuration file
- Artifact files (proposal.md, design.md, tasks.md)
- `specs/` directory for spec files (if using spec-driven schema)

#### Scenario: Change is valid
- **WHEN** a change directory exists
- **THEN** it has all required files for its schema type
