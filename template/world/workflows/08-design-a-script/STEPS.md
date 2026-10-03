---
workflow: 08-design-a-script
phase: produce
skills: [design-script, research]
model: opus
---

# STEPS.md — design a script

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for designing a writing system, or extending one. Each step names the
skill and guide it uses. **Run in order** (the world before the type, the type and inspiration
before glyphs, rules before drawings) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `design-script` skill is this procedure in skill form.

## 1. Fix the script's job in the book

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Ask the author where the script appears (maps, headings, inscriptions, described only), who in
the story writes it, and whether it will be printed. The answer sets how many glyphs this pass
needs. For an extension, name the missing units `add-word` reported. _Substantive._

## 2. Read the language and its people's world

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Read the language's `language.toml`, `phonology.toml` and `lexicon.toml`; the culture's
materials and tools (what they write on, and with what); and the events in `world/src/history/`
that brought them into contact with other writers. If the phonology is still changing, stop and
say so. If the world files cannot say what the script was first written on, or where it came
from, say what is missing rather than guess. _Substantive._

## 3. Choose the script type

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Offer two or three types (alphabet, abjad, abugida, syllabary, logographic, featural), each with
its fit to the syllable shapes and the people's history, and recommend one with its reason. The
author chooses. _Substantive._

## 4. Choose the script's real-world inspiration

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

A separate question from the sound model, asked on its own. Recommended, not mandatory: from
the medium, the tool and the script's origin (native, borrowed or adapted), offer two or three
real script families with period and reasoning, and recommend one; or record the author's
choice of none. Take structure and stroke logic, never glyphs. _Substantive._

## 5. Research and record the inspiration

> **Skill:** `research` · **Guide:** `world/docs/reference/writing-systems.md`

Research how the chosen family works (its structure, direction, stroke logic and layout) into
notes in `research/src/setting/`, and record `[meta.inspiration]` in `glyphs.toml`: medium,
tool, origin, script family, period, what it borrows, sources. _Substantive._

## 6. Fix direction, layout, forms and the em grid

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Direction (`ltr`, `rtl` or `ttb`), how lines and words are laid out, and whether any glyph
changes shape by position. Record `type`, `direction` and the em grid (`units_per_em`,
`ascender`, `descender`, `default_advance`) in `[meta]`. For `rtl` or `ttb`, tell the author
now that print needs proving, as the guide explains. _Substantive._

## 7. Write the transliteration rules

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

In `transliteration.md`: IPA to romanised, romanised to IPA, romanised to native (greedy longest
match over the glyphs' romanisations), and native to romanised. Work every headword through the
rules before any glyph exists; an awkward fit from a borrowed script is recorded as a quirk, not
smoothed away. _Substantive._

## 8. Build the glyph table

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

One `[[glyph]]` per written unit, every key present: `id`, `romanisation`, `ipa`, `name`,
`description`, `strokes` (stroke order in words), `svg`, `advance`, `forms`, and `codepoint`
(empty unless pinned). _Substantive._

## 9. Draw the glyphs

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Check first that no SVG will be overwritten. Then one SVG per glyph in the script's glyphs
folder, named for its `id`: one filled outline in `currentColor` on the declared em grid, never
strokes, nothing outside the em box, shaped the way the medium and tool would make it. Validate
with `uv run tooling/font.py check <lang>`. _Substantive._

## 10. Design numerals, punctuation and diacritics

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Base of counting, digits or letter-numerals, word divider, sentence end, quotation, and any
diacritic; or, where the book needs none yet, the interim rules and the decisions still to make,
in `numerals-and-punctuation.md`. _Substantive._

## 11. Record the script's history and principles

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

In `script.md`: the type and direction, the grid of what is drawn, the inspiration, how the
shapes descend from what the people first wrote on and with, where the script came from (tied to
the history and to the roots), the design principles, and any ceremonial hand. _Substantive._

## 12. Build the font and a sample

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Run `make font LANG=<slug>` (it needs `uv`) and `make script-sample LANG=<slug> TEXT="…"`. If the
author wants stable code points, print them with `uv run tooling/font.py assign <lang>` and pin
them in `codepoint`. _Mechanical._

## 13. Check every headword

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Run `python3 tooling/script.py check <lang>` and `make lexicon LANG=<slug>`, and transliterate
each headword with `python3 tooling/script.py transliterate <lang> "<headword>"`. List any
headword that cannot be written, with the units it needs. _Mechanical._

## 14. Hand back

> **Skill:** `design-script` · **Guide:** `world/docs/reference/writing-systems.md`

Report the type, direction and inspiration, the glyphs drawn, the font and sample built, the
headwords that cannot yet be written and the units they need, any print caveat, and the
decisions left in `numerals-and-punctuation.md`. _Substantive._
