<!-- Compass template: this file is created from templates/care-team/contacts.md during onboarding. Edit freely. -->

# External Contacts

> Doctors, consultants, advocates, researchers, trial coordinators, administrators — everyone outside the internal care team who interacts with this case.
> `/email` resolves recipients from this file. `/prep` reads this file when preparing for meetings. `/contacts` is the CRUD interface over this file.
> Keep email addresses accurate. When a contact's role or affiliation changes, update here first — the rest of Compass reads from here.

---

## Template row

| Field | What goes here |
|---|---|
| `name` | Full name as the contact uses it professionally |
| `email` | Primary work email (use institutional domain when available) |
| `role_specialty` | Job title + specialty — e.g., "Pediatric oncologist" or "Surgical oncologist — sarcoma" |
| `institution` | Hospital / company / university |
| `location` | City + state/country (helps with travel-logistics questions) |
| `workstreams` | Comma-separated list of workstreams this contact is involved with — matches to TODO.md workstream headings |
| `relationship` | `primary-oncologist` \| `second-opinion` \| `surgeon` \| `trialist` \| `advocate` \| `advisor` \| `administrator` \| `other` |
| `first_engaged` | YYYY-MM-DD — when this contact first joined the case |
| `last_interaction` | YYYY-MM-DD — most recent email / meeting / consultation |
| `audience_type` | `doctor` \| `administrator` \| `researcher` \| `family` \| `patient` — used by `email-drafter` agent for tone calibration |
| `notes` | Free-form: style preferences (prefers brief vs. detailed), time-zone, best way to reach them, history of interactions |

---

## Primary care team

### {{Name — e.g., Dr. {{Last name}} }}

- **Email**: {{}}
- **Role / specialty**: {{}}
- **Institution**: {{}}
- **Location**: {{}}
- **Workstreams**: {{}}
- **Relationship**: primary-oncologist
- **First engaged**: {{YYYY-MM-DD}}
- **Last interaction**: {{YYYY-MM-DD}}
- **Audience type**: doctor
- **Notes**: {{}}

---

## Surgeons & procedure teams

### {{Name}}

- **Email**: {{}}
- **Role / specialty**: {{}}
- **Institution**: {{}}
- **Location**: {{}}
- **Workstreams**: {{}}
- **Relationship**: surgeon
- **First engaged**: {{YYYY-MM-DD}}
- **Last interaction**: {{YYYY-MM-DD}}
- **Audience type**: doctor
- **Notes**: {{}}

---

## Second opinions & consultants

### {{Name}}

- **Email**: {{}}
- **Role / specialty**: {{}}
- **Institution**: {{}}
- **Location**: {{}}
- **Workstreams**: {{}}
- **Relationship**: second-opinion
- **First engaged**: {{YYYY-MM-DD}}
- **Last interaction**: {{YYYY-MM-DD}}
- **Audience type**: doctor
- **Notes**: {{}}

---

## Trial coordinators & administrators

### {{Name}}

- **Email**: {{}}
- **Role / specialty**: {{}}
- **Institution**: {{}}
- **Location**: {{}}
- **Workstreams**: {{}}
- **Relationship**: trialist
- **First engaged**: {{YYYY-MM-DD}}
- **Last interaction**: {{YYYY-MM-DD}}
- **Audience type**: administrator
- **Notes**: {{}}

---

## Advocates, advisors, community

### {{Name}}

- **Email**: {{}}
- **Role / specialty**: {{}}
- **Institution**: {{}}
- **Location**: {{}}
- **Workstreams**: {{}}
- **Relationship**: advocate
- **First engaged**: {{YYYY-MM-DD}}
- **Last interaction**: {{YYYY-MM-DD}}
- **Audience type**: {{doctor | family | researcher — depends on person}}
- **Notes**: {{}}

---

## Add-contact checklist (for `/contacts add`)

When adding a new contact, `/contacts` asks for:
1. Name (full, as they sign emails)
2. Email
3. Role / specialty
4. Institution + location
5. How this person came into the case (referral / research / direct reach-out)
6. Which workstream(s) they're involved with
7. Audience type for tone calibration (if unclear, the agent asks: "Are they a medical professional, an administrator, a researcher, or someone closer to a family audience?")
8. Any known style preferences (brevity, jargon tolerance, response-time expectations)
