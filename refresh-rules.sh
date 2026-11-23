#!/usr/bin/env bash
# Keeps ~/.claude/CLAUDE.md equal to the one rules source:
# CLAUDE.md in the public repo yoelt1/claude-rules (branch main).
# Runs as a SessionStart hook (RULES_URL overrides the source, for tests only). It downloads a text file and compares it;
# it never runs downloaded code, and it never blocks or fails a session.
URL="${RULES_URL:-https://raw.githubusercontent.com/yoelt1/claude-rules/main/CLAUDE.md}"
DEST="$HOME/.claude/CLAUDE.md"
LOG="$HOME/.claude/rules-refresh.log"
log() { echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) remote=${CLAUDE_CODE_REMOTE:-false} $1" >> "$LOG" 2>/dev/null; }

mkdir -p "$HOME/.claude"
T=$(mktemp "${TMPDIR:-/tmp}/rules.XXXXXX") || { log "no temp file"; exit 0; }
trap 'rm -f "$T"' EXIT

if ! curl -fsSL --max-time 10 "$URL" -o "$T" 2>/dev/null; then
  log "download failed, kept current rules"; exit 0
fi
# Guard against an error page or an empty file replacing the rules.
if ! head -1 "$T" | grep -q '^# How I work with Claude'; then
  log "downloaded file looks wrong, kept current rules"; exit 0
fi
if cmp -s "$T" "$DEST"; then
  log "unchanged"; exit 0
fi

if [ -f "$DEST" ]; then
  mkdir -p "$HOME/.claude/backups/rules"
  cp -p "$DEST" "$HOME/.claude/backups/rules/CLAUDE.md.$(date +%Y%m%d-%H%M%S)"
fi
cp "$T" "$DEST"
log "updated"
# SessionStart hook output is added to the session's context.
echo "Your global rules were just updated from yoelt1/claude-rules. The newest rules follow; they replace any older copy loaded earlier in this session."
echo
cat "$DEST"
exit 0
