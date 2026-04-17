<!-- Compass template: this file is created from templates/patient/clinical-trials.md during onboarding. Edit freely. -->

# Clinical Trials & Expanded Access

> Active research on treatment options for this patient's case.
> The agent populates and updates this file during `/research` and `/update` passes.
> Trials are grouped by relevance tier and current status.

**Last updated:** {{YYYY-MM-DD}}

> **Status key:**
> - `Active — evaluating`: trial is open and patient eligibility is being assessed
> - `Active — enrolled`: patient is currently enrolled
> - `Applicable — future`: trial not yet relevant but should be revisited if the plan changes
> - `Likely excluded`: patient probably ineligible based on current status
> - `Closed / historical`: trial is no longer enrolling; included for reference
> - `IND / expanded access`: compassionate use or single-patient IND pathway, not a formal trial

> **Regulatory note:** For every trial or expanded access option marked "non-US" or "unapproved," the agent is required to include the regulatory pathway section below. See the evaluator agent prompt for details.

---

## Currently Enrolled

### {{Trial Name}} — {{NCT or IRB number}}

**Status:** `Active — enrolled`
**Phase:** {{Phase I / II / III}}
**Institution:** {{Institution, City}}
**PI:** {{Dr. Name}}
**Trial contact:** {{name@institution.edu / phone}}

**Regimen:**
{{e.g., Ifosfamide-based backbone with sequential targeted drug pairings across 6 cycles. Surgery at Cycle 1 / Cycle 2 boundaries. All treatment at enrolling institution; weekly visits required.}}

| Cycle | Agents | Notes |
|---|---|---|
| Cycle 1 | {{e.g., Drug A + Drug B}} | {{}} |
| Surgery 1 | {{e.g., Primary site resection}} | {{}} |
| Cycle 2 | {{e.g., Drug A + Drug C}} | {{}} |
| Cycle 3+ | {{e.g., Drug A alone}} | {{}} |

**Eligibility constraints:**
- {{e.g., Must not have started chemotherapy more than 22 days before trial opens}}
- {{e.g., All treatment must be local — weekly site visits required}}

**Enrollment date:** {{YYYY-MM-DD}}
**Correlative studies:** {{e.g., Blood draws for cfDNA and CTC at specified timepoints; CBC/CMP biweekly}}

---

## Under Active Evaluation

### {{Trial Name}} — {{NCT number}}

**Status:** `Active — evaluating`
**Phase:** {{Phase I / II}}
**Institution:** {{Institution, City}}
**PI / contact:** {{Dr. Name — contact@institution.edu}}

**Regimen:** {{Brief description — agents, route, schedule}}

**Eligibility fit:**
- **Favorable:** {{e.g., Age and diagnosis match; measurable disease present}}
- **Uncertain:** {{e.g., Prior chemotherapy exposure — confirm eligibility with trial coordinator}}
- **Unfavorable:** {{e.g., Requires NED status; patient has active disease}}

**Mechanism / rationale:** {{e.g., Combines checkpoint inhibitor with a TKI that reprograms the tumor microenvironment — increases CD8+ T-cell infiltration and reduces immune suppression. Rationale strongest when VEGF/MET/AXL pathways are elevated.}}

**Evidence base:** {{e.g., Prior single-arm trial: 12% ORR, 33% disease control at 6 months. No OS benefit demonstrated.}}

**Next step:** {{e.g., Confirm eligibility — call trial coordinator by YYYY-MM-DD}}

---

## Applicable — Future (Revisit If Plan Changes)

### {{Trial Name}} — {{NCT number}}

**Status:** `Applicable — future`
**Best timing:** {{e.g., After achieving surgical NED from lung metastases}}
**Key constraint:** {{e.g., Requires complete resection of all metastatic disease and NED status; no concurrent agents}}
**Institution:** {{Institution, City}}

**Brief summary:** {{e.g., Single-agent immunostimulant therapy. Phase II data from small pilot study: median progression-free survival substantially longer than etoposide control arm. Very small numbers — interpret with caution.}}

**Action:** {{e.g., Monitor — revisit eligibility after lung surgery if NED achieved}}

---

### {{Trial Name}} — {{NCT number}}

