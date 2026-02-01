# Git Learning Path Design

**Date:** 2026-02-01
**Status:** Approved
**Scope:** Add learning path indicators to existing Git documentation

## Overview

Formalize the natural learning progression across the 3 existing Git-related pages by adding learning path metadata and visual indicators, reusing the CSS infrastructure from the Claude Code section.

## Structure

| Phase | Page | Level | Time | Focus |
|-------|------|-------|------|-------|
| 1 | `onboarding/setup-git.qmd` | Beginner | 10 min | Install Git, configure identity, SSH keys |
| 2 | `onboarding/github-fundamentals.qmd` | Beginner | 15 min | Issues, PRs, Discussions, Branches concepts |
| 3 | `coding-standards/git-practices.qmd` | Intermediate | 12 min | Lab workflows, commit conventions, PR lifecycle |

### Prerequisites Chain

- Phase 1: None (entry point)
- Phase 2: Phase 1 (need Git installed)
- Phase 3: Phase 2 (need GitHub concepts)

### Design Decisions

1. **No dedicated learning-path.qmd page** — 3 pages don't warrant a separate overview (unlike Claude Code's 15 pages)
2. **Distributed across sections** — Pages stay in their current locations (onboarding, coding-standards)
3. **Cross-section navigation** — Learning path indicators link across sidebar sections

## Frontmatter Metadata

### setup-git.qmd
```yaml
learning-path:
  name: git
  phase: 1
  order: 1
  level: beginner
  time: "10 min"
  prerequisites: []
date-modified: 2026-02-01
```

### github-fundamentals.qmd
```yaml
learning-path:
  name: git
  phase: 2
  order: 1
  level: beginner
  time: "15 min"
  prerequisites:
    - setup-git.qmd
date-modified: 2026-02-01
```

### git-practices.qmd
```yaml
learning-path:
  name: git
  phase: 3
  order: 1
  level: intermediate
  time: "12 min"
  prerequisites:
    - github-fundamentals.qmd
date-modified: 2026-02-01
```

## Visual Indicators

### Learning Path Indicator Bar

Each page gets a `.learning-path-indicator` bar showing:
- Level badge (beginner/intermediate)
- Time estimate
- Phase name ("Git Learning Path")
- Previous/Next navigation links

### Entry Point Callout (Phase 1 only)

```markdown
::: {.callout-tip appearance="simple" icon=false}
**Git Learning Path** — This is the first of 3 pages covering Git for the lab.
Setup → GitHub Fundamentals → Git Practices
:::
```

### Prerequisite Callouts (Phase 2 & 3)

Reuse `.callout-prereq` class to show required prior reading.

## Files to Modify

| File | Changes |
|------|---------|
| `onboarding/setup-git.qmd` | Add frontmatter, entry callout, path indicator |
| `onboarding/github-fundamentals.qmd` | Add frontmatter, path indicator, prereq callout |
| `coding-standards/git-practices.qmd` | Add frontmatter, path indicator, prereq callout |

## Files NOT Modified

- `_quarto.yml` — Pages stay in current sidebar locations
- `assets/custom.scss` — Reuse existing CSS classes from Claude Code implementation

## CSS Classes Reused

- `.learning-path-indicator` — Path position bar
- `.level-badge.level-beginner` / `.level-intermediate` — Level badges
- `.callout-prereq` — Prerequisite callouts
- `.path-nav` — Previous/Next navigation

## Estimated Effort

~15 minutes, 3 file edits
