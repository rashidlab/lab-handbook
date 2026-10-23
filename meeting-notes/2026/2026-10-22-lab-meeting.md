# Lab Meeting - 2026-10-22

**Lead:** @dinelka97
**Time:** Thursday, October 22, 2026 · 10:30–11:45 AM ET
**Location:** Lineberger conference room / Zoom
**Presenter:** @dinelka97 — Initial ideas for calibrating Phase 1 designs
**Agenda:** https://github.com/rashidlab/lab-handbook/discussions/47

### Attendees
- [x] @naimurashid
- [x] @dinelka97 (Dinelka)
- [x] @jialiux22 (Jialiu)
- [x] @tylerbhumpherys (Tyler)
- [x] @andrew-walther (Andrew)
- [x] @alexakus (Alex)

---


_AI-generated summary; may contain mistakes (e.g., speaker attribution); names corrected by hand. Review for accuracy._

### Quick recap

This meeting focused on project updates and discussions about AI tools like Claude and Codex for academic work. Naim announced upcoming grant submissions including a $300K software grant for BATON development and an ARPA-H grant for clinical trial framework infrastructure. The team discussed experiences using Claude and Codex for tasks like manuscript writing, literature reviews, and thesis formatting, with participants sharing tips about using these tools effectively while acknowledging limitations in manuscript writing and the importance of manual review. Tyler provided updates on his work generalizing methods for endoplasmic reticulum data and developing a multimodal expression methylation approach, while Dinelka presented on Bayesian optimization methods for Phase 1 clinical trials, specifically focusing on the U-BOIN design and exploring ways to calibrate parameters for dose selection using both toxicity and efficacy considerations.

### Next steps

**Jialiu (@jialiux22)**
- [ ] Update the repository associated with the paper draft.

**Naim (@naimurashid)**
- [ ] Fix the meeting invite on the calendar so it no longer shows as canceled for the team.
- [ ] Discuss submitting abstracts for JSM (Joint Statistical Meetings) and student paper awards with students during one-on-one meetings.
- [ ] Provide a more in-depth presentation on the ARPA-H digital twin/clinical trial framework grant as it fleshes out.
- [ ] Share the paper agent system with the team once it is ready for testing.
- [ ] Review Jialiu's paper draft and provide feedback.
- [ ] Follow up with Vincent regarding the agenda for the Friday meeting.
- [ ] Look up the BE-BOIN paper/extension to clarify the details on backfilling and late-onset toxicity.
- [ ] Explore if there is real-world data or summary statistics from clinical trials that use calibration/U-BOIN to motivate the need for the proposed calibration method.
- [ ] Create a generic LaTeX/Beamer template repository for UNC dissertations/presentations based on the work started by Amber and others.

**Tyler (@tylerbhumpherys)**
- [ ] Send Naim the materials/items discussed in their sync-up.
- [ ] Continue polishing the introduction and methods for the methylation paper.
- [ ] Work on the multimodal expression-methylation version of the method, addressing convergence issues and testing different feature set sizes.
- [ ] Consider the trade-offs of a two-step feature selection method (unsupervised vs. survival screening) and how to justify it in the paper.

### Summary

#### Conference Submission Opportunities Announcement
Naim announced opportunities for students to submit abstracts and papers for ENR and JSM conferences, suggesting that completed or near-completion work could be submitted for these deadlines in mid-October and November respectively. He explained the difference between invited and contributed sessions, noting that invited sessions require prior proposal and speaker arrangement, while contributed sessions allow regular submissions that are later organized into related sessions. Naim encouraged students to consider submitting their work and discussed the possibility of further discussion about submissions in one-on-one meetings.

#### Grant Applications and Research Updates
Naim provided updates on several grant applications, including a software grant for BATON development and a clinical trials grant focused on adaptive designs. He discussed an ARPA-H opportunity for designing a clinical trial framework infrastructure that aligns well with current work, mentioning he has assembled a clinical team and partners but is still coordinating various components. The team also discussed their experiences with Claude, particularly its usefulness for creating boilerplate templates and managing thesis work, with one team member taking initiative to create a shared repository of templates and resources.

