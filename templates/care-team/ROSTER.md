<!-- Compass template: this file is created from templates/care-team/ROSTER.md during onboarding. Edit freely. -->

# Care Team Roster

> The people using Compass to coordinate this case. Distinct from `care-team/contacts.md` (which tracks external doctors, consultants, advocates).
> Every row is one person who has — or will have — their own Compass session on their own machine, working from the shared case folder.
> Roles determine what each person can do via Compass (see "Access levels" below).

---

## Access levels

| Level | Can do |
|---|---|
| `full` | All skills. Their own `/update` runs across all enabled connectors. Their own `/email` drafts in their own inbox. Can edit any shared file. Can approve self-adds. |
| `read-only` | All read operations: view TODOs, read reports, read case files. No writes to shared files. No email drafting. |
| `todo-only` | Can view and modify the shared TODO list. No other writes. Useful for care-team members who only help with task-tracking. |

---

## Roles

Every entry has a `role`. Compass uses `role` to scope behavior:

- `primary-caregiver` — the operational lead. There should be exactly one at a time (transferable via `/contacts set-primary`).
- `patient` — the patient themselves, if they are using Compass.
- `co-caregiver` — a second parent, partner, or primary-caregiver partner.
- `medical-advocate` — a professional or friend helping navigate the medical system.
- `family-observer` — family members who want visibility but aren't driving decisions.
- `care-team-member` — catch-all for others actively contributing.

---

## Roster

| Name | Email | Role | Access level | Timezone | Briefing recipient | Invite status | Invited on |
|---|---|---|---|---|---|---|---|
| {{Primary name}} | {{primary@example.com}} | primary-caregiver | full | {{e.g., America/New_York}} | yes | active | {{YYYY-MM-DD}} |
| {{Co-caregiver name}} | {{copart@example.com}} | co-caregiver | full | {{tz}} | yes | {{pending-first-run | active}} | {{YYYY-MM-DD}} |
| {{Advocate name}} | {{advocate@example.com}} | medical-advocate | full | {{tz}} | optional | {{}} | {{}} |

<!-- Invite statuses:
     - `pending-first-run` — invited by the primary, has not yet opened Compass on their own machine
     - `active` — has opened Compass and identified themselves
     - `removed` — kept in the roster for audit but excluded from current-user resolution
-->

---

## Pending approvals

<!-- When a team member self-adds during /onboarding (Side B) but wasn't pre-added by the primary caregiver, they land here. The primary caregiver approves via `/contacts approve <name>` (see skills/contacts/SKILL.md) on their next session. -->

<!-- Example entry:
| Name | Email | Self-identified role | Self-added on | Context |
|---|---|---|---|---|
| {{Name}} | {{email}} | {{role they claimed}} | {{YYYY-MM-DD}} | {{how they arrived — shared folder name, email domain hint, etc.}}
-->

---

## Notes

- Identity resolution at session start: Compass uses `gmail_get_profile` (or `outlook_get_profile`) to identify the current user, then matches against this roster. If no email connector is available, Compass asks the user to pick their entry from the roster.
- `primary-caregiver` is never hardcoded to a specific email — it is whoever holds the role in this file. Transfer is done via `/contacts set-primary <email>` which asks the current primary to confirm.
- When a member is marked `removed`, Compass keeps their past contributions attributed. The Drive folder share must be revoked separately (Compass reminds the primary to do this).
