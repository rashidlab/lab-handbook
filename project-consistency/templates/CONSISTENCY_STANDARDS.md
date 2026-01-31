# Consistency Standards

Rules and procedures for maintaining alignment between code, configuration, documentation, and manuscripts.

---

## 1. Configuration Consistency

### Rule
Every configurable parameter must have a **single source of truth**.

### Implementation
- All defaults defined in `DEFAULTS.md`
- R functions use `config$param` or fall back to documented default
- Config files inherit from defaults, only override what changes

### Verification
```bash
# Check config files reference valid parameters
Rscript scripts/validate_consistency.R --check-configs
```

---

## 2. Function Defaults Consistency

### Rule
Function parameter defaults must match `DEFAULTS.md`.

### Implementation
```r
# Good: Default matches DEFAULTS.md (alpha = 0.05)
run_analysis <- function(data, alpha = 0.05) { ... }

# Bad: Different default than documented
run_analysis <- function(data, alpha = 0.10) { ... }
```

### Verification
```bash
# Extract function defaults and compare to DEFAULTS.md
Rscript scripts/validate_consistency.R --check-function-defaults
```

---

## 3. Paper-Code Consistency

### Rule
Every quantitative claim in the paper must trace to a specific target or result file.

### Implementation

**Figure-Target Mapping** (document in paper's YAML or comments):
```yaml
# Paper front matter or separate mapping file
figure_sources:
  fig1: tar_read(fig_main_results)
  fig2: tar_read(fig_simulation_comparison)
  table1: tar_read(summary_statistics)
```

**Inline Claims** (use dynamic values):
```r
# In Rmd/Qmd
We observed a hazard ratio of `r round(results$hr, 2)` (95% CI: `r round(results$ci_lower, 2)`-`r round(results$ci_upper, 2)`).
```

### Verification
```bash
# Check all figures have valid target sources
Rscript scripts/validate_consistency.R --check-paper-targets
```

---

## 4. Store Consistency

### Rule
All pipeline components must reference the same targets store.

### Implementation
- Define store path in ONE location (e.g., `_targets.yaml` or environment variable)
- All scripts read from that location
- Never hardcode store paths in multiple files

```yaml
# _targets.yaml (single source)
main:
  store: _targets_store
```

```r
# In R scripts
store_path <- Sys.getenv("TAR_STORE", "_targets_store")
tar_config_set(store = store_path)
```

### Verification
```bash
# Find all store path references, verify consistency
grep -r "store" . --include="*.R" --include="*.yaml" --include="*.sh" | grep -v "^Binary"
```

---

## 5. Mode Switching (Quick vs Full)

### Rule
Development (quick) and production (full) modes must be switchable WITHOUT modifying tracked files.

### Implementation
Use symlink-based mode switching:

```bash
# Directory structure
local_config/
├── quick/
│   └── settings.yml    # Fast settings for testing
├── full/
│   └── settings.yml    # Production settings
└── setup.sh            # Mode switching script
```

```bash
# Usage
./local_config/setup.sh --quick   # Switch to quick mode
./local_config/setup.sh --full    # Switch to full mode
./local_config/setup.sh --status  # Check current mode
```

### Verification
```bash
# Check current mode
cat .current_mode
```

---

## 6. Change Documentation

### Rule
All significant changes must be documented in CHANGELOG.md.

### Format
```markdown
## [YYYY-MM-DD] - Brief Description

### Added
- New feature X

### Changed
- Modified parameter Y from A to B

### Fixed
- Bug in function Z
```

### Commit Message Convention
```
<type>: <description>

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- refactor: Code restructuring
- test: Test additions
- config: Configuration changes
- data: Data updates
```

---

## 7. File Modification Triggers

### Rule
When modifying certain files, related files must also be updated.

| If you modify... | Also update... |
|------------------|----------------|
| Function defaults | `DEFAULTS.md` |
| Config structure | `consistency_registry.yml` |
| Figure generation | Paper figure references |
| Analysis method | Methods section of paper |
| Package dependencies | `DESCRIPTION` / `requirements.txt` |

---

## 8. Pre-Commit Checklist

Run before every commit:

```bash
# 1. R syntax check
Rscript -e 'lapply(list.files("R", pattern="\\.R$", full.names=TRUE), parse)'

# 2. No debug statements
! grep -r "browser()" R/ --include="*.R" || echo "Remove browser() statements"

# 3. Config validation
Rscript scripts/validate_consistency.R --quick

# 4. Targets validation
Rscript -e 'targets::tar_validate()'
```

---

## 9. Pre-Submission Checklist

Run before paper submission:

```bash
# 1. Full consistency validation
Rscript scripts/validate_consistency.R --full

# 2. All targets up to date
Rscript -e 'targets::tar_outdated()' | grep -q "NULL" || echo "Outdated targets exist"

# 3. Paper renders without errors
Rscript -e 'rmarkdown::render("paper/main.Rmd", run_pandoc=FALSE)'

# 4. All tests pass
Rscript -e 'testthat::test_dir("tests/testthat")'

# 5. No uncommitted changes
git status --porcelain | grep -q . && echo "Uncommitted changes exist"

# 6. CHANGELOG updated
head -20 CHANGELOG.md
```

---

## 10. Automated Verification

### Daily/CI Checks
```yaml
# .github/workflows/consistency.yml
name: Consistency Check
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: r-lib/actions/setup-r@v2
      - run: Rscript scripts/validate_consistency.R --quick
```

### Local Git Hook
```bash
# .git/hooks/pre-commit
#!/bin/bash
Rscript scripts/validate_consistency.R --quick
if [ $? -ne 0 ]; then
  echo "Consistency check failed. Fix issues before committing."
  exit 1
fi
```

---

## Summary

| Standard | Frequency | Command |
|----------|-----------|---------|
| Config consistency | Every commit | `--check-configs` |
| Function defaults | Every commit | `--check-function-defaults` |
| Paper-code alignment | Before paper edits | `--check-paper-targets` |
| Store consistency | After store changes | `grep -r "store"` |
| Full validation | Before submission | `--full` |
