<!-- Compass template: this file is created from templates/patient/treatment-history.md during onboarding. Edit freely. -->

# Treatment History

> Chronological record of all treatments received. The agent uses this file to understand what has
> already been tried, cumulative toxicity constraints, and what options remain viable.
> Add a new phase section each time the treatment plan changes significantly.

---

## Overview

> Brief summary paragraph — written or updated by the agent after each major phase change.
> Example: "Patient received first-line chemotherapy from [date] through [date] with [response].
> Surgery was performed on [date] with [margin/necrosis result]. As of [date], [status]."

{{Compass will draft this summary after ingesting treatment records. Edit freely.}}

---

## Phase 1: {{Phase Name, e.g., Pre-Surgical Chemotherapy}}

**Date range:** {{YYYY-MM-DD}} to {{YYYY-MM-DD}}
**Protocol / regimen:** {{e.g., Standard first-line chemotherapy per COG protocol, or "MAP: methotrexate + doxorubicin + cisplatin"}}
**Treating institution:** {{Institution name, city}}
**Primary oncologist:** {{Dr. Name, title}}

### Treatment Cycles

| Date | Agent(s) | Dose / Notes |
|---|---|---|
| {{YYYY-MM-DD}} | {{e.g., Cisplatin + Doxorubicin (Cycle 1)}} | {{e.g., Standard dosing; first treatment}} |
| {{YYYY-MM-DD}} | {{e.g., High-dose methotrexate}} | {{}} |
| {{YYYY-MM-DD}} | {{e.g., Cisplatin + Doxorubicin (Cycle 2)}} | {{}} |

### Complications During This Phase

- {{e.g., Hospitalized once for fever and neutropenia following Cycle 1}}
- {{e.g., Catheter-associated thrombus — started on anticoagulation}}
- {{e.g., Transaminitis — monitored}}

### Response Assessment

| Imaging / Assessment | Date | Finding |
|---|---|---|
| {{e.g., CT Chest}} | {{YYYY-MM-DD}} | {{e.g., No evidence of metastatic disease}} |
| {{e.g., MRI primary site}} | {{YYYY-MM-DD}} | {{e.g., Increased mineralization, decreased enhancement — probable treatment effect}} |
| {{e.g., PET/CT}} | {{YYYY-MM-DD}} | {{e.g., SUVmax decreased from X to Y — significant treatment response}} |

---

## Phase 2: {{Phase Name, e.g., Surgical Resection}}

**Date:** {{YYYY-MM-DD}}
**Institution:** {{Institution name, city}}
**Surgeon(s):** {{Dr. Name — role; Dr. Name — role}}

### Procedure

{{Brief description of the surgery. Example: "Definitive surgical resection of primary tumor with limb-salvage reconstruction. Internalized lengthening device inserted."}}

### Surgical Pathology

| Parameter | Finding |
|---|---|
| **Histologic type** | {{e.g., High-grade sarcoma}} |
| **Histologic grade** | {{e.g., Grade 3/3}} |
| **Tumor size** | {{e.g., 11.0 x 6.5 x 4.5 cm}} |
| **Treatment response (necrosis)** | {{e.g., 25% necrosis — poor histologic response (Grade I/IV). Good response is ≥90%.}} |
| **Surgical margins** | {{e.g., Negative for tumor; closest margin 1.35 mm}} |
| **Lymphovascular invasion** | {{e.g., Not identified}} |
| **TNM staging (post-treatment)** | {{e.g., pT2, pN not assigned, pM cannot be determined}} |

**Key interpretation:** {{e.g., 25% necrosis is classified as poor histologic response, associated with higher relapse risk. Negative margins are favorable.}}

---

## Phase 3: {{Phase Name, e.g., Post-Surgical Chemotherapy}}

**Date range:** {{YYYY-MM-DD}} to {{YYYY-MM-DD}}
**Protocol / regimen:** {{e.g., Continued first-line protocol — same agents, no escalation per trial data}}
**Treating institution:** {{Institution name, city}}

### Treatment Cycles

| Date | Agent(s) | Notes |
|---|---|---|
| {{YYYY-MM-DD}} | {{e.g., Restart chemotherapy (Cycle 3)}} | {{Returns to treating center after surgery}} |
| {{YYYY-MM-DD}} | {{e.g., Final chemotherapy}} | {{End of protocol}} |

**Total treatment duration:** {{e.g., ~7.5 months (Month YYYY – Month YYYY)}}

---

## Phase 4: {{Phase Name, e.g., Post-Treatment Surveillance}}

**Date range:** {{YYYY-MM-DD}} to {{YYYY-MM-DD or "ongoing"}}
**Surveillance cadence:** {{e.g., CT chest + X-ray every 3 months for 2 years, then every 6 months}}
**Treating institution:** {{Institution name, city}}

