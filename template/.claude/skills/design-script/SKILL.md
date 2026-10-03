---
name: design-script
description: >-
  Design or extend the native writing system of a constructed language: its real-world
  inspiration chosen as a separate question from the language's sound (the medium, the tool, the
  script's origin, and two or three real script families with their periods, from the culture's
  materials and history, with a recommendation), then the script type, direction and positional
  forms, the transliteration rules in both directions, the glyph table in glyphs.toml, one
  filled-outline SVG per glyph on the declared em grid, numerals and punctuation, and the
  script's history; then make font and a rendered sample. Takes a real family's structure and
  stroke logic, never its glyphs. Use when the author says 'design a script for the river
  people', 'what would they write on?', 'draw the glyph for "ka"', 'add the missing glyphs',
  'make the font', or 'how is this word written natively?'. Not the sounds or the spelling in
  prose (`build-language`), not a new word (`add-word`), not audio (`pronounce`).
---

# Skill: Design a script (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A script is a language's history made visible: what it was first written on, with what, by whom and
for what. This skill designs one from the world outward: the phonology decides what each glyph must
write, the culture's materials and history suggest a real script family to learn from, and the
transliteration rules become the single source of truth for every native spelling. Glyphs are drawn
as filled outlines the font builder can compile, so a script can reach the printed page. The
script's inspiration is a separate decision from the language's sound model, asked on its own; the
author chooses at every fork.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `world/workflows/08-design-a-script/` — this skill is that procedure in skill form; its steps and
  these are numbered alike.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `world/docs/reference/writing-systems.md` — script types, real-world inspiration, the em grid,
  transliteration, code points and the font.
- `world/docs/reference/building-a-language.md` — the house conlang method the script serves.
- `typeset/docs/reference/conlang-in-print.md` — how native script reaches the printed book.
- `research/workflows/01-ingest-a-source/` — how a real script family's structure is researched and
  cited.
- `standards/risk/FICTION.md` — rule 7: a real language or script lends its feel, never its words or
  its sacred terms.

## How to design a script

1. **Fix the script's job in the book.** Ask the author where it appears (maps, headings,
   inscriptions, chapter openers, or only described), who in the story writes it, and whether it
   will be printed. The answer sets how many glyphs this pass needs. For an extension, name the
   missing units `add-word` or `make lexicon` reported. *Complete when:* the job and this pass's
   glyph count are agreed.

2. **Read the language and its people's world.** Read the language's `language.toml`,
   `phonology.toml` and `lexicon.toml`; the culture's file in `world/src/cultures/` (what they write
   on and with, who writes, what for); the people's file in `world/src/peoples/`; and the events in
   `world/src/history/` that brought them into contact with other writers (invented at home,
   borrowed from a neighbour, or adapted, and when). If the phonology is still changing, stop and
   say so. If the world files cannot say what the script was first written on, or where it came
   from, say what is missing rather than guess. *Complete when:* the medium, the tool, the writers
   and the origin are each read from a named file or listed as missing.

3. **Choose the script type.** Offer two or three types (alphabet, abjad, abugida, syllabary,
   logographic, featural), each with its fit to the syllable shapes and the people's history, and
   recommend one with its reason. The author chooses. *Complete when:* the author has chosen the
   type.

4. **Choose the script's real-world inspiration, as its own question.** Recommended, not mandatory.
   From the medium and tool (a chisel or knife cuts short straight lines, a stylus in clay leaves
   wedges, a brush or pen gives curves and joins) and the origin (native, borrowed or adapted; a
   borrowed script fits its new language awkwardly, and the awkward fits become authentic spelling
   quirks), offer two or three real script families, each with its period, the reasoning tied to the
   named world files, what readers will associate with it, and its risks (a living people's sacred
   script, a family readers tie to one real culture). The family may be unrelated to the sound
   model. Recommend one with its reason, or record the author's choice of none. Take structure and
   stroke logic, never glyphs. *Complete when:* the author has chosen a family, or none.

5. **Research and record the inspiration.** With the `research` skill, find out how the chosen
   family works (its structure, direction, stroke logic and layout) into cited notes in
   `research/src/setting/`. Record `[meta.inspiration]` in `glyphs.toml`: `medium`, `tool`, `origin`
   (`native`, `borrowed:<culture>` or `adapted:<culture>`), `script_family`, `period`, `borrows` and
   `sources`. *Complete when:* `[meta.inspiration]` is recorded and every source is a real note, or
   the choice of none is recorded.

6. **Fix direction, layout, forms and the em grid.** Direction (`ltr`, `rtl` or `ttb`), how lines
   and words are laid out, and whether any glyph changes shape by position (isolated, initial,
   medial, final; the font carries them as contextual alternates). Record `type`, `direction` and
   the em grid (`units_per_em = 1000`, `ascender`, `descender`, `default_advance`) in `[meta]`. For
   `rtl` or `ttb`, tell the author now that print needs proving: Unicode treats Private Use Area
   characters as left-to-right, so typeset text will not run the right way on its own.
   *Complete when:* `[meta]` holds the type, the direction and the grid, and any print caveat has
   been given.

