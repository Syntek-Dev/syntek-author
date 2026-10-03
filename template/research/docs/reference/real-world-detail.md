---
type: guide
skills: [research, fact-check]
model: opus
---

# Real-world detail — checking the world a novel borrows

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** How to check the real world a novel depicts (places, periods, professions,
procedures, objects, law, medicine, speech) so that every departure from it is a choice and never
an accident. Readers will accept an invented kingdom; they will not accept a train that never ran,
a weapon that could not have fired, or a ward handover no nurse would recognise. A reader who
catches one error stops trusting the rest. Invented facts belong to the story bible in `world/src/`;
this guide is about the real world.

## What counts

Anything a reader could check against the world:

- **Time:** dates, events, what had and had not been invented, prices and wages of the period.
- **Place:** geography, distances and travel times, weather and light in a given season.
- **Work:** how a job is actually done, its vocabulary, its routines and its hierarchy.
- **Bodies:** injury, illness, recovery, what a body can do after no sleep or in the cold.
- **Law and procedure:** arrest, trial, inheritance, marriage, as they stood at the time.
- **Speech:** the idiom and register of a time, a place and a class.

## Where it goes

Texture (how a place sounds at night, how a trade's tools are held) goes in a setting note in
`research/src/setting/`, with the source it came from. A fact the prose will state plainly goes
through `research/workflows/02-verify-a-claim/` into `research/src/evidence/`. A first-hand account
from someone who knows the world is a source too: note who (by role, not name, unless they agree to
be named) and when.

## Deliberate departures

A novel may change the world: move a building, shift a date, invent a town. Record each departure
in its setting note and in `planning/src/continuity.md`, so `continuity` holds the book to its own
version, and consider an author's note where a reader would otherwise take it for a mistake. An
undocumented departure is indistinguishable from an error.

## Real people and borrowed words

- **A real person, organisation or crime** shown on the page carries risk; read
  `standards/risk/FICTION.md` before drafting it, and flag it for the author.
- **Quotation, epigraph, lyric, poem:** every passage reproduced from another work gets a row in
  `research/src/permissions.md` when it enters a draft, and is treated as needing clearance until
  the publisher says otherwise.

## How we apply it here

- **Primary over remembered.** The period source, the manual, the map, the practitioner; never
  another novel's version of the same world.
- **Two dates** where the detail can change: when it was true, and when you checked it.
- **Never invent a source.** An unchecked detail in the prose carries a `VERIFY` flag until it is
  checked.

## Who implements it

- **Skills:** `research` (reading), `fact-check` (period accuracy and real-world claims),
  `continuity` (the book against its own record). **Workflows:**
  `research/workflows/01-ingest-a-source/`, `research/workflows/02-verify-a-claim/`.

## Governing standard

`standards/risk/FICTION.md` owns depiction and real people; `standards/method/FICTION.md` makes the
story bible the source of truth. The standards own the rules; this guide owns checking the world.
