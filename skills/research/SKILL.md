---
description: Deep research pipeline for a medical question about the case. Coordinates specialized agents (planner, researcher, evaluator, writer) to produce a thorough, evidence-based report grounded in the patient's case data, with regulatory-status awareness and tiered decision framework. Use when the user asks a medical, treatment, trial, or case-related research question.
---

# /compass:research — Deep Research Orchestrator

Invoked as: `/compass:research "question"` (Claude Code / Desktop) or `@research "question"` (Codex)

This skill orchestrates a full deep research pipeline for any medical case question. It coordinates specialized agents to produce thorough, evidence-based research reports grounded in the patient's actual case data. Every recommendation includes explicit regulatory status and access pathway information.

**Context note**: Before starting, tell the user: "This may take a few minutes and use significant context. After we're done, you'll want to start a fresh chat for your next task."

---

## Step 1: Query Clarification

Assess whether the question is sufficiently specific.

If ambiguous or underspecified, ask:
- What specific aspect is most important to explore?
- Is this for an upcoming appointment, a decision point, or general understanding?
- Are there particular institutions, treatment approaches, or specialists to focus on?

Do not proceed until the question is clear enough to generate a useful research plan. In `--scheduled` or batch contexts, skip clarification and proceed with the question as given.

---

## Step 2: Case Context Loading

Read the following files to build context for the research plan.

**Always load:**
- `patient/PROFILE.md` — patient demographics, diagnosis, location, country (for regulatory-status scoping), treatment phase, budget posture
- `patient/molecular.md` — genomic and molecular findings, actionable alterations
- `patient/current-findings.md` — most recent scans, labs, and clinical status
- `patient/treatment-history.md` — prior regimens, surgeries, responses, toxicities, cumulative constraints

**Load when relevant to the question:**
- `patient/case-timeline.md` — key dates and milestones
- `patient/scan-history.md` — imaging results over time
- `patient/treatment-options.md` — previously identified options and their status
- `patient/clinical-trials.md` — active and previously reviewed trials
- `patient/consultation-log.md` — prior specialist interactions
- `patient/considerations.md` — active proactive considerations (open items flagged by prior updates) — pass these to the planner so current research connects to known gaps

Summarize the relevant case context into a compact brief (2–4 paragraphs) before dispatching the planner. Note the patient's country of residence for regulatory scoping.

---

## Step 3: Research Loop

### 3a. Planning

Dispatch the `planner` agent with:
- The user's research question
- The case context brief from Step 2
- The active open items from `patient/considerations.md` (so the planner can surface connections to known gaps)
- The current treatment phase and tier (from PROFILE.md) so the planner knows whether to prioritize standard-of-care, extended options, or first-principles approaches

The planner returns a JSON research plan with 3–7 specific sub-questions. Extract the JSON from the agent's response.

### 3b. Research (Parallel)

Dispatch one `researcher` instance per sub-question, running in parallel. Each researcher:
- Investigates one sub-question deeply using web search
- Returns findings with citations and confidence levels

### 3c. Evaluation

Dispatch the `evaluator` agent with:
- All collected findings from the researchers
- The original question
- The full text of `patient/PROFILE.md`, `patient/molecular.md`, `patient/current-findings.md`, and `patient/treatment-history.md` (the evaluator has no tools — it reasons only from what you pass it)
- The patient's country of residence (for regulatory-status evaluation)
- The current treatment tier (so the evaluator applies the appropriate escalation logic)

The evaluator:
1. Assesses whether the research is sufficient and identifies critical gaps.
2. Checks that every recommendation includes a regulatory-status determination for the patient's jurisdiction.
3. **Refuses to pass any unapproved therapy recommendation to the writer without a regulatory pathway analysis** (IND, expanded access, compassionate use, Right-to-Try, or jurisdiction-equivalent). If any recommendation is missing this, it flags it as a gap for further research rather than passing it through incomplete.
4. Escalates tiers appropriately: if Tier-1 standard-of-care options have been exhausted or shown insufficient, the evaluator explicitly notes the escalation and explains the logic.
5. Returns `research_sufficient` (boolean) and `gaps_for_further_research` (array).

### 3d. Loop or Conclude

- **If `research_sufficient: true`:** Proceed to Step 3e.
- **If `research_sufficient: false`:** Dispatch `planner` again with the gaps as follow-up questions. Run another parallel round of `researcher` instances. Collect findings. Re-dispatch `evaluator` with all findings (original + new).

