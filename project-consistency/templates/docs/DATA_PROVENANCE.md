# Data Provenance

Complete traceability from every figure and table back to source data, scripts, and configuration.

---

## How to Use This Document

1. **Before modifying a figure/table**: Find its entry below to understand the full dependency chain
2. **After creating new outputs**: Add an entry following the template
3. **During code review**: Verify claimed provenance matches actual code

---

## Figure Provenance

### Figure 1: [Description]

| Attribute | Value |
|-----------|-------|
| **Output File** | `figures/fig1_description.pdf` |
| **Generating Script** | `scripts/generate_fig1.R` |
| **Data Source(s)** | `results/analysis_summary.csv` |
| **Upstream Script** | `scripts/run_analysis.R` |
| **Configuration** | `config/globals.yml` → `analysis.*` |
| **Key Parameters** | `alpha = 0.05`, `n_bootstrap = 1000` |
| **Last Validated** | YYYY-MM-DD |

**Regeneration Command:**
```bash
Rscript scripts/generate_fig1.R
```

---

### Figure 2: [Description]

| Attribute | Value |
|-----------|-------|
| **Output File** | `figures/fig2_description.pdf` |
| **Generating Script** | `scripts/generate_fig2.R` |
| **Data Source(s)** | `results/simulation_results.csv` |
| **Upstream Script** | `Rscript -e "targets::tar_make(sim_results)"` |
| **Configuration** | `config/scenarios.csv` |
| **Key Parameters** | Scenarios 1-10 |
| **Last Validated** | YYYY-MM-DD |

---

## Table Provenance

### Table 1: [Description]

| Attribute | Value |
|-----------|-------|
| **Manuscript Location** | `paper/main.qmd` line ~XXX |
| **Generating Code** | Inline R in manuscript |
| **Data Source** | `results/summary_statistics.csv` |
| **Key Columns** | `metric`, `estimate`, `ci_lower`, `ci_upper` |

**Inline Code:**
```r
results <- read_csv("../results/summary_statistics.csv")
kable(results %>% select(metric, estimate, ci_lower, ci_upper))
```

---

## Inline Claims Provenance

### Claim: "[Specific quantitative claim from manuscript]"

| Attribute | Value |
|-----------|-------|
| **Manuscript Location** | `paper/results.qmd` line ~XXX |
| **Code** | `` `r round(results$metric, 2)` `` |
| **Data Source** | `results/analysis_summary.csv` |
| **Column** | `metric` |
| **Expected Range** | 0.8 - 0.95 |

---

## Dependency Graph

```
config/globals.yml ─────────────────────────────┐
                                                │
config/scenarios.csv ──┐                        │
                       ↓                        ↓
              _targets.R (pipeline definition)
                       │
                       ↓
              tar_make() execution
                       │
         ┌─────────────┼─────────────┐
         ↓             ↓             ↓
    sim_results   analysis_results  validation
         │             │             │
         ↓             ↓             ↓
results/sim.csv  results/analysis.csv  results/validation.csv
         │             │             │
         └─────────────┼─────────────┘
                       ↓
            scripts/generate_figures.R
                       │
                       ↓
            figures/*.pdf, figures/*.png
                       │
                       ↓
            paper/main.qmd (tar_read + inline R)
                       │
                       ↓
            paper/main.pdf
```

---

## Validation Checklist

Before submission, verify:

- [ ] All figures listed in this document
- [ ] All tables listed in this document
- [ ] All inline quantitative claims listed
- [ ] Regeneration commands work
- [ ] Data sources exist and have expected columns
- [ ] Last validated dates are recent

**Validation Command:**
```bash
Rscript scripts/validate_provenance.R
```

---

## Template for New Entries

Copy and fill in:

```markdown
### [Figure/Table N]: [Description]

| Attribute | Value |
|-----------|-------|
| **Output File** | `path/to/output` |
| **Generating Script** | `scripts/generate_X.R` |
| **Data Source(s)** | `results/source.csv` |
| **Upstream Script** | `scripts/run_X.R` or `tar_make(target)` |
| **Configuration** | `config/file.yml` → `section.*` |
| **Key Parameters** | param1 = value, param2 = value |
| **Last Validated** | YYYY-MM-DD |

**Regeneration Command:**
\```bash
command to regenerate
\```
```
