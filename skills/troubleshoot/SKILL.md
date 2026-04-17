---
description: Diagnose Compass setup problems. Checks plugin version, case file integrity, prefs-block validity, connector status, storage writability, and flags anything misconfigured. Use when the user says something isn't working, asks why a connector isn't firing, or wants a health check.
---

# /compass:troubleshoot — Health Check & Diagnostics

Invoked as: `/compass:troubleshoot` (Claude Code / Desktop) or `@troubleshoot` (Codex)

This skill runs a read-only health check of the current Compass installation and case folder, then prints a single table of results plus copyable fixes. It never auto-repairs anything that writes to user-owned files.

---

## Pre-Step: Detect Host Environment

Identify the host exactly as in `skills/onboarding/SKILL.md`:

```
CLAUDECODE env var present and = "1"  → host = "claude-code-cli"
CLAUDE_DESKTOP env var present        → host = "claude-desktop"
CODEX env var present                 → host = "codex"
Otherwise                             → host = "unknown"
```

Store `host` — it determines which fix strings are shown (Gmail reconnect path, update command, fresh-chat wording).

---

## Checks

Run each check in order. Record status (`OK` / `WARN` / `CRITICAL` / `INFO` / `SKIPPED`) and a short detail string. Do not stop early — run them all, then present the full table. If a check depends on an earlier check that failed, record `SKIPPED — depends on Check N` rather than re-erroring.

### Check 1: Plugin version

Read `.claude-plugin/plugin.json` from the plugin install directory.

- Claude Code: inside the plugin's own directory (the dir containing this SKILL.md's parent's parent).
- Codex: `~/.codex/plugins/compass/.claude-plugin/plugin.json`.

Report: `OK — version <X.Y.Z>, installed at <path>`. If file missing → `WARN — plugin.json not found at expected path`.

### Check 2: Working directory

Confirm `patient/PROFILE.md` exists in the current working directory.

- Present → `OK`.
- Missing → `CRITICAL — Not in a case folder. Run /compass:onboarding or cd to the case folder.`

### Check 3: PROFILE integrity

Depends on Check 2 — if Check 2 is CRITICAL, record `SKIPPED` here and move on.

Read `patient/PROFILE.md`. Required keys: `patient_name` (as "Full name"), `diagnosis_summary` (as "Primary diagnosis"), `current_phase` (a checked phase box), `country` (as "Country of residence").

- All present and non-placeholder (no `{{…}}` remaining) → `OK`.
- Any missing or still-templated → `WARN — missing/placeholder: [list]`.

### Check 4: Onboarding state

Read `config/onboarding-state.md` if present.

- No file, or `completed_steps: [1,2,3,4,5,6,7,8,9,10]` → `OK`.
- `in_progress_step: N` with `completed_steps` not full → `WARN — Onboarding incomplete (paused at step N). Run /compass:onboarding to resume.`

### Check 5: Prefs block

Open the host-level memory file:

- `claude-code-cli` or `claude-desktop` → `~/.claude/CLAUDE.md`
- `codex` → `~/.codex/AGENTS.md`

Locate `<!-- compass:prefs -->` and `<!-- /compass:prefs -->`. Validate:

- Both markers present.
- Opening marker appears before closing marker.
- Each marker appears exactly once.
- No markers nested inside another compass block.

- All good → `OK`.
- Missing one or both markers, wrong order, or duplicated → `CRITICAL — Prefs block malformed. Suggested repaired block:` followed by a copyable example block built from whatever key/value lines can be salvaged between delimiters (or a fresh block from onboarding defaults if nothing salvageable).

### Check 6: Connectors

Read `config/connectors.md`. For each connector listed as `enabled: true` (or equivalent), run `ToolSearch` with its family keyword:

| Connector | Query |
|---|---|
| Gmail | `gmail` |
| Outlook | `outlook` |
| Google Calendar | `calendar` |
| Fireflies | `fireflies` |
| Otter | `otter` |
| Apple Notes | `notes` |

