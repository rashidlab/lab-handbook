# Project Consistency Framework

A systematic approach to ensuring code, documentation, and manuscripts stay synchronized in research projects.

## Why This Matters

In research software development, inconsistencies between code and written artifacts are common:
- Manuscript says "Sobol sampling" but code uses LHS
- Documentation claims threshold is 50% but config says 30%
- Figures claim to show data from file X but actually read from file Y

These inconsistencies undermine reproducibility and can lead to incorrect conclusions being published.

## The Solution: Consistency Registry

Instead of hoping things stay in sync, we **explicitly declare dependencies** between artifacts and **automatically validate** them.

### Core Concept

A YAML registry file maps claims in manuscripts/docs to their authoritative sources:

```yaml
# config/consistency_registry.yml
config_values:
  - id: convergence_threshold
    description: "BO convergence improvement threshold"
    manuscript_locations:
      - file: paper/main.qmd
        pattern: '(\d+)% improvement threshold'
    source:
      file: config/globals.yml
      path: bo.convergence_threshold
      transform: "x * 100"  # 0.05 → 5
```

A validation script checks that all claims match their sources.

## Quick Start

### 1. Copy Template Files

```bash
cp -r /path/to/lab-setup/lab-handbook/project-consistency/templates/* your-project/
```

This gives you:
- `config/consistency_registry.yml` - Registry template
- `scripts/validate_consistency.R` - Validation script
- Makefile snippets

### 2. Add Your First Claim

Edit `config/consistency_registry.yml`:

```yaml
config_values:
  - id: my_threshold
    description: "Description of what this value represents"
    manuscript_locations:
      - file: paper/main.tex
        pattern: 'threshold of (\d+\.?\d*)%'
    source:
      file: config/settings.yml
      path: analysis.threshold
      transform: "x * 100"
```

### 3. Run Validation

```bash
make validate-consistency
# or
Rscript scripts/validate_consistency.R
```

### 4. Integrate with Workflow

Add to your Makefile:

```makefile
pdf: validate-quick
	# your render command

pre-submit: validate-consistency
	@echo "Ready for submission"
```

## Registry Types

### Type 1: Config Values

Numeric values appearing in multiple places:

```yaml
config_values:
  - id: alpha_level
    description: "Significance level for hypothesis tests"
    manuscript_locations:
      - file: paper/methods.qmd
        pattern: 'significance level.{0,20}(\d+\.?\d*)%'
      - file: README.md
        pattern: 'alpha = (\d+\.?\d*)'
    source:
      file: config/analysis.yml
      path: hypothesis_testing.alpha
      transform: "x * 100"  # 0.05 → 5
    code_defaults:
      - file: R/analysis.R
        function: run_test
        param: alpha
```

### Type 2: Method Claims

Verify manuscript descriptions match code:

```yaml
method_claims:
  - id: sampling_method
    description: "Experimental design sampling approach"
    manuscript_locations:
      - file: paper/methods.qmd
        pattern: '(Latin hypercube|LHS|random|grid)'
        expected: "Latin hypercube"
    verification:
      type: code_grep
      file: R/design.R
      pattern: "lhs::|randomLHS|maximinLHS"
```

### Type 3: Results Provenance

Verify figures/tables use claimed data:

```yaml
results_provenance:
  - id: figure_1
    description: "Main results figure"
    manuscript_location:
      file: paper/results.qmd
      label: "fig-main-results"
    data_source:
      file: results/main_analysis.csv
      required_columns: [group, estimate, ci_lower, ci_upper]
    generation_script: scripts/generate_figures.R
```

## Validation Modes

### Quick Mode (During Development)

Checks config values only (~2 seconds):

```bash
make validate-quick
# Runs: Rscript scripts/validate_consistency.R --quick
```

Integrate with your build:
```makefile
pdf: validate-quick
	quarto render paper/main.qmd
```

### Full Mode (Before Submission)

Checks everything (~10-30 seconds):

```bash
make validate-consistency
# Runs: Rscript scripts/validate_consistency.R --full
```

### Pre-Submission Checklist

```bash
make pre-submit
```

Runs:
1. Full consistency validation
2. Format validation (JASA, etc.)
3. Reproducibility checks
4. Git status check (no uncommitted changes)

## Error Messages

The validator produces clear, actionable errors:

```
CONSISTENCY ERROR: alpha_level mismatch

  Manuscript (paper/methods.qmd:42):
    "significance level of 10%"

  Config (config/analysis.yml → hypothesis_testing.alpha):
    0.05 (= 5%)

  Code default (R/analysis.R::run_test → alpha):
    0.05

  Action: Update manuscript to say "5%" or change config to 0.10
```

## Best Practices

### 1. Add Claims Incrementally

Don't try to catalog everything at once. Add claims as you:
- Write new manuscript sections
- Add new configuration values
- Notice inconsistencies

### 2. Use Transforms Consistently

Common transforms:
- `"x * 100"` - Proportion to percentage
- `"x * 1000"` - To per-thousand
- `"round(x, 2)"` - Rounding for display

### 3. Keep Patterns Simple

Regex patterns should be:
- Specific enough to avoid false matches
- General enough to survive minor rewording

```yaml
# Good - captures the number regardless of exact wording
pattern: 'threshold.{0,30}(\d+\.?\d*)%'

# Bad - too specific, breaks if wording changes
pattern: 'we used a threshold of exactly (\d+)%'
```

### 4. Document Expected Values

For method claims, always specify what you expect:

```yaml
method_claims:
  - id: kernel_type
    manuscript_locations:
      - file: paper/methods.qmd
        pattern: '(Matérn|RBF|squared.exponential)'
        expected: "Matérn"  # Document what should be found
```

## Files Reference

| File | Purpose |
|------|---------|
| `config/consistency_registry.yml` | Claim definitions |
| `scripts/validate_consistency.R` | Validation logic |
| `Makefile` | Integration targets |

## Template Files

All templates are in `templates/` directory:

### Documentation Templates

| Template | Purpose |
|----------|---------|
| `CLAUDE.md` | Project guidance for Claude Code |
| `DEFAULTS.md` | Parameter defaults registry |
| `CONSISTENCY_STANDARDS.md` | Alignment rules and checklists |
| `docs/DATA_PROVENANCE.md` | Figure/table traceability |

### Configuration Templates

| Template | Purpose |
|----------|---------|
| `config/globals.yml` | Centralized project configuration |
| `config/consistency_registry.yml` | Manuscript claim registry |
| `R/globals_loader.R` | Config loader with caching |

### Validation Templates

| Template | Purpose |
|----------|---------|
| `scripts/validate_consistency.R` | Consistency validation script |
| `Makefile.snippet` | Make target integration |

### Mode Switching (from DeSurv-paper)

| Template | Purpose |
|----------|---------|
| `local_config/setup.sh` | Quick/full mode switching |
| `local_config/quick/` | Development settings |
| `local_config/full/` | Production settings |

## Copying Templates to New Project

```bash
# Copy all templates
cp -r lab-handbook/project-consistency/templates/* my-project/

# Or copy specific files
cp lab-handbook/project-consistency/templates/CLAUDE.md my-project/
cp lab-handbook/project-consistency/templates/config/globals.yml my-project/config/
cp -r lab-handbook/project-consistency/templates/R/ my-project/R/
```

## Related Documentation

- [Coding Standards](../coding-standards/README.md) - General code quality
- [Targets Pipeline Guide](../coding-standards/targets-pipeline.md) - Workflow automation
- [renv Setup](../../lab-computing/environments/renv-setup.md) - R environment management
