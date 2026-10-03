---
type: guide
skills: [grill-with-docs, wayfinder]
model: opus
---

# World history — the long past that shaped peoples, cultures and languages

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The world's history is its past before and around the story: the eras, and the
events that moved, mixed and divided its peoples. It is not the story's timeline, which orders
the story's own days in `planning/src/timeline.md`. Its job in the story bible is to explain
why things are as they are when the story opens: why two peoples share words, why one language
became two, why a script looks borrowed.

## Eras and events

- `world/src/history/eras.md` holds the eras, oldest first, one row each: the span, what defines
  it, the peoples in it, the language stage they spoke, and its events. It is the spine; an
  event with no era is not yet placed.
- Each major event has its own file: a migration, a conquest, first contact, a split, a
  founding, a catastrophe. Chart only events whose consequences reach the page or a language.
- Settle the order of the eras before any dates. Give years only when the story or a language
  needs them; a precise date is one more thing a chapter can contradict.

## Events leave marks in language

| Event | What it usually leaves |
|---|---|
| Migration or separation | Speech that drifts apart: one language becomes two, and the changes after the split belong to one branch only |
| Conquest | Words for rule, law and war from the conquerors; words for land, food and home kept by the conquered |
| Contact and trade | Words for traded goods, reshaped to the borrower's sounds; sometimes a neighbour's script |
| Script borrowing | A writing system that fits its new language badly; the awkward fits survive as spelling quirks |

Each event file states its consequences under `## Linguistic consequences`, or says there were
none, so nobody invents one later. With the constructed-language kit, each consequence becomes
language work: a split is a parent and a daughter joined by ordered sound changes, a loan has a
stratum and the sound change after which it entered, and a borrowed script records its origin.

## The record and the memory

Keep what happened apart from what each people remembers. A conquest may be a liberation in one
people's songs and a theft in another's; both belong in the file, marked as belief, and neither
replaces the record. A character knows their people's version, never the record.

## How we apply it here

- When the history is too large for one sitting, `wayfinder` charts it as a decision map in
  `planning/src/maps/`, with the order of the eras as its first frontier.
- `grill-with-docs` settles each era and event with the author, recording it as it resolves.
- Contradictions with peoples, cultures, places or the timeline are reported, never repaired.

## Who implements it

- **Skills:** `grill-with-docs` (eras and events), `wayfinder` (the map, when one is needed).
- **Workflow:** `world/workflows/11-chart-the-world-history/`.

## Governing standard

`standards/method/FICTION.md` owns the story bible as the source of truth and causality in the
story; `standards/verification/FICTION.md` owns the continuity gate. The standards own the
requirements; this guide owns how the world's past is ordered and what it leaves behind.
