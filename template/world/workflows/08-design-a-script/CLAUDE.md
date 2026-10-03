@./CONTEXT.md

# CLAUDE.md — world/workflows/08-design-a-script/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Give a language a writing system that fits its sounds and its history, recorded so that the
tooling can write and draw every word in it.

## How to work here

- **Routing:** skill `design-script`, with `research` for the inspiration; guide
  `world/docs/reference/writing-systems.md`; builds and checks `make font`, `make script-sample`
  and `make lexicon` (each with `LANG=<slug>`), `uv run tooling/font.py check <lang>` and
  `python3 tooling/script.py transliterate <lang> "text"`.
- **Model:** **Opus** for every design decision and every glyph drawn; the mechanical tier for
  creating files and running the checks (`.claude/rules/syntek-author/05-model-allocation.md`).
  The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the script's
  job → read the language and the world → type → inspiration → research and record it →
  direction, forms and em grid → transliteration rules → glyph table → SVGs → numerals and
  punctuation → history and principles → font and sample → check → hand back.
- **Definition of done:** every headword in the language's lexicon transliterates through the
  glyph table (or the missing units are listed and agreed as not yet needed); every `svg` path
  names a filled-outline file that passes `font.py check`; the font builds and
  `make script-sample` renders.

## Guardrails

- **Sounds first, script second.** If the phonology is still moving, stop and say so.
- **Inspiration is its own question.** Ask it apart from the sound model, recommend from the
  culture's medium, tool and the script's origin, and borrow structure and stroke logic, never
  a real script's glyphs.
- **Rules before glyphs.** Write the transliteration rule for a unit, then its `[[glyph]]`
  entry, then its SVG. A glyph without a rule makes the table the hidden source of truth.
- **Draw only what the book will show.** The table can grow when `add-word` reports a gap.
- **SVG conventions are not optional.** One filled outline in `currentColor` on the declared em
  grid, never strokes; anything else breaks the font build and the composer.
- **Code points follow the ConScript convention.** Leave `codepoint` empty unless the author
  wants pins; `font.py assign` prints them, after the registry's allocations are checked.
- **Never overwrite a glyph, an SVG or a rule** without confirming with the author.

## Output & naming

- **Produces:** the language's script folder: pair, `script.md`, `glyphs.toml`,
  `glyphs/<id>.svg` (with the folder's pair), `transliteration.md`,
  `numerals-and-punctuation.md`.
- **Generated (never hand-edit):** the font and rendered samples in the build folder.
- **Does not touch:** `phonology.toml`, the lexicon's words, or promoted prose. A romanised
  spelling the rules cannot produce is reported, not silently respelled.
