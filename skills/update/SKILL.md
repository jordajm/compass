---
description: Daily catch-up — scans new files, emails, calendar, meeting transcripts, and notes since last run; updates the case knowledge base and to-do list; runs a proactive considerations pass; prints a morning briefing. Use when the user asks for a catch-up, says "what's new", or starts their day with Compass. Also invoked with --scheduled for cron and --ingest for batch file processing.
---

# /compass:update — Daily Catch-Up

Invoked as: `/compass:update` or `/compass:update "last 3 days"` or `/compass:update --scheduled` or `/compass:update --ingest` (Claude Code / Desktop) or `@update …` (Codex)

This skill runs the daily catch-up in one command: scans new files in the case folder, checks Apple Notes for recent meeting notes, pulls meeting transcripts from Fireflies (or Otter), checks the calendar for upcoming meetings, scans email for action items, updates the to-do list, runs a proactive considerations pass, and prints a morning briefing.

**Flags:**
- `--scheduled` — non-interactive mode for cron invocation. Skips any step that would prompt. Never blocks waiting for input.
- `--ingest` — large-volume document ingestion mode. Enumerates `documents/`, hash-compares against `config/ingestion-log.md`, processes a bounded batch (default 15 files or ~80k tokens), updates the ingestion log.
- `--reingest <filename>` — force re-ingestion of a specific file regardless of hash match.

---

## Step 0: Verify Identity + Access Level

Before proceeding, determine who is running the update and what access they have.

1. Read `care-team/ROSTER.md`.
2. Use `ToolSearch "gmail"` to check if Gmail MCP is available.
3. If available, call `gmail_get_profile` to get the connected account email.
4. Match the returned email against roster entries in `ROSTER.md`.
   - **Matched, access_level = full**: proceed in **full mode** (all sources enabled).
   - **Matched, access_level = read-only or todo-only**: proceed in **file-scan-only mode** (Steps 2 and 4 only; skip Steps 2.3, 2.5, 2.7, 3). Inform: "Running in file-scan mode based on your roster access level ([role])."
   - **No match or Gmail not connected**: proceed in **file-scan-only mode**. Note in briefing which sources were skipped.
5. Store identity (`current_user_name`, `current_user_email`) for attribution in all writes this session.

In `--scheduled` mode: if identity cannot be determined without prompting, proceed as file-scan-only and log the reason.

---

## Step 1: Determine Time Window

Read `config/update-state.json` from the working directory.

```json
{ "last_run": "2026-04-17T08:30:00-05:00", "last_run_by": "user@example.com" }
```

- **File exists:** Use `last_run` as the start time.
- **File doesn't exist (first run):** Default to 24 hours ago.
- **User provides an override** ("last 3 days", "since Monday"): Use that instead of the saved state. (Skip override parsing in `--scheduled` mode.)

Convert the start time to formats needed by each source:
- `find -newermt` argument for file search
- Apple Notes date filter
- Fireflies `fromDate` ISO timestamp
- Calendar `timeMin` RFC3339 timestamp (calendar uses a 7-day forward window from now, not from `last_run`)
- Gmail `after:YYYY/MM/DD` query

Tell the user the window: "Catching up since [date/time]..." (suppress in `--scheduled` if no output destination).

---

## Step 2: Scan New / Modified Files

Run via Bash:

```bash
find . -newermt "<start_time>" -type f \
  -not -path './.claude/*' \
  -not -path './.git/*' \
  -not -path './reports/*' \
  -not -path './meeting-notes/*' \
  -not -path './documents/*' \
  -not -path './config/*' \
  -not -name 'TODO.md' \
  -not -name 'CLAUDE.md' \
  -not -name 'README.*' \
  -not -name 'update-state.json'
```

If no new files found, note "No new files" and skip to the next step.

For each file found:
1. Read the file (supports PDFs via Read tool, markdown, text).
2. Determine which case files should be updated based on content:

