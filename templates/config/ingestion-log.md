<!-- Compass template: this file is created from templates/config/ingestion-log.md during onboarding. Edit freely. -->

# Ingestion Log

> Tracks every case-document file Compass has processed from `documents/`, what was extracted, and what remains pending.
> Populated automatically by `/update --ingest`. Users generally should not edit this file by hand.
> When a file appears in `documents/` with a new content hash, Compass re-processes it and supersedes the prior extraction.

**Last updated**: {{YYYY-MM-DD HH:MM}}
**Source folder**: `{{documents/}}` (or absolute path if different)

---

## Processed

| File | SHA256 (first 12) | Processed on | Processed by | Extracted to |
|---|---|---|---|---|
| (empty — `/update --ingest` populates this table) | | | | |

<!-- Example row:
| 2026-03-15-pathology-report.pdf | a3b7c1d8ef42 | 2026-04-17 | jane@example.com | patient/molecular.md, patient/consultation-log.md |
-->

---

## Pending

| File | Size | First seen | Notes |
|---|---|---|---|
| (empty — files dropped into `documents/` land here until processed) | | | |

<!-- The ingestion batch default is 15 files or ~80k tokens per run, whichever comes first. The user runs `/update --ingest` repeatedly (ideally in fresh chats to manage context) until this table is empty. -->

---

## Superseded

> When a file is re-processed because its content hash changed, the prior entry moves here for audit.

| File | Prior hash | New hash | Re-processed on | Reason (inferred) |
|---|---|---|---|---|

---

## Errors

| File | Error | Suggested action |
|---|---|---|
| (empty) | | |

<!-- Common errors:
     - OCR failed (scanned PDF with poor quality) → ask user to re-scan or type up key content
     - File too large → user should split or provide a summary
     - Unsupported format → convert to .pdf / .md / .txt
     - Extraction timed out → retry with `/update --reingest <filename>`
-->

---

## Commands

- `/update --ingest` — process the next batch of pending files.
- `/update --reingest <filename>` — force re-processing of a specific file (useful when the extraction was wrong or the target file changed).
- `/update --ingest-status` — print a summary: X of Y files processed, Z pending, W errors.
