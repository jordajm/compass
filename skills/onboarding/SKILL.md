---
description: Guided first-run setup for a new case, or abbreviated onboarding for a team member joining an existing case. Use when the user says they are starting a new case, adding a team member, or when no patient/PROFILE.md exists in the working directory.
---

# /compass:onboarding — First-Run Setup & Team Member Onboarding

Invoked as: `/compass:onboarding` (Claude Desktop) or `@onboarding` (Codex)

This skill guides a new user through Compass setup in a paced, conversational flow. It detects whether this is a fresh case or an existing shared case, and routes accordingly. State is saved after each step so onboarding can be interrupted and resumed.

---

## Pre-Step: Detect Host Environment

Before any greeting, identify the host. Compass supports only two hosts: **Claude Desktop** (which ships Cowork) and **Codex Desktop**.

```
CODEX env var present  → host = "codex-desktop"
Otherwise              → host = "claude-desktop"
```

Store `host` — it determines wording in Steps 8 and 9.

**Legacy state migration.** If `config/onboarding-state.md` (or the `<!-- compass:prefs -->` block) records `host` as `claude-code-cli`, `codex-cli`, `codex`, or `unknown`, treat the stored value as missing. Re-detect using the rule above and write the corrected value back silently on first read. Compass no longer supports CLI hosts; if a user is genuinely running CLI, they fall through to `claude-desktop` wording and the first scheduling step will point them at Claude Desktop.

---

## Pre-Step: Route — Fresh vs. Existing Case

Check whether `patient/PROFILE.md` exists in the current working directory.

**If `patient/PROFILE.md` does NOT exist** → run **Side A: Full Onboarding** (Steps 1–10 below).

**If `patient/PROFILE.md` EXISTS** → run **Side B: Team Member Onboarding** (see bottom of this file).

---

## Side A: Full Onboarding — Steps 1–10

### Resume Logic

Read `config/onboarding-state.md` if it exists. It records which steps are complete:

```markdown
## Onboarding State
last_updated: YYYY-MM-DD HH:MM
completed_steps: [1, 2, 3]
in_progress_step: 4
onboarding_complete: false
data:
  user_name: ...
  patient_name: ...
  ...
automation:
  hourly_updates:
    configured: true | false
    installed: confirmed | unconfirmed | declined
  daily_briefing:
    enabled: true | false
    send_mode: draft-only | auto-send-after-preview | auto-send-no-preview
```

Branch on state:

- **No state file** → start at Step 1.
- **Partially complete** (`onboarding_complete` absent or false, `in_progress_step` set) → greet the user by name, summarize what's done, and resume at `in_progress_step`.
- **Fully complete** (`onboarding_complete: true`) → do **not** re-run the full flow. Greet the user, print a short summary of what's set up from state (patient, user, host, connectors, scheduled-task status, briefing cadence), then ask:

  > Everything looks set up. Is there a step you want to redo, or something to add? I can revisit any of: **who's on the team**, **connectors**, **scheduled updates & briefings**, **documents folder**. Or just tell me what's off.

  Map the user's answer to a step and re-run just that step (not the full flow):

  | User says | Re-run step |
  |---|---|
  | "team" / "roster" / "add a member" | Step 6 |
  | "documents" / "storage folder" / "Drive path" | Step 7 |
  | "connectors" / "Gmail" / "Calendar" | Step 8 |
  | "scheduled" / "hourly" / "briefing" / "automation" | Step 9 |

  When re-entering Step 9 from a revisit, read the existing `automation.*` values from state and ask "did you actually install the Cowork Scheduled task / Codex Automation yet?" before marking it complete. Do not assume a previously-stored `hourly_updates.installed: confirmed` is still accurate — re-verify.

  If the user names nothing specific, suggest `/compass:update` or `/compass:todo` and exit.

Save state to `config/onboarding-state.md` after each step completes. Create the `config/` directory if needed.

---

### Step 1: Welcome + Who Are You

Say:

> Hi, I'm Compass. I help families and care teams coordinate complex medical cases — tracking records, research, contacts, to-dos, and communications all in one place.
>
> Before we start, what should I call you? And what's your email address? (I use it to match you to the care team roster later.)

Collect: `user_name`, `user_email`.

Save to state. Proceed.

---

### Step 2: Who Is the Patient

Ask:

> Are you the patient, or are you helping someone else?

If helping someone else:

> What's the patient's name? (First name is fine if you prefer.)

If they are the patient themselves:

