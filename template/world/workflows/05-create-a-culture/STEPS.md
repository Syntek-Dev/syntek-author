---
workflow: 05-create-a-culture
phase: produce
skills: [create-name]
model: opus
---

# STEPS.md — create a culture

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for describing a culture from the ground up: how one people lives, once
its people file exists. Each step names the skill and guide it uses. **Run in order** (land
before values, values before customs) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `create-name` skill carries the judgement of step 6.

## 1. Fix the culture's job in the story

> **Skill:** none (the author's brief) · **Guide:** `world/docs/reference/cultures.md`

Ask the author which scenes and characters this culture shapes, and what the story needs from
it: a home to leave, a rival, a mirror, a threat. Depth follows the job. _Substantive._

## 2. Read the world it belongs to

> **Skill:** none · **Guide:** `world/docs/reference/cultures.md`

Read `world/src/names-register.md`, the people's file in `world/src/peoples/`, the other files in
`world/src/cultures/`, the events in `world/src/history/` that touch them, the places they live
in, the characters who come from them, and `planning/src/continuity.md`. If the people has no
file yet, offer `world/workflows/10-create-a-people/` first. Where the constructed-language kit
is installed and the people speak one of its languages, read that language's grammar and
phonology too. List what is already fixed. _Substantive._

## 3. Settle the land and the livelihood

> **Skill:** none (decided with the author) · **Guide:** `world/docs/reference/cultures.md`

Climate, terrain, food, work, trade, materials and tools, including what they would write on
and with, if they write at all. Offer options where the author has not decided, and check each
against the place files. _Substantive._

## 4. Settle values, taboos and beliefs

> **Skill:** none (decided with the author) · **Guide:** `world/docs/reference/cultures.md`

What the people prize, what shames them, what they fear; what they hold true about the world,
and the rites of a life. Tie each value to what survival on that land demanded. Name the domains
their speech will need many words for, and any words or older forms kept for the sacred.
_Substantive._

## 5. Settle power, kinship and customs

> **Skill:** none (decided with the author) · **Guide:** `world/docs/reference/cultures.md`

Who decides and how law is kept; how family is reckoned, and how rank is spoken to (titles,
polite forms); hospitality, greeting, dress, food, quarrel and reconciliation. Every custom gets
its reason; a custom with none is cut or given one. _Substantive._

## 6. Write the naming customs and test them

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

How people and places are named, by whom, and when a name changes; the sound palette that makes
the people's names recognisable. Test the customs by generating five sample names with
`create-name`; if the samples do not sound like one people, revise the customs, not the
samples. _Substantive._

## 7. Record variety and neighbours

> **Skill:** none · **Guide:** `world/docs/reference/cultures.md`

At least one internal division (old against young, town against country, devout against
practical), and the people's relations with each neighbouring people the book depicts.
_Substantive._

## 8. Run the depiction check

> **Skill:** none · **Guide:** `world/docs/reference/cultures.md`

Record what, if anything, the culture borrows from real peoples, and check it against
`standards/risk/FICTION.md`: a real people reduced to one trait, or a sacred practice used as
decoration, is reported to the author with a suggested alternative. The outcome goes in the
internal note under the file's frontmatter. _Substantive._

## 9. Confirm you will not clobber a file, then write it

> **Skill:** none · **Guide:** `world/docs/reference/cultures.md`

Check that `world/src/cultures/<slug>.md` does not exist; if it does, stop and ask. Write the
file from the skeleton in `world/src/cultures/CLAUDE.md`, one sentence per line, with `people`
naming the people's file and `first_appears` left empty. _Mechanical._

## 10. Register the names

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Register the culture's own name with kind `culture` only when it differs from its people's
registered name; never register the people's name again, because every name in the register is
unique and `make lexicon` fails on a repeat. A people's name not yet registered goes through
`world/workflows/10-create-a-people/`. Then add only those sample names the author decides the
book will use. _Mechanical._

## 11. Hand back

> **Skill:** none · **Guide:** `world/docs/reference/cultures.md`

Report the file written, the names registered, the depiction check's outcome, any character or
place that now contradicts the culture, and the open flags. _Substantive._