| Content Type | Target Case Files |
|---|---|
| Scan / imaging results | `patient/current-findings.md`, `patient/scan-history.md` |
| Lab results | `patient/current-findings.md` |
| Consultation / appointment notes | `patient/consultation-log.md`, `care-team/contacts.md` |
| Treatment changes | `patient/treatment-history.md`, `patient/case-timeline.md` |
| Molecular / genomic results | `patient/molecular.md` |
| Trial or treatment options discussed | `patient/treatment-options.md`, `patient/clinical-trials.md` |
| Strategy / priority changes | `patient/considerations.md` |

3. Read the target file(s), add new information in the appropriate section, preserving existing content.
4. Track what was updated for the summary (filename → which case files changed).

---

## Step 2.3: Check Apple Notes

Check `config/connectors.md` for Apple Notes status. Also run `ToolSearch "notes"` — if either confirms availability, proceed. If neither confirms, skip and note in briefing.

Search Apple Notes for notes related to the case:
- Use keywords from `patient/PROFILE.md` (patient name, diagnosis keywords) to build search queries.
- Filter results to notes created or modified since `last_run`.

For each relevant recent note:
1. Read the full note content.
2. Extract action items and add to `TODO.md` (assignee: current user, added_by: current user).
3. Update case files if the note contains clinically relevant info (same routing table as Step 2).
4. Save a copy to `meeting-notes/YYYY-MM-DD-apple-note-slug.md` (and `.html` sibling if `html_dual_write` is enabled).

**If Apple Notes tools are unavailable:** print "(Apple Notes not connected — skipped)" and continue.

---

## Step 2.5: Pull Meeting Transcripts

Check `config/connectors.md` for Fireflies or Otter status. Run `ToolSearch "fireflies"` and `ToolSearch "otter"` to confirm availability. Use whichever is connected; if neither, skip.

### For Fireflies:

Use `fireflies_get_transcripts` with `fromDate` = `last_run`, `toDate` = now, `limit` = 50.

Filter to case-relevant meetings using keywords from `patient/PROFILE.md` and contact names from `care-team/contacts.md`.

For each relevant meeting:
1. Fetch full meeting data (`fireflies_fetch`).
2. Save to `meeting-notes/YYYY-MM-DD-meeting-slug.md` (and `.html` sibling if enabled):

```markdown
# [Meeting Title]
**Date:** YYYY-MM-DD HH:MM
**Participants:** [list]

## Summary
[AI-generated overview]

## Action Items
[Extracted action items]

## Key Decisions
[Clinical decisions, next steps, agreements]

## Full Transcript
[Complete transcript with speaker attribution]
```

3. Extract action items → add to `TODO.md` with `assignee: current_user`, `added_by: current_user`.
4. Update case files if meeting contains clinically relevant info (same routing table).

**If Fireflies tools are unavailable or error:** print "(Meeting transcripts: Fireflies not connected — skipped)" and continue.

### For Otter:

Follow the same pattern using Otter's MCP tools (discovered via `ToolSearch "otter"`).

---

## Step 2.7: Check Upcoming Calendar

Check `config/connectors.md` for Calendar status. Run `ToolSearch "calendar"` to confirm. If neither confirms, skip and note in briefing.

Fetch upcoming events:
- `calendarId`: primary
- `timeMin`: now (RFC3339)
- `timeMax`: 7 days from now (RFC3339)
- `maxResults`: 20

Filter to case-relevant events using keywords from `patient/PROFILE.md` and contact names from `care-team/contacts.md`.

For each relevant event happening in the next 2–7 days:
1. Check if a prep item already exists in `TODO.md` for this meeting (fuzzy match on contact + date). Skip if tracked.
2. Create a preparation to-do item:
   - Description: "Prepare for [event title] with [attendees]"
   - Target date: 1–2 days before the meeting
   - Status: `[NEXT]` (or `[URGENT]` if tomorrow or today)
   - Assignee: current user
   - Added_by: current user
