<!-- Compass template: this file is created from templates/patient/molecular.md during onboarding. Edit freely. -->

# Molecular Profile

> This file tracks all genomic and molecular testing performed on the patient's tumor tissue.
> It is referenced by the research and evaluator agents whenever treatment options are assessed.
> For any finding that should trigger a follow-up action or risk flag, add a link to `patient/considerations.md`.

---

## Summary of Genomic Testing

> One paragraph written (or updated by the agent) after each new test result arrives.
> Example: "Two comprehensive molecular profiling tests have been performed across two specimens.
> Both consistently identify [gene alteration] as the most clinically significant finding."

{{Compass will draft this summary after ingesting test reports. Edit freely.}}

---

## Test Log

> Add one row per test. Most patients will have 2–5 tests across their disease course.

| Date | Institution / Lab | Specimen | Assay / Panel | Accession # | Status |
|---|---|---|---|---|---|
| {{YYYY-MM-DD}} | {{Lab name, city}} | {{e.g., Tumor biopsy, right femur}} | {{e.g., Comprehensive solid tumor DNA+RNA panel}} | {{e.g., LAB-12345}} | {{Resulted / Pending}} |
| {{YYYY-MM-DD}} | {{Lab name, city}} | {{e.g., Surgical resection specimen}} | {{e.g., 500-gene panel with matched normal}} | {{e.g., LAB-67890}} | {{Resulted / Pending}} |
| {{YYYY-MM-DD}} | {{Lab name, city}} | {{e.g., Relapse biopsy}} | {{e.g., Comprehensive solid tumor DNA+RNA panel}} | {{e.g., LAB-11223}} | {{Resulted / Pending}} |

---

## Actionable Findings

> List every finding with potential therapeutic relevance. Include even low-confidence findings (mark them clearly).
> For any finding flagged here, check whether a `considerations.md` entry exists.

| Gene / Target | Alteration | Confidence | Drug Class / Implication | Evidence Level | Notes |
|---|---|---|---|---|---|
| {{e.g., Gene A}} | {{e.g., Activating fusion}} | {{High / Medium / Low}} | {{e.g., Targeted inhibitor class}} | {{e.g., Level 3B — investigational in another indication}} | {{e.g., Confirmed by 3 independent assays}} |
| {{e.g., Gene B}} | {{e.g., Amplification}} | {{High / Medium / Low}} | {{e.g., May affect pathway X}} | {{e.g., Preclinical only}} | {{e.g., Subclonal — VAF 8%}} |
| {{e.g., Gene C}} | {{e.g., Loss of expression}} | {{Medium}} | {{e.g., Possible sensitization to drug class Y}} | {{e.g., Emerging — 2 case reports}} | {{e.g., See considerations.md}} |

---

## Tumor Mutational Burden / MSI / PD-L1

> These three values determine eligibility for immunotherapy approaches.

| Biomarker | Value | Interpretation |
|---|---|---|
| **TMB** | {{e.g., 2.5 mut/Mb — Low}} | {{e.g., Does not support checkpoint inhibitor use}} |
| **MSI status** | {{e.g., Microsatellite Stable (MSS)}} | {{e.g., No hypermutator phenotype}} |
| **PD-L1 expression** | {{e.g., Medium — TPS 10%}} | {{e.g., Borderline; rationale for checkpoint therapy unclear without high TMB}} |

---

## Copy Number & Chromosomal Findings

> Summarize broad copy number alterations and chromosomal instability patterns.

{{e.g., Widespread copy number alterations across multiple chromosomes, consistent with chromosomal instability.
New gain at chromosome Xq detected in relapse specimen (not present at diagnosis).
Prior changes at chromosomes Y and Z were not confidently detected in relapse specimen.}}

---

## Tumor Microenvironment (if assessed)

> Some comprehensive platforms (e.g., whole transcriptome sequencing) characterize the TME.
> This affects immunotherapy strategy — fibrotic TME, for example, is associated with poor checkpoint response.

