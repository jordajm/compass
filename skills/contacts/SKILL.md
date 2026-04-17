---
description: CRUD interface over the care team roster and external contacts. Add / list / update / remove contacts, transfer the primary-caregiver role, approve pending self-adds, and generate invite handoff messages for new team members. Use when the user mentions adding, inviting, updating, or looking up a contact or team member.
---

# /compass:contacts — Care Team & Contact Management

Invoked as: `/compass:contacts [action] [args]` (Claude Code / Desktop) or `@contacts [action] [args]` (Codex).

CRUD interface over `care-team/ROSTER.md` (internal care-team members who use Compass) and `care-team/contacts.md` (external doctors, consultants, advocates, administrators, researchers).

---

## Step 0: Detect user

Same identity-resolution pattern as `/compass:update` / `/compass:email` — resolve current user name + role from `care-team/ROSTER.md` using the connected email account. Store for attribution.

---

## Actions

| Action | What it does |
|---|---|
| `list` | Show all contacts or filter by criteria |
| `add` | Guided add flow (auto-detects internal vs. external) |
| `update <name> field:value` | Modify an existing entry |
| `remove <name>` | Mark as removed (retains audit record) |
| `set-primary <email>` | Transfer primary-caregiver role (requires current primary's confirmation) |
| `approve <email>` | Approve a pending self-add from `ROSTER.md#Pending-approvals` |
| `invite <name>` | Re-generate the invite handoff message for a team member |

---

## Action: list

`/compass:contacts list` — print full roster + contacts.
`/compass:contacts list "role:surgeon"` — filter by role.
`/compass:contacts list "workstream:targeted-therapy"` — filter by workstream.
`/compass:contacts list "team"` — only show internal care team (ROSTER.md).
`/compass:contacts list "external"` — only show external contacts (contacts.md).

---

## Action: add

`/compass:contacts add` — asks the user whether this is an internal care-team member or an external contact, then runs the appropriate sub-flow.

### Sub-flow: External contact (to `care-team/contacts.md`)

Ask in sequence:
1. Name (as they sign professionally)
2. Email
3. Role / specialty
4. Institution + location
5. How this contact joined the case (referral / research / direct reach-out)
6. Workstreams involved
7. Audience type for tone (doctor / administrator / researcher / family / patient) — offer the default based on role
8. Any known style preferences

Write to `care-team/contacts.md` in the correct role section (Primary care team / Surgeons / Second opinions / Trial coordinators / Advocates). Stamp `first_engaged` = today and `added_by` = current user.

### Sub-flow: Internal care-team member (to `care-team/ROSTER.md`)

This is the invite flow from plan §8b — the existing user invites someone to co-use Compass.

Ask in sequence:
1. Name
2. Email
3. Role on the care team (`co-caregiver`, `medical-advocate`, `family-observer`, etc.)
4. Access level (`full`, `read-only`, `todo-only`) — offer default based on role
5. Timezone (if different from primary)
6. Should they receive the daily briefing? (y/n)

Write to `care-team/ROSTER.md` with `invite-status: pending-first-run` and `invited-on: today`.

**Then offer two things**:

1. **Walk through Drive folder sharing** (if the storage provider is Google Drive Desktop or similar):
   - "Open the case folder in Drive (web)."
   - "Right-click the folder → Share."
   - "Add `{{email}}`. Set 'Editor' (so Compass can write from their session) or 'Viewer' (for read-only roles)."
   - "Click Send."

2. **Generate the handoff message** — a ready-to-send email / text the existing user forwards. Format:

```
Subject: I've added you to {{Patient}}'s Compass setup

Hi {{Name}},

I'm using a tool called Compass to help coordinate {{Patient}}'s care — medical
records, doctor contacts, appointments, and research. I just shared the case
folder with you so you can help.

To get set up on your machine:

1. Install Google Drive Desktop if you don't have it: google.com/drive/download
2. Find "Compass — {{Patient}}" in your Drive (it's shared with you).
3. Install Compass in either Claude Code (claude.com/code) or Codex
   (platform.openai.com/codex). Ask me which you'd prefer — I can help with either.
4. Open the shared folder in Compass and type /onboarding (Claude) or @onboarding (Codex).
   It'll recognize the existing case and walk you through the rest.

Your role is {{role}}. Compass will filter to-dos to what's assigned to you by default.

Let me know when you're set up or hit any friction.
```

If an email connector is available, offer to drop this into the user's email drafts. Otherwise, print for copy-paste.

---

## Action: update

`/compass:contacts update "<name>" field:value field:value`

Example: `/compass:contacts update "{{Name}}" role:co-caregiver access-level:full`

Resolve the contact (ROSTER.md or contacts.md), apply the change, stamp `updated_by: {{current user}}, {{date}}`.

For role changes on roster members, Compass adds a one-line notice: *"Your role on the care team was updated to {{new-role}} by {{current user}}."* — this is surfaced on the affected user's next Compass session.

---

## Action: remove

`/compass:contacts remove "<name>"` — marks `invite-status: removed` (for roster) or appends a `removed_on: YYYY-MM-DD` note (for external contacts). Does not delete — past contributions remain attributed.

For roster removals: remind the current user to also revoke the Drive folder share separately. Compass cannot revoke Drive access on their behalf.

---

## Action: set-primary

`/compass:contacts set-primary "<email>"` — transfers the `primary-caregiver` role from the current primary to the named roster member. Requires:

1. The named email must already be an `active` roster member.
2. The current primary caregiver must confirm.

If the user initiating the transfer **is** the current primary, confirm directly and flip the role. If the user is someone else, add a pending-transfer entry to `ROSTER.md` and tell the initiator: *"I've requested the transfer. {{Current primary}} will get a confirmation prompt on their next session. Until they confirm, {{they}} is still the primary."*

---

## Action: approve

`/compass:contacts approve "<email>"` — approves a pending self-add. Must be run by the current primary caregiver.

1. Read `care-team/ROSTER.md#Pending approvals`.
2. Move the matching entry into the main roster table.
3. Set `invite-status: active`.
4. Stamp `approved_by: {{primary}}, {{date}}`.

If the current user isn't the primary caregiver, refuse: *"Only the primary caregiver can approve roster adds. Ask {{primary name}} to run this next time they're in Compass."*

---

## Action: invite

`/compass:contacts invite "<name>"` — re-runs the handoff-message generation for an existing roster member. Useful when the original invite email was lost.

---

## Behavioral rules

1. **Single source of truth**: `care-team/ROSTER.md` and `care-team/contacts.md` are the authoritative registries. Every skill that needs contact info reads from here.
2. **Audit trail over deletion** — `remove` keeps records. The history of who joined / left / changed role is useful.
3. **Attribution on every write** — `added_by`, `updated_by`, `approved_by`, `removed_by` stamps with dates.
4. **Primary caregiver is a role, not a person** — never hardcode. The role is defined by the current ROSTER.md entry. Transfer via `set-primary`.
5. **Pending approvals surface** — whenever the current primary caregiver runs any Compass command, if `ROSTER.md#Pending approvals` has entries, a one-line reminder appears at the top: *"{{N}} pending team member(s) waiting for your approval. Run `/compass:contacts approve <email>` to review."*
6. **Identity = email match** — if someone's email changes, update via `/compass:contacts update`. Don't create a duplicate entry.
