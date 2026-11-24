#!/usr/bin/env bash
# Run by the "My setup" cloud environment. Its pasted setup script only downloads
# and runs this file, so changes made here need no new paste.
# 1. Installs the global rules (~/.claude/CLAUDE.md).
# 2. Installs refresh-rules.sh as a SessionStart hook in ~/.claude/settings.json.
#    The cloud keeps a snapshot of this setup for up to ~7 days; the hook is meant to
#    fetch newer rules in every session. Whether the cloud runs user-level hooks is
#    tested by ~/.claude/rules-refresh.log: a line with src=hook means it does.
# 3. Installs plugins (originals, checked 2026-11-22). The loop keeps all 4 that the
#    old My setup script installed; without it, sessions started by other sessions
#    got no plugins (tested 2026-11-23, workspace INBOX.md).
BASE="https://raw.githubusercontent.com/yoelt1/claude-rules/main"
mkdir -p ~/.claude/hooks

curl -fsSL --max-time 20 "$BASE/refresh-rules.sh" -o ~/.claude/hooks/refresh-rules.sh \
  && chmod +x ~/.claude/hooks/refresh-rules.sh \
  && RULES_REFRESH_SRC=setup bash ~/.claude/hooks/refresh-rules.sh >/dev/null

# Add the SessionStart hook, keeping any other settings already in the file.
python3 - <<'PY' || true
import json, os
p = os.path.expanduser("~/.claude/settings.json")
try:
    s = json.load(open(p))
except Exception:
    s = {}
cmd = '"$HOME/.claude/hooks/refresh-rules.sh"'
hooks = s.setdefault("hooks", {}).setdefault("SessionStart", [])
if not any(h.get("command") == cmd for e in hooks for h in e.get("hooks", [])):
    hooks.append({"hooks": [{"type": "command", "command": cmd, "timeout": 20}]})
json.dump(s, open(p, "w"), indent=2)
PY

for p in superpowers code-review-anthropics firecrawl claude-code-setup; do
  claude plugin install "$p@anthropic-plugin-directory" >/dev/null 2>&1 || true
done
exit 0