**Soft iteration cap:** After 3 research iterations, present the current findings to the user and ask whether to continue investigating gaps or proceed to report writing with available evidence. In `--scheduled` or non-interactive mode, proceed to writing after 3 iterations regardless.

### 3e. Report Writing

Dispatch the `writer` agent with:
- The original question
- All evaluated findings (from the evaluator's final output)
- The case context brief
- The planner's `synthesis_note`
- Active open items from `patient/considerations.md` (so the writer can surface connections)
- Patient country of residence (for regulatory-status sections)
- `report_type`: `"detailed"` by default; `"brief"` for quick updates; `"action_plan"` when a checklist of next steps is needed; `"trial_summary"` when the question focused on clinical trials

The writer produces the final report. Every recommendation section **must** include:

```
**Regulatory status ([patient's country]):** [Approved / Not approved / Approved for different indication]
**Access pathway (if not approved):** [IND / Expanded Access 21 CFR 312 / Right-to-Try / Compassionate Use / [jurisdiction equivalent] / None identified]
**Pathway notes:** [Eligibility, typical timeline, who applies, manufacturer posture, advocacy resources if known]
```

---

## Step 4: On-Demand Case Analysis

If any step requires specific interpretation of the patient's case data (labs, scans, pathology values), dispatch the `case-analyst` agent with the specific data and question. This agent specializes in reading actual medical records and placing findings in clinical context.

---

## Step 5: Save Report to Disk

After the writer produces the final report:

1. Create `reports/` directory if it doesn't exist.
2. Write to `reports/YYYY-MM-DD-topic-slug.md` (canonical).
3. If `html_dual_write` is enabled in `config/preferences.md`, also write `reports/YYYY-MM-DD-topic-slug.html` (rendered with a simple stylesheet — this is the file to open in Google Drive preview).
4. Tell the user both file paths.

**Filename format:** `YYYY-MM-DD-topic-slug.md` where the slug is 3–6 lowercase kebab-case words from the research question. If a same-day file with the same slug exists, append `-2`, `-3`, etc.

---

## Step 5.5: Suggest To-Do Updates

After saving the report, read `TODO.md` and check:

1. Does the research answer or advance any existing to-do items? If so, suggest updating their status.
2. Does the research surface new action items not already tracked? If so, suggest additions with workstream and priority.

Present suggestions as a bulleted list. **Do NOT modify TODO.md directly** — let the user decide via `/compass:todo`. (Unlike `/compass:update` which auto-adds for speed, `/compass:research` only suggests.)

---

## Step 6: Output and Disclaimer

Print the full report to the console so the user can read it immediately.

Every report must end with:

> **Disclaimer:** This research is for informational purposes to support discussions with the medical team. It does not constitute medical advice. All treatment decisions should be made in consultation with the treating physicians and medical team. — Generated by Compass, [date]

After the report, offer the context-coaching note: "This was a long session. Starting a fresh chat for your next task will be faster." (Use host-appropriate wording from onboarding skill.)

---

## Agent References

All agents are defined in `agents/`:

| Agent | File | Role |
|-------|------|------|
| planner | `agents/planner.md` | Breaks question into sub-questions and research plan |
| researcher | `agents/researcher.md` | Investigates a single sub-question with web search |
| evaluator | `agents/evaluator.md` | Assesses sufficiency, regulatory completeness, tier escalation |
| writer | `agents/writer.md` | Synthesizes findings into final report with regulatory sections |
| case-analyst | `agents/case-analyst.md` | Interprets specific patient case data on demand |

---

## Behavioral Rules

1. **Regulatory status is non-negotiable.** Every recommendation that reaches the writer must have a regulatory-status determination. The evaluator enforces this — it does not pass incomplete recommendations through.
2. **Tier escalation is explicit.** When the evaluator escalates from Tier 1 to Tier 2 or Tier 3, it writes out the escalation reasoning so the family understands why options they're now seeing were not offered earlier.
3. **Unapproved therapies are framed honestly.** Never imply an unapproved therapy is a normal treatment option. Always frame as an experimental, regulated path with access hurdles.
4. **Soft cap prevents runaway usage.** After 3 iterations, check in with the user.
5. **Dual-write for Drive users.** `.html` sibling makes reports previewable in Google Drive without triggering the `.gdoc` shadow problem.
6. **Considerations are connected.** The planner and writer both receive the active considerations list so research connects to known case gaps, not just the stated question.
