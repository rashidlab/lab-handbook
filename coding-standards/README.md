# Coding Standards

## General Principles

1. **Reproducibility first**: Anyone should be able to run your code and get the same results
2. **Document as you go**: Comments, README files, and docstrings
3. **Version control everything**: Frequent, meaningful commits
4. **Never hardcode paths**: Use `here::here()` in R, `pathlib` in Python

## R Style Guide

Follow the [Tidyverse Style Guide](https://style.tidyverse.org/) with these specifics:

### Naming
```r
# Variables: snake_case
patient_data <- read_csv(...)
mean_survival_time <- mean(data$time)

# Functions: snake_case verbs
calculate_hazard_ratio <- function(data, ...) { }
fit_cox_model <- function(...) { }

# Constants: SCREAMING_SNAKE_CASE
MAX_ITERATIONS <- 1000
DEFAULT_ALPHA <- 0.05
```

### File Organization
```r
# Top of script
# =============================================================================
# Project: [Name]
# Script: 01-data-prep.R
# Author: [Name]
# Date: [Date]
# Description: [What this script does]
# =============================================================================

# Load packages (alphabetical)
library(data.table)
library(here)
library(tidyverse)

# Source functions
source(here("R/functions.R"))

# Load configuration
config <- yaml::read_yaml(here("config/config.yml"))

# Set seed
set.seed(config$seed)
```

### Functions
```r
#' Calculate hazard ratio with confidence interval
#'
#' @param data A data frame with time, status, treatment columns
#' @param alpha Significance level (default 0.05)
#' @return A tibble with hr, lower, upper columns
#' @examples
#' calculate_hr(survival_data)
calculate_hr <- function(data, alpha = 0.05) {
  # Validate inputs
  stopifnot(
    is.data.frame(data),
    all(c("time", "status", "treatment") %in% names(data))
  )
  
  # Fit model
  fit <- coxph(Surv(time, status) ~ treatment, data = data)
  
  # Extract results
  tibble(
    hr = exp(coef(fit)),
    lower = exp(confint(fit, level = 1 - alpha)[1]),
    upper = exp(confint(fit, level = 1 - alpha)[2])
  )
}
```

## Python Style Guide

Follow [PEP 8](https://pep8.org/) with these specifics:

### Naming
```python
# Variables: snake_case
patient_data = pd.read_csv(...)
mean_survival = data["time"].mean()

# Functions: snake_case
def calculate_hazard_ratio(data: pd.DataFrame) -> dict:
    pass

# Classes: PascalCase
class SurvivalModel:
    pass

# Constants: SCREAMING_SNAKE_CASE
MAX_ITERATIONS = 1000
DEFAULT_ALPHA = 0.05
```

### Type Hints
```python
from typing import Optional, List, Dict
import pandas as pd
import numpy as np

def fit_model(
    data: pd.DataFrame,
    features: List[str],
    target: str,
    alpha: float = 0.05,
    seed: Optional[int] = None
) -> Dict[str, np.ndarray]:
    """
    Fit a survival model.
    
    Args:
        data: Input dataframe with features and target
        features: List of feature column names
        target: Target column name
        alpha: Significance level
        seed: Random seed for reproducibility
        
    Returns:
        Dictionary with 'coefficients' and 'se' arrays
    """
    pass
```

## Git Practices

### Commit Messages
```
# Format: <type>: <description>

feat: add Cox model with time-varying covariates
fix: correct SE calculation in bootstrap
docs: update README with usage examples
refactor: simplify data loading function
test: add unit tests for hazard ratio calculation
data: update simulation parameters for scenario 3
```

### Branch Strategy
```bash
# Main branch is always stable
# Feature branches for development
git checkout -b feature/add-competing-risks
git checkout -b fix/convergence-issue
git checkout -b analysis/sensitivity-analysis
```

### .gitignore Essentials
```
# Data (never commit)
data/
*.csv
*.rds
*.RData

# Outputs (regenerable)
output/
figures/exploratory/

# Environment
.Rproj.user
renv/library/
.venv/
__pycache__/

# Credentials
.env
*.pem
```

## Project Structure

```
project/
├── README.md           # Project overview, setup, usage
├── config/
│   └── config.yml      # Parameters, seeds, paths
├── R/ or python/       # Source code (reusable functions)
├── analysis/           # Analysis scripts (numbered: 01-, 02-)
├── data/               # Data (gitignored)
│   ├── raw/           # Original data (never modify)
│   └── processed/     # Cleaned data
├── output/             # Generated results
├── figures/            # Plots
│   ├── exploratory/   # Working figures (gitignored)
│   └── publication/   # Final figures (tracked)
├── reports/            # Written reports, manuscripts
├── tests/              # Unit tests
├── renv.lock           # R dependencies
└── requirements.txt    # Python dependencies
```

## Documentation Requirements

### README.md (every project)
- Project description
- Directory structure
- Setup instructions
- How to run
- Data sources
- Contact info

### Code Comments
- Explain *why*, not *what*
- Document assumptions
- Note sources for formulas
- Mark TODOs clearly

### Function Documentation
- All exported functions must have docstrings
- Include parameter types and descriptions
- Provide examples where helpful