For each:
- Listed enabled, tool found → `OK — <name> connected`.
- Listed enabled, no tool found → `WARN — <name> listed as enabled but no tool available. Reconnect via:` with host-specific path (see Host-specific fixes below).
- Listed disabled or absent → no row (don't clutter the table).

If `config/connectors.md` is missing entirely → `WARN — connectors.md missing. Run /compass:onboarding to regenerate.`

### Check 7: Storage writability

Attempt `Write` of a trivial file at `config/.compass-write-check` containing a timestamp, then overwrite it with an empty string (no deletion — Compass never deletes files).

- Write succeeds → `OK`.
- Write fails → `CRITICAL — Can't write to this folder. Check cloud-sync pause, disk space, or folder permissions.`

### Check 8: Update check

Run the shared update-check logic defined in `CLAUDE.md` under "Update check". Force a fresh check here (do not honor the 24h cache) so the troubleshoot output reflects current state.

- Up to date → `OK — Compass <X.Y.Z> (latest)`.
- Stale → `WARN — Newer version available: <local> → <latest>. To update: <host-specific command>`.
- WebFetch failed → `INFO — Update check skipped (no network)`. Never CRITICAL.

### Check 9: Context-size hint

Best-effort heuristic based on this-session tool-call volume (rough threshold: more than ~30 tool calls or multiple skills run before troubleshoot). If the signal is present, add `INFO — Session looks long; consider starting a fresh chat after this check.` with the host-appropriate fresh-chat wording from the fixes table. If the signal is absent or ambiguous, omit the row (don't force it).

---

## Host-specific fixes

When a check suggests a fix, tailor the wording:

| Fix | claude-code-cli | claude-desktop | codex |
|---|---|---|---|
| Gmail reconnect | Edit `.mcp.json` in project root and re-run `claude mcp add`. | Settings → Connectors → Gmail. | Edit `~/.codex/config.toml` Gmail server entry. |
| Calendar reconnect | Edit `.mcp.json`. | Settings → Connectors → Google Calendar. | Edit `~/.codex/config.toml`. |
| Update command | `/plugin marketplace update compass` then reinstall. | `/plugin marketplace update compass` then reinstall. | `cd ~/.codex/plugins/compass && git pull && bash scripts/build-codex.sh` |
| Fresh chat | Type `/clear`. | Click "New chat" or type `/clear`. | Start a new session. |

If host is `unknown`, show both Claude Code and Codex fix lines.

---

## Output format

Print one table, then a numbered "Suggested fixes" list, then a one-line summary. Example:

```
## Compass Health Check

| # | Check | Status | Detail |
|---|---|---|---|
| 1 | Plugin version | OK | 0.1.0 at ~/.claude/plugins/compass |
| 2 | Working directory | OK | patient/PROFILE.md found |
| 3 | PROFILE integrity | WARN | missing: country |
| 4 | Onboarding state | OK | all steps complete |
| 5 | Prefs block | OK | markers valid |
| 6 | Connectors | WARN | Gmail listed enabled but no tool available |
| 7 | Storage writability | OK | wrote config/.compass-write-check |
| 8 | Update check | OK | 0.1.0 (latest) |

### Suggested fixes
1. Fill in "Country of residence" in patient/PROFILE.md — used for regulatory-jurisdiction resolution.
2. Reconnect Gmail: <host-specific command>.

Summary: 2 warnings, 0 critical. Compass is usable but email-dependent steps will be skipped.
```

---

## Behavioral Rules

1. **Read-only by default.** Only Check 7 writes, and it only writes a throwaway marker file then overwrites it with empty content. Never delete user files.
2. **Never block.** If any check fails to run (file unreadable, WebFetch errors), record the failure as its own row with `INFO` status and continue.
3. **No prompts mid-check.** The user ran troubleshoot to get a report, not to answer questions. Collect everything, then present.
4. **Graceful degradation matches CLAUDE.md.** Missing connectors don't cascade into CRITICALs — only outright broken state does.
5. **Host-agnostic summary line.** End with one sentence the user can read at a glance: "All clear", or "N warnings, M critical — see fixes above".
