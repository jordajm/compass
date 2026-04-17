<!-- Compass template: this file is created from templates/config/preferences.md during onboarding. Edit freely. -->

# Preferences

> This file mirrors the per-user preferences stored in the delimited `<!-- compass:prefs -->` block in your host-level memory file:
> - Claude Code: `~/.claude/CLAUDE.md`
> - Codex: `~/.codex/AGENTS.md`
>
> The host-level block is the source of truth that follows you across cases. This file is a case-local copy for reference and for new team members to see the current user's settings.
> When you change a preference here, Compass also updates the corresponding block in your host-level memory file.

**Last updated**: {{YYYY-MM-DD}}
**This file reflects**: {{user email — so other team members know whose prefs these are}}

---

## Identity

| Field | Value |
|---|---|
| **Full name** | {{}} |
| **Address me as** | {{nickname or preferred form — e.g., "Pat" not "Patrick Salisbury"}} |
| **Role on care team** | {{see `care-team/ROSTER.md` for full list}} |
| **Timezone** | {{IANA — e.g., `America/New_York`}} |

---

## Communication style

| Field | Value |
|---|---|
| **Preferred tone** | {{`concise` \| `warm-professional` \| `formal` \| `direct`}} |
| **Default summary length** | {{`one-paragraph` \| `three-paragraphs` \| `bulleted-full`}} |
| **Jargon tolerance** | {{`high` — I'm medically literate \| `medium` — explain unfamiliar terms \| `low` — always gloss medical terms}} |
| **Sugar-coating tolerance** | **zero** — always be frank, never give false hope, never use performative empathy. (This is the Compass default and should not be changed. It's listed here so users understand the posture.) |

---

## Defaults

| Field | Value |
|---|---|
| **Default `/research` report type** | {{`detailed` \| `brief` \| `action_plan` \| `trial_summary`}} |
| **Default `/update` cadence when scheduled** | {{e.g., `hourly` \| `every-4-hours` \| `daily-7am` \| `manual`}} |
| **Default `/briefing` cadence** | {{`daily-7am` \| `weekly-monday` \| `disabled` \| `manual-only`}} |
| **Include me on the daily briefing recipient list** | {{yes / no}} |
| **Auto-send briefing vs. draft-only** | {{`draft-only` (default) \| `auto-send-after-preview`}} |

---

## Context management

Compass surfaces a "this is a natural stopping point" suggestion at major break points (end of `/update`, end of `/research`, end of an ingestion batch). When it does, it tailors the advice to the detected host.

| Field | Value |
|---|---|
| **Preferred prompt wording** | {{`subtle` (one-line hint) \| `explicit` (clear instruction) \| `none` (don't show)}} |
| **Auto-suggest new chat after large tasks** | {{yes / no}} |

---

## Email preferences (when user is the email sender)

| Field | Value |
|---|---|
| **Sign as** | {{name used in email sign-offs}} |
| **Default CC on care-team communications** | {{comma-separated emails or empty}} |
| **Max length the email drafter should produce** | 15 sentences (Compass default, do not exceed) |

---

## Notes to the agent

> Free-form. The agent reads this paragraph every session. Use it to share anything Compass should remember about how you like to work together.

{{Free-form notes. Example: "I'm new to managing complex medical cases. Err on the side of explaining more rather than less. I prefer receiving drafts I can edit rather than finished artifacts I have to decide on."}}
