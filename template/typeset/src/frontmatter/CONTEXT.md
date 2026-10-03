# CONTEXT.md — typeset/src/frontmatter/

The pages before the first chapter, each a short `.tex` file that `typeset/src/book.tex` brings in
with `\houseinput{frontmatter/<name>}`. The half-title and title pages come from the house class
(`\housetitlepage`) and the contents from `\tableofcontents`, so this folder holds only what is
particular to this book. The template ships only this pair; the files are written with the author.

## Directory Tree

```text
typeset/src/frontmatter/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules
├── copyright.tex         ← the title verso: rights, edition, ISBN, permissions (when written)
└── dedication.tex        ← the dedication, if the author wants one (when written)
```

## What's here

- Nothing yet beyond this pair. `book.tex` already names `copyright` and `dedication`; until a
  file exists, the print leaves it out and warns. Add other pages (a foreword, a map, an
  epigraph for the whole book) by writing the file and adding its `\houseinput` line.
- **Every word here is supplied by the author or by the publisher**: the copyright line, the ISBN,
  the permissions credits for quoted works, the dedication. None is invented.

## Cross-references

- `typeset/src/book.tex` — the order the front matter prints in.
- `typeset/docs/reference/the-house-class.md` — the class macros these pages may use.
- `.claude/rules/syntek-author/03-authorship.md` — never fabricating, which covers an ISBN too.