> Got it — we'll set this up for your own care coordination.

Collect: `patient_name`, `user_is_patient` (boolean), `user_relationship` (self / caregiver / co-caregiver / advocate / family-observer / other).

Save to state. Proceed.

---

### Step 3: The Condition

Ask:

> What's the diagnosis or medical situation? Take it at whatever level of detail you have — a rough description is fine to start, and we can fill in details from records later.

Collect: `diagnosis_summary` (free text — may be one sentence or several paragraphs).

Ask: "What's the current treatment phase? (Newly diagnosed / active treatment / monitoring / re-planning / other — or skip if you're not sure.)"

Collect: `treatment_phase` (optional).

Save to state. Proceed.

---

### Step 4: Location and Travel

Ask:

> Where do you live? (City and country is enough — this helps me find relevant specialists and trials.)

Collect: `location_city`, `location_country`.

Ask:

> If a specialist in another city or country could help, are you able to travel? How far?

Options to offer: local only / regional (within country) / national / international / not sure yet.

Collect: `travel_willingness`.

Save to state. Proceed.

---

### Step 5: Budget and Insurance

Say (exact wording required):

> This next one is a sensitive question but it matters: insurance covers different things in different places, and for rare diseases, some of the best options are not always covered. I'll never push you toward something you can't afford — but knowing your situation helps me recommend what's realistic. Are you working strictly within insurance, or is there a self-funded amount you'd consider for options insurance doesn't cover? Rough ranges are fine, or skip if you'd rather.

Collect: `budget_posture` (free text or "skip"). Mark `budget_sensitive: true` in PROFILE.md always.

Save to state. Proceed.

---

### Step 6: Care Team Roster

Ask:

> Who else is involved in the case? Spouse, siblings, medical advocates, friends helping coordinate? I'll set each of them up so they can use Compass too.

For each person the user names, collect:
- Name
- Email (optional — can be added later)
- Role: primary-caregiver / co-caregiver / medical-advocate / family-observer / patient / other
- Access level: full / read-only / todo-only
- Whether they should receive daily briefing emails

If the user says "just me" or "no one else right now", that's fine — roster starts with just them.

Save to state. Proceed.

---

### Step 7: Documents Folder + Storage Setup

**Core principle:** Never ask the user to run a shell command or navigate the filesystem. The skill (Claude) should guess the folder path, verify it exists using its own tools (`Glob`, `Bash ls`, `Read`), confirm with the user in plain language, and only fall back to asking them to type a path as a last resort. If the folder doesn't exist yet, ask permission to create it at the probed location.

#### Storage choice

Ask:

> Where would you like to store your case files? I'll read and write files there.
>
> Options:
> 1. **Google Drive** (recommended) — syncs across devices, easy sharing with care team
> 2. **Dropbox / iCloud / OneDrive** — any cloud sync provider works
> 3. **Obsidian vault** — if you use Obsidian for notes
> 4. **Local only** — just on this machine, no sync

#### Path probing (applies to every branch below)

For every storage option, the flow is **probe → confirm → create if needed**. The skill must never demand that the user paste a full path unless all probes fail.