3. For events today or tomorrow, call them out prominently in the briefing.

**If Calendar tools are unavailable:** print "(Google Calendar not connected — skipped)" and continue.

---

## Step 3: Scan Email

Check `config/connectors.md` for email provider (`gmail` or `outlook`). Run `ToolSearch "gmail"` or `ToolSearch "outlook"` to confirm availability.

### Gmail:

Search with `after:YYYY/MM/DD` plus keywords from `patient/PROFILE.md` (patient name, diagnosis keywords). Also build a supplementary `from:` query using email addresses from `care-team/contacts.md`.

Read up to 10 most recent relevant threads. For each thread, extract action items:
- Respond to a question
- Schedule a call or appointment
- Send information
- Make a decision
- Follow up on something

Cross-reference with existing `TODO.md` to avoid duplicates. Add new items with `assignee: current_user`, `added_by: current_user`, priority `[URGENT]` or `[NEXT]` based on urgency signals.

If the time gap is large (>7 days) and many results exist, note it: "Many emails to catch up on. Consider running `/compass:todo "pull todos from email"` for a thorough review."

### Outlook:

If `config/connectors.md` specifies `email_provider: outlook`, use the Outlook MCP tools discovered via `ToolSearch "outlook"` with equivalent search parameters.

**If email tools are unavailable:** print "(Email not connected — skipped)" and continue.

Update `TODO.md` "Last updated" timestamp.

---

## Step 3.5: Proactive Considerations Pass

After processing all new information, dispatch the `case-analyst` agent with:
- All new content ingested this update (file excerpts, meeting summaries, email summaries)
- Current `patient/PROFILE.md` contents
- Current `patient/considerations.md`
- Current `patient/treatment-history.md` and `patient/current-findings.md`

The case-analyst runs a structured `consider` pass asking:
- What does this new information mean clinically?
- What should the care team be thinking about that may not be on their radar?
- **Did the care team decide to skip, delay, or modify any screening/test/treatment?** If so, log as a risk and research alternatives. (Any skipped test is a risk event — log it with concrete alternatives, not just a flag.)
- Is the surveillance intensity appropriate for the risk category?
- What should be done now to prepare if the current plan doesn't work? (Tissue banking, liquid biopsy, second-opinion outreach, trial pre-screening.)
- Does this change the treatment tier (standard-of-care / extended options / first-principles)?

For each consideration surfaced, write a structured entry to `patient/considerations.md`:

```markdown
## [NEW] YYYY-MM-DD — [Brief title]
**Trigger**: [What new information caused this]
**Risk / Observation**: [Clinical reasoning]
**Suggested action**: [Concrete next step]
**Tier**: [1 / 2 / 3]
**Status**: open
— [current_user_name], YYYY-MM-DD
```

If any consideration is assessed as high-priority, add a `[RISK-FLAG]` item to `TODO.md` pointing to it.

Skip this step if no new information was ingested (no files, no meetings, no emails with new content).

---

## Step 4: Review TODO.md

Read `TODO.md`. Identify:
- **Overdue:** Items past their target date
- **Stale:** Items with `[NEXT]` or `[URGENT]` status unchanged for 7+ days
- **Blocked:** Items in `[BLOCKED]` where the blocker may have resolved (check email threads for replies)
- **Unassigned urgent items:** Flag these for current user's attention

---

## Step 4.5: Ingest Mode (--ingest flag only)

If `--ingest` flag is set, run this step instead of (or after) the normal file scan:

1. Read `config/ingestion-log.md`. Load the set of already-processed file hashes.
2. Enumerate all files in `documents/` recursively.
3. For each file, compute a content hash (SHA256, first 12 chars is sufficient for display).
4. Compare to processed hashes. Files not in the log (or with changed hash) are candidates.
5. Process a bounded batch:
   - Default cap: **15 files or ~80k tokens of extracted content, whichever comes first.**
   - Configurable via `ingestion_batch_size` in `config/preferences.md`.
