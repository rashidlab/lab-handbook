# Claude Code CLI Lab Guide - Design Document

**Date:** 2026-02-01
**Author:** Naim Rashid (with Claude)
**Status:** Ready for Implementation

## Overview

This document defines the design for a comprehensive Claude Code CLI guide integrated into the Rashid Lab handbook. The goal is to enable 5 PhD students to use Claude Code effectively while reinforcing existing lab practices (git, targets, branding, consistency framework).

## Goals

1. **Accelerate research output** — Students use Claude to write code faster, debug quicker
2. **Improve code quality** — Claude enforces lab standards, reviews code
3. **Teaching tool** — Students learn by asking Claude to explain code and methods
4. **Integrate with existing practices** — Reinforce git/targets/branding/templates already in handbook

## Constraints

- **Students:** 5 PhD students, mostly beginners, few intermediate
- **Environment:** Equal split between local machines and Longleaf HPC
- **Collaboration:** Currently solo projects, moving toward shared repos
- **Timeline:** Foundation in 2-4 weeks, phased rollout over 1-2 months

## Design Decisions

### Approach: Integrated Handbook Chapter

Rather than a standalone repo, Claude Code documentation will be:
1. **A new chapter in lab-handbook** — Cross-references existing content
2. **Updates to existing pages** — Add Claude sections to relevant pages
3. **Template integration** — Add `.claude/` configs to all templates

### Configuration Hierarchy

```
~/.claude/CLAUDE.md          # Global lab standards (all projects)
~/.claude/settings.json      # User plugins and permissions
.claude/CLAUDE.md            # Project-specific instructions
.claude/settings.json        # Project permissions and hooks
.claude/commands/*.md        # Project skills (/review, /validate)
.claude/agents/*.md          # Project agents (lab-reviewer, etc.)
.claude/review-checklist.yml # Known issue patterns
```

### Privacy: Hybrid Team Roster

- **Public:** `config/team.yml` — Names, roles, focus areas (all students see)
- **Private:** `lab-admin/config/students.yml` — Milestones, 1:1 notes (PI only)
- **Global CLAUDE.md templates:** Separate versions for students vs PI

---

## Deliverables

### 1. New Handbook Chapter: `claude-code/`

```
lab-handbook/claude-code/
├── index.qmd                 # Overview, team account, quick orientation
├── installation.qmd          # Local + Longleaf setup
├── first-session.qmd         # Guided walkthrough with real project
├── daily-workflow.qmd        # Common patterns, consistency intro
├── lab-integration.qmd       # targets, git, config, Quarto integration
├── hpc-usage.qmd             # Longleaf-specific workflows
├── advanced/
│   ├── index.qmd             # Advanced overview
│   ├── global-config.qmd     # ~/.claude/CLAUDE.md setup
│   ├── skills.qmd            # Custom /commands
│   ├── agents.qmd            # Custom agents
│   ├── hooks.qmd             # Automation triggers
│   ├── mcp-servers.qmd       # External integrations
│   └── enforcing-standards.qmd # Full consistency stack
├── troubleshooting.qmd       # Common issues and solutions
└── reference.qmd             # Quick reference card
```

### 2. New Page: `project-consistency/claude-code-enforcement.qmd`

Bridges Claude Code with the existing consistency framework:
- How Claude reads globals.yml, plans, provenance docs
- Review checklist integration
- `/validate` skill for consistency checks

### 3. Cross-Reference Updates

| Existing Page | Addition |
|---------------|----------|
| `computing/index.qmd` | "Claude Code on Longleaf" section |
| `branding/presentations.qmd` | "Creating Presentations with Claude" section |
| `coding-standards/targets-pipeline.qmd` | "Debugging with Claude" section |
| `coding-standards/git-practices.qmd` | "Claude Commit Workflow" section |
| `coding-standards/r-style.qmd` | "Claude Enforces Standards" callout |
| `onboarding/first-project.qmd` | "Using Claude on Your First Project" section |

### 4. Shared Configuration Files