1. Settle on a folder name. Default for the Drive/cloud branches: `Compass — [Patient Name]`. Default for local-only: `Compass/[patient-slug]`.
2. Probe candidate parent paths for the operating system, in order, using `Glob` / `Bash ls`:

   **macOS Google Drive**
   - `~/Library/CloudStorage/GoogleDrive-*/My Drive/` (new-style Drive Desktop)
   - `~/Google Drive/My Drive/` (legacy)

   **Windows Google Drive**
   - `C:\Users\{USERNAME}\My Drive\`
   - `C:\Users\{USERNAME}\Google Drive\My Drive\`

   **iCloud Drive (macOS)**
   - `~/Library/Mobile Documents/com~apple~CloudDocs/`

   **Dropbox**
   - `~/Dropbox/`
   - `~/Library/CloudStorage/Dropbox/` (macOS, newer)

   **OneDrive**
   - `~/Library/CloudStorage/OneDrive-*/` (macOS)
   - `~/OneDrive/` (fallback)
   - `C:\Users\{USERNAME}\OneDrive\` (Windows)

   **Obsidian** — no canonical parent; probe `~/Documents/`, `~/Obsidian/`, `~/Vaults/` as a convenience.

   **Local only** — `~/Compass/` is the default parent; no probe needed.

3. Check whether the target folder (`<parent>/<folder-name>/`) already exists. Outcomes:
   - **Exactly one parent matches and the folder already exists there** → present: "I found `<full-path>` — is that the folder you want to use?" Proceed on yes.
   - **Exactly one parent matches but the folder doesn't exist yet** → present: "I can see `<parent>`. I'll create `<folder-name>` there — OK?" Proceed on yes, then create.
   - **Multiple parents match** → list each as a numbered option and ask the user to pick.
   - **Zero parents match** → fall back to the last-resort prompt below.

4. Last-resort fallback (only if no probe succeeded): "I couldn't find `<provider>` installed in any of the usual places. Could you paste the full local path where you'd like the case files, or the path to an existing `<provider>` folder?"

Whenever the chosen folder doesn't exist yet, use the `Write` / `Bash mkdir -p` tools to create it and the `documents/` subfolder, after confirming with the user.

#### If Google Drive chosen (default path — most polished):

1. "I'll need Google Drive Desktop installed on your machine. If you don't have it yet, download it at https://www.google.com/drive/download/ (macOS: dmg file, Windows: exe installer). Let me know when you're ready."
2. Wait for user confirmation.
3. "Sign in to Google Drive Desktop with the Google account you want to use for Compass."
4. Run the path-probing flow above with folder name `Compass — [Patient Name]`. If the probe finds the folder already, confirm and reuse. If it finds `My Drive` but no Compass folder, create it. If nothing is found, fall back to the last-resort prompt.
5. Store the confirmed path as `working_directory`.
6. "If you have existing medical records, scan reports, or documents, drop them into the `documents/` subfolder I'm about to create. Compass will process them in batches — you don't have to do it all at once."
7. Note the `.gdoc` rule: "One important rule for Drive: **do not open `.md` files with Google Docs.** Open the `.html` sibling file instead — I'll create one alongside every report. I'll pin this rule in the folder's README."

#### If Dropbox / iCloud / OneDrive:

Run the path-probing flow for the chosen provider with folder name `Compass — [Patient Name]`. Confirm the detected path or create the folder at the found parent. Only ask the user to paste a path if every probe fails. Store as `working_directory`. No dual-write `.html` is needed for these since they render `.md` natively — set `html_dual_write: false` in preferences.

#### If Obsidian vault:

Probe the Obsidian convenience locations (`~/Documents/`, `~/Obsidian/`, `~/Vaults/`) for existing vault directories (a vault is any folder containing a `.obsidian/` subfolder). If any are found, list them and let the user pick. Only ask for a pasted path if no candidate vault is detected. Once a vault is chosen, present: "I'll create `<vault>/Compass — [Patient Name]/` inside the vault — OK?" and on yes, create that subfolder. Store the subfolder path (not the vault root) as `working_directory`. Set `html_dual_write: false`.

#### If local only:

Default to `~/Compass/[patient-slug]/`. Confirm with the user, create the folder, and store as `working_directory`. Set `html_dual_write: false`.

Save to state. Proceed.

---

### Step 8: Connectors Menu

Use `ToolSearch` at runtime to discover which MCP tools are available. Check for the following families:

| Connector | Detection pattern |
|-----------|------------------|
| Gmail | `ToolSearch "gmail"` returns results |
| Outlook | `ToolSearch "outlook"` returns results |
| Google Calendar | `ToolSearch "calendar"` returns results |
| Fireflies | `ToolSearch "fireflies"` returns results |
| Otter | `ToolSearch "otter"` returns results |
| Apple Notes | `ToolSearch "notes"` returns results |
| Any others | Scan remaining ToolSearch results |

Present the findings:

> Here's what I found:
> - Gmail: [connected / not detected]
> - Google Calendar: [connected / not detected]
> - Fireflies: [connected / not detected]
> - Apple Notes: [connected / not detected]
>
> Connected tools will be used automatically during `/compass:update`. Any you'd like to add? I can give you setup instructions. Or skip for now.

For any connector the user wants to add, warn first, then give host-specific instructions:

> **When the permissions dialog appears, check every box.** Compass needs every scope the connector exposes. For Gmail, that includes both "View email messages" and "Create drafts" — if either is unchecked, briefings and email drafts will silently fail. The same rule applies to Google Calendar (read + write), Outlook, and any other connector with multiple permission checkboxes.

| Host | Gmail / Calendar / other connectors |
|------|--------------------------------------|
| claude-desktop | Settings → Connectors → pick the provider → sign in → **on the Google / Microsoft consent screen, check every permission box** → click Allow |
| codex-desktop | Edit `~/.codex/config.toml` — add the server entry. When the OAuth consent screen opens in the browser, check every permission box before clicking Allow. |

#### Post-connection capability probe

After the user adds a connector, don't trust "connected" — probe each required scope. Use `ToolSearch` to resolve the exact MCP tool names the current host exposes (they're namespaced like `mcp__claude_ai_Gmail__gmail_list_drafts` in Claude Desktop; Codex Desktop uses different prefixes). Then invoke one tool per scope and report the outcome inline.

| Connector | Scopes to verify | Capability probes (resolve exact tool names via `ToolSearch`) |
|-----------|-----------------|---------------------------------------------------------------|
| Gmail | View, Draft | **View**: profile + list-messages (e.g., `gmail_get_profile` + `gmail_search_messages`). **Draft**: list-drafts (e.g., `gmail_list_drafts`). |
| Outlook | View, Draft | **View**: profile + list-folders (or list-messages). **Draft**: list-drafts (or equivalent). Exact names vary by Outlook MCP vendor. |
| Google Calendar | Read, Write | **Read**: list-calendars + list-events for the next 7 days. **Write**: if a non-destructive `create-event` exists, dry-run with a past-dated or tentative event the user can delete; if not, note Write as "not verified" and flag in the report. |
| Fireflies / Otter | List transcripts | List recent transcripts (any non-empty list or clean empty list proves auth works). |
| Apple Notes | List notes | List notes (same logic). |

**A probe fails** if the call returns an auth / scope / permission error. An empty list is not a failure — it means the scope works but there's no data.

Report per connector, with one ✓ or ✗ per scope exercised. Success case:

> Gmail: connected
>   ✓ View (list-messages works)
>   ✓ Draft (list-drafts works)

Partial-scope failure:

> Gmail: connected, but the Draft scope is missing.
> I can read your inbox, but I can't create email drafts — so briefings won't work.
> To fix: open Settings → Connectors → Gmail → Reconnect, and this time **check every permission box** on the consent screen.

If a probe fails, offer to try again after the user reconnects, rather than proceeding with a broken scope. If a scope cannot be probed non-destructively (e.g., Calendar Write without a safe create-event), record it as "not verified" and move on — don't fabricate a pass.

Write detected (and newly added) connectors — including the verified scopes — to `config/connectors.md`.

Save to state. Proceed.

---

### Step 9: Scheduled Updates and Briefings

Ask:

> Would you like Compass to check for new information automatically?
>
> - **Hourly updates**: Compass runs `/compass:update --scheduled` in the background and flags anything new.
> - **Daily email briefing**: A summary email each morning (requires Gmail or Outlook connector).

If they want hourly updates, route based on the detected host. Compass supports only Desktop hosts — Claude Desktop uses Cowork **Scheduled tasks**, Codex Desktop uses **Automations**. There is no CLI path and no cron path.

| Host | Setup |
|------|-------|
| claude-desktop | Use Cowork's built-in **Scheduled tasks** feature (ships with every Claude Desktop build). Sidebar → **Scheduled** → **New task** → paste the Compass prompt (generated below) → click **Work in a project** and pick the Compass project → **Frequency: Hourly** → **Save**. Step-by-step guide with screenshots: [`docs/install-cowork-scheduled-task.md`](../../docs/install-cowork-scheduled-task.md). |
| codex-desktop | Use Codex's built-in **Automations** feature. Sidebar → **Automations** → new automation → **Standalone** → paste the Compass prompt (generated below) → scope to the Compass project → **Custom schedule: `0 * * * *`** → **Save**. Step-by-step guide: [`docs/install-codex-automations.md`](../../docs/install-codex-automations.md). |

#### Generate and display the scheduled-task prompt (Desktop hosts)

For the Cowork and Codex desktop branches, generate and display the natural-language prompt the user will paste into the scheduled task. The same prompt works for both hosts. Fill in `<Patient Name>` from state before displaying.

```
Run /compass:update --scheduled for the Compass — <Patient Name> project. This will:
  - Pull new emails, calendar events, and meeting transcripts since the last run.
  - Ingest any new files dropped in the documents/ folder.
  - Update patient files (current-findings, consultation-log, considerations).
  - Refresh TODO.md with any new action items, flag overdue items, and note items stale 7+ days.
  - Run the proactive considerations pass and surface new risk flags.

