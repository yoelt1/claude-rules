---
name: handoff
description: Write HANDOFF.md in the project folder so a fresh session can continue the work, or pick up from an existing HANDOFF.md. Use when the user types /handoff, says a session is too long or asks for a hand-over, or starts a session with "Read HANDOFF.md and continue". Also use when a job listed in HANDOFF.md is finished.
---

# Hand-over between sessions

One fixed file, `HANDOFF.md`, in the top folder of the project. Never anywhere else: a note outside the project folder is invisible to the next session.

## Writing the note (ending a long session)

1. Finish or stop cleanly first. If a check, test or decision is half done, say so in the note; do not leave it implied.
2. Log any decision not yet in `DECISIONS.md`.
3. Write `HANDOFF.md` in the project's top folder, replacing the old one. 60 lines at most. Plain words. Sections, in this order:
   - `## Goal`: one or two lines, in the user's words.
   - `## Done and checked`: what is finished, with the file path and how it was checked (test output, checker verdict).
   - `## Done, not checked`: finished but unverified. Say what would verify it.
   - `## Tried and failed, known traps`: what not to repeat, and why.
   - `## Open questions for the user`: each one answerable in a line.
   - `## Next step`: the exact next action, with file paths.
   - `## Read first`: `BRIEF.md`, `DECISIONS.md`, and any other file the next session needs. Point to them; do not copy them.
4. Leave out: the story of the session, tool output, anything already in `BRIEF.md` or `DECISIONS.md`, and conclusions with no file or evidence behind them.
5. Read the file back to confirm it is there. Commit it with any finished work, following the project's rules for pushing and merging.
6. Start the next job's session yourself when this session has a start-session tool (the desktop app's `start_session`). Do this when the user is on Remote Control too (the new session runs on the same computer as this one; worked once with Remote Control on, 24 Nov, job 15; if it fails, say so in step 7).
   - Next job: the first job in HANDOFF.md that is not done and not waiting on the user. If none is left, start nothing.
   - Start a fresh session in the same project folder, without a worktree. Title: `<project> – job N: <short name>`. Brief: `Read HANDOFF.md and continue with job N.` plus one line on the goal.
   - After it starts, make no more edits in this folder (one writing session per folder at a time).
   - If the app shows a card for the user to start instead, say that one tap on the card starts it.
7. Tell the user in two lines: the HANDOFF.md path as a link, and which job's session started, with its link (or why none started).
8. Only when there is no start-session tool (cloud, terminal): give the line to send, `Read HANDOFF.md and continue with job N.`, and how to get a fresh session (a new session in the same folder, or `/clear` in this one).

## Picking up (starting from a note)

1. Read `HANDOFF.md`, then the files under "Read first".
2. If HANDOFF.md lists more than one job, take the first one not yet done unless the user names another, and say which one you took.
3. Check the note against the files before doing new work: the files it names exist, and "Done and checked" items are really there. Rerun a test if one is named and cheap.
4. Tell the user in a few lines: what you found, any mismatch ("the note said X, the folder shows Y"), and the next step you will take.
5. If a mismatch or open question is about the user's goals, or about money, sending, publishing, deleting, installing outside tools, legal, health or taste, ask before continuing. Otherwise fix the note to match the files, say so in one line, and carry on with "Next step".
6. If there is no `HANDOFF.md` in the project folder, say so and ask where the note is. Do not search the whole computer for it.
