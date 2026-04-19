---
description: Manage the care team's shared to-do list, organized by workstream and scoped by assignee. Supports viewing, adding, completing, re-prioritizing, ingesting items from emails or files, and reviewing overdue/stale items. Use when the user mentions to-dos, action items, follow-ups, or wants to add/update/complete tasks.
---

# /compass:todo — To-Do & Workstream Tracker

Invoked as: `/compass:todo` or `/compass:todo "command"` (Claude Desktop) or `@todo "command"` (Codex)

This skill manages the care team's shared to-do list. It tracks action items across workstreams, supports multi-user attribution and assignee scoping, can ingest emails and files to extract new items, and helps prioritize what needs attention.

The to-do list lives at `TODO.md` in the working directory — a markdown file that can also be read and edited directly.

---

## Step 0: Detect Current User

1. Read `care-team/ROSTER.md`.
2. Use `ToolSearch "gmail"` to check if Gmail MCP is available.
3. If available, call `gmail_get_profile`. Match the returned email against roster entries.
   - If matched: use the roster entry's `name` for attribution. Store `current_user_name`, `current_user_email`, `current_user_role`, `current_user_access_level`.
   - If not matched: ask "Who am I talking to? I see this roster: [list names]. Or tell me your name if you're new."
4. If Gmail is not available: `ToolSearch "outlook"` — if Outlook is connected, call its profile tool. Match against roster similarly.
5. If no email connector at all: ask the user for their name (needed for attribution on any writes).

Store identity for the session. Default `/compass:todo` view shows items **assigned to current user** plus **unassigned urgent items**.

---

## Concurrency Guard

`TODO.md` is a shared file. Before every write:
1. Re-read `TODO.md` immediately before writing to get the latest version.
2. Apply changes to the freshest version.

This minimizes (but cannot eliminate) race conditions from concurrent edits.

---

## Routing

Parse the user's request and route to the appropriate mode:

| Intent | Mode | Examples |
|--------|------|----------|
| Show list (optionally filtered) | **Show** | `/compass:todo`, `/compass:todo "show urgent"`, `/compass:todo "show assigned to Sarah"`, `/compass:todo "show surgery workstream"` |
| Create / update / mark done | **Mutate** | `/compass:todo "call the lab about tissue banking"`, `/compass:todo "mark done: insurance pre-auth"`, `/compass:todo "assign the MRI prep item to Sarah"` |
| Extract todos from email | **Ingest: Email** | `/compass:todo "pull todos from email"`, `/compass:todo "pull todos from emails from Dr. Chen"` |
| Extract todos from a file | **Ingest: File** | `/compass:todo "pull todos from call transcript"`, `/compass:todo "pull todos from documents/2026-04-15-notes.pdf"` |
| Review & suggest actions | **Review** | `/compass:todo "review"`, `/compass:todo "what's overdue?"` |
| Seed from case files | **Seed** | `/compass:todo "seed"` |

If intent is ambiguous, ask the user to clarify.

---

## Mode: Show

1. Read `TODO.md`.
2. If no filter: show items **assigned to current user** plus **unassigned urgent items** by default. (Full list with `/compass:todo "show all"`.)
3. Apply filter if provided:
   - By workstream: match section headers
   - By status: match markers (`urgent`, `blocked`, `done`, etc.)
   - By contact: match contact names
   - By assignee: match `assignee:` field (e.g., `/compass:todo "show assigned to Sarah"`)
4. Print to console.

---

## Mode: Mutate

Handles all direct item management.

### Step 1: Read Current State

Read `TODO.md` and `care-team/contacts.md` (for contact lookups).

### Step 2: Parse Intent and Apply

**Create a new item:**
- Infer workstream from context. Use explicit workstream if provided.
- Infer priority from urgency cues: "ASAP", "urgent", "before [event]" → `[URGENT]`; "when possible", "eventually" → `[WATCH]`; no cue → `[NEXT]`.
- Look up contacts in `care-team/contacts.md` to auto-fill institution and role.
- Set `assignee`: use the name/email the user specifies, or default to current user if adding for self, or `unassigned` if adding for the team.
- Add to the appropriate workstream section, priority-ordered (URGENT first).

**Mark done:**
- Find the matching item (fuzzy match on description keywords).
- Move to "Completed (Recent)" section with today's date and completion attribution.
- If ambiguous, ask the user which item.

**Update an item:**
- Find the matching item, apply changes: new notes, changed status, new target date, reassign, etc.

**Re-prioritize / change status:**
- Change the status marker (e.g., `[NEXT]` → `[URGENT]`, `[NEXT]` → `[BLOCKED]` with a blocker note).

**Reassign:**
- `/compass:todo "assign [item description] to [name]"` → update `assignee:` field, stamp `updated_by: current_user_name, date`.

### Step 3: Write and Confirm

1. Re-read `TODO.md` (concurrency guard).
2. Apply changes and update the "Last updated" date.
3. Add attribution:
   - New items: append `(added_by: [current_user_name], [date])`
   - Updated items: append or update `(updated_by: [current_user_name], [date])`
4. Write `TODO.md`.
5. Show before/after for affected item(s).

---

## Mode: Ingest: Email

Access level check:
- **Primary caregiver (full access):** may ingest from their own connected inbox.
- **Other roster members:** may pull from their own connected inbox only. If they ask to pull from another roster member's inbox, stop and explain: "Email ingestion only pulls from the inbox you're currently signed into. To pull from [other person]'s inbox, they need to run `/compass:todo` from their own session."
- **No email connector:** stop and explain: "No email connector is available. You can add items manually with `/compass:todo 'description'`."

### Step 1: Determine Time Window

