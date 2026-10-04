# CONTEXT.md — typeset/workflows/01-design-the-page/

The procedure for settling how the printed book looks: trim size, margins, typefaces, chapter
opener, scene-break mark, footnote style and drop capitals, plus any choice this kind of book
adds. The AI explains each option, recommends one with its reason, and records only what the
author chooses, in `typeset/src/page-design.md` and the class options of `typeset/src/book.tex`
together. A sample chapter is printed so the author decides by looking at a page, not a list.

## Directory Tree

```text
typeset/workflows/01-design-the-page/
├── CHECKLIST.md             ← verification checklist before marking complete
├── CLAUDE.md                ← operating rules for this workflow
├── CONTEXT.md               ← this file (when to use, what it produces, the one thing that matters)
└── STEPS.md                 ← ordered steps to execute
```

## When to use this

- Before the first chapter is typeset for print, or when `make flags` still lists page-design
  choices as open.
- The author asks how the book will look, wants a different typeface, or has the printer's
  specification.
- A publisher or printer changes a requirement (a new trim, minimum margins).

Reach for a **different** procedure when: the page design is settled and a chapter needs setting
(`typeset/workflows/02-typeset-a-chapter/`); or the question is about the words, not the page
(the section procedures in `manuscript/workflows/`).

## What it produces, and where

- **`typeset/src/page-design.md`** with each settled choice recorded (value, reason, date) and its
  flag removed, and a row in its decisions table.
- **`typeset/src/book.tex`** with the matching class options set.
- **A sample print** in `build/typeset/book.pdf`, read with the author.
- **A dated line** in `.claude/MEMORY.md` Decisions (mapped in `00-project.md`
  `## Memory headings`) for any choice that is costly to reverse (the trim above all, because it
  sets the page count and the cover).

## The one thing this procedure exists to protect

**The page is the author's.** A recommendation is offered with its reason and the author decides;
nothing is recorded as chosen because the AI preferred it, and no choice is made silently by
leaving a default in place.

## Cross-references

- `typeset/docs/reference/the-house-class.md` — every option, with its values and default.
- `typeset/src/page-design.md` — the record this procedure fills in.
- `.claude/rules/syntek-author/03-authorship.md` — who decides what.
