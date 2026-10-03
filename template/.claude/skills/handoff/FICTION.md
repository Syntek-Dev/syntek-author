# FICTION.md — handoff, fiction mode

What a novel's handoff must never drop: the open continuity threads, which a fresh session cannot
see in any single file.

## Paths and unit

- **Unit:** a chapter, `manuscript/src/NN-kebab-title/`, with its sections in `drafts/`; its brief
  is `planning/src/units/NN-kebab-title.md`.
- **Anchors** for in-flight work point into the section draft, the brief's
  `## Continuity facts`, `planning/src/causality.md`, `planning/src/continuity.md`,
  `planning/src/timeline.md`, a character's arc in `planning/src/arcs/`, or a story-bible file.

## Additions to the steps

- **Step 1 — also** register any name settled this session in `world/src/names-register.md`
  (through create-name), and put any fact the session's prose established into the brief's
  `## Continuity facts`, before writing the handoff.
- **Step 4 — also** give the scene in flight its point-of-view character, its place on
  `planning/src/timeline.md`, and the beat in `planning/src/causality.md` it is meant to deliver.
- **Step 5 — also carry the open continuity threads.** The part is headed
  `## Open continuity threads` and names:
  - **Planted set-ups not yet paid off**, each with the section that plants it.
  - **Facts established this session** that are not yet in `planning/src/continuity.md`, each
    with its section and line.
  - **Unresolved contradictions** found against the story bible: reported, not repaired.
  - **Names or words coined but not yet registered**: names not in the register; where the
    language kit is installed, words not yet in their lexicon, and whether `make lexicon` has run.
  - **Open language decisions**: a real-world model, period or romanisation discussed but not yet
    confirmed and recorded.

## Domain rules

- **A continuity thread lives in its plan file, not in the handoff.** The handoff lists it so the
  fresh session knows to look; the record is the brief, `planning/src/continuity.md` or the
  causality chain.
- **Never carry a coined word or name only in the handoff.** Register it, or list it under the
  threads as unregistered, with the section that uses it.
- **A real person or a lived experience behind the story** is named and located, never described
  (`standards/risk/FICTION.md`).

## Examples

```markdown
## Open continuity threads

- Set-up: the cracked oar-lock (03-the-ford/drafts/02-the-turn.md:14); payoff planned in
  chapter 7, not yet drafted.
- Established, not yet in continuity.md: the ferryman cannot swim (02-the-turn.md:27).
- Contradiction: the ford is 'waist-deep' here (line 9) but 'chest-deep' in the places file
  (world/src/places/the-ford.md:6); reported to the author, both left as they are.
- Unregistered: the ferryman's name, 'Osk' (02-the-turn.md:33).
- Open language decision: whether river-names take the Celtic-accent spellings (not confirmed).
```