- **Default:** Use the "Last updated" date from `TODO.md` as the start date.
- **Override:** User can specify window, sender, or keywords.
- **First run (no prior date):** Default to last 14 days.

### Step 2: Search Email

Build query combining:
- Time filter: `after:YYYY/MM/DD`
- Case-related keywords from `patient/PROFILE.md` (patient name, diagnosis keywords)
- Contact addresses from `care-team/contacts.md` (if filtering by sender)
- User keyword overrides

Use Gmail (`mcp__claude_ai_Gmail__gmail_search_messages`) or Outlook equivalent per `config/connectors.md`.

### Step 3: Read Threads

Read relevant threads (limit 10 most recent to control context).

### Step 4: Extract Action Items

From each thread, extract anything requiring action:
- Respond to a question
- Schedule a call or appointment
- Send information
- Make a decision
- Follow up on something discussed

### Step 5: Deduplicate and Categorize

- Cross-reference with existing `TODO.md` — skip already-tracked items.
- Cross-reference with `care-team/contacts.md` for contact/institution tagging.
- Assign workstreams and priority markers.
- Set `assignee`: infer from context (item is for the user → current user; item for a specific person → that person; unclear → `unassigned`).

### Step 6: Present for Approval

Show extracted items in a numbered list. User can:
- Approve all → add to `TODO.md`
- Approve selectively → add chosen items
- Edit before adding → modify wording, priority, workstream, or assignee
- Reject → skip

### Step 7: Update TODO.md

Add approved items with full attribution (`added_by`, `assignee`, date). Update "Last updated."

---

## Mode: Ingest: File

### Step 1: Identify the File

User specifies a file path, or describe what to look for ("the call transcript from today"). If multiple candidates, ask which to process.

### Step 2: Read the File

Supports: `.md`, `.txt`, PDFs (via Read tool), documents in `documents/` or `meeting-notes/`. For large PDFs (>10 pages), focus on sections with action items, decisions, and follow-ups.

### Step 3: Extract Action Items

Pull out:
- Explicit action items ("need to...", "follow up with...", "schedule...", "send...")
- Decisions requiring follow-through
- Open questions needing answers
- Deadlines or scheduled events

### Step 4: Deduplicate and Categorize

- Cross-reference with `TODO.md` and `care-team/contacts.md`.
- Assign workstreams, priorities, assignees.

### Step 5: Present for Approval

Same approval flow as Ingest: Email.

### Step 6: Update TODO.md

Add approved items. Optionally suggest updates to case files if the ingested file contains:
- New contacts → suggest adding to `care-team/contacts.md`
- New strategy decisions → suggest adding to `patient/considerations.md`

---

## Mode: Review

### Step 1: Load Context

Read in parallel:
- `TODO.md`
- `patient/considerations.md`
- `care-team/contacts.md`

### Step 2: Analyze

Identify:
- **Overdue:** Items past their target date
- **Stale:** `[NEXT]` or `[URGENT]` items unchanged for 7+ days
- **Blocked:** Items in `[BLOCKED]` — check if blocker may have resolved
- **Priority mismatches:** `[URGENT]` items not acted on
- **Unassigned urgent items:** Should be assigned or escalated
- **Missing from TODO:** Open items in `patient/considerations.md` not yet tracked

### Step 3: Present Prioritized Suggestions

1. Items needing immediate attention (overdue + urgent)
2. Items needing a follow-up email (stale + blocked — suggest `/compass:email`)
3. Items to add from `patient/considerations.md`
4. Items ready to mark done

---

## Mode: Seed

Seed `TODO.md` from case files (one-time or reset).

1. Read `patient/considerations.md` — extract every open item (status: open or raised-with-team).
2. Read `patient/treatment-options.md` and `patient/clinical-trials.md` — extract any pending decisions or follow-up actions.
3. Read `patient/consultation-log.md` — extract unresolved action items from prior consultations.
4. Map to workstreams based on content. Assign priorities and assignees where clear.
5. Present proposed items to the user for review.
6. On approval, write `TODO.md`. If `TODO.md` already has content, show a preview of what will change and confirm before overwriting.

---

## TODO.md Format Reference

```markdown
# To-Do Tracker
> Last updated: YYYY-MM-DD

## [Workstream Name]

- **[STATUS]** Task description — Contact (Institution) — _status note_
  assignee: [name or email or "unassigned"]
  added_by: [name], [date]
  target: [YYYY-MM-DD or description]

## Completed (Recent)

- **[DONE]** Task description — Workstream — YYYY-MM-DD
  completed_by: [name], [date]
```

**Status markers:** `[URGENT]`, `[NEXT]`, `[WATCH]`, `[BLOCKED]`, `[DONE]`, `[RISK-FLAG]`

**Ordering:** Within each workstream — URGENT first, then NEXT, WATCH, BLOCKED. Workstream sections ordered by overall urgency.

**Assignee field:** Every item has an `assignee:` line. Defaults to current user when created by them for themselves, or `unassigned` when added for the team. Default view (no filter) shows items where `assignee` matches current user, plus unassigned urgent items.

**Completed section:** Items moved here when marked done. Pruned after 2 weeks.

---

## Behavioral Rules

1. **Attribution on every write.** Every create or update is stamped with `added_by` or `updated_by` and date.
2. **Concurrency guard always.** Re-read `TODO.md` immediately before every write.
3. **Access scoping.** Email ingestion only from the user's own connected inbox.
4. **Default view is personal.** Show items for the current user + unassigned urgent. Don't dump the whole list unless asked.
5. **Considerations are a secondary backlog.** Items in `patient/considerations.md` with status `open` can be tracked and closed via `/compass:todo` — they remain in the considerations file for audit (record of what was considered and why).
