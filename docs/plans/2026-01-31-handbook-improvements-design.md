# Lab Handbook Improvements Design

**Date:** 2026-01-31
**Author:** Claude (based on feedback from Amber Young)
**Status:** Approved for implementation

## Overview

Implementing student feedback to improve lab handbook usability. Key pain points: overwhelming page lengths, missing troubleshooting guidance, unclear rationale for conventions, and gaps in meeting/policy documentation.

## Changes by Priority

| Priority | Change | Effort | Impact |
|----------|--------|--------|--------|
| **P1** | Add troubleshooting FAQ | Medium | High |
| **P1** | Split tools-setup.qmd (608 lines → 3 pages) | Medium | High |
| **P1** | Create meeting lead cheatsheet | Low | High |
| **P2** | Add "why base R" rationale | Low | Medium |
| **P2** | Add virtual/hybrid meeting guidance | Low | Medium |
| **P3** | Fix hardcoded paths/versions | Low | Low |
| **P3** | Add prerequisites callouts | Low | Medium |
| **P3** | Add 1:1 preparation guidance | Low | Medium |

## New Files

### 1. `onboarding/troubleshooting.qmd`
Central FAQ for common issues: Longleaf/HPC, Git/GitHub, R/targets, Quarto.

### 2. Split tools-setup.qmd → 3 files
- `onboarding/setup-longleaf.qmd` (~200 lines) - Longleaf, OnDemand, VS Code Remote, SSH
- `onboarding/setup-local.qmd` (~120 lines) - Local R, RStudio, Quarto
- `onboarding/setup-git.qmd` (~150 lines) - Git install, config, GitHub SSH
- `onboarding/tools-setup.qmd` becomes landing page (~50 lines)

### 3. `policies/meeting-cheatsheet.qmd`
One-page quick reference for meeting leads with checkboxes.

## Edits to Existing Files

### coding-standards/r-style.qmd
- Add "Why Base R + data.table?" callout after General Principles

### policies/meetings.qmd
- Add "Virtual & Hybrid Participation" section after Meeting Types

### policies/index.qmd
- Add "1:1 Meetings with Dr. Rashid" section with preparation guidance

### policies/meeting-leader-guide.qmd
- Add "Can't Lead Your Assigned Week?" swap guidance before Phase 1

### Hardcoded path fixes
- tools-setup.qmd: Add comment about checking module versions
- meeting-leader-guide.qmd: Use placeholder path
- first-week.qmd: Clean up redundant comment

### Prerequisites callouts
- coding-standards/r-style.qmd
- coding-standards/targets-pipeline.qmd
- coding-standards/git-practices.qmd

## Navigation Updates (_quarto.yml)

### Onboarding section
```yaml
- section: "Getting Started"
  contents:
    - onboarding/index.qmd
    - onboarding/first-week.qmd
    - text: "Tools Setup"
      contents:
        - onboarding/tools-setup.qmd
        - onboarding/setup-longleaf.qmd
        - onboarding/setup-local.qmd
        - onboarding/setup-git.qmd
    - onboarding/github-fundamentals.qmd
    - onboarding/first-project.qmd
    - onboarding/troubleshooting.qmd
```

### Policies section
Add `policies/meeting-cheatsheet.qmd` after meeting-leader-guide.qmd

## Implementation Phases

1. **Phase 1:** Create new files (no breaking changes)
2. **Phase 2:** Edit existing files
3. **Phase 3:** Update navigation (_quarto.yml)
4. **Phase 4:** Verify build & commit

## Success Criteria

- New students can complete setup without asking for help
- Meeting leads have a one-page reference
- Pages are ≤200 lines each
- `quarto render` succeeds without errors
