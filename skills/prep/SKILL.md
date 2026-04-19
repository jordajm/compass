---
description: Produce a concise prep file for an upcoming meeting or call — who the contact is, what you've discussed before, open items, recent developments, and 3–5 suggested questions. Faster and cheaper than full research. Use when the user mentions an upcoming meeting, call, consultation, or appointment.
---

# /compass:prep — Meeting & Call Prep

Invoked as: `/compass:prep "<meeting description>"` (Claude Desktop) or `@prep "<description>"` (Codex). Can also be auto-triggered by `/compass:update` when an upcoming calendar event is within the next 2 days and no prep file exists.

Produces a concise, actionable prep file for an upcoming meeting — who the contact is, what you've discussed before, relevant recent developments, and suggested questions. Optimized for quick review before a call, not for deep research.

---

## When to use `/compass:prep` vs `/compass:research`

| Use `/compass:prep` when | Use `/compass:research` when |
|---|---|
| You have a meeting coming up and need to walk in prepared | You have a medical question you want to investigate |
| You want a short readable file (1–2 pages) | You want a full evidence review with citations |
| You want to reference prior interactions with this contact | You don't care who you're meeting — you want the answer |
| Default: no web search | Default: parallel web research across PubMed, trials, etc. |

`/compass:prep "meeting with Dr. X" --research` combines both: runs a fast research pass on any open questions specific to that meeting, then assembles the prep file with research findings attached.

---

## Step 0: Detect user

Same identity-resolution pattern as `/compass:email` and `/compass:update` — `ToolSearch` for email provider → `get_profile` → match to `care-team/ROSTER.md`. Store name for attribution on any writes.

---

## Step 1: Parse the request

Two entry modes:

### Mode A: Named contact

Input like `/compass:prep "meeting with Dr. X"` or `/compass:prep "call with {{Name}} tomorrow"`.

1. Extract contact name from the request.
2. Look up in `care-team/contacts.md`. If not found, ask the user which contact they mean, or offer to `/compass:contacts add`.
3. Look for a matching calendar event (if Calendar is connected) within the next 14 days.

### Mode B: Calendar event

Input is a calendar event title, or `/compass:prep` auto-triggered by `/compass:update` for an upcoming event.

1. Use the Calendar MCP to fetch event details: title, date/time, attendees, description.
2. Match attendee emails to `care-team/contacts.md` entries.
3. If no roster/contacts match, fall back to whatever the event title references.

---

## Step 2: Gather context (parallel reads)

Load in parallel:

- **Contact details**: `care-team/contacts.md` entry for this person — role, institution, audience type, notes, last interaction.
- **Prior interactions**: `patient/consultation-log.md` — scan for this person's name; extract dates + topics + decisions.
- **Meeting notes**: `meeting-notes/` — grep for this contact's name across recent transcript files.
- **Open TODO items**: `TODO.md` — filter to items tagged with this contact, their institution, or workstreams they drive.
- **Recent case changes**: `patient/current-findings.md`, most recent 30 days of `patient/case-timeline.md`, any `[NEW]` entries in `patient/considerations.md`.
- **Prior emails** (if email connector is available): search the inbox for the most recent thread with this person, summarize last 3–5 messages.

---

## Step 3: Optionally run a research pass (`--research`)

If invoked with `--research`, extract the open questions from TODO items + considerations that are relevant to this meeting, and dispatch a focused `/compass:research` pipeline for each (via the same planner → researcher → evaluator → writer flow). Keep it tight — 2–3 sub-questions max, 1 iteration. The output is a short findings section appended to the prep file.

Without `--research`, skip this step entirely. `/compass:prep` stays fast.

---

## Step 4: Dispatch the writer agent

Dispatch `writer` (subagent) with `report_type: "prep_file"`:

```json
{
  "report_type": "prep_file",
  "question": "Prep for {{meeting description}}",
  "audience": "family",
  "meeting_context": {
    "contact": { ...from contacts.md },
    "when": "<date/time/location from calendar>",
    "prior_interactions": [ ... from consultation-log.md ],
    "recent_meeting_notes": [ ... excerpts from meeting-notes/ ],
    "open_todos_for_this_contact": [ ... ],
    "recent_thread": "<email thread summary, if any>",
    "recent_case_changes": "<digest of current-findings changes, new considerations, timeline updates>"
  },
  "research_findings": <optional, from Step 3>
}
```

The writer produces a prep file with these sections:
- **Who they are** (role, institution, how they got involved)
- **What you've discussed before** (chronological, most recent first)
- **Where the case stands now** (2–3 sentence update scoped to what this contact cares about)
- **Suggested questions** (3–5 specific questions grounded in open TODO items and considerations)
- **Open items still owed** (from you / to you — with dates)
- **If time allows** (nice-to-have topics that are lower priority)
- **Recent research** (if `--research` was used)

---

## Step 5: Save to disk (dual-write)

Filename: `reports/prep-YYYY-MM-DD-<contact-slug>.md`

1. Write the markdown file.
2. Write a `.html` sibling at the same path (per `CLAUDE.md` §11 — for Google Drive users, the `.html` avoids the `.gdoc` shadow problem).
3. Tell the user the file paths.

---

## Step 6: Offer to update TODO

If the prep process surfaced any action items not yet in TODO.md (e.g., "send Dr. X the updated molecular report before the call"), offer to add them. Do **not** modify TODO.md directly — suggest via `/compass:todo` so the user approves.

---

## Step 7: Print to console

After saving, print the prep file to the console so the user can read it immediately.

---

## Behavioral rules

1. **Concise** — prep files are for quick pre-meeting review. Target 1–2 pages. Cut ruthlessly.
2. **Grounded in prior interactions** — if `consultation-log.md` has entries for this contact, use them. Don't generate generic prep when specific history exists.
3. **Suggested questions are actionable, not philosophical** — each suggested question should name a concrete decision, data point, or next step. Not "what do you think about the case?"
4. **Audience-aware** — `writer` tags this as a family-internal document, so tone is clear and direct. But if the prep file references clinical detail, it should use medical terms the user will hear in the meeting (with brief gloss where helpful).
5. **No filler** — skip "I hope the meeting goes well" etc. Families under stress don't need it.
6. **Every recommendation mentioned carries a regulatory status line** — same rule as `/compass:research`. If the meeting is about a treatment option, note its approval status in the patient's jurisdiction.
7. **Cheaper than `/compass:research`** — default path uses no web search. Only `--research` incurs web calls.
