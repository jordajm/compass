---
description: Configure or send the optional daily email briefing — top priorities, due/overdue TODOs, upcoming meetings, new considerations, and digest of recent case changes. Configurable cadence, recipients, and content. Drafts by default — never auto-sends without explicit opt-in. Use when the user mentions briefing, daily summary, or configuring email summaries.
---

# /compass:briefing — Email Briefing Configuration & Send

Invoked as: `/compass:briefing [action]` (Claude Desktop) or `@briefing [action]` (Codex).

Configures and sends an optional email briefing summarizing what's new, due, and coming up. Opt-in; requires an email connector. Sent on a schedule (default: daily at 7am local) or on-demand.

---

## Actions

| Action | What it does |
|---|---|
| (none) | Show current config + when next briefing is due |
| `configure` | Interactive config flow (cadence, recipients, content toggles, send mode) |
| `send` | Assemble and send/draft a briefing now |
| `--if-due` | No-op unless the scheduled cadence says we're due; called by the in-app scheduled task (Cowork Scheduled task on Claude Desktop, Codex Automation on Codex Desktop) |
| `preview` | Show what the next briefing would contain — don't send |

---

## Step 0: Detect user and provider

Same identity-resolution pattern as `/compass:email` — check `config/connectors.md` for email provider, use `ToolSearch` to load MCP tools, `get_profile` to resolve identity, match against `care-team/ROSTER.md`.

If `email_provider = none`, fall back to **console-only** briefings: `/compass:briefing send` prints the briefing to the console instead of drafting an email. Scheduled runs still work — they'll print to stdout which the user can redirect / log.

---

## Action: (none) — show config

Read `config/briefing.md`. Print:

```
Briefing is {{enabled/disabled}}.
Cadence: {{cadence}}
Timezone: {{tz}}
Recipients: {{list}}
Send mode: {{draft-only | auto-send-after-preview | auto-send-no-preview}}
Next due: {{computed from last_sent + cadence}}

Content sections enabled: {{list}}
```

---

## Action: configure

Interactive flow to update `config/briefing.md`. For each setting, show the current value and ask whether to change it.

1. **Enable / disable**
2. **Cadence** (options: `daily-<HH:MM>-<tz>`, `weekly-<day>-<HH:MM>-<tz>`, `manual-only`)
3. **Recipients** — show the roster; ask which members to include; allow adding external emails
4. **Send mode** — `draft-only` (default, safest), `auto-send-after-preview`, `auto-send-no-preview`
5. **Content toggles** — list each toggle and ask y/n for each

Write back to `config/briefing.md`. Stamp `last_updated` + `updated_by`.

If the user enabled scheduled cadence and no scheduled task / automation is installed yet, walk them through the in-app setup for the detected host:

- **claude-desktop** → Cowork **Scheduled tasks** — see [`docs/install-cowork-scheduled-task.md`](../../docs/install-cowork-scheduled-task.md).
- **codex-desktop** → Codex **Automations** — see [`docs/install-codex-automations.md`](../../docs/install-codex-automations.md).

If onboarding already generated a scheduled-task prompt and the user installed it, just confirm: the same scheduled task runs `/compass:update --scheduled && /compass:briefing --if-due`, so briefings flow through it — no second scheduler to install.

---

## Action: send

Assemble the briefing and deliver it per `send_mode`.

### Step 1: Assemble content (per content toggles)

Read in parallel (respecting the toggles in `config/briefing.md`):

- **Today's top priorities** — top 3–5 `[URGENT]` or near-due items from `TODO.md`. Filter to items the recipient can act on (if a roster member, their `assignee` items).
- **TODOs due today / overdue** — date-filtered from `TODO.md`.
- **TODOs stale 7+ days** — items unchanged since 7+ days ago.
- **Upcoming meetings (next 7 days)** — from Calendar MCP if available, matched to `care-team/contacts.md`. Link to `reports/prep-*.md` when a prep file exists.
- **New considerations** — `[NEW]` and `[open]` entries in `patient/considerations.md` added since `last_briefing_sent`.
- **New-info digest** — summary of case-file updates since last briefing: `patient/*.md` changes, new emails/meetings, new reports.
- **Research reports generated** — `reports/` entries since last briefing.
- **Files pending ingestion** — `config/ingestion-log.md#Pending` count + note if backlog exists.

### Step 2: Dispatch the writer agent

Dispatch `writer` with `report_type: "brief"` and `audience: "family"` — the briefing is for the recipients (primary caregiver + whoever opted in), so it uses family audience tone.

```json
{
  "report_type": "brief",
  "audience": "family",
  "question": "Daily briefing for {{date}}",
  "content_sections": { ...from Step 1 },
  "recipient_context": {
    "is_primary_caregiver": true | false,
    "preferred_length": "{{from config/preferences.md}}",
    "timezone": "{{}}"
  }
}
```

### Step 3: Deliver per send_mode

- **draft-only** (default): create an email draft in the user's email provider with the briefing content. Subject: *"Compass briefing — {{date}}"*. Tell the user: *"Briefing drafted. Review and send when ready."*
- **auto-send-after-preview**: print the briefing to the console. Wait 30 seconds (or a configurable delay from preferences). If the user has not typed anything, send. If they type anything, treat as cancel and offer to revise.
- **auto-send-no-preview**: send immediately without preview. Only use if the user has explicitly configured this (disclosed in `config/briefing.md`).

If `email_provider = none`: skip delivery. Just print to console.

### Step 4: Stamp

Write `last_briefing_sent: {{now}}` to `config/briefing.md`. This feeds the `--if-due` check.

---

## Action: --if-due

Called by the host's scheduled task (Cowork Scheduled task or Codex Automation). Non-interactive.

1. Read `config/briefing.md`. If `enabled != yes`, exit silently.
2. Compute whether we're at / past the next scheduled time based on cadence + `last_briefing_sent`.
3. If not due, exit silently.
4. If due, run `/compass:briefing send` in **non-interactive mode** — gracefully skip any steps that would prompt. For `send_mode = auto-send-after-preview`, treat the preview wait as "preview skipped" in scheduled context (the recipient can still delete the sent email if needed, but preferences should favor `draft-only` if the user wants human review).

Exit cleanly even if any connector call fails — scheduled runs must not leave error state that blocks the next run.

---

## Action: preview

Run Steps 1–2 of `send` but print the briefing to the console only. Do not deliver. Do not update `last_briefing_sent`.

---

## Behavioral rules

1. **Opt-in only** — briefings are off by default. `/compass:briefing configure` enables them.
2. **Draft-only default** — the safest send mode. Users can upgrade to auto-send deliberately.
3. **Scheduled runs are fail-safe** — `--if-due` never errors loudly. Connectors may be down; users may have revoked auth; don't block tomorrow's run.
4. **Non-primary caregivers can have their own briefings** — the roster's `briefing-recipient: yes` field is per-member. A team member's briefing is scoped to their own assigned TODOs + shared updates.
5. **Privacy** — briefings may contain medical detail. Recipients must be explicit — no broadcasting to the full roster by default.
6. **Audience tone** — always family-audience. Never sugarcoat, never use performative empathy (per CLAUDE.md anti-pattern list).
7. **Include the disclaimer** — every briefing closes with the standard *"This is not medical advice"* footer.