| Date | Study | Finding |
|---|---|---|
| {{YYYY-MM-DD}} | {{e.g., 3-month post-treatment CT chest}} | {{e.g., No evidence of intrathoracic metastatic disease}} |
| {{YYYY-MM-DD}} | {{e.g., 6-month post-treatment CT chest}} | {{e.g., No visible nodule — retrospectively concerning finding noted on later reread}} |

---

## Phase 5: {{Phase Name, e.g., Relapse Detection}}

> Add a new phase when relapse or progression is identified.

**Date:** {{YYYY-MM-DD}}
**How detected:** {{e.g., Routine surveillance CT; new symptoms; rising tumor markers}}

| Study | Date | Finding |
|---|---|---|
| {{e.g., CT Chest}} | {{YYYY-MM-DD}} | {{e.g., 3 new pulmonary nodules — concerning for metastasis}} |
| {{e.g., PET/CT}} | {{YYYY-MM-DD}} | {{e.g., Local recurrence suspected at primary site, SUVmax X}} |
| {{e.g., Biopsy}} | {{YYYY-MM-DD}} | {{e.g., Malignancy confirmed — local recurrence}} |

---

## Phase 6: {{Phase Name, e.g., Second-Line Treatment}}

**Date range:** {{YYYY-MM-DD}} to {{ongoing / YYYY-MM-DD}}
**Protocol / regimen:** {{e.g., Clinical trial — ifosfamide + sequential targeted agents}}
**Treating institution:** {{Institution name, city}}
**Trial / IND:** {{e.g., NCT-XXXXXXXX, PI: Dr. Name}}

### Regimen Structure

| Cycle | Agents | Notes |
|---|---|---|
| {{Cycle 1}} | {{e.g., Ifosfamide + targeted agent A}} | {{}} |
| {{Surgery 1}} | {{e.g., Primary site surgery}} | {{}} |
| {{Cycle 2}} | {{e.g., Ifosfamide + targeted agent B}} | {{}} |
| {{Surgery 2}} | {{e.g., Metastasis resection}} | {{}} |

---

## Cumulative Toxicity Profile

> The agent uses this section to flag contraindications when evaluating new treatment options.
> Fill in as data accumulates. Add a `considerations.md` link for any constraint that requires follow-up.

| Toxicity / Agent | Cumulative exposure | Current constraint | Notes |
|---|---|---|---|
| **Anthracycline (e.g., doxorubicin)** | {{e.g., Total lifetime dose: ~XXX mg/m²}} | {{e.g., Cardiac monitoring required; approach lifetime cap}} | {{See `scan-history.md` for echo EF values}} |
| **Platinum (e.g., cisplatin)** | {{e.g., X cycles}} | {{e.g., Nephrotoxicity monitoring; ototoxicity baseline established}} | {{Audiogram date: YYYY-MM-DD}} |
| **Radiation fields** | {{e.g., None received}} | {{None}} | {{}} |
| **Surgical reconstruction** | {{e.g., Lengthening rod in right femur}} | {{e.g., MRI artifact limits local imaging interpretation}} | {{}} |
| **Thrombus history** | {{e.g., Catheter-associated thrombus during Cycle 1}} | {{e.g., Anticoagulation completed}} | {{}} |

---

## Fertility Preservation

> Document any fertility preservation steps taken before or during treatment.

| Intervention | Date | Details | Storage location |
|---|---|---|---|
| {{e.g., Ovarian tissue cryopreservation}} | {{YYYY-MM-DD}} | {{e.g., Tissue collected at time of biopsy; sent to fertility center}} | {{e.g., University Fertility Center, City}} |
| {{e.g., Hormone suppression}} | {{YYYY-MM-DD}} | {{e.g., Started Lupron; uncertain benefit but adjunct to tissue preservation}} | {{N/A}} |

---

## Key Clinical Facts Reference Table

> Quick reference for the agent when drafting research reports.

| Parameter | Value |
|---|---|
| First-line regimen | {{e.g., MAP: methotrexate + doxorubicin + cisplatin}} |
| Date of surgery | {{YYYY-MM-DD}} |
| Histologic response (necrosis) | {{e.g., 25% — Poor response}} |
| Surgical margins | {{e.g., Negative (closest: 1.35 mm)}} |
| Time to confirmed relapse | {{e.g., ~9 months post-treatment completion}} |
| Current trial / IND | {{e.g., NCT-XXXXXXXX — ifosfamide + sequential agents}} |

---

## Source Documents

- `documents/{{filename}}.pdf` — {{e.g., Clinical notes through Month YYYY}}
- `documents/{{filename}}.pdf` — {{e.g., Surgical pathology report, Date}}
- `documents/{{filename}}.pdf` — {{e.g., Trial enrollment confirmation}}

---

*Last updated: {{YYYY-MM-DD}}*
