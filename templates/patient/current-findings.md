<!-- Compass template: this file is created from templates/patient/current-findings.md during onboarding. Edit freely. -->

# Current Findings

> This file captures the most recent clinical picture: latest scans, labs, organ function, and active findings.
> The agent updates this file after each `/update` pass that ingests new data.
> It is read first at the start of any research or evaluation task to establish current disease status.

**Last updated:** {{YYYY-MM-DD}}
**Updated by:** {{Compass /update — or manual edit by {{name}}}}

---

## Summary (Plain Language)

> 2–4 sentence summary of where things stand right now. Written for a non-specialist reader.
> The agent drafts this; edit freely to add context or nuance.

{{e.g., As of [date], [patient name] has [diagnosis] with [current disease status — e.g., confirmed local recurrence at the primary site and bilateral pulmonary metastases]. The most recent CT chest on [date] showed [key finding]. Treatment is currently [active / on hold / being planned]. The next key milestone is [e.g., surgical pathology results / next scan / next treatment cycle].}}

---

## Active Disease Sites

> Table of every known or suspected disease site, updated after each new scan.

| Site | Finding | Last assessed | Modality | Status |
|---|---|---|---|---|
| {{e.g., Primary site — right distal femur}} | {{e.g., Post-surgical; no evidence of residual disease}} | {{YYYY-MM-DD}} | {{MRI}} | {{Clear / Suspected recurrence / Confirmed recurrence}} |
| {{e.g., Right lung}} | {{e.g., 1.6 × 1.0 cm nodule with calcification — growing}} | {{YYYY-MM-DD}} | {{CT}} | {{Metastasis — growing}} |
| {{e.g., Left lung}} | {{e.g., 4 new subcentimeter nodules}} | {{YYYY-MM-DD}} | {{CT}} | {{New metastatic lesions}} |
| {{e.g., Regional lymph nodes}} | {{e.g., Mildly enlarged right inguinal nodes — indeterminate}} | {{YYYY-MM-DD}} | {{PET/CT}} | {{Indeterminate — follow-up required}} |

---

## Most Recent Imaging

> One subsection per recent scan. Most recent first.

### {{YYYY-MM-DD}} — {{Modality}}, {{Body Region}}

**Institution:** {{e.g., Major Cancer Center, City}}
**Radiologist:** {{Dr. Name}}
**Comparison:** {{Prior study date}}

**Key findings:**
- {{e.g., Right lung: known lesion increased from 1.1 × 0.6 cm to 1.6 × 1.0 cm — growing}}
- {{e.g., Left lung: 4 new subcentimeter nodules — new bilateral disease}}
- {{e.g., No pleural effusion; no mediastinal adenopathy}}

**Impression:**
1. {{e.g., Interval growth of right pulmonary metastasis}}
2. {{e.g., New left lung pulmonary metastases — bilateral progression}}

---

### {{YYYY-MM-DD}} — {{Modality}}, {{Body Region}}

**Institution:** {{Institution}}
**Radiologist:** {{Dr. Name}}
**Comparison:** {{Prior study}}

**Key findings:**
- {{e.g., Primary site: soft tissue lesion measuring X cm at posterior aspect of hardware — concerning for recurrence}}
- {{e.g., SUVmax 7.8 at primary site}}

**Impression:**
1. {{e.g., Findings concerning for local recurrence — biopsy recommended}}

---

## Most Recent Labs

> Key lab values from the most recent draw. Add more rows as relevant to the specific case.

**Lab date:** {{YYYY-MM-DD}}
**Drawn at:** {{Institution or outpatient lab}}

