#!/usr/bin/env bash
# Run by the "My setup" cloud environment. Its pasted setup script only downloads
# and runs this file, so changes made here need no new paste.
# 1. Installs the global rules (~/.claude/CLAUDE.md).
# 2. Installs refresh-rules.sh as a SessionStart hook in ~/.claude/settings.json.
#    The cloud keeps a snapshot of this setup for up to ~7 days; the hook fetches newer
#    rules each session (seen working 24 Nov: log line src=hook in ~/.claude/rules-refresh.log).
# 3. Installs the 4 plugins the owner kept at the 22 Nov /doctor check, then
#    (step 4) the i-have-adhd plugin, pinned, with its always-on flag (job 20). The old My setup
#    script had this loop; without it, sessions started by other sessions got no
#    plugins (tested 2026-11-23; workspace DECISIONS.md, job 14).
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

# 4. i-have-adhd reply rules, always on (owner's yes, job 20, 25 Nov), pinned to the commit
#    installed on the laptop 25 Nov (same files as the SkillSpector-scanned 1ecea19 plus a
#    Devin manifest). A newer version needs a new scan and the owner's yes.
IHA_SHA=f3e783bae5f4820416492091b3abeb670616c23a
IHA="$HOME/.claude/i-have-adhd-pinned"
[ -d "$IHA/.git" ] || git clone -q https://github.com/ayghri/i-have-adhd.git "$IHA" 2>/dev/null
if git -C "$IHA" checkout -q "$IHA_SHA" 2>/dev/null; then
  claude plugin marketplace add "$IHA" >/dev/null 2>&1 || true
  claude plugin install i-have-adhd@i-have-adhd >/dev/null 2>&1 || true
  touch "$HOME/.claude/.i-have-adhd-always"
fi
exit 0