**Status:** `Applicable — future`
**Best timing:** {{e.g., Post-chemotherapy — requires measurable residual disease}}
**Key constraint:** {{e.g., Requires lymphodepleting chemotherapy before infusion; cannot combine with active chemo}}
**Institution:** {{Institution, City}}
**Phase:** {{Phase I}}

**Brief summary:** {{e.g., Cell therapy targeting a surface antigen highly expressed in this tumor type. Requires biopsy-confirmed expression. Phase I dose-escalation; no published interim results.}}

**Molecular eligibility:** {{e.g., Surface target expression — confirmed by transcriptome data; IHC staining recommended to confirm protein expression before enrollment discussion}}

**Action:** {{e.g., Request IHC staining; contact trial coordinator to get on waitlist}}

---

## IND / Expanded Access Options

### {{Agent Name}} — Single-Patient IND / Expanded Access

**Status:** `IND / expanded access`
**Sponsor / manufacturer:** {{Company or institution name}}
**Sponsor contact:** {{name@company.com}}
**Pathway:** {{e.g., Single-patient expanded access IND — sponsoring oncologist files FDA paperwork; manufacturer supplies drug}}

**Evidence:**
- {{e.g., Phase IIb trial: primary endpoint met — 12-month event-free survival 33–35% vs. ~20% historical control}}
- {{e.g., Single-arm study; historical control matched from limited patient database — interpret cautiously}}

**Regulatory status:** {{e.g., Not yet FDA-approved; Phase III planning underway; rolling BLA submitted}}
**Regulatory pathway:** {{e.g., FDA 21 CFR Part 312 single-patient IND. Treating physician is the sponsor. Manufacturer provides drug at no cost and supplies letter of support + treatment guidelines. FDA Project Facilitate (240-402-0004) can expedite.}}

**Current status:** {{e.g., Treating physician has initiated IND process; drug confirmed available at no cost from manufacturer}}
**Applicable when:** {{e.g., After achieving NED status following surgical resection of all metastatic disease}}

---

### {{Agent Name}} — Off-Label Maintenance

**Status:** `IND / expanded access`
**Pathway:** {{e.g., Off-label prescription — no IND required for approved drugs used outside labeled indication}}

**Rationale:** {{e.g., Multiple centers use this agent as maintenance after salvage chemotherapy. No randomized data specifically for this combination, but phase II data in this tumor type shows disease control benefit.}}

**Caution:** {{e.g., This agent impairs wound healing — must be held for 1–2 weeks before any surgical procedure. Port-site wound complications have been reported when initiated too close to surgery.}}

---

## Closed / Historical Reference

### {{Trial Name}} — {{NCT number}}

**Status:** `Closed / historical`
**Notes:** {{e.g., Trial closed to enrollment. Published results showed no objective responses after first infusion. Included here because results inform interpretation of similar trials in this drug class.}}

---

## Eligibility Matrix

> Quick reference table — current status snapshot.

| Trial / Option | Best timing | Key constraint | Current status |
|---|---|---|---|
| {{Trial A}} | {{e.g., During active treatment}} | {{e.g., Weekly site visits required}} | **Enrolled** |
| {{Trial B}} | {{e.g., Before definitive surgery}} | {{e.g., Measurable disease required; no prior chemo}} | Likely excluded |
| {{Trial C}} | {{e.g., After surgical NED}} | {{e.g., Complete resection required; no concurrent agents}} | Applicable — future |
| {{Trial D — cell therapy}} | {{e.g., Post-chemotherapy}} | {{e.g., Surface target IHC confirmation; lymphodepletion required}} | Applicable — future |
| {{Agent X — expanded access}} | {{e.g., After NED}} | {{e.g., IND in process}} | IND in process |
| {{Trial E}} | {{e.g., Second relapse}} | {{e.g., Phase I; palliative intent}} | Future option |

---

## Key Trial Contacts

| Name | Role | Institution | Contact |
|---|---|---|---|
| {{Dr. Name}} | {{Trial PI}} | {{Institution}} | {{email / phone}} |
| {{Dr. Name}} | {{Compassionate use contact}} | {{Sponsor company}} | {{email}} |
| {{FDA Project Facilitate}} | {{Expedited expanded access}} | FDA | {{240-402-0004 / OncProjectFacilitate@fda.hhs.gov}} |

---

*Last updated: {{YYYY-MM-DD}}*
