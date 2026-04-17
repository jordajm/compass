<!-- Compass template: this file is created from templates/patient/case-timeline.md during onboarding. Edit freely. -->

# Case Timeline

> Chronological record of every significant event from first symptoms through the present.
> The agent appends new events automatically after each `/update` pass.
> Use this file to quickly orient a new specialist, reconstruct the sequence of decisions, or identify gaps.

---

## Timeline

> Event types: `diagnosis` | `treatment` | `surgery` | `scan` | `lab` | `consultation` | `decision-point` | `trial` | `milestone`

### Phase 1: Initial Presentation and Diagnosis

| Date | Event type | Event | Location | Notes |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | `scan` | {{e.g., MRI primary site — initial diagnostic imaging}} | {{Institution, City}} | {{e.g., Aggressive lesion identified; malignancy suspected}} |
| {{YYYY-MM-DD}} | `scan` | {{e.g., CT chest — baseline staging}} | {{Institution, City}} | {{e.g., No pulmonary metastases}} |
| {{YYYY-MM-DD}} | `scan` | {{e.g., PET/CT whole body — baseline staging}} | {{Institution, City}} | {{e.g., SUVmax X at primary site; no distant disease}} |
| {{YYYY-MM-DD}} | `diagnosis` | {{e.g., Core needle biopsy — diagnosis confirmed}} | {{Institution, City}} | {{e.g., High-grade malignancy confirmed; molecular panel ordered}} |
| {{YYYY-MM-DD}} | `lab` | {{e.g., Comprehensive molecular panel ordered}} | {{Lab, Institution}} | {{e.g., Results reported YYYY-MM-DD — see molecular.md}} |

---

### Phase 2: First-Line Treatment

| Date | Event type | Event | Location | Notes |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | `treatment` | {{e.g., First chemotherapy — Cycle 1}} | {{Institution, City}} | {{e.g., Protocol X begins}} |
| {{YYYY-MM-DD}} | `treatment` | {{e.g., Chemotherapy — Cycle 2}} | {{Institution, City}} | {{}} |
| {{YYYY-MM-DD}} | `scan` | {{e.g., Pre-surgical CT chest}} | {{Institution, City}} | {{e.g., No new metastatic disease}} |
| {{YYYY-MM-DD}} | `scan` | {{e.g., Pre-surgical MRI primary site}} | {{Institution, City}} | {{e.g., Decreased enhancement — probable treatment effect}} |
| {{YYYY-MM-DD}} | `decision-point` | {{e.g., Surgical team consultation — limb salvage vs. amputation}} | {{Institution, City}} | {{e.g., Limb salvage recommended; surgery scheduled}} |
| {{YYYY-MM-DD}} | `surgery` | {{e.g., Surgical resection of primary tumor}} | {{Institution, City}} | {{e.g., Margins negative; 25% necrosis — poor histologic response; see treatment-history.md}} |
| {{YYYY-MM-DD}} | `lab` | {{e.g., Surgical pathology signed out}} | {{Institution, City}} | {{e.g., See treatment-history.md for full report}} |
| {{YYYY-MM-DD}} | `treatment` | {{e.g., Post-surgical chemotherapy resumes — Cycle 3}} | {{Institution, City}} | {{}} |
| {{YYYY-MM-DD}} | `treatment` | {{e.g., Final chemotherapy}} | {{Institution, City}} | {{e.g., End of first-line protocol}} |

---

### Phase 3: Post-Treatment Surveillance

| Date | Event type | Event | Location | Notes |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | `scan` | {{e.g., 3-month post-treatment CT chest + X-ray}} | {{Institution, City}} | {{e.g., No evidence of disease}} |
| {{YYYY-MM-DD}} | `scan` | {{e.g., 6-month post-treatment CT chest + X-ray}} | {{Institution, City}} | {{e.g., No visible lesion — retrospectively a small nodule was present on later reread}} |
| {{YYYY-MM-DD}} | `milestone` | {{e.g., 6-month post-treatment — surveillance imaging}} | {{Institution, City}} | {{e.g., Team decided to skip MRI due to hardware artifact concerns — see considerations.md}} |

> **Surveillance gap note:** Any time a scheduled surveillance test is skipped or modified, log it in `patient/considerations.md` as a risk entry — including the rationale and any researched alternatives. This is one of the most important proactive behaviors the agent is designed to support.

---

### Phase 4: Relapse / Progression

| Date | Event type | Event | Location | Notes |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | `scan` | {{e.g., 9-month post-treatment CT chest — CRITICAL}} | {{Institution, City}} | {{e.g., New pulmonary nodules — concerning for metastasis}} |
| {{YYYY-MM-DD}} | `scan` | {{e.g., PET/CT whole body — relapse staging}} | {{Institution, City}} | {{e.g., Local recurrence suspected — SUVmax X at primary site; lung lesions suspicious}} |
| {{YYYY-MM-DD}} | `diagnosis` | {{e.g., Core needle biopsy of recurrence site}} | {{Institution, City}} | {{e.g., Malignancy confirmed — local recurrence}} |
| {{YYYY-MM-DD}} | `lab` | {{e.g., Relapse biopsy pathology signed out}} | {{Institution, City}} | {{e.g., Consistent with prior histology; molecular panel pending}} |
| {{YYYY-MM-DD}} | `decision-point` | {{e.g., Second-line treatment planning}} | {{Institution, City}} | {{e.g., Evaluating: clinical trial vs. standard salvage chemotherapy}} |

---

### Phase 5: Second-Line Treatment

| Date | Event type | Event | Location | Notes |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | `consultation` | {{e.g., Specialist consultation — second-line options}} | {{Remote / Institution}} | {{e.g., See consultation-log.md}} |
| {{YYYY-MM-DD}} | `trial` | {{e.g., Enrolled in clinical trial NCT-XXXXXXXX}} | {{Institution, City}} | {{e.g., PI: Dr. Name; ifosfamide + sequential targeted agents}} |
| {{YYYY-MM-DD}} | `treatment` | {{e.g., Second-line treatment begins — Cycle 1}} | {{Institution, City}} | {{e.g., Per trial schedule}} |
| {{YYYY-MM-DD}} | `surgery` | {{e.g., Surgery 1 — primary site}} | {{Institution, City}} | {{e.g., Tissue allocation per biobanking plan}} |
| {{YYYY-MM-DD}} | `surgery` | {{e.g., Surgery 2 — metastasis resection (planned)}} | {{Institution, City}} | {{e.g., Estimated; bilateral disease — staged approach}} |

---

## Key Dates Summary

| Milestone | Date |
|---|---|
| First symptoms / initial presentation | {{YYYY-MM-DD}} |
| Biopsy / diagnosis confirmed | {{YYYY-MM-DD}} |
| First treatment | {{YYYY-MM-DD}} |
| Surgical resection | {{YYYY-MM-DD}} |
| End of first-line treatment | {{YYYY-MM-DD}} |
| First surveillance scan clear | {{YYYY-MM-DD}} |
| Relapse / progression confirmed | {{YYYY-MM-DD}} |
| Second-line treatment begins | {{YYYY-MM-DD}} |
| Current date | {{YYYY-MM-DD}} |

---

## Source Documents

- `documents/{{filename}}.pdf` — {{e.g., Clinical notes through Month YYYY}}
- `documents/{{filename}}.pdf` — {{e.g., Pathology reports}}
- `patient/scan-history.md` — Full imaging detail
- `patient/treatment-history.md` — Full treatment detail
- `patient/consultation-log.md` — Full consultation detail

---

*Last updated: {{YYYY-MM-DD}}*
