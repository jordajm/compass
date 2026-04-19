<!-- Compass template: this file is created from templates/config/briefing.md during onboarding. Edit freely. -->

# Briefing Configuration

> Controls the optional daily (or weekly) email briefing. Configure via `/briefing configure`. Sent via `/briefing send` or `/briefing --if-due` (called by the scheduled task).
> Requires an email connector in `config/connectors.md`. If none, briefings print to the console instead.

**Last updated**: {{YYYY-MM-DD}}

---

## Schedule

| Field | Value |
|---|---|
| **Enabled** | {{yes / no}} |
| **Cadence** | {{`daily-7am` \| `daily-<HH:MM>-<tz>` \| `weekly-monday-7am` \| `manual-only`}} |
| **Timezone** | {{IANA timezone from the primary caregiver's preferences}} |

If `manual-only`, `/briefing --if-due` is a no-op — briefings only send when explicitly invoked.

---

## Recipients

| Name | Email | Include | Notes |
|---|---|---|---|
| {{Primary caregiver}} | {{email}} | yes | Default recipient |
| {{Team member name}} | {{email}} | {{yes / no}} | Opt-in only — see `care-team/ROSTER.md` briefing-recipient field |
| {{Spouse, family}} | {{email}} | {{yes / no}} | Non-roster recipients allowed |

Rule: only roster members with `briefing-recipient = yes` are included by default. Non-roster recipients must be added explicitly here.

---

## Send mode

| Field | Value |
|---|---|
| **Mode** | {{`draft-only` \| `auto-send-after-preview` \| `auto-send-no-preview`}} |

- **draft-only** (default, recommended): Compass creates a Gmail draft. User reviews and sends manually. Safest option.
- **auto-send-after-preview**: Compass shows the briefing in the console, waits a configurable number of seconds, then sends. Interruptible.
- **auto-send-no-preview**: Compass sends without preview. Only use if the user trusts the briefing logic fully and runs unattended.

---

## Content toggles

What goes into each briefing. Turn sections off if they're noisy.

| Section | Enabled | Description |
|---|---|---|
| **Today's top priorities** | yes | Top 3–5 urgent items from TODO.md |
| **TODOs due today / overdue** | yes | Dated items whose target date is today or past |
| **TODOs not updated in 7+ days** | yes | Stale items that need attention |
| **Upcoming meetings (next 7 days)** | yes | With links to `reports/prep-*.md` if `/prep` has been run |
| **New [NEW] considerations** | yes | Items added to `patient/considerations.md` since last briefing |
| **New-info digest since last briefing** | yes | Summary of case file updates, new emails/meetings, new reports |
| **Research reports generated** | yes | Links to reports created since last briefing |
| **Files pending ingestion** | yes | If `/update --ingest` has a backlog, flag it (so the user can schedule a session to work through them) |

---

## Last sent / next due

| Field | Value |
|---|---|
| **Last briefing sent** | {{YYYY-MM-DD HH:MM — auto-updated by `/briefing send`}} |
| **Next due** | {{computed from cadence + last sent}} |

Compass uses these fields to decide whether `/briefing --if-due` should run when called by the scheduled task.
