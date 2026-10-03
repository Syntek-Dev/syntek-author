---
workflow: 11-chart-the-world-history
phase: produce
skills: [grill-with-docs, wayfinder, create-name]
model: opus
---

# STEPS.md — chart the world history

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for charting the world's long past. Each step names the skill and guide
it uses. **Run in order** (the reckoning before the eras, the eras before the events, each event
before its consequences) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `grill-with-docs` skill settles each era and event with the author and records it as it
> resolves; `wayfinder` charts the work first when it is too large for one sitting.

## 1. Fix what the story needs from the history

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

Ask the author which parts of the past reach the page or the languages: a war a character
remembers, a split between two peoples' speech, a script borrowed from a neighbour. Depth
follows those needs; the rest stays unwritten. _Substantive._

## 2. Read the world as it stands

> **Skill:** none · **Guide:** `world/docs/reference/world-history.md`

Read `world/src/history/eras.md` and its event files, the files in `world/src/peoples/` and
`world/src/cultures/`, the places, the Calendar in `planning/src/timeline.md`, and
`planning/src/continuity.md`. Where the constructed-language kit is installed, read each
language's family and models too. List every movement, conquest or contact the files already
assume. _Substantive._

## 3. Chart a map if the history is large

> **Skill:** `wayfinder` · **Guide:** `world/docs/reference/world-history.md`

If the open decisions will not fit one sitting, chart them as a decision map in
`planning/src/maps/`, with the order of the eras as the first frontier, and work the frontier
across sessions. Otherwise say so and continue. _Substantive._

## 4. Settle the reckoning

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

How the world counts years across the eras, and where that count meets the story's calendar.
Record it under Reckoning in `eras.md`. _Substantive._

## 5. Settle the eras, oldest first

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

For each era: its span, what defines it, the peoples present, and the language stage each
spoke. Add one row per era to `eras.md` as each is settled, in order; leave a cell as a dash
rather than guess. _Substantive._

## 6. Choose the events worth a file

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

From step 2's list and the author's needs, choose the migrations, conquests, contacts, splits and
foundings whose consequences reach the page or a language, and place each in its era.
_Substantive._

## 7. Create each event file

> **Skill:** none · **Guide:** `world/docs/reference/world-history.md`

Check that `world/src/history/<slug>.md` does not exist; if it does, stop and ask. Create it
from the skeleton in `world/src/history/CLAUDE.md`, one sentence per line, and add its slug to
the era's Events cell. _Mechanical._

## 8. Settle each event

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

What happened, its causes, and who it changed and how, for each people involved. Record each
answer in the file as it resolves. _Substantive._

## 9. Trace the linguistic consequences

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

Loanwords (which way they travelled, in which domains), splits (which speech divided, and which
sound changes belong after it), and script borrowing (who took whose writing, and how badly it
fitted); or 'none' where there were none. With the constructed-language kit, list each as
language work for the hand-back, without changing any language file. _Substantive._

## 10. Record what each people remembers

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/world-history.md`

Each people's version of the event, marked as belief and kept apart from what happened.
_Substantive._

## 11. Check the history against the world

> **Skill:** none · **Guide:** `world/docs/reference/world-history.md`

Compare the eras and events with the people, culture and place files, the timeline and the
continuity ledger. Report every contradiction with both locations; never repair one.
_Substantive._

## 12. Register any invented names

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

An era or an event with an invented name gets a register row (kind `event` for both), chosen
and checked like any other name. _Mechanical._

## 13. Hand back

> **Skill:** none · **Guide:** `world/docs/reference/world-history.md`

Report the eras and event files written, the map if one was charted, the language work each
consequence implies, the contradictions found, and the open flags. _Substantive._
