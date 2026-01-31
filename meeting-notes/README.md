# Meeting Notes

This directory contains committed meeting notes for all lab meetings.

## Structure

```
meeting-notes/
├── 2026/
│   ├── 2026-01-31-lab-meeting.md
│   ├── 2026-02-07-lab-meeting.md
│   └── 2026-02-07-journal-club.md
├── TEMPLATE.md
└── README.md
```

## File Naming Convention

- **Lab meetings:** `YYYY-MM-DD-lab-meeting.md`
- **Journal club:** `YYYY-MM-DD-journal-club.md`
- **Working groups:** `YYYY-MM-DD-wg-[project-name].md`

## Workflow

1. Meeting lead takes notes during the meeting
2. After the meeting, update the GitHub Discussion thread
3. Copy the notes to a new file in `meeting-notes/YYYY/`
4. Commit and push: `git commit -m "notes: lab meeting YYYY-MM-DD"`

## Template

Copy `TEMPLATE.md` when creating a new meeting notes file.

## Search

Search all meeting notes:

```bash
# Find discussions about a topic
grep -r "BATON" meeting-notes/

# Find action items assigned to someone
grep -r "@jsmith" meeting-notes/
```
