<!-- Compass template: this file is created from templates/patient/scan-history.md during onboarding. Edit freely. -->

# Scan History

> Chronological log of all imaging studies and procedures with pathologic results.
> The agent uses this file when assessing disease trajectory and surveillance adequacy.
> Add each new scan as a row in the summary table, then optionally expand it in the detailed section below.

---

## Summary Table (Chronological)

> One row per study. Use the key finding column to capture the single most important result.
> For studies that change the clinical picture materially, add a detailed report in the section below.

| Date | Modality | Body region | Key finding | Radiologist / institution | File reference |
|---|---|---|---|---|---|
| {{YYYY-MM-DD}} | {{e.g., MRI w/wo contrast}} | {{e.g., Right lower extremity}} | {{e.g., Aggressive lesion with large soft tissue component — malignancy suspected}} | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |
| {{YYYY-MM-DD}} | {{e.g., CT chest w/o contrast}} | {{Chest}} | {{e.g., No evidence of pulmonary metastases}} | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |
| {{YYYY-MM-DD}} | {{e.g., PET/CT whole body}} | {{Whole body — baseline staging}} | {{e.g., Hypermetabolic primary lesion SUVmax X; no definite metastases}} | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |
| {{YYYY-MM-DD}} | {{e.g., CT chest w/o contrast}} | {{Chest — pre-surgery}} | {{e.g., No metastatic disease}} | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |
| {{YYYY-MM-DD}} | {{e.g., PET/CT whole body}} | {{Whole body — response assessment}} | {{e.g., SUVmax decreased from X to Y — significant treatment effect}} | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |
| {{YYYY-MM-DD}} | {{e.g., CT chest w/o contrast}} | {{Chest — 3-month surveillance}} | {{e.g., No evidence of intrathoracic metastatic disease}} | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |
| **{{YYYY-MM-DD}}** | **{{e.g., CT chest w/o contrast}}** | **{{Chest — CRITICAL}}** | **{{e.g., New pulmonary nodules — suspicious for metastasis}}** | {{Dr. Name, Institution}} | `documents/{{filename}}.pdf` |

---

## Detailed Reports

> Copy this block for each scan that warrants expanded documentation.
> You don't need to expand every scan — focus on diagnostically significant ones.

---

### {{YYYY-MM-DD}} — {{Modality}} {{Body Region}} ({{Purpose, e.g., Baseline staging}})

**Radiologist:** {{Dr. Name}} ({{Institution}})
**Comparison:** {{e.g., None — baseline}} / {{e.g., Prior study date}}
**Indication:** {{e.g., New suspected diagnosis — characterize primary lesion}}

**Key findings:**
- {{e.g., Primary lesion: aggressive distal femoral metadiaphyseal lesion}}
  - Intraosseous component: {{e.g., ~2.1 × 2.2 × 6.4 cm}}
  - Soft tissue mass: {{e.g., extends medially and posteriorly, ~4.8 × 2.8 × 7.4 cm}}
- {{e.g., No skip metastases}}
- {{e.g., Lesion abuts neurovascular bundle posteriorly}}
- {{e.g., No definite lymph node involvement}}

**Impression:**
1. {{e.g., Aggressive lesion — malignancy suspected}}
2. {{e.g., No evidence of metastatic disease}}

---

### {{YYYY-MM-DD}} — {{Modality}} {{Body Region}} ({{Purpose, e.g., Response assessment}})

**Radiologist:** {{Dr. Name}} ({{Institution}})
**Comparison:** {{Prior study date and modality}}
**Indication:** {{e.g., Response assessment after 2 cycles of chemotherapy}}

**Key findings:**
- {{e.g., SUVmax decreased from 9.3 to 4.7 (48% decrease) — significant treatment effect}}
- {{e.g., No new suspicious hypermetabolic lesions}}
- {{e.g., Prior equivocal lymph node uptake improved/resolved}}

**Impression:**
1. {{e.g., Decreased primary lesion activity — consistent with treatment response}}
2. {{e.g., No new lesions}}

---

### {{YYYY-MM-DD}} — **CRITICAL** — {{Modality}} {{Body Region}}

**Radiologist:** {{Dr. Name}} ({{Institution}})
**Comparison:** {{Prior study}}
**Indication:** {{e.g., Routine surveillance — history of treated malignancy}}

**Key findings:**
- {{e.g., NEW: Right lower lobe nodule, X mm — not present on prior study}}
- {{e.g., NEW: Additional nodule, Y mm — new since prior study}}

**Impression:**
1. **{{e.g., Pulmonary nodules as described — concerning for metastatic disease}}**
2. {{e.g., Critical result communicated to treating physician on YYYY-MM-DD at HH:MM}}

---

## Disease Progression Tracking

> These tables are most useful for tracking how specific lesions change over time.
> The agent updates these tables after each new scan report is ingested.

### Primary Site

| Date | Modality | Size | SUVmax | Status |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | {{MRI}} | {{e.g., 4.8 × 2.8 × 7.4 cm soft tissue}} | — | Baseline — diagnosis |
| {{YYYY-MM-DD}} | {{CT}} | {{e.g., 7.6 × 5.6 × 2.8 cm ossified component}} | — | After Cycle 1 |
| {{YYYY-MM-DD}} | {{PET}} | — | {{9.3}} | Baseline PET |
| {{YYYY-MM-DD}} | {{PET}} | — | {{4.7}} | After 2 cycles — treatment effect |
| {{YYYY-MM-DD}} | {{Surgery}} | {{Resected}} | — | Clear margins; see treatment-history.md |

### Metastatic Lesions

| Date | Site | Modality | Finding | Interpretation |
|---|---|---|---|---|
| {{YYYY-MM-DD}} | {{e.g., Right lower lobe lung}} | {{CT}} | {{e.g., No nodules}} | No metastases |
| {{YYYY-MM-DD}} | {{e.g., Right lower lobe lung}} | {{CT}} | {{e.g., 3.6 mm — new}} | **Suspicious for metastasis — CRITICAL** |
| {{YYYY-MM-DD}} | {{e.g., Left lung (new)}} | {{CT}} | {{e.g., 4 new nodules — new}} | **Bilateral progression** |

---

## Cardiac Monitoring (Echocardiograms)

> Track separately if the patient has received cardiotoxic agents (e.g., anthracyclines).

| Date | Ejection fraction | Institution | Notes |
|---|---|---|---|
| {{YYYY-MM-DD}} | {{e.g., 65% — normal}} | {{Institution}} | {{Baseline pre-treatment}} |
| {{YYYY-MM-DD}} | {{e.g., 62% — normal}} | {{Institution}} | {{Mid-treatment monitoring}} |
| {{YYYY-MM-DD}} | {{e.g., 60% — normal}} | {{Institution}} | {{Post-treatment monitoring}} |

---

## Source Documents

- `documents/{{filename}}.pdf` — {{e.g., Initial MRI report, Date}}
- `documents/{{filename}}.pdf` — {{e.g., PET/CT baseline, Date}}
- `documents/{{filename}}.pdf` — {{e.g., Surveillance CT, Date — CRITICAL result}}

---

*Last updated: {{YYYY-MM-DD}}*
