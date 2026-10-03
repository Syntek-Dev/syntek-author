@./CONTEXT.md

# CLAUDE.md — world/src/languages/example-tongue/script/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → `world/src/languages/CONTEXT.md` →
`world/src/languages/CLAUDE.md` → `world/src/languages/example-tongue/CONTEXT.md` →
`world/src/languages/example-tongue/CLAUDE.md` → this folder's `CONTEXT.md` (imported above)
→ this file.

## Purpose (one line)

Show a script recorded as data and filled-outline SVGs, with transliteration rules every spelling
obeys and a font built from the same files.

## How to work here

- **Routing:** skill `design-script`; workflow `world/workflows/08-design-a-script/`; guide
  `world/docs/reference/writing-systems.md`.
- **Model:** **Opus** for any letter or rule; the mechanical tier for `make script-sample` and
  `make font` (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (adding a letter):** write its rule in `transliteration.md` → add its
  `[[glyph]]` entry, with its `advance` → draw its SVG as one filled outline on the em grid →
  run `python3 tooling/script.py check example-tongue` and `uv run tooling/font.py check
  example-tongue` → run `make script-sample` and `make font`, and check every headword still
  transliterates.
- **Definition of done:** both checks pass, every headword in the language's `lexicon.toml`
  transliterates through `glyphs.toml`, and every `svg` and `forms` path names a file that exists.

## Guardrails

- **Rules first, glyphs second.** A letter added without its rule makes the table disagree with
  `transliteration.md`, and the table silently wins.
- **Filled outlines only.** One `<path>` per file, `fill="currentColor"`, no strokes, no
  transforms, no CSS classes; a stroke cannot become a font outline.
- **Keep the order of `glyphs.toml`, or pin the code points first.** Unpinned code points follow
  file order; `uv run tooling/font.py assign example-tongue` prints the lines that pin them.
- **Never overwrite a glyph or its SVG** without confirming with the author.

## Output & naming

- **Hand-written:** `glyphs.toml`, the SVGs (named for the glyph `id`, a form as
  `<id>-<position>.svg`), and the Markdown files.
- **Generated (never hand-edit):** rendered samples and the font, in the build folder.
