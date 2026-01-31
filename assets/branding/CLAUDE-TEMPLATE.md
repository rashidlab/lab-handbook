# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Repository Overview

[Brief description of what this project does, its purpose, and key goals]

## Key Dependencies

| Package | Location/Version | Purpose |
|---------|------------------|---------|
| **BATON** | `~/Downloads/BATON` | Bayesian optimization for adaptive trials |
| **evolveTrial** | `~/Downloads/evolveTrial` | Adaptive trial simulations |
| **tidyverse** | CRAN ≥2.0 | Data manipulation |
| **Quarto** | System ≥1.4 | Document rendering |

```r
# Install local packages
devtools::install("~/Downloads/BATON")
devtools::install("~/Downloads/evolveTrial")
```

## Common Commands

### Build/Render

```bash
make pdf          # Render to PDF
make html         # Render to HTML
make quick        # Quick build with caching
```

### Testing

```bash
make test         # Run all validation tests
Rscript tests/run_tests.R  # R tests only
```

### Simulations

```bash
# Run production scenarios
Rscript scripts/run_scenarios.R scenarios/production.csv

# Dry run to validate
Rscript scripts/run_scenarios.R scenarios/production.csv --dry-run
```

### Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `BO_BUDGET` | 120 | Total evaluation budget |
| `QUICK_MODE` | 0 | Enable quick mode (1=on) |

## Architecture

### Directory Structure

```
├── R/              # Shared R functions and utilities
├── scripts/        # Executable scripts
├── manuscript/     # Quarto manuscript source
├── scenarios/      # CSV scenario specifications
├── results/        # Output files (gitignored)
├── figures/        # Generated figures
├── docs/           # Documentation
└── tests/          # Validation tests
```

### Key Files

| File | Purpose |
|------|---------|
| `_targets.R` | Pipeline definition |
| `globals.yml` | Central configuration |
| `R/utils.R` | Shared utility functions |
| `CODING_STANDARDS.md` | Style guide |

## Coding Conventions

### R Style

- Tidyverse style guide
- Two-space indentation
- `snake_case` for functions and variables
- `library()` calls at top of scripts
- Explicit `return()` statements

### Parameter Naming

| Concept | Correct | Incorrect |
|---------|---------|-----------|
| Maximum sample size | `total_n` | `nmax`, `N` |
| Type I error | `type1` | `alpha` |
| Type II error | `type2` | `beta` |
| Power | `power` | `1-beta` |

### Commits

- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Reference issues: `fixes #123`
- Atomic commits (one logical change)

### Seeds

Always record seeds for reproducibility:

```r
set.seed(2025)  # Seed for [purpose]
```

## Testing & Validation

- Use deterministic seeds
- Validate both `fidelity = "low"` and `"high"` paths
- Check plausible ranges (power 0.70-0.95, type I 0.01-0.15)

## Documentation Index

| Document | Purpose |
|----------|---------|
| `docs/QUICK_START.md` | Getting started guide |
| `CODING_STANDARDS.md` | Full style guide |
| `CHANGELOG.md` | Version history |
| `AGENTS.md` | CI/CD and automation |
