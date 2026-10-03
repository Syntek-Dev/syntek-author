---
type: guide
skills: [create-name, chart-character-arc]
model: opus
---

# Story bible — what the world files are for

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The story bible is the set of files under `world/src/` that record what is true
in the novel: who its people are, what its places are like, which names exist and how they are
said. It is the record the prose is checked against. When a chapter and the bible disagree, one
of them is wrong, and only the author decides which.

## World or planning?

| Belongs in `world/src/` | Belongs in `planning/src/` |
|---|---|
| A character's want, need, wound, voice markers and relationships | How the character changes across the book (`planning/src/arcs/`) |
| A place's geography, senses, history and rules | When things happen there (`planning/src/timeline.md`) |
| Every invented name, with IPA and a respelling | Why one event causes the next (`planning/src/causality.md`) |
| What is true, whether or not the reader learns it | Where the reader learned it (`planning/src/continuity.md`) |
| The world's long past before the story (worldbuilding kit) | The story's own days, in story-time order (`planning/src/timeline.md`) |

**The test:** would the fact still hold if the chapters were written in a different order? Then
it is world. If it depends on when the reader finds out, it is planning. Real places and periods
you have checked live in `research/src/setting/`; the bible cites them rather than copying them.

## How a fact settles

1. The author decides it, in conversation or in a world file. Options are offered; the choice
   is the author's.
2. One world file records it, once. Other files link to that file instead of repeating it.
3. Prose that uses it is checked against it by `continuity`, at structural review.
4. When promoted prose first relies on it, `planning/src/continuity.md` records the section.
   From then on the fact is frozen: changing it changes the book, so the affected sections are
   listed for the author before anything is edited.

## Depth on demand

Write what a scene uses, or what constrains something a scene uses. A character's childhood
earns a line if it explains a choice in Chapter 9; a currency earns a file if money changes
hands on the page. An unused fact is not harmless: it is one more thing a later chapter can
contradict, and a bible thick with them is skimmed rather than read.

When a scene needs something the bible lacks, do not invent it in the prose. Flag
`<!-- AUTHOR TO CONFIRM: … -->` at the point of use, and add the fact to the bible once the
author has decided.

## How we apply it here

- One file per character and per place, named for the registered name in kebab-case; the
  worldbuilding kit adds peoples, cultures, creatures and world history in the same pattern.
- Every name is registered in `world/src/names-register.md` before it appears in promoted
  prose, so that `spelling` knows it and `continuity` can find it.
- Contradictions are reported with both locations, never repaired silently in either direction.
- World files are notes, not prose: one sentence per line, plain, and no polishing.
- A fact with a real-world basis (a river's width, a period's coinage) is checked through
  `research/workflows/02-verify-a-claim/` before the bible relies on it.

## Who implements it

- **Skills:** `create-name` (every name), `chart-character-arc` (want, need, wound and the lie),
  and `continuity`, which checks the prose against the bible.
- **Workflows:** `world/workflows/01-create-a-character/`, `world/workflows/02-create-a-place/`
  and `world/workflows/03-name-something/`.

## Governing standard

`standards/method/FICTION.md` owns the rule that the story bible is the source of truth;
`standards/verification/FICTION.md` owns the continuity gate at structural review. The
standards own the requirements; this guide owns what goes in which file, and when a fact
becomes fixed.
