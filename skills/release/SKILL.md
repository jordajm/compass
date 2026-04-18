---
description: Cut a formal Compass release — bump version, update CHANGELOG, commit, and tag. Use when the user says "cut a release", "tag a version", "release X.Y.Z", or wants to ship 1.0.0. For routine commits, the bump happens automatically per CLAUDE.md → Commit Protocol; this skill is only for formal, tagged releases.
---

# /compass:release — Cut a Tagged Release

Invoked as: `/compass:release` (Claude Code / Desktop) or `@release` (Codex).

Produces a single release commit that bumps the plugin version, updates `CHANGELOG.md`, and creates an annotated git tag. Never pushes — prints the push command for the user to run manually.

---

## When to use this skill

- **Use it** when the user wants to cut a tagged, user-visible release — especially when moving to `1.0.0` or rolling up multiple pre-release commits into a formal version.
- **Do not use it** for everyday commits. The rule in `CLAUDE.md` → Commit Protocol already bumps the version on every shipped-surface commit; most changes do not need this skill.

---

## Pre-flight checks

Run these in order. Abort with a clear error if any fails.

1. **Working tree clean.** `git status --porcelain` must return empty. If dirty, tell the user to commit or stash first.
2. **Sync check.** The plugin-entry `version` in `.claude-plugin/marketplace.json` and the `version` in `.codex-plugin/plugin.json` must match. If `scripts/bump-version.sh --dry-run patch` exits non-zero, surface the error and stop.
3. **On main (or release branch).** Warn, not fail, if on a feature branch.

(The tag-collision check runs later — see the end of Step 2, once the candidate version is known.)

---

## Step 1 — Summarize the delta

- Read current version from the plugin entry in `.claude-plugin/marketplace.json`.
- Collect commit subjects since the last release tag:
  - If any tag matches `v*`: `git log "$(git describe --tags --abbrev=0 --match 'v*')..HEAD" --format='%s'`
  - Otherwise: `git log --format='%s' --reverse` (the whole history)
- Print to the user: current version + bulleted list of commit subjects.

---

## Step 2 — Pick a bump level

Suggest a default based on *path-level* changes in the delta, not commit-subject keywords (subjects are unreliable: `Add CHANGELOG.md` shouldn't trigger a minor bump).

Collect the set of changed files:
```
git diff --name-only "$PREV_TAG..HEAD"   # or: git diff --name-only $(git rev-list --max-parents=0 HEAD)..HEAD
```

Apply, in order:

- **major** — only if any commit subject contains `BREAKING` or `breaking change`. Never auto-suggest major otherwise; it always requires user intent.
- **minor** — if the diff shows a new directory under `skills/` or a new file under `agents/` (use `git diff --name-status` and look for `A` entries whose path starts with `skills/<name>/` where `<name>` wasn't previously tracked, or `agents/*.md`).
- **patch** — otherwise.

Always present the suggestion *with its reasoning* (e.g., "Suggested: minor — new skill `skills/share/` detected") and let the user confirm or override (`patch` / `minor` / `major`). The heuristic can misfire on refactors that happen to add a supporting file; trust the user's override.

For the 1.0.0 cut specifically: confirm explicitly that the user wants to leave the 0.x series, then use `major`.

**Tag-collision check (runs here, not in pre-flight, because the candidate version is only known now):** compute `v<new>` from the current version + chosen level (or run `bash scripts/bump-version.sh --dry-run <level>` and parse its output). Then run `git rev-parse --verify --quiet "v<new>"` — if it returns 0, the tag already exists. Abort and ask the user whether to pick a higher bump level or delete the stale tag manually. Never land a release commit that cannot be tagged.

---

## Step 3 — Collect a release summary

Ask the user for a 1–3 line summary describing the release. This becomes:
- The subject line of the CHANGELOG entry (first line).
- The annotated tag message.

If the user declines, synthesize one from the commit subjects.

---

## Step 4 — Bump, changelog, commit, tag

Execute in this order. Stop on any failure; do not attempt partial rollback — surface the error and let the user clean up.

1. **Bump:** `bash scripts/bump-version.sh <level>` — record the new version string from the output.
2. **Update CHANGELOG.md:**
   - If an `## [Unreleased]` section exists, rename its heading to `## [<new>] - <YYYY-MM-DD>` (today's date) and insert a fresh empty `## [Unreleased]` block immediately above it. Any content already under `[Unreleased]` stays under what is now the `[<new>]` heading.
   - If no `[Unreleased]` section, insert a new `## [<new>] - <YYYY-MM-DD>` block directly under the intro paragraph, above whatever the most recent version heading is.
   - Under the new heading (after the user's summary as a plain paragraph), add an `### Added` / `### Changed` / `### Fixed` breakdown derived from the commit subjects (map "Add …" → Added, "Fix …" → Fixed, "Update …"/"Refactor …" → Changed; anything else → Changed). Do this in addition to any content promoted from `[Unreleased]`.

**Worked example — empty `[Unreleased]`, releasing 0.2.0:**

Before:
```
## [Unreleased]

## [0.1.0] - 2026-04-18
<content>
```

After (with user summary "Adds release tooling"):
```
## [Unreleased]

## [0.2.0] - 2026-09-15
Adds release tooling.

### Added
- ...

## [0.1.0] - 2026-04-18
<content>
```
3. **Stage:** `git add .claude-plugin/marketplace.json .codex-plugin/plugin.json CHANGELOG.md`
4. **Commit:** message `Release v<new>` with the user's summary as the body. Include the Co-Authored-By trailer per the global commit convention.
5. **Tag:** `git tag -a v<new> -m "<user summary>"`

**Exception to the commit protocol:** this release commit does not itself trigger another version bump — it *is* the bump.

---

## Step 5 — Print the push command

Print, but do not execute:

```
Release v<new> committed and tagged locally. To publish:

  git push origin main --tags

Or if you're on a feature branch:

  git push origin <branch> --tags
```

Honors the project rule: never push without explicit user action.

---

## Failure handling

- **Sync mismatch before bump:** abort with a clear message; tell the user which file to inspect.
- **bump-version.sh fails:** surface stderr verbatim; do not proceed to CHANGELOG or commit.
- **CHANGELOG write fails:** revert the bump with `git checkout -- .claude-plugin/marketplace.json .codex-plugin/plugin.json` and report.
- **Commit fails (pre-commit hook or otherwise):** do not create the tag. Surface the error and let the user resolve. Never retry with `--no-verify`.
- **Tag already exists:** warn (`v<new> already exists`) and offer to move it (`git tag -f`) only with explicit user confirmation.

---

## Example transcript

```
Current version: 0.3.2
Commits since v0.3.2 (3):
  - Add /compass:share skill for exporting reports
  - Fix CHANGELOG promotion bug in /compass:release
  - Refactor agent dispatch for readability

Suggested bump: minor (new skill added)
Bump level? [minor] >

Release summary (1-3 lines) >
  Adds /compass:share for exporting reports. Small fixes to release and dispatch.

Bumping… bumped: 0.3.2 -> 0.4.0
Updating CHANGELOG.md… done.
Committing… [main abc1234] Release v0.4.0
Tagging… v0.4.0 created.

Release v0.4.0 committed and tagged locally. To publish:
  git push origin main --tags
```

---

## Host notes

- **Codex:** the shell calls in this skill work identically. Invoke as `@release`.
- **Claude Code CLI / Desktop:** `/compass:release`. On Desktop, the user will still see the shell output in the tool-call UI.
