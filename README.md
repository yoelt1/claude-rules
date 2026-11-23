# claude-rules

My global rules for Claude Code, in one public file. No secrets live here.

- `CLAUDE.md`: the rules. This is the one source. Change them here, by pull request.
- `refresh-rules.sh`: a session-start hook. It downloads `CLAUDE.md`, and if it differs
  from `~/.claude/CLAUDE.md`, backs up the old copy to `~/.claude/backups/rules/` and
  installs the new one. It only downloads text; it never runs downloaded code.
- `cloud-setup.sh`: run by my "My setup" cloud environment (rules, hook, plugins).
- `LICENSE-i-have-adhd`: the MIT licence of the reply-style rules copied into `CLAUDE.md`
  (ayghri/i-have-adhd, commit 1ecea19).

## Where the rules reach

- Laptop: `~/.claude/settings.json` runs `refresh-rules.sh` at every session start.
- Cloud ("My setup" environment): its setup script is pasted once and never changes:

```bash
#!/bin/bash
# Global rules: https://github.com/yoelt1/claude-rules (public). Paste once; don't edit.
curl -fsSL --max-time 30 https://raw.githubusercontent.com/yoelt1/claude-rules/main/cloud-setup.sh -o /tmp/cloud-setup.sh && bash /tmp/cloud-setup.sh
exit 0
```

GitHub's raw file server can serve a copy up to about 5 minutes old after a merge.
The cloud reuses its setup for up to about 7 days (code.claude.com/docs/en/cloud-environments).
[ASSUMED until tested: whether the cloud runs the hook, so new rules arrive every session.]
