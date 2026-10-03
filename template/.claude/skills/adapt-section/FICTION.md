# FICTION.md — adapt-section, fiction mode

The domain for revising a beat of a novel from the author's notes, and for turning an earlier
draft or a short story into a beat of this chapter.

## Paths and unit

- **Unit:** a chapter. **Section:** one scene beat.
- **Procedure:** `manuscript/workflows/02-adapt-a-draft/`.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`; its brief is
  `planning/src/units/NN-kebab-title.md`.
- **The story bible and plot record:** `world/src/`, `world/src/names-register.md`,
  `planning/src/continuity.md`, `planning/src/causality.md` and `planning/src/timeline.md`.
- **Kinds of source this project adapts (step 7):** the author's earlier draft of a scene, or a
  short story of theirs, reworked into this chapter's beat.
- **Guides:** `manuscript/docs/reference/drafting-with-ai.md`,
  `manuscript/docs/reference/the-status-ladders.md` and `manuscript/docs/reference/scene-craft.md`.
- **Method:** `standards/method/FICTION.md`.

## Additions to the steps

- **Step 3 — also check a note that changes what happens.** A note that changes an event, a
  cause or a fact the reader has been given is checked against `planning/src/causality.md` and
  `planning/src/continuity.md` before anything is changed. A contradiction is reported with both
  locations, for the author to decide which is canon; neither side is repaired.
- **Step 5 — also hold the point of view, the tense and the voices.** A revised line keeps the
  chapter's point-of-view character, its tense and each speaker's voice markers (in their file in
  `world/src/characters/`). A name not in the register is never introduced by a revision; a
  constructed word in its `{.conlang …}` span is left exactly as it is unless the note is about it.
- **Step 6 — also the holding line is the original.** Leave the original line in the draft until
  the author chooses between the alternatives.
- **Step 7 — also reconcile the source with the bible.** When reworking an earlier draft or a
  short story, shift its point of view and tense to the chapter's, rename every person and place
  to the register's names (proposing any missing one through `create-name`), and list each fact
  the source asserts that the story bible contradicts or lacks. The source's events are kept only
  where `planning/src/causality.md` has a place for them.
- **Step 10 — also list new facts.** Any fact the revision now establishes is listed for
  `planning/src/continuity.md`, for the author to accept at promotion.

## Domain rules

- **Contradictions are reported, never repaired** (`.claude/rules/syntek-author/03-authorship.md`
  Section 7); the story bible is the source of truth (`standards/method/FICTION.md` Section 6).
- **Point-of-view discipline** (Section 5): a revision never lets the narration know what its
  point-of-view character cannot.
- **Every beat keeps its cause** (Section 1); a note that removes a cause removes the beat's
  reason to exist, and the author is told so.
- **Dialect, deliberate fragments and a character's verbal habits are voice**, not errors; keep
  them unless the note is about them.

## Examples

An invented open note and its alternatives (step 6), different in kind:

```text
Note 2: 'The ending is flat.'
  1. End on the action: 'She let go of the rope.' (shorter; the reader supplies the fear)
  2. End inside her head: 'She thought of the mill, and let go.' (closer; names the cost)
  3. End on the river: 'Below her, the water did not stop.' (wider; hands on to the next beat)
```

An invented contradiction, reported rather than repaired:

```markdown
<!-- AUTHOR TO CONFIRM: the note makes the ford knee-deep, but planning/src/continuity.md F012 has it waist-deep at the willow. Which is canon? -->
```