| Feature | Value | Implication |
|---|---|---|
| **TME type** | {{e.g., Fibrotic / Immune-enriched / Excluded / Deserted}} | {{e.g., Fibrotic subtype associated with poor ICI response regardless of TMB}} |
| **CD8+ T cells** | {{e.g., Low — 1.6%}} | {{e.g., Cold tumor — limited infiltrating cytotoxic cells}} |
| **Macrophages** | {{e.g., Medium — 14%}} | {{}} |
| **Fibroblasts** | {{e.g., High — 20%}} | {{e.g., Consistent with fibrotic microenvironment}} |

---

## Surface Target Expression (for ADC / CAR-T eligibility)

> Populated from whole transcriptome sequencing or IHC staining.
> These targets are relevant for antibody-drug conjugates (ADCs) and CAR-T cell therapies.

| Target | Expression level | Percentile (vs. tumor type cohort) | Therapeutic relevance | Notes |
|---|---|---|---|---|
| {{e.g., Surface protein A}} | {{e.g., High}} | {{e.g., 95th %ile}} | {{e.g., ADC in clinical trials for this expression level}} | {{e.g., IHC staining pending to confirm protein}} |
| {{e.g., Surface protein B}} | {{e.g., Medium}} | {{e.g., 60th %ile}} | {{e.g., CAR-T trials open; eligibility requires IHC confirmation}} | {{}} |

---

## Germline Findings

> Germline testing evaluates whether the patient carries inherited cancer risk variants.
> Flag any finding here that should also appear in `patient/considerations.md`.

| Gene | Variant | Classification | Implication | Notes |
|---|---|---|---|---|
| {{e.g., Gene X}} | {{e.g., Pathogenic variant}} | {{Pathogenic / VUS / Benign}} | {{e.g., Hereditary cancer syndrome — family counseling recommended}} | {{e.g., Refers to considerations.md entry YYYY-MM-DD}} |

**Overall germline result:** {{e.g., No pathogenic or likely-pathogenic germline variants detected}} / {{e.g., See above}}

---

## Cross-Test Summary

> This table is useful when multiple tests have been run across multiple specimens and timepoints.
> Helps identify which findings are clonal (present in all specimens) vs. subclonal or acquired.

| Finding | Test 1 ({{date}}) | Test 2 ({{date}}) | Test 3 ({{date}}) | Interpretation |
|---|---|---|---|---|
| {{Gene A fusion}} | {{Yes}} | {{Yes}} | {{Yes}} | {{Clonal — present across all timepoints}} |
| {{Gene B variant}} | {{Yes}} | {{Not detected}} | {{Yes — VAF 8%}} | {{Subclonal or re-emerged at relapse}} |
| {{TMB}} | {{2.5 mut/Mb}} | {{1.2 mut/Mb}} | {{3.1 mut/Mb}} | {{Consistently low}} |

---

## Drug Potency / IC50 Reference (if applicable)

> If multiple drugs in the same class are under consideration, document their comparative potency here.
> This helps the evaluator agent make calibrated recommendations.

| Drug | Target IC50 | Mechanism | Notes |
|---|---|---|---|
| {{Drug A}} | {{e.g., 1.0 nM}} | {{e.g., Reversible selective inhibitor}} | {{e.g., Lowest IC50 in class}} |
| {{Drug B}} | {{e.g., 1.6 nM}} | {{e.g., Irreversible covalent}} | {{e.g., Overcomes gatekeeper resistance mutations}} |
| {{Drug C}} | {{e.g., 3.0 nM}} | {{e.g., Reversible ATP-competitive}} | {{e.g., Most clinical data in this tumor type}} |

---

## Source Documents

> List every report that was read to populate this file.

- `documents/{{filename}}.pdf` — {{brief description, e.g., initial biopsy NGS panel, Lab A}}
- `documents/{{filename}}.pdf` — {{brief description, e.g., resection specimen panel, Lab B}}
- `documents/{{filename}}.pdf` — {{brief description, e.g., relapse biopsy NGS panel, Lab A}}

---

*Last updated: {{YYYY-MM-DD}}*
