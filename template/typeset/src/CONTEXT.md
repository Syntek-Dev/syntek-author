# CONTEXT.md — typeset/src/

The book as it will be printed. The words are not written here: every word of a chapter comes
from its Markdown in `manuscript/src/` through Pandoc. What is made here is everything around the
words: the page-design record, the master file that assembles the book, the front and back
matter, and the styled chapters. `make print` sets `book.tex` into `build/typeset/book.pdf`.

## Directory Tree

```text
typeset/src/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules
├── page-design.md            ← the author's page-design choices, each flagged until chosen
├── book.tex                  ← the master file: class options, front matter, chapters, back matter
├── frontmatter/              ← title verso, dedication and the like, as short .tex files
├── backmatter/               ← acknowledgements, about the author, glossary, as short .tex files
└── units/                    ← one styled NN-kebab-title.tex per chapter
    └── .base/                ← Pandoc's base for each chapter; README.md, no pair, never edited
```

## What's here

- `page-design.md` — **the record of the author's choices**: trim, typefaces, chapter opener,
  scene-break mark, footnote style, drop capitals. Seeded with an `AUTHOR TO CONFIRM` flag on each,
  so `make flags` lists every choice still open. Never overwritten by `copier update`.
- `book.tex` — the master file. Its class options mirror `page-design.md`; it `\houseinput`s the
  front matter, then each chapter's styled file in plan order, then the back matter. A file not
  yet written is left out of the print with a warning, so the book can be proofed as it grows.
  Never overwritten by `copier update`.
- `typeset/src/frontmatter/` and `typeset/src/backmatter/` — short `.tex` files for the pages
  around the text. Their words are the author's, supplied by the author; the AI sets them and
  never composes them.
- `typeset/src/units/` — the styled chapters, each a copy of its base with house macros added,
  and `typeset/src/units/.base/` beside them, written only by `make tex`. Commit a base and its
  styled file together.

## Cross-references

- `typeset/docs/reference/the-typesetting-pipeline.md` — how a chapter moves through this folder.
- `typeset/docs/reference/the-house-class.md` — every class option and macro.
- `typeset/workflows/` — where every task in this folder starts.
- `planning/src/outline.md` — the running order `book.tex` follows.
