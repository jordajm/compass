---
description: Draft emails, search the inbox, and read threads related to the case. Produces drafts only — the user always reviews and sends manually. Audience-aware tone — concise + clinical for doctors, clearer + honest for family. Use when the user says draft / reply / email / inbox / send to.
---

# /compass:email — Email Drafting & Inbox

Invoked as: `/compass:email "command"` (Claude Code / Desktop) or `@email "command"` (Codex)

This skill helps draft emails, search inboxes, and read threads related to care coordination. It assembles relevant case context from the patient's files so every email is precise and informed.

**Important:** Email integration creates **drafts only**. The user always reviews and sends manually.

---

## Step 0: Detect Current User and Email Provider

Before any email operation:

1. Read `care-team/ROSTER.md` and `config/connectors.md`.
2. Determine email provider from `config/connectors.md` (`email_provider: gmail` or `email_provider: outlook`). Default to Gmail if not specified.
3. Use `ToolSearch "gmail"` (or `ToolSearch "outlook"`) to confirm the appropriate tools are available.
4. If Gmail: call `gmail_get_profile`. If Outlook: call the Outlook equivalent profile tool.
5. Match the returned email against roster entries in `ROSTER.md`.
   - If matched: store `current_sender_name`, `current_sender_email`, `current_sender_role`, `is_primary_caregiver` (true if role = primary-caregiver).
   - If not matched: inform the user of the connected account and proceed — they may be using a personal account not in the roster.
6. Inform the user of the connected account: "Connected as [name] ([email]). Drafts will go to your inbox."
7. If no email connector is available: inform the user and exit gracefully. "No email connector is available. Check `config/connectors.md` to enable Gmail or Outlook."

---

## Routing

| Intent | Mode | Examples |
|--------|------|----------|
| Draft a new email or reply | **Draft** | `/compass:email "draft a message to Dr. Chen about the scan results"`, `/compass:email "reply to the trial coordinator thread"` |
| Search or read emails | **Read** | `/compass:email "check emails from the genetics lab"`, `/compass:email "read the latest thread with the insurance coordinator"` |
| Draft from a to-do item | **Draft from TODO** | `/compass:email "draft an email for the pre-auth follow-up todo"`, `/compass:email "draft emails for all urgent items"` |

If intent is ambiguous, ask the user to clarify.

---

## Mode: Draft

The orchestrator assembles all relevant context so the `email-drafter` agent produces a precise, well-informed email. The drafter has no tools — it can only use what the orchestrator passes it.

### Step 1: Resolve Recipient

Read `care-team/contacts.md`. Find the recipient by name and extract:
- Email address
- Role, specialty, institution
- Relationship context (new contact vs. established; prior consultations by date)

If the recipient is not in `care-team/contacts.md`:
1. Search the inbox for messages from/to that person to find their address.
2. If still not found, ask the user for their email and role.

### Step 2: Determine Audience Category

Based on recipient role, set audience category — this drives tone and jargon level for the drafter:

| Recipient role | Audience category |
|---|---|
| Surgeon, oncologist, specialist, radiologist, geneticist, pathologist, any MD | `medical_professional` |
| Patient advocate, care coordinator, case manager | `medical_adjacent` |
| Family member, friend, non-medical caregiver | `family` |
| The patient themselves | `patient` |
| Insurance, billing, administrative | `administrative` |
| Unknown / not in contacts | Ask the user |

### Step 3: Load TODO.md

Read `TODO.md`. Find any items related to:
- This recipient (by name or institution)
- The email's topic or workstream

Pass matching items as context so the email can reference outstanding items or recent progress.

### Step 4: Load Relevant Case Files

Select files based on the recipient's role category and the email topic. Extract only the relevant excerpts — do not pass entire files to the drafter.

| Recipient role category / Topic | Files to load |
|---|---|
| Surgeon | `patient/treatment-history.md`, `patient/scan-history.md`, `patient/current-findings.md` |
| Oncologist / trials | `patient/clinical-trials.md`, `patient/treatment-options.md`, `patient/current-findings.md` |
| Genomics / molecular / genetics lab | `patient/molecular.md`, `patient/treatment-options.md` |
| Biobanking / tissue coordination | `patient/treatment-history.md`, `patient/case-timeline.md` |
| Radiation oncologist | `patient/scan-history.md`, `patient/treatment-history.md`, `patient/current-findings.md` |
| New contact / general introduction | `patient/molecular.md`, `patient/treatment-history.md`, `patient/current-findings.md` |
| Insurance / administrative | `patient/treatment-history.md`, `patient/clinical-trials.md` |

### Step 5: Load Thread History (if replying)

If replying to an existing thread or there is prior correspondence with this recipient:
1. Search the inbox for the thread (by recipient email + keywords).
2. Read the full thread.
3. For long threads (>5 messages), summarize only the last 3–5 messages.
4. Note the `threadId` for creating the reply draft.

### Step 6: Dispatch Email Drafter

Dispatch the `email-drafter` agent with:

```json
{
  "sender": {
    "name": "<current_sender_name>",
    "email": "<current_sender_email>",
    "role": "<current_sender_role>",
    "is_primary_caregiver": true/false
  },
  "purpose": "<what the email needs to accomplish>",
  "recipient": {
    "name": "<from contacts.md>",
    "email": "<from contacts.md>",
    "role": "<from contacts.md>",
    "institution": "<from contacts.md>",
    "audience_category": "<medical_professional | medical_adjacent | family | patient | administrative>",
    "relationship_context": "<new or established; prior interactions>"
  },
  "case_context": "<relevant excerpts from case files>",
  "todo_context": "<matching to-do items>",
  "thread_context": "<thread summary, or empty if new email>",
  "tone": "<inferred: formal_medical | warm_professional | follow_up | urgent>",
  "special_instructions": "<any specific asks from the user>"
}
```

