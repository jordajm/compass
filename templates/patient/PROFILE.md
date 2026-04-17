<!-- Compass template: this file is created from templates/patient/PROFILE.md during onboarding. Edit freely. -->

# Patient Profile

> This is the anchor document for the entire case. Every other file refers back to this one.
> Fill in each section during or after onboarding. The agent reads this file at the start of every session.

---

## Patient

| Field | Value |
|---|---|
| **Full name** | {{Patient Full Name}} |
| **Date of birth** | {{YYYY-MM-DD}} |
| **Current age** | {{Age}} <!-- Compass will auto-calculate from DOB each session --> |
| **Sex / pronouns** | {{e.g., Female / she-her}} |
| **Country of residence** | {{e.g., United States}} <!-- Used for regulatory-jurisdiction resolution --> |
| **State / province** | {{e.g., Colorado, USA}} |

---

## Primary Diagnosis

| Field | Value |
|---|---|
| **Primary diagnosis** | {{e.g., High-grade sarcoma of the right distal femur}} |
| **Histologic subtype** | {{e.g., Osteoblastic; or "unknown — pending pathology"}} |
| **Staging / grading** | {{e.g., Stage IIB; Grade 3/3}} |
| **Date of diagnosis** | {{YYYY-MM-DD}} |
| **Diagnosing institution** | {{e.g., Children's Hospital — City, State}} |
| **Primary treating institution** | {{e.g., University Medical Center — City, State}} |

---

## Molecular / Genomic Summary

> Full detail lives in `patient/molecular.md`. Summarize key actionable findings here so this file is self-contained for quick reference.

| Finding | Relevance |
|---|---|
| {{e.g., Gene fusion — see molecular.md}} | {{e.g., Potentially targetable with a specific drug class}} |
| {{e.g., TMB — Low}} | {{e.g., Does not support checkpoint immunotherapy}} |
| {{e.g., MSI — Stable}} | {{e.g., No hypermutator phenotype}} |

**Link:** See `patient/molecular.md` for the full test log, all findings, and IC50 comparisons.

---

## Travel Willingness

> This determines which clinical trials and specialist consultations the agent will include in research output.

- [ ] Local only (within driving distance)
- [ ] Regional (same country, willing to travel within region)
- [x] National (anywhere within home country)
- [ ] International (willing to travel abroad for the right option)

**Notes:** {{e.g., Can travel to major cancer centers; international travel feasible if medically warranted}}

---

## Insurance & Budget Posture

> This is a sensitive section. Fill in only what is helpful. The agent uses this to filter recommendations toward what is realistic.
> You can skip this section entirely — the agent will ask if it needs to make a recommendation that depends on cost.

| Field | Value |
|---|---|
| **Insurance coverage** | {{e.g., Private insurance through employer; covers standard of care and most clinical trials}} |
| **Insurance gaps** | {{e.g., Does not cover experimental therapies; international treatments not covered}} |
| **Self-funded budget (rough range)** | {{e.g., Willing to consider up to $X for options not covered by insurance — or leave blank}} |
| **Notes** | {{e.g., Would consider expanded access if drug is supplied at no cost by manufacturer}} |

> **Privacy note:** This information stays in your local case folder and is never transmitted externally.

---

## Primary User

> The person who set up Compass and holds the "primary-caregiver" role on the care team.

| Field | Value |
|---|---|
| **Name** | {{Your Full Name}} |
| **Relationship to patient** | {{e.g., Parent, Guardian, Spouse, Self}} |
| **Email** | {{your@email.com}} |
| **Timezone** | {{e.g., America/Denver}} |

---

## Case Phase & Tier

> Compass uses a two-axis framework to calibrate research and recommendations.
> The agent updates these fields during `/update` when significant new information changes the case status.

### Phase (where the case is in its lifecycle)

- [ ] **Phase 0 — Lead search**: No primary specialist yet; agent helps identify candidates.
- [ ] **Phase 1 — Team build**: Lead in place; building the surrounding team.
- [ ] **Phase 2 — Plan establishment**: Active treatment plan being developed.
- [x] **Phase 3 — Execution & monitoring**: Plan is in flight; agent watches for gaps and risks.
- [ ] **Phase 4 — First-principles re-planning**: Prior plan not working; escalating to unconventional options.

**Phase notes:** {{e.g., Currently in active treatment; surveillance begins after completion}}

### Tier (how far from conventional the recommendation set has moved)

- [x] **Tier 1 — Standard of care + established trials**: First-line guidelines, Phase II+ trials.
- [ ] **Tier 2 — Extended options**: Compassionate use, Phase I trials, off-label with preclinical support.
- [ ] **Tier 3 — First-principles**: Molecular-match reasoning beyond labeled indications; case reports as evidence.

**Tier notes:** {{e.g., Starting at Tier 1; Tier 2 options being researched in parallel}}

---

## Last Updated

{{YYYY-MM-DD}} — {{brief description of what changed, e.g., "Updated phase to 3 after treatment began"}}
