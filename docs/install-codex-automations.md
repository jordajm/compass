# Setting up a Compass Automation in Codex

This guide walks through creating a Codex **Automation** that runs `/compass:update` hourly and drafts a daily email briefing when one is due. Compass generates a ready-to-paste prompt for you during `/compass:onboarding` — this guide shows where it goes.

> **Note:** Screenshots for this guide will be added after the first Codex testing pass. The steps and field names reflect the Codex app as of April 2026.

> **Disclaimer:** Compass is for informational purposes only to support conversations with your medical team. It does not constitute medical advice. All treatment decisions should be made in consultation with your treating physicians.

---

## Before you start

You need:

- The Codex desktop app installed and signed in.
- The Compass plugin installed and onboarded for Codex. If you haven't done that yet, run `/compass:onboarding` first.
- A Codex **project** that points at your Compass case folder (the one `/compass:onboarding` set up). Project-scoped automations require that the project folder be available on disk.
- The **prompt** Compass printed at the end of onboarding. If you lost it, re-run `/compass:onboarding` and skip to the scheduled-task step, or ask Compass: "Generate the scheduled-task prompt again."

The whole process takes about a minute.

---

## Step 1 — Open the Automations pane

In the Codex sidebar, click **Automations**. You'll see any existing automations, or an empty state if this is your first one.

*(Screenshot placeholder: `codex-01-automations-sidebar.png`.)*

---

## Step 2 — Create a new automation

Click the new-automation button at the top of the Automations pane.

*(Screenshot placeholder: `codex-02-new-automation.png`.)*

---

## Step 3 — Choose Standalone (not Thread)

Codex offers two automation types:

- **Standalone** — each run starts a fresh context and reports its findings to the Triage inbox. Use this.
- **Thread** — a recurring "wake-up call" attached to an existing conversation thread. Not what you want for Compass.

Select **Standalone**.

*(Screenshot placeholder: `codex-03-standalone-vs-thread.png`.)*

---

## Step 4 — Paste the Compass prompt

Paste the prompt Compass generated during onboarding into the **Prompt** field. It's the long instruction block that tells Codex what to do each hour.

*(Screenshot placeholder: `codex-04-prompt-field.png`.)*

---

## Step 5 — Scope the automation to your Compass project

In the project selector, pick the Compass project you set up during onboarding. The automation will run with that project's working directory as its context — the same as if you ran `codex` interactively inside the case folder.

> Codex requires the app to be running and the project folder to be available on disk for project-scoped automations to fire. If you regularly close Codex, expect missed runs.

*(Screenshot placeholder: `codex-05-project-selector.png`.)*

---

## Step 6 — Set the schedule (hourly via cron)

Unlike Claude Cowork, Codex doesn't have a one-click "Hourly" preset. Pick **Custom** and enter `0 * * * *` (top of every hour).

If you want a less frequent check-in, Codex also offers Daily and Weekly presets. For Compass's purposes, hourly is the recommended cadence.

*(Screenshot placeholder: `codex-06-schedule-cron.png`.)*

---

## Step 7 — Save

Click **Save**. The new automation appears in your Automations pane and will start running at the top of the next hour.

*(Screenshot placeholder: `codex-07-saved-automation.png`.)*

---

## Step 8 — Where findings show up

Every automation run that produces findings lands in **Triage** (Codex's inbox for background work). Runs with no findings are auto-archived — so on quiet days, you may see nothing new, which is normal.

You can filter Triage by automation name to see only Compass runs.

---

## Troubleshooting

- **The automation didn't run.** Codex needs the app to be running at the scheduled time, and the project folder must be available on disk. Check both.
- **I don't see any results in Triage.** Runs with no findings are auto-archived. If `/compass:update` finds nothing new since the last run, it will exit quietly — that's expected.
- **The run is failing with "no such project" or "can't find patient/PROFILE.md".** Edit the automation and make sure the project scope points at your Compass project, and that the project's folder path matches your case folder.
- **I want to change the schedule or the prompt.** Open the automation from the Automations pane and edit it — no need to delete and recreate.
- **I lost the prompt.** Run `/compass:onboarding` and skip to Step 9 (Scheduled updates), or ask Compass in an interactive chat: "Regenerate the scheduled-task prompt for Codex."
- **Briefings aren't being drafted.** Check that Gmail (or your email connector) is still connected and that the briefing cadence in `config/briefing.md` is set. Run `/compass:briefing preview` interactively to see what would be sent.
