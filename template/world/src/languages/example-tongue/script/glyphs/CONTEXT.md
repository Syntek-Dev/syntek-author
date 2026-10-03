# CONTEXT.md — world/src/languages/example-tongue/script/glyphs/

One SVG per letter in `glyphs.toml`, named for the letter's `id`, plus one for the positional form
of o. Each is a single filled outline in `currentColor` on the em grid in `[meta]`: a viewBox of
the letter's advance by 1,000 units, the baseline at y 800. Nothing but SVGs and this pair
belongs here.

## Directory Tree

```text
world/src/languages/example-tongue/script/glyphs/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
├── o.svg · a.svg · e.svg · i.svg · u.svg      ← vowels: 1 to 5 notches across the stem
├── k.svg · p.svg · qu.svg                     ← voiceless stops: upright cuts above
├── b.svg · d.svg · g.svg                      ← voiced stops: upright cuts below
├── h.svg · f.svg                              ← fricatives: slanting cuts above
├── r.svg · l.svg · m.svg                      ← nasals and liquids: slanting cuts below
└── o-final.svg                                ← o at the end of a word: the stem closed by a bar
```

## What's here

- Sixteen letters and one form. **Each file is one `<path>` tracing the stem and its cuts as a
  single closed outline**, so it composes into samples and compiles into the font unchanged.

## Cross-references

- `world/docs/reference/writing-systems.md` — the SVG conventions: em grid, filled outlines.
- `world/src/languages/example-tongue/script/script.md` — the grid measurements these follow.
- `tooling/font.py` — its check subcommand validates these files, and its build subcommand
  compiles them into the font.
