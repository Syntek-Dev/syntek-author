# FICTION.md — research, fiction mode

Where a novel's research goes, what counts as a primary source for it, and how a real language
or script that inspires an invented one is researched.

## Paths and unit

- **Setting notes:** `research/src/setting/<subject>.md` for the real world the novel borrows (a
  place, a period, a trade, a procedure) and for every real language, period or script family
  that inspires an invented one; the format is in `research/src/setting/CONTEXT.md`, with
  `## Departures` for each deliberate change.
- **Quotations, epigraphs and lyrics:** a row in `research/src/permissions.md`.
- **Question-led notes:** `research/src/notes/`; **reading notes:** `research/src/sources/`.
- **Serves:** chapter slugs from `planning/src/units/` and, for language research, the language's
  `language.toml` `sources` list or the `script/glyphs.toml` `[meta.inspiration]` `sources` list.

## Additions to the steps

- **Step 2 — also route by the routing table's fiction rows:** real-world texture goes to
  `research/src/setting/`; a quoted passage to `research/src/permissions.md`; a fact the prose
  will state plainly also to `fact-check`.
- **Step 3 — also, for a real language that models an invented one,** name the language **and
  the period** (Old English c. 900 is not Middle English c. 1350), and what the question is
  about: its sounds, syllable shapes, stress and rhythm first; its grammar type or naming habits
  only when the model borrows them.
- **Step 4 — also, for a real language,** the primary sources are scholarly reference grammars
  and historical phonologies of that language at that period, and its standard historical
  dictionary; for a word's meaning (an `echo`), the dictionary entry itself, with its sense and
  date. For a script family: palaeographic and epigraphic references on that script and period,
  and how its medium and tool shaped its strokes.
- **Step 6 — also,** a language note records what the model is borrowed **for** (sound, rhythm,
  naming) and the false friends a prominent invented word must avoid in the model languages and
  in English slang.

## Domain rules

- **What counts as primary:** period records and archives; maps and gazetteers of the period;
  manuals, ledgers and trade records; first-hand accounts (named by role unless the giver agrees
  to be named); for a community the author does not share, that community's own published
  voices (`standards/risk/FICTION.md` Section 4). Another novel's version of the world is never a
  source.
- **Borrow structure and flavour, never vocabulary.** A real word appears in the lexicon only as
  a deliberate `echo`, recorded with its verified meaning and its source.
- **Respect living languages.** The note flags any proposal to lift a minority, Indigenous or
  sacred language's words or sacred terms, or to caricature it, for the author and
  `standards/risk/FICTION.md`; taking such a language's feel is acceptable.
- **Every departure is logged** in the note's `## Departures` and in `planning/src/continuity.md`,
  so it reads as a choice, not an error.

## Examples

```markdown
---
subject: "Old English c. 900: sounds, syllables and stress"
period: "c. 850 to 950"
serves: []               # the language's language.toml sources list cites this note
checked: DD/MM/YYYY
---

# Old English c. 900: sounds, syllables and stress

## What is true
- <each claim on its own line, ending in its reference grammar and page>
## Sources
## Departures
- The invented language takes the stress pattern, not the vowel system.
## History
```
