# FICTION.md — grammar in a novel

A novel's grammar lives in two places: the narration, which holds one tense and one point of view
per scene, and the dialogue, where a character's grammar is characterisation. This mode adds
dialogue punctuation, the grammar of invented words, and the line between a slip and a voice.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with section drafts
  in its `drafts/` folder.
- **The pass** is step 9 of `manuscript/workflows/05-review-a-chapter/`.
- **Extra reads:** each character's voice markers in `world/src/characters/`;
  `manuscript/docs/reference/scene-craft.md` (point of view and orientation); how the style sheet
  marks thought, scene breaks and invented words.
- **Where corrections go:** an accepted punctuation correction may be applied in the chapter file
  directly, logged as a row in that section's ledger entry. Any correction that changes a word,
  however small, is a wording change: it goes back through `manuscript/workflows/02-adapt-a-draft/`
  or `manuscript/workflows/03-improve-your-draft/` and is promoted again through
  `manuscript/workflows/04-promote-a-section/` (`manuscript/workflows/05-review-a-chapter/`,
  'Applying agreed fixes').

## Additions to the steps

- **Step 3 — also:** the narrative tense is held within a scene; a slip is reported with the tense
  the scene is in. A change of point of view inside a scene is not grammar: hand it to
  `character-voice`.
- **Step 4 — also, dialogue:** single quotation marks; a new paragraph for each new speaker; a
  dialogue tag ('she said') joined to the speech by a comma inside the closing mark; an action beat
  written as its own sentence; interrupted and trailing speech marked as the style sheet sets them;
  a quotation inside speech in double marks; thought marked as the style sheet says.
- **Step 4 — also, invented words:** punctuation sits outside an invented word and its markup,
  never inside; plurals and possessives of invented words follow the style sheet. If it is silent,
  propose an entry on first use (an English '-s', or the language's own plural).
- **Step 5 — also:** dialect grammar in dialogue, and in close narration of a dialect speaker, is
  voice when that character's voice markers record it; a fragment in action or interior thought is
  usually deliberate. An unrecorded case is asked about once per character, not once per line.

## Domain rules

- **A character's grammar is characterisation.** Never correct it towards the narrator's.
- **Never correct an invented language's grammar towards English**; its grammar is in its own
  files, and a doubt about it is reported for the author.
- **Tense slips are grammar; point-of-view slips are voice.** Report each to its owner.

## Examples

> **Dialogue tag.** `the-turn` line 5: `'Hold the rope.' Maren said.` → `'Hold the rope,' Maren
> said.` Applied in the chapter file once accepted; ledger row added.

> **Action beat.** `the-turn` line 11: `'Now,' Tam lifted the lantern.` → `'Now.' Tam lifted the
> lantern.` (lifting is an action, not a way of speaking).

> **Tense slip.** `opening` line 14: the scene is in the past tense; 'the water rises' is present.
> Reported; if it is deliberate, the author says so and it is recorded in the internal note.

> **Not reported.** The ferryman's 'we was' in dialogue, recorded in his voice markers.
