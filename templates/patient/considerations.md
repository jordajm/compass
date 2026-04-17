<!-- Compass template: this file is created from templates/patient/considerations.md during onboarding. Edit freely. -->

# Considerations

> Proactive "things to think about" flagged by the agent when new information arrives.
> This is where Compass tracks risks, surveillance gaps, tissue-banking opportunities, and regulatory questions — the forward-looking layer of the case.
> Nothing here is a decision — these are items the care team should actively consider and either action or explicitly close.

---

## How this file works

Every entry follows this format:

```markdown
## [STATUS] YYYY-MM-DD — short title

**Trigger**: what new information caused this consideration to be raised.
**Risk / opportunity**: the honest assessment — what is at stake if this is ignored, or what is potentially gained if acted on.
**Suggested action**: the specific thing to raise with the care team, with enough detail that the action owner knows what to do.
**Researched alternatives**: for skipped tests / contraindications, what the alternatives are, with evidence.
**Regulatory status** (if a therapy is involved): approval status in the patient's jurisdiction + pathway if unapproved.
**Status**: `open` | `raised-with-team` | `actioned` | `closed`
**Raised by**: {{agent | care-team member name, date}}
**Last updated**: YYYY-MM-DD
```

**Status flow**: items start `open` → the care team discusses it → flip to `raised-with-team` → once resolved, flip to `actioned` (with note on what happened) or `closed` (with reason). Closed items stay in the file as an audit record — "we considered this and decided X" is valuable history.

---

## Examples (edit or remove — these illustrate what good entries look like)

### [open] YYYY-MM-DD — Example: Surveillance scan declined — research alternatives

**Trigger**: Care-team decision note dated YYYY-MM-DD indicates a scheduled follow-up scan was declined because of {{reason, e.g., imaging artifact concern, sedation risk}}.
**Risk**: The standard-of-care surveillance interval exists because the recurrence window for this disease is short. Skipping this scan without a compensating surveillance strategy materially raises late-detection risk.
**Researched alternatives**: {{e.g., alternative imaging modality that avoids the artifact / ultrasound surveillance / circulating tumor DNA / tumor-marker tracking}}. Compass's `/research` skill can produce a full evidence review — run `/research "alternative surveillance protocols for [diagnosis] when [standard modality] is contraindicated"`.
**Suggested action**: Raise with primary oncologist at the next appointment. Ask specifically about {{named alternatives}}. If the alternatives are pursued, record the substitute surveillance plan in `patient/scan-history.md`.
**Regulatory status**: not applicable (imaging protocols, not drugs).
**Status**: open
**Raised by**: agent (via `/update`)
**Last updated**: YYYY-MM-DD

---

### [open] YYYY-MM-DD — Example: Tissue-banking opportunity ahead of upcoming procedure

**Trigger**: `patient/case-timeline.md` shows an upcoming sample-yielding procedure (biopsy / resection / bone-marrow aspirate / other).
**Opportunity**: The procedure yields irreplaceable tissue. Banking fresh-frozen tissue and sending a split for extended molecular profiling opens options the family may want later — targeted therapy selection, neoantigen vaccine design, organoid culture, proteomic profiling. Arranging this requires advance logistics (consent, labs that accept the sample, shipping, timing window).
**Suggested action**: Before the procedure, confirm with the surgical team: (1) consent for research-grade tissue banking; (2) identify receiving lab(s); (3) coordinate fresh-frozen vs. FFPE split; (4) shipping logistics if sending to an external lab.
**Researched alternatives**: n/a (this is an additive option, not a substitute).
**Regulatory status**: n/a for banking itself; relevant when downstream therapies are identified.
**Status**: open
**Raised by**: agent (via `/update`)
**Last updated**: YYYY-MM-DD

---

### [open] YYYY-MM-DD — Example: Regulatory pathway for unapproved therapy under discussion

**Trigger**: {{Consultation log / research report}} discussed {{therapy X}}, which is {{not approved in the patient's jurisdiction / approved only for another indication}}.
**Risk / opportunity**: If the care team is seriously considering this therapy, access requires a formal special-access pathway. Starting the pathway process early matters — most pathways take weeks to months and require a willing physician sponsor.
**Researched alternatives**: Compass's `/research` produced {{link to report}}. Pathway options in the patient's jurisdiction: {{e.g., FDA Expanded Access / single-patient IND / Right-to-Try / EMA compassionate use / EAMS / SAP — whichever applies}}.
**Suggested action**: (1) Confirm with the prescribing physician whether they are willing to serve as the IND / pathway sponsor. (2) Identify whether the manufacturer has granted expanded access for this indication before. (3) Identify any advocacy organizations that specialize in navigating this pathway. (4) Begin the application paperwork in parallel with the treatment-decision conversation — do not wait for a final decision.
**Regulatory status**: {{approval status}} — pathway: {{pathway name}}.
**Status**: open
**Raised by**: agent (via `/research`)
**Last updated**: YYYY-MM-DD

---

## Active Considerations

<!-- New entries from /update and other flows land here. Most recent first. -->

## Closed / Actioned (audit trail)

<!-- When an item is resolved, move it here with a brief note on the outcome. Do not delete — the history of what was considered and why is valuable. -->
