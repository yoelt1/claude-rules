---
name: check
description: Run the independent checker agent on a project and show its full report. Use when the user types /check, asks to "run the checker", or before saying major work is done.
---

# Run the independent checker

1. Find the project folder: the one holding BRIEF.md, at or above the file the user named (or the current folder if they named none).
2. Start the checker agent with only the project folder's absolute path and the output paths under `## Outputs` in BRIEF.md. Send no summary, reasoning or opinion about the work.
3. Show the user the checker's full report word for word, from the `PROJECT:` line to the `VERDICT:` line. Don't shorten or reword it.
4. Below the report, list the MAJOR findings, then the MINOR ones, as a numbered list. Use the checker's own counts and wording, and keep them the same if you mention them again later.
5. Fix the findings yourself, then run the checker again and show its new report the same way. Log each fix in DECISIONS.md. Two exceptions, which you list and ask the user about instead: a fix that involves money, sending, publishing, deleting, installing outside tools, legal or health matters, or a design or taste choice the user owns; and a finding that the brief or its sources can't settle. After 3 checker runs that don't pass, stop and show the user the findings.
6. If BRIEF.md is missing or not approved, don't run the checker. Say so in one line and run /brief yourself.
