#!/usr/bin/env bash
# bump-version.sh
#
# Atomically bumps the plugin version across both plugin.json files.
# The Claude Code client uses the `version` field in .claude-plugin/plugin.json
# to detect updates — without a bump, cached users never see new code.
#
# Usage:
#   bash scripts/bump-version.sh patch    # 0.1.0 -> 0.1.1
#   bash scripts/bump-version.sh minor    # 0.1.0 -> 0.2.0
#   bash scripts/bump-version.sh major    # 0.1.0 -> 1.0.0
#   bash scripts/bump-version.sh --dry-run patch   # print, do not write
#
# Behavior:
#   - Reads current version from .claude-plugin/plugin.json (source of truth).
#   - Requires both plugin.json files to share the same X.Y.Z version.
#   - Two-phase write: stage both tmpfiles and validate, then rename both.
#     If staging fails for either file, nothing is renamed.
#   - Replacement is string-anchored (no regex surprises from dots).
#   - Prints: "bumped: <old> -> <new>"
#
# Requirements: bash, awk — no external dependencies.

set -euo pipefail

# ── Constants ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLAUDE_JSON="$PLUGIN_ROOT/.claude-plugin/plugin.json"
CODEX_JSON="$PLUGIN_ROOT/.codex-plugin/plugin.json"
DRY_RUN=false

# ── Help (derived from header comment — no line-number magic) ────────────────
print_help() {
  awk '
    NR == 1 { next }
    /^set -euo pipefail/ { exit }
    /^#/ { sub(/^# ?/, ""); print }
  ' "${BASH_SOURCE[0]}"
}

# ── Parse args ───────────────────────────────────────────────────────────────
LEVEL=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    patch|minor|major) LEVEL="$arg" ;;
    -h|--help) print_help; exit 0 ;;
    *)
      echo "Error: unknown argument '$arg'" >&2
      echo "Usage: bash scripts/bump-version.sh [--dry-run] <patch|minor|major>" >&2
      exit 2
      ;;
  esac
done

if [[ -z "$LEVEL" ]]; then
  echo "Error: bump level required (patch|minor|major)" >&2
  echo "Usage: bash scripts/bump-version.sh [--dry-run] <patch|minor|major>" >&2
  exit 2
fi

# ── Read and validate current versions ───────────────────────────────────────
extract_version() {
  # Extracts the first "version": "X.Y.Z" value from a JSON file.
  awk -F'"' '/"version"[[:space:]]*:/ {print $4; exit}' "$1"
}

for f in "$CLAUDE_JSON" "$CODEX_JSON"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: $f not found" >&2
    exit 1
  fi
done

CURRENT="$(extract_version "$CLAUDE_JSON")"
CODEX_CURRENT="$(extract_version "$CODEX_JSON")"

if [[ -z "$CURRENT" ]]; then
  echo "Error: could not find \"version\" field in $CLAUDE_JSON" >&2
  exit 1
fi
if [[ -z "$CODEX_CURRENT" ]]; then
  echo "Error: could not find \"version\" field in $CODEX_JSON" >&2
  exit 1
fi

if [[ "$CURRENT" != "$CODEX_CURRENT" ]]; then
  echo "Error: plugin.json versions out of sync (claude=$CURRENT, codex=$CODEX_CURRENT)" >&2
  echo "Resolve manually before bumping." >&2
  exit 1
fi

if ! [[ "$CURRENT" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: current version '$CURRENT' is not in X.Y.Z form" >&2
  exit 1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$LEVEL" in
  patch) PATCH=$((PATCH + 1)) ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
esac

NEW="${MAJOR}.${MINOR}.${PATCH}"

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[dry-run] would bump: $CURRENT -> $NEW"
  echo "[dry-run] would update: $CLAUDE_JSON"
  echo "[dry-run] would update: $CODEX_JSON"
  exit 0
fi

# ── Two-phase write ──────────────────────────────────────────────────────────
# Phase 1: stage both tmpfiles and validate each contains the new version.
# Phase 2: rename both (same filesystem = effectively atomic per-file).
#
# Replacement uses awk's index()/substr() so dots in the old version are not
# interpreted as regex metacharacters. `done` is explicitly initialised via
# `-v done=0` so we never rely on awk's implicit-empty default.

stage_tmpfile() {
  # Args: source-file old-version new-version
  # Writes a tmpfile next to the source, validates, echoes the tmpfile path.
  # Exits non-zero on failure; caller is responsible for cleanup on failure.
  local file="$1" old="$2" new="$3"
  local tmp
  tmp="$(mktemp "${file}.tmp.XXXXXX")"
  awk -v old="$old" -v new="$new" -v done=0 '
    !done && /"version"[[:space:]]*:/ {
      needle = "\"" old "\""
      replacement = "\"" new "\""
      pos = index($0, needle)
      if (pos > 0) {
        $0 = substr($0, 1, pos - 1) replacement substr($0, pos + length(needle))
        done = 1
      }
    }
    { print }
  ' "$file" > "$tmp"
  if ! grep -q "\"$new\"" "$tmp"; then
    rm -f "$tmp"
    echo "Error: rewrite of $file failed (new version not found in output)" >&2
    return 1
  fi
  echo "$tmp"
}

CLAUDE_TMP=""
CODEX_TMP=""
cleanup_tmpfiles() {
  [[ -n "$CLAUDE_TMP" && -f "$CLAUDE_TMP" ]] && rm -f "$CLAUDE_TMP"
  [[ -n "$CODEX_TMP" && -f "$CODEX_TMP" ]] && rm -f "$CODEX_TMP"
}
trap cleanup_tmpfiles ERR

CLAUDE_TMP="$(stage_tmpfile "$CLAUDE_JSON" "$CURRENT" "$NEW")"
CODEX_TMP="$(stage_tmpfile "$CODEX_JSON" "$CURRENT" "$NEW")"

# Both stages succeeded — commit.
mv "$CLAUDE_TMP" "$CLAUDE_JSON"
mv "$CODEX_TMP" "$CODEX_JSON"
trap - ERR

echo "bumped: $CURRENT -> $NEW"
echo "  $CLAUDE_JSON"
echo "  $CODEX_JSON"
