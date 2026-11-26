---
name: brief
description: Start major work (multi-step work that produces a file, plan, design, document or code change) by writing BRIEF.md and getting it approved before doing the work. Use when the user starts a major task or project, or types /brief.
---

# Brief before work

Write a first draft alongside the brief so the user always gets something to react to. Finish the work only after the brief is approved (step 7 says by whom).

1. Read every source the user gave you (files, images, PDFs, links, repos) before writing anything. Copy local source files into `sources/` in the project folder; in a code repo, list their paths instead.
2. Write `BRIEF.md` in the project folder with these sections, in this order:
   - `## Goal`: one or two sentences, in the user's words.
   - `## Sources, most trusted first`: each with its path or link. When sources disagree, the higher one wins unless the user says otherwise. If the work depends on something that isn't in the folder (real-world measurements, an API spec, a contract), list it as `MISSING:` and make getting it an open question.
   - `## Keep exactly`: an inventory, one item per line, of everything that must survive, taken from the sources rather than from memory. Go part by part: for a document, every section, figure and number; for a drawing, every space with what it contains and every label and dimension as written; for code, the behaviour and interfaces that must not change.
   - `## May change`: only what the user said may change, and its limits.
   - `## Out of scope`: only what the user said. If they said nothing, write "Not discussed".
   - `## Outputs`: the path of each file this work will produce or change, one per line starting with `- `, relative to the project folder. Use a link for outside outputs such as a Google Doc.
   - `## Done means`: checkable criteria. For code, the tests that must pass, split into tasks with their own tests when the work has several parts.
   - `## Risk`: `major`, or `risky` if any output will leave this computer or be acted on in a way that's hard to undo (sending, submitting, publishing, pushing, merging, spending money, building).
   - `## Open questions`: everything you would otherwise have to guess.
3. Write only what the user said or a source shows. Anything else goes under Open questions.
4. Create `DECISIONS.md` with the header `date | decision | source`.
5. Write a first draft of each output listed under `## Outputs`. Mark every guess [ASSUMED] and add it under Open questions. If a source the work depends on is missing entirely (listed as `MISSING:`), skip the draft and say exactly which file or numbers you need. A draft never leaves this computer.
6. Show the user the brief with the Keep exactly inventory in full, because the checker enforces it later.
7. Decide who approves:
   - **Claude approves** when the work is AI setup or code, it touches no money, sending, publishing, deleting, installing outside tools, legal, health, house or taste matter, there is no `MISSING:` source, and every open question is a small, easy-to-undo choice. Pick the best answer for each open question, log it in DECISIONS.md with "Claude (small choice)" as the source, put `Approved: YYYY-MM-DD (by Claude, no owner questions)` as the first line of BRIEF.md, tell the user in one line they can say stop, and start the work.
   - **The user approves** in every other case. Ask the open questions one at a time, log each answer in DECISIONS.md with "user" as the source, and update the brief. A brief with a `MISSING:` source can't be approved unless the user explicitly says to go ahead without it; log that in DECISIONS.md. When the user approves, put `Approved: YYYY-MM-DD` as the first line of BRIEF.md, with no formatting. Then start the work.