Then run /compass:briefing --if-due. If the briefing cadence says we're due, assemble today's briefing and save it as a draft in Gmail (or whichever email connector is configured). Do not auto-send.

If any connector is missing or expired, skip that step and continue. Never block.
```

Display the prompt in a copyable code block, then add host-matching copy:

- **claude-desktop:** "Paste this into the Description field when you create the Cowork Scheduled task. Set Frequency to Hourly and click **Work in a project** to select your Compass project. The step-by-step walkthrough with screenshots is at [`docs/install-cowork-scheduled-task.md`](../../docs/install-cowork-scheduled-task.md)."
- **codex-desktop:** "Paste this into the Prompt field when you create the Codex Automation. Choose **Standalone** and scope it to your Compass project. For hourly, pick a custom schedule and enter `0 * * * *`. The step-by-step walkthrough is at [`docs/install-codex-automations.md`](../../docs/install-codex-automations.md)."

#### Installation checkpoint — do not mark complete on assent alone

After the user picks a host and the skill displays the generated scheduled-task prompt, **wait for confirmation before marking automation installed**. The previous behavior of flipping `hourly_updates: true` after a "yes please" caused Compass to claim automation was active when nothing had been created in the host UI.

Ask:

> Let me know when you've created the [Cowork Scheduled task / Codex Automation] — I'll wait. Or, if you'd rather set it up later, I'll note that it's not installed yet and remind you next time you run `/compass:update`.

Write the state using the split schema:

```yaml
automation:
  hourly_updates:
    configured: true        # user chose a cadence
    installed: confirmed    # when user reports the task/automation is created
    # or installed: unconfirmed — user said "later"
    # or installed: declined — user opted out of hourly updates
