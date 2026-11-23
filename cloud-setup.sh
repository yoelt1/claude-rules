#!/usr/bin/env bash
# Run by the "My setup" cloud environment. Its pasted setup script only downloads
# and runs this file, so changes made here need no new paste.
# 1. Installs the global rules (~/.claude/CLAUDE.md).
# 2. Installs refresh-rules.sh as a SessionStart hook in ~/.claude/settings.json.
#    The cloud keeps a snapshot of this setup for up to ~7 days; the hook is meant to
#    fetch newer rules in every session. Whether the cloud runs user-level hooks is
#    being tested (job 14); see README.md for the result.
# 3. Installs plugins (originals, checked 2026-11-22).
BASE="https://raw.githubusercontent.com/yoelt1/claude-rules/main"
mkdir -p ~/.claude/hooks

curl -fsSL --max-time 20 "$BASE/refresh-rules.sh" -o ~/.claude/hooks/refresh-rules.sh \
  && chmod +x ~/.claude/hooks/refresh-rules.sh \
  && bash ~/.claude/hooks/refresh-rules.sh >/dev/null

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

# Plugins: Anthropic's code review; Superpowers by Jesse Vincent (obra).
claude plugin install code-review-anthropics@anthropic-plugin-directory >/dev/null 2>&1 || true
claude plugin install superpowers@anthropic-plugin-directory >/dev/null 2>&1 || true
exit 0
