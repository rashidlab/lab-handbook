# Lab Meeting - 2026-05-07

**Lead:** @dinelka97
**Time:** Thursday, May 7, 2026 · 9:30–11:00 AM ET
**Location:** LCCC 20-023 / Microsoft Teams
**Presenter:** @dinelka97 — Bayesian framework for subtyping pancreatic cancer using evRNA-seq

### Attendees
- [x] @naimurashid
- [x] @ayoung31 (Amber)
- [x] @dinelka97 (Dinelka)
- [x] @tylerbhumpherys (Tyler)
- [x] @andrew-walther (Andrew)

---

## Quick Recap

Dinelka presented his Bayesian framework for subtyping pancreatic cancer using evRNA-seq data, which aims to predict tumor subtypes from blood samples rather than invasive biopsies. The discussion covered the technical details of the model, including how it handles missing data in evRNA-seq samples and leverages bulk RNA-seq data for reference. The group provided feedback on improving the presentation, suggesting visual aids and clarifications about model assumptions. Other lab members shared updates on their current work, including Andrew's progress on cross-validation for survival analysis and Amber's dissertation preparations. The conversation ended with a decision to switch to virtual meetings starting in June due to Naim's travel to Sri Lanka.

Naim contributed comments and suggestions throughout the presentation (model formulation, missingness assumptions, cross-validation strategy, identifiability, and uncertainty quantification — see Discussion Summary below).

---

## Decisions Made

- [x] Switch to virtual (Zoom) meetings starting June 2026 while Naim is in Sri Lanka
- [x] Plan an in-person get-together for Amber before her dissertation defense (target: before 2026-06-26)
- [x] Onboard Alex (new lab member) to the lab repo, handbook, and rotation schedule

---

## Discussion Summary

### Lab Updates and AI Adoption

Naim announced that Alex has officially joined the lab and will be working with him and David Zay on virtual cell modeling using spatial data. Training grant renewal received a **2 percentile** score, indicating a strong chance of funding despite NIH's new review criteria. Naim mentioned an upcoming ASA webinar on AI adoption in academia, which he will present alongside Tian Zheng; AI usage varies significantly among faculty by role and experience, with coding-heavy work benefiting more from AI tools.

### AI Implementation Challenges (Discussion)

The group discussed challenges around AI implementation in companies. Amber shared mixed perspectives from her network on how AI should be used. Naim gave examples of AI being mandated in industry roles (e.g., Meta tying AI use to bonuses), emphasizing that AI is better suited for automating routine tasks rather than replacing high-level thinking jobs. The team agreed to switch to virtual meetings starting in June due to Naim's travel to Sri Lanka, and discussed planning a celebration for Amber's upcoming dissertation defense on 2026-06-26.

### Dinelka — Bayesian Pancreatic Cancer Subtyping Framework (evRNA-seq)

Dinelka presented his project developing a Bayesian framework for subtyping pancreatic cancer using **evRNA-seq** data. The goal is to predict molecular subtypes from non-invasive liquid biopsies, since current methods rely on bulk RNA-seq data which is not directly suitable for evRNA-seq due to high levels of missing data. The project uses a Bayesian latent factor approach to reduce the dimensionality of gene expression data from both bulk RNA-seq and evRNA-seq, leveraging a small sample size of **40 matched pairs** and publicly available PDAC bulk RNA data.

#### Modeling Approach & Presentation Planning

Dinelka and Amber discussed using PowerPoint slides to present an overview of the modeling approach; Amber agreed to send an example (flowchart / "figure one" from her DSERV method paper). The group explored using flowcharts and labeled diagrams to communicate methodology more effectively. The joint modeling approach leverages cross-sample correlations from bulk RNA data to inform evRNA-seq analysis in a sparse environment. The two datasets have different sample sizes but share the same gene dimensions; the paired bulk and plasma samples can be used to improve predictions.

#### Plasma evRNA-seq Data Challenges

