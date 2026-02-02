# Site Reorganization Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Reorganize lab-handbook to make content easier to find by discrete topics (Lab Computing, Lab Policies, Learning Materials).

**Architecture:** Keep existing sidebar navigation intact. Create new hub pages that aggregate links to existing content by topic. Update the main page to reflect these discrete sections clearly.

**Tech Stack:** Quarto (.qmd files), YAML navigation (_quarto.yml)

---

## Summary of Changes

1. **Expand Lab Computing page** - Add "Getting Started" and "Coding Standards" sections with links
2. **Update Lab Policies page** - Add link to Lab Branding
3. **Create Learning Materials page** - New page aggregating educational content
4. **Update main page (index.qmd)** - Reorganize to show discrete topic sections
5. **Update sidebar navigation** - Add Learning Materials to sidebar

---

### Task 1: Expand Lab Computing Page

**Files:**
- Modify: `computing/index.qmd`

**Step 1: Add Getting Started section with links to setup guides**

Add a "Getting Started" section at the top that links to:
- Your First Project (`onboarding/first-project.qmd`)
- Tools Setup (`onboarding/tools-setup.qmd`)
- Longleaf Setup (`onboarding/setup-longleaf.qmd`)
- Local Development Setup (`onboarding/setup-local.qmd`)
- Git & GitHub Setup (`onboarding/setup-git.qmd`)

**Step 2: Add Coding Standards section with links**

Add a "Coding Standards" section that links to:
- Coding Standards overview (`coding-standards/index.qmd`)
- R Style Guide (`coding-standards/r-style.qmd`)
- Python Style Guide (`coding-standards/python-style.qmd`)
- Git Practices (`coding-standards/git-practices.qmd`)
- Targets Pipeline Guide (`coding-standards/targets-pipeline.qmd`)

**Step 3: Add Project Consistency section with links**

Add links to:
- Project Consistency Framework (`project-consistency/index.qmd`)

**Step 4: Add Related Resources section**

Add a section at the bottom linking to:
- Lab Branding (`branding/index.qmd`)
- Lab Policies (`policies/index.qmd`)

**Step 5: Preview changes**

Run: `quarto preview computing/index.qmd`
Expected: Page renders with new sections and working links

---

### Task 2: Update Lab Policies Page

**Files:**
- Modify: `policies/index.qmd`

**Step 1: Add Related Resources section**

Add a section at the bottom linking to:
- Lab Branding (`branding/index.qmd`) - for presentation guidelines
- Lab Computing (`computing/index.qmd`) - for technical setup

**Step 2: Preview changes**

Run: `quarto preview policies/index.qmd`
Expected: Page renders with new Related Resources section

---

### Task 3: Create Learning Materials Page

**Files:**
- Create: `learning/index.qmd`

**Step 1: Create learning directory and index page**

Create a new page that aggregates learning resources:
- GitHub Fundamentals (`onboarding/github-fundamentals.qmd`)
- Glossary (`onboarding/glossary.qmd`)
- Claude Code Learning Path (`claude-code/learning-path.qmd`)
- Troubleshooting guides

**Step 2: Preview changes**

Run: `quarto preview learning/index.qmd`
Expected: Page renders with links to learning resources

---

### Task 4: Update Sidebar Navigation

**Files:**
- Modify: `_quarto.yml`

**Step 1: Add Learning Materials sidebar section**

Add new sidebar section for Learning Materials pointing to:
- `learning/index.qmd`
- `onboarding/github-fundamentals.qmd`
- `onboarding/glossary.qmd`

**Step 2: Preview site navigation**

Run: `quarto preview`
Expected: New Learning Materials section appears in sidebar when browsing learning pages

---

### Task 5: Reorganize Main Page

**Files:**
- Modify: `index.qmd`

**Step 1: Update "Key Resources" section**

Replace current three columns with topic-focused sections:
- **Lab Policies** - meetings, communication, data management
- **Lab Computing** - setup guides, coding standards, HPC
- **Learning Materials** - tutorials, fundamentals, glossary

**Step 2: Update "I'm Looking For..." quick links**

Ensure quick links reflect the new organization with clear paths to:
- Lab Policies
- Lab Computing
- Learning Materials

**Step 3: Preview changes**

Run: `quarto preview`
Expected: Homepage shows clear topic-based organization

---

### Task 6: Final Verification

**Step 1: Full site render**

Run: `quarto render`
Expected: Site builds without errors

**Step 2: Test all new links**

Navigate through:
- Computing page → all linked pages work
- Policies page → branding link works
- Learning page → all linked pages work
- Homepage → all sections link correctly

**Step 3: Commit changes**

```bash
git add computing/index.qmd policies/index.qmd learning/index.qmd _quarto.yml index.qmd
git commit -m "docs: reorganize site for topic-based navigation

- Expand Lab Computing page with Getting Started and Coding Standards links
- Add Related Resources to Lab Policies with branding link
- Create Learning Materials page aggregating educational content
- Update homepage to show discrete topic sections
- Add Learning Materials to sidebar navigation"
```
