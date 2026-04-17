<!-- Compass template: this file is created from templates/patient/consultation-log.md during onboarding. Edit freely. -->

# Consultation Log

> Chronological record of specialist consultations, second opinions, and advisor calls.
> Every entry captures: date, who, institution, topic, key points, decisions, follow-up.
> `/update` appends new entries as meeting notes / emails arrive. `/prep` reads this file when preparing for the next meeting with a given contact.

---

## Template Entry

```markdown
## YYYY-MM-DD — {{Consultant name}} ({{Institution}})

**Modality**: {{in-person / video / phone / email-exchange}}
**Attendees**: {{who was there, including care-team members}}
**Topic**: {{short subject line}}

### Key Points
- {{point 1 — the clinician's assessment, recommendation, or observation}}
- {{point 2}}
- {{point 3}}

### Decisions Made
- {{decision 1 — what was agreed}}
- {{decision 2 — what was deferred, to whom, by when}}

### Open Questions
- {{question the consultant raised that needs follow-up}}
- {{question we raised that wasn't fully answered}}

### Follow-Up Items
- {{action item — who owns it — by when}}
- {{these should also land in TODO.md with workstream + assignee}}

### Relevant Files
- {{link to `reports/` research that was referenced}}
- {{link to `meeting-notes/` if a transcript was captured}}
- {{link to `patient/*.md` updates that resulted}}
```

---

## Entries

<!-- Add new consultations here, most recent first. The onboarding agent will create an initial entry when the user describes their current care team. Subsequent entries come from /update, /prep follow-ups, and manual additions. -->

## YYYY-MM-DD — {{First consultant name}} ({{Institution}})

**Modality**: {{}}
**Attendees**: {{}}
**Topic**: {{}}

### Key Points
-

### Decisions Made
-

### Open Questions
-

### Follow-Up Items
-

### Relevant Files
-
