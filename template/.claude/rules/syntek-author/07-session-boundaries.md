# 07-session-boundaries.md — hand off, never compact

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Template-owned.** Shipped by syntek-author and replaced by every `copier update`: never edit it here. Project-specific rules belong in `.claude/CLAUDE.md` Section 3.

The `PreCompact` hook (`.claude/hooks/pre-compact-handoff.sh`) cites this file. It is the rule the
hook enforces.

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
  initiative.
- The `PreCompact` hook runs `.claude/hooks/pre-compact-handoff.sh` on both triggers. On `auto` it
  **blocks** compaction (exit 2) and prints the steps below; on a manual `/compact` it **warns**
  and lets it proceed (exit 0), because a deliberate choice by the author is not overridden.
- A hook cannot write a handoff or end a turn; only the model can. This rule is what carries the
  behaviour, and the hook is the backstop.

Hand off before the window is full, not when the hook fires. Compaction that is blocked at the
hard limit leaves the current request to fail, and a handoff written in a hurry is the one most
likely to leave something out.

---

## 3. The steps

1. **Record durable knowledge in its real home first**: a decision or fact in `.claude/MEMORY.md`
   (through the gate in `.claude/rules/syntek-author/08-naming-and-memory.md` Section 3); a
   unit decision in its brief in `planning/src/units/`; a folder rule in that folder's
   `CLAUDE.md`; a provenance record in the ledger.
2. **Invoke the `handoff` skill.** It writes
   `handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`, where the descriptor names the work, not the
   session (`HANDOFF-OPENING-SECTIONS-03-10-2026.md`, not `HANDOFF-TUESDAY-…`). Its mode file adds
   the part this doc type must never drop:
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
  to bring it up to date. Work that will span many sessions by design belongs in a decision map in
  `planning/src/maps/` (the `wayfinder` skill), not in a chain of handoffs.
