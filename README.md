# claude-rules

My global rules for Claude Code, in one public file. No secrets live here.

- `CLAUDE.md`: the rules. This is the one source. Change them here, by pull request.
- `refresh-rules.sh`: a session-start hook. It downloads `CLAUDE.md`, and if it differs
  from `~/.claude/CLAUDE.md`, backs up the old copy to `~/.claude/backups/rules/` and
  installs the new one. It only downloads text; it never runs downloaded code.
- `cloud-setup.sh`: run by my "My setup" cloud environment (rules, hook, 4 plugins:
  superpowers, code-review-anthropics, firecrawl, claude-code-setup, and the i-have-adhd
  plugin pinned to commit f3e783b with its always-on flag; the tools below; session-start.sh).
- `tools/`: copies of my laptop's /brief, /check and /handoff skills and checker agent, so
  cloud sessions have them in every repo. The laptop files are the ones edited; my private
  workspace repo's weekly prune runs a check that flags any difference, and the copy here is
  then updated by pull request.
- `session-start.sh`: a cloud session-start hook. It pulls the repo (fast-forward only) and
  prints a short summary of `INBOX.md` and `OWNER-TODO.md` if the repo has them. It never
  blocks or fails a session.
- Reply style: the i-have-adhd plugin (ayghri/i-have-adhd, MIT) adds its rules at every
  session start; `LICENSE-i-have-adhd` is its licence. Until 25 Nov 2026 the rules text was
  copied into `CLAUDE.md` (commit 1ecea19). Updating the plugin needs a new SkillSpector scan
  and my yes.

## Where the rules reach

- Laptop: `~/.claude/settings.json` runs `refresh-rules.sh` at every session start.
- Cloud ("My setup" environment): its setup script is pasted once and never changes:

```bash
#!/bin/bash
# Global rules: https://github.com/yoelt1/claude-rules (public). Paste once; don't edit.
curl -fsSL --max-time 30 https://raw.githubusercontent.com/yoelt1/claude-rules/main/cloud-setup.sh -o /tmp/cloud-setup.sh && bash /tmp/cloud-setup.sh
exit 0
```

GitHub's raw file server can serve a copy up to about 5 minutes old after a merge
(its `cache-control: max-age=300` header, seen 2026-11-23; the test rule took ~220 s to show).
The cloud reuses its setup for up to about 7 days (code.claude.com/docs/en/cloud-environments).
Checked 24 Nov: the cloud runs this hook at session start (log `remote=true src=hook`), even though
Anthropic's docs say it doesn't run hooks from personal settings. If a cloud log ever shows only
`src=setup` lines, new rules wait for the setup rebuild (up to ~7 days).
