---
name: grill-me
description: >-
  Grill an idea and write nothing down: the grilling interview, in frontier rounds with a
  recommended answer on every question, that sharpens a half-formed plan, argument, plot turn,
  name or offer and leaves no trace in the repository. Invoke by typing /grill-me, or when
  <%AUTHOR_FIRST_NAME%> says 'grill me on this', 'poke holes in it', 'talk me through whether
  this works' or 'don't record this'. If an answer turns out to be load-bearing, it says so and
  offers to switch. Not for decisions that must outlive the session (`grill-with-docs`), and not
  for work too big for one sitting (`wayfinder`).
---

# Skill: Grill-me (<%PROJECT_NAME%>)

Run a grilling session and save nothing. `.claude/skills/grilling/SKILL.md` is the engine and its
mode file is the domain: **they own the round shape, the question format, the recommendation rule
and the surfaces; this file does not restate them.** Grill until the idea is settled and
<%AUTHOR_FIRST_NAME%> confirms shared understanding.

Use this when the interview itself is the point and there is no artefact to update yet. Typical
openings:

- testing whether a unit's argument, a plot turn or a document's offer actually holds before it is
  committed to a brief;
- working out, out loud, what the work really wants to say about something;
- thinking through what a name, a word or an invented language should sound like before anything
  is coined (grilling's mode file sets which question opens such a round);
- rehearsing a difficult reply, or a position the author is drawn to, before it hardens.

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** A `grill-me` session sits before any procedure, and records nothing for
one to pick up. The engine's own procedures are listed in `.claude/skills/grilling/SKILL.md`; the
rule it serves is `.claude/rules/syntek-author/06-global-rules.md` Section 8 (design work opens
with grilling).

## Steps

1. **Load the engine and its mode.** Read `.claude/skills/grilling/SKILL.md` and the mode file
   beside it, then run its step 1 against the record. *Complete when:* the engine's step 1 is
   done and the first round is ready to send.
2. **Grill in frontier rounds, recording nothing.** Follow the engine exactly. Write no file,
   edit no brief, touch no `.claude/MEMORY.md` entry. *Complete when:* the frontier is empty and
   <%AUTHOR_FIRST_NAME%> has said yes to the summary.
3. **Name any decision with no home.** Because nothing is recorded, a session that settles
   something load-bearing (a reading the work adopts, a scope boundary, a language's real-world
   model, a price) has produced a decision nobody will find next month. If that happened, say so
   at the end and offer to re-run that part under `grill-with-docs`, or to record it directly
   through that skill's gate. *Complete when:* every load-bearing answer is either named with the
   offer made, or there was none and the session says so.

## Anti-patterns

- **Writing anything down.** That is `grill-with-docs`; switch openly rather than half-recording.
- **Restating the engine** here or in the conversation instead of following it.
- **Letting a load-bearing decision evaporate.** A conclusion nobody recorded is argued again.
- **Settling a fact by asking.** Empirical questions go to `fact-check` or `research`, exactly as
  the engine says.

## Cross-references

- `.claude/skills/grilling/SKILL.md` — the engine this runs, and its mode file.
- `.claude/skills/grill-with-docs/SKILL.md` — the stateful twin that records each decision.
- `.claude/skills/wayfinder/SKILL.md` — for work too big to settle in one sitting.