6. For each file in the batch:
   - Read the file (PDF, docx, text, etc.).
   - Dispatch `case-analyst` to extract clinically material content.
   - Route extracted content to the appropriate case files (`patient/molecular.md`, `patient/scan-history.md`, `patient/treatment-history.md`, `patient/consultation-log.md`, etc.).
   - Log the file in `config/ingestion-log.md` under `### Processed` with hash, date, and target files.
7. Files that fail (OCR error, corrupt, etc.) go to `### Errors` in the log with a suggested action.
8. At the end of the batch, print:
   - "Processed [N] of [total] files. [remaining] remaining. Run `/compass:update --ingest` again (in a new conversation) to continue."
   - Or: "All [N] files processed. You're fully caught up."

In `--scheduled` mode, `--ingest` is suppressed unless explicitly configured in `config/preferences.md` (`scheduled_ingest: true`).

---

## Step 5: Print Morning Briefing

```markdown
## Morning Update — [date]
> Covering since [last_run date/time] · Run by: [current_user_name]
> Case files: [N of M processed (P pending)] | All sources current

### Files Processed
- [filename] → updated [case files]
- (or "No new files since last update")

### Notes Processed
- [note title] — [X action items added] → saved to meeting-notes/
- (or "Apple Notes not connected — skipped")

### Meetings Processed
- [date] [title] — [participants] — [X action items] → meeting-notes/filename.md
- (or "Meeting transcripts not connected — skipped")

### Upcoming Meetings (Next 7 Days)
- **[TOMORROW]** [time] — [title] with [attendees] — prep todo created
- (or "Google Calendar not connected — skipped")

### New Email Action Items
- [sender]: [brief description] — [URGENT/NEXT] — added
- (or "Email not connected — skipped")

### New Considerations
- [YYYY-MM-DD] [title] — [tier] — open
- (or "No new considerations this update")

### To-Do Highlights
- [N] URGENT items need attention
- [N] items unchanged for 7+ days
- [N] new items added this update

### Today's Top Priorities
1. [most urgent item]
2. [next]
3. [next]
```

Keep this to one screenful. Prioritize ruthlessly — the user can run `/compass:todo` for the full list.

In `--scheduled` mode, write the briefing to `reports/YYYY-MM-DD-scheduled-briefing.md` instead of printing (and `.html` sibling if enabled). The daily `/compass:briefing` skill will pick it up.

---

## Step 6: Save State

Write `config/update-state.json`:

```json
{
  "last_run": "[ISO timestamp]",
  "last_run_by": "[current_user_email]"
}
```

Write only after a successful run. If interrupted, the timestamp does not advance, so the next run re-covers the same period.

---

## Context-Coaching Note

After the briefing, if the session has been long (many tool calls, large files read), say:

> "This is a natural stopping point. Starting a fresh chat for your next task will be faster."

Host-specific wording:
- claude-code-cli: "Type `/clear` or start a new session."
- claude-desktop: "Click 'New chat' in the sidebar or type `/clear`."
- codex: "Start a new session."

---

## Behavioral Rules

1. **Don't ask for confirmation before updating case files or TODO.md.** Speed is the point — the user reviews the briefing afterward.
2. **Be concise in the briefing.** Scannable in 30 seconds.
3. **Prioritize ruthlessly.** Top Priorities: 3–5 items max.
4. **Flag surprises.** Unexpected news (new scan results, treatment changes, cancellations) gets called out prominently.
5. **Don't duplicate work.** Files modified before `last_run` are skipped.
6. **Graceful degradation.** Missing connectors print a skip message and do not block the run.
7. **`--scheduled` is fully non-interactive.** Never prompt, never block, never fail hard on a missing connector.
8. **Attribution on every write.** Every item added to `TODO.md` or `considerations.md` carries `added_by` and timestamp.
