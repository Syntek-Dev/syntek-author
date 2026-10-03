@./CONTEXT.md

# CLAUDE.md — world/src/languages/example-tongue/script/glyphs/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → `world/src/languages/CONTEXT.md` →
`world/src/languages/CLAUDE.md` → `world/src/languages/example-tongue/CONTEXT.md` →
`world/src/languages/example-tongue/CLAUDE.md` →
`world/src/languages/example-tongue/script/CONTEXT.md` →
`world/src/languages/example-tongue/script/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Hold the drawn form of each letter, in a shape both the sample renderer and the font builder
read unchanged.

## How to work here

- **Routing:** skill `design-script`; workflow `world/workflows/08-design-a-script/`.
- **Model:** **Opus** for drawing a letter (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** draw on the em grid (`viewBox="0 0 <advance> 1000"`, baseline y 800, the
  stem y 470 to 530, cuts reaching y 250 above or y 750 below) → trace the stem and its cuts as
  one closed outline, anticlockwise on the page → save it as one `<path fill="currentColor">`
  in `<id>.svg` → set the glyph's `advance` to the viewBox width → run
  `uv run tooling/font.py check example-tongue`.
- **Definition of done:** the font check passes: one filled path, inside the em box, no
  strokes, transforms or CSS.

## Guardrails

- **Fills, not strokes.** A stroke has no outline a font can carry; draw the edge of the shape.
- **Stay inside the em box.** x from 0 to the advance, y from 0 to 1000; the check measures the
  outline itself.
- **Never overwrite an SVG** without confirming with the author.

## Output & naming

- **Hand-written:** `<id>.svg`, matching the letter's `id` in `glyphs.toml`; a positional form as
  `<id>-<position>.svg`.
- **Generated:** nothing here.