```
config/
├── claude/
│   ├── student-CLAUDE.md     # Student global template
│   ├── pi-CLAUDE.md          # PI global template (with admin section)
│   └── settings.json         # Recommended plugins and settings
└── team.yml                  # Public team roster
```

### 5. Template Updates

Add `.claude/` directory to each template:

```
template-research-project/.claude/
├── CLAUDE.md                 # Project-specific instructions
├── settings.json             # Permissions, hooks
├── commands/
│   └── review.md             # /review skill
├── agents/
│   └── lab-reviewer.md       # Code review agent
└── review-checklist.yml      # Known issue patterns

template-methods-paper/.claude/
└── [same + manuscript-checker agent]

template-clinical-trial/.claude/
└── [same + pipeline-debugger agent]
```

---

## Key Content Summaries

### Global CLAUDE.md (Student Version)

```markdown
# Rashid Lab - Claude Code Configuration

## Lab Organization
- Lab: Rashid Lab, Biostatistics, UNC Chapel Hill
- GitHub Org: https://github.com/rashidlab
- Team roster: ~/rashid-lab-setup/config/team.yml

## Lab Coding Standards
- Data manipulation: Base R + data.table (NOT tidyverse)
- Dependencies: DESCRIPTION file (not renv.lock)
- Pipelines: {targets} (not Makefiles)
- Communication: Microsoft Teams (not Slack)
- HPC: Longleaf cluster

## Common Commands
- Pipeline: Rscript -e "targets::tar_make()"
- Longleaf: ssh <onyen>@longleaf.unc.edu

## Resources
- Lab Handbook: https://rashidlab.github.io/lab-handbook/
- Claude Code Guide: lab-handbook/claude-code/
```

### Lab-Standard Agents

**lab-reviewer.md:**
- Priority order: Logic errors > Security > Data integrity > Lab standards > Style
- Project-specific checklist from review-checklist.yml
- Structured output format (Critical/Warning/Notes)

**pipeline-debugger.md:**
- Targets + Slurm debugging specialist
- Common fixes: stale locks, orphaned workers, resource limits
- References computing/index.qmd

**manuscript-checker.md:**
- Quarto/LaTeX validation
- Checks for hardcoded values
- Verifies figure provenance

### Lab-Standard Skills

**/review:**
- Review commits with priority-ordered checks
- Apply project review-checklist.yml patterns
- Log findings to logs/code_review.log

**/validate:**
- Run consistency validation script
- Check globals.yml usage
- Verify data provenance

**/preflight:**
- Pre-Slurm submission checks
- Stale lock detection
- Orphaned process cleanup

### Recommended Plugins

```json
{
  "enabledPlugins": {
    "github@claude-plugins-official": true,
    "commit-commands@claude-plugins-official": true,
    "superpowers@superpowers-marketplace": true,
    "scientific-skills@claude-scientific-skills": true
  }
}
```

---

## Implementation Phases

### Phase 1: Foundation (Week 1-2)

1. Create `config/claude/` with global CLAUDE.md templates
2. Create `config/team.yml` public roster
3. Write core handbook pages:
   - `claude-code/index.qmd`
   - `claude-code/installation.qmd`
   - `claude-code/first-session.qmd`
   - `claude-code/daily-workflow.qmd`
4. Add `.claude/` to `template-research-project/`

### Phase 2: Integration (Week 3-4)

1. Write remaining handbook pages:
   - `claude-code/lab-integration.qmd`
   - `claude-code/hpc-usage.qmd`
   - `claude-code/troubleshooting.qmd`
   - `claude-code/reference.qmd`
2. Add cross-references to existing pages
3. Create `project-consistency/claude-code-enforcement.qmd`
4. Add `.claude/` to remaining templates

### Phase 3: Advanced Features (Month 2)

1. Write advanced section:
   - `claude-code/advanced/*.qmd`
2. Create lab-standard agents and skills
3. Configure hooks for automation
4. Test with 1-2 students, gather feedback

### Phase 4: Rollout (Month 2)

1. Onboard all 5 students
2. Set up Claude for Teams account
3. Iterate based on feedback
4. Document common issues in troubleshooting

---

## Success Criteria

