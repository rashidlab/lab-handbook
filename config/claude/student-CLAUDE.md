# Rashid Lab - Claude Code Configuration

This is the global Claude Code configuration for Rashid Lab members.
Copy this file to `~/.claude/CLAUDE.md` on your machine.

## Lab Organization

**Lab:** Rashid Lab, Department of Biostatistics, UNC Chapel Hill
**PI:** Naim Rashid
**GitHub Org:** https://github.com/rashidlab

### Lab Team

See `~/rashid-lab-setup/config/team.yml` for current lab members.

### Key Repositories

| Repository | Purpose |
|------------|---------|
| `rashid-lab-setup/` | Parent directory with all lab repos |
| `lab-handbook/` | Policies, onboarding, coding standards |
| `template-research-project/` | General research template |
| `template-methods-paper/` | Methods paper with simulations |
| `template-clinical-trial/` | Bayesian adaptive trial template |

## Lab Coding Standards

| Preference | Use | Avoid |
|------------|-----|-------|
| Data manipulation | Base R + `data.table` | tidyverse/dplyr |
| Dependencies | DESCRIPTION file | renv.lock |
| Pipelines | `{targets}` | Makefiles for R |
| Communication | Microsoft Teams | Slack |
| HPC | Longleaf cluster | Local for production |
| Data storage | `/proj/rashidlab/` + symlinks | Committing data to Git |

## Common Commands

### Targets Pipeline

```bash
Rscript -e "targets::tar_make()"       # Run pipeline
Rscript -e "targets::tar_outdated()"   # Check outdated
Rscript -e "targets::tar_visnetwork()" # Visualize DAG
```

### Quarto Documents

```bash
quarto preview                         # Local preview
quarto render                          # Build site/document
```

### Longleaf HPC

```bash
ssh <onyen>@longleaf.unc.edu
squeue -u $USER                        # Check queue
sbatch script.sh                       # Submit job
srun --pty -p interact -n 1 -t 60 bash # Interactive session
```

## Project Consistency

When working on research projects:

1. **Configuration source of truth:** `globals.yml`
2. **Design decisions:** `docs/plans/*.md`
3. **Results provenance:** `docs/DATA_PROVENANCE.md`
4. **Manuscript reads from code:** Never hardcode values in manuscripts

See the [Project Consistency Framework](https://rashidlab.github.io/lab-handbook/project-consistency/) for details.

## Resources

| Resource | URL |
|----------|-----|
| Lab Handbook | https://rashidlab.github.io/lab-handbook/ |
| Claude Code Guide | https://rashidlab.github.io/lab-handbook/claude-code/ |
| GitHub Org | https://github.com/rashidlab |
| Lab Meetings | https://github.com/rashidlab/lab-handbook/discussions/categories/lab-meetings |

## Getting Help

- **Claude Code issues:** See handbook troubleshooting guide
- **Lab questions:** `#general` Teams channel
- **Computing help:** `#computing` Teams channel
- **Longleaf issues:** research@unc.edu
