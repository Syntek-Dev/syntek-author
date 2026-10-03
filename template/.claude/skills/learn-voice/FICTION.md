# FICTION.md — learn-voice, fiction mode

The domain for learning the voice of a novel: which entries are mined, the narrator against the
characters, and where a character's own voice belongs.

## Paths and unit

- **Procedure:** `manuscript/workflows/07-learn-from-your-edits/`.
- **Entries mined (step 1):** every ledger entry with `learned: false`. One with a `promoted`
  date is mined whole; one whose section is not yet promoted lends only its
  `## Improvement decisions` and stays unlearned, because its author final is still to come.
- **Registers (step 4):** the narrator, and the narration's shifts with the point-of-view
  character, both kept under `## Registers` in `standards/style/voice-notes.md`.
- **Homes:** a narrator habit goes under `## Learned` in `standards/style/voice-notes.md`. A habit
  in one character's dialogue belongs to that character's `## Voice markers` in
  `world/src/characters/`, and is put to the author as a proposal for that file, written there
  only on their explicit instruction. A mechanical habit goes to `standards/style/style-sheet.md`
  and a preferred spelling or term to `standards/style/terminology.md`, each written only as an
  approved, dated entry.
- **Method:** `standards/method/FICTION.md`.

## Additions to the steps

- **Step 3 — also separate narration from dialogue.** Read the author's changes to narration and
  to each character's speech apart: a cut the author makes in one character's mouth says nothing
  about the narrator.
- **Step 3 — also set aside changes of story.** An edit that changed an event, a cause, a fact
  or a name is a story decision, recorded through continuity, not a voice habit.
- **Step 4 — also name the point of view.** A narration pattern seen only under one
  point-of-view character is a shift by point of view, not a narrator mark; say which character.
- **Step 6 — also check a pattern against the characters.** Where a proposed narrator note would
  make the narrator sound like one character, say so: the voices must stay distinct.

## Domain rules

- **Dialect, deliberate fragments and a character's habits are voice**, and they belong to the
  speaker, not to the narrator.
- **Constructed words are not voice evidence**: an edit to a romanised word or its span is a
  lexicon matter, raised separately.
- **Point-of-view discipline** (`standards/method/FICTION.md` Section 5) wins over any voice
  habit that would let the narration know more than its point-of-view character.

## Examples

An invented `## Learned` bullet, as written after approval:

```markdown
- **DD/MM/YYYY** — **The narrator names the feeling last, if at all.** Before: 'She felt afraid as the water rose.' After: 'The water rose. She did not move.' (from `02-kebab-title--the-turn` and `05-kebab-title--the-gate`)
```

An invented proposal for a character file, kept apart from the voice notes:

```text
Character habit (proposed for that character's ## Voice markers, not the voice notes): in three
rejected suggestions you kept Ilsa's questions unanswered by herself. Record 'Ilsa never answers
her own questions'?
```
