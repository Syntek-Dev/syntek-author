# CONTEXT.md — world/src/languages/example-tongue/script/

The Example Tongue writing system: an alphabet written left to right, in which every letter is a
run of an unbroken stem with cuts above, below or across it, after the structure of ogham. Sixteen
letters and one positional form are drawn, enough to write every headword. The glyph table is data
the tooling reads; the Markdown files explain the design, its history and the transliteration
rules every romanised spelling obeys.

## Directory Tree

```text
world/src/languages/example-tongue/script/
├── CONTEXT.md                      ← this file
├── CLAUDE.md                       ← operating rules
├── script.md                       ← type, direction, families, grid, inspiration, history, font
├── glyphs.toml                     ← [meta] em grid + [meta.inspiration] + one [[glyph]] per letter
├── glyphs/                         ← one filled-outline SVG per letter and form (+ pair)
├── transliteration.md              ← IPA, romanised and native, in every direction
└── numerals-and-punctuation.md     ← interim rules; nothing designed yet
```

## What's here

- `glyphs.toml` — **the executable form of the transliteration rules**: `tooling/script.py`
  writes romanised text natively by greedy longest match over each letter's `romanisation`, and
  `tooling/font.py` builds the font from the same table.
- `world/src/languages/example-tongue/script/glyphs/` — the drawn letters, one filled outline
  each on the em grid in `[meta]`.
- `script.md` — the families of cuts, the grid, the inspiration and why the shapes are what
  they are.
- `transliteration.md` — the rules in words, with every headword worked through.
- `numerals-and-punctuation.md` — the decisions still to make.

## Cross-references

- `research/src/setting/example-model-ogham.md` — the cited facts behind the structure.
- `world/docs/reference/writing-systems.md` — choosing a script, the em grid and SVG conventions.
- `world/workflows/08-design-a-script/` — the procedure for designing a script.
- `tooling/script.py` and `tooling/font.py` — transliterate, render, check and build the font.
