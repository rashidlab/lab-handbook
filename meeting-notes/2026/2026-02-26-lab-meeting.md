## Lab Meeting - 2026-02-26

**Lead:** @naimurashid
**Time:** Thursday, February 26, 2026 · 9:30–11:00 AM ET
**Location:** LCCC 20-023 / Microsoft Teams
**Format:** Hands-on working session — bring your laptop

### Attendees
- [ ] @ayoung31
- [ ] @dinelka97
- [ ] @jialiux22
- [ ] @tylerbhumpherys
- [ ] @andrew-walther

---

### Standing Items (5 min)
- [ ] Announcements
- [ ] Note: Dinelka's research update moved to a future session

---

### Working Session: Claude Code for Your Research Projects (50 min)

> **Pre-work required:** See [Issue #16](https://github.com/rashidlab/lab-handbook/issues/16) — install Claude Code, have a repo ready.
>
> **Handbook reference:** [Claude Code chapter](https://rashidlab.github.io/lab-handbook/claude-code/) · [Learning path](https://rashidlab.github.io/lab-handbook/claude-code/learning-path.html)

This is a live-coding session. I'll drive on the projector, you follow along on your laptops with your own repos. By the end, you'll have a fully configured project that Claude understands, and you'll know the daily workflows that save the most time.

#### Roadmap

| # | Segment | Min | What you'll build |
|---|---------|:---:|-------------------|
| 1 | `claude /init` — generating your first CLAUDE.md | 5 | A starter CLAUDE.md for your project |
| 2 | Configuration hierarchy — global + project CLAUDE.md | 8 | Lab standards (global) + project context (repo) |
| 3 | Context management — the most important workflow pattern | 5 | Mental model for `/clear`, `/compact`, `--resume` |
| 4 | Git as a checkpoint system | 8 | Real commits + diff-based debugging |
| 5 | Iterating CLAUDE.md — learning from mistakes | 7 | A "Lessons Learned" section in your CLAUDE.md |
| 6 | Planning documents — plan in one session, implement fresh | 7 | A design doc in `docs/plans/` |
| 7 | GSD workflows — structured project management | 7 | See how to manage multi-phase research projects |
| 8 | Hooks — automated safety nets | 4 | A pre-commit hook in your repo |
| 9 | Run→Fix loops — let Claude debug for you | 5 | See Claude run scripts, catch errors, and fix them |
| 10 | TDD — test-driven development with Claude | 4 | See the write-tests-first workflow in action |

---

#### Segment 1: `claude /init` (5 min)

> 📖 Handbook: [First Session](https://rashidlab.github.io/lab-handbook/claude-code/first-session.html)

Open your terminal in your repo directory:

```bash
cd ~/path-to-your-repo
claude /init
```

Walk through the interactive prompts. `/init` scans your repo — files, README, existing configs — and generates a starter CLAUDE.md.

After it completes, open the generated file and scan what it produced. It's a starting point, not the final product. The next step is where it gets useful.

**Key idea:** Think of CLAUDE.md as your project's memory. Every time Claude starts a conversation, it reads this file first. A good CLAUDE.md means you stop repeating yourself.

---

#### Segment 2: Configuration Hierarchy — Global + Project (8 min)

> 📖 Handbook: [Configuration Hierarchy](https://rashidlab.github.io/lab-handbook/claude-code/advanced/index.html#configuration-hierarchy) · [Global Config](https://rashidlab.github.io/lab-handbook/claude-code/advanced/global-config.html)

Claude Code loads **two** CLAUDE.md files every session:

| Level | Location | Contains |
|-------|----------|----------|
| **Global** | `~/.claude/CLAUDE.md` | Lab-wide standards (same for all projects) |
| **Project** | `.claude/CLAUDE.md` | Repo-specific context (different per project) |

**Step 1 — Set up your global config (2 min):**

```bash
cp ~/rashid-lab-setup/lab-handbook/config/claude/student-CLAUDE.md ~/.claude/CLAUDE.md
```

Open it — this has our [lab coding standards](https://rashidlab.github.io/lab-handbook/claude-code/reference.html#lab-coding-standards), common commands, [project consistency](https://rashidlab.github.io/lab-handbook/project-consistency/) rules, and key links pre-loaded. You write this once.

**Step 2 — Customize your project CLAUDE.md (6 min):**

If you cloned a lab template, `.claude/CLAUDE.md` already exists — open it and fill in the `[Project Name]` placeholders and project-specific details.

If you're using your own repo:

```
Look at my project structure and create a .claude/CLAUDE.md
based on what you find. Focus on key files, how to run things,
and project-specific rules.
```

**Note:** Lab template repos ship with a full `.claude/` directory — settings.json (permissions), a `/review` command, a lab-reviewer agent, and a review checklist. When you start a new project from a template, all of this comes pre-configured.

---

#### Segment 3: Context Management (5 min)

> 📖 Handbook: [Managing Context](https://rashidlab.github.io/lab-handbook/claude-code/daily-workflow.html#managing-context) · [Command Reference](https://rashidlab.github.io/lab-handbook/claude-code/reference.html#essential-commands)

Claude has a fixed-size context window — think of it as a desk. Your CLAUDE.md, files Claude reads, your conversation, and Claude's responses all compete for space. When the desk fills up, older conversation gets compressed.

**Check your context right now:**

```
/context
```

This shows a visual grid of what's consuming space.

**Three strategies when context gets heavy:**

**`/compact` — compress the noise, stay in the flow:**

```
/compact focus on the analysis function we're building
```

Summarizes older exchanges while keeping key content. Use when you're mid-task but context is filling up.

**`/clear` — fresh start, same terminal:**

```
/clear
```

Wipes the conversation. CLAUDE.md reloads. Use this for the **plan→implement pattern**: write your plan to a file, `/clear`, then implement with full context available.

**`/rename` + `--resume` — pause and come back later:**

```
/rename sensitivity-analysis
/exit
```

Then tomorrow:

```bash
claude -c                          # resume most recent session
claude -r "sensitivity-analysis"   # resume a specific session by name
```

Full conversation history restored. Claude remembers where you were.

**The most important workflow pattern:** Plan in one context, implement in a fresh one. The plan file is the bridge — your planning conversation disappears, but the decisions survive in the file.

**Practical rules:**
- Let Claude read files — don't paste them into the chat
- Start new contexts for new tasks (`/clear`)
- CLAUDE.md is always loaded, so put important context there — not in conversation
- Name sessions (`/rename`) before stopping so you can resume by name

---

#### Segment 4: Git as a Checkpoint System (8 min)

> 📖 Handbook: [Git Workflow Integration](https://rashidlab.github.io/lab-handbook/claude-code/lab-integration.html#git-workflow-integration) · [Git Operations](https://rashidlab.github.io/lab-handbook/claude-code/reference.html#git-operations)

Every commit is a save point. When Claude makes changes, commit early and often — not because you're done, but because you're creating checkpoints to debug from.

**Make a small change:**

```
Add a comment block at the top of my main analysis file
explaining what this script does
```

Then:

```
Commit this change with a descriptive message
```

**Now make a second, more complex change and commit that too.** You now have two checkpoints.

**The debugging power — ask Claude to trace what changed:**

```
Show me what changed in the last commit
```

Claude runs `git diff HEAD~1` and summarizes the changes in plain English. Then:

```
Something is broken after the last change. Compare the current
code to the previous commit and identify what might have caused
the issue
```

**Key principles:**
- **Atomic commits = debuggable history.** Small commits let Claude pinpoint exactly where things went wrong via diffs
- **Claude understands diffs.** You don't have to read the diff yourself — ask Claude to explain what changed and whether it could cause the bug
- **Recovery options:** Ask Claude to fix it, `git checkout -- file.R` to restore one file, or `git revert HEAD` to undo the whole commit

**Verify:** `git log --oneline -5` — you should see your checkpointed commits.

---

#### Segment 5: Iterating CLAUDE.md After Bugs (7 min)

> 📖 Handbook: [Customizing Your Config](https://rashidlab.github.io/lab-handbook/claude-code/advanced/global-config.html#customizing) · [Enforcing Standards](https://rashidlab.github.io/lab-handbook/claude-code/advanced/enforcing-standards.html)

CLAUDE.md is a **living document** that gets smarter over time. Every time Claude makes a systematic mistake, you update CLAUDE.md so it won't repeat it.

**The feedback loop:**

```
Claude makes mistake → catch it via commit diff →
fix the code → update CLAUDE.md with the lesson →
next session, Claude won't repeat it
```

**Add a common mistakes section to your CLAUDE.md:**

```
In my CLAUDE.md, add a 'Lessons Learned' section. Include:
- Never use tidyverse/dplyr — use base R and data.table
- Never hardcode numerical values — always read from config/globals.yml
- Never create renv.lock — dependencies go in DESCRIPTION
- Always preserve random seeds for reproducibility
```

**Real example from our lab:** In one project, Claude kept using inconsistent parameter names — sometimes `nmax`, sometimes `total_n`. We added a naming taxonomy to CLAUDE.md:

```markdown
| Canonical | Avoid |
|-----------|-------|
| `total_n` | `nmax`, `N`, `max_n` |
| `type1`   | `alpha`, `type_1_error` |
```

After that, it used the right names every time.

**Your turn (2 min):** Think of one convention or mistake from your own work. Add it to your CLAUDE.md now.

---

#### Segment 6: Planning Documents (7 min)

> 📖 Handbook: [Consistency Files](https://rashidlab.github.io/lab-handbook/claude-code/daily-workflow.html#consistency-files) · [Project Consistency Framework](https://rashidlab.github.io/lab-handbook/project-consistency/)

This makes the context management strategy concrete. Instead of jumping straight to code, plan first and save the plan as a file.

**Planning session — brief back-and-forth with Claude:**

```
I need to add [a feature relevant to your project].
Let's think through the design. What are the key decisions?
```

After a few exchanges:

```
Write this plan to docs/plans/2026-02-26-[topic]-design.md.
Include the decisions we made, the approach, and the
implementation steps.
```

Commit the plan:

```
Commit this plan file
```

**Now the session switch:**

```
/clear
```

Fresh context. Then:

```
Read docs/plans/2026-02-26-[topic]-design.md and implement
step 1 of the plan
```

Full context window available for implementation. Claude has everything it needs from CLAUDE.md + the plan file.

**The resume scenario — stopping mid-implementation:**

```
/rename results-summary-implementation
/exit
```

Next day:

```bash
claude -r "results-summary-implementation"
```

Full conversation restored. Ask Claude to continue with the next step.

**When to use this pattern:** For anything that takes real thought — new analysis, package architecture, manuscript restructuring. A 5-minute task, just do it. A multi-step design, plan first and implement fresh.

`docs/plans/` is already part of the [project consistency framework](https://rashidlab.github.io/lab-handbook/project-consistency/) — it's referenced in your CLAUDE.md under "Design decisions."

---

#### Segment 7: GSD Workflows (7 min — demo, no follow-along)

> 📖 Handbook: [Custom Skills](https://rashidlab.github.io/lab-handbook/claude-code/advanced/skills.html)

GSD (Get Stuff Done) is the structured, multi-phase version of the plan→implement pattern for large research efforts.

**Key commands (I'll demo on screen):**

| Command | What it does |
|---------|-------------|
| `/gsd:new-project` | Interviews you about the project, researches the domain, creates a phased roadmap |
| `/gsd:plan-phase` | Creates a detailed execution plan with tasks for one phase |
| `/gsd:execute-phase` | Works through the plan task by task, committing as it goes |
| `/gsd:progress` | Shows where you are — completed phases, current task, what's next |
| `/gsd:pause-work` / `/gsd:resume-work` | Saves context when you stop, restores when you come back |

**Example:** Starting a new methods paper with `/gsd:new-project` would create a roadmap like:
- Phase 1: Core method implementation
- Phase 2: Simulation study
- Phase 3: Manuscript

Each phase gets researched, planned, and executed separately. Every decision is documented.

**Especially useful with Longleaf:** Plan locally, pause before submitting cluster jobs, resume when results are back.

You don't need to run GSD today — but when you start a major research effort, this is the tool to reach for.

---

#### Segment 8: Hooks — Automated Safety Nets (4 min)

> 📖 Handbook: [Hooks](https://rashidlab.github.io/lab-handbook/claude-code/advanced/hooks.html) · [Pre-Commit Validation](https://rashidlab.github.io/lab-handbook/claude-code/advanced/hooks.html#common-hook-patterns)

Hooks run automatically at trigger points, catching mistakes before they land in your repo.

**See what the templates ship with:**

```bash
cat .claude/settings.json
```

Template repos include a pre-commit hook that validates pipeline consistency.

**Add a simple hook to your project:**

In `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [{
      "command": "echo 'Reminder: Review CLAUDE.md if project context has changed'"
    }]
  }
}
```

**Key ideas:**
- **Pre-commit hooks catch convention violations** — hardcoded values, missing config references
- **CLAUDE.md tells Claude what to do. Hooks verify it actually did it.** Together they create a system that's hard to misuse
- The [handbook hooks page](https://rashidlab.github.io/lab-handbook/claude-code/advanced/hooks.html) has more examples — we'll go deeper in a future session

---

#### Segment 9: Run→Fix Loops — Let Claude Debug For You (5 min — demo)

> 📖 Handbook: [Run→Diagnose→Fix Loop](https://rashidlab.github.io/lab-handbook/claude-code/lab-integration.html#run-diagnose-fix) · [HPC Submit→Monitor→Fix](https://rashidlab.github.io/lab-handbook/claude-code/hpc-usage.html#submit-monitor-fix)

This is one of the biggest time-savers: instead of running a script, reading the error, searching for the fix, and trying again — **let Claude do the whole cycle.**

**Live demo — run a script and let Claude handle the error:**

```
Run Rscript scripts/run_simulation.R and fix any errors you find
```

Claude runs the script, sees the error output directly, identifies the bug, fixes it, and re-runs — all without you reading the traceback.

**Key insight:** Claude sees the full error output in real-time. You don't need to copy-paste errors or diagnose anything. Just tell Claude to run it and fix what breaks.

**This works for everything:**

| What you run | What Claude auto-fixes |
|-------------|----------------------|
| R scripts | Missing packages, syntax errors, wrong function arguments |
| `targets::tar_make()` | Failed targets, missing dependencies, configuration issues |
| `devtools::check()` | Missing docs, failed tests, namespace issues |
| `quarto render` | YAML errors, missing references, broken includes |

**On Longleaf — the submit→fix→resubmit cycle:**

```
Submit scripts/run_sim.sh to Slurm, and when it finishes,
check the error log. If it failed, fix the issue and resubmit.
```

Common first-submission failures Claude handles automatically: missing modules, wrong library paths, insufficient memory, timeouts, bad file paths. Instead of multiple SSH sessions reading logs, Claude reads the error log and fixes the job script in one step.

---

#### Segment 10: TDD — Test-Driven Development (4 min — demo)

> 📖 Handbook: [Daily Workflow — Writing Tests](https://rashidlab.github.io/lab-handbook/claude-code/daily-workflow.html#writing-tests)

Write the test first, watch it fail, then write code to make it pass. Claude is exceptionally good at this.

**Live demo:**

```
I need a function called summarize_scenarios that takes a
data.table with columns scenario_id, metric, and value,
and returns a summary table with mean and sd per scenario.
Write the tests first using testthat.
```

Claude writes the test file. Then:

```
Now implement the function to pass these tests
```

Then:

```
Run the tests
```

**Why this matters for research:** Simulation code runs for hours on Longleaf. A bug discovered after a week-long run means re-running everything. Tests catch logic errors in minutes, not days. Claude generates edge-case tests you might not think of — empty inputs, single-row data.tables, NA handling.

**The checkpoint connection:** Commit after tests are written, commit after implementation passes. If you later change the function and tests break, `git diff` shows exactly what you changed.

---

### Wrap-Up & Resources (5 min)

**What you built today:**

| Layer | What's in place |
|-------|----------------|
| Global config | `~/.claude/CLAUDE.md` with lab standards |
| Project config | `.claude/CLAUDE.md` with your project context |
| Context discipline | `/clear`, `/compact`, `--resume` workflow |
| Git checkpoints | Atomic commits + diff-based debugging |
| Living documentation | CLAUDE.md that learns from your mistakes |
| Planning workflow | `docs/plans/` for design-before-code |
| Project management | GSD for multi-phase research efforts |
| Safety net | Hooks for automated validation |
| Auto-debugging | Run→fix loops for scripts and HPC jobs |
| Quality assurance | TDD for reliable research code |

**Next steps:**
1. Finish filling in your project CLAUDE.md — the more context, the better Claude works
2. Use Claude for your next real task and update CLAUDE.md when something goes wrong
3. Read the full [Claude Code handbook chapter](https://rashidlab.github.io/lab-handbook/claude-code/)
4. Try `/gsd:new-project` on your research when you're ready for structured project management

**Resources:**

| Resource | Link |
|----------|------|
| Claude Code handbook chapter | https://rashidlab.github.io/lab-handbook/claude-code/ |
| Learning path | https://rashidlab.github.io/lab-handbook/claude-code/learning-path.html |
| Student CLAUDE.md template | `lab-handbook/config/claude/student-CLAUDE.md` ([setup guide](https://rashidlab.github.io/lab-handbook/claude-code/advanced/global-config.html)) |
| Project templates | `template-research-project/`, `template-methods-paper/` |
| Troubleshooting | https://rashidlab.github.io/lab-handbook/claude-code/troubleshooting.html |
| Quick reference | https://rashidlab.github.io/lab-handbook/claude-code/reference.html |
| Pre-work issue | https://github.com/rashidlab/lab-handbook/issues/16 |

---

### Discussion Items
Team members: add your items below by Wednesday 5pm.

### Parking Lot
Items to revisit in future sessions:
- Deep dive on [custom agents](https://rashidlab.github.io/lab-handbook/claude-code/advanced/agents.html) and review checklists
- [MCP servers](https://rashidlab.github.io/lab-handbook/claude-code/advanced/mcp-servers.html) and scientific plugins
- [Custom skills/commands](https://rashidlab.github.io/lab-handbook/claude-code/advanced/skills.html) (building your own `/review`)
- Memory files for persistent knowledge across sessions
- Advanced [hooks](https://rashidlab.github.io/lab-handbook/claude-code/advanced/hooks.html) (pre-commit validation scripts)
- [Claude Code on Longleaf](https://rashidlab.github.io/lab-handbook/claude-code/hpc-usage.html) (HPC-specific workflows)
