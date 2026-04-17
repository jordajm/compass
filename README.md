# Compass

> **Disclaimer:** Compass is for informational purposes only to support conversations with your medical team. It does not constitute medical advice. All treatment decisions should be made in consultation with your treating physicians.

---

## What Compass Is

The medical system regularly fails rare-disease patients — not from malice, but from structural mismatch. Specialists operate in silos. Follow-up surveillance falls through the cracks. Families juggle dozens of contacts, appointments, records, and decisions across months or years, often without anyone keeping the whole picture in view. A surveillance scan gets skipped and no one tracks the gap. A tissue sample gets discarded before anyone thinks to bank it. A clinical trial closes before the family knew it existed.

Compass is an AI co-pilot that fills that coordination gap. It maintains a structured knowledge base of the patient's case — medical records, scan history, molecular findings, treatment history, clinical trials — and updates it automatically as new documents arrive. It thinks across the whole case, not just the last appointment. It flags risks proactively, before they become urgent. It drafts communications that are calibrated to their audience — concise and clinical for doctors, clear and honest for family. And it does all of this in coordination with everyone on the care team, not just one person.

Compass is built on the same principles as a great medical advocate: it knows the case cold, thinks two steps ahead, asks the questions no one else is asking, and never lets something fall through the cracks. It is not a replacement for doctors or medical judgment. It is a force multiplier for the family doing the hardest work of their lives.

Compass works equally on Claude Code and Codex. It requires only a folder it can read and write — no servers, no databases, no subscriptions beyond your AI subscription. Your case files stay on your machine and your cloud storage. Nothing is sent anywhere else.

---

## Features

- **Case knowledge base** — ingests medical records (PDFs, Word documents, spreadsheets) and builds a structured summary: molecular profile, treatment history, scan history, timeline, consultation log, clinical trials. Updates automatically as new files arrive.
- **Daily catch-up (`/compass:update`)** — scans new files, emails, calendar, meeting transcripts, and notes; assembles a morning briefing of what's new, what's due, and what needs attention. Runs in file-only mode when email and calendar connectors are not configured.
- **Deep research (`/compass:research`)** — tiered decision framework from standard-of-care through first-principles, with regulatory-status awareness (approved / expanded access / IND pathway / etc.) for every recommendation.
- **Meeting prep (`/compass:prep`)** — concise prep file for any upcoming call: who the contact is, what you've discussed before, open action items, recent developments, suggested questions.
- **To-do management (`/compass:todo`)** — workstream-organized, multi-user, with action items pulled automatically from emails and meeting transcripts. Items carry assignee and attribution.
- **Email drafts (`/compass:email`)** — audience-aware tone: clinical and concise for doctors, plain-language and honest for family. Produces drafts only — you always review and send manually.
- **Contacts (`/compass:contacts`)** — central directory of doctors, consultants, advocates, and specialists with role, institution, specialty, and relationship notes.
- **Daily briefing email (`/compass:briefing`)** — optional scheduled email summarizing what's new, what's due, what's coming up. Configurable recipients, cadence, and content.
- **Hourly scheduled updates** — optional background task that checks for new information and flags material changes without prompting for input.
- **Proactive considerations** — agent flags risks, missed surveillance opportunities, and preparatory steps — written to `patient/considerations.md` and surfaced in every briefing.
- **Multi-user** — family members, advocates, and care team members all use the same shared case folder, with to-do items assignable by name and every change attributed.
- **Multi-host** — works identically in Claude Code (Desktop and CLI) and Codex (CLI and Desktop). One install, both platforms.

---

## What It Connects To

| Connector | Status | What it enables |
|---|---|---|
| Local or cloud-synced folder (Google Drive Desktop, Dropbox, iCloud, etc.) | **Required** | Reading and writing case files |
| Gmail or Outlook | Recommended | Email drafts, inbox scanning, action-item extraction |
| Google Calendar or Outlook Calendar | Recommended | Upcoming-meeting detection, prep file triggering |
| Fireflies, Otter, or Granola | Recommended | Automatic meeting transcript ingestion |
| Apple Notes | Optional | Notes ingestion during `/compass:update` |

All connectors are optional except the folder. The agent degrades gracefully — each step prints a one-line notice and continues if a connector is not configured.

---

## Install — Claude Code

Compass works on both Claude Code CLI and Claude Desktop. Desktop is easier for non-technical users; CLI is faster once you've set it up.

### Claude Desktop (recommended for most users)

1. Open Claude Desktop.
2. Go to **Settings** → **Plugins**.
3. In the marketplace input, paste:
   ```
   jordajm/compass
   ```
4. Click **Add** — Claude Desktop fetches the marketplace entry.
5. Click **Install** on the `compass` plugin listing.
6. Create (or open) a folder for the patient's case. This is where Compass will store all case files. A Google-Drive-Desktop-synced folder works best so you can share it with your care team.
7. In that folder, type `/compass:onboarding`. Compass will guide you through the rest.

### Claude Code CLI

Run these two commands inside any Claude Code session:

