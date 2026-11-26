#!/usr/bin/env bash
# Cloud session start (job 13c). Installed by cloud-setup.sh as a SessionStart hook
# (startup and resume). In the session's repo it:
#   1. pulls from GitHub (fast-forward only, 20-second limit), and
#   2. prints a short summary of INBOX.md and OWNER-TODO.md, if the repo has them.
# The output goes into Claude's context. It never blocks or fails a session: every step
# is optional and the script always exits 0. One line per run goes to ~/.claude/session-start.log.
LOG="$HOME/.claude/session-start.log"
DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$DIR" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

export GIT_TERMINAL_PROMPT=0
T=""; command -v timeout >/dev/null 2>&1 && T="timeout 20"
BR=$(git branch --show-current 2>/dev/null)
if ! UP=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
  PULL="pull skipped: branch ${BR:-(none)} has no upstream; at $(git rev-parse --short HEAD 2>/dev/null)"
elif $T git pull --ff-only -q >/dev/null 2>&1; then
  PULL="pulled $UP, now at $(git rev-parse --short HEAD)"
else
  PULL="pull failed (offline, timed out or not a fast-forward); kept $(git rev-parse --short HEAD)"
fi
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) remote=${CLAUDE_CODE_REMOTE:-false} dir=$DIR $PULL" 2>/dev/null >> "$LOG"

echo "Session start: $PULL."
# Summary: the first two cells of each table row (number or date, then what), at most 5 per file.
for f in INBOX.md OWNER-TODO.md; do
  [ -f "$f" ] || continue
  python3 - "$f" <<'PY' 2>/dev/null || echo "$f: present (summary failed; read it directly)."
import re, sys
f = sys.argv[1]
rows = [l.strip() for l in open(f, encoding="utf-8") if l.strip().startswith("|")]
rows = [r for r in rows if not re.fullmatch(r"[|:\-\s]+", r)][1:]  # drop separator and header
items = []
for r in rows:
    cells = [c.strip() for c in r.strip("|").split("|")]
    text = ": ".join(c for c in cells[:2] if c)
    if text:
        items.append(text if len(text) <= 100 else text[:99] + "…")
if not items:
    print(f"{f}: empty.")
else:
    print(f"{f}: {len(items)} open:")
    for t in items[:5]:
        print(f"- {t}")
    if len(items) > 5:
        print(f"- …and {len(items) - 5} more (read {f})")
PY
done
exit 0
