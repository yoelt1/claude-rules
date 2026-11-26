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
# 5. Installs /brief, /check, /handoff and the checker agent from tools/ (job 13b).
# 6. Installs session-start.sh as a second SessionStart hook: pull, then a short
#    INBOX.md / OWNER-TODO.md summary (job 13c).
# CLOUD_SETUP_BASE and RULES_URL override the download source, for tests only.
BASE="${CLOUD_SETUP_BASE:-https://raw.githubusercontent.com/yoelt1/claude-rules/main}"
mkdir -p ~/.claude/hooks

curl -fsSL --max-time 20 "$BASE/refresh-rules.sh" -o ~/.claude/hooks/refresh-rules.sh \
  && chmod +x ~/.claude/hooks/refresh-rules.sh \
  && RULES_REFRESH_SRC=setup bash ~/.claude/hooks/refresh-rules.sh >/dev/null

# 5. Skills and agent: copies of the laptop's ~/.claude files (the workspace repo's
#    setup/check-cloud-tools.sh flags when they differ). A file that fails to download,
#    or doesn't start with "---", is skipped and any older copy is kept.
for f in skills/brief/SKILL.md skills/check/SKILL.md skills/handoff/SKILL.md agents/checker.md; do
  mkdir -p "$HOME/.claude/$(dirname "$f")"
  t=$(mktemp "${TMPDIR:-/tmp}/tool.XXXXXX") || continue
  if curl -fsSL --max-time 20 "$BASE/tools/$f" -o "$t" && [ "$(head -1 "$t")" = "---" ]; then
    chmod 644 "$t" && mv "$t" "$HOME/.claude/$f"
  fi
  rm -f "$t"
done

# 6. Session-start pull and summary hook (added to settings below if it downloaded).
curl -fsSL --max-time 20 "$BASE/session-start.sh" -o ~/.claude/hooks/session-start.sh \
  && chmod +x ~/.claude/hooks/session-start.sh

# Add the SessionStart hooks, keeping any other settings already in the file.
python3 - <<'PY' || true
import json, os
p = os.path.expanduser("~/.claude/settings.json")
try:
    s = json.load(open(p))
except Exception:
    s = {}
hooks = s.setdefault("hooks", {}).setdefault("SessionStart", [])
for name, matcher, timeout in [("refresh-rules.sh", None, 20), ("session-start.sh", "startup|resume", 30)]:
    if not os.path.exists(os.path.expanduser("~/.claude/hooks/" + name)):
        continue
    cmd = '"$HOME/.claude/hooks/%s"' % name
    if not any(h.get("command") == cmd for e in hooks for h in e.get("hooks", [])):
        entry = {"hooks": [{"type": "command", "command": cmd, "timeout": timeout}]}
        if matcher:
            entry["matcher"] = matcher
        hooks.append(entry)
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
