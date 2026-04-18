# Changelog

All notable changes to Compass are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Versioning rules and the per-commit bump policy live in `CLAUDE.md` → Commit Protocol. Formal tagged releases are cut via `/compass:release`. The 1.0.0 cut will signal the first stable release.

## [Unreleased]

### Changed
- Claude Code reads the plugin version from the plugin entry in `.claude-plugin/marketplace.json` instead of `.claude-plugin/plugin.json`, following the docs recommendation for relative-path plugins. `bump-version.sh`, `/compass:release`, `/compass:troubleshoot`, and the 24-hour update-check in `CLAUDE.md` are updated to match. Codex continues to read `version` from `.codex-plugin/plugin.json`.

## [0.1.0] - 2026-04-18

Initial open-source release of Compass — a Claude Code and Codex plugin for families coordinating complex medical cases.

### Added
- Initial M1 build: generic, open-source medical coordination plugin.
- Nine skills: `onboarding`, `update`, `research`, `prep`, `todo`, `email`, `briefing`, `contacts`, `troubleshoot`.
- Six agents: case-analyst, planner, researcher, writer, evaluator, email-drafter.
- `/compass:troubleshoot` health check with silent 24h update-check against the GitHub repo.
- Activation-first onboarding recap.
- Claude Desktop install guide with screenshots.
- Onboarding UX fixes from first testing pass: path-probing, scope verification, in-app schedulers.
- Parallel Codex build via `scripts/build-codex.sh`.
