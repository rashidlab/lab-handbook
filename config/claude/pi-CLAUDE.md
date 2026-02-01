# Rashid Lab - Claude Code Configuration (PI)

This is the global Claude Code configuration for the PI.
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
| `lab-admin/` | Private - student tracking, milestones |
| `template-research-project/` | General research template |
| `template-methods-paper/` | Methods paper with simulations |
| `template-clinical-trial/` | Bayesian adaptive trial template |

### Reference Implementation

See `~/Downloads/adaptive-trial-bo-paper/` for a complete example of:
- Comprehensive CLAUDE.md with project context
- Custom `/review` command and reviewer agent
- Review checklist with known issue patterns
- Targets pipeline with Slurm integration

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

---

## Admin (PI Only)

### Student Management

See `~/rashid-lab-setup/lab-admin/` for:

| Directory | Contents |
|-----------|----------|
| `1on1-meetings/` | Individual meeting notes by student |
| `milestones/` | PhD milestone tracking |
| `progress-logs/` | Automated activity logs |
| `grants/` | Grant documentation |
| `config/students.yml` | Full student data (source of truth) |

### Admin Commands

```bash
cd ~/rashid-lab-setup/lab-admin
make sync-students    # Propagate student config to all repos
make prep-1on1        # Generate 1:1 prep reports
```

### Team Account Management

**Claude for Teams Dashboard:** https://claude.ai/team

- Add/remove team members via dashboard
- Monitor usage and costs
- Set organization policies

### Onboarding New Students

1. Add to `lab-admin/config/students.yml`
2. Run `make sync-students`
3. Invite to Claude for Teams via dashboard
4. Share `config/claude/student-CLAUDE.md` template
5. Point to handbook Claude Code chapter
