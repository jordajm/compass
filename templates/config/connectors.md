<!-- Compass template: this file is created from templates/config/connectors.md during onboarding. Edit freely. -->

# Connectors

> What the user enabled during onboarding. Every skill reads this file and skips steps whose connectors aren't present.
> Only the **filesystem** entry is required. Everything else is optional.
> Re-run `/onboarding` or manually edit this file to change connector choices later.

**Last updated**: {{YYYY-MM-DD}}

---

## Required: Filesystem / cloud storage

| Field | Value |
|---|---|
| **Provider** | {{`google-drive-desktop` \| `dropbox` \| `icloud` \| `onedrive` \| `obsidian` \| `local`}} |
| **Working directory path** | {{e.g., `/Users/name/Google Drive/My Drive/Compass — <Patient>`}} |
| **Documents subfolder** | `documents/` (where the user drops raw PDFs / docx / xlsx for ingestion) |
| **Shared with care team** | {{yes / no}} |

**Notes on Google Drive `.gdoc` shadow files**: If the storage provider is Google Drive Desktop, Compass dual-writes `.html` siblings for files users may view in Drive preview. The rule surfaced in `README.html` at the top of the shared folder: **"Do not 'Open with → Google Docs' on any `.md` file. Open the `.html` sibling instead."**

---

## Optional: Email

| Field | Value |
|---|---|
| **Provider** | {{`gmail` \| `outlook` \| `none`}} |
| **MCP connected** | {{yes / no}} |
| **Connected account** | {{email — used for identity resolution against the roster}} |
| **Verified scopes** | {{e.g., `view`, `draft` — populated by the post-connection probe in `/onboarding`. If `draft` is missing, briefings and outbound email will fail silently — reconnect with every permission box checked.}} |

**What this enables**: `/email` (draft / read / reply), email ingestion in `/update`, email briefings via `/briefing`. If `none`, these features print a skip message and continue.

---

## Optional: Calendar

| Field | Value |
|---|---|
| **Provider** | {{`google-calendar` \| `outlook-calendar` \| `none`}} |
| **MCP connected** | {{yes / no}} |
| **Verified scopes** | {{e.g., `read`, `write` — populated by the post-connection probe in `/onboarding`.}} |

**What this enables**: upcoming-meeting detection during `/update` (auto-creates prep TODOs for meetings in the next 7 days). Also used by `/prep` when invoked against a calendar event rather than a named contact.

---

## Optional: Meeting transcripts

| Field | Value |
|---|---|
| **Provider** | {{`fireflies` \| `otter` \| `granola` \| `none`}} |
| **MCP connected** | {{yes / no}} |
| **Verified scopes** | {{e.g., `list`, `read-transcript` — populated by the post-connection probe in `/onboarding`.}} |

**What this enables**: `/update` pulls recent meeting transcripts, saves to `meeting-notes/`, extracts action items into TODO.md, and updates `patient/consultation-log.md` when the meeting is with a known contact.

---

## Optional: Notes

| Field | Value |
|---|---|
| **Provider** | {{`apple-notes` \| `notion` \| `none`}} |
| **MCP connected** | {{yes / no}} |
| **Verified scopes** | {{e.g., `list`, `read` — populated by the post-connection probe in `/onboarding`.}} |

**What this enables**: `/update` scans recent notes for case-related action items and adds them to TODO.md.

---

## Scheduled tasks

| Field | Value |
|---|---|
| **Hourly `/update`** | {{enabled / disabled}} |
| **Scheduler** | {{`cowork-scheduled-task` \| `codex-automation` \| `cron` \| `none`}} |
| **Cron expression** | {{e.g., `0 * * * *` for top-of-hour; empty if using Cowork/Codex in-app scheduler or disabled}} |
| **Hook-triggered `/update` on new file drop** | {{enabled / disabled}} |

**Notes**:
- Scheduled `/update` runs with the `--scheduled` flag — fully non-interactive, skips anything that would prompt, tolerates missing / expired connectors.
- **Preferred scheduler by host:**
  - **Claude Desktop (Cowork):** use the built-in **Scheduled tasks** feature. Walkthrough with screenshots: https://github.com/jordajm/compass/blob/main/docs/install-cowork-scheduled-task.md
  - **Codex desktop:** use the built-in **Automations** feature (Standalone, custom schedule `0 * * * *`). Walkthrough: https://github.com/jordajm/compass/blob/main/docs/install-codex-automations.md
  - **Claude Code CLI / Codex CLI:** use the OS `crontab` (macOS / Linux) or Task Scheduler (Windows). Example line for hourly runs:
    `0 * * * * cd /path/to/case-folder && claude -p "/compass:update --scheduled && /compass:briefing --if-due"`
- Hook-triggered runs use `hooks/hooks.json` in the plugin — see that file for enablement instructions.

---

## Host detection

| Field | Value |
|---|---|
| **Detected host** | {{`claude-code-cli` \| `claude-desktop` \| `codex-cli` \| `codex-desktop`}} |
| **Last detected on** | {{YYYY-MM-DD}} |

Compass re-detects the host at session start. This field records the most recent detection for troubleshooting.
