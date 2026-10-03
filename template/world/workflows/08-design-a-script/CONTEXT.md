# CONTEXT.md — world/workflows/08-design-a-script/

The procedure for designing a constructed language's writing system, or extending one: its type,
chosen to fit the language's sounds and its people's history; its real-world inspiration, chosen
from what the culture writes on and with and where its writing came from; its direction, layout
and em grid; a glyph table with stroke order and positional forms; one filled-outline SVG per
glyph; numerals, punctuation and diacritics; the script's own history; the transliteration rules
that every romanised spelling obeys; and a font built from the glyphs.

## Directory Tree

```text
world/workflows/08-design-a-script/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- The book will show the script: on a map, an epigraph, a carved door, a chapter heading.
- The book describes writing (a letter, an inscription, a forbidden book) closely enough that
  its look must be consistent.
- `add-word` reported a missing glyph.

Reach for a **different** procedure when the language's sounds are not settled yet
(`world/workflows/06-build-a-language/`); a script designed before its sounds fights them.

## What it produces, and where

All under the language's script folder, with its pair:

- **`script.md`**: type, direction, the grid of what is drawn, history and design principles.
- **`glyphs.toml`**: `[meta]` (type, direction, the em grid), `[meta.inspiration]` and one
  `[[glyph]]` per written unit.
- **`glyphs/<id>.svg`**: one SVG per glyph, to the conventions in
  `world/docs/reference/writing-systems.md`, with the folder's pair.
- **`transliteration.md`**: the rules in every direction, the single source of truth for
  romanised spellings.
- **`numerals-and-punctuation.md`**: numerals, punctuation and diacritics, or the interim
  rules until they are designed.
- **Research notes** in `research/src/setting/` on the real script family, where one is chosen.
- **A font and a sample** in the build folder, from `make font` and `make script-sample`.

## The failure this procedure exists to prevent

Two sources of truth for spelling. When the transliteration rules live in prose and the glyph
table drifts from them, a romanised name in Chapter 2 and its inscription in Chapter 14 stop
agreeing, and nobody can say which is right. Writing the rule first, then the glyph, and checking
every headword through the table, keeps one answer.

## Cross-references

- `world/docs/reference/writing-systems.md` — script types, inspiration, the em grid, code
  points, the font, and print.
- `world/src/languages/` — the layout every language's script folder follows.
- `world/src/cultures/` and `world/src/history/` — the medium, the tool and the script's origin.
- `tooling/script.py` and `tooling/font.py` — transliteration, rendering, and the font.
