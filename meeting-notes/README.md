# Meeting Notes

This directory contains committed meeting notes for all lab meetings.

> **Full Guide:** [Lab Meetings Documentation](https://rashidlab.github.io/lab-handbook/policies/meetings.html)

---

## Quick Reference: Key Deadlines

| Day | Who | What |
|-----|-----|------|
| **Wednesday 5pm** | Meeting Lead | Create the Discussion thread with agenda |
| **Thursday 5pm** | Everyone | Add your agenda items to the thread |
| **Friday** | Everyone | Attend lab meeting |
| **Friday EOD** | Meeting Lead | Post notes to Discussion AND commit here |

---

## For Everyone: Adding Agenda Items

**By Thursday 5pm**, reply to the week's Discussion thread with your items:

```markdown
### [Your Name] - Agenda Item

**Topic:** [Brief title]
**Time needed:** [5/10/15 min]
**Type:** [Update / Discussion / Decision needed / FYI]

**Summary:**
[2-3 sentences describing what you want to share or discuss]
```

**Where to find the thread:** [Lab Meeting Discussions](https://github.com/rashidlab/lab-handbook/discussions/categories/lab-meetings)

---

## For Meeting Leads: Your Checklist

### Before Meeting (Wed-Thu)
- [ ] Create Discussion thread: `Lab Meeting - YYYY-MM-DD`
- [ ] Post the [agenda template](https://rashidlab.github.io/lab-handbook/policies/meetings.html#agenda-template)
- [ ] Remind team in Teams to add items

### During Meeting (Fri)
- [ ] Review last week's action items
- [ ] Keep time for each presenter
- [ ] Capture decisions and new action items

### After Meeting (Fri EOD)
- [ ] Update Discussion thread with notes
- [ ] @mention action item assignees
- [ ] **Commit notes to this directory** (see below)

> **Detailed walkthrough:** [Discussion Leader Guide](https://rashidlab.github.io/lab-handbook/policies/meetings.html#leader-walkthrough)

---

## Action Items Format

Write action items so anyone can understand them:

```markdown
- [ ] **[Verb] [specific task]** - @assignee - Due: YYYY-MM-DD
```

**Good examples:**
```markdown
- [ ] **Run sensitivity analysis for Table 2** - @jsmith - Due: 2026-02-14
- [ ] **Review manuscript Methods section** - @bjones - Due: 2026-02-12
```

**Bad examples:**
```markdown
- [ ] Work on analysis - Due: soon
- [ ] Someone should review the paper
```

> **More on action items:** [Best Practices](https://rashidlab.github.io/lab-handbook/policies/meetings.html#action-items-best-practices)

---

## Committing Meeting Notes

After updating the Discussion thread, commit notes here for a permanent record.

### Option 1: Command Line

```bash
# 1. Pull latest
cd ~/lab-handbook
git pull origin main

# 2. Create notes file from template
cp meeting-notes/TEMPLATE.md meeting-notes/2026/2026-02-07-lab-meeting.md

# 3. Edit with your notes (copy from Discussion thread)

# 4. Commit and push
git add meeting-notes/2026/2026-02-07-lab-meeting.md
git commit -m "notes: lab meeting 2026-02-07"
git push origin main
```

### Option 2: GitHub Web Interface

1. Go to [meeting-notes/2026/](https://github.com/rashidlab/lab-handbook/tree/main/meeting-notes/2026)
2. Click **Add file** → **Create new file**
3. Name: `2026-02-07-lab-meeting.md`
4. Paste your notes (copy from Discussion thread)
5. Click **Commit new file**

---

## Directory Structure

```
meeting-notes/
├── 2026/
│   ├── 2026-02-07-lab-meeting.md
│   ├── 2026-02-14-lab-meeting.md
│   └── 2026-02-07-journal-club.md
├── TEMPLATE.md
└── README.md
```

### File Naming

| Meeting Type | Format |
|--------------|--------|
| Lab meetings | `YYYY-MM-DD-lab-meeting.md` |
| Journal club | `YYYY-MM-DD-journal-club.md` |
| Working groups | `YYYY-MM-DD-wg-[project-name].md` |

---

## Searching Past Notes

```bash
# Find discussions about a topic
grep -r "BATON" meeting-notes/

# Find action items assigned to someone
grep -r "@jsmith" meeting-notes/

# Find all decisions made
grep -r "Decision:" meeting-notes/
```

---

## Links

- **Full meetings guide:** https://rashidlab.github.io/lab-handbook/policies/meetings.html
- **Meeting schedule:** https://rashidlab.github.io/lab-handbook/policies/schedule.html
- **Discussion threads:** https://github.com/rashidlab/lab-handbook/discussions/categories/lab-meetings
- **GitHub fundamentals:** https://rashidlab.github.io/lab-handbook/onboarding/github-fundamentals.html