```

Treat `installed: unconfirmed` as the default until the user explicitly confirms creation. Do not fabricate `confirmed`.

If they want daily briefing:
- Ask for preferred send time (default: 7:00 AM local)
- Ask for recipients (default: self; offer adding roster members who opted in)
- Ask: auto-send or draft-only (default: draft-only)
- Write to `config/briefing.md`

Save to state. Proceed.

---

### Step 10: Commit to Memory — Materialize All Files

Now create all case files from templates. For each, read the corresponding template from `templates/` and write it into the working directory with the onboarding data filled in.

#### Files to create:

**`patient/PROFILE.md`** — Fill in: patient name, user name + relationship, diagnosis summary, location, travel willingness, budget posture (with sensitivity flag), treatment phase, country (for regulatory-status context). Leave molecular/clinical sections stubbed with instructive comments.

**`care-team/ROSTER.md`** — Primary user as first entry (role from Step 2), plus any roster members from Step 6. Each entry:
```
### [Name]
email: [email]
role: [role]
access_level: [full/read-only/todo-only]
timezone: [if collected]
briefing_recipient: [yes/no]
invited: [today's date]
status: active
```

**`care-team/contacts.md`** — Empty template (external contacts — to be populated via `/compass:contacts add`).

**`config/connectors.md`** — List of detected connectors and their status.

**`config/preferences.md`** — User name, preferred address, timezone (ask if not already collected), ingestion batch size (default 15), html_dual_write setting.

**`config/briefing.md`** — Briefing cadence, recipients, content, send mode from Step 9.

**`config/ingestion-log.md`** — Empty ingestion log (header only).

**`patient/considerations.md`** — Empty stub.

**`TODO.md`** — Empty stub with header and format comment.

**`README.html`** — A simple HTML file for Drive: "Welcome to Compass — [Patient Name]. Do not open .md files with Google Docs. Open the .html sibling instead."

Create stub files (with instructive comments) for: `patient/molecular.md`, `patient/treatment-history.md`, `patient/scan-history.md`, `patient/current-findings.md`, `patient/case-timeline.md`, `patient/clinical-trials.md`, `patient/treatment-options.md`, `patient/consultation-log.md`.

Create `documents/` directory (empty, for user to drop files into).

Create `reports/` and `meeting-notes/` directories.

#### Write user preferences to global config:

Determine the preferences block target:
- claude-desktop → `~/.claude/CLAUDE.md`
- codex-desktop → `~/.codex/AGENTS.md`

Read the file. Find the `<!-- compass:prefs -->` block. If it exists, update it. If not, append it at the end. Write only within the delimiters — never touch content outside them.

```
<!-- compass:prefs -->
name: [user_name]
address_as: [preferred name]
timezone: [timezone]
working_directory: [path]
patient_name: [patient_name]
host: [host]
<!-- /compass:prefs -->
```

#### Summary and wrap-up:

Print a summary of everything created. Then:

> You're all set. Compass is now watching [patient]'s case.
>
> You don't need to memorize any commands. Just say what you want in plain language — I'll figure out the right tool:
>
> - "What's new today?"              →  catches you up
> - "Draft a reply to Dr. [name]."   →  email draft
> - "What's on my to-do list?"       →  to-do view
> - "Research [question]."           →  deep research
> - "Prep me for tomorrow's call."   →  meeting prep
> - "Who's on the care team?"        →  contacts
>
> If something ever seems off, say "troubleshoot" and I'll run a health check.
>
> Power-user shortcuts (optional):
> `/compass:update`  `/compass:research`  `/compass:email`  `/compass:todo`
> `/compass:prep`    `/compass:contacts`  `/compass:briefing`  `/compass:troubleshoot`

Host-specific closing note:

| Host | Note |
|------|------|
| claude-desktop | "Use 'New chat' in the sidebar between tasks to keep things fast." |
| codex-desktop | "Start a new session between tasks to keep things fast." |

Mark all steps complete in `config/onboarding-state.md`.

---

## Side B: Team Member Onboarding (Existing Case Detected)

Triggered when `patient/PROFILE.md` exists and the user runs `/compass:onboarding`.

### B-Step 1: Identity Resolution

Read `care-team/ROSTER.md`.

Attempt identity match:
1. `ToolSearch "gmail"` — if Gmail available, call `gmail_get_profile`. Match the returned email against roster entries.
2. `ToolSearch "outlook"` — if Outlook available, call the equivalent profile tool. Match similarly.
3. If no email connector: read roster aloud and ask "Which one is you?"
4. If the user's email matches a roster entry with `status: pending-first-run` → auto-match, flip to `status: active`.
5. If the user's email does not match any roster entry:
   > "I don't see you in the team roster yet. What's your name and email? I'll add a pending entry, and [primary caregiver name] will get a prompt to confirm your role next time they run Compass."
   Add pending entry to ROSTER.md under `## Pending Approvals`.

### B-Step 2: Greet and Orient

Read `patient/PROFILE.md`. Identify the primary caregiver name and patient name.

Greet:
> "Welcome, [name]. [Primary caregiver] added you to [patient]'s care team as [role]. I'm Compass — let me get you oriented in about 2 minutes."

Provide a brief case summary scoped to their access level:
- full access: patient name, diagnosis, current treatment phase, active workstream count, one-paragraph "where we are now" from PROFILE.md
- read-only: same but note they cannot create/edit items
- todo-only: just the task view relevant to them

### B-Step 3: Collect Their Preferences

Collect and write to **their** machine's global config (NOT the shared case files):

Ask:
- "How should I address you?" → `address_as`
- "What's your preferred response length — brief summaries or detailed explanations?" → `draft_verbosity`
- "What timezone are you in?" → `timezone`
- "Would you like to receive daily briefing emails?" → `briefing_opt_in`

Write to `<!-- compass:prefs -->` block in `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md` (per host detection). Never overwrite content outside the delimited block.

### B-Step 4: Their Connector Setup

Walk through connector setup for **their** accounts (not the primary user's):
- Gmail/Outlook: their own inbox for email drafts
- Calendar: their calendar for prep items
- Fireflies/Otter: if they record their own meetings

Use `ToolSearch` to show what's already connected.

### B-Step 5: Scoped Capabilities Reminder

> "Your to-do list is filtered to items assigned to you by default. You can see and edit shared case files. Your emails draft from your own account — not from [primary caregiver]'s. When you run `/compass:update`, you'll see new info since your last run, tracked separately from other team members."

Show available commands and wrap up.

---

## Behavioral Rules

1. **Pace the conversation.** Don't dump all questions at once. One step at a time. If the user seems overwhelmed, offer to pause: "We can stop here and pick this up next time — just run `/compass:onboarding` again."
2. **Save state after every step.** If interrupted, the next `/compass:onboarding` call resumes exactly where it left off.
3. **Never overwrite existing case data.** If `patient/PROFILE.md` already has content, merge new information — don't replace.
4. **Never write outside the `<!-- compass:prefs -->` block** in global config files.
5. **Graceful degradation.** If a connector isn't available during setup, don't block onboarding. Note it and move on.
6. **Context-coaching at the end.** After the full flow, say: "This was a long session — a good moment to start a fresh chat for your first `/compass:update`." Use the host-appropriate wording above.
