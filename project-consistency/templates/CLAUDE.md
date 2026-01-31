# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

[Brief description of the project - 2-3 sentences]

The repository couples [manuscript type] with [analysis type] that [brief purpose].

## Key Dependencies

| Package | Location | Purpose |
|---------|----------|---------|
| **Package1** | CRAN/GitHub | Brief purpose |
| **Package2** | Local path | Brief purpose |

```r
# Install dependencies
install.packages(c("tidyverse", "targets", "crew"))
```

## Common Commands

### Analysis

```bash
make quick                    # Run with cached results (~5 min)
make full                     # Re-run all analysis (~hours)
make test                     # Validation only
```

### Manuscript

```bash
make pdf                      # Render to PDF
make html                     # Render to HTML (quick review)
```

### Slurm (Longleaf)

```bash
make calibrate                # Full run via Slurm
TAR_WORKERS=4 make calibrate  # Specify worker count
```

## Architecture

### Directory Structure

```
├── _targets.R               # Pipeline definition
├── R/                       # Shared functions
│   ├── tar_functions.R      # Targets helpers
│   └── [module].R           # Domain-specific modules
├── config/
│   ├── globals.yml          # Centralized configuration
│   └── scenarios.csv        # Scenario specifications
├── scripts/                 # Standalone scripts
├── results/                 # Outputs (gitignored)
├── figures/                 # Generated figures
├── paper/                   # Manuscript source
└── docs/                    # Documentation
```

### Configuration Management

All parameters centralized in `config/globals.yml`:

```r
# Load configuration
source("R/globals_loader.R")
config <- load_globals()

# Access parameters
config$analysis$alpha
config$simulation$n_reps
```

### Pipeline Flow

```
config/globals.yml + config/scenarios.csv
    ↓
_targets.R (defines pipeline)
    ↓
R/tar_functions.R (execution helpers)
    ↓
results/*.csv (outputs)
    ↓
scripts/generate_figures.R
    ↓
figures/*.pdf + paper/main.qmd
```

## Coding Conventions

See `CODING_STANDARDS.md` for complete details. Key points:

- **Style**: Tidyverse R, two-space indents, `snake_case`
- **Parameter naming**: Use canonical names from standards doc
- **Config access**: Always use loader functions
- **Seeds**: Record seeds inline for reproducibility

### Null-Coalescing Pattern

Scripts that may run standalone must define:
```r
if (!exists("%||%", mode = "function")) {
  `%||%` <- function(x, y) if (is.null(x)) y else x
}
```

## Manuscript Standards

### No Hardcoded Values

All numerical results must be computed dynamically:
```r
# In setup chunk
results <- read_csv("../results/analysis_summary.csv")

# In text - use inline R
The analysis achieved `r fmt(results$metric, 2)`.
```

### Figure Standards

- **Dual output required**: PDF (vector) + PNG (300 DPI)
- **Naming**: `fig<N>_<description>.pdf` for main figures

```r
ggsave("figures/fig_name.pdf", plot, width = 7, height = 5)
ggsave("figures/fig_name.png", plot, width = 7, height = 5, dpi = 300)
```

## Documentation Index

| Document | Purpose |
|----------|---------|
| `CODING_STANDARDS.md` | Parameter naming, testing |
| `AGENTS.md` | Commit guidelines, PR requirements |
| `docs/QUICK_START.md` | Getting started |

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `N_REPS` | 1000 | Simulation replications |
| `TAR_WORKERS` | 4 | Parallel workers |
| `QUICK_MODE` | 0 | Enable quick mode |