```
/plugin marketplace add jordajm/compass
/plugin install compass@compass
```

The first command registers the marketplace; the second installs the `compass` plugin from it. Then:

```
cd /path/to/your/case-folder
```

…and type `/compass:onboarding` in Claude Code. The onboarding skill walks you through everything else.

### Testing a local copy (for developers)

```
git clone https://github.com/jordajm/compass.git
claude --plugin-dir ./compass
```

This loads the plugin directly without installing it — useful when iterating on the plugin itself.

---

## Install — Codex

Codex's plugin ecosystem is UI-driven — plugins install through the in-app Plugins panel. Until Compass is listed in the official Codex plugin directory, use the manual-install path below.

### Manual install (works today)

1. Clone the repository directly into Codex's plugins folder:
   ```bash
   git clone https://github.com/jordajm/compass.git ~/.codex/plugins/compass
   ```
2. Restart Codex. It auto-discovers plugins under `~/.codex/plugins/`.
3. Generate the Codex subagent TOML files from the shared agent source:
   ```bash
   bash ~/.codex/plugins/compass/scripts/build-codex.sh
   ```
   This installs `compass-*.toml` subagent files at `~/.codex/agents/`.
4. Navigate to your case folder and type `@onboarding` — Codex will auto-load the skill and start the guided setup.

### Updating

```bash
cd ~/.codex/plugins/compass && git pull
bash scripts/build-codex.sh
```

### Official directory (coming soon)

Once the Codex plugin directory lists Compass, you will be able to install from the in-app Plugins panel with one click. Check [github.com/jordajm/compass](https://github.com/jordajm/compass) for the updated install path.

---

## First Run

Once installed, start the onboarding conversation:

- **Claude Code**: type `/compass:onboarding`
- **Codex**: type `@onboarding`

Compass will ask you a series of questions — who the patient is, their condition, where you are in treatment, who else is on the care team — and build the case files from your answers. If you have existing medical records, drop them in a `documents/` folder and Compass will read them in batches. No config files to edit.

Onboarding takes 5–15 minutes for a typical case and can be paused and resumed at any point.

If anything feels off at any point, run `/compass:troubleshoot` (or `@troubleshoot` in Codex) for a health check covering plugin version, case file integrity, connector status, and storage writability.

---

## Privacy and Safety

- All case data stays on your machine and your chosen cloud storage (Google Drive, Dropbox, iCloud, etc.). Compass does not transmit your data to any external service beyond the AI model you're already using.
- The AI model (Claude or Codex) processes your inputs per Anthropic's or OpenAI's standard privacy policy. Review their policies if you have concerns about sensitive medical information.
- Compass never sends email automatically. All `/compass:email` operations produce drafts only; you review and send manually.
- Compass never deletes files.
- The disclaimer "This is not medical advice" appears at the top of every research report and every email draft.

---

## Troubleshooting

**Running a health check.** If anything feels off, run `/compass:troubleshoot` (or `@troubleshoot` in Codex) for a diagnostic report. It checks plugin version, case file integrity, connector status, storage writability, and whether a newer Compass release is available — then prints a single table with copyable fixes. Start here before the specific issues below.

**"The agent says it can't find Gmail."**
Gmail is optional. If you haven't configured the Gmail connector, Compass will skip email steps and continue. To enable Gmail, follow the connector setup instructions in `/compass:onboarding` or run it again and choose the Gmail option.

**"My case files aren't being read."**
Make sure you're running Compass from the correct working directory — the folder containing `patient/PROFILE.md`. In Claude Code CLI, `cd` to that folder before launching. In Claude Desktop, open the folder as a project.

**"I'm getting context-limit errors or the session feels slow."**
Start a fresh chat. Long sessions with many files read accumulate context quickly. In Claude Code, type `/clear` or open a new chat. In Codex, start a new thread. Compass saves its state to files so nothing is lost.

**"The agent keeps asking me who I am."**
Configure the Gmail connector (or Outlook). Compass identifies you by matching your connected email account against the care team roster. Without an email connector, it asks at the start of each session. You can also set your name in the `<!-- compass:prefs -->` block in `~/.claude/CLAUDE.md`.

**"I dropped files in `documents/` but they weren't processed."**
Run `/compass:update --ingest` to process new files. Compass processes files in batches (15 files per session by default) to manage context. If you have many files, run `/compass:update --ingest` multiple times — ideally in a new chat each time — until the status shows "all files processed."

**"A care team member can't see the case files."**
Make sure you've shared the case folder with them in Google Drive (right-click → Share in Drive on the web). Each team member needs to install Compass on their own machine, point it at the shared folder, and run `/compass:onboarding` — Compass will recognize the existing case and skip re-setup.

---

## Contributing

Compass is open source under the MIT license. Contributions welcome.

- Bug reports and feature requests: [GitHub Issues](https://github.com/jordajm/compass/issues)
- Pull requests: please open an issue first to discuss the change
- If you've used Compass on a real case and have feedback, please share it — user experience from families in the middle of a medical case is the most valuable input

---

Compass is an open-source generalization of IDA, built by John Jordan.