1. **All students can:**
   - Install and authenticate Claude Code (local + Longleaf)
   - Run `/review` and `/commit` workflows
   - Use Claude with targets pipelines
   - Submit Slurm jobs via Claude

2. **Consistency enforcement:**
   - Claude follows lab coding standards automatically
   - Projects use globals.yml, not hardcoded values
   - Reviews catch common anti-patterns

3. **Documentation complete:**
   - Handbook chapter covers all major workflows
   - Cross-references connect Claude to existing practices
   - Troubleshooting covers common issues

---

## Reference: Existing Assets

### From adaptive-trial-bo-paper (Example Implementation)

The PI's adapt repo demonstrates advanced patterns:
- 955-line CLAUDE.md with comprehensive project context
- Custom `/review` command with 9-step process
- Reviewer agent with priority-ordered checks
- `review-checklist.yml` with known issue patterns
- Integration with globals.yml, targets, Slurm

These patterns will be generalized for lab-wide use.

### From Lab Handbook

Existing sections to integrate with:
- `project-consistency/` — Config values, claims, provenance, validation
- `computing/` — Slurm, targets + Slurm, array jobs
- `coding-standards/` — R style, git practices, targets pipeline
- `branding/` — Presentations, colors, assets
- `templates/` — Research project, methods paper, clinical trial

---

## Appendix: Page Outlines

### claude-code/index.qmd
- Why Claude Code (speed, quality, learning, integration)
- Team account setup
- Quick orientation table
- Reference implementation link

### claude-code/installation.qmd
- Local installation (curl, login, lab config)
- Longleaf installation (SSH, modules, config sync)
- Recommended plugins
- Verification steps

### claude-code/first-session.qmd
- Clone template project
- Exploration prompts
- Running commands
- Making changes
- Code review
- Committing

### claude-code/daily-workflow.qmd
- Starting your day
- Core patterns (explore→understand→modify)
- Task-specific workflows
- Managing context
- Consistency files (plans, changelog, globals)
- End of day checklist

### claude-code/lab-integration.qmd
- Targets pipeline integration
- Git workflow integration
- Configuration integration
- Quarto/manuscript integration
- Longleaf HPC integration
- Full workflow examples

### claude-code/hpc-usage.qmd
- When to use HPC vs local
- Connecting (SSH, tmux)
- Job submission workflows
- Monitoring and debugging
- Targets + Slurm
- Data management
- Remote development patterns

### claude-code/advanced/index.qmd
- Configuration hierarchy
- Overview of advanced topics
- Quick setup commands

### claude-code/advanced/global-config.qmd
- User CLAUDE.md structure
- Lab vs personal settings
- PI admin section

### claude-code/advanced/skills.qmd
- What are skills
- Lab-provided skills
- Creating custom skills
- Project vs user skills

### claude-code/advanced/agents.qmd
- What are agents
- Lab-provided agents
- Creating custom agents
- Agent vs skill comparison

### claude-code/advanced/hooks.qmd
- Hook types (Pre/Post/Notification/Stop)
- Lab-provided hooks
- Creating custom hooks
- Best practices

### claude-code/advanced/mcp-servers.qmd
- What are MCP servers
- Lab-recommended servers
- Scientific skills servers
- Configuration

### claude-code/advanced/enforcing-standards.qmd
- The consistency stack
- Setting up new projects
- Enforcement points
- Customizing enforcement
- Integration with project-consistency framework

### claude-code/troubleshooting.qmd
- Quick diagnostics
- Authentication issues
- Context issues
- Permission issues
- Performance issues
- HPC-specific issues
- Hook issues
- Git issues
- Pipeline issues
- Getting help

### claude-code/reference.qmd
- Essential commands
- Keyboard shortcuts
- Common prompts
- File patterns
- Agent invocations
- Pipeline commands
- Configuration locations
- Lab standards quick reference
- Links

---

## Approval

This design is ready for implementation. Next steps:

1. [ ] PI reviews and approves design
2. [ ] Create implementation branch
3. [ ] Begin Phase 1 implementation
4. [ ] Set up Claude for Teams account
