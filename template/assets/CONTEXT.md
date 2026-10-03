# CONTEXT.md — assets/

The project's binary store: images and other non-text files the work uses, such as a cover,
figures, maps, diagrams and logos. Nothing here is prose and nothing here is generated; anything
a build produces goes to `build/`, and anything the author writes goes in a layer's `src/`.

## Directory Tree

```text
assets/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules
└── <kind>/             ← one folder per kind of asset (cover, figures, maps, logos), each with its own pair
```

## What's here

- **Kind folders**, created as assets arrive. Each new folder gets its own `CONTEXT.md` and
  `CLAUDE.md` pair, and nothing sits directly in `assets/` itself.
- **Source files are kept.** Where an image has an editable source (an SVG, a layered file),
  the source sits beside the export, so the image can be changed without being redrawn.
- **Very large files stay out of Git.** Audio masters, video and high-resolution scans belong in
  external storage, with a note here saying where; generated audio and renders are git-ignored.
- The folder is empty apart from this pair until the first asset arrives.

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — where `assets/` sits among the layers.
- `.claude/rules/syntek-author/08-naming-and-memory.md` — naming conventions.
