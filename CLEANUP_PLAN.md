# Cleanup: Debian-Only Dev Environments

**Goal:** Clean up the dev-envs repository to focus exclusively on Debian development environments in two modalities: Docker container and Incus VM. Remove all unrelated configuration (.opencode/, openspec/, dependency files).

**Target Structure:**
```
dev-envs/
├── README.md              # Simplified: Debian Docker + Incus VM only
├── AGENTS.md              # Simplified: Basic AI guidelines
├── Justfile               # Docker + VM commands only
├── .gitignore             # Updated
├── .github/
│   └── ISSUE_TEMPLATE/    # Keep for bug reports
└── templates/
    └── debian/
        ├── README.md      # Template usage
        ├── justfile       # Template-local commands
        ├── Dockerfile     # Container provisioning
        ├── entrypoint.sh  # Container runtime
        └── cloud-init.yaml # VM provisioning
```

---

## Milestones

### M0: Prep & Backup
**Goal:** Create backup branch and establish baseline functionality.

**Tasks:**
- [ ] Create backup branch: `git checkout -b backup-before-cleanup`
- [ ] Test current workflows: `just docker-build`, `just debian-test`
- [ ] Document current file count: `find . -type f | wc -l`

**Success Criteria:**
- Backup branch created and pushed
- Baseline tests pass (docker-build succeeds, debian profile creates)
- Current file count documented

---

### M1: Remove .opencode/ Directory
**Goal:** Remove ~150+ files of unrelated AI agent configuration.

**Tasks:**
- [ ] Verify .opencode/ is not referenced elsewhere: `grep -r ".opencode" --include="*.md" --include="*.yaml" --include="*.sh" .`
- [ ] Remove .opencode/ directory: `rm -rf .opencode/`
- [ ] Verify removal: `git status`

**Success Criteria:**
- .opencode/ directory completely removed
- No broken references in remaining files
- Git status shows ~150+ files deleted

---

### M2: Remove openspec/ Directory
**Goal:** Remove entire openspec change management workflow.

**Tasks:**
- [ ] Remove openspec/ directory: `rm -rf openspec/`
- [ ] Verify removal: `git status`

**Success Criteria:**
- openspec/ directory completely removed
- Git status reflects removal

---

### M3: Remove Root Dependencies
**Goal:** Clean up root-level dependency files and bloat.

**Tasks:**
- [ ] Remove package.json: `rm package.json`
- [ ] Remove bun.lock: `rm bun.lock`
- [ ] Remove models.json: `rm models.json`
- [ ] Remove .crush/ directory: `rm -rf .crush/`
- [ ] Remove node_modules/: `rm -rf node_modules/`
- [ ] Verify removal: `git status`

**Success Criteria:**
- All dependency files removed from root
- Root directory contains only essential files

---

### M4: Clean Template Files
**Goal:** Remove unused configuration files from templates/debian/.

**Tasks:**
- [ ] Check if models.json is referenced in Dockerfile: `grep "models.json" templates/debian/Dockerfile`
- [ ] Check if models.yml is referenced in Dockerfile: `grep "models.yml" templates/debian/Dockerfile`
- [ ] If models.json is copied into image, verify if needed (check entrypoint.sh)
- [ ] Remove models.json from templates/debian/ if unused
- [ ] Remove models.yml from templates/debian/ if unused
- [ ] Verify removal: `git status`

**Success Criteria:**
- Unused model configuration files removed
- Docker build still succeeds after removal

---

### M5: Update Justfile
**Goal:** Simplify Justfile to remove openspec references.

**Tasks:**
- [ ] Review current Justfile for openspec commands
- [ ] Remove openspec-related commands (new, status, list, archive references)
- [ ] Keep only docker-* and debian-* commands
- [ ] Update default recipe if needed
- [ ] Test: `just --list` shows only relevant commands

**Success Criteria:**
- Justfile contains only Docker and VM management commands
- All remaining commands work correctly

---

### M6: Update Documentation
**Goal:** Rewrite documentation for Debian-only focus.

**Tasks:**
- [ ] Update README.md:
  - Remove openspec references
  - Clarify Debian-only focus (Docker + Incus VM)
  - Update project structure section
  - Remove Ubuntu references
- [ ] Update AGENTS.md:
  - Remove openspec workflow section
  - Remove Ubuntu template references
  - Simplify to basic contribution guidelines
- [ ] Update .gitignore:
  - Add any missing patterns
  - Remove openspec/bun-specific patterns if no longer needed
- [ ] Verify: No references to removed files in documentation

**Success Criteria:**
- README.md clearly describes Debian Docker + Incus VM only
- AGENTS.md provides clear, simplified guidelines
- .gitignore is up to date
- No broken links or references

---

### M7: Validation & Testing
**Goal:** Verify all workflows still function after cleanup.

**Tasks:**
- [ ] Test Docker build: `just docker-build`
- [ ] Test Docker run: `just docker-run` (or manual docker run)
- [ ] Test Debian profile: `just debian-create`
- [ ] Test Debian profile: `just debian-test-profile`
- [ ] Verify container starts and SSH works
- [ ] Verify VM profile creates successfully
- [ ] Run: `just --list` to confirm all commands available
- [ ] Final git status review

**Success Criteria:**
- Docker build succeeds
- Docker container runs and is accessible
- Incus VM profile creates successfully
- All Justfile commands work
- Repository is clean and focused

---

## Dependencies

```
M0 → M1 → M2 → M3 → M4 → M5 → M6 → M7
```

All milestones are sequential due to file dependency chain.

---

## Abort Points

Safe to stop after: M1, M2, M3, M4, M5, M6
Must complete: M0 (safety), M7 (validation)

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Breaking Docker build | Test after M4, before committing |
| Breaking VM profile | Test after M5, before committing |
| Removing needed files | Backup branch created in M0 |
| Documentation drift | Final review in M6, validation in M7 |

---

## Estimated Effort

- M0: 15 min
- M1: 5 min
- M2: 5 min
- M3: 5 min
- M4: 10 min
- M5: 10 min
- M6: 20 min
- M7: 30 min (includes Docker build time)

**Total:** ~1.5-2 hours