Dinelka discussed challenges with plasma evRNA-seq being more sparse than bulk due to limited genetic material in blood samples, which makes subtyping and detection more difficult. **Naim's suggestion:** augment known correlations from bulk data to fill gaps in plasma data by selecting the top **~200 common genes** across both sources. The discussion focused on establishing a relationship between **W_S** (gene loadings from bulk RNA) and **W_T** (gene loadings from plasma evRNA) through latent factors, with the assumption that these factors should be similar across paired samples. New latent factors need to be estimated for unpaired samples; **Naim proposed** a pairing indicator variable to distinguish constrained vs. unconstrained relationships between the two data sources.

#### Bayesian Model Fitting Approaches

Dinelka discussed implementing a Bayesian approach for model fitting, including latent factors and cross-validation. **Naim's input:** while traditional cross-validation could be applied, Bayesian-specific methods like **expected log predictive density (ELPD)** could be used instead. The approach could be made more complex by sampling the number of factors from a prior distribution, though this would increase computational complexity. Naim pointed to a recent paper on patient cross-validation that provides a simplified approach for model fitting without requiring complete re-computation of MCMC chains for each fold.

#### Handling Uncertainty in Prediction Models

**Naim's comments** centered on uncertainty and cutoff selection: highlighted **conformal prediction** as a framework for obtaining uncertainty estimates; discussed trade-offs between informative vs. non-informative priors in Bayesian models (efficiency vs. needing to justify assumptions). The missingness model for plasma gene expression treats missingness as likely due to lower yield and stochastic sampling of blood-based tests compared to bulk RNA-seq. Dinelka outlined the data generation process, including the role of missingness and its impact on observed data.

#### Semi-Supervised RNA Classification Framework

Dinelka discussed extending to a semi-supervised framework for subtype classification using paired bulk RNA and evRNA data — the model can handle samples without known subtypes by leveraging learned relationships between the two modalities from paired samples. On power analysis: traditional power calculations are challenging for prediction-oriented studies, but **Naim suggested** indirect approaches to assess model performance and gene selection. The discussion concluded with model identifiability issues and a **Match Align** algorithm used to address column switching and sign changes in the Z and W matrices.

#### Bayesian Framework for Missing Data

Dinelka walked through the Bayesian framework for handling missing data in evRNA samples — how the model uses latent factors and rotation techniques to align and predict subtypes. The team discussed simulation results and potential improvements to the missingness model, with **suggestions to compare against random forest** approaches and explore alternative classification methods.

### Round Robin Updates

- **Andrew:** Working on cross-validation updates and model parameterization for survival analysis. Will bring specific issues/questions to the next meeting for group review if needed.
- **Amber:** Dissertation preparations underway; defense on 2026-06-26.
- **Tyler:** Literature reviews for cell simulation projects; will present updated experiment framework on Monday.

---

## Action Items

| Task | Assignee | Due Date | Status |
|------|----------|----------|--------|
| Send example PowerPoint slides (flowchart / figure one from DSERV method) to Dinelka for visual presentation of the modeling framework | @ayoung31 | 2026-05-14 | [ ] |
| Bring specific cross-validation / model parameterization questions to next meeting for group review | @andrew-walther | 2026-05-21 | [ ] |
| Onboard Alex to the lab repo, add to the lab handbook, and add to the rotation schedule when the new cycle starts | @naimurashid | 2026-05-21 | [ ] |
| Coordinate get-together for Amber's dissertation (before her defense, before 2026-06-26); follow up with group to finalize timing and location (potentially at Naim's house) | @naimurashid | 2026-06-19 | [ ] |
| Update the recurring lab meeting invite to include the Zoom link and confirm virtual meetings starting in June | @naimurashid | 2026-05-28 | [ ] |
| Present updated experiment framework/presentation to the group | @tylerbhumpherys | 2026-05-11 | [ ] |

---

## Parking Lot

- Comparison of Dinelka's Bayesian framework against random forest baseline
- Alternative classification methods for evRNA-seq subtyping
- Formalizing the pairing indicator variable for constrained vs. unconstrained samples
- Power analysis approaches for prediction-oriented Bayesian studies

---

## Next Meeting

- **Date:** 2026-05-21
- **Lead:** @jialiux22
- **Presenter(s):** @jialiux22
- **Format:** Virtual (Zoom) — confirming switch to virtual starting June