#### AI Tools in Scientific Writing
Naim discussed his experience using AI tools like Codex and Claude for literature reviews, manuscript writing, and presentations, noting that while these tools are helpful for coding and outlining, they still require significant human editing and review, especially for writing introductions and manuscripts. He shared his approach of using a paper agent system he's developing to help with journal-specific formatting and style, which learns from example papers and user feedback to generate better initial drafts. The discussion highlighted that while AI tools can be valuable for research tasks, they currently have limitations in producing high-quality scientific writing that meets journal standards without extensive human refinement.

#### AI Tools Comparison and Setup
Naim discussed the strengths and limitations of Codex and Claude AI tools, noting that Codex excels at implementation and debugging but struggles with planning, while Claude is better at planning and creativity. He shared his setup using automated hooks to review code diffs and manage context resets, particularly for Claude which offers better efficiency with newer models like Opus 5.5. The discussion also covered practical considerations around working with AI tools in cluster environments, including potential security concerns with persistent SSH connections, and concluded with a brief mention of thesis formatting tools.

#### Research Method Development Updates
Naim provided updates on generalizing his method beyond endoplasmic reticulum data and preparing for Monday's meeting. Tyler discussed working on a multimodal expression methylation method, addressing convergence issues and exploring feature set optimization, while also considering a two-step feature selection approach. The team discussed the balance between unsupervised and supervised methods in their research, with guidance on positioning their semi-supervised approach in the context of pure NMF and Cox regression. They also planned for an upcoming meeting on Friday, where Naim will present results and seek clarification on paper requirements and potential data resources.

#### Markdown Document Review Tools
Naim discussed tools for reviewing Markdown documents and code files, specifically mentioning Obsidian as a helpful local editing tool for Markdown files that allows for searching and organizing project notes. He explained that while Obsidian provides good functionality for managing local content, it requires adding files to a vault first for one-time access, which can be inconvenient. The discussion also touched on alternatives like Notion and workarounds for integrating with Microsoft services through Gmail and Chrome extensions due to IT restrictions on certain tools.

#### Phase One Clinical Trials Introduction
Dinelka provided an introduction to a project extending Amber's (@ayoung31) dissertation work on phase 2 trials, focusing on preparing for phase one clinical trials. Dinelka explained the concept of optimal biological dose (OBD) and how traditional phase one trials often fail in later phases due to inadequate toxicity and efficacy relationship assessment. Dinelka detailed the differences between phase one and two trials, including primary objectives, endpoints, and design considerations, noting that FDA's Project Optimus recommends identifying at least two doses for comparison in phase two trials.

#### U-BOIN Clinical Trial Design
Dinelka explained the U-BOIN design, which extends the traditional 3+3 phase 1 clinical trial design by incorporating utility considerations that account for both toxicity and efficacy. Dinelka described how the design uses a multinomial approach with predefined categories and scores, allowing clinicians to specify their preferences for different outcome combinations. Dinelka also outlined the two-stage construction of the U-BOIN setting, where the first stage focuses on exploring toxicity and determining admissible doses before proceeding to the second stage.

#### Phase One Trial Design Strategies
Dinelka discussed phase one trial designs, explaining that sample sizes of 12 are recommended but can vary based on different trials and populations. He outlined three options for dose selection in stage two: randomization, selecting the highest posterior mean utility dose, or adaptive randomization based on utility ratios. Dinelka also covered approaches for handling late onset toxicity and backfilling in phase one trials, mentioning extensions like BF-BOIN and BE-BOIN that address these challenges.

#### Phase 1 Trial Backfilling Challenges
Dinelka discussed the challenges of small sample sizes in Phase 1 trials and explained how backfilling can address this issue by adding more patients without turning them away. Dinelka highlighted that while backfilling provides more information on toxicity and potentially efficacy profiles, its utility in improving dose selection and Phase 2 outcomes depends on specific trial parameters. Dinelka also mentioned recent research that accounts for both backfilling and late-onset toxicity, and Dinelka is exploring new operating characteristics and design parameters that could be calibrated in trials using backfilling.

#### Bayesian Optimization for Phase 1 Trials
Dinelka discussed optimizing backfill strategies for Phase 1 trials using Bayesian optimization and calibration approaches, building on previous work on BATON. The team agreed to start by focusing on the top four operating characteristics that have been studied in U-BOIN settings, with initial optimization of sample size and FTE thresholds. They discussed potentially using data from approved Phase I/II drugs as a more promising approach than traditional Phase I trials using healthy participants, and considered evaluating the effectiveness of calibration methods through real-world data comparison.