| Test | Value | Reference range | Trend | Notes |
|---|---|---|---|---|
| WBC | {{e.g., 3.2 K/µL}} | {{4.5–11.0}} | {{↓ from 4.1}} | {{e.g., Nadir expected Day 10–14 post-chemo}} |
| ANC | {{e.g., 1.8 K/µL}} | {{≥1.5}} | {{Stable}} | {{}} |
| Hemoglobin | {{e.g., 9.8 g/dL}} | {{12–16}} | {{↓}} | {{e.g., Transfusion not yet required}} |
| Platelets | {{e.g., 112 K/µL}} | {{150–400}} | {{↓}} | {{}} |
| Creatinine | {{e.g., 0.7 mg/dL}} | {{0.5–1.0}} | {{Stable}} | {{e.g., Renal function normal}} |
| ALT | {{e.g., 45 U/L}} | {{7–56}} | {{↑ from 28}} | {{e.g., Monitor; was higher during prior cycle}} |
| LDH | {{e.g., 180 U/L}} | {{140–280}} | {{Stable}} | {{e.g., Tumor marker of interest in some sarcomas}} |
| Phosphate | {{e.g., 4.2 mg/dL}} | {{2.5–4.5}} | {{↑}} | {{e.g., Relevant biomarker for certain targeted therapies — monitor if on applicable TKI}} |

---

## Organ Function Summary

> Summarizes key functional constraints for treatment planning.
> Updated when new echo, audiology, PFT, or renal function results arrive.

| Organ system | Status | Last assessed | Notes |
|---|---|---|---|
| **Cardiac (EF)** | {{e.g., EF 60% — normal}} | {{YYYY-MM-DD}} | {{e.g., Monitor; anthracycline exposure}} |
| **Renal (GFR/Cr)** | {{e.g., Normal — Cr 0.7}} | {{YYYY-MM-DD}} | {{e.g., Cisplatin exposure — continue monitoring}} |
| **Hearing (audiogram)** | {{e.g., Mild high-frequency loss — Grade 1}} | {{YYYY-MM-DD}} | {{e.g., Cisplatin ototoxicity; document before further platinum}} |
| **Pulmonary (PFTs)** | {{e.g., Not assessed / Normal}} | {{YYYY-MM-DD}} | {{}} |
| **Liver (transaminases)** | {{e.g., Mildly elevated ALT — monitoring}} | {{YYYY-MM-DD}} | {{}} |

---

## Most Recent Pathology

> Summarize the most recent biopsy or surgical pathology result.

**Specimen:** {{e.g., Core needle biopsy — right posterior distal femur, soft tissue}}
**Date collected:** {{YYYY-MM-DD}}
**Signed out:** {{YYYY-MM-DD}}
**Pathologist:** {{Dr. Name, Institution}}
**Accession:** {{LAB-XXXXX}}

**Diagnosis:** {{e.g., High-grade sarcoma, compatible with local recurrence. Histology identical to original diagnostic biopsy.}}

**Key pathologic features:**
- Histologic type: {{e.g., Extraskeletal — recurrent}}
- Mitotic rate: {{e.g., 4 per 10 HPF}}
- Necrosis: {{e.g., Present — ~10%}}
- Lymphovascular invasion: {{e.g., Not identified}}
- Molecular studies: {{e.g., NGS (DNA+RNA) — results pending / see molecular.md}}

---

## Pending Results

> Tests that have been ordered but not yet resulted. The agent checks this list during `/update`.

| Test | Ordered | Institution | ETA | Contact |
|---|---|---|---|---|
| {{e.g., NGS DNA+RNA on relapse biopsy}} | {{YYYY-MM-DD}} | {{Lab / Institution}} | {{e.g., ~2 weeks}} | {{e.g., Dr. Name or lab coordinator}} |
| {{e.g., Comprehensive genomic profiling (external lab)}} | {{YYYY-MM-DD}} | {{Lab name}} | {{e.g., ~4 weeks}} | {{e.g., contact@lab.com}} |

---

## Open Clinical Questions

> Questions that need answers before the next decision point. Updated by the agent or primary user.

1. {{e.g., Does the current treatment regimen show response at the primary site? Next scan: YYYY-MM-DD}}
2. {{e.g., Are the lung nodules progressing? Bilateral — is surgery still possible?}}
3. {{e.g., Pending NGS results — does the molecular target persist at relapse?}}

**See also:** `patient/considerations.md` for proactive flags and risks being tracked.

---

*Last updated: {{YYYY-MM-DD}}*
