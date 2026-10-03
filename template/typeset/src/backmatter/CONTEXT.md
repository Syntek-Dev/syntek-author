# CONTEXT.md — typeset/src/backmatter/

The pages after the last chapter, each a short `.tex` file that `typeset/src/book.tex` brings in
with `\houseinput{backmatter/<name>}`. Where the project keeps references, the reference list is
not written here: `make print` generates it and `\housereferences` sets it. The template ships
only this pair; the files are written with the author.

## Directory Tree

```text
typeset/src/backmatter/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules
├── acknowledgements.tex      ← the author's thanks (when written)
└── about-the-author.tex      ← the author's biography, as the author supplies it (when written)
```

## What's here

- Nothing yet beyond this pair. `book.tex` already names `acknowledgements` and
  `about-the-author`; until a file exists, the print leaves it out and warns. Other pages (notes,
  a glossary, a reading list) are added by writing the file and its `\houseinput` line.
- **Every word here is the author's.** Acknowledgements name real people; a biography states
  facts about the author. Both come from the author, verbatim.

## Cross-references

- `typeset/src/book.tex` — the order the back matter prints in.
- `typeset/docs/reference/the-house-class.md` — `\housereferences` and the other class macros.
- `.claude/rules/syntek-author/03-authorship.md` — never fabricating.
