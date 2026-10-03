# FICTION.md — grill-with-docs, fiction mode

Where a novel's decisions are recorded: the plan files, the story bible and, where the language
kit is installed, each language's own data files.

## Paths and unit

- **Brief:** `planning/src/units/NN-kebab-title.md`; its settled-positions slot is
  `## Continuity facts`.
- **Plan files:** `planning/src/causality.md`, `planning/src/timeline.md`,
  `planning/src/continuity.md`, and one arc per character in `planning/src/arcs/`.
- **Story bible:** `world/src/characters/`, `world/src/places/` and `world/src/names-register.md`
  (written through create-name); with the worldbuilding kit, the peoples, cultures, history and
  creatures files (world/src/peoples/, world/src/cultures/, world/src/history/, with eras.md, and
  world/src/creatures/) and quests (planning/src/quests/); with the language kit, each language
  folder (world/src/languages/<lang>/: language.toml, phonology.toml, sound-changes.toml,
  lexicon.toml and script/glyphs.toml).
- **Research:** `research/src/setting/`, which holds every researched fact about a real place,
  period, language or script family that a decision rests on.

## Additions to the steps

- **Step 1 — also read the world before a language, name or word question:** the files grilling's
  fiction mode lists, plus the language's current `language.toml` and the lexicon entries the
  question touches.
- **Step 3 — also record the novel's rows:**

| When a decision… | Record it in |
|---|---|
| chooses a real-world model for a language | an `[[inspiration]]` entry in its `language.toml`: language, period, family, weight, borrows, sources, notes |
| chooses a script's real-world inspiration | `[meta.inspiration]` in its `script/glyphs.toml`: medium, tool, origin, script family, period, borrows (never the glyphs), sources |
| settles a word's flavour, echo or history | the word's lexicon entry: `echo` (the real word, its verified meaning, the source), `stratum`, `entered_after` |
| fixes how a sound is spelt for readers | `[romanisation]` in `phonology.toml`, or a reasoned line in `[romanisation.exceptions]` |
| settles the cause of a beat | `planning/src/causality.md` |
| fixes a fact the prose will rely on | the brief's `## Continuity facts`; `planning/src/continuity.md` only once promoted prose states it |
| fixes a date or the order of events | `planning/src/timeline.md` |
| settles a character's want, need, wound, lie or voice | the character's file in `world/src/characters/`; the arc in `planning/src/arcs/` |
| settles a place, people, culture, era or creature | its file in the story bible |
| chooses a name | `world/src/names-register.md`, through create-name |
| departs deliberately from the real world | the setting note's `## Departures`, and `planning/src/continuity.md` |

- **Step 4 — also gate the language family's model.** The model chosen for a language, a family
  of languages or an antagonist people's tongue is hard to reverse once names are coined, would
  surprise a reader of the files, and settled a real trade-off: it goes to `.claude/MEMORY.md`
  `Decisions` as well, with the options rejected and why.

## Domain rules

- **No inspiration without its research.** An `[[inspiration]]` or `[meta.inspiration]` entry
  names in `sources` the note in `research/src/setting/` that establishes how the model actually
  works. Until `research` has written it, record the decision in `.claude/MEMORY.md`, leave
  `sources` empty, and say that the language's sound cannot be built on it yet.
- **An echo is never recorded from memory.** The real word, its meaning and its source are
  verified first, and a prominent word also gets the false-friend check (unintended meanings in
  the model languages and in English slang).
- **Grilling settles; it does not coin.** It fixes the model, the period, the stratum and the
  point of entry. The form itself is coined by the add-word procedure and a name by create-name,
  each validated by `make lexicon`.
- **The story bible is the source of truth.** A contradiction found while recording is reported
  to the author with both sources, never repaired by overwriting one of them.
- **Never overwrite a story-bible file or a data file** without confirming; add, or supersede
  with a dated note.

## Examples

A model, confirmed by the author and researched, in the language's `language.toml`:

```toml
[[inspiration]]
language = "Old English"
period = "medieval"
family = "Germanic"
weight = "primary"
borrows = ["phonology", "phonotactics", "prosody"]
sources = ["research/src/setting/old-english-c900-sounds.md"]
notes = "c. 900; the hill-trade accent is a second entry; MEMORY Decisions 03/10/2026"
```

A word's history, in its lexicon entry: `stratum = "early-loan"`, `entered_after = 2`, `echo = ""`.

The same choice in `.claude/MEMORY.md` `Decisions`: `- **03/10/2026** — **Fenward's model: Old
English c. 900, with a Celtic accent.** The hill trade in era 2 is the world's defining contact.
Rejected: an Old Norse accent (it voices a sea contact the history does not have) and one model
alone (loans would not sound borrowed).`
