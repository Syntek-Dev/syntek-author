---
type: guide
skills: [design-script]
model: opus
---

# Writing systems — choosing, drawing and building a script

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A script is a language's history made visible: what its people first wrote on,
with what tool, and whether they invented it or took it from a neighbour. This guide covers
choosing one, drawing its glyphs, building its font and setting it in print.

## Type, from the sounds and the culture

| Type | One glyph writes | Fits a language that… |
|---|---|---|
| alphabet | one consonant or vowel | has many syllable shapes, or borrowed its script |
| abjad | one consonant; vowels optional | has predictable vowels, or roots carried by consonants |
| abugida | a consonant with an inherent vowel; marks change it | is mostly consonant plus vowel, with few clusters |
| syllabary | one whole syllable | has few syllable types and a small inventory |
| logographic | one word or morpheme | writes for record and ritual more than for speed |
| featural | a sound, its shape built from how it is made | was designed deliberately, by a scholar or a court |

## Real-world inspiration, from the culture's medium

- **Recommended by default, never mandatory.** Read the culture's materials and tools and the
  history's contact events first: medium and tool shape the strokes (a chisel or knife cuts
  short straight lines, clay takes wedges, ink gives curves and joins).
- **Origin matters:** `native` (invented by the people), `borrowed:<culture>` or
  `adapted:<culture>`. A borrowed script fits its new language badly, and the awkward fits
  (one sign for two sounds, a letter kept for a sound now lost) are authentic spelling quirks.
- **Offer two or three real script families** with period and reasoning, recommend one, and
  research how it works with `research`, citing notes in `research/src/setting/`.
- **Take structure, never glyphs:** type, direction, stroke logic and layout may be borrowed; no
  glyph is traced or copied. The choice is independent of the sound model.
- **Record it in `[meta.inspiration]`** in `glyphs.toml`: `medium`, `tool`, `origin`,
  `script_family`, `period`, `borrows`, `sources`.

## Glyphs: filled outlines on the em grid

- `[meta]` declares the grid: `units_per_em` (1000), `ascender` (800), `descender` (-200) and
  `default_advance`. Each SVG's viewBox is `0 0 <advance> 1000`, y grows downwards, and the
  baseline sits at y 800.
- **One filled path per glyph**, `fill="currentColor"`: never strokes, transforms, CSS, text,
  images or scripts, and nothing outside the em box. Stroke order lives in words, in `strokes`.
- `forms` (isolated, initial, medial, final) become contextual alternates in the font;
  `uv run tooling/font.py check <lang>` validates every SVG.

## Transliteration, code points and the font

- `transliteration.md` states the rules both ways, and `glyphs.toml` is their executable form:
  greedy longest match over each glyph's `romanisation`. A spelling the rules cannot produce is
  wrong in the spelling, not in the rules.
- Each glyph takes a Private Use Area code point (U+E000 to U+F8FF), by the ConScript Unicode
  Registry's convention (check its allocations first). An explicit `codepoint` wins; the rest
  follow the highest, in file order. `uv run tooling/font.py assign <lang>` prints pins.
- `make font LANG=<slug>` builds the font into the build folder (it needs `uv`);
  `make script-sample LANG=<slug> TEXT="…"` renders a sample, honouring direction.

## Right-to-left and vertical scripts in print

Unicode treats Private Use Area characters as left-to-right, so an `rtl` or `ttb` script set from
the font will not run the right way on its own; rendered samples honour `direction`, typeset text
does not. Prove it in print first (`typeset/docs/reference/conlang-in-print.md`), or use images.

## How we apply it here

- Design the script after the phonology is settled; a script built first fights the sounds.
- Rules before glyphs: a unit's transliteration rule, then its `[[glyph]]`, then its SVG. Draw
  only what the book will show; the table grows when `add-word` reports a gap.

## Who implements it

- **Skill:** `design-script`. **Workflow:** `world/workflows/08-design-a-script/`.

## Governing standard

`standards/method/FICTION.md` owns the story bible as the source of truth; `tooling/script.py`
and `tooling/font.py` execute the glyph table. This guide owns the design choices.
