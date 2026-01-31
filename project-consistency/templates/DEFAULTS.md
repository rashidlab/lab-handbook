# Parameter Defaults Registry

**Single source of truth for all configurable parameters.**

When changing defaults, update BOTH the code AND this file. This ensures consistency between implementation and documentation.

Last updated: YYYY-MM-DD

---

## Analysis Parameters

| Parameter | Default Value | Type | Description |
|-----------|---------------|------|-------------|
| `seed` | 2024 | integer | Base random seed for reproducibility |
| `alpha` | 0.05 | numeric | Significance level for hypothesis tests |
| `n_bootstrap` | 1000 | integer | Bootstrap resamples for CI estimation |

## Simulation Parameters

| Parameter | Default Value | Type | Description |
|-----------|---------------|------|-------------|
| `n_sims` | 1000 | integer | Number of simulation replications |
| `n_scenarios` | varies | integer | Number of scenarios to evaluate |

## Model Parameters

| Parameter | Default Value | Type | Description |
|-----------|---------------|------|-------------|
| `max_iter` | 1000 | integer | Maximum optimization iterations |
| `tol` | 1e-6 | numeric | Convergence tolerance |

## Bayesian Optimization Parameters

| Parameter | Quick | Full | Description |
|-----------|-------|------|-------------|
| `bo_n_init` | 10 | 50 | Initial random samples |
| `bo_n_iter` | 20 | 100 | BO iterations after init |
| `bo_candidate_pool` | 500 | 4000 | Candidate points per iteration |

## Computing Resources

| Parameter | Value | Description |
|-----------|-------|-------------|
| `n_cores_default` | 4 | Default parallel workers |
| `n_cores_memory_intensive` | 2 | Workers for heavy tasks |
| `memory_per_core_gb` | 4 | Memory allocation per worker |
| `slurm_partition` | "general" | Default Slurm partition |
| `slurm_time_hours` | 24 | Default walltime |

## File Paths

| Path | Purpose |
|------|---------|
| `data/raw/` | Original input data (never modify) |
| `data/processed/` | Cleaned/transformed data |
| `results/` | Analysis outputs |
| `figures/` | Generated plots |
| `logs/` | Slurm and execution logs |

---

## How to Use This File

1. **When adding a new parameter:**
   - Add it to the appropriate section above
   - Update the R code to use the same default
   - Update any documentation that mentions the parameter

2. **When changing a default:**
   - Update this file FIRST
   - Update the R code to match
   - Run `make validate-consistency` to verify alignment
   - Document the change in CHANGELOG.md

3. **Validation:**
   ```bash
   # Check that code defaults match this file
   Rscript scripts/validate_consistency.R --check-defaults
   ```

---

## Version History

| Date | Parameter | Old Value | New Value | Reason |
|------|-----------|-----------|-----------|--------|
| YYYY-MM-DD | example | 100 | 200 | Improved convergence |