**Tone inference:**
- New contact with no prior interaction → `formal_medical`
- Established relationship → `warm_professional`
- Referencing a prior conversation → `follow_up`
- Time-sensitive / deadline-driven → `urgent`

**Audience-aware tone rules the drafter applies:**
- `medical_professional`: concise, jargon welcome, drop pleasantries, exact clinical details (doses, dates, values), 15-sentence hard cap.
- `medical_adjacent`: clear, some jargon with brief glosses, professional but accessible.
- `family`: plain language, explain jargon parenthetically, acknowledge uncertainty, never sugarcoat or falsely reassure.
- `patient`: same as family, plus heightened care about framing — name the reality, then name the options. Never write as if tragedy is certain; never write as if everything is fine.
- `administrative`: factual and precise, reference relevant codes or coverage categories when known.

### Step 7: Present Draft

Print the draft to the console. Offer three actions:
1. **Create draft** — save to Gmail or Outlook drafts folder
2. **Revise** — ask what to change, then re-dispatch the drafter with feedback
3. **Cancel** — discard

### Step 8: Create Draft (on approval)

**Gmail:** Use `gmail_create_draft` with `to`, `subject`, `body`, and `threadId` if replying.

**Outlook:** Use the Outlook equivalent MCP tool discovered via `ToolSearch "outlook"`.

Tell the user: "Draft created in [Gmail/Outlook]. Review and send when ready."

### Step 9: Offer TODO Update

If there's a related to-do item, offer to update its status:
- Add a "Draft created [date]" note to the item
- Status change (e.g., `_todo_` → `_in progress_`)

For simple updates, apply directly. For complex changes, suggest the user run `/compass:todo`.

---

## Mode: Read

### Step 1: Resolve Search Query

Read `care-team/contacts.md` to resolve names to email addresses.

Build a search query from the user's request:
- By sender: `from:email@domain.com`
- By keywords: `subject:keyword`
- By date: `newer_than:7d` or `after:YYYY/MM/DD`
- Combined as appropriate

### Step 2: Search

Use the appropriate inbox search tool (Gmail or Outlook). Limit to 10 results.

### Step 3: Read Threads

For relevant results, use the thread-read tool to get full conversations.

### Step 4: Summarize

Present a concise summary:
- Who wrote, when, subject
- Key points and decisions
- Action items or questions needing responses
- Flag anything connecting to items in `TODO.md`

### Step 5: Offer Next Steps

- "Want to draft a reply to any of these?"
- "I see action items — want to add them to your to-do list? Use `/compass:todo`."

---

## Mode: Draft from TODO

### Step 1: Identify To-Do Items

Read `TODO.md`. Match the user's request to specific items:
- By description keywords
- By workstream
- By status (e.g., "all urgent items")
- By assignee (default: items assigned to current user)

### Step 2: Draft Each Email

If more than 5 items match, present the list and ask which to draft first. Process a maximum of 5 drafts per invocation.

For each matching item:
1. Check if the item has an identifiable contact with an email in `care-team/contacts.md`.
2. If no contact or email found, skip it: "Skipped '[item description]' — no contact email found. Add their email to `care-team/contacts.md` or specify it."
3. For items with a valid contact, run the full **Draft** flow (Steps 1–9 above).
4. Present drafts one at a time for review.

---

## Gmail Tool Reference

| Tool | Use |
|------|-----|
| `mcp__claude_ai_Gmail__gmail_search_messages` | Find emails by sender, subject, date, labels |
| `mcp__claude_ai_Gmail__gmail_read_message` | Read a single email by ID |
| `mcp__claude_ai_Gmail__gmail_read_thread` | Read full conversation thread by ID |
| `mcp__claude_ai_Gmail__gmail_create_draft` | Create a draft in Gmail |
| `mcp__claude_ai_Gmail__gmail_list_drafts` | List existing drafts |
| `mcp__claude_ai_Gmail__gmail_get_profile` | Get connected Gmail account info |

**`gmail_create_draft` key parameters:**
- `to` — recipient email(s), comma-separated
- `subject` — subject line (omit when `threadId` is set)
- `body` — email body
- `cc` / `bcc` — optional
- `threadId` — for replies
- `contentType` — `"text/plain"` (default) or `"text/html"`

For Outlook, use the equivalent tools discovered via `ToolSearch "outlook"` at runtime.

---

## Behavioral Rules

1. **The user controls sending.** Never imply an email has been sent. Always say "draft created."
2. **Conciseness is non-negotiable.** If the drafter produces a long email, compress before presenting. 15-sentence limit for medical professional audience is a hard rule.
3. **Recipient resolution first.** Always check `care-team/contacts.md` before asking the user. If not found, try inbox search.
4. **Audience-aware always.** Tone and jargon level must match the audience category determined in Step 2.
5. **Connect to TODO.** When reading emails, proactively flag connections to open `TODO.md` items.
6. **Confidentiality.** Email contents are sensitive medical information. Do not include email content in research reports or shared files other than `TODO.md` action items.
7. **Thread awareness.** When replying, always load the prior thread so the draft doesn't repeat what's already been said.
8. **No explicit anti-patterns in output.** No "I understand this must be difficult" filler; no performative empathy; no false-optimism language; no jargon-without-gloss when audience is non-medical.