7. **Write the transliteration rules.** In the script folder's `transliteration.md`: IPA to
   romanised, romanised to IPA, romanised to native (greedy longest match over the glyphs'
   `romanisation`), and native to romanised. Work every headword through the rules before any glyph
   exists; an awkward fit from a borrowed script is recorded as a quirk, not smoothed away. These
   rules are the single source of truth for native spellings. *Complete when:* every headword
   transliterates on paper, or its missing unit is listed.

8. **Build the glyph table.** One `[[glyph]]` per written unit, every key present: `id`,
   `romanisation`, `ipa`, `name`, `description`, `strokes` (the stroke order in words), `svg`,
   `advance` (0 for the default), `forms`, and `codepoint` (empty unless pinned). *Complete when:*
   every unit this pass needs has a complete entry.

9. **Draw the glyphs.** Check first that no SVG will be overwritten. Then one SVG per glyph in the
   script's glyphs folder, named for its `id`: a **filled outline**, never a stroke, as one path
   with `fill="currentColor"` written on it and no stroke attributes, transforms, CSS (a `<style>`
   element or a class: export with inline attributes), text, images or scripts. Use the em grid
   from `[meta]`: the viewBox is `0 0 <advance> 1000`, y grows downwards, and the baseline sits at
   y equal to `ascender`; nothing falls outside the em box. Draw the pen's width as the
   shape's width, so the outline still reads as made by the people's medium and tool. Validate with
   `uv run tooling/font.py check <lang>`. *Complete when:* every SVG passes the check.

10. **Design numerals, punctuation and diacritics.** The base of counting, digits or
    letter-numerals, word divider, sentence end, quotation and any diacritic; or, where the book
    needs none yet, the interim rules and the decisions still to make, in
    `numerals-and-punctuation.md`. *Complete when:* each item is designed or recorded as a decision
    still to make.

11. **Record the script's history and principles.** In `script.md`: the type and direction, the grid
    of what is drawn, the inspiration and what it lends, how the shapes descend from what the people
    first wrote on and with, where the script came from (tied to the history and to the roots the
    glyphs grew from), the design principles, and any ceremonial hand. *Complete when:* `script.md`
    covers each item.

12. **Build the font and a sample.** Run `make font LANG=<slug>` (it needs `uv`) and
    `make script-sample LANG=<slug> TEXT="…"`, and let the author read the sample. If the author
    wants stable code points (before a book is typeset), print them with
    `uv run tooling/font.py assign <lang>` and pin them in `codepoint`. *Complete when:* the font
    builds and the author has seen the sample.

13. **Check every headword.** Run `python3 tooling/script.py check <lang>` and
    `make lexicon LANG=<slug>`, and transliterate each headword with
    `python3 tooling/script.py transliterate <lang> "<headword>"`. List any headword that cannot be
    written, with the units it needs. *Complete when:* the checks pass and every unwritable headword
    is listed.

14. **Hand back.** Report the type, direction and inspiration, the glyphs drawn, the font and sample
    built, the headwords that cannot yet be written and the units they need, any print caveat, and
    the decisions left in `numerals-and-punctuation.md`. *Complete when:* the author has the report.

## Anti-patterns

- **Script before sound.** A script drawn before the phonology settles fights it.
- **Copying a real script's glyphs.** Take structure, direction and stroke logic; the shapes are
  this people's own.
- **Merging the two inspirations.** The sound model and the script's model are separate decisions,
  asked separately.
- **Strokes in the SVG.** The font builder compiles filled outlines only; a stroked path is lost or
  distorted.
- **The wrong grid.** Glyphs off the declared em grid, or outside the em box, sit wrongly in every
  line of print.
- **A spelling the rules cannot produce.** That is an error in the spelling, not a reason to bend
  the rules quietly; change a rule only with the author, then re-check every headword.
- **Drawing glyphs nobody will see.** Draw what the book shows; the table grows as words need it.
- **A sacred script as ornament.** Flag it under rule 7 of the fiction risk standard and offer
  another model.

## Cross-references

- `world/src/languages/` — each language's `script/` folder: `glyphs.toml`, the SVGs,
  `transliteration.md`, `script.md` and `numerals-and-punctuation.md`.
- `world/docs/reference/writing-systems.md` — the craft and the conventions.
- `research/src/setting/` — the cited notes on the inspiring script family.
- `.claude/skills/build-language/SKILL.md` — the phonology and spelling the script writes.
- `.claude/skills/add-word/SKILL.md` — reports the units a new word cannot yet be written with.
- `.claude/skills/research/SKILL.md` — the cited notes on a real script family.
