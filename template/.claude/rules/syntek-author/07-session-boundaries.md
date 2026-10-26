# 07-session-boundaries.md — hand off, never compact

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. This project's settings, paths and overrides are in `00-project.md` beside it, which outranks this file; project rules go where its `## Paths` says.

The two session hooks, `.claude/hooks/context-threshold-handoff.sh` (`UserPromptSubmit`) and
`.claude/hooks/pre-compact-handoff.sh` (`PreCompact` and `SessionStart`), cite this file. It is
the rule they enforce.

---

## 1. The rule

**Requirement.** When a session's context window nears full, or the work reaches a natural break
(the end of a day, a move to another unit), write a handoff and stop. Never let the session
compact.

**Why this rule exists.** A half-finished unit carries many settled decisions: a reading chosen, a
concession positioned, a fact verified, a line the author rejected and why. Compaction summarises
them, and a summary keeps the conclusions while dropping the reasons, so the next session
finishes the work on half-remembered decisions. A handoff carries the live thread deliberately,
and a fresh session starts from it with a full window.

---

## 2. How it is enforced

- `.claude/settings.json` sets `"autoCompactEnabled": false`, so compaction never starts on its own
  initiative as the window fills, and `"idleCompaction": false`, so it never starts while a long
  session sits idle either, even where the first is turned back on. Claude Code fires the same
  `PreCompact` `auto` trigger for an idle compaction, so without the second a pause could end in
  the note to hand off with the window far from full; a version older than 2.1.290 ignores the
  key. The seed sets both; a copy over a `settings.json` of its own, or the next update, adds each
  once where the file has no such key. A value the author set is kept, and the copy or update
  says once that the handoff hooks assume false; set it to false to use them (without them, the
  `PreCompact` hook still blocks compaction).
- The `UserPromptSubmit` hook runs `.claude/hooks/context-threshold-handoff.sh` before every
  prompt and measures the context window. At **50%** it advises, once a session: finish the step
  in flight, open nothing new that will not fit, name the stopping point and offer `/handoff`. At
  **75%** it insists, on every prompt: hand off now, with the steps below. It assumes a window of
  200,000 tokens; for a larger one, set `CLAUDE_CONTEXT_WINDOW` under `"env"` in
  `.claude/settings.local.json`. It never blocks a prompt.
- The `PreCompact` hook runs `.claude/hooks/pre-compact-handoff.sh` on both triggers. On `auto` (the
  window near its limit, or the session idle) it **blocks** compaction (exit 2), and the author's
  next prompt in that session shows 'Automatic compaction was stopped. Run /handoff to save where
  you are, then /clear to start a fresh session. If /handoff has no room to run, run /compact
  yourself (it is allowed), then /handoff.', with the same news for the session. On a manual
  `/compact` it lets the compaction proceed (exit 0), because a deliberate choice by the author is
  not overridden; once it is done, the `SessionStart` hook shows a note that a handoff gives a
  cleaner break (next time `/handoff`, then `/clear`) and tells the session that its earlier
  conversation is now a summary. Because Claude Code cannot be relied on to show what a
  `PreCompact` hook prints on either path, the hook leaves a marker for the session,
  `.claude/compaction-marker-<session_id>.tmp` (git-ignored), for that session's later hook to
  read. Each session has its own, so one session's compaction never touches another's note; when
  the hook leaves one, it removes any other session's marker more than seven days old (a session
  never resumed).
- A hook cannot write a handoff or end a turn; only the model can. This rule is what carries the
  behaviour, and the hooks are the prompt and the backstop.

Hand off before the window is full, not when the compaction hook fires. **At the 75% warning,
the handoff is the next thing written; at 50%, plan the stopping point.** Compaction that is
blocked at the hard limit leaves the current request to fail, and a handoff written in a hurry
is the one most likely to leave something out. Where the window has no room left to write the
handoff, say so rather than start one that cannot be finished: <%AUTHOR_FIRST_NAME%> may run
`/compact`, which the project allows, and then `/handoff`. After a `/compact` made to make room
for a handoff, offer the `handoff` skill at once. Other coding agents have no such hook: there
the session watches its own window and follows the same thresholds.

---

## 3. The steps

1. **Record durable knowledge in its real home first**: a decision or fact in `.claude/MEMORY.md`
   (through the gate in `.claude/rules/syntek-author/08-naming-and-memory.md` Section 3, under
   the heading `00-project.md` `## Memory headings` maps it to); a
   unit decision in its brief in `planning/src/units/`; a folder rule in that folder's
   `CLAUDE.md`; a provenance record in the ledger.
2. **Invoke the `handoff` skill.** It writes
   `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md` (or the folder and filename `00-project.md`
   `## Paths` gives for 'Handoffs' and 'Handoff filename'), where the descriptor names the work,
   not the session (`HANDOFF-OPENING-SECTIONS-03-10-2026.md`, not `HANDOFF-TUESDAY-…`). Its mode
   file adds the part this doc type must never drop:
<: if DOC_TYPE == 'theology' :>   the standing commitments (an objection left standing, a disclosure that must be restated).
<: elif DOC_TYPE == 'fiction' :>   the open continuity threads (planted set-ups not yet paid off, unresolved continuity rows).
<: else :>   what is unsent or unregistered (a document drafted but not sent, a version not yet in the register).
<: endif :>3. **Print the handoff's path and stop the turn.** Do not carry on working: a handoff followed by
   more work is already stale.
4. <%AUTHOR_FIRST_NAME%> runs `/clear` and resumes in a fresh window from the handoff file.

---

## 4. What a handoff is not

- **Not a memory store.** If a fact will still matter next month, it belongs in
  `.claude/MEMORY.md` or a folder file, and the handoff links to it.
- **Not a copy of the work.** Artefacts are referenced by path, with `path:line` anchors for
  anything in flight. A handoff that quotes half a section has recreated the context it was meant
  to replace.
- **Not confidential.** It is committed. Confidential material is named and located, never pasted
  (`.claude/rules/syntek-author/06-global-rules.md` Section 10).
- **Not permanent.** Prune a handoff once its work has resumed and landed; never edit an old one
  to bring it up to date. Work that will span many sessions by design belongs in a decision map
  (the `wayfinder` skill; `00-project.md` `## Paths`, 'Decision maps'), not in a chain of
  handoffs.
