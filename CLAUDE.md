# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Rashid Lab Handbook** - a Quarto-based documentation website for the Rashid Lab at UNC Chapel Hill, Department of Biostatistics. It contains lab policies, coding standards, onboarding guides, project templates, and meeting documentation.

**Live site:** https://rashidlab.github.io/lab-handbook/

## Key Conventions

### Technology Stack

| Tool | Purpose |
|------|---------|
| **Quarto** | Static site generator (`.qmd` files) |
| **GitHub Pages** | Hosting via `.github/workflows/` |
| **GitHub Discussions** | Meeting agendas and notes |
| **Microsoft Teams** | Lab communication (NOT Slack) |

### Coding Standards (Lab-Wide)

The lab uses specific conventions - be aware when writing examples:

| Preference | Use | Avoid |
|------------|-----|-------|
| **Data manipulation** | Base R + `data.table` | tidyverse/dplyr |
| **Dependencies** | DESCRIPTION file | renv.lock |
| **Communication** | Microsoft Teams | Slack |
| **HPC** | Longleaf (UNC cluster) | Local for production |

## Common Commands

### Render the Site

```bash
# Preview locally
quarto preview

# Render full site
quarto render

# Render single page
quarto render onboarding/github-fundamentals.qmd
```

### Deploy

Deployment is automatic via GitHub Actions on push to `main`. Manual deploy:

```bash
quarto publish gh-pages
```

## Directory Structure

```
lab-handbook/
├── _quarto.yml              # Site configuration
├── index.qmd                # Home page (quick access cards)
├── handbook.qmd             # Handbook landing page (all sections overview)
├── onboarding/              # Getting started guides
│   ├── index.qmd            # Welcome page
│   ├── first-week.qmd       # First week checklist
│   ├── tools-setup.qmd      # Environment setup (Longleaf, R, Git)
│   ├── github-fundamentals.qmd  # GitHub basics for beginners
│   └── first-project.qmd    # Starting your first project
├── coding-standards/        # Code style and practices
│   ├── index.qmd            # Overview
│   ├── r-style.qmd          # R conventions (base R + data.table)
│   ├── python-style.qmd     # Python conventions
│   ├── git-practices.qmd    # Git workflow, Issues, PRs
│   └── targets-pipeline.qmd # {targets} for reproducible pipelines
├── policies/                # Lab policies
│   ├── index.qmd            # Communication, data, publications
│   ├── meetings.qmd         # Lab meetings guide (comprehensive)
│   └── schedule.qmd         # Meeting rotation
├── templates/               # Project templates
│   ├── index.qmd            # Template overview
│   ├── research-project.qmd # General research project
│   ├── methods-paper.qmd    # Methods paper repo structure
│   └── package-development.qmd  # R package development
├── project-consistency/     # Reproducibility framework
│   ├── index.qmd            # Overview
│   ├── config-values.qmd    # Configuration management
│   ├── method-claims.qmd    # Claims registry
│   ├── data-provenance.qmd  # Data tracking
│   └── validation.qmd       # Validation checks
├── computing/               # HPC and computing guides
│   └── index.qmd            # Longleaf, Slurm, environments
├── meeting-notes/           # Committed meeting notes
│   ├── README.md            # Quick reference for students
│   ├── TEMPLATE.md          # Meeting notes template
│   └── 2026/                # Notes by year
├── .github/
│   ├── workflows/           # GitHub Actions
│   │   ├── publish.yml      # Deploy to GitHub Pages
│   │   ├── meeting-reminder-lead.yml      # Wed reminder to lead
│   │   ├── meeting-reminder-contribute.yml # Thu reminder to all
│   │   └── action-items-reminder.yml      # Mon action items
│   └── meeting-rotation.yml # Meeting schedule config
└── assets/                  # CSS and styling
    ├── custom.scss
    └── custom.css
```

## Key Pages

### For New Lab Members

| Page | Purpose |
|------|---------|
| `onboarding/github-fundamentals.qmd` | GitHub basics (Issues, PRs, Discussions, Branches) |
| `onboarding/tools-setup.qmd` | Environment setup (Longleaf, VS Code, R) |
| `policies/meetings.qmd` | How lab meetings work |

### For Meeting Leads

| Page | Purpose |
|------|---------|
| `policies/meetings.qmd#leader-walkthrough` | Step-by-step guide for discussion leaders |
| `meeting-notes/README.md` | Quick reference with checklists |
| `meeting-notes/TEMPLATE.md` | Template for committed notes |

### For Code Review

| Page | Purpose |
|------|---------|
| `coding-standards/git-practices.qmd` | Issues vs PRs, review guidelines |
| `coding-standards/r-style.qmd` | R code conventions |

## GitHub Integration

### Discussions

Lab meetings use GitHub Discussions:
- **Category:** Lab Meetings
- **Thread format:** `Lab Meeting - YYYY-MM-DD`
- **Workflow:** Agenda (Tue) → Contributions (Wed) → Meeting (Thu 9:30-11am) → Notes (Thu EOD)

### Automated Reminders

GitHub Actions send Teams notifications:

| Workflow | Schedule | Purpose |
|----------|----------|---------|
| `meeting-reminder-lead.yml` | Tue 9am ET | Remind lead to create agenda |
| `meeting-reminder-contribute.yml` | Wed 9am ET | Remind all to add items |
| `action-items-reminder.yml` | Mon 9am ET | Weekly action item check |

**Required secret:** `MS_TEAMS_WEBHOOK_URI` (Teams incoming webhook URL)

### Meeting Rotation Config

`.github/meeting-rotation.yml` contains:
- Lab member list (name, GitHub username, email)
- Upcoming meeting schedule (date, lead, presenters)
- Skip dates (holidays, breaks)

## Editing Guidelines

### Adding New Pages

1. Create `.qmd` file in appropriate directory
2. Add YAML frontmatter:
   ```yaml
   ---
   title: "Page Title"
   subtitle: "Optional subtitle"
   ---
   ```
3. Add to `_quarto.yml` sidebar section
4. Render and test locally: `quarto preview`

### Code Blocks

Use non-executable code blocks (no `{r}` or `{python}`):

```markdown
```r
# This won't execute - just displays code
x <- data.table::fread("data.csv")
```
```

### Cross-References

Link to other pages:
```markdown
See [GitHub Fundamentals](../onboarding/github-fundamentals.qmd)
```

Link to sections:
```markdown
See the [Leader Walkthrough](meetings.qmd#leader-walkthrough)
```

## Setup Issues

If setting up fresh, these GitHub Issues track required tasks:

| Issue | Task |
|-------|------|
| #1 | Create Teams incoming webhook |
| #2 | Add webhook to GitHub Secrets |
| #3 | Update meeting rotation config |
| #4 | Create Discussion categories |
| #5-8 | Student setup tasks |

View all: https://github.com/rashidlab/lab-handbook/issues

## Important Links

| Resource | URL |
|----------|-----|
| Live site | https://rashidlab.github.io/lab-handbook/ |
| Repository | https://github.com/rashidlab/lab-handbook |
| Discussions | https://github.com/rashidlab/lab-handbook/discussions |
| Lab Meetings | https://github.com/rashidlab/lab-handbook/discussions/categories/lab-meetings |
| GitHub Org | https://github.com/rashidlab |
